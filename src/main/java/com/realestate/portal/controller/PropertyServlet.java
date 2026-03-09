package com.realestate.portal.controller;

import com.realestate.portal.model.Property;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/properties")
public class PropertyServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Tell the response we are sending UTF-8 back to the browser
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        List<Property> propertyList = new ArrayList<>();
        String filePath = getServletContext().getRealPath("/WEB-INF/properties.txt");
        File file = new File(filePath);

        if (file.exists()) {
            // 🔥 FIX: Force Java to READ the file using UTF-8!
            try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");

                    if (data.length == 8) {
                        try {
                            double price = Double.parseDouble(data[2]);
                            String imageUrl = (data[7] == null || data[7].trim().isEmpty()) ? "https://images.unsplash.com/photo-1600607687644-c7171b42498b?w=900&q=80" : data[7];

                            Property p = new Property(data[0], data[1], price, data[3], data[4], data[5], data[6], imageUrl);
                            propertyList.add(p);
                        } catch (NumberFormatException e) {
                            System.out.println("Skipping invalid price: " + data[2]);
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("Error reading properties: " + e.getMessage());
            }
        }
        request.setAttribute("propertyList", propertyList);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}