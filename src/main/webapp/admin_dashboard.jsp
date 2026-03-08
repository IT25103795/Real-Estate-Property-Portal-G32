<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- SECURITY CHECK: Kick out anyone who isn't an Admin --%>
<%
String role = (String) session.getAttribute("loggedRole");
if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
response.sendRedirect("properties"); // Send them away!
return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Admin Dashboard — NESTIQ</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <style>
        :root {
          --ink: #0f1117; --ink2: #2a2d35; --ink3: #5a5f70; --line: #e8eaee;
          --bg: #ffffff; --bg2: #f7f8fa; --accent: #1a56db; --red: #e02828;
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
        .logout-btn { width: 100%; padding: 12px; border-radius: 8px; border: 1px solid var(--line); background: transparent; color: var(--red); font-weight: 600; cursor: pointer; transition: 0.2s; }
        .logout-btn:hover { background: var(--red); color: white; border-color: var(--red); }

        /* Main Content */
        .main-content { flex: 1; padding: 40px; overflow-y: auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        .title { font-size: 1.8rem; font-weight: 700; }

        /* Dashboard Cards */
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; margin-bottom: 40px; }
        .stat-card { background: var(--bg); border: 1px solid var(--line); border-radius: 12px; padding: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
        .stat-title { font-size: 0.85rem; color: var(--ink3); text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
        .stat-value { font-size: 2rem; font-weight: 700; color: var(--ink); }

        /* Data Table */
        .data-box { background: var(--bg); border: 1px solid var(--line); border-radius: 12px; padding: 24px; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
        .data-box h3 { margin-bottom: 20px; font-size: 1.2rem; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th, td { padding: 14px; border-bottom: 1px solid var(--line); }
        th { font-size: 0.85rem; color: var(--ink3); text-transform: uppercase; letter-spacing: 0.5px; }
        td { font-size: 0.95rem; font-weight: 500; }
        .action-btn { background: var(--red); color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 0.8rem; cursor: pointer; }
        .action-btn:hover { opacity: 0.9; }

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
    <div class="logo">NESTIQ Admin</div>
    <button class="nav-btn active">📊 Dashboard</button>
    <button class="nav-btn" onclick="document.querySelector('.data-box').scrollIntoView({ behavior: 'smooth' });">👥 Manage Users</button>
    <button class="nav-btn" onclick="window.location.href='index.jsp'">🏠 Manage Properties</button>
    <button class="nav-btn" id="theme-toggle" onclick="toggleTheme()">🌙 Toggle Theme</button>

    <form action="logout" method="post" class="logout-form">
        <button type="submit" class="logout-btn">Logout</button>
    </form>
</div>

<div class="main-content">
    <div class="header">
        <h1 class="title">System Overview</h1>

        <div style="display: flex; gap: 15px; align-items: center;">
            <button class="btn" onclick="window.location.href='index.jsp'" style="background: #e8eaee; color: #0f1117; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 600;">🏠 Go to Homepage</button>
            <span class="god-mode-badge" style="background: #eef2ff; color: #1a56db; padding: 8px 16px; border-radius: 50px; font-weight: 600; display: flex; align-items: center; gap: 6px;">
                🛡️ God Mode: ${sessionScope.loggedUser}
            </span>
        </div>

    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-title">Total Users</div>
            <div class="stat-value">${totalUsers}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Total Properties</div>
            <div class="stat-value">${totalProperties}</div>
        </div>
        <div class="stat-card">
            <div class="stat-title">Active Reports</div>
            <div class="stat-value" style="color: var(--red);">2</div>
        </div>
    </div>

    <div class="data-box">
        <h3>Recent Registered Users</h3>
        <table>
            <thead>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
                <c:forEach var="u" items="${userList}">
                     <tr>
                         <td>${u[1]}</td>
                         <td>${u[2]}</td>
                         <td style="font-weight: 600;">${u[0]}</td>
                         <td>
                             <form action="deleteUser" method="post" style="margin: 0;" onsubmit="return confirm('Are you sure you want to permanently delete this user?');">
                                  <input type="hidden" name="userEmail" value="${u[2]}">
                                  <button type="submit" class="action-btn">Delete</button>
                             </form>
                         </td>
                     </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<script src="app.js"></script>

</body>
</html>