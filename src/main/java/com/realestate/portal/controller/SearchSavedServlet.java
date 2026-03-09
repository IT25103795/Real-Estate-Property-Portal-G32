package com.realestate.portal.controller;

import com.realestate.portal.model.Property;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/searchSaved")
public class SearchSavedServlet extends HttpServlet {

    // ==========================================
    // 🔥 ALGORITHM 1: BINARY SEARCH TREE (BST) 🔥
    // ==========================================
    class PropertyNode {
        Property data;
        PropertyNode left, right;
        public PropertyNode(Property data) { this.data = data; }
    }

    class PropertyBST {
        PropertyNode root;

        // Insert into the Tree
        public void insert(Property p) {
            root = insertRec(root, p);
        }

        private PropertyNode insertRec(PropertyNode root, Property p) {
            if (root == null) {
                return new PropertyNode(p);
            }
            // Sort the tree alphabetically by Property ID
            if (p.getId().compareToIgnoreCase(root.data.getId()) < 0)
                root.left = insertRec(root.left, p);
            else if (p.getId().compareToIgnoreCase(root.data.getId()) > 0)
                root.right = insertRec(root.right, p);
            return root;
        }

        // Search the Tree in O(log N) Time!
        public Property searchById(String id) {
            PropertyNode result = searchRec(root, id);
            return result != null ? result.data : null;
        }

        private PropertyNode searchRec(PropertyNode root, String id) {
            // Base Cases: root is null or key is present at root
            if (root == null || root.data.getId().equalsIgnoreCase(id))
                return root;
            // Key is greater than root's key
            if (root.data.getId().compareToIgnoreCase(id) > 0)
                return searchRec(root.left, id);
            // Key is smaller than root's key
            return searchRec(root.right, id);
        }
    }
    // ==========================================

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String loggedUser = (String) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect("login");
            return;
        }

        String query = request.getParameter("query");
        if (query == null) query = "";
        query = query.trim().toLowerCase();

        List<String> myFavIds = new ArrayList<>();
        List<Property> allSavedProperties = new ArrayList<>();

        // 1. Grab this Buyer's specific favorites from the database
        File favFile = new File(getServletContext().getRealPath("/WEB-INF/favorites.txt"));
        if (favFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(favFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");
                    if (data.length == 2 && data[0].equals(loggedUser)) myFavIds.add(data[1]);
                }
            } catch (Exception e) {}
        }

        // 2. Grab the actual Property details for those favorites
        File propFile = new File(getServletContext().getRealPath("/WEB-INF/properties.txt"));
        if (propFile.exists() && !myFavIds.isEmpty()) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(propFile), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");
                    if (data.length == 8 && myFavIds.contains(data[0])) {
                        double price = Double.parseDouble(data[2]);
                        allSavedProperties.add(new Property(data[0], data[1], price, data[3], data[4], data[5], data[6], data[7]));
                    }
                }
            } catch (Exception e) {}
        }

        List<Property> searchResults = new ArrayList<>();

        // 3. EXECUTE THE SEARCH
        if (!query.isEmpty()) {
            PropertyBST bst = new PropertyBST();

            // Load all saved properties into the Binary Search Tree
            for (Property p : allSavedProperties) {
                bst.insert(p);
            }

            // Try to find the exact property using our ultra-fast BST!
            Property foundById = bst.searchById(query);

            if (foundById != null) {
                searchResults.add(foundById);
            } else {
                // Fallback: If they typed a City instead of an ID, do a standard linear search
                for (Property p : allSavedProperties) {
                    if (p.getLocation().toLowerCase().contains(query) || p.getTitle().toLowerCase().contains(query)) {
                        searchResults.add(p);
                    }
                }
            }
        } else {
            searchResults = allSavedProperties; // Show all if search box is empty
        }

        // Send the filtered results back to the Dashboard
        request.setAttribute("savedProperties", searchResults);
        request.getRequestDispatcher("/buyer_dashboard.jsp").forward(request, response);
    }
}
