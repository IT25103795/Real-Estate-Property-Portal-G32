package com.realestate.portal.controller;

import com.realestate.portal.model.Property;
import com.realestate.portal.model.InquiryMessage;
import com.realestate.portal.model.InquiryThread;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet("/buyerDashboard")
public class BuyerDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String loggedUser = (String) session.getAttribute("loggedUser");

        if (loggedUser == null) {
            response.sendRedirect("login");
            return;
        }

        // ── Auto-restore expired rental properties ──────────────────────────
        try {
            RentalExpiryCheckerServlet expiryChecker = new RentalExpiryCheckerServlet();
            expiryChecker.init(getServletConfig());
            expiryChecker.runExpiryCheck(request);
        } catch (Exception expiryEx) {
            System.err.println("Expiry check warning: " + expiryEx.getMessage());
        }
        // ───────────────────────────────────────────────────────────────────

        List<String> myFavIds = new ArrayList<>();
        List<Property> savedProperties = new ArrayList<>();

        // 1. Read favorites.txt and find IDs belonging to this specific buyer
        File favFile = new File(getServletContext().getRealPath("/WEB-INF/favorites.txt"));
        if (favFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(favFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");
                    if (data.length == 2 && data[0].equals(loggedUser)) {
                        myFavIds.add(data[1]); // Save the Property ID
                    }
                }
            } catch (Exception e) {
                System.err.println("Error reading favorites: " + e.getMessage());
            }
        }

        // 2. Read properties.txt, grab the full details for those specific IDs
        File propFile = new File(getServletContext().getRealPath("/WEB-INF/properties.txt"));
        if (propFile.exists() && !myFavIds.isEmpty()) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(Files.newInputStream(Paths.get(propFile.getAbsolutePath())), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split(",");
                    if (myFavIds.contains(data[0])) {
                        Property p = null;
                        try {
                            if (data.length == 11) { // New format with description
                                p = new Property(data[0], data[1], Double.parseDouble(data[2]), data[3], data[4], data[5], data[6], data[7], Integer.parseInt(data[8]), Integer.parseInt(data[9]), data[10]);
                            } else if (data.length == 10) { // Format without description
                                p = new Property(data[0], data[1], Double.parseDouble(data[2]), data[3], data[4], data[5], data[6], data[7], Integer.parseInt(data[8]), Integer.parseInt(data[9]), "");
                            } else if (data.length == 8) { // Old format
                                p = new Property(data[0], data[1], Double.parseDouble(data[2]), data[3], data[4], data[5], data[6], data[7], 0, 0, "");
                            }
                            if (p != null) {
                                savedProperties.add(p);
                            }
                        } catch (NumberFormatException e) {
                            System.err.println("Skipping malformed property line: " + line);
                        }
                    }
                }
            } catch (Exception e) {
                System.err.println("Error reading properties: " + e.getMessage());
            }
        }

        // --- INQUIRY THREAD READER ENGINE (new threaded system) ---
        List<Map<String, String>> myInquiries = new ArrayList<>();
        List<InquiryThread> buyerThreads = new ArrayList<>();
        Map<String, InquiryThread> byId = new HashMap<>();

        File threadsFile = new File(getServletContext().getRealPath("/WEB-INF/inquiry_threads.tsv"));
        if (threadsFile.exists()) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(Files.newInputStream(Paths.get(threadsFile.getAbsolutePath())), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] data = line.split("\t", -1);
                    // threadId, propertyId, propertyTitle, sellerName, buyerAccount, buyerName, buyerEmail, buyerPhone, createdDate, status
                    if (data.length >= 10 && loggedUser.equals(data[4])) {
                        Map<String, String> inq = new HashMap<>();
                        inq.put("threadId", data[0]);
                        inq.put("propertyId", data[1]);
                        inq.put("propertyTitle", data[2]);
                        inq.put("agentName", data[3]);
                        inq.put("buyerName", data[5]);
                        inq.put("buyerEmail", data[6]);
                        inq.put("buyerPhone", data[7]);
                        inq.put("date", data[8]);
                        inq.put("status", data[9]);
                        myInquiries.add(inq);

                        InquiryThread t = new InquiryThread(
                                data[0], data[1], data[2], data[3],
                                data[4], data[5], data[6], data[7],
                                data[8], data[9]
                        );
                        buyerThreads.add(t);
                        byId.put(t.getId(), t);
                    }
                }
            } catch (Exception e) {
                System.err.println("Error reading inquiry threads: " + e.getMessage());
            }

            File messagesFile = new File(getServletContext().getRealPath("/WEB-INF/inquiry_messages.tsv"));
            if (messagesFile.exists() && !byId.isEmpty()) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(Files.newInputStream(Paths.get(messagesFile.getAbsolutePath())), StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        String[] data = line.split("\t", -1);
                        if (data.length >= 5) {
                            InquiryThread t = byId.get(data[0]);
                            if (t == null) continue;

                            String content = "";
                            try {
                                byte[] decoded = Base64.getDecoder().decode(data[4]);
                                content = new String(decoded, StandardCharsets.UTF_8);
                            } catch (Exception ignored) {}

                            t.getMessages().add(new InquiryMessage(data[0], data[1], data[2], data[3], content));
                        }
                    }
                } catch (Exception e) {
                    System.err.println("Error reading inquiry messages: " + e.getMessage());
                }
            }
        }

        request.setAttribute("myInquiries", myInquiries);
        request.setAttribute("buyerThreads", buyerThreads);

        // ─── BOOKINGS MODULE ─────────────────────────────────────────────────────
        java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
        java.time.LocalDate today = java.time.LocalDate.now();

        // Build a map of propertyId -> dailyPrice from properties.txt
        java.util.Map<String, Double> propertyPriceMap = new java.util.HashMap<>();
        File propFilePath = new File(getServletContext().getRealPath("/WEB-INF/properties.txt"));
        if (propFilePath.exists()) {
            try (java.io.BufferedReader pr = new java.io.BufferedReader(
                    new java.io.InputStreamReader(
                            java.nio.file.Files.newInputStream(propFilePath.toPath()),
                            java.nio.charset.StandardCharsets.UTF_8))) {
                String pl;
                while ((pl = pr.readLine()) != null) {
                    if (pl.trim().isEmpty() || pl.trim().startsWith("#")) continue;
                    String[] pd = pl.split(",", -1);
                    if (pd.length >= 3) {
                        try { propertyPriceMap.put(pd[0].trim(), Double.parseDouble(pd[2].trim())); }
                        catch (NumberFormatException ignored) {}
                    }
                }
            } catch (Exception ignored) {}
        }

        List<Map<String, String>> myBookings = new ArrayList<>();
        List<Map<String, String>> bookingHistory = new ArrayList<>(); // ENHANCEMENT 3: Booking history

        String bookingsPath = getServletContext().getRealPath("/WEB-INF/bookings.txt");
        java.io.File bookingsFile = new java.io.File(bookingsPath);

        if (bookingsFile.exists()) {
            try (java.io.BufferedReader bkBr = new java.io.BufferedReader(
                    new java.io.InputStreamReader(
                            java.nio.file.Files.newInputStream(bookingsFile.toPath()),
                            java.nio.charset.StandardCharsets.UTF_8))) {
                String bkLine;
                while ((bkLine = bkBr.readLine()) != null) {
                    if (bkLine.trim().isEmpty()) continue;
                    if (bkLine.trim().startsWith("#")) continue;
                    String[] d = bkLine.split("\\|", -1);
                    if (d.length < 11) continue;
                    if (!loggedUser.equals(d[4])) continue;  // buyerUsername is index 4

                    Map<String, String> bk = new HashMap<>();
                    bk.put("bookingId",     d[0]);
                    bk.put("propertyId",    d[1]);
                    bk.put("propertyTitle", d[2]);
                    bk.put("sellerName",    d[3]);
                    bk.put("buyerName",     d[5]);
                    bk.put("buyerEmail",    d[6]);
                    bk.put("buyerPhone",    d[7]);
                    bk.put("bookingDate",   d[8]);  // Start date
                    bk.put("returnDate",    d[9]);  // End date
                    bk.put("status",        d[10]);

                    // Use the property's own daily price as the penalty rate
                    double dailyRate = propertyPriceMap.getOrDefault(d[1].trim(), 100.0);
                    bk.put("dailyRate", String.format("%.2f", dailyRate));

                    double penalty = 0.0;
                    try {
                        java.time.LocalDate returnDate = java.time.LocalDate.parse(d[9], dtf);
                        if (!"COMPLETED".equalsIgnoreCase(d[10]) && today.isAfter(returnDate)) {
                            long daysOverdue = java.time.temporal.ChronoUnit.DAYS.between(returnDate, today);
                            penalty = daysOverdue * dailyRate;
                            bk.put("status", "OVERDUE");
                            bk.put("daysOverdue", String.valueOf(daysOverdue));
                        }
                    } catch (Exception ignored) {}
                    bk.put("penaltyFee", String.format("%.2f", penalty));

                    myBookings.add(bk);

                    // ENHANCEMENT 3: Add completed bookings to history
                    if ("COMPLETED".equalsIgnoreCase(d[10])) {
                        bookingHistory.add(bk);
                    }
                }
            } catch (Exception e) {
                System.err.println("Error reading bookings: " + e.getMessage());
            }
        }
        request.setAttribute("myBookings", myBookings);
        request.setAttribute("bookingHistory", bookingHistory); // ENHANCEMENT 3
        // ENHANCEMENT 3: Add booking statistics
        request.setAttribute("totalBookings", myBookings.size() + bookingHistory.size());
        request.setAttribute("activeBookings", myBookings.size());
        request.setAttribute("completedBookings", bookingHistory.size());
        // ─────────────────────────────────────────────────────────────────────────

        request.setAttribute("savedProperties", savedProperties);

        // ── ALL UNSOLD / AVAILABLE PROPERTIES (for the Replace dropdown) ──
        List<Property> availableProperties = new ArrayList<>();
        if (propFile.exists()) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(
                    Files.newInputStream(Paths.get(propFile.getAbsolutePath())), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty()) continue;
                    String[] data = line.split(",", -1);
                    // status is index 5 — skip "Sold" properties
                    if (data.length >= 6 && "Sold".equalsIgnoreCase(data[5].trim())) continue;
                    try {
                        Property p = null;
                        if (data.length >= 11) {
                            p = new Property(data[0], data[1], Double.parseDouble(data[2].trim()),
                                    data[3], data[4], data[5], data[6], data[7],
                                    Integer.parseInt(data[8].trim()), Integer.parseInt(data[9].trim()), data[10]);
                        } else if (data.length >= 10) {
                            p = new Property(data[0], data[1], Double.parseDouble(data[2].trim()),
                                    data[3], data[4], data[5], data[6], data[7],
                                    Integer.parseInt(data[8].trim()), Integer.parseInt(data[9].trim()), "");
                        } else if (data.length >= 8) {
                            p = new Property(data[0], data[1], Double.parseDouble(data[2].trim()),
                                    data[3], data[4], data[5], data[6], data[7], 0, 0, "");
                        }
                        if (p != null) availableProperties.add(p);
                    } catch (NumberFormatException ignored) {}
                }
            } catch (Exception e) {
                System.err.println("Error reading available properties: " + e.getMessage());
            }
        }
        request.setAttribute("availableProperties", availableProperties);

        // ── SELLER MESSAGES as Notifications (unread only) ────────────────
        List<Map<String, String>> allNotifications = new ArrayList<>();
        File messagesFileNotif = new File(getServletContext().getRealPath("/WEB-INF/inquiry_messages.tsv"));
        File readsFile         = new File(getServletContext().getRealPath("/WEB-INF/inquiry_reads.tsv"));

        if (threadsFile.exists() && messagesFileNotif.exists()) {
            // Build a threadId → thread-data map (all threads, not just buyer's)
            Map<String, String[]> allThreads = new HashMap<>();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(
                    Files.newInputStream(Paths.get(threadsFile.getAbsolutePath())), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty()) continue;
                    String[] data = line.split("\t", -1);
                    if (data.length >= 10) allThreads.put(data[0], data);
                }
            } catch (Exception ignored) {}

            // Load last-read timestamps: key = "user|threadId" → timestamp
            Map<String, String> lastRead = new HashMap<>();
            if (readsFile.exists()) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(
                        Files.newInputStream(Paths.get(readsFile.getAbsolutePath())), StandardCharsets.UTF_8))) {
                    String line;
                    while ((line = br.readLine()) != null) {
                        if (line.trim().isEmpty()) continue;
                        String[] r = line.split("\t", -1);
                        if (r.length >= 3) lastRead.put(r[0] + "|" + r[1], r[2]);
                    }
                } catch (Exception ignored) {}
            }

            // Scan messages — only show SELLER-sent messages where buyer is the receiver
            try (BufferedReader br = new BufferedReader(new InputStreamReader(
                    Files.newInputStream(Paths.get(messagesFileNotif.getAbsolutePath())), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty()) continue;
                    String[] msg = line.split("\t", -1);
                    if (msg.length < 5) continue;
                    String[] t = allThreads.get(msg[0]);
                    if (t == null) continue;

                    String senderRole = msg[2];
                    // Only interested in messages sent BY the SELLER to this buyer
                    if (!"SELLER".equalsIgnoreCase(senderRole)) continue;
                    String receiver = t[4]; // buyerAccount field
                    if (!loggedUser.equals(receiver)) continue;

                    // Skip if already read
                    String ts = msg[1];
                    String lr = lastRead.get(loggedUser + "|" + msg[0]);
                    if (lr != null && ts != null && ts.compareTo(lr) <= 0) continue;

                    String content = "";
                    try {
                        content = new String(Base64.getDecoder().decode(msg[4]), StandardCharsets.UTF_8);
                    } catch (Exception ignored) {}

                    Map<String, String> n = new HashMap<>();
                    n.put("sender",    t[3]);   // sellerName
                    n.put("receiver",  receiver);
                    n.put("content",   content);
                    n.put("propTitle", t[2]);   // propertyTitle
                    n.put("type",      "CHAT");
                    n.put("threadId",  t[0]);
                    allNotifications.add(n);
                }
            } catch (Exception ignored) {}
        }

        // ── ANNOUNCEMENTS as Notifications (unread only) ─────────────────
        Set<String> readAnnIds = loadReadAnnouncementIds(loggedUser);
        File annFile = new File(getServletContext().getRealPath("/WEB-INF/announcements.txt"));
        if (annFile.exists()) {
            try (BufferedReader br = new BufferedReader(new FileReader(annFile))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty()) continue;
                    String[] parts = line.split(",", 9); // Updated to 9 fields for new format
                    if (parts.length < 6) continue;

                    String annId = parts[0].trim();

                    // Skip if already read
                    if (readAnnIds.contains(annId)) continue;

                    // All announcements are shown to all users (no filtering by audience)
                    Map<String, String> n = new HashMap<>();
                    n.put("sender",    "System Administration");
                    n.put("receiver",  loggedUser);
                    n.put("title",     parts[1]);
                    n.put("content",   parts[2]);
                    n.put("priority",  parts[3]);
                    n.put("timestamp", parts[5]);
                    n.put("type",      "ANNOUNCEMENT");
                    n.put("threadId",  "");
                    allNotifications.add(n);
                }
            } catch (Exception e) {
                System.err.println("Error reading announcements: " + e.getMessage());
            }
        }
        request.setAttribute("allNotifications", allNotifications);

        request.getRequestDispatcher("/buyer_dashboard.jsp").forward(request, response);
    }

    // ── Load set of announcement IDs already read by this user ────────
    private Set<String> loadReadAnnouncementIds(String username) {
        Set<String> ids = new HashSet<>();
        try {
            String path = getServletContext().getRealPath("/WEB-INF/announcement_reads.txt");
            if (path == null) return ids;
            File f = new File(path);
            if (!f.exists()) return ids;
            try (BufferedReader br = new BufferedReader(new FileReader(f))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] parts = line.split(",", 2);
                    if (parts.length == 2 && parts[0].trim().equals(username)) {
                        ids.add(parts[1].trim());
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("BuyerDashboardServlet: error reading announcement_reads: " + e.getMessage());
        }
        return ids;
    }

}
