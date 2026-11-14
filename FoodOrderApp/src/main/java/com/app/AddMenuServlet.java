package com.app;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part; // Required for handling files

@WebServlet("/AddMenuServlet")
// CRITICAL: This annotation tells Tomcat to accept file uploads up to 5MB
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 5,       // 5MB
                 maxRequestSize = 1024 * 1024 * 10)   // 10MB
public class AddMenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Define where you want the images saved on your server
    private static final String UPLOAD_DIR = "images/menu";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Grab the text data
        String itemName = request.getParameter("itemName");
        String itemPrice = request.getParameter("itemPrice");
        String itemDesc = request.getParameter("itemDesc");
        
        // 2. Grab the physical image file
        Part filePart = request.getPart("itemImage");
        String fileName = getFileName(filePart);
        
        // 3. Create the directory path on the server if it doesn't exist
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
        
        File uploadFolder = new File(uploadFilePath);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs(); // Creates the images/menu folders
        }
        
        // 4. Save the file to the server
        String savedFilePath = uploadFilePath + File.separator + fileName;
        filePart.write(savedFilePath);
        
        // The path you will actually save in the database so the HTML can find it:
        String databaseImagePath = UPLOAD_DIR + "/" + fileName;

        System.out.println("----------------------------------------");
        System.out.println("🍔 NEW MENU ITEM & IMAGE UPLOADED!");
        System.out.println("Name: " + itemName);
        System.out.println("Price: $" + itemPrice);
        System.out.println("Image Saved At: " + databaseImagePath);
        System.out.println("----------------------------------------");

        /* * 🚀 DATABASE CODE GOES HERE
         * Now, instead of just saving name/price, you also save 'databaseImagePath' 
         * into a new column in your menu table called 'image_path'.
         */

        response.sendRedirect("admin_dashboard.jsp?status=added");
    }

    // Helper method to extract the file name from the HTTP header
    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return "default.jpg";
    }
}