package com.app;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT fullname FROM users WHERE email = ? AND password = ?")) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // MATCH FOUND! Grab the user's name from the database
                String dbName = rs.getString("fullname");

                // Create a session to remember the user
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", dbName);

                // Redirect to the home page
                response.sendRedirect("index.jsp");
            }  else {
                // No match found - redirect back to index with an error flag
                response.sendRedirect("index.jsp?error=invalid_login");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h1>Server Error. Check console.</h1>");
        }
    }
}