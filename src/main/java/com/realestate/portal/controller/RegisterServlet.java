package com.realestate.portal.controller;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        System.out.println("====== NEW REGISTRATION ======");
        System.out.println("The HTML form sent the role: " + role);

        String userRecord = fullName + "," + email + "," + password + "," + role + "\n";

        String filePath = getServletContext().getRealPath("/WEB-INF/users.txt");

        try (FileWriter fw = new FileWriter(filePath, true);
             BufferedWriter bw = new BufferedWriter(fw);
             PrintWriter out = new PrintWriter(bw)) {
            out.print(userRecord);
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("Error saving user: " + e.getMessage());
        }

        request.setAttribute("successMessage", "Account created successfully! Please Sign In.");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}