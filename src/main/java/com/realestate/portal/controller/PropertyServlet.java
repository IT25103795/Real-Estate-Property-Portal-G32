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
        String filePath = getServletContext().getRealPath("/properties.txt");

        // Check if file exists to avoid yellow warning/error
        File file = new File(filePath);
        if (file.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] d = line.split(",");
                    if (d.length >= 5) {
                        propertyList.add(new Property(d[0], d[1], Double.parseDouble(d[2]), d[3], d[4]));
                    }
                }
            } catch (Exception e) {
                // Keep this - it's fine for your lab work!
                e.printStackTrace();
            }
        }

        request.setAttribute("properties", propertyList);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}