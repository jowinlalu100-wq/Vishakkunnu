package com.app;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/checkAvailability")
public class CheckAvailabilityServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        
        // We will send back JSON data
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        List<String> bookedTables = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT table_id FROM bookings WHERE booking_date = ? AND booking_time = ? AND status != 'Cancelled'")) {
            
            ps.setString(1, date);
            ps.setString(2, time);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                bookedTables.add("\"" + rs.getString("table_id") + "\"");
            }
            
            // Manually format the list into a JSON array: ["T1", "T2"]
            out.print("[" + String.join(",", bookedTables) + "]");
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]"); // Return empty array on error so UI doesn't break
        }
    }
}