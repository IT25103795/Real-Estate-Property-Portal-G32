package com.realestate.portal.controller;

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
import javax.servlet.http.HttpSession;

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("loggedRole");

        // SECURITY CHECK: Kick out anyone who isn't God Mode (ADMIN)
        if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        int totalProperties = 0;
        List<String[]> allUsers = new ArrayList<>(); // Will hold [Name, Email, Role]

        // 1. READ ALL USERS
        String usersPath = getServletContext().getRealPath("/WEB-INF/users.txt");
        File usersFile = new File(usersPath);
        if (usersFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(usersFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");
                    // Expecting: email, password, role, name
                    if (data.length >= 4) {
                        String[] userRecord = {data[3], data[0], data[2]}; // Name, Email, Role
                        allUsers.add(userRecord);
                    }
                }
            } catch (Exception e) {
                System.out.println("Error reading users: " + e.getMessage());
            }
        }

        // 2. COUNT ALL PROPERTIES
        String propsPath = getServletContext().getRealPath("/WEB-INF/properties.txt");
        File propsFile = new File(propsPath);
        if (propsFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(propsFile))) {
                while (br.readLine() != null) {
                    totalProperties++; // Just count the lines!
                }
            } catch (Exception e) {
                System.out.println("Error reading properties: " + e.getMessage());
            }
        }

        // 3. ATTACH DATA AND SEND TO DASHBOARD
        request.setAttribute("userList", allUsers);
        request.setAttribute("totalUsers", allUsers.size());
        request.setAttribute("totalProperties", totalProperties);
        request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);

    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}