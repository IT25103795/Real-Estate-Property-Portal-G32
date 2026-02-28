<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.realestate.portal.model.User" %>
<%
    // Get the user object from the session
    User user = (User) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("index.jsp"); // Security: Boot them out if not logged in
    }
%>
<html>
<head>
    <title>NESTIQ — Dashboard</title>
    <style>
        body { font-family: 'Outfit', sans-serif; padding: 50px; text-align: center; }
        .welcome-card { border: 1px solid #e8eaee; padding: 40px; border-radius: 16px; box-shadow: 0 4px 16px rgba(0,0,0,.08); }
        h1 { color: #1a56db; }
    </style>
</head>
<body>
    <div class="welcome-card">
        <h1>Welcome back, <%= (user != null) ? user.getUsername() : "Guest" %>!</h1>
        <p>You are logged in as: <strong><%= (user != null) ? user.getRole() : "" %></strong></p>
        <hr>
        <p>This is the central hub for Group G32's Real Estate Portal.</p>
        <a href="index.jsp">Logout</a>
    </div>
</body>
</html>