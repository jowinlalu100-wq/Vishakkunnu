package com.app;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ContactServlet")
public class ContactServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String name = request.getParameter("userName");
        String email = request.getParameter("userEmail");
        String message = request.getParameter("userMessage");
        
        // Change these to match your exact DB credentials!
        String dbURL = "jdbc:mysql://localhost:3306/fooddb";
        String dbUser = "root";
        String dbPass = "root";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(dbURL, dbUser, dbPass);
            
            String query = "INSERT INTO contact_messages (name, email, message) VALUES (?, ?, ?)";
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, message);
            
            pstmt.executeUpdate();
            
            pstmt.close();
            con.close();
            
            // Redirect back to index page with a success flag
            response.sendRedirect("index.jsp?msg=success#contact");
            
        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error saving message: " + e.getMessage());
        }
    }
}