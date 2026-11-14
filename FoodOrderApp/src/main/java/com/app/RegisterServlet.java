package com.app;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password"); 

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO users(fullname, email, password) VALUES (?, ?, ?)")) {

            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, password);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                // Success! Send them back to the home page
                response.sendRedirect("index.jsp");
            } else {
                response.getWriter().println("<h1>Registration Failed.</h1>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h1>Error: Email might already exist. Check Eclipse console.</h1>");
        }
    }
}