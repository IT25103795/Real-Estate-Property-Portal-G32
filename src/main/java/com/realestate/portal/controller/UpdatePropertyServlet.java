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

@WebServlet("/updateProperty")
public class UpdatePropertyServlet extends HttpServlet {

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

        // 2. Grab the updated data from the edit form
        String id = request.getParameter("propertyId"); // We MUST have the ID to know which one to update!
        String title = request.getParameter("title");
        String price = request.getParameter("price");
        String location = request.getParameter("location");
        String type = request.getParameter("type");
        String status = request.getParameter("status");

        // 3. Create the new, updated row
        String updatedRecord = id + "," + title + "," + price + "," + location + "," + type + "," + status + "," + sellerName;
        String filePath = getServletContext().getRealPath("/WEB-INF/properties.txt");

        // 4. THE MAGIC FILE SWAP: Read everything, find the match, and replace it
        List<String> allLines = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                // Check if this line starts with the ID we are trying to update
                if (line.startsWith(id + ",")) {
                    allLines.add(updatedRecord); // MATCH! Swap in the new data
                } else {
                    allLines.add(line); // Not a match, keep the old data exactly as is
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading properties for update: " + e.getMessage());
        }

        // 5. Overwrite the file with the new list
        // Notice the 'false' here! It means DO NOT append; completely overwrite the file!
        try (PrintWriter out = new PrintWriter(new FileWriter(filePath, false))) {
            for (String newLine : allLines) {
                out.println(newLine);
            }
        } catch (IOException e) {
            System.out.println("Error writing updated properties: " + e.getMessage());
        }

        // 6. Send them back to the dashboard with a success message
        request.setAttribute("successMessage", "Property updated successfully!");
        request.getRequestDispatcher("/sellerDashboard").forward(request, response);
    }
}