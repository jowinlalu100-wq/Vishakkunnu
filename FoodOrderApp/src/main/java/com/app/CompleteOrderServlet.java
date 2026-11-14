package com.app;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/completeOrder")
public class CompleteOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Get the logged-in user
        HttpSession session = request.getSession();
        String currentUser = (String) session.getAttribute("loggedInUser");
        
        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2. Catch all the data from the payment form
        String cartData = request.getParameter("cartData");
        String tableId = request.getParameter("tableId");
        String totalBill = request.getParameter("totalBill");
        String bookingDate = request.getParameter("bookingDate");
        String bookingTime = request.getParameter("bookingTime");
        
        // Handle cases where no table was selected (Takeaway only)
        if (tableId == null || tableId.trim().isEmpty()) {
            tableId = "None";
            // Set a dummy date/time for takeaway orders so MySQL doesn't crash on NULL
            if (bookingDate == null || bookingDate.isEmpty()) bookingDate = "2099-01-01";
            if (bookingTime == null || bookingTime.isEmpty()) bookingTime = "00:00:00";
        } else {
            // Add seconds to time to match MySQL TIME format
            if (bookingTime != null && bookingTime.length() == 5) {
                bookingTime += ":00";
            }
        }

        // 3. Save to MySQL Database (Notice 'guests' is explicitly added here!)
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO bookings (fullname, table_id, booking_date, booking_time, guests, total_bill, order_details, status) VALUES (?, ?, ?, ?, ?, ?, ?, 'Confirmed')")) {
            
            ps.setString(1, currentUser);
            ps.setString(2, tableId);
            ps.setString(3, bookingDate);
            ps.setString(4, bookingTime);
            ps.setInt(5, 0); // We MUST pass '0' for guests so MySQL doesn't block the save!
            ps.setString(6, totalBill);
            ps.setString(7, cartData); 
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                // 4. SUCCESS! Forward the request to success.jsp
                request.getRequestDispatcher("success.jsp").forward(request, response);
            } else {
                response.sendRedirect("order.jsp?error=db_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("order.jsp?error=exception");
        }
    }
}