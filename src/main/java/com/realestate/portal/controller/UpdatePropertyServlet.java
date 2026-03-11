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

        // 1. Force UTF-8 so we don't scramble Sinhala text during the update!
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String loggedUser = (String) session.getAttribute("loggedUser");
        String role = (String) session.getAttribute("loggedRole");

        // Security Check
        if (loggedUser == null || !"SELLER".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        // Grab the incoming edits (Clean out any rogue commas so it doesn't break the DB!)
        String propertyId = request.getParameter("propertyId"); // WE MUST KEEP THIS ID EXACTLY THE SAME!
        String title = request.getParameter("title").replace(",", " ");
        String price = request.getParameter("price").replace(",", "");
        String location = request.getParameter("location").replace(",", " ");
        String type = request.getParameter("type");
        String status = request.getParameter("status");

        File propFile = new File(getServletContext().getRealPath("/WEB-INF/properties.txt"));
        List<String> updatedLines = new ArrayList<>();

        if (propFile.exists() && propertyId != null) {
            // 2. Read the entire database line by line
            try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(propFile), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");

                    // If we find the exact property we are trying to edit...
                    if (data.length == 8 && data[0].equals(propertyId) && data[6].equals(loggedUser)) {

                        // 🔥 THE MAGIC FIX: Carefully reconstruct the 8 pieces of data!
                        // Notice how data[0] (ID), data[6] (Seller Name), and data[7] (Image) stay EXACTLY the same!
                        String updatedRecord = data[0] + "," + title + "," + price + "," + location + "," + type + "," + status + "," + data[6] + "," + data[7];
                        updatedLines.add(updatedRecord);

                    } else {
                        // Not the property we are editing? Keep it exactly as it was.
                        updatedLines.add(line);
                    }
                }
            } catch (Exception e) {
                System.out.println("Error reading properties for update: " + e.getMessage());
            }

            // 3. Overwrite the database file with the newly updated list
            try (PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream(propFile, false), "UTF-8"))) {
                for (String l : updatedLines) {
                    out.println(l);
                }
            } catch (Exception e) {
                System.out.println("Error saving updated properties: " + e.getMessage());
            }
        }

        // Send the Seller back to their dashboard!
        response.sendRedirect("sellerDashboard");
    }
}