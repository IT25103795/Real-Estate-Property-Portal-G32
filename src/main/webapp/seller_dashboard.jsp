<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Seller Dashboard - NESTIQ</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <style>
        /* Reusing your slick NESTIQ variables */
        :root {
            --bg: #ffffff; --bg2: #f7f8fa; --ink: #0f1117; --line: #e8eaee;
            --accent: #1a56db; --font-sans: 'Outfit', sans-serif; --r: 10px;
        }
        [data-theme="dark"] {
            --bg: #0f1117; --bg2: #1a1d27; --ink: #ffffff; --line: #232736;
        }
        body { font-family: var(--font-sans); background: var(--bg2); color: var(--ink); margin: 0; padding: 40px; transition: background 0.3s, color 0.3s; }

        .dashboard-container { max-width: 1000px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }

        .card { background: var(--bg); border: 1px solid var(--line); border-radius: var(--r); padding: 30px; margin-bottom: 30px; box-shadow: 0 4px 16px rgba(0,0,0,.04); }
        .card-title { font-size: 1.2rem; font-weight: 600; margin-bottom: 20px; margin-top: 0; }

        /* Forms & Buttons */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        label { font-size: 0.85rem; font-weight: 500; }
        input, select { padding: 10px; border: 1.5px solid var(--line); border-radius: 6px; background: var(--bg); color: var(--ink); font-family: var(--font-sans); outline: none; }
        input:focus, select:focus { border-color: var(--accent); }
        .btn { background: var(--accent); color: white; padding: 10px 20px; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .btn:hover { opacity: 0.9; }

        /* The Data Table */
        table { width: 100%; border-collapse: collapse; text-align: left; font-size: 0.9rem; }
        th, td { padding: 14px; border-bottom: 1px solid var(--line); }
        th { font-weight: 600; color: var(--accent); }
        .btn-edit { background: none; border: 1px solid var(--accent); color: var(--accent); padding: 6px 12px; border-radius: 4px; cursor: pointer; font-size: 0.8rem; }
        .btn-edit:hover { background: var(--accent); color: white; }

        /* The Edit Modal */
        .modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.6); display: none; align-items: center; justify-content: center; z-index: 1000; }
        .modal-overlay.open { display: flex; }
        .modal-box { background: var(--bg); padding: 30px; border-radius: var(--r); width: 100%; max-width: 500px; }
        .close-btn { float: right; cursor: pointer; font-weight: bold; font-size: 1.2rem; color: var(--ink); }

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
    </style>
</head>
<body data-theme="light" id="body-theme">

<div class="dashboard-container">
    <div class="header">
            <h2>👋 Welcome, ${sessionScope.loggedUser}</h2>
            <div style="display: flex; align-items: center; gap: 15px;">

                <div class="theme-switch" onclick="toggleTheme()" title="Toggle Dark Mode">
                    <div class="theme-switch-thumb" id="theme-toggle">🌙</div>
                </div>

                <button class="btn" onclick="window.location.href='index.jsp'" style="background: var(--line); color: var(--ink);">🏠 Go to Homepage</button>
                <form action="logout" method="post" style="display:inline;">
                    <button type="submit" class="btn" style="background: #e02828;">Logout</button>
                </form>
            </div>
    </div>

    <div class="card">
        <h3 class="card-title">List a New Property</h3>
        <p style="color: #0d9e6e; font-weight: bold;">${successMessage}</p>
        <form action="addProperty" method="post" class="form-grid">
            <div class="form-group"><label>Property Title</label><input type="text" name="title" required></div>
            <div class="form-group"><label>Price ($)</label><input type="number" name="price" required></div>
            <div class="form-group"><label>Location / City</label><input type="text" name="location" required></div>
            <div class="form-group"><label>Type</label>
                <select name="type"><option>Apartment</option><option>House</option><option>Villa</option></select>
            </div>
            <div class="form-group"><label>Status</label>
                <select name="status"><option>For Sale</option><option>For Rent</option></select>
            </div>
            <div class="form-group" style="display: flex; align-items: flex-end;">
                <button type="submit" class="btn" style="width: 100%;">➕ Add Property</button>
            </div>
        </form>
    </div>

    <div class="card">
        <h3 class="card-title">My Managed Properties</h3>
        <table>
            <thead>
                <tr><th>ID</th><th>Title</th><th>Price</th><th>Location</th><th>Type</th><th>Actions</th></tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty myProperties}">
                        <c:forEach var="p" items="${myProperties}">
                            <tr>
                                <td><small>${p.id}</small></td>
                                <td>${p.title}</td>
                                <td>$${p.price}</td>
                                <td>${p.location}</td>
                                <td>${p.type}</td>
                                <td style="display: flex; gap: 8px;">
                                   <button class="btn-edit" onclick="openEditModal('${p.id}', '${p.title}', '${p.price}', '${p.location}', '${p.type}', '${p.status}')">✏️ Edit</button>

                                   <form action="deleteProperty" method="post" style="margin: 0;" onsubmit="return confirm('Are you absolutely sure you want to delete this property? This cannot be undone!');">
                                       <input type="hidden" name="propertyId" value="${p.id}">
                                       <button type="submit" class="btn-edit" style="color: var(--red); border-color: var(--red);">🗑️ Delete</button>
                                   </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="6" style="text-align:center;">You haven't listed any properties yet.</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<div class="modal-overlay" id="editModal">
    <div class="modal-box">
        <span class="close-btn" onclick="closeEditModal()">×</span>
        <h3 class="card-title">Update Property</h3>
        <form action="updateProperty" method="post" style="display: flex; flex-direction: column; gap: 16px;">
            <input type="hidden" name="propertyId" id="edit-id">

            <div class="form-group"><label>Title</label><input type="text" name="title" id="edit-title" required></div>
            <div class="form-group"><label>Price ($)</label><input type="number" name="price" id="edit-price" required></div>
            <div class="form-group"><label>Location</label><input type="text" name="location" id="edit-location" required></div>
            <div class="form-grid">
                <div class="form-group"><label>Type</label>
                    <select name="type" id="edit-type"><option>Apartment</option><option>House</option><option>Villa</option></select>
                </div>
                <div class="form-group"><label>Status</label>
                    <select name="status" id="edit-status"><option>For Sale</option><option>For Rent</option></select>
                </div>
            </div>
            <button type="submit" class="btn">💾 Save Changes</button>
        </form>
    </div>
</div>

<script src="app.js"></script>
<script>
    function openEditModal(id, title, price, location, type, status) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-title').value = title;
        document.getElementById('edit-price').value = price;
        document.getElementById('edit-location').value = location;
        document.getElementById('edit-type').value = type;
        document.getElementById('edit-status').value = status;
        document.getElementById('editModal').classList.add('open');
    }

    function closeEditModal() {
        document.getElementById('editModal').classList.remove('open');
    }
</script>

</body>
</html>