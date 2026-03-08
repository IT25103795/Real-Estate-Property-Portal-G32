package com.realestate.portal.controller;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
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

        // 1. SECURITY CHECK: Make sure the user is actually logged in and is a SELLER
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("loggedRole");
        String sellerName = (String) session.getAttribute("loggedUser");

        if (role == null || !"SELLER".equalsIgnoreCase(role)) {
            response.sendRedirect("login"); // Kick unauthorized users out!
            return;
        }

        // 2. Grab all the input data from the seller_dashboard.jsp form
        String title = request.getParameter("title");
        String price = request.getParameter("price");
        String location = request.getParameter("location");
        String type = request.getParameter("type");
        String status = request.getParameter("status");

        // Generate a simple unique ID for the property using the current time
        String propertyId = "PROP_" + System.currentTimeMillis();

        // 3. Format it for our text file "Database"
        // Format: ID, Title, Price, Location, Type, Status, SellerName
        String propertyRecord = propertyId + "," + title + "," + price + "," + location + "," + type + "," + status + "," + sellerName;

        // 4. Locate properties.txt and Save the new record!
        String filePath = getServletContext().getRealPath("/WEB-INF/properties.txt");

        // Using FileWriter with 'true' means it will APPEND to the bottom of the file
        try (PrintWriter out = new PrintWriter(new FileWriter(filePath, true))) {
            out.println(propertyRecord);
        } catch (IOException e) {
            System.out.println("Error saving property to properties.txt: " + e.getMessage());
        }

        // 5. Send them back to the dashboard with a green success message
        request.setAttribute("successMessage", "Property listed successfully!");
        request.getRequestDispatcher("/sellerDashboard").forward(request, response);
    }
}