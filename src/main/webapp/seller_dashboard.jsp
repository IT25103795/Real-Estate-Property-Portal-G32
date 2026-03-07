<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- SECURITY CHECK: Kick out anyone who isn't a Seller --%>
<%
String role = (String) session.getAttribute("loggedRole");
if (role == null || !"SELLER".equalsIgnoreCase(role)) {
response.sendRedirect("properties"); // Send them away!
return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Seller Dashboard — NESTIQ</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <style>
        :root {
          --ink: #0f1117; --ink2: #2a2d35; --ink3: #5a5f70; --line: #e8eaee;
          --bg: #ffffff; --bg2: #f7f8fa; --accent: #1a56db; --green: #0d9e6e;
          --font-sans: 'Outfit', sans-serif; --font-serif: 'Playfair Display', serif;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: var(--font-sans); background: var(--bg2); color: var(--ink); display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar { width: 260px; background: var(--bg); border-right: 1px solid var(--line); padding: 24px; display: flex; flex-direction: column; }
        .logo { font-family: var(--font-serif); font-size: 1.5rem; font-weight: 700; color: var(--accent); margin-bottom: 40px; }
        .nav-btn { display: block; width: 100%; text-align: left; padding: 12px 16px; margin-bottom: 8px; border-radius: 8px; border: none; background: transparent; font-family: var(--font-sans); font-size: 1rem; font-weight: 500; color: var(--ink3); cursor: pointer; transition: 0.2s; }
        .nav-btn:hover { background: var(--bg2); color: var(--ink); }
        .nav-btn.active { background: rgba(26,86,219,0.1); color: var(--accent); font-weight: 600; }
        .logout-form { margin-top: auto; }
        .logout-btn { width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--line); background: transparent; color: #e02828; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .logout-btn:hover { background: #e02828; color: white; border-color: #e02828; }

        /* Main Content */
        .main-content { flex: 1; padding: 40px; overflow-y: auto; max-width: 1000px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        .title { font-size: 1.8rem; font-weight: 700; }
        .user-badge { background: var(--bg); padding: 8px 16px; border-radius: 99px; border: 1px solid var(--line); font-weight: 600; font-size: 0.9rem; color: var(--green); }

        /* Form Container */
        .form-box { background: var(--bg); border: 1px solid var(--line); border-radius: 12px; padding: 32px; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
        .form-box h3 { font-family: var(--font-serif); font-size: 1.4rem; margin-bottom: 24px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { margin-bottom: 16px; }
        .form-group.full-width { grid-column: span 2; }
        label { display: block; font-size: 0.85rem; font-weight: 600; color: var(--ink2); margin-bottom: 6px; }
        input, select, textarea { width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--line); background: var(--bg2); font-family: var(--font-sans); font-size: 0.95rem; transition: 0.2s; }
        input:focus, select:focus, textarea:focus { outline: none; border-color: var(--accent); background: white; }
        .submit-btn { background: var(--accent); color: white; border: none; padding: 14px 24px; border-radius: 8px; font-size: 1rem; font-weight: 600; cursor: pointer; width: 100%; margin-top: 10px; transition: 0.2s; }
        .submit-btn:hover { background: #1041b0; }

        .success-msg { color: var(--green); font-weight: 600; margin-bottom: 20px; text-align: center; }

        /* ── DARK MODE OVERRIDES ── */
        [data-theme="dark"] {
          --bg:       #0f1117;
          --bg2:      #1a1d27;
          --bg3:      #232736;
          --ink:      #ffffff;
          --ink2:     #e8eaee;
          --ink3:     #9198a8;
          --ink4:     #5a5f70;
          --line:     #232736;
          --line2:    #2d3243;
        }
        [data-theme="dark"] .sidebar, [data-theme="dark"] .form-box,
        [data-theme="dark"] .stat-card, [data-theme="dark"] .data-box {
          background: var(--bg);
        }
        [data-theme="dark"] input, [data-theme="dark"] select, [data-theme="dark"] textarea {
          background: var(--bg2);
          color: var(--ink);
        }
        [data-theme="dark"] th, [data-theme="dark"] td {
          border-bottom-color: var(--line);
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="logo">NESTIQ Seller</div>
    <button class="nav-btn active">➕ Add Property</button>
    <button class="nav-btn" onclick="window.location.href='properties'">🏠 View All Listings</button>
    <button class="nav-btn" id="theme-toggle" onclick="toggleTheme()">🌙 Toggle Theme</button>

    <form action="logout" method="post" class="logout-form">
        <button type="submit" class="logout-btn">Logout</button>
    </form>
</div>

<div class="main-content">
    <div class="header">
        <h1 class="title">Seller Dashboard</h1>
        <div class="user-badge">💼 Logged in as: ${sessionScope.loggedUser}</div>
    </div>

    <div class="form-box">
        <h3>List a New Property</h3>

        <c:if test="${not empty successMessage}">
            <div class="success-msg">✓ ${successMessage}</div>
        </c:if>

        <form action="addProperty" method="post">
            <div class="form-grid">

                <div class="form-group full-width">
                    <label>Property Title</label>
                    <input type="text" name="title" placeholder="e.g. Luxury Oceanview Villa" required />
                </div>

                <div class="form-group">
                    <label>Price ($)</label>
                    <input type="number" name="price" placeholder="e.g. 450000" required />
                </div>

                <div class="form-group">
                    <label>Location (City)</label>
                    <input type="text" name="location" placeholder="e.g. Miami" required />
                </div>

                <div class="form-group">
                    <label>Property Type</label>
                    <select name="type" required>
                        <option value="House">House</option>
                        <option value="Apartment">Apartment</option>
                        <option value="Villa">Villa</option>
                        <option value="Studio">Studio</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Listing Status</label>
                    <select name="status" required>
                        <option value="Sale">For Sale</option>
                        <option value="Rent">For Rent</option>
                    </select>
                </div>

            </div>

            <button type="submit" class="submit-btn">Publish Listing →</button>
        </form>
    </div>
</div>
<script src="app.js"></script>

</body>
</html>