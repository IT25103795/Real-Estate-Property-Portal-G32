package com.realestate.portal.controller;

import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/saveFavorite")
public class SaveFavoriteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String buyerName = (String) session.getAttribute("loggedUser");
        String role = (String) session.getAttribute("loggedRole");

        // Kick them to login if they aren't a buyer!
        if (buyerName == null || !"BUYER".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        String propertyId = request.getParameter("propertyId");
        if (propertyId != null && !propertyId.isEmpty()) {
            String filePath = getServletContext().getRealPath("/WEB-INF/favorites.txt");
            // Save the match: BuyerName,PropertyID
            try (PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream(filePath, true), "UTF-8"))) {
                out.println(buyerName + "," + propertyId);
            } catch (Exception e) {
                System.out.println("Error saving favorite: " + e.getMessage());
            }
        }

        // Instantly redirect them to their Dashboard to see it!
        response.sendRedirect("buyerDashboard");
    }
}