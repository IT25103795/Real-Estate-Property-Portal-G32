package com.realestate.portal.controller;

import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
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

        // 🔥 FIX 1: Tell Tomcat to expect Sinhala (UTF-8) text from the form!
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String sellerName = (String) session.getAttribute("loggedUser");
        String role = (String) session.getAttribute("loggedRole");

        if (sellerName == null || !"SELLER".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        String propertyId = UUID.randomUUID().toString().substring(0, 8);

        // Grab inputs (Now safely in UTF-8 format)
        String title = request.getParameter("title").replace(",", " ");
        String price = request.getParameter("price").replace(",", "");
        String location = request.getParameter("location").replace(",", " ");
        String status = request.getParameter("status");
        String type = request.getParameter("type");

        String staticImageUrl = "assets/images/property-types/house.jpg";

        if (type != null) {
            switch (type.trim().toUpperCase()) {
                case "HOUSE": staticImageUrl = "assets/images/property-types/house.jpg"; break;
                case "APARTMENT": staticImageUrl = "assets/images/property-types/apartment.jpg"; break;
                case "VILLA": staticImageUrl = "assets/images/property-types/villa.jpg"; break;
                case "STUDIO": staticImageUrl = "assets/images/property-types/apartment.jpg"; break;
            }
        }

        String imageUrl = staticImageUrl;
        String propertyRecord = propertyId + "," + title + "," + price + "," + location + "," + type + "," + status + "," + sellerName + "," + imageUrl;

        String filePath = getServletContext().getRealPath("/WEB-INF/properties.txt");

        // 🔥 FIX 2: Force the text file to save in UTF-8 format!
        try (PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream(filePath, true), "UTF-8"))) {
            out.println(propertyRecord);
        } catch (Exception e) {
            System.out.println("Error saving property: " + e.getMessage());
        }

        response.sendRedirect("sellerDashboard");
    }
}