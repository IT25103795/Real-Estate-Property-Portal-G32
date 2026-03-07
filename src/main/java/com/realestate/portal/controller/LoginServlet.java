package com.realestate.portal.controller;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String inputEmail = request.getParameter("username");
        String inputPassword = request.getParameter("password");

        String filePath = getServletContext().getRealPath("/WEB-INF/users.txt");

        boolean isValidUser = false;
        String fullName = "";
        String role = "";

        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] userDetails = line.split(",");

                if (userDetails.length == 4) {

                    if (userDetails[1].equals(inputEmail) && userDetails[2].equals(inputPassword)) {
                        isValidUser = true;
                        fullName = userDetails[0];
                        role = userDetails[3].trim();
                        break;
                    }
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading users.txt: " + e.getMessage());
        }

        if (isValidUser) {

            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", fullName);
            session.setAttribute("loggedRole", role);

            // ── THE TRAFFIC COP LOGIC ──

            if ("ADMIN".equalsIgnoreCase(role)) {
                response.sendRedirect("admin_dashboard.jsp");
            } else if ("SELLER".equalsIgnoreCase(role)) {
                response.sendRedirect("seller_dashboard.jsp");
            } else {

                response.sendRedirect("properties");
            }
        } else {

            request.setAttribute("errorMessage", "Invalid email or password!");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }
}