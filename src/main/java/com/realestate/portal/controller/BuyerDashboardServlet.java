package com.realestate.portal.controller;

import com.realestate.portal.model.Property;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/buyerDashboard")
public class BuyerDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String loggedUser = (String) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect("login");
            return;
        }

        List<String> myFavIds = new ArrayList<>();
        List<Property> savedProperties = new ArrayList<>();

        // 1. Read favorites.txt and find IDs belonging to this specific buyer
        File favFile = new File(getServletContext().getRealPath("/WEB-INF/favorites.txt"));
        if (favFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(favFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");
                    if (data.length == 2 && data[0].equals(loggedUser)) {
                        myFavIds.add(data[1]); // Save the Property ID
                    }
                }
            } catch (Exception e) {
            }
        }

        // 2. Read properties.txt, grab the full details for those specific IDs
        File propFile = new File(getServletContext().getRealPath("/WEB-INF/properties.txt"));
        if (propFile.exists() && !myFavIds.isEmpty()) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(propFile), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");
                    if (data.length == 8 && myFavIds.contains(data[0])) {
                        double price = Double.parseDouble(data[2]);
                        savedProperties.add(new Property(data[0], data[1], price, data[3], data[4], data[5], data[6], data[7]));
                    }
                }
            } catch (Exception e) {
            }
        }
        // --- INQUIRY READER ENGINE (BULLETPROOF HASHMAP) ---
        List<java.util.Map<String, String>> myInquiries = new ArrayList<>();
        File inqFile = new File(getServletContext().getRealPath("/WEB-INF/inquiries.txt"));

        if (inqFile.exists()) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(inqFile), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");
                    // If it belongs to this buyer, map it!
                    if (data.length >= 5 && data[0].equals(loggedUser)) {
                        java.util.Map<String, String> inq = new java.util.HashMap<>();
                        inq.put("agentName", data[1]);
                        inq.put("propertyTitle", data[2]);
                        inq.put("date", data[3]);
                        inq.put("status", data[4]);
                        myInquiries.add(inq);
                    }
                }
            } catch (Exception e) {
                System.out.println("Error reading inquiries: " + e.getMessage());
            }
        }
        // ... (your inquiry reader code above) ...

        request.setAttribute("myInquiries", myInquiries);
        // ---------------------------------------------------

        request.setAttribute("savedProperties", savedProperties);
        request.getRequestDispatcher("/buyer_dashboard.jsp").forward(request, response);
    }
}