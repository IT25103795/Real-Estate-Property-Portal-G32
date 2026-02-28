package com.realestate.portal.controller;

import com.realestate.portal.model.Property;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/properties")
public class PropertyServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Property> propertyList = new ArrayList<>();
        String filePath = getServletContext().getRealPath("/") + "properties.txt";

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                if (data.length == 5) {
                    propertyList.add(new Property(data[0], data[1],
                            Double.parseDouble(data[2]), data[3], data[4]));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


        request.setAttribute("propertyList", propertyList);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}