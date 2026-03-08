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

@WebServlet("/search")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Grab what the user typed in the search bar
        String searchLocation = request.getParameter("location");
        String searchType = request.getParameter("type");

        List<Property> searchResults = new ArrayList<>();
        String filePath = getServletContext().getRealPath("/WEB-INF/properties.txt");
        File file = new File(filePath);

        // 2. Open the database and start filtering
        if (file.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(file))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");

                    // Remember, we upgraded to 8 columns for the Image URL!
                    if (data.length == 8) {
                        String propLocation = data[3];
                        String propType = data[4];

                        // 3. THE FILTERING LOGIC
                        // Check if the location matches (ignores uppercase/lowercase, and handles empty searches)
                        boolean matchesLocation = (searchLocation == null || searchLocation.trim().isEmpty())
                                || propLocation.toLowerCase().contains(searchLocation.toLowerCase().trim());

                        // Check if the property type matches (or if they selected "Any Type")
                        boolean matchesType = (searchType == null || searchType.trim().isEmpty())
                                || propType.equalsIgnoreCase(searchType);

                        // If it passes both tests, add it to the final results!
                        if (matchesLocation && matchesType) {
                            double price = Double.parseDouble(data[2]);
                            String imageUrl = (data[7] == null || data[7].trim().isEmpty()) ? "https://images.unsplash.com/photo-1600607687644-c7171b42498b?w=900&q=80" : data[7];

                            Property p = new Property(data[0], data[1], price, propLocation, propType, data[5], data[6], imageUrl);
                            searchResults.add(p);
                        }
                    }
                }
            } catch (Exception e) {
                System.out.println("Error searching properties: " + e.getMessage());
            }
        }

        // 4. Send the filtered list back to the homepage to display!
        request.setAttribute("propertyList", searchResults);

        // Add a message so the user knows they are looking at search results
        request.setAttribute("searchMessage", "Showing results for your search:");

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}