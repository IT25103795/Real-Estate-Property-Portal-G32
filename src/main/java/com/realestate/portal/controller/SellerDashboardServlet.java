package com.realestate.portal.controller;

import com.realestate.portal.model.Property;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/sellerDashboard")
public class SellerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String sellerName = (String) session.getAttribute("loggedUser");
        String role = (String) session.getAttribute("loggedRole");

        // Kick out anyone who isn't a logged-in Seller
        if (sellerName == null || !"SELLER".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        List<Property> myProperties = new ArrayList<>();
        String filePath = getServletContext().getRealPath("/WEB-INF/properties.txt");
        File file = new File(filePath);

        // Read the file and ONLY grab properties that match this Seller's name
        if (file.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");
                    if (data.length == 7 && data[6].equals(sellerName)) {
                        double price = Double.parseDouble(data[2]);
                        myProperties.add(new Property(data[0], data[1], price, data[3], data[4], data[5], data[6]));
                    }
                }
            } catch (Exception e) {
                System.out.println("Error reading seller properties: " + e.getMessage());
            }
        }

        // Attach the specific seller's properties and forward to the JSP UI
        request.setAttribute("myProperties", myProperties);
        request.getRequestDispatcher("/seller_dashboard.jsp").forward(request, response);
    } // <-- Notice this bracket! This safely closes doGet before doPost starts.

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // If it receives a POST (like from Delete or Update), just run the GET logic anyway to reload the table!
        doGet(request, response);
    }
}