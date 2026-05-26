package com.realestate.portal.controller;

import java.io.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/markAsSold")
public class MarkAsSoldServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        String loggedUser = (String) session.getAttribute("loggedUser");
        String role = (String) session.getAttribute("loggedRole");

        // Only sellers can mark their own properties as sold
        if (loggedUser == null || !"SELLER".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        String propertyId = request.getParameter("propertyId");

        File propFile = new File(getServletContext().getRealPath("/WEB-INF/properties.txt"));
        List<String> updatedLines = new ArrayList<>();
        boolean updated = false;
        String soldPropertyData = null;

        if (propFile.exists() && propertyId != null) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(propFile), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");
                    // Match by property ID AND seller name (security check)
                    if (data.length >= 8 && data[0].equals(propertyId) && data[6].equals(loggedUser)) {
                        // data[5] is the status field — set it to "Sold"
                        data[5] = "Sold";
                        updatedLines.add(String.join(",", data));
                        updated = true;

                        // Store property data for sold notification
                        // Format: propertyId|title|price|location|imageUrl
                        soldPropertyData = propertyId + "|" + data[1] + "|" + data[2] + "|" + data[3] + "|" + (data.length > 7 ? data[7] : "");
                    } else {
                        updatedLines.add(line);
                    }
                }
            } catch (Exception e) {
                System.out.println("Error reading properties for mark-as-sold: " + e.getMessage());
            }

            if (updated) {
                try (PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream(propFile, false), "UTF-8"))) {
                    for (String l : updatedLines) {
                        out.println(l);
                    }
                } catch (Exception e) {
                    System.out.println("Error saving sold status: " + e.getMessage());
                }

                // Records the sold property with timestamp for display on homepage
                if (soldPropertyData != null) {
                    recordSoldProperty(soldPropertyData);
                }
            }
        }

        response.sendRedirect("sellerDashboard");
    }

    private void recordSoldProperty(String propertyData) {
        try {
            String soldFilePath = getServletContext().getRealPath("/WEB-INF/sold_properties.txt");
            File soldFile = new File(soldFilePath);

            // Get current timestamp
            LocalDateTime now = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String timestamp = now.format(formatter);

            // Check if property is already recorded to avoid duplicates
            boolean alreadyRecorded = false;
            if (soldFile.exists()) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(soldFile), "UTF-8"))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        if (line.contains("|" + propertyData.split("\\|")[0] + "|")) {
                            alreadyRecorded = true;
                            break;
                        }
                    }
                }
            }

            // Only append if not already recorded
            if (!alreadyRecorded) {
                try (FileWriter fw = new FileWriter(soldFile, true);
                     BufferedWriter bw = new BufferedWriter(fw);
                     PrintWriter out = new PrintWriter(bw)) {
                    out.println(timestamp + "|" + propertyData);
                }

                System.out.println("🔴 SOLD PROPERTY RECORDED: " + propertyData);
            } else {
                System.out.println("⚠️ SOLD PROPERTY ALREADY RECORDED: " + propertyData);
            }
        } catch (Exception e) {
            System.out.println("Error recording sold property: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
