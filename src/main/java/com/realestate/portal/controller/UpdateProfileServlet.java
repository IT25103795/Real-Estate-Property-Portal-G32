package com.realestate.portal.controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String oldEmail = request.getParameter("oldEmail");
        String newName = request.getParameter("newName");
        String newEmail = request.getParameter("newEmail");
        String newPassword = request.getParameter("newPassword");

        HttpSession session = request.getSession();
        String currentRole = (String) session.getAttribute("loggedRole");

        if (currentRole == null) {
            response.sendRedirect("login");
            return;
        }

        // Setup file paths (adjust the path to match your WEB-INF setup)
        String filePath = getServletContext().getRealPath("/WEB-INF/users.txt");
        File inputFile = new File(filePath);
        File tempFile = new File(inputFile.getAbsolutePath() + ".tmp");

        try (BufferedReader reader = new BufferedReader(new FileReader(inputFile));
             BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile))) {

            String currentLine;

            while ((currentLine = reader.readLine()) != null) {
                String[] userData = currentLine.split(",");

                // Check if this line is the user we want to update
                if (userData.length >= 4 && userData[1].equals(oldEmail) && userData[userData.length - 1].trim().equals(currentRole)) {
                    // Preserve phone number (field index 2) if it exists in the stored record
                    String phone = (userData.length >= 5) ? userData[2] : "";
                    // Write the updated line instead of the old one (keep 5-field format)
                    writer.write(newName + "," + newEmail + "," + phone + "," + newPassword + "," + currentRole);
                } else {
                    // Keep the original line (Sellers and other buyers stay untouched)
                    writer.write(currentLine);
                }
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Replace the old file with the updated temp file
        if (inputFile.delete()) {
            tempFile.renameTo(inputFile);
        }

        // Update the session with the new email so the user stays logged in
        session.setAttribute("loggedUser", newName);
        session.setAttribute("loggedEmail", newEmail);
        session.setAttribute("loggedPassword", newPassword);

        // Redirect back to the dashboard with success message
        if ("ADMIN".equals(currentRole)) {
            response.sendRedirect("adminDashboard?profile=success");
        } else if ("SELLER".equals(currentRole)) {
            response.sendRedirect("sellerDashboard?profile=success");
        } else {
            response.sendRedirect("buyerDashboard?profile=success");
        }
    }
}