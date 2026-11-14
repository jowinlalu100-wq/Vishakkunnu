package com.app;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logoutServlet")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Notice we use doGet here because a standard HTML <a> link sends a GET request
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Grab the current session (if it exists)
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Destroy the session entirely, wiping the user's logged-in status
            session.invalidate();
        }
        
        // Send them back to the home page as a guest
        response.sendRedirect("index.jsp");
    }
}