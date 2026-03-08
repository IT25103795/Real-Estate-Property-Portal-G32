package com.realestate.portal.controller;

import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/addProperty")
public class AddPropertyServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String sellerName = (String) session.getAttribute("loggedUser");
        String role = (String) session.getAttribute("loggedRole");

        // SECURITY CHECK: Kick out anyone who isn't a logged-in Seller
        if (sellerName == null || !"SELLER".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        // 1. Generate a unique ID for the property
        String propertyId = UUID.randomUUID().toString().substring(0, 8);

        // 2. Grab inputs (stripped of commas for our database)
        String title = request.getParameter("title").replace(",", " ");
        String price = request.getParameter("price").replace(",", "");
        String location = request.getParameter("location").replace(",", " ");
        String status = request.getParameter("status");

        // 3. THE NEW IMAGE MAPPING LOGIC 🔥
        // Grab the type the seller selected (e.g., "House", "Apartment", "Villa")
        String type = request.getParameter("type");

        // Define a safe fallback house link in case they select an unknown type!
        String staticImageUrl = "assets/images/property-types/house.jpg";

        // Use Java's switch case to map the type to the exact local file path!
        if (type != null) {
            switch (type.trim().toUpperCase()) { // Convert to standard upper case like "HOUSE"
                case "HOUSE":
                    staticImageUrl = "assets/images/property-types/house.jpg";
                    break;
                case "APARTMENT":
                    staticImageUrl = "assets/images/property-types/apartment.jpg";
                    break;
                case "VILLA":
                    staticImageUrl = "assets/images/property-types/villa.jpg";
                    break;
                case "STUDIO":
                    // If they selected Studio, maybe we give them the apartment image?
                    staticImageUrl = "assets/images/property-types/apartment.jpg";
                    break;
                default:
                    // If somehow it's a type we don't know, we use the safe house fallback!
                    break;
            }
        }

        // 4. THE LOCAL LINK SAVING
        // Instead of a URL, we are saving the LOCAL PROJECT PATH!
        String imageUrl = staticImageUrl;

        // 5. Format strictly as 8 columns for properties.txt database
        String propertyRecord = propertyId + "," + title + "," + price + "," + location + "," + type + "," + status + "," + sellerName + "," + imageUrl;

        // 6. Save (append) to the text file database
        String filePath = getServletContext().getRealPath("/WEB-INF/properties.txt");
        try (PrintWriter out = new PrintWriter(new FileWriter(filePath, true))) {
            out.println(propertyRecord);
        } catch (Exception e) {
            System.out.println("Error saving property: " + e.getMessage());
        }

        // 7. Route back to the Seller Dashboard
        response.sendRedirect("sellerDashboard");
    }
}