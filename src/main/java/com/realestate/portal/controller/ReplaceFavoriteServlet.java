package com.realestate.portal.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/replaceFavorite")
public class ReplaceFavoriteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String loggedUser = (String) session.getAttribute("loggedUser");
        String role       = (String) session.getAttribute("loggedRole");

        // Must be a logged-in buyer
        if (loggedUser == null || !"BUYER".equalsIgnoreCase(role)) {
            response.sendRedirect("login");
            return;
        }

        String oldPropertyId = request.getParameter("oldPropertyId");
        String newPropertyId = request.getParameter("newPropertyId");

        if (oldPropertyId == null || newPropertyId == null
                || oldPropertyId.isEmpty() || newPropertyId.isEmpty()) {
            response.sendRedirect("buyerDashboard?replace=error");
            return;
        }

        // ── Validate that the new property is NOT sold ────────────────────
        String propPath = getServletContext().getRealPath("/WEB-INF/properties.txt");
        boolean isSold  = false;
        boolean exists  = false;
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(Files.newInputStream(Paths.get(propPath)), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] d = line.split(",", -1);
                if (d.length >= 6 && d[0].trim().equals(newPropertyId.trim())) {
                    exists = true;
                    if ("Sold".equalsIgnoreCase(d[5].trim())) {
                        isSold = true;
                    }
                    break;
                }
            }
        } catch (Exception ignored) {}
// ── PROPERTY AVAILABILITY GUARD ──────────────────────────────
// Before replacing a favorite, we verify the new property:
//   1. Actually exists in properties.txt
//   2. Is NOT marked as Sold (status col index 5)
// If either check fails, buyer is redirected with ?replace=unavailable

        if (!exists || isSold) {
            response.sendRedirect("buyerDashboard?replace=unavailable");
            return;
        }

        // ── Replace the first matching line in favorites.txt ──────────────
        String favPath = getServletContext().getRealPath("/WEB-INF/favorites.txt");
        File   favFile = new File(favPath);

        if (!favFile.exists()) {
            response.sendRedirect("buyerDashboard?replace=error");
            return;
        }

        List<String> lines  = new ArrayList<>();
        boolean      replaced = false;

        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(Files.newInputStream(favFile.toPath()), StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                // Replace only the FIRST occurrence belonging to this buyer
                if (!replaced && line.equals(loggedUser + "," + oldPropertyId)) {
                    lines.add(loggedUser + "," + newPropertyId);
                    replaced = true;
                } else {
                    lines.add(line);
                }
            }
        }

        if (!replaced) {
            // The old property wasn't in this buyer's favorites
            response.sendRedirect("buyerDashboard?replace=notfound");
            return;
        }

        // Write the updated list back
        try (PrintWriter pw = new PrintWriter(
                new OutputStreamWriter(new FileOutputStream(favFile, false), StandardCharsets.UTF_8))) {
            for (String l : lines) {
                pw.println(l);
            }
        }

        response.sendRedirect("buyerDashboard?replace=success");
    }
}
