<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Seller Dashboard - NESTIQ</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <style>
        /* Reusing your slick NESTIQ variables */
        :root {
            --bg: #ffffff; --bg2: #f7f8fa; --ink: #0f1117; --line: #e8eaee;
            --accent: #1a56db; --font-sans: 'Outfit', sans-serif; --r: 10px;
            --green: #0d9e6e; --red: #e02828;
        }
        [data-theme="dark"] {
            --bg: #111827; --bg2: #1f2937; --ink: #f9fafb; --line: #374151;
            --accent: #3b82f6; --green: #10b981; --red: #ef4444;
        }
        body { font-family: var(--font-sans); background: var(--bg2); color: var(--ink); margin: 0; padding: 30px; transition: background 0.3s, color 0.3s; }

        .dashboard-container { max-width: 1600px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }

        /* ── ENHANCED STAT CARDS ── */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }
        .stat-card {
            background: var(--bg);
            border: 1px solid var(--line);
            border-radius: var(--r);
            padding: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,.04);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--accent);
        }
        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,.08);
        }
        .stat-card.green::before { background: var(--green); }
        .stat-card.red::before { background: var(--red); }
        .stat-card.amber::before { background: #f59e0b; }

        .stat-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            margin-bottom: 12px;
        }
        .stat-icon.blue { background: rgba(26,86,219,0.1); }
        .stat-icon.green { background: rgba(13,158,110,0.1); }
        .stat-icon.red { background: rgba(224,40,40,0.1); }
        .stat-icon.amber { background: rgba(245,158,11,0.1); }

        .stat-value {
            font-size: 1.85rem;
            font-weight: 700;
            color: var(--ink);
            line-height: 1;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 0.8rem;
            color: var(--ink);
            opacity: 0.6;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .card {
            background: var(--bg);
            border: 1px solid var(--line);
            border-radius: var(--r);
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 4px 16px rgba(0,0,0,.04);
            transition: box-shadow 0.3s ease, transform 0.3s ease;
            box-sizing: border-box;
            width: 100%;

        }
        [data-theme="dark"] .card {
            box-shadow: 0 4px 20px rgba(0,0,0,0.3), 0 0 0 1px rgba(255,255,255,0.05);
        }
        .card:hover {
            box-shadow: 0 6px 20px rgba(0,0,0,.08);
        }
        [data-theme="dark"] .card:hover {
            box-shadow: 0 8px 30px rgba(0,0,0,0.4), 0 0 0 1px rgba(255,255,255,0.08);
            transform: translateY(-2px);
        }
        .card-title {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 20px;
            margin-top: 0;
            padding-bottom: 14px;
            border-bottom: 2px solid var(--line);
        }

        /* Forms & Buttons */
        .form-grid { display: grid; gap: 14px; }
        .form-group { display: flex; flex-direction: column; gap: 5px; }
        label { font-size: 0.82rem; font-weight: 600; }
        input, select, textarea {
            padding: 9px 11px;
            border: 1.5px solid var(--line);
            border-radius: 6px;
            background: var(--bg);
            color: var(--ink);
            font-family: var(--font-sans);
            outline: none;
            transition: all 0.2s;
            font-size: 0.9rem;
        }
        input:focus, select:focus, textarea:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(26,86,219,0.1);
        }
        .btn {
            background: var(--accent);
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            box-shadow: 0 2px 8px rgba(26,86,219,0.2);
            font-size: 0.85rem;
        }
        [data-theme="dark"] .btn {
            box-shadow: 0 2px 12px rgba(59,130,246,0.3);
        }
        .btn:hover {
            opacity: 0.9;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(26,86,219,0.3);
        }
        [data-theme="dark"] .btn:hover {
            box-shadow: 0 4px 16px rgba(59,130,246,0.4);
        }
        .btn:active {
            transform: translateY(0);
        }

        /* The Data Table */
        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            border-radius: var(--r);
            width: 100%;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }
        th, td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--line);
            white-space: nowrap;
            vertical-align: middle;
            text-align: left;
        }
        th {
            font-weight: 600;
            color: var(--ink);
            opacity: 0.75;
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            background: var(--bg2);
            position: sticky;
            top: 0;
            text-align: left;
        }
        [data-theme="dark"] th {
            background: rgba(31,41,55,0.8);
            opacity: 0.85;
        }
        tbody tr {
            transition: background-color 0.15s ease;
        }
        tbody tr:hover {
            background-color: rgba(26,86,219,0.03);
        }
        [data-theme="dark"] tbody tr:hover {
            background-color: rgba(59,130,246,0.08);
        }
        .btn-edit {
            background: none;
            border: 1.5px solid var(--accent);
            color: var(--accent);
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 0.78rem;
            font-weight: 600;
            transition: all 0.2s;
        }
        .btn-edit:hover {
            background: var(--accent);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 3px 10px rgba(26,86,219,0.25);
        }
        .badge-sold {
            display: inline-block;
            background: rgba(13,158,110,0.12);
            color: #0d9e6e;
            border: 1px solid rgba(13,158,110,0.35);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.78rem;
            font-weight: 700;
            white-space: nowrap;
        }

        /* Responsive layout for stats + inquiries */
        @media (max-width: 1200px) {
            .stats-inquiries-row {
                grid-template-columns: 1fr !important;
            }
        }

        /* The Edit Modal */
        .modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.6); display: none; align-items: center; justify-content: center; z-index: 1000; }
        .modal-overlay.open { display: flex; }
        .modal-box { overflow: scroll; height: 550px; background: var(--bg); padding: 30px; border-radius: var(--r); width: 100%; max-width: 500px; }
        .close-btn { float: right; cursor: pointer; font-weight: bold; font-size: 1.2rem; color: var(--ink); }
        .modal-box::-webkit-scrollbar {display: none;}

        /* Container styling to match your dark theme */
        /* Container styling adapting to Light/Dark Mode */
        .profile-section {
            background: var(--bg); /* Automatically shifts between light/dark background */
            /*border: 1px solid var(--line); !* Adds a subtle, elegant outline *!*/
            box-shadow: 0 4px 16px rgba(0,0,0,.04); /* Soft shadow to lift it off the page */
            padding: 25px;
            border-radius: var(--r);
            margin-bottom: 30px;
            /*margin-left: 80px; !* More push to right to give stats more left space *!*/
            color: var(--ink); /* Automatically shifts text color */
            max-width: 380px;
            min-width: 340px;
            display: block;
        }

        /* ── SELLER STATS ROW (profile + stats side-by-side) ── */
        .seller-top-row {
            display: flex;
            gap: 20px;
            align-items: flex-start;
            margin: auto;
            flex-wrap: wrap;
            width: 80%;
            justify-content: space-between;
        }
        .seller-top-row .profile-section {
            margin-bottom: 30px;
            flex-shrink: 0;
        }
        .seller-stats-panel {
            flex: 1;
            min-width: 220px;
            display: flex;
            flex-direction: column;
            gap: 14px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: var(--bg);
            border: 1px solid var(--line);
            border-radius: var(--r);
            box-shadow: 0 4px 16px rgba(0,0,0,.04);
            padding: 18px 22px;
            display: flex;
            align-items: center;
            gap: 16px;
            transition: all 0.3s ease;
            min-height: 80px;
        }
        [data-theme="dark"] .stat-card {
            box-shadow: 0 4px 20px rgba(0,0,0,0.25), 0 0 0 1px rgba(255,255,255,0.03);
            border-color: rgba(255,255,255,0.08);
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }
        [data-theme="dark"] .stat-card:hover {
            box-shadow: 0 8px 28px rgba(0,0,0,0.35), 0 0 0 1px rgba(255,255,255,0.06);
            border-color: rgba(255,255,255,0.12);
        }
        .stat-icon {
            font-size: 1.6rem;
            flex-shrink: 0;
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .stat-icon.total   { background: rgba(26,86,219,0.10); }
        .stat-icon.booked  { background: rgba(245,158,11,0.12); }
        .stat-icon.done    { background: rgba(13,158,110,0.12); }
        .stat-info { display: flex; flex-direction: column; gap: 2px; min-width: 0; flex: 1; }
        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            line-height: 1.2;
            color: var(--ink);
            word-break: break-all;
            overflow-wrap: break-word;
        }
        .stat-label {
            font-size: 0.78rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            opacity: 0.55;
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

        .account-tab button{
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #0d9e6e;
            border: none;
            transition: background-color 0.3s ease-in-out;
            color: whitesmoke;

        }
        .account-tab button:hover{
            background: #0c7652;
        }
        .fa-regular{
            display: flex;
        }

        /* ── INQUIRY CHAT MODAL (WhatsApp-like) ── */
        .chat-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.6); display: none; align-items: center; justify-content: center; z-index: 1200; padding: 18px; }
        .chat-overlay.open { display: flex; }
        .chat-box { background: var(--bg); border: 1px solid var(--line); border-radius: var(--r); width: 100%; max-width: 920px; height: min(78vh, 620px); box-shadow: 0 20px 70px rgba(0,0,0,.25); overflow: hidden; display: grid; grid-template-columns: 320px 1fr; }
        .chat-left { border-right: 1px solid var(--line); background: var(--bg2); padding: 18px; overflow-y: auto; }
        .chat-right { display: flex; flex-direction: column; height: 100%; min-height: 0; }
        .chat-top { padding: 16px 18px; border-bottom: 1px solid var(--line); display: flex; align-items: center; justify-content: space-between; gap: 10px; }
        .chat-peer { display: flex; align-items: center; gap: 10px; }
        .avatar { width: 34px; height: 34px; border-radius: 50%; background: var(--line); display: flex; align-items: center; justify-content: center; color: var(--ink); font-weight: 700; }
        .peer-name { font-weight: 700; }
        .peer-sub { font-size: 0.8rem; opacity: 0.75; }
        .chat-msgs { flex: 1; padding: 18px; overflow-y: auto; background: var(--bg); min-height: 0; }
        .bubble { max-width: 72%; padding: 10px 12px; border-radius: 12px; margin: 8px 0; border: 1px solid var(--line); }
        .bubble-left { background: var(--bg2); margin-right: auto; border-top-left-radius: 6px; }
        .bubble-right { background: rgba(26,86,219,0.10); margin-left: auto; border-top-right-radius: 6px; }
        .bubble-meta { font-size: 0.72rem; opacity: 0.75; margin-bottom: 4px; }
        .chat-compose { border-top: 1px solid var(--line); padding: 12px; display: flex; gap: 10px; background: var(--bg2); }
        .chat-input { flex: 1; resize: none; min-height: 42px; max-height: 110px; padding: 10px 12px; border-radius: 8px; border: 1.5px solid var(--line); background: var(--bg); color: var(--ink); }
        .chat-send { background: var(--accent); color: white; padding: 10px 16px; border-radius: 8px; font-weight: 700; }

        /* Small right-side scroll bar (chat messages) */
        .chat-msgs { scrollbar-width: thin; scrollbar-color: rgba(145,152,168,.8) transparent; }
        .chat-msgs::-webkit-scrollbar { width: 6px; }
        .chat-msgs::-webkit-scrollbar-track { background: transparent; }
        .chat-msgs::-webkit-scrollbar-thumb { background: rgba(145,152,168,.75); border-radius: 10px; }
        .chat-msgs::-webkit-scrollbar-thumb:hover { background: rgba(145,152,168,.95); }

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

            <!-- ── ANNOUNCEMENTS BUTTON ── -->
            <div style="position: relative; display: inline-flex;">
                <button class="btn" onclick="window.location.href='announcements'"
                        id="announcements-tab-btn"
                        title="View Official Announcements"
                        style="background:var(--line); color:var(--ink); display:flex; align-items:center; gap:6px;
                                   transition: all 0.2s;">
                    📢 Announcements
                </button>
                <span id="ann-tab-count"
                      style="position: absolute; top: -6px; right: -6px; background: #e02828;
                                 color: white; border-radius: 50%; font-size: 0.65rem; font-weight: 700;
                                 min-width: 18px; height: 18px; display: none; align-items: center;
                                 justify-content: center; padding: 0 4px; line-height: 1;
                                 pointer-events: none; box-shadow: 0 2px 8px rgba(224,40,40,0.3);"></span>
            </div>

            <!-- Bell Notifications (same as homepage) -->
            <div class="nav-notif" id="bell-container" onclick="toggleNotif(event)" style="position: relative; cursor: pointer; margin-right: 2px; display:flex; align-items:center;">
                <span class="notif-icon" style="font-size: 1.5rem;">🔔</span>
                <div id="notif-count" class="notif-badge" style="position:absolute; top:-5px; right:-5px; background:#e02828; color:white; font-size:0.65rem; padding:2px 6px; border-radius:10px; font-weight:bold; border:2px solid var(--bg); display:none;">0</div>
                <div class="notif-panel" id="notif-panel" style="position:absolute; top:120%; right:0; width:320px; background:var(--bg); border:1px solid var(--line); border-radius:16px; box-shadow:0 32px 80px rgba(0,0,0,.16); display:none; z-index:2000; overflow:hidden;">
                    <div class="notif-header" style="padding:16px; border-bottom:1px solid var(--line); font-weight:700; font-size:0.95rem; background:var(--bg2);">Notifications</div>
                    <div id="notif-list" style="max-height:350px; overflow-y:auto;">
                        <p style="padding: 20px; text-align: center; color: rgba(0,0,0,.45); font-size: 0.85rem;">No new messages</p>
                    </div>
                    <div class="notif-footer" style="padding:12px; text-align:center; font-size:0.8rem; color:var(--accent); background:var(--bg2); border-top:1px solid var(--line);">Nestiq Secure Messaging</div>
                </div>
            </div>

            <button class="btn" onclick="window.location.href='sellerAnalytics'" style="background: rgba(26,86,219,0.1); color: var(--accent); border-color: rgba(26,86,219,0.3);">📊 Analytics</button>
            <button class="btn" onclick="window.location.href='properties'" style="background: var(--line); color: var(--ink);">🏠 Go to Homepage</button>
            <div class="account-tab"><button id="openBtn" ><i class="fa-regular fa-circle-user fa-2xl"></i></button></div>
            <form action="logout" method="post" style="display:inline;">
                <button type="submit" class="btn" style="background: #e02828;">Logout</button>
            </form>
        </div>
    </div>

    <!-- ── SELLER TOP ROW: Personal Info + Stats Cards ── -->
    <div class="seller-top-row">


        <!-- ── STATS + INQUIRIES ROW ─────────────────────────────────────── -->
        <div class="stats-inquiries-row" style="grid-template-columns: 1fr 400px; gap: 20px; margin-bottom: 24px; width: 100%">

            <!-- Left: Stat Cards -->
            <div class="stats-grid" style="margin-bottom: 0;">
                <div class="stat-card">
                    <div class="stat-icon blue">🏠</div>
                    <div class="stat-value">${not empty myProperties ? myProperties.size() : 0}</div>
                    <div class="stat-label">Total Properties</div>
                </div>

                <div class="stat-card amber">
                    <div class="stat-icon amber">📋</div>
                    <div class="stat-value">${not empty activeBookings ? activeBookings.size() : 0}</div>
                    <div class="stat-label">Active Bookings</div>
                </div>

                <div class="stat-card green">
                    <div class="stat-icon green">✅</div>
                    <div class="stat-value">${not empty soldCount ? soldCount : 0}</div>
                    <div class="stat-label">Sold Properties</div>
                </div>

                <div class="stat-card red">
                    <div class="stat-icon red">💰</div>
                    <div class="stat-value">LKR <fmt:formatNumber value="${not empty totalEarnings ? totalEarnings : 0}" pattern="#,##0"/></div>
                    <div class="stat-label">Total Earnings</div>
                </div>

                <!-- Total Penalty Fees Card -->
                <div class="stat-card" style="--card-accent:#8b5cf6;">
                    <div class="stat-icon" style="background:rgba(239,68,68,0.10);">⚠️</div>
                    <div class="stat-value">LKR <fmt:formatNumber value="${not empty totalPenaltyFees ? totalPenaltyFees : 0}" pattern="#,##0"/></div>
                    <div class="stat-label">Total Penalty Fees</div>
                </div>

                <div class="stat-card" style="--card-accent:#8b5cf6;">
                    <div class="stat-icon" style="background:rgba(139,92,246,0.10);">👁️</div>
                    <div class="stat-value">${not empty analyticsViews ? analyticsViews : 0}</div>
                    <div class="stat-label">Total Listing Views</div>
                </div>
                <div class="stat-card" style="--card-accent:#f59e0b;">
                    <div class="stat-icon" style="background:rgba(245,158,11,0.10);">📩</div>
                    <div class="stat-value">${not empty analyticsInquiries ? analyticsInquiries : 0}</div>
                    <div class="stat-label">Total Inquiries</div>
                </div>
                <div class="stat-card" style="--card-accent:#0d9e6e;">
                    <div class="stat-icon" style="background:rgba(13,158,110,0.10);">📋</div>
                    <div class="stat-value">${not empty analyticsBookings ? analyticsBookings : 0}</div>
                    <div class="stat-label">Total Bookings</div>
                </div>
                <div class="stat-card" style="--card-accent:#ec4899;">
                    <div class="stat-icon" style="background:rgba(236,72,153,0.10);">❤️</div>
                    <div class="stat-value">${not empty analyticsFavorites ? analyticsFavorites : 0}</div>
                    <div class="stat-label">Times Saved by Buyers</div>
                </div>
            </div>

            <!-- Right: Buyer Inquiries Card -->
            <div class="card" style="margin-bottom: 0; margin-top: 20px; padding: 20px;">
                <h3 class="card-title" style="font-size: 1.1rem; margin-bottom: 16px; padding-bottom: 12px;">📩 Buyer Inquiries</h3>

                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <select id="inqSelect" style="width: 100%; min-width: unset;">
                        <option value="">Select an inquiry...</option>
                        <c:forEach var="t" items="${sellerThreads}">
                            <option value="${t.id}">${t.buyerName} — ${t.propertyTitle}</option>
                        </c:forEach>
                    </select>

                    <button class="btn" type="button" onclick="openInquiryFromSelect()" style="width: 100%;">Open Inquiry</button>

                    <div style="margin-top: 8px; color: var(--ink); opacity: 0.7; font-size: 0.82rem; line-height: 1.5;">
                        <c:choose>
                            <c:when test="${empty sellerThreads}">
                                <div style="text-align: center; padding: 16px 0; opacity: 0.6;">
                                    <div style="font-size: 2rem; margin-bottom: 8px;">💬</div>
                                    <div>No inquiries yet</div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="padding: 10px; background: var(--bg2); border-radius: 6px; border-left: 3px solid var(--accent);">
                                    💡 Tip: Select an inquiry above to view the conversation and reply to buyers.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

        <!-- ─────────────────────────────────────────────────────────────── -->
        <!--Profile-section -->
        <div id="myModal" style="display:none; position:fixed; z-index:1; left:0; top:0; width:100%; height:100%; background-color:rgba(0,0,0,0.4);">
            <div style="background-color:#111827; margin: 120px auto; padding:40px; width:fit-content; border-radius:10px; box-shadow: 8px 8px 25px black;">
                <span id="closeBtn" style="cursor:pointer; float:right;"><i class="fa-solid fa-xmark"></i></span>
                <p> </p><br>
                <div class="profile-section">
                    <div class="profile-header">
                        <h3>Personal Information</h3>
                        <button type="button" id="superEditBtn" class="edit-btn" onclick="toggleEditMode()">Edit</button>
                    </div>

                    <form action="UpdateProfileServlet" method="POST" id="profileForm">
                        <input type="hidden" name="oldEmail" value="<%= session.getAttribute("loggedEmail") %>">

                        <div class="form-group">
                            <label style="color: var(--ink); opacity: 0.6; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 5px;">NAME</label>
                            <input type="text" name="newName" value="<%= session.getAttribute("loggedUser") %>" readonly class="readonly-input">
                        </div>

                        <div class="form-group" style="margin-top: 15px;">
                            <label style="color: var(--ink); opacity: 0.6; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 5px;">EMAIL</label>
                            <input type="email" name="newEmail" value="<%= session.getAttribute("loggedEmail") %>" readonly class="readonly-input">
                        </div>

                        <div class="form-group" style="position: relative; margin-top: 15px;">
                            <label style="color: var(--ink); opacity: 0.6; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 5px;">PASSWORD</label>
                            <input type="password" id="pwdInput" name="newPassword" value="<%= session.getAttribute("loggedPassword") %>" readonly class="readonly-input" style="padding-right: 35px; width: 100%; box-sizing: border-box;">

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

                    <c:if test="${param.profile == 'success'}">
                        <div style="background: rgba(13,158,110,0.1); border: 1px solid #0d9e6e; color: #0d9e6e; padding: 12px 16px; border-radius: 8px; margin-top: 15px; font-weight: 600; text-align: center;">
                            ✅ Profile credentials updated successfully!
                        </div>
                    </c:if>
                    <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid var(--line); text-align: center;">
                        <form action="DeleteAccountServlet" method="POST" style="margin: 0;" onsubmit="return confirm('⚠️ WARNING: Are you absolutely sure you want to permanently delete your account? This action cannot be undone and you will lose all saved properties.');">
                            <input type="hidden" name="userEmail" value="<%= session.getAttribute("loggedEmail") %>">
                            <button type="submit" style="background: transparent; color: var(--red); border: 2px solid red; width: 250px; height: 30px; border-radius: 8px; font-size: 0.85rem; font-weight: 600; cursor: pointer;">
                                Delete My Account
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!--end profilesection -->
    </div>

        <!-- Clearfix for flex row -->
        <div style="clear: both; width: 100%;"></div>

        <div class="card">
            <h3 class="card-title">List a New Property</h3>
            <p style="color: #0d9e6e; font-weight: bold;">${successMessage}</p>
            <form action="addProperty" method="post" class="form-grid">
                <div class="form-group"><label>Property Title</label><input type="text" name="title" required></div>
                <div class="form-group"><label id="add-price-label">Price (LKR)</label><input type="number" name="price" required></div>
                <div class="form-group"><label>Location / City</label><input type="text" name="location" required></div>
                <div class="form-group"><label>Type</label>
                    <select name="type"><option>Apartment</option><option>House</option><option>Villa</option></select>
                </div>
                <div class="form-group"><label>Bed Rooms</label><input type="number" name="bedrooms" min="0" required></div>
                <div class="form-group"><label>Bath Tubs</label><input type="number" name="bathrooms" min="0" required></div>
                <div class="form-group"><label>Status</label>
                    <select name="status" id="add-status-select" onchange="updatePriceLabel('add')" required>
                        <option value=""selected >Choose a Ststus</option>
                        <option>For Sale</option>
                        <option>For Rent</option>
                    </select>
                </div>
                <div class="form-group"><label>Description</label><textarea name="description" rows="6" style="resize: none;"></textarea></div>
                <button type="submit" class="btn" style="width: 30%; margin: 20px auto"><i class="fa-solid fa-plus"></i> Add Property</button>
            </form>
        </div>

        <div class="card">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px; padding-bottom: 14px; border-bottom: 2px solid var(--line);">
                <h3 class="card-title" style="margin:0; padding-bottom: 0; border-bottom: none;">🏠 My Managed Properties</h3>
                <span style="font-size:0.85rem; opacity:0.65; background: var(--bg2); padding: 6px 14px; border-radius: 20px; border: 1px solid var(--line);">
                ${not empty myProperties ? myProperties.size() : 0} Total Properties
            </span>
            </div>
            <div class="table-responsive">
                <table>
                    <thead>
                    <tr>
                        <th style="width: 60px;">ID</th>
                        <th>Title</th>
                        <th style="width: 120px;">Price</th>
                        <th>Location</th>
                        <th style="width: 100px;">Type</th>
                        <th style="width: 70px;">Beds</th>
                        <th style="width: 70px;">Baths</th>
                        <th style="width: 120px;">Status</th>
                        <th style="width: 280px;">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty myProperties}">
                            <c:forEach var="p" items="${myProperties}">
                                <tr style="${p.status == 'Sold' ? 'opacity: 0.7; background: rgba(13,158,110,0.05);' : ''}">
                                    <td><small style="opacity: 0.6; font-weight: 600;">#${p.id}</small></td>
                                    <td>
                                        <div style="font-weight: 600; color: var(--ink);">${p.title}</div>
                                        <c:if test="${p.status == 'Sold'}">
                                            <c:if test="${not empty propertyBookingEndDates[p.id]}">
                                                <div style="font-size: 0.75rem; color: #0d9e6e; margin-top: 2px;">✓ Sold Property</div>
                                            </c:if>
                                            <c:if test="${empty propertyBookingEndDates[p.id]}">
                                                <div style="font-size: 0.75rem; color: #0d9e6e; margin-top: 2px;">✓ Sold Property</div>
                                            </c:if>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div style="font-weight: 700; color: ${p.status == 'Sold' ? '#0d9e6e' : 'var(--accent)'}; font-size: 0.95rem;">
                                            LKR <fmt:formatNumber value="${p.price}" pattern="#,##0.##"/>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 4px;">
                                            <span style="font-size: 0.85rem;">📍</span>
                                            <span>${p.location}</span>
                                        </div>
                                    </td>
                                    <td>
                                    <span style="background: var(--bg2); padding: 4px 10px; border-radius: 6px; font-size: 0.82rem; font-weight: 600; border: 1px solid var(--line);">
                                            ${p.type}
                                    </span>
                                    </td>
                                    <td style="text-align: center;">
                                    <span style="background: rgba(26,86,219,0.08); padding: 4px 10px; border-radius: 6px; font-weight: 600; font-size: 0.85rem; color: var(--accent);">
                                            ${p.bedrooms}
                                    </span>
                                    </td>
                                    <td style="text-align: center;">
                                    <span style="background: rgba(13,158,110,0.08); padding: 4px 10px; border-radius: 6px; font-weight: 600; font-size: 0.85rem; color: var(--green);">
                                            ${p.bathrooms}
                                    </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${p.status == 'Sold' and not empty propertyBookingEndDates[p.id]}">
                                            <span class="badge-sold" style="font-size: 0.82rem; padding: 6px 14px; display: inline-flex; align-items: center; gap: 4px; background:rgba(13,158,110,0.12); color:#0d9e6e; border:1px solid rgba(13,158,110,0.3);">
                                                ✅ RENTED
                                            </span>
                                            </c:when>
                                            <c:when test="${p.status == 'Sold'}">
                                            <span class="badge-sold" style="font-size: 0.82rem; padding: 6px 14px; display: inline-flex; align-items: center; gap: 4px;">
                                                ✅ SOLD
                                            </span>
                                            </c:when>
                                            <c:otherwise>
                                            <c:choose>
                                                <c:when test="${p.status == 'For Rent'}">
                                                    <span style="display: inline-block; background: rgba(13,158,110,0.10); color: #0d9e6e; border: 1px solid rgba(13,158,110,0.35); padding: 6px 14px; border-radius: 20px; font-size: 0.82rem; font-weight: 700; white-space: nowrap;">
                                                        🏷️ ${p.status}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="display: inline-block; background: rgba(26,86,219,0.10); color: var(--accent); border: 1px solid rgba(26,86,219,0.35); padding: 6px 14px; border-radius: 20px; font-size: 0.82rem; font-weight: 700; white-space: nowrap;">
                                                        🏷️ ${p.status}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 6px; align-items: center; flex-wrap: wrap;">
                                            <c:choose>
                                                <c:when test="${p.status != 'Sold' and p.status != 'For Rent'}">
                                                    <button class="btn-edit" onclick="openEditModal('${p.id}', '${p.title}', '${p.price}', '${p.location}', '${p.type}', '${p.status}', '${p.bedrooms}', '${p.bathrooms}', '${p.description}')"
                                                            style="padding: 6px 10px; font-size: 0.75rem;" title="Edit property details">
                                                        ✏️ Edit
                                                    </button>
                                                    <form action="markAsSold" method="post" style="margin: 0;" onsubmit="return confirm('Mark &quot;${p.title}&quot; as Sold? This will update the property status to Sold and move it to the Completed Transactions section.');">
                                                        <input type="hidden" name="propertyId" value="${p.id}">
                                                        <button type="submit" class="btn-edit" style="color: #0d9e6e; border-color: #0d9e6e; padding: 6px 10px; font-size: 0.75rem;" title="Mark this property as sold">
                                                            🏷️ Sold
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${p.status == 'For Rent'}">
                                                    <button class="btn-edit" onclick="openEditModal('${p.id}', '${p.title}', '${p.price}', '${p.location}', '${p.type}', '${p.status}', '${p.bedrooms}', '${p.bathrooms}', '${p.description}')"
                                                            style="padding: 6px 10px; font-size: 0.75rem;" title="Edit property details">
                                                        ✏️ Edit
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="opacity: 0.4; font-size: 0.82rem; padding: 6px 10px;">—</span>
                                                </c:otherwise>
                                            </c:choose>

                                            <form action="deleteProperty" method="post" style="margin: 0;" onsubmit="return confirm('Are you absolutely sure you want to delete this property? This cannot be undone!');">
                                                <input type="hidden" name="propertyId" value="${p.id}">
                                                <button type="submit" class="btn-edit" style="color: var(--red); border-color: var(--red); padding: 6px 10px; font-size: 0.75rem;" title="Delete this property permanently">
                                                    🗑️ Delete
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="9" style="text-align:center; padding: 40px 20px;">
                                    <div style="font-size: 3rem; margin-bottom: 12px;">🏠</div>
                                    <div style="font-weight: 600; margin-bottom: 6px; color: var(--ink);">No Properties Listed Yet</div>
                                    <div style="opacity: 0.7; font-size: 0.9rem;">Start by adding your first property above!</div>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ── ACTIVE BOOKINGS ──────────────────────────────────────────────── -->
        <div class="card">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                <h3 class="card-title" style="margin:0;"> Active Bookings</h3>
                <span style="font-size:0.85rem; opacity:0.65;">${reservedCount} property(s) currently reserved</span>
            </div>

            <c:if test="${param.confirmed == 'success'}">
                <div style="background:rgba(26,86,219,0.08);border:1px solid rgba(26,86,219,0.3);border-radius:8px;padding:12px 16px;margin-bottom:16px;font-size:0.9rem;color:#1a56db;font-weight:600;">
                    ✅ Booking confirmed! The property is now marked as <strong>Booked</strong> for the rental period.
                </div>
            </c:if>
            <c:if test="${param.completed == 'success'}">
                <div style="background:rgba(13,158,110,0.08);border:1px solid rgba(13,158,110,0.3);border-radius:8px;padding:12px 16px;margin-bottom:16px;font-size:0.9rem;color:#0d9e6e;font-weight:600;">
                    🏁 Booking completed! The property has been restored to <strong>Available (For Rent)</strong> and rental earnings have been recorded.
                </div>
            </c:if>
            <div class="table-responsive">
                <table>
                    <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Property</th>
                        <th>Buyer</th>
                        <th>Contact</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Status</th>
                        <th>Penalty</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty activeBookings}">
                            <c:forEach var="bk" items="${activeBookings}">
                                <tr>
                                    <td style="font-size:0.8rem; opacity:0.7;">${bk.bookingId}</td>
                                    <td>
                                        <div style="font-weight:600;">${bk.propertyTitle}</div>
                                        <div style="font-size:0.78rem; opacity:0.6;">ID: ${bk.propertyId}</div>
                                    </td>
                                    <td>
                                        <div style="font-weight:500;">${bk.buyerName}</div>
                                        <div style="font-size:0.78rem; opacity:0.65;">${bk.buyerUsername}</div>
                                    </td>
                                    <td>
                                        <div style="font-size:0.85rem;">${bk.buyerEmail}</div>
                                        <div style="font-size:0.85rem; opacity:0.7;">${bk.buyerPhone}</div>
                                    </td>
                                    <td>${bk.bookingDate}</td>
                                    <td>${bk.returnDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${bk.status == 'OVERDUE'}">
                                                <span class="status-badge" style="background:rgba(224,40,40,0.12);color:#e02828;">&#9888; Overdue</span>
                                            </c:when>
                                            <c:when test="${bk.status == 'CONFIRMED'}">
                                                <span class="status-badge" style="background:rgba(13,158,110,0.12);color:#0d9e6e;">✅ Confirmed</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge" style="background:rgba(26,86,219,0.1);color:var(--accent);">Reserved</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${bk.penaltyFee != '0.00'}">
                                                <div style="color:#e02828; font-weight:700;">LKR <fmt:formatNumber value="${bk.penaltyFee}" pattern="#,##0.00" /></div>
                                                <c:if test="${not empty bk.daysOverdue}">
                                                    <div style="font-size:0.72rem;color:#e02828;margin-top:2px;">${bk.daysOverdue} × LKR <fmt:formatNumber value="${bk.dailyRate}" pattern="#,##0.00" />/day</div>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <div style="opacity:0.4;">&#8212;</div>
                                                <c:if test="${not empty bk.dailyRate}">
                                                    <div style="font-size:0.72rem;opacity:0.55;margin-top:2px;">Rate: LKR <fmt:formatNumber value="${bk.dailyRate}" pattern="#,##0.00" />/day</div>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div style="display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
                                                <%-- Show CONFIRM button only for RESERVED bookings --%>
                                            <c:if test="${bk.status == 'RESERVED'}">
                                                <form action="confirmBooking" method="post" style="margin:0;"
                                                      onsubmit="return confirm('Confirm this booking? The property will be shown as Sold until the return date.');">
                                                    <input type="hidden" name="bookingId" value="${bk.bookingId}">
                                                    <button type="submit" class="btn"
                                                            style="padding:7px 14px; font-size:0.82rem; background:#1a56db; display:flex; align-items:center; gap:5px;">
                                                        ✅ Confirm
                                                    </button>
                                                </form>
                                            </c:if>
                                                <%-- Show COMPLETE button for CONFIRMED or OVERDUE bookings --%>
                                            <c:if test="${bk.status == 'CONFIRMED' or bk.status == 'OVERDUE'}">
                                                <form action="completeBooking" method="post" style="margin:0;"
                                                      onsubmit="return confirm('Mark this booking as completed? The property will be restored to Available and rental earnings will be calculated.');">
                                                    <input type="hidden" name="bookingId" value="${bk.bookingId}">
                                                    <button type="submit" class="btn"
                                                            style="padding:7px 14px; font-size:0.82rem; background:#0d9e6e; display:flex; align-items:center; gap:5px;">
                                                        🏁 Complete
                                                    </button>
                                                </form>
                                            </c:if>
                                                <%-- If still RESERVED (not yet confirmed), show greyed Complete --%>
                                            <c:if test="${bk.status == 'RESERVED'}">
                                                <button type="button" class="btn"
                                                        style="padding:7px 14px; font-size:0.82rem; background:#9ca3af; cursor:not-allowed; opacity:0.55;"
                                                        title="Confirm the booking first before completing it" disabled>
                                                    🏁 Complete
                                                </button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="9" style="text-align:center; padding:36px; opacity:0.6;">No active bookings at the moment.</td></tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- ── COMPLETED BOOKINGS ───────────────────────────────────────────── -->
        <div class="card">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">
                <h3 class="card-title" style="margin:0;">Completed Transactions</h3>
                <span style="font-size:0.85rem; opacity:0.65;">${completedBookings.size()} completed</span>
            </div>

            <c:if test="${param.delete == 'success'}">
                <div style="background:rgba(13,158,110,0.1);border:1px solid rgba(13,158,110,0.3);border-radius:8px;padding:12px 16px;margin-bottom:16px;font-size:0.9rem;color:#0d9e6e;font-weight:600;">
                    ✅ Completed transaction removed successfully!
                </div>
            </c:if>
            <c:if test="${param.delete == 'error'}">
                <div style="background:rgba(224,40,40,0.1);border:1px solid rgba(224,40,40,0.3);border-radius:8px;padding:12px 16px;margin-bottom:16px;font-size:0.9rem;color:#c0392b;font-weight:600;">
                    ⚠️ Failed to remove transaction. Please try again.
                </div>
            </c:if>

            <div class="table-responsive">
                <table>
                    <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Property</th>
                        <th>Buyer</th>
                        <th>Rental Start</th>
                        <th>Rental End</th>
                        <th>Booking Status</th>
                        <th style="width:100px;">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty completedBookings}">
                            <c:forEach var="bk" items="${completedBookings}">
                                <tr>
                                    <td style="font-size:0.8rem; opacity:0.7;">${bk.bookingId}</td>
                                    <td>
                                        <div style="font-weight:600;">${bk.propertyTitle}</div>
                                        <div style="font-size:0.78rem; opacity:0.6;">ID: ${bk.propertyId}</div>
                                    </td>
                                    <td>
                                        <div style="font-weight:500;">${bk.buyerName}</div>
                                        <div style="font-size:0.78rem; opacity:0.65;">${bk.buyerEmail}</div>
                                    </td>
                                    <td>${bk.bookingDate}</td>
                                    <td>${bk.returnDate}</td>
                                    <td><span class="status-badge" style="background:rgba(13,158,110,0.1);color:#0d9e6e;">Completed</span></td>
                                    <td>
                                        <form action="deleteCompletedBooking" method="post" style="margin:0;" onsubmit="return confirm('Are you sure you want to delete this completed transaction? This action cannot be undone.');">
                                            <input type="hidden" name="bookingId" value="${bk.bookingId}">
                                            <button type="submit" class="btn-edit" style="color: #ef4444; border-color: #ef4444; font-size: 0.78rem; padding: 6px 10px;" title="Delete this completed transaction">
                                                🗑️ Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="7" style="text-align:center; padding:36px; opacity:0.6;">No completed transactions yet.</td></tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card" id="reviews-section">
            <h3 class="card-title">💬 Buyer Reviews</h3>
            <p style="color: var(--ink); opacity: 0.7; font-size: 0.9rem; margin-top: -16px; margin-bottom: 24px;">
                Reviews posted by buyers for your properties.
            </p>

            <c:choose>
                <c:when test="${empty myProperties}">
                    <div style="text-align:center; padding: 40px; background: var(--bg2); border-radius: var(--r); border: 2px dashed var(--line);">
                        <div style="font-size: 3rem; margin-bottom: 12px;">🏠</div>
                        <div style="font-weight: 600; margin-bottom: 6px;">No Properties Yet</div>
                        <div style="opacity: 0.7; font-size: 0.9rem;">Add a property to start receiving reviews from buyers.</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display:flex; flex-direction:column; gap: 24px;">
                        <c:forEach var="p" items="${myProperties}">
                            <!-- Property Card -->
                            <div style="border: 1px solid var(--line); border-radius: var(--r); background: var(--bg); overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.04); transition: box-shadow 0.3s ease;"
                                 onmouseover="this.style.boxShadow='0 4px 16px rgba(0,0,0,0.08)'"
                                 onmouseout="this.style.boxShadow='0 2px 8px rgba(0,0,0,0.04)'">

                                <!-- Property Header -->
                                <div style="background: linear-gradient(135deg, rgba(26,86,219,0.05) 0%, rgba(13,158,110,0.05) 100%); padding: 18px 20px; border-bottom: 1px solid var(--line);">
                                    <div style="display:flex; justify-content:space-between; align-items:center; gap: 12px; flex-wrap: wrap;">
                                        <div>
                                            <div style="font-weight: 800; font-size: 1.05rem; color: var(--ink);">${p.title}</div>
                                            <div style="font-size: 0.82rem; opacity: 0.7; margin-top: 4px; display: flex; align-items: center; gap: 8px;">
                                                <span>🆔 ${p.id}</span>
                                                <span>•</span>
                                                <span>📍 ${p.location}</span>
                                                <span>•</span>
                                                <span>🏷️ ${p.type}</span>
                                            </div>
                                        </div>
                                        <c:set var="revList" value="${reviewsByProperty[p.id]}"/>
                                        <div style="background: var(--accent); color: white; padding: 6px 14px; border-radius: 20px; font-size: 0.78rem; font-weight: 700;">
                                                ${not empty revList ? revList.size() : 0} Review${not empty revList && revList.size() != 1 ? 's' : ''}
                                        </div>
                                    </div>
                                </div>

                                <!-- Reviews List -->
                                <div style="padding: 20px;">
                                    <c:choose>
                                        <c:when test="${empty revList}">
                                            <div style="text-align: center; padding: 32px 20px; background: var(--bg2); border-radius: 8px; border: 1px dashed var(--line);">
                                                <div style="font-size: 2.5rem; margin-bottom: 10px;">⭐</div>
                                                <div style="font-weight: 600; margin-bottom: 4px;">No Reviews Yet</div>
                                                <div style="font-size: 0.85rem; opacity: 0.7;">Be patient! Buyers will leave reviews after viewing this property.</div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div style="display:flex; flex-direction:column; gap: 14px;">
                                                <c:forEach var="r" items="${revList}">
                                                    <!-- Individual Review Card -->
                                                    <div style="padding: 16px 18px; border-radius: 10px; background: var(--bg2); border: 1.5px solid var(--line); transition: all 0.2s ease;"
                                                         onmouseover="this.style.borderColor='var(--accent)'; this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 12px rgba(26,86,219,0.1)'"
                                                         onmouseout="this.style.borderColor='var(--line)'; this.style.transform='translateY(0)'; this.style.boxShadow='none'">

                                                        <!-- Review Header -->
                                                        <div style="display:flex; justify-content:space-between; align-items:flex-start; gap: 12px; margin-bottom: 12px; flex-wrap: wrap;">
                                                            <div style="display: flex; align-items: center; gap: 10px;">
                                                                <div style="width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, var(--accent), #1041b0); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 1.1rem; flex-shrink: 0;">
                                                                        ${fn:substring(r.buyerName, 0, 1)}
                                                                </div>
                                                                <div>
                                                                    <div style="font-weight: 700; font-size: 0.95rem; color: var(--ink);"><c:out value="${r.buyerName}"/></div>
                                                                    <div style="font-size: 0.75rem; opacity: 0.6; margin-top: 2px;">Verified Buyer ✓</div>
                                                                </div>
                                                            </div>
                                                            <div style="display: flex; align-items: center; gap: 12px;">
                                                                <div style="display: flex; align-items: center; gap: 4px; background: rgba(217,119,6,0.1); padding: 6px 12px; border-radius: 20px; border: 1px solid rgba(217,119,6,0.2);">
                                                                <span style="color: #d97706; letter-spacing: 1px; font-size: 0.95rem;">
                                                                    <c:forEach begin="1" end="${r.rating}" var="i">★</c:forEach>
                                                                    <c:forEach begin="1" end="${5 - r.rating}" var="i">☆</c:forEach>
                                                                </span>
                                                                    <span style="font-weight: 700; color: #d97706; font-size: 0.85rem;">${r.rating}.0</span>
                                                                </div>
                                                                <form action="deleteReview" method="post" onsubmit="return confirm('Are you sure you want to delete this review? This action cannot be undone.');" style="margin: 0;">
                                                                    <input type="hidden" name="reviewId" value="${r.reviewID}">
                                                                    <button type="submit" class="btn-edit" style="color: var(--red); border-color: var(--red); padding: 6px 12px; font-size: 0.78rem;" title="Delete this review">
                                                                        🗑️ Delete
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </div>

                                                        <!-- Review Comment -->
                                                        <div style="background: var(--bg); padding: 14px 16px; border-radius: 8px; border-left: 3px solid var(--accent);">
                                                            <div style="font-size: 0.88rem; line-height: 1.6; color: var(--ink); opacity: 0.9; white-space: pre-wrap;">
                                                                <c:out value="${r.comment}"/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

    <div class="modal-overlay" id="editModal">
        <div class="modal-box">
            <span class="close-btn" onclick="closeEditModal()">×</span>
            <h3 class="card-title">Update Property</h3>
            <form action="updateProperty" method="post" style="display: flex; flex-direction: column; gap: 16px;">
                <input type="hidden" name="propertyId" id="edit-id">

                <div class="form-group"><label>Title</label><input type="text" name="title" id="edit-title" required></div>
                <div class="form-group"><label id="edit-price-label">Price (LKR)</label><input type="number" name="price" id="edit-price" required></div>
                <div class="form-group"><label>Location</label><input type="text" name="location" id="edit-location" required></div>
                <div class="form-grid">
                    <div class="form-group"><label>Type</label>
                        <select name="type" id="edit-type"><option>Apartment</option><option>House</option><option>Villa</option></select>
                    </div>
                    <div class="form-group"><label>Bed Rooms</label><input type="number" name="bedrooms" id="edit-bedrooms" min="0" required></div>
                    <div class="form-group"><label>Bath Tubs</label><input type="number" name="bathrooms" id="edit-bathrooms" min="0" required></div>
                    <div class="form-group"><label>Status</label>
                        <select name="status" id="edit-status-select" onchange="updatePriceLabel('edit')" required>
                            <option value="" selected>Choose a Ststus</option>
                            <option>For Sale</option>
                            <option>For Rent</option>
                        </select>
                    </div>
                </div>
                <div class="form-group"><label>Description</label><textarea name="description" id="edit-description" rows="3"></textarea></div>
                <button type="submit" class="btn">💾 Save Changes</button>
                <button type="Reset" class="btn"> Reset</button>
                <button onclick="closeEditModal()" class="btn">Close</button>
            </form>
        </div>
    </div>

    <script src="app.js"></script>

    <script>
        // Bulletproof direct function - customized for superEditBtn and emoji-free text!
        //open profile section in popups
        const modal = document.getElementById("myModal");
        const btn = document.getElementById("openBtn");
        const span = document.getElementById("closeBtn");

        // Open modal on click
        btn.onclick = function () {
            modal.style.display = "block";
        }

        // Close modal when clicking (x)
        span.onclick = function () {
            modal.style.display = "none";
        }
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

    <script>
        // Identity bridge for notifications on this page too
        window.currentUser = "${sessionScope.loggedUser}";
        window.currentRole = "${sessionScope.loggedRole}";
        window.allNotifications = [];
        <c:forEach items="${allNotifications}" var="n">
        window.allNotifications.push({
            sender: "${n.sender}",
            receiver: "${n.receiver}",
            title: "${n.title}",
            message: "${n.content}",
            property: "${n.propTitle}",
            type: "${n.type}",
            threadId: "${n.threadId}",
            timestamp: "${n.timestamp}"
        });
        </c:forEach>
    </script>
    <script>
        function openEditModal(id, title, price, location, type, status, bedrooms, bathrooms, description) {
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-title').value = title;
            document.getElementById('edit-price').value = price;
            document.getElementById('edit-location').value = location;
            document.getElementById('edit-type').value = type;
            document.getElementById('edit-status-select').value = status; // Set status first
            document.getElementById('edit-bedrooms').value = bedrooms;
            document.getElementById('edit-bathrooms').value = bathrooms;
            document.getElementById('edit-description').value = description;

            updatePriceLabel('edit'); // Call to update label based on status
            document.getElementById('editModal').classList.add('open');
        }

        function closeEditModal() {
            document.getElementById('editModal').classList.remove('open');
        }

        function updatePriceLabel(formType) {
            let statusSelectId = formType === 'add' ? 'add-status-select' : 'edit-status-select';
            let priceLabelId = formType === 'add' ? 'add-price-label' : 'edit-price-label';

            let statusSelect = document.getElementById(statusSelectId);
            let priceLabel = document.getElementById(priceLabelId);

            if (statusSelect && priceLabel) {
                if (statusSelect.value === 'For Rent') {
                    priceLabel.innerText = 'Daily Price (LKR)';
                } else {
                    priceLabel.innerText = 'Price (LKR)';
                }
            }
        }

        // Initial call for add form on page load
        document.addEventListener('DOMContentLoaded', () => {
            updatePriceLabel('add');
        });
    </script>

    <!-- Inquiry Chat Modal -->
    <div class="chat-overlay" id="chatOverlay" onclick="closeChatIfOutside(event)">
        <div class="chat-box" onclick="event.stopPropagation()">
            <div class="chat-left">
                <div style="font-weight: 800; margin-bottom: 12px;">Inquiry Details</div>
                <div style="display:flex; flex-direction:column; gap: 10px;">
                    <div>
                        <div style="font-size:0.75rem; opacity:0.7; text-transform: uppercase; letter-spacing: .6px;">Buyer</div>
                        <div id="chatBuyerName" style="font-weight:700;"></div>
                    </div>
                    <div>
                        <div style="font-size:0.75rem; opacity:0.7; text-transform: uppercase; letter-spacing: .6px;">Email</div>
                        <div id="chatBuyerEmail"></div>
                    </div>
                    <div>
                        <div style="font-size:0.75rem; opacity:0.7; text-transform: uppercase; letter-spacing: .6px;">Phone</div>
                        <div id="chatBuyerPhone"></div>
                    </div>
                    <div style="padding-top: 10px; border-top: 1px solid var(--line);">
                        <div style="font-size:0.75rem; opacity:0.7; text-transform: uppercase; letter-spacing: .6px;">Property</div>
                        <div id="chatPropTitle" style="font-weight:700;"></div>
                        <div id="chatPropId" style="font-size:0.85rem; opacity:0.8;"></div>
                    </div>
                    <div style="padding-top: 10px; border-top: 1px solid var(--line);">
                        <div style="font-size:0.75rem; opacity:0.7; text-transform: uppercase; letter-spacing: .6px;">Thread</div>
                        <div id="chatThreadId" style="font-size:0.85rem; opacity:0.85; word-break: break-all;"></div>
                    </div>
                </div>
            </div>

            <div class="chat-right">
                <div class="chat-top">
                    <div class="chat-peer">
                        <div class="avatar">👤</div>
                        <div>
                            <div class="peer-name" id="chatHeaderName">Buyer</div>
                            <div class="peer-sub" id="chatHeaderSub">Inquiry chat</div>
                        </div>
                    </div>
                    <button class="btn" type="button" style="background: var(--line); color: var(--ink);" onclick="closeChat()">Close</button>
                </div>

                <div class="chat-msgs" id="chatMsgs"></div>

                <form class="chat-compose" id="chatForm" action="replyInquiry" method="post">
                    <input type="hidden" name="threadId" id="chatThreadIdInput">
                    <textarea class="chat-input" name="message" id="chatInput" placeholder="Type a reply..." required></textarea>
                    <button class="chat-send" type="submit">Send</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Build a JS map of seller threads from server-side data
        window.sellerThreads = {};
        <c:forEach var="t" items="${sellerThreads}">
        window.sellerThreads["${t.id}"] = {
            id: "${t.id}",
            propertyId: "${t.propertyId}",
            propertyTitle: "${t.propertyTitle}",
            buyerName: "${t.buyerName}",
            buyerEmail: "${t.buyerEmail}",
            buyerPhone: "${t.buyerPhone}",
            createdDate: "${t.createdDate}",
            status: "${t.status}"
        };
        </c:forEach>

        function openInquiryFromSelect() {
            const sel = document.getElementById('inqSelect');
            if (!sel || !sel.value) return;
            openChat(sel.value);
        }

        function openChat(threadId) {
            const t = window.sellerThreads ? window.sellerThreads[threadId] : null;
            if (!t) return;

            // --- Populate Chat UI ---
            document.getElementById('chatBuyerName').innerText = t.buyerName || '(No name)';
            document.getElementById('chatBuyerEmail').innerText = t.buyerEmail || '(No email)';
            document.getElementById('chatBuyerPhone').innerText = t.buyerPhone || '(No phone)';
            document.getElementById('chatPropTitle').innerText = t.propertyTitle || '(No title)';
            document.getElementById('chatPropId').innerText = t.propertyId ? ('Property ID: ' + t.propertyId) : '';
            document.getElementById('chatThreadId').innerText = t.id;
            document.getElementById('chatHeaderName').innerText = t.buyerName || 'Buyer';
            document.getElementById('chatHeaderSub').innerText = (t.createdDate ? ('Created: ' + t.createdDate) : 'Inquiry chat');
            document.getElementById('chatThreadIdInput').value = t.id;

            const msgs = document.getElementById('chatMsgs');
            const container = document.getElementById('thread-msgs-' + t.id);
            msgs.innerHTML = container ? container.innerHTML : '';

            // --- Show Modal & Focus ---
            document.getElementById('chatOverlay').classList.add('open');
            setTimeout(() => { msgs.scrollTop = msgs.scrollHeight; }, 50);
            setTimeout(() => { document.getElementById('chatInput').focus(); }, 80);

            // --- Mark as Read & Update UI ---
            // 1. Find the notification in the global array
            const notifIndex = window.allNotifications.findIndex(n => n.threadId === threadId);

            // 2. If it exists, remove it from the array and re-render the bell
            if (notifIndex > -1) {
                window.allNotifications.splice(notifIndex, 1);
                if (typeof renderNotifications === 'function') {
                    renderNotifications();
                }
            }

            // 3. Send the "mark as read" request to the server in the background
            fetch('markInquiryRead', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'threadId=' + encodeURIComponent(threadId)
            }).catch(err => console.error("Failed to mark as read on server:", err));
        }


        function closeChat() {
            document.getElementById('chatOverlay').classList.remove('open');
            document.getElementById('chatInput').value = '';
        }

        function closeChatIfOutside(event) {
            if (event.target && event.target.id === 'chatOverlay') closeChat();
        }

        // Auto-open from notification bell routing & attach form listener
        document.addEventListener("DOMContentLoaded", () => {
            const params = new URLSearchParams(window.location.search);
            const threadId = params.get('threadId');
            if (threadId) {
                setTimeout(() => openChat(threadId), 150);
            }

            const chatForm = document.getElementById('chatForm');
            if (chatForm) {
                chatForm.addEventListener('submit', (e) => handleChatSubmit(e, 'SELLER', chatForm));

                const chatInput = document.getElementById('chatInput');
                chatInput.addEventListener('keydown', function(e) {
                    if (e.key === 'Enter' && !e.shiftKey) {
                        e.preventDefault();
                        handleChatSubmit(new Event('submit', { bubbles: true, cancelable: true }), 'SELLER', chatForm);
                    }
                });
            }
        });
    </script>

    <script>
        // Auto-scroll to reviews section after a review deletion
        (function() {
            const params = new URLSearchParams(window.location.search);
            if (params.get('scrollTo') === 'reviews') {
                const reviewsSection = document.getElementById('reviews-section');
                if (reviewsSection) {
                    reviewsSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
                // Clean the URL so refreshing doesn't re-scroll
                const cleanUrl = window.location.pathname;
                history.replaceState(null, '', cleanUrl);
            }
        })();
    </script>

    <!-- Hidden rendered messages per thread (safe HTML escaping) -->
    <div style="display:none;">
        <c:forEach var="t" items="${sellerThreads}">
            <div id="thread-msgs-${t.id}">
                <c:forEach var="m" items="${t.messages}">
                    <c:choose>
                        <c:when test="${m.senderRole == 'SELLER'}">
                            <div class="bubble bubble-right">
                                <div class="bubble-meta">
                                    <strong><c:out value="${m.senderName}"/></strong>
                                    · <c:out value="${m.timestamp}"/>
                                </div>
                                <div style="white-space: pre-wrap;"><c:out value="${m.content}"/></div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="bubble bubble-left">
                                <div class="bubble-meta">
                                    <strong><c:out value="${m.senderName}"/></strong>
                                    · <c:out value="${m.timestamp}"/>
                                </div>
                                <div style="white-space: pre-wrap;"><c:out value="${m.content}"/></div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
        </c:forEach>
    </div>

    <!-- Page Transition Animation System -->
    <script src="page-transitions.js"></script>
</div>
</body>
</html>