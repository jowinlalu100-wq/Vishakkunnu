package com.app;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Update "your_database_name" to whatever your MySQL database is called
    private static final String dbURL = "jdbc:mysql://localhost:3306/fooddb";
    private static final String user = "root";       // Usually "root" on local setups
    private static final String pwd = "root";    // Put your MySQL password here

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        // Loads the MySQL driver so Tomcat knows how to talk to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(dbURL, user, pwd);
    }
}