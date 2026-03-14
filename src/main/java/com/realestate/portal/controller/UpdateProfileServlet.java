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

        // Setup file paths (adjust the path to match your WEB-INF setup)
        String filePath = getServletContext().getRealPath("/WEB-INF/users.txt");
        File inputFile = new File(filePath);
        File tempFile = new File(inputFile.getAbsolutePath() + ".tmp");

        try (BufferedReader reader = new BufferedReader(new FileReader(inputFile));
             BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile))) {

            String currentLine;

            while ((currentLine = reader.readLine()) != null) {
                String[] userData = currentLine.split(",");

                // Check if this line is the user we want to update AND they are a BUYER
                if (userData.length == 4 && userData[1].equals(oldEmail) && userData[3].equals("BUYER")) {
                    // Write the updated line instead of the old one
                    writer.write(newName + "," + newEmail + "," + newPassword + ",BUYER");
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
        HttpSession session = request.getSession();
        session.setAttribute("userEmail", newEmail);

        // Redirect back to the dashboard
        response.sendRedirect("buyerDashboard");
    }
}