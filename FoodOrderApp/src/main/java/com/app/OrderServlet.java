package com.app;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Tells Tomcat to route the form submission here
@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String food = request.getParameter("food");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Try-with-resources ensures the connection is closed even if an error occurs
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO orders(name, food, quantity) VALUES (?, ?, ?)")) {

            ps.setString(1, name);
            ps.setString(2, food);
            ps.setInt(3, quantity);

            int rowsAffected = ps.executeUpdate();

            // Only redirect if the database accepted the data
            if (rowsAffected > 0) {
                response.sendRedirect("success.jsp");
            } else {
                response.getWriter().println("<h1>Database rejected the order. Please try again.</h1>");
            }

        } catch (Exception e) {
            e.printStackTrace(); // This prints the exact error in your Eclipse Console
            response.getWriter().println("<h1>Server Error. Check the Eclipse Console.</h1>");
        }
    }
}