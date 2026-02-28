package com.realestate.portal.controller;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import com.realestate.portal.model.Property;

@WebServlet("/properties")
public class PropertyServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Property> propertyList = new ArrayList<>();
        // This path works because we moved properties.txt to the webapp folder
        String filePath = getServletContext().getRealPath("/properties.txt");

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            String searchLocation = request.getParameter("location");

            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                // Linear Search Logic
                if (searchLocation == null || searchLocation.isEmpty() || data[4].equalsIgnoreCase(searchLocation)) {
                    propertyList.add(new Property(data[0], data[1], Double.parseDouble(data[2]), data[3], data[4]));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("properties", propertyList);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}