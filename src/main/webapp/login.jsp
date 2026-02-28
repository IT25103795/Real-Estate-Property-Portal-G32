<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Real Estate Portal - Login</title>
</head>
<body>
    <h2>Login to Property Portal</h2>
    <p style="color: red;">${errorMessage}</p> <form action="login" method="post">
        Username: <input type="text" name="username" required><br><br>
        Password: <input type="password" name="password" required><br><br>
        <button type="submit">Login</button>
    </form>
</body>
</html>