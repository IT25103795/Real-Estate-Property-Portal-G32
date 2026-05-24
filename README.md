# 🏠 NESTIQ — Real Estate Portal

> A full-stack Java EE web application for browsing, listing, and managing real estate properties — built as a Group 32 OOP project.
>
> **Latest Update:** May 2026 - Enhanced with premium dark theme, advanced booking system, inquiry messaging, seller analytics, and comprehensive admin dashboard.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [User Roles](#user-roles)
- [Key Modules](#key-modules)
- [Data Storage](#data-storage)
- [Screenshots](#screenshots)

---

## Overview

NESTIQ is a real estate web portal where users can register as **Buyers** or **Sellers** (or **Admins**) to browse property listings, book viewings, submit inquiries, write reviews, save favourites, and manage their own listings — all within a clean, dark/light mode responsive UI.

---

## Features

### 👤 Authentication & Roles
- User registration with role selection (Buyer / Seller / Admin)
- Secure admin registration via unique license key: `436FD - 7UH5R - F12W3 - 8HY5R`
- Session-based login/logout with role-based access control
- Profile management with update functionality

### 🏡 Property Listings
- Add, update, and delete property listings (Sellers)
- Advanced search and filter by location, type, price range (Buyers)
- Mark properties as Sold or For Rent
- Property types: House, Apartment, Villa
- Premium amenities support for Villas
- Property view tracking and analytics
- Automatic rental expiry and restoration

### 📅 Bookings & Rentals
- Book property viewings and rentals (Buyers)
- Manage and update bookings with date changes
- Cancel bookings with seller notifications
- Complete bookings with automatic payment processing
- Overdue detection with penalty fee calculation
- Rental expiry tracking with automatic restoration
- Booking history and detailed reports
- Real-time countdown timers for active rentals

### 💬 Inquiries & Messaging
- Submit inquiries on property listings
- Threaded inquiry system with back-and-forth conversations
- Base64-encoded message content for security
- Read/unread tracking per user with notification badges
- Real-time notification system for new messages
- Inquiry status management (Open/Closed)

### ⭐ Reviews & Ratings
- Submit verified and public reviews on properties
- Star rating system (1-5 stars)
- Admin moderation (delete inappropriate reviews)
- Review display on seller dashboards
- Verified buyer review badges

### 🔖 Favorites & Saved Properties
- Save and remove favorite properties
- Binary Search Tree (BST) implementation for efficient searching
- Sort saved listings by price, date, or title
- Bulk removal of favorites
- Replace favorites with other properties

### 📢 Announcements & Notifications
- Admin can post system-wide announcements with priority levels
- Per-user read tracking with persistent storage
- Notification badge counters in dashboards
- Role-based announcement filtering
- Real-time notification updates

### 👑 Admin Dashboard
- Comprehensive statistics: total users, buyers, sellers, admins, properties, market value
- User management (view, delete, role-based filtering)
- Property management (view, delete, status tracking)
- Review moderation and deletion
- Announcement broadcasting system
- Booking oversight and reporting
- Sold properties archive management
- System-wide earnings tracking

### 🎨 UI/UX Enhancements
- Premium dark/light mode toggle with localStorage persistence
- Responsive design (mobile-friendly across all devices)
- Smooth page transition animations
- Professional gradient effects and shadows
- Telegram-style notification badges
- Modern card-based layouts with hover effects
- Sticky navigation and sidebars
- Custom scrollbar styling

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 8 |
| Web Framework | Java Servlets + JSP |
| Frontend | HTML5, CSS3, JavaScript (vanilla) |
| Build Tool | Apache Maven 3.x |
| Server | Apache Tomcat 7/8 (via SmartTomcat) |
| Templating | JSTL 1.2 |
| Data Storage | Flat files (`.txt`, `.tsv`) with UTF-8 encoding |
| IDE | IntelliJ IDEA |
| Chart Library | Chart.js 4.4.0 |
| Fonts | Google Fonts (Outfit, Playfair Display, DM Mono)

---

## Project Structure

```
src/
├── main/
│   ├── java/com/realestate/portal/
│   │   ├── controller/        # All Servlet controllers (40+ servlets)
│   │   │   ├── LoginServlet.java
│   │   │   ├── RegisterServlet.java
│   │   │   ├── PropertyServlet.java
│   │   │   ├── AdminDashboardServlet.java
│   │   │   ├── AdminAnnouncementServlet.java
│   │   │   ├── BuyerDashboardServlet.java
│   │   │   ├── SellerDashboardServlet.java
│   │   │   ├── SellerAnalyticsServlet.java
│   │   │   ├── BookPropertyServlet.java
│   │   │   ├── UpdateBookingServlet.java
│   │   │   ├── CancelBookingServlet.java
│   │   │   ├── CompleteBookingServlet.java
│   │   │   ├── ConfirmBookingServlet.java
│   │   │   ├── SearchServlet.java
│   │   │   ├── SearchSavedServlet.java   # Uses BST for search
│   │   │   ├── SortSavedServlet.java
│   │   │   ├── ReviewServlet.java
│   │   │   ├── DeleteReviewServlet.java
│   │   │   ├── SubmitInquiryServlet.java
│   │   │   ├── ReplyInquiryServlet.java
│   │   │   ├── MarkInquiryReadServlet.java
│   │   │   ├── SaveFavoriteServlet.java
│   │   │   ├── RemoveFavoriteServlet.java
│   │   │   ├── ReplaceFavoriteServlet.java
│   │   │   ├── BulkRemoveFavoriteServlet.java
│   │   │   ├── MarkAsSoldServlet.java
│   │   │   ├── UpdateProfileServlet.java
│   │   │   ├── RentalExpiryCheckerServlet.java
│   │   │   └── ... (and more)
│   │   ├── model/             # Domain model classes
│   │   │   ├── User.java
│   │   │   ├── Property.java
│   │   │   ├── Reservation.java
│   │   │   ├── Review.java
│   │   │   ├── PublicReview.java
│   │   │   ├── VerifiedReview.java
│   │   │   ├── InquiryThread.java
│   │   │   ├── InquiryMessage.java
│   │   │   └── PaymentRecord.java
│   │   └── service/
│   │       └── LoginService.java
│   └── webapp/
│       ├── index.jsp              # Landing / Registration / Login
│       ├── admin_dashboard.jsp    # Admin control panel
│       ├── buyer_dashboard.jsp    # Buyer dashboard
│       ├── seller_dashboard.jsp   # Seller dashboard
│       ├── seller_home.jsp        # Seller home page
│       ├── seller_analytics.jsp   # Seller analytics
│       ├── announcements.jsp      # Announcements page
│       ├── app.js                 # Main client-side logic
│       ├── page-transitions.js    # Page animation system
│       ├── assets/images/         # Property type images
│       ├── images/                # Background images
│       └── WEB-INF/
│           ├── web.xml
│           ├── users.txt          # User accounts
│           ├── properties.txt     # Property listings
│           ├── bookings.txt       # Booking records
│           ├── reviews.txt        # User reviews
│           ├── favorites.txt      # Saved favorites
│           ├── inquiry_threads.tsv # Inquiry thread metadata
│           ├── inquiry_messages.tsv # Individual messages (Base64)
│           ├── inquiry_reads.tsv  # Read tracking
│           ├── announcements.txt  # Admin announcements
│           ├── announcement_reads.txt # Announcement read status
│           ├── sold_properties.txt # Sold property archive
│           ├── payments.txt       # Payment records
│           ├── property_views.txt # View tracking
│           ├── availability_report.txt # Auto-generated reports
│           └── booking_report.txt # Booking reports
pom.xml
```

---

## Getting Started

### Prerequisites
- **Java 8** or higher
- **Apache Maven** 3.x
- **Apache Tomcat** 8.x (or use the bundled SmartTomcat IntelliJ plugin)
- **IntelliJ IDEA** (recommended)

### Run Locally

1. **Clone the repository**
   ```bash
   git clone https://github.com/IT25103795/Real-Estate-Property-Portal-G32.git
   cd OOP-PROJECT
   ```

2. **Build with Maven**
   ```bash
   mvn clean package
   ```

3. **Deploy to Tomcat**
   - Copy the generated `target/RealEstatePortal_G32.war` to your Tomcat `webapps/` directory, **or**
   - Use the IntelliJ SmartTomcat plugin (pre-configured in `.smarttomcat/`)

4. **Access the app**
   ```
   http://localhost:8080/RealEstatePortal_G32
   ```

---

## User Roles

| Role | Access |
|---|---|
| **Buyer** | Browse listings, book viewings/rentals, save favorites, submit inquiries, write reviews, manage bookings, receive notifications |
| **Seller** | List/manage properties, view bookings, respond to inquiries, track analytics, manage earnings, confirm/complete bookings |
| **Admin** | Full access — manage all users, properties, reviews, announcements, monitor system-wide statistics and earnings |

### Admin Registration
During sign-up, select the **Admin** role (👑) and enter the admin license key when prompted:
```
436FD - 7UH5R - F12W3 - 8HY5R
```

---

## Key Modules

### 🔍 Search (Binary Search Tree)
`SearchSavedServlet` uses a custom BST (`PropertyBST`) to efficiently search through a user's saved properties by title or keyword. This provides O(log n) search performance for large favorite lists.

### 📊 Sorting & Filtering
`SortSavedServlet` provides sorting of saved listings by price, date, or title. Advanced filtering options include location, property type, and dynamic price ranges.

### 📋 Booking Lifecycle
Bookings flow through states: **Pending → Confirmed → Reserved → Completed / Cancelled**, managed by dedicated servlets for each transition. The system includes:
- Automatic overdue detection with penalty fee calculation
- Real-time countdown timers for active rentals
- Rental expiry tracking with automatic property restoration
- Payment record generation for completed transactions

### 💬 Inquiry Threading
Inquiries are modelled as threads (`InquiryThread`) with individual messages (`InquiryMessage`), supporting back-and-forth conversations between buyer and seller. Messages are Base64-encoded for security and include read/unread tracking.

### 📈 Seller Analytics
The `SellerAnalyticsServlet` provides comprehensive performance metrics including:
- Property views, inquiries, favorites, and bookings counts
- Total earnings from sold properties and rental fees
- Penalty fee tracking for overdue rentals
- Availability report generation

### ⏰ Rental Expiry System
`RentalExpiryCheckerServlet` automatically monitors rental bookings and restores expired rental properties to "Available" status, ensuring accurate inventory management.

### 🎨 Theme Management
Premium dark/light mode implementation with:
- Telegram-style toggle buttons
- localStorage persistence across sessions
- Smooth CSS transitions between themes
- Professional gradient effects and shadows in dark mode

---

## Data Storage

This project uses **flat-file persistence** with UTF-8 encoding (no external database required):

| File | Contents | Format |
|---|---|---|
| `users.txt` | Registered user accounts (BUYER, SELLER, ADMIN) | CSV |
| `properties.txt` | Property listings with status tracking | CSV |
| `bookings.txt` | Booking records with lifecycle states | Pipe-delimited |
| `reviews.txt` | User reviews (Public/Verified types) | CSV |
| `favorites.txt` | Saved favorites per user | CSV |
| `inquiry_threads.tsv` | Inquiry thread metadata | TSV |
| `inquiry_messages.tsv` | Individual inquiry messages (Base64 encoded) | TSV |
| `inquiry_reads.tsv` | Read status tracking per user/thread | TSV |
| `announcements.txt` | Admin announcements with priority levels | CSV |
| `announcement_reads.txt` | Per-user announcement read tracking | CSV |
| `sold_properties.txt` | Archive of sold listings | Pipe-delimited |
| `payments.txt` | Payment records with fee breakdowns | Pipe-delimited |
| `property_views.txt` | Property view tracking | Pipe-delimited |
| `availability_report.txt` | Auto-generated availability reports | Text |
| `booking_report.txt` | Comprehensive booking reports | Text |

All data files are stored under `src/main/webapp/WEB-INF/` and are not publicly accessible.

---

## Recent Enhancements (2026)

### 🎨 Premium UI/UX
- **Dark Mode Enhancement**: Professional dark theme with vibrant purple accents, deep space backgrounds, and enhanced shadows
- **Light Mode Refinement**: Clean modern interface with royal blue palette and premium gradients
- **Responsive Design**: Mobile-first approach ensuring seamless experience across all devices
- **Animation System**: Smooth page transitions, hover effects, and micro-interactions

### 💰 Advanced Booking & Payment System
- **Rental Fee Calculation**: Dynamic pricing based on daily rates × rental duration
- **Penalty System**: Automatic overdue detection with per-day penalty fees
- **Payment Records**: Detailed fee breakdowns (rental fees + penalty fees)
- **Booking Reports**: Auto-generated comprehensive booking and availability reports

### 📊 Analytics & Reporting
- **Seller Dashboard**: Real-time performance metrics and earnings tracking
- **Admin Overview**: System-wide statistics and user management
- **Property Analytics**: View counts, inquiry rates, favorite saves, booking conversions
- **Earnings Calculation**: Multi-method calculation from sold properties and rentals

### 🔔 Notification System
- **Real-time Badges**: Unread message and announcement counters
- **Multi-channel**: Chat messages, system announcements, booking updates
- **Read Tracking**: Persistent read status across sessions
- **Priority Levels**: High/Medium/Low priority for announcements

### 🔐 Security Enhancements
- **Base64 Encoding**: All inquiry messages encoded for security
- **Session Validation**: Role-based access control on all protected routes
- **Admin Key Protection**: Secure license key validation for admin registration
- **Data Isolation**: All sensitive data stored in WEB-INF directory

---

## Group

**Group 32** — OOP Project, 2026

### Team Members
- IT25103795 (Project Lead)

---

## License

This project is developed as part of the Object-Oriented Programming course curriculum.

---

## Acknowledgments

- Google Fonts for premium typography (Outfit, Playfair Display, DM Mono)
- Chart.js for analytics visualization
- Apache Tomcat for servlet container
- JSTL for JSP templating
