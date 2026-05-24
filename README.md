[README.md](https://github.com/user-attachments/files/27712987/README.md)
# 🏠 NESTIQ — Real Estate Portal

> A full-stack Java EE web application for browsing, listing, and managing real estate properties — built as a Group 32 OOP project.

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
- Secure admin registration via a unique licence key
- Session-based login/logout

### 🏡 Property Listings
- Add, update, and delete property listings (Sellers)
- Search and filter properties (Buyers)
- Mark properties as Sold
- Property types: House, Apartment, Villa

### 📅 Bookings
- Book property viewings (Buyers)
- Manage and update bookings
- Cancel or complete bookings
- Booking history and reports

### 💬 Inquiries & Messaging
- Submit inquiries on listings
- Threaded inquiry replies between Buyer and Seller
- Read/unread tracking per user

### ⭐ Reviews
- Submit and manage reviews on properties
- Verified and public review types
- Admin moderation (delete reviews)

### 🔖 Favourites
- Save and remove favourite properties
- Search saved properties (via Binary Search Tree)
- Sort saved listings

### 📢 Announcements
- Admin can post system-wide announcements
- Per-user read tracking

### 👑 Admin Dashboard
- Overview statistics: total users, buyers, sellers, admins, properties, market value
- User management (view, delete)
- Property management (view, delete)
- Review moderation
- Role management

### 🎨 UI/UX
- Dark / Light mode toggle
- Responsive design (mobile-friendly)
- Page transition animations

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 8 |
| Web Framework | Java Servlets + JSP |
| Frontend | HTML, CSS, JavaScript (vanilla) |
| Build Tool | Apache Maven |
| Server | Apache Tomcat 7/8 (via SmartTomcat) |
| Templating | JSTL 1.2 |
| Data Storage | Flat files (`.txt`, `.tsv`) |
| IDE | IntelliJ IDEA |

---

## Project Structure

```
src/
├── main/
│   ├── java/com/realestate/portal/
│   │   ├── controller/        # All Servlet controllers
│   │   │   ├── LoginServlet.java
│   │   │   ├── RegisterServlet.java
│   │   │   ├── PropertyServlet.java
│   │   │   ├── AdminDashboardServlet.java
│   │   │   ├── BuyerDashboardServlet.java
│   │   │   ├── SellerDashboardServlet.java
│   │   │   ├── BookPropertyServlet.java
│   │   │   ├── SearchServlet.java
│   │   │   ├── SearchSavedServlet.java   # Uses BST for search
│   │   │   ├── ReviewServlet.java
│   │   │   ├── SubmitInquiryServlet.java
│   │   │   └── ... (30+ servlets)
│   │   ├── model/             # Domain model classes
│   │   │   ├── User.java
│   │   │   ├── Property.java
│   │   │   ├── Reservation.java
│   │   │   ├── Review.java
│   │   │   ├── InquiryThread.java
│   │   │   └── InquiryMessage.java
│   │   └── service/
│   │       └── LoginService.java
│   └── webapp/
│       ├── index.jsp              # Landing / Registration / Login
│       ├── admin_dashboard.jsp
│       ├── buyer_dashboard.jsp
│       ├── seller_dashboard.jsp
│       ├── seller_home.jsp
│       ├── app.js                 # Main client-side logic
│       ├── page-transitions.js
│       ├── assets/images/         # Property type images
│       └── WEB-INF/
│           ├── web.xml
│           ├── announcements.jsp
│           └── *.txt / *.tsv      # Flat-file data store
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
| **Buyer** | Browse listings, book viewings, save favourites, submit inquiries, write reviews |
| **Seller** | List/manage properties, view bookings, respond to inquiries |
| **Admin** | Full access — manage all users, properties, reviews, and announcements |

### Admin Registration
During sign-up, select the **Admin** role and enter the admin licence key when prompted.

---

## Key Modules

### 🔍 Search (Binary Search Tree)
`SearchSavedServlet` uses a custom BST (`PropertyBST`) to efficiently search through a user's saved properties by title or keyword.

### 📊 Sorting
`SortSavedServlet` provides sorting of saved listings by price, date, or other criteria.

### 📋 Booking Lifecycle
Bookings flow through states: **Pending → Confirmed → Completed / Cancelled**, managed by dedicated servlets for each transition.

### 💬 Inquiry Threading
Inquiries are modelled as threads (`InquiryThread`) with individual messages (`InquiryMessage`), supporting back-and-forth conversations between buyer and seller.

---

## Data Storage

This project uses **flat-file persistence** (no external database required):

| File | Contents |
|---|---|
| `users.txt` | Registered user accounts |
| `properties.txt` | Property listings |
| `bookings.txt` | Booking records |
| `reviews.txt` | User reviews |
| `favorites.txt` | Saved favourites per user |
| `inquiry_threads.tsv` | Inquiry thread metadata |
| `inquiry_messages.tsv` | Individual inquiry messages |
| `announcements.txt` | Admin announcements |
| `sold_properties.txt` | Archive of sold listings |

All data files are stored under `src/main/webapp/WEB-INF/` and are not publicly accessible.

---

## Group

**Group 32** — OOP Project, 2026
