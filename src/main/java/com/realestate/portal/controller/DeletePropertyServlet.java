package com.realestate.portal.controller;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/deleteProperty")
public class DeletePropertyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. SECURITY CHECK: Ensure it's a logged-in SELLER
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("loggedRole");
        String sellerName = (String) session.getAttribute("loggedUser");

        if (role == null || !"SELLER".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        // 2. Grab the ID of the house they want to delete
        String idToDelete = request.getParameter("propertyId");

        String filePath = getServletContext().getRealPath("/WEB-INF/properties.txt");
        List<String> remainingLines = new ArrayList<>();
        boolean isDeleted = false;

        // 3. THE MAGIC ERASER: Read everything, but SKIP the matching house
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                // If the line starts with the ID, we ignore it (this deletes it!)
                // We also double-check the sellerName to prevent hackers from deleting other people's houses
                if (line.startsWith(idToDelete + ",") && line.endsWith("," + sellerName)) {
                    isDeleted = true; // We found it and skipped it!
                } else {
                    remainingLines.add(line); // Keep all other houses
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading properties for deletion: " + e.getMessage());
        }

        // 4. Overwrite the file with the remaining houses
        if (isDeleted) {
            try (PrintWriter out = new PrintWriter(new FileWriter(filePath, false))) {
                for (String newLine : remainingLines) {
                    out.println(newLine);
                }
            } catch (IOException e) {
                System.out.println("Error writing after deletion: " + e.getMessage());
            }
            request.setAttribute("successMessage", "Property deleted successfully! 🗑️");
        } else {
            request.setAttribute("errorMessage", "Error: Property not found or unauthorized.");
        }

        // 5. Send them back to their dashboard
        request.getRequestDispatcher("/sellerDashboard").forward(request, response);
    }
}