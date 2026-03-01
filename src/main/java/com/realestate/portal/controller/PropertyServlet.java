package com.realestate.portal.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.realestate.portal.model.Property;

@WebServlet("/properties")
public class PropertyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Property> propertyList = new ArrayList<>();


        String filePath = getServletContext().getRealPath("/properties.txt");

        File file = new File(filePath);
        if (file.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");

                    if (data.length >= 5) {
                        propertyList.add(new Property(data[0], data[1], Double.parseDouble(data[2]), data[3], data[4]));
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }


        request.setAttribute("properties", propertyList);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}