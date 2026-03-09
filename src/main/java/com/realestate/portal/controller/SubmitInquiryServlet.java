package com.realestate.portal.controller;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/submitInquiry")
public class SubmitInquiryServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String buyerName = (String) session.getAttribute("loggedUser");

        if (buyerName == null) {
            response.sendRedirect("login");
            return;
        }

        // Grab the hidden data from the form
        String propertyTitle = request.getParameter("propertyTitle");
        String agentName = request.getParameter("agentName");

        // Generate today's date automatically
        String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        String status = "Pending"; // New inquiries always start as Pending!

        // Format: BuyerName,AgentName,PropertyTitle,Date,Status
        String record = buyerName + "," + agentName + "," + propertyTitle + "," + date + "," + status;

        String filePath = getServletContext().getRealPath("/WEB-INF/inquiries.txt");
        try (PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream(filePath, true), "UTF-8"))) {
            out.println(record);
        } catch (Exception e) {}

        // Send them straight to the dashboard to see their new inquiry!
        response.sendRedirect("buyerDashboard");
    }
}