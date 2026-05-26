package com.realestate.portal.controller;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/deleteAccount")
public class DeleteAccountServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String userEmail = request.getParameter("userEmail");
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("loggedRole") : null;

        if (userEmail == null || userEmail.trim().isEmpty()) {
            if ("SELLER".equalsIgnoreCase(role)) {
                response.sendRedirect("sellerDashboard");
            } else if ("ADMIN".equalsIgnoreCase(role)) {
                response.sendRedirect("adminDashboard");
            } else {
                response.sendRedirect("buyerDashboard");
            }
            return;
        }

        String filePath = getServletContext().getRealPath("/WEB-INF/users.txt");
        File inputFile = new File(filePath);
        File tempFile = new File(inputFile.getAbsolutePath() + ".tmp");

        try (BufferedReader reader = new BufferedReader(new FileReader(inputFile));
             BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile))) {

            String currentLine;

            while ((currentLine = reader.readLine()) != null) {
                String[] userDetails = currentLine.split(",");
                if (userDetails.length >= 2 && userDetails[1].equals(userEmail)) {
                    continue; 
                }
                writer.write(currentLine);
                writer.newLine();
            }
        } catch (IOException e) {
            System.out.println("Error deleting user: " + e.getMessage());
        }

        if (inputFile.delete()) {
            tempFile.renameTo(inputFile);
        }

        if (session != null) {
            session.invalidate();
        }

        // Redirect to login page after account deletion
        request.setAttribute("successMessage", "Your account has been successfully deleted. We are sorry to see you go!");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}