package com.realestate.portal.controller;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/removeFavorite")
public class RemoveFavoriteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String buyerName = (String) session.getAttribute("loggedUser");

        // Security check
        if (buyerName == null) {
            response.sendRedirect("login");
            return;
        }

        String propertyId = request.getParameter("propertyId");
        File favFile = new File(getServletContext().getRealPath("/WEB-INF/favorites.txt"));

        if (favFile.exists() && propertyId != null) {
            List<String> remainingFavorites = new ArrayList<>();
            String targetLine = buyerName + "," + propertyId; // This is what we are hunting for!

            // 1. Read all lines, but SKIP the one we want to delete
            try (BufferedReader br = new BufferedReader(new FileReader(favFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (!line.trim().equals(targetLine)) {
                        remainingFavorites.add(line);
                    }
                }
            } catch (Exception e) {}

            // 2. Overwrite the file with the remaining favorites
            try (PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream(favFile), "UTF-8"))) {
                for (String fav : remainingFavorites) {
                    out.println(fav);
                }
            } catch (Exception e) {}
        }

        // Refresh the dashboard!
        response.sendRedirect("buyerDashboard");
    }
}