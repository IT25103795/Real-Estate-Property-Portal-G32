<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Buyer Dashboard - NESTIQ</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <style>
        /* ── PREMIUM NESTIQ VARIABLES ── */
        :root {
            --bg: #ffffff; --bg2: #f7f8fa; --ink: #0f1117; --line: #e8eaee;
            --accent: #1a56db; --font-sans: 'Outfit', sans-serif; --r: 10px;
            --green: #0d9e6e; --red: #e02828;
        }
        [data-theme="dark"] {
            --bg: #0f1117; --bg2: #1a1d27; --ink: #ffffff; --line: #232736;
        }
        body { font-family: var(--font-sans); background: var(--bg2); color: var(--ink); margin: 0; padding: 40px; transition: background 0.3s, color 0.3s; }

        .dashboard-container { max-width: 1100px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }

        .card { background: var(--bg); border: 1px solid var(--line); border-radius: var(--r); padding: 30px; margin-bottom: 30px; box-shadow: 0 4px 16px rgba(0,0,0,.04); }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .card-title { font-size: 1.2rem; font-weight: 600; margin: 0; }

        /* Forms & Toolbars */
        .toolbar { display: flex; gap: 15px; align-items: center; }
        input, select { padding: 10px 15px; border: 1.5px solid var(--line); border-radius: 6px; background: var(--bg); color: var(--ink); font-family: var(--font-sans); outline: none; transition: 0.2s; }
        input:focus, select:focus { border-color: var(--accent); }
        .btn { background: var(--accent); color: white; padding: 10px 20px; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .btn:hover { opacity: 0.9; }
        .btn-outline { background: transparent; border: 1.5px solid var(--line); color: var(--ink); }
        .btn-outline:hover { border-color: var(--accent); color: var(--accent); }

        /* The Data Table */
        table { width: 100%; border-collapse: collapse; text-align: left; font-size: 0.95rem; }
        th, td { padding: 16px; border-bottom: 1px solid var(--line); vertical-align: middle; }
        th { font-weight: 600; color: var(--ink); opacity: 0.7; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; }

        /* Thumbnail Image for Saved Properties */
        .prop-thumb { width: 60px; height: 45px; border-radius: 4px; object-fit: cover; }
        .prop-title-cell { display: flex; align-items: center; gap: 15px; font-weight: 500; }

        .status-badge { padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .badge-pending { background: rgba(26, 86, 219, 0.1); color: var(--accent); }
        .badge-viewed { background: rgba(13, 158, 110, 0.1); color: var(--green); }

        .btn-action { background: none; border: 1px solid var(--line); color: var(--ink); padding: 8px 12px; border-radius: 4px; cursor: pointer; font-size: 0.85rem; font-weight: 500; transition: 0.2s;}
        .btn-action:hover { border-color: var(--red); color: var(--red); }

        /* ── TELEGRAM STYLE THEME TOGGLE ── */
        .theme-switch {
            position: relative; width: 54px; height: 30px; background-color: var(--line);
            border-radius: 30px; cursor: pointer; display: flex; align-items: center;
            padding: 4px; transition: background-color 0.4s ease; box-sizing: border-box;
        }
        .theme-switch-thumb {
            width: 22px; height: 22px; background-color: white; border-radius: 50%;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2); display: flex; align-items: center;
            justify-content: center; font-size: 0.75rem;
            transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        [data-theme="dark"] .theme-switch { background-color: var(--accent); }
        [data-theme="dark"] .theme-switch-thumb { transform: translateX(24px); background-color: var(--bg2); }

        /* Container styling to match your dark theme */
        /* Container styling adapting to Light/Dark Mode */
                .profile-section {
                    background: var(--bg); /* Automatically shifts between light/dark background */
                    border: 1px solid var(--line); /* Adds a subtle, elegant outline */
                    box-shadow: 0 4px 16px rgba(0,0,0,.04); /* Soft shadow to lift it off the page */
                    padding: 25px;
                    border-radius: var(--r);
                    margin-bottom: 30px;
                    color: var(--ink); /* Automatically shifts text color */
                    max-width: 400px;
                }

                .profile-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 20px;
                }

                .profile-header h3 {
                    margin: 0;
                    font-size: 1.2rem;
                }

                /* Vertical stacking for the form */
                .form-group {
                    margin-bottom: 15px;
                    display: flex;
                    flex-direction: column;
                }

                .form-group label {
                    margin-bottom: 5px;
                    color: var(--ink4); /* Adaptive gray */
                    font-size: 0.85rem;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }

                /* 1. How it looks normally (Read-Only) */
                .readonly-input {
                    background-color: transparent;
                    border: 1px solid transparent;
                    color: var(--ink); /* Adaptive text */
                    font-size: 1rem;
                    padding: 5px 0;
                    outline: none;
                }

                /* 2. How it looks when editing */
                .editable-input {
                    background-color: var(--bg2); /* Adaptive input background */
                    border: 1px solid var(--line);
                    border-radius: 4px;
                    color: var(--ink); /* Adaptive text */
                    padding: 10px;
                    font-size: 1rem;
                    outline: none;
                }

                .editable-input:focus {
                    border-color: var(--accent); /* Nestiq Blue highlight when typing */
                }

        /* Button Styling */
        .edit-btn, .save-btn {
            background-color: #3b82f6;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.2s;
        }

        .edit-btn:hover, .save-btn:hover {
            background-color: #2563eb;
        }

        .save-btn {
            width: 100%;
            margin-top: 10px;
            background-color: #10b981; /* Green color for saving */
        }

        .save-btn:hover {
            background-color: #059669;
        }

    </style>
</head>
<body>

<div class="dashboard-container">
    <div class="header">
        <div>
            <h2 style="margin: 0; font-size: 1.8rem;">👋 Welcome back, ${sessionScope.loggedUser}</h2>
            <p style="margin: 5px 0 0 0; color: var(--ink); opacity: 0.7;">Ready to find your dream home in Sri Lanka?</p>
        </div>
        <div style="display: flex; align-items: center; gap: 15px;">
            <div class="theme-switch" onclick="toggleTheme()" title="Toggle Dark Mode">
                <div class="theme-switch-thumb" id="theme-toggle">🌙</div>
            </div>
            <button class="btn btn-outline" onclick="window.location.href='properties'">🏠 Browse Properties</button>
            <form action="logout" method="post" style="display:inline;">
                <button type="submit" class="btn" style="background: var(--red);">Logout</button>
            </form>
        </div>
    </div>

    <div class="profile-section">
        <div class="profile-header">
            <h3>Personal Information</h3>
            <button type="button" id="superEditBtn" class="edit-btn" onclick="toggleEditMode()">Edit</button>
        </div>

        <form action="UpdateProfileServlet" method="POST" id="profileForm">
            <input type="hidden" name="oldEmail" value="<%= session.getAttribute("loggedEmail") %>">

            <div class="form-group">
                <label>NAME</label>
                <input type="text" name="newName" value="<%= session.getAttribute("loggedUser") %>" readonly class="readonly-input">
            </div>

            <div class="form-group">
                <label>EMAIL</label>
                <input type="email" name="newEmail" value="<%= session.getAttribute("loggedEmail") %>" readonly class="readonly-input">
            </div>

            <div class="form-group" style="position: relative;">
                <label>PASSWORD</label>
                <input type="password" id="pwdInput" name="newPassword" value="<%= session.getAttribute("loggedPassword") %>" readonly class="readonly-input" style="padding-right: 35px;">

                <span onclick="togglePassword()" style="position: absolute; right: 10px; top: 32px; cursor: pointer; color: #a0aabf; transition: 0.2s;">
                    <svg id="eyeOpen" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                        <circle cx="12" cy="12" r="3"></circle>
                    </svg>
                    <svg id="eyeClosed" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display: none;">
                        <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
                        <line x1="1" y1="1" x2="23" y2="23"></line>
                    </svg>
                </span>
            </div>

            <button type="submit" id="saveProfileBtn" class="save-btn" style="display: none;">Save Changes</button>
        </form>
    </div>

    <div class="card">
        <div class="card-header">
            <h3 class="card-title">❤️ My Saved Properties</h3>

            <div class="toolbar">
                <form action="searchSaved" method="get" style="display: flex; gap: 8px;">
                    <input type="text" name="query" placeholder="Search by ID or City..." style="width: 200px;">
                    <button type="submit" class="btn btn-outline">🔍</button>
                </form>

                <form action="sortSaved" method="get">
                    <select name="sortOrder" onchange="this.form.submit()">
                        <option value="default">Sort by: Default</option>
                        <option value="priceLow">Price: Low to High (QuickSort)</option>
                        <option value="priceHigh">Price: High to Low (QuickSort)</option>
                    </select>
                </form>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Property</th>
                    <th>Location</th>
                    <th>Price</th>
                    <th>Type</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty savedProperties}">
                        <c:forEach var="p" items="${savedProperties}">
                            <tr>
                                <td class="prop-title-cell">
                                    <img src="${p.imageUrl}" class="prop-thumb" alt="House">
                                    <div>
                                        <div style="font-weight: 600;">${p.title}</div>
                                        <div style="font-size: 0.8rem; opacity: 0.7;">ID: ${p.id}</div>
                                    </div>
                                </td>
                                <td>📍 ${p.location}</td>
                                <td style="font-weight: 600; color: var(--accent);">$<fmt:formatNumber value="${p.price}" pattern="#,##0.00" /></td>
                                <td>${p.type}</td>
                                <td style="display: flex; gap: 10px; align-items: center;">
                                    <button class="btn" style="padding: 8px 15px; font-size: 0.85rem;" onclick="window.location.href='properties?viewId=${p.id}'">View</button>

                                    <form action="removeFavorite" method="post" style="margin: 0;">
                                        <input type="hidden" name="propertyId" value="${p.id}">
                                        <button type="submit" class="btn-action" style="padding: 8px 12px; font-size: 0.85rem; height: 100%;" onsubmit="return confirm('Remove this property from your saved list?');">❌ Remove</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="5" style="text-align:center; padding: 40px; color: var(--ink); opacity: 0.6;">You haven't saved any properties yet. Go browse the listings!</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <div class="card">
        <div class="card-header">
            <h3 class="card-title">💬 My Inquiries</h3>
        </div>
        <table>
            <thead>
                <tr>
                    <th>Sent To</th>
                    <th>Property Title</th>
                    <th>Date Sent</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty myInquiries}">
                        <c:forEach var="inq" items="${myInquiries}">
                            <tr>
                                <td><span style="font-weight: 500;">${inq.agentName}</span></td>
                                <td>${inq.propertyTitle}</td>
                                <td>${inq.date}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${inq.status == 'Pending'}"><span class="status-badge badge-pending">Pending Reply</span></c:when>
                                        <c:otherwise><span class="status-badge badge-viewed">Agent Responded</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="4" style="text-align:center; padding: 30px; color: var(--ink); opacity: 0.6;">No pending inquiries.</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<script>
    // Bulletproof direct function - customized for superEditBtn and emoji-free text!
    function toggleEditMode() {
        const btn = document.getElementById('superEditBtn'); // Ensure ID matches!
        const inputs = document.querySelectorAll('#profileForm input[type="text"], #profileForm input[type="email"], #profileForm input[type="password"]');
        const saveBtn = document.getElementById('saveProfileBtn');

        // Check if the save button is currently visible
        const isEditing = saveBtn.style.display === 'block';

        if (!isEditing) {
            // Switch TO Edit Mode
            inputs.forEach(input => {
                input.removeAttribute('readonly');
                input.classList.remove('readonly-input');
                input.classList.add('editable-input');
            });
            saveBtn.style.display = 'block';
            btn.innerHTML = 'Cancel'; // Emoji-free text!
            btn.style.backgroundColor = '#ef4444'; // Make button red
        } else {
            // Switch BACK to Read-Only Mode
            inputs.forEach(input => {
                input.setAttribute('readonly', true);
                input.classList.remove('editable-input');
                input.classList.add('readonly-input');
            });
            saveBtn.style.display = 'none';
            btn.innerHTML = 'Edit'; // Emoji-free text!
            btn.style.backgroundColor = '#3b82f6'; // Make button blue

            // Revert changes if they click cancel without saving
            document.getElementById('profileForm').reset();
        }
    }
    // Show/Hide Password Toggle
        function togglePassword() {
            const pwdInput = document.getElementById('pwdInput');
            const eyeOpen = document.getElementById('eyeOpen');
            const eyeClosed = document.getElementById('eyeClosed');

            // If it's currently hidden, reveal it!
            if (pwdInput.type === 'password') {
                pwdInput.type = 'text';
                eyeOpen.style.display = 'none';
                eyeClosed.style.display = 'block';
            }
            // If it's revealed, hide it!
            else {
                pwdInput.type = 'password';
                eyeOpen.style.display = 'block';
                eyeClosed.style.display = 'none';
            }
        }
</script>

<script src="app.js"></script>

</body>
</html>