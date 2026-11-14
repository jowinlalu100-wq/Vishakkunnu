package com.app;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// 1. Give it a unique URL routing so it doesn't clash with the customer logout!
@WebServlet("/adminLogout") 
public class AdminLogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 2. Class name matches the new file name
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            session.invalidate(); 
            System.out.println("🔒 Admin has been securely logged out.");
        }
        
        // Redirect the admin back to the home page
        response.sendRedirect("index.jsp");
    }
}