package com.realestate.portal.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Find the user's session and destroy it
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        // Send them back to the homepage
        response.sendRedirect("properties");
    }
}