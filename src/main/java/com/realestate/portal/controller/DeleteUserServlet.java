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

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("loggedRole");

        // Kick out anyone who isn't the Admin!
        if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        // Grab the email of the user we want to delete from the hidden input
        String emailToDelete = request.getParameter("userEmail");
        String filePath = getServletContext().getRealPath("/WEB-INF/users.txt");
        List<String> remainingUsers = new ArrayList<>();

        // 1. Read the file and SKIP the user with the matching email
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.contains(emailToDelete)) {
                    remainingUsers.add(line); // Keep everyone else!
                }
            }
        } catch (Exception e) {
            System.out.println("Error reading users: " + e.getMessage());
        }

        // 2. Overwrite the file with the remaining users
        try (PrintWriter out = new PrintWriter(new FileWriter(filePath, false))) {
            for (String u : remainingUsers) {
                out.println(u);
            }
        } catch (Exception e) {
            System.out.println("Error deleting user: " + e.getMessage());
        }

        // 3. Route back to the Admin Dashboard to refresh the table
        request.getRequestDispatcher("/adminDashboard").forward(request, response);
    }
}