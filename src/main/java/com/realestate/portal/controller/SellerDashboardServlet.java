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
        String loggedUser = (String) session.getAttribute("loggedUser");
        String role = (String) session.getAttribute("loggedRole");

        if (loggedUser == null || !"SELLER".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        List<Property> myProperties = new ArrayList<>();
        String filePath = getServletContext().getRealPath("/WEB-INF/properties.txt");
        File file = new File(filePath);

        if (file.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");

                    // UPGRADED to check for 8 columns and match the Seller Name
                    if (data.length == 8 && data[6].equals(loggedUser)) {
                        try {
                            double price = Double.parseDouble(data[2]);
                            String imageUrl = (data[7] == null || data[7].trim().isEmpty()) ? "https://images.unsplash.com/photo-1600607687644-c7171b42498b?w=900&q=80" : data[7];

                            // Pass all 8 items!
                            Property p = new Property(data[0], data[1], price, data[3], data[4], data[5], data[6], imageUrl);
                            myProperties.add(p);
                        } catch (NumberFormatException e) {
                            System.out.println("Skipping invalid price: " + data[2]);
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("Error reading properties: " + e.getMessage());
            }
        }

        request.setAttribute("myProperties", myProperties);
        request.getRequestDispatcher("/seller_dashboard.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
