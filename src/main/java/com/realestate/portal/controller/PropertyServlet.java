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

@WebServlet("/properties")
public class PropertyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<Property> propertyList = new ArrayList<>();
        String filePath = getServletContext().getRealPath("/WEB-INF/properties.txt");
        File file = new File(filePath);

        // READ: Open properties.txt and grab every house
        if (file.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");

                    // We expect 7 pieces of data based on our AddPropertyServlet
                    if (data.length == 7) {
                        try {
                            double price = Double.parseDouble(data[2]);
                            Property p = new Property(data[0], data[1], price, data[3], data[4], data[5], data[6]);
                            propertyList.add(p);
                        } catch (NumberFormatException e) {
                            System.out.println("Skipping invalid price format: " + data[2]);
                        }
                    }
                }
            } catch (IOException e) {
                System.out.println("Error reading properties: " + e.getMessage());
            }
        }

        // ATTACH & ROUTE: Send the list of houses to the front-end!
        request.setAttribute("properties", propertyList);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}