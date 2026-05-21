package com.realestate.portal.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet("/completeBooking")
public class CompleteBookingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final DateTimeFormatter DTF = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session  = request.getSession(false);
        String loggedUser    = (session != null) ? (String) session.getAttribute("loggedUser") : null;
        String loggedRole    = (session != null) ? (String) session.getAttribute("loggedRole") : null;

        if (loggedUser == null || !"SELLER".equalsIgnoreCase(loggedRole)) {
            response.sendRedirect("login");
            return;
        }

        String bookingId = request.getParameter("bookingId");
        if (bookingId == null || bookingId.trim().isEmpty()) {
            response.sendRedirect("sellerDashboard?error=missing_id");
            return;
        }

        String bookingsPath = getServletContext().getRealPath("/WEB-INF/bookings.txt");
        File   bookingsFile = new File(bookingsPath);

        List<String> updatedLines      = new ArrayList<>();
        boolean      found             = false;
        String completedPropId         = null;
        String completedPropTitle      = null;
        String completedBuyerName      = null;
        String completedStartDate      = null;
        String completedEndDate        = null;
        double dailyRate               = 100.0;

        // Build property price map
        String propPath = getServletContext().getRealPath("/WEB-INF/properties.txt");
        java.util.Map<String, Double> priceMap = new java.util.HashMap<>();
        File propFile = new File(propPath);
        if (propFile.exists()) {
            try (BufferedReader pr = new BufferedReader(
                    new InputStreamReader(Files.newInputStream(propFile.toPath()), StandardCharsets.UTF_8))) {
                String pl;
                while ((pl = pr.readLine()) != null) {
                    if (pl.trim().isEmpty() || pl.trim().startsWith("#")) continue;
                    String[] pd = pl.split(",", -1);
                    if (pd.length >= 3) {
                        try { priceMap.put(pd[0].trim(), Double.parseDouble(pd[2].trim())); }
                        catch (NumberFormatException ignored) {}
                    }
                }
            } catch (Exception ignored) {}
        }

        if (bookingsFile.exists()) {
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(Files.newInputStream(bookingsFile.toPath()), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty() || line.trim().startsWith("#")) {
                        updatedLines.add(line);
                        continue;
                    }
                    String[] d = line.split("\\|", -1);
                    if (d.length >= 11 && d[0].equals(bookingId) && d[3].equals(loggedUser)) {
                        completedPropId    = d[1].trim();
                        completedPropTitle = d[2].trim();
                        completedBuyerName = d[5].trim();
                        completedStartDate = d[8].trim();
                        completedEndDate   = d[9].trim();
                        dailyRate          = priceMap.getOrDefault(completedPropId, 100.0);
                        d[10] = "COMPLETED";
                        updatedLines.add(String.join("|", d));
                        found = true;
                    } else {
                        updatedLines.add(line);
                    }
                }
            }
        }

        if (found) {
            // Persist bookings
            try (PrintWriter pw = new PrintWriter(
                    new OutputStreamWriter(
                            Files.newOutputStream(bookingsFile.toPath(),
                                    StandardOpenOption.WRITE, StandardOpenOption.TRUNCATE_EXISTING),
                            StandardCharsets.UTF_8))) {
                for (String l : updatedLines) pw.println(l);
            }

            // Check if any OTHER active bookings still reference this property
            boolean otherActiveExists = false;
            for (String l : updatedLines) {
                if (l.trim().isEmpty() || l.trim().startsWith("#")) continue;
                String[] d = l.split("\\|", -1);
                if (d.length >= 11
                        && d[1].trim().equals(completedPropId)
                        && !d[0].equals(bookingId)
                        && !"COMPLETED".equalsIgnoreCase(d[10])
                        && !"CANCELLED".equalsIgnoreCase(d[10])) {
                    otherActiveExists = true;
                    break;
                }
            }

            // Restore property to "For Rent" if no other active bookings remain
            if (!otherActiveExists && completedPropId != null) {
                restorePropertyToForRent(completedPropId);
            }

            // Calculate and log earnings + create payment record
             if (completedPropId != null) {
                 appendEarningsToReport(request,
                         bookingId, completedPropId, completedPropTitle,
                         loggedUser, completedBuyerName,
                         completedStartDate, completedEndDate, dailyRate);

                 // Create payment record with rental fee + penalty fee
                 createPaymentRecord(request, bookingId, completedPropId, loggedUser,
                         completedStartDate, completedEndDate, dailyRate);
             }
        }

        response.sendRedirect("sellerDashboard?completed=success");
    }

    /** Restores a rental property that was marked Sold back to "For Rent" (Available). */
    private void restorePropertyToForRent(String propertyId) {
        try {
            String propPath = getServletContext().getRealPath("/WEB-INF/properties.txt");
            File   propFile = new File(propPath);
            if (!propFile.exists()) return;

            List<String> lines   = new ArrayList<>();
            boolean      updated = false;

            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(Files.newInputStream(propFile.toPath()), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) {
                    String[] d = line.split(",", -1);
                    if (d.length >= 6 && d[0].trim().equals(propertyId)
                            && "Sold".equalsIgnoreCase(d[5].trim())) {
                        d[5] = "For Rent";
                        lines.add(String.join(",", d));
                        updated = true;
                    } else {
                        lines.add(line);
                    }
                }
            }

            if (updated) {
                try (PrintWriter pw = new PrintWriter(
                        new OutputStreamWriter(
                                Files.newOutputStream(propFile.toPath(),
                                        StandardOpenOption.WRITE, StandardOpenOption.TRUNCATE_EXISTING),
                                StandardCharsets.UTF_8))) {
                    for (String l : lines) pw.println(l);
                }
                System.out.println("🔓 Property [" + propertyId + "] restored to 'For Rent'.");
            }
        } catch (Exception e) {
            System.err.println("CompleteBookingServlet: error restoring property: " + e.getMessage());
        }
    }

    /** Calculates rental earnings and appends a record to booking_report.txt. */
    private void appendEarningsToReport(HttpServletRequest request,
                                        String bookingId, String propertyId, String propertyTitle,
                                        String sellerName, String buyerName,
                                        String startDateStr, String endDateStr,
                                        double dailyRate) {
        try {
            LocalDate start        = LocalDate.parse(startDateStr, DTF);
            LocalDate today        = LocalDate.now();
            
            // Calculate days from start date to TODAY (when seller clicks Complete)
            long daysRented   = ChronoUnit.DAYS.between(start, today) + 1;
            if (daysRented <= 0) daysRented = 1;

            // Calculate overdue days based on original end date
            LocalDate end          = LocalDate.parse(endDateStr, DTF);
            long   overduedays   = today.isAfter(end) ? ChronoUnit.DAYS.between(end, today) : 0;
            
            // Total earned = actual days rented × daily rate
            double totalEarned   = daysRented * dailyRate;

            String reportPath = getServletContext().getRealPath("/WEB-INF/booking_report.txt");
            try (PrintWriter rw = new PrintWriter(
                    new OutputStreamWriter(new FileOutputStream(reportPath, true), StandardCharsets.UTF_8))) {
                rw.println("=========================================================");
                rw.println("  BOOKING COMPLETED — " + today.format(DTF));
                rw.println("=========================================================");
                rw.println("  Booking ID    : " + bookingId);
                rw.println("  Property      : " + propertyTitle + "  [" + propertyId + "]");
                rw.println("  Seller        : " + sellerName);
                rw.println("  Buyer Name    : " + buyerName);
                rw.println("  Rental Start  : " + startDateStr);
                rw.println("  Original End  : " + endDateStr);
                rw.println("  Completed On  : " + today.format(DTF));
                rw.println("  Days Rented   : " + daysRented + " day(s) (from start to completion)");
                rw.println("  Daily Rate    : LKR " + String.format("%.2f", dailyRate));
                if (overduedays > 0) {
                    rw.println("  Overdue Days  : " + overduedays + " (beyond original end date)");
                }
                rw.println("  ─────────────────────────────────────────────────────");
                rw.println("  TOTAL EARNED  : LKR " + String.format("%.2f", totalEarned));
                rw.println("  Property Status → Restored to 'For Rent' (Available)");
                rw.println();
            }
            System.out.println("Earnings recorded: LKR " + String.format("%.2f", totalEarned) + " for booking " + bookingId);
         } catch (Exception e) {
             System.err.println("CompleteBookingServlet: error writing earnings report: " + e.getMessage());
         }
     }

     /** Creates a payment record with rental fee + penalty fee breakdown. */
     private void createPaymentRecord(HttpServletRequest request,
                                     String bookingId, String propertyId, String sellerId,
                                     String startDateStr, String endDateStr,
                                     double dailyRate) {
         try {
             LocalDate start        = LocalDate.parse(startDateStr, DTF);
             LocalDate end          = LocalDate.parse(endDateStr,   DTF);
             LocalDate today        = LocalDate.now();

              // Calculate rental fee based on ACTUAL days from start to completion date
              long daysRented  = ChronoUnit.DAYS.between(start, today) + 1;
              if (daysRented <= 0) daysRented = 1;
              double rentalFee = daysRented * dailyRate;

             // Calculate penalty fee (only if completed after original end date)
             long overduedays = today.isAfter(end) ? ChronoUnit.DAYS.between(end, today) : 0;
             double penaltyFee = overduedays > 0 ? overduedays * dailyRate : 0.0;

             // Total amount = rental fee + penalty fee
             double totalAmount = rentalFee + penaltyFee;

             // Generate unique payment ID
             String paymentId = "PAY-" + System.currentTimeMillis() + "-" + UUID.randomUUID().toString().substring(0, 8);

             // Create payment record
             String paymentLine = String.join("|",
                     paymentId,
                     bookingId,
                     propertyId,
                     sellerId,
                     String.format("%.2f", rentalFee),
                     String.format("%.2f", penaltyFee),
                     String.format("%.2f", totalAmount),
                     "PAID",
                     today.format(DTF),
                     endDateStr
             );

             // Append to payments.txt
             String paymentsPath = getServletContext().getRealPath("/WEB-INF/payments.txt");
             try (PrintWriter pw = new PrintWriter(
                     new OutputStreamWriter(
                             new FileOutputStream(paymentsPath, true),
                             StandardCharsets.UTF_8))) {
                 pw.println(paymentLine);
             }

             System.out.println("✅ Payment record created: " + paymentId +
                     " | Days: " + daysRented +
                     " | Rental: LKR " + String.format("%.2f", rentalFee) +
                     " | Penalty: LKR " + String.format("%.2f", penaltyFee) +
                     " | Total: LKR " + String.format("%.2f", totalAmount));
         } catch (Exception e) {
             System.err.println("CompleteBookingServlet: error creating payment record: " + e.getMessage());
         }
     }
 }
