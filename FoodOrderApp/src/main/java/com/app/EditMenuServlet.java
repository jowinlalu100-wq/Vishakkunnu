package com.app;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/EditMenuServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class EditMenuServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "images/menu";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("itemId");
        String name = request.getParameter("itemName");
        String price = request.getParameter("itemPrice");
        String desc = request.getParameter("itemDesc");
        Part filePart = request.getPart("itemImage");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/fooddb", "root", "root");
            
            // If the user DID NOT upload a new photo
            if (filePart == null || filePart.getSize() == 0) {
                PreparedStatement ps = con.prepareStatement("UPDATE menu SET name=?, price=?, description=? WHERE id=?");
                ps.setString(1, name);
                ps.setString(2, price);
                ps.setString(3, desc);
                ps.setString(4, id);
                ps.executeUpdate();
            } 
            // If the user DID upload a new photo
            else {
                String fileName = getFileName(filePart);
                String uploadFilePath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                new File(uploadFilePath).mkdirs();
                filePart.write(uploadFilePath + File.separator + fileName);
                
                String databaseImagePath = UPLOAD_DIR + "/" + fileName;

                PreparedStatement ps = con.prepareStatement("UPDATE menu SET name=?, price=?, description=?, image_path=? WHERE id=?");
                ps.setString(1, name);
                ps.setString(2, price);
                ps.setString(3, desc);
                ps.setString(4, databaseImagePath);
                ps.setString(5, id);
                ps.executeUpdate();
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect("admin_dashboard.jsp?status=updated");
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "default.jpg";
    }
}