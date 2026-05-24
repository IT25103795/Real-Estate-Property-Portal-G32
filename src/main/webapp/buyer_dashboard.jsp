<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Buyer Dashboard - NESTIQ</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <style>
        /* ── PREMIUM NESTIQ VARIABLES ── */
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

        .dashboard-container { max-width: 80%; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }

        /* ── STAT CARDS GRID ── */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }
        .stat-card {
            width: 100%;
            background: var(--bg);
            border: 1px solid var(--line);
            border-radius: var(--r);
            padding: 20px;
            box-shadow: 0 4px 16px rgba(0,0,0,.04);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        [data-theme="dark"] .stat-card {
            box-shadow: 0 4px 20px rgba(0,0,0,0.25), 0 0 0 1px rgba(255,255,255,0.03);
            border-color: rgba(255,255,255,0.08);
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
        [data-theme="dark"] .stat-card:hover {
            box-shadow: 0 8px 28px rgba(0,0,0,0.35), 0 0 0 1px rgba(255,255,255,0.06);
            border-color: rgba(255,255,255,0.12);
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
        }
        [data-theme="dark"] .card {
            box-shadow: 0 4px 20px rgba(0,0,0,0.3), 0 0 0 1px rgba(255,255,255,0.05);
        }
        .card:hover {
            box-shadow: 0 6px 20px rgba(0,0,0,.08);
        }
        [data-theme="dark"] .card:hover {
            box-shadow: 0 8px 30px rgba(0,0,0,0.4), 0 0 0 1px rgba(255,255,255,0.08);
        }
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            padding-bottom: 14px;
            border-bottom: 2px solid var(--line);
        }
        .card-title {
            font-size: 1.2rem;
            font-weight: 700;
            margin: 0;
            color: var(--ink);
        }

        /* Forms & Toolbars */
        .toolbar { display: flex; gap: 15px; align-items: center; }
        input, select {
            padding: 10px 15px;
            border: 1.5px solid var(--line);
            border-radius: 6px;
            background: var(--bg);
            color: var(--ink);
            font-family: var(--font-sans);
            outline: none;
            transition: all 0.2s;
        }
        input:focus, select:focus {
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
        .btn-outline {
            background: transparent;
            border: 1.5px solid var(--line);
            color: var(--ink);
            box-shadow: none;
        }
        .btn-outline:hover {
            border-color: var(--accent);
            color: var(--accent);
            background: rgba(26,86,219,0.05);
        }

        /* The Data Table */
        table { width: 100%; border-collapse: collapse; text-align: left; font-size: 0.9rem; }
        th, td { padding: 12px 14px; border-bottom: 1px solid var(--line); vertical-align: middle; }
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

        /* Thumbnail Image for Saved Properties */
        .prop-thumb { width: 60px; height: 45px; border-radius: 4px; object-fit: cover; }
        .prop-title-cell { display: flex; align-items: center; gap: 15px; font-weight: 500; }

        .status-badge { padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .badge-pending { background: rgba(26, 86, 219, 0.1); color: var(--accent); }
        .badge-viewed { background: rgba(13, 158, 110, 0.1); color: var(--green); }

        .btn-action { background: none; border: 1px solid var(--line); color: var(--ink); padding: 8px 12px; border-radius: 4px; cursor: pointer; font-size: 0.85rem; font-weight: 500; transition: 0.2s;}
        .btn-action:hover { border-color: var(--red); color: var(--red); }

        /* ── Bulk Remove Toolbar ── */
        .bulk-toolbar { display: flex; align-items: center; justify-content: space-between; padding: 10px 18px; background: var(--bg); border-bottom: 1px solid var(--line); gap: 12px; flex-wrap: wrap; }
        .bulk-left { display: flex; align-items: center; gap: 12px; }
        .bulk-select-all-label { display: flex; align-items: center; gap: 6px; font-size: 0.88rem; font-weight: 600; cursor: pointer; user-select: none; color: var(--ink); }
        .bulk-select-all-label input[type="checkbox"] { width: 16px; height: 16px; cursor: pointer; accent-color: var(--accent, #e63946); }
        .bulk-count { font-size: 0.82rem; color: var(--accent, #e63946); font-weight: 600; }
        .bulk-actions { display: flex; gap: 8px; }
        .btn-bulk-remove { background: var(--accent, #e63946); color: #fff; border: none; border-radius: 6px; padding: 7px 14px; font-size: 0.83rem; font-weight: 600; cursor: pointer; transition: opacity 0.2s; }
        .btn-bulk-remove:hover { opacity: 0.85; }
        .btn-remove-all { background: none; border: 1.5px solid var(--red); color: var(--red); border-radius: 6px; padding: 7px 14px; font-size: 0.83rem; font-weight: 600; cursor: pointer; transition: 0.2s; margin-left: auto; }
        .btn-remove-all:hover { background: var(--red); color: #fff; }
        .fav-row td:first-child { text-align: center; }
        .fav-checkbox { width: 16px; height: 16px; cursor: pointer; accent-color: var(--accent, #e63946); }

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
        /* ── PROFILE & STATS 2X2 GRID LAYOUT ── */
        .profile-stats-grid {
            display: grid;
            /*grid-template-columns: 1fr 1fr;*/
            gap: 24px;
            margin-bottom: 24px;
        }

        .stats-2x2-grid {
            display: flex;
            grid-template-columns: 1fr 1fr;
            /*grid-template-rows: 1fr 1fr;*/
            gap: 16px;
            align-content: center;
        }

        .stats-2x2-grid .stat-card {
            margin: 0;
        }
        .profile-section {
            background: var(--bg2); /* Automatically shifts between light/dark background */
            /*border: 1px solid var(--line); !* Adds a subtle, elegant outline *!*/
            box-shadow: 0 4px 16px rgba(0,0,0,.04); /* Soft shadow to lift it off the page */
            padding: 20px;
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

        /* ── REPLACE PROPERTY DROPDOWN ── */
        .replace-wrapper { position: relative; display: inline-block; z-index: 10000; }
        .replace-wrapper td { overflow: visible !important; }
        .replace-wrapper table { overflow: visible !important; }

        .btn-replace {
            background: none;
            border: 1.5px solid var(--line);
            color: var(--ink);
            padding: 8px 11px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            line-height: 1;
            transition: border-color 0.2s, color 0.2s, background 0.2s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn-replace:hover { border-color: var(--accent); color: var(--accent); background: rgba(26,86,219,0.05); }
        .btn-replace.active { border-color: var(--accent); color: var(--accent); background: rgba(26,86,219,0.08); }

        .replace-dropdown {
            display: none;
            position: absolute;
            top: calc(100% + 6px);
            left: 50%;
            transform: translateX(-50%);
            min-width: 260px;
            max-width: 320px;
            max-height: 350px;
            background: var(--bg);
            border: 1.5px solid var(--line);
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.25);
            z-index: 9999;
            overflow: hidden;
        }
        .replace-dropdown.open {
            display: block;
        }

        .replace-dropdown-header {
            padding: 10px 14px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--accent);
            border-bottom: 1px solid var(--line);
            background: rgba(26,86,219,0.04);
            position: sticky;
            top: 0;
            z-index: 1;
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

        /* .modal-overlay{
            margin: auto;
        }
        .modal-box{
            margin: auto;
        } */
         input::-webkit-calendar-picker-indicator{
            background-color: var(--bg2);
         }

        .replace-dropdown-list { max-height: 300px; overflow-y: auto; }
        .replace-dropdown-list::-webkit-scrollbar { width: 5px; }
        .replace-dropdown-list::-webkit-scrollbar-thumb { background: var(--line); border-radius: 10px; }

        .replace-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 9px 14px;
            cursor: pointer;
            border: none;
            background: transparent;
            width: 100%;
            text-align: left;
            color: var(--ink);
            font-family: var(--font-sans);
            font-size: 0.88rem;
            transition: background 0.15s;
            border-bottom: 1px solid var(--line);
        }
        .replace-item:last-child { border-bottom: none; }
        .replace-item:hover { background: rgba(26,86,219,0.06); }
        .replace-item-thumb { width: 38px; height: 28px; object-fit: cover; border-radius: 4px; flex-shrink: 0; }
        .replace-item-info { flex: 1; min-width: 0; }
        .replace-item-title { font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .replace-item-meta { font-size: 0.75rem; opacity: 0.65; margin-top: 1px; }
        .replace-item-badge { font-size: 0.68rem; font-weight: 700; padding: 2px 7px; border-radius: 20px; flex-shrink: 0; }
        .badge-forsale  { background: rgba(13,158,110,0.12); color: var(--green); }
        .badge-forrent  { background: rgba(26,86,219,0.12); color: var(--accent); }

        .replace-empty { padding: 16px; text-align: center; font-size: 0.85rem; opacity: 0.6; }

        /* Flash alert */
        .flash-alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
            font-weight: 600;
            font-size: 0.92rem;
        }
        .flash-success { background: rgba(13,158,110,0.1); border: 1px solid #0d9e6e; color: #0d9e6e; }
        .flash-error   { background: rgba(224,40,40,0.1);  border: 1px solid #e02828; color: #e02828; }
        .flash-warn    { background: rgba(255,165,0,0.1);  border: 1px solid #ffa500; color: #ff8c00; }

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

            <!-- ── ANNOUNCEMENTS BUTTON ── -->
            <div style="position: relative; display: inline-flex;">
                <button class="btn btn-outline" onclick="window.location.href='announcements'"
                        id="announcements-tab-btn"
                        title="View Official Announcements"
                        style="display:flex; align-items:center; gap:6px;
                               transition: all 0.2s;">
                    📢 Announcements
                </button>
                <span id="ann-tab-count"
                      style="position: absolute; top: -6px; right: -6px; background: var(--red);
                             color: white; border-radius: 50%; font-size: 0.65rem; font-weight: 700;
                             min-width: 18px; height: 18px; display: none; align-items: center;
                             justify-content: center; padding: 0 4px; line-height: 1;
                             pointer-events: none; box-shadow: 0 2px 8px rgba(224,40,40,0.3);"></span>
            </div>

            <!-- ── NOTIFICATION BELL ── -->
            <div style="position: relative;">
                <button onclick="toggleNotif(event)" title="Notifications"
                        style="background: var(--bg); border: 1.5px solid var(--line); border-radius: 8px;
                               width: 42px; height: 42px; cursor: pointer; font-size: 1.15rem;
                               position: relative; display: flex; align-items: center; justify-content: center;
                               transition: border-color 0.2s;"
                        onmouseover="this.style.borderColor='var(--accent)'"
                        onmouseout="this.style.borderColor='var(--line)'">
                    🔔
                    <span id="notif-count"
                          style="position: absolute; top: -6px; right: -6px; background: var(--red);
                                 color: white; border-radius: 50%; font-size: 0.65rem; font-weight: 700;
                                 min-width: 18px; height: 18px; display: none; align-items: center;
                                 justify-content: center; padding: 0 4px; line-height: 1;"></span>
                </button>

                <!-- Dropdown Panel -->
                <div id="notif-panel"
                     style="display: none; position: absolute; right: 0; top: calc(100% + 10px);
                            width: 340px; background: var(--bg); border: 1px solid var(--line);
                            border-radius: 12px; box-shadow: 0 12px 40px rgba(0,0,0,0.15);
                            z-index: 9999; overflow: hidden;"
                     onclick="event.stopPropagation()">

                    <div style="padding: 14px 18px; border-bottom: 1px solid var(--line);
                                display: flex; justify-content: space-between; align-items: center;">
                        <span style="font-weight: 700; font-size: 0.95rem;">Notifications</span>
                        <a href="announcements"
                           style="font-size: 0.78rem; color: var(--accent); font-weight: 600;
                                  text-decoration: none;">View All Announcements →</a>
                    </div>
                    <div id="notif-list" style="max-height: 380px; overflow-y: auto;"></div>
                </div>
            </div>
            <!-- ── END NOTIFICATION BELL ── -->

            <button class="btn btn-outline" onclick="window.location.href='properties?tab=browse'">🏠 Browse Properties</button>
            <div class="account-tab"><button id="openBtn" ><i class="fa-regular fa-circle-user fa-2xl"></i></button></div>
            <form action="logout" method="post" style="display:inline;">
                <button type="submit" class="btn" style="background: var(--red);">Logout</button>
            </form>
        </div>
    </div>

    <!-- ── PROFILE & STATS GRID LAYOUT ───────────────────────────── -->
    <div class="profile-stats-grid">
        <!-- Profile Section -->
        <div id="myModal" style="display:none; position:fixed; z-index:1; left:0; top:0; width:100%; height:100%; background-color:rgba(0,0,0,0.4);">
            <div style="background-color:var(--bg2); margin: 120px auto; padding:20px; width:fit-content; border-radius:10px; box-shadow: 8px 8px 25px black;">
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
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid var(--line); text-align: center;">
                <form action="DeleteAccountServlet" method="POST" style="margin: 0;" onsubmit="return confirm('⚠️ WARNING: Are you absolutely sure you want to permanently delete your account? This action cannot be undone and you will lose all saved properties.');">
                    <input type="hidden" name="userEmail" value="<%= session.getAttribute("loggedEmail") %>">
                    <button type="submit" style="background: transparent; color: var(--red); border: 2px solid red; font-size: 0.85rem; border-radius: 8px; font-weight: 600; cursor: pointer; padding: 5px">
                        Delete My Account
                    </button>
                </form>
            </div>
        </div>
            </div>
        </div>
        <!-- 2x2 Stat Cards Grid -->
        <div class="stats-2x2-grid">
            <div class="stat-card">
                <div class="stat-icon blue">❤️</div>
                <div class="stat-value">${not empty savedProperties ? savedProperties.size() : 0}</div>
                <div class="stat-label">Saved Properties</div>
            </div>

            <div class="stat-card green">
                <div class="stat-icon green">💬</div>
                <div class="stat-value">${not empty myInquiries ? myInquiries.size() : 0}</div>
                <div class="stat-label">Active Inquiries</div>
            </div>

            <div class="stat-card amber">
                <div class="stat-icon amber">📅</div>
                <div class="stat-value">${totalBookings != null ? totalBookings : 0}</div>
                <div class="stat-label">Total Bookings</div>
            </div>

            <div class="stat-card red">
                <div class="stat-icon red">✅</div>
                <div class="stat-value">${completedBookings != null ? completedBookings : 0}</div>
                <div class="stat-label">Completed</div>
            </div>
        </div>
    </div>
    <!-- ───────────────────────────────────────────────────────────── -->

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

        <c:if test="${param.replace == 'success'}">
            <div class="flash-alert flash-success">✅ Property replaced successfully!</div>
        </c:if>
        <c:if test="${param.replace == 'error'}">
            <div class="flash-alert flash-error">❌ Could not replace property. Please try again.</div>
        </c:if>
        <c:if test="${param.replace == 'notfound'}">
            <div class="flash-alert flash-error">❌ Original property not found in your saved list.</div>
        </c:if>
        <c:if test="${param.replace == 'unavailable'}">
            <div class="flash-alert flash-warn">⚠️ The selected property is sold or unavailable.</div>
        </c:if>

        <%-- ── BULK ACTION TOOLBAR ── --%>
        <c:if test="${not empty savedProperties}">
            <div class="bulk-toolbar" id="bulkToolbar">
                <div class="bulk-left">
                    <label class="bulk-select-all-label">
                        <input type="checkbox" id="selectAllFavs" onchange="toggleSelectAll(this)">
                        <span>Select All</span>
                    </label>
                    <span class="bulk-count" id="bulkCount" style="display:none;">0 selected</span>
                </div>
                <div class="bulk-actions" id="bulkActions" style="display:none;">
                    <button class="btn-bulk-remove" onclick="bulkRemoveSelected()">🗑️ Remove Selected</button>
                </div>
                <button class="btn-remove-all" onclick="bulkRemoveAll()">🗑️ Remove All</button>
            </div>
        </c:if>
        <%-- ── END BULK TOOLBAR ── --%>

        <%-- Hidden bulk-remove form submitted by JS --%>
        <form id="bulkRemoveForm" action="bulkRemoveFavorite" method="post" style="display:none;">
            <input type="hidden" name="mode" id="bulkMode" value="selected">
            <div id="bulkHiddenIds"></div>
        </form>

        <table>
            <thead>
            <tr>
                <c:if test="${not empty savedProperties}"><th style="width:36px;"></th></c:if>
                <th>Property</th>
                <th>Location</th>
                <th>Price</th>
                <th>Type</th>
                <th>Beds</th>
                <th>Baths</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty savedProperties}">
                    <c:forEach var="p" items="${savedProperties}">
                        <tr class="fav-row" id="row-${p.id}">
                            <td>
                                <input type="checkbox" class="fav-checkbox" value="${p.id}" onchange="updateBulkCount()">
                            </td>
                            <td class="prop-title-cell">
                                <img src="${p.imageUrl}" class="prop-thumb" alt="House">
                                <div>
                                    <div style="font-weight: 600;">${p.title}</div>
                                    <div style="font-size: 0.8rem; opacity: 0.7;">ID: ${p.id}</div>
                                </div>
                            </td>
                            <td>📍 ${p.location}</td>
                            <td style="font-weight: 600; color: var(--accent);">$<fmt:formatNumber value="${p.price}" pattern="#,##0.00" /><c:if test="${p.status == 'For Rent'}"><span style="font-size:0.75em; font-weight:400; opacity:0.65;">/day</span></c:if></td>
                            <td>${p.type}</td>
                            <td>${p.bedrooms}</td>
                            <td>${p.bathrooms}</td>
                            <td style="white-space: nowrap;">
                                <button class="btn" style="padding: 8px 15px; font-size: 0.85rem;" onclick="window.location.href='properties?viewId=${p.id}'">View</button>

                                    <%-- ── REPLACE BUTTON + DROPDOWN ── --%>
                                <div class="replace-wrapper" id="rw-${p.id}">
                                    <button type="button"
                                            class="btn-replace"
                                            title="Replace this property"
                                            onclick="toggleReplaceDropdown('${p.id}', event)">
                                        &#x21C4;
                                    </button>

                                    <div class="replace-dropdown" id="rd-${p.id}">
                                        <div class="replace-dropdown-header">Replace with…</div>
                                        <div class="replace-dropdown-list">
                                            <c:choose>
                                                <c:when test="${not empty availableProperties}">
                                                    <c:forEach var="ap" items="${availableProperties}">
                                                        <c:if test="${ap.id != p.id}">
                                                            <form action="replaceFavorite" method="post" style="margin:0; padding:0;">
                                                                <input type="hidden" name="oldPropertyId" value="${p.id}">
                                                                <input type="hidden" name="newPropertyId" value="${ap.id}">
                                                                <button type="submit" class="replace-item">
                                                                    <img src="${ap.imageUrl}" class="replace-item-thumb" alt="${ap.title}">
                                                                    <div class="replace-item-info">
                                                                        <div class="replace-item-title">${ap.title}</div>
                                                                        <div class="replace-item-meta">📍 ${ap.location}</div>
                                                                    </div>
                                                                    <span class="replace-item-badge ${ap.status == 'For Sale' ? 'badge-forsale' : 'badge-forrent'}">
                                                                            ${ap.status}
                                                                    </span>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="replace-empty">No available properties.</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                    <%-- ─ END REPLACE ── --%>

                                <form action="removeFavorite" method="post" style="margin: 0; display: inline-block;">
                                    <input type="hidden" name="propertyId" value="${p.id}">
                                    <button type="submit" class="btn-action" style="padding: 8px 12px; font-size: 0.85rem; height: 100%;" onsubmit="return confirm('Remove this property from your saved list?');"> Remove</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="8" style="text-align:center; padding: 40px; color: var(--ink); opacity: 0.6;">You haven't saved any properties yet. Go browse the listings!</td></tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <%-- ── BULK REMOVE JS ── --%>
    <script>
        function toggleSelectAll(master) {
            document.querySelectorAll('.fav-checkbox').forEach(cb => cb.checked = master.checked);
            updateBulkCount();
        }

        function updateBulkCount() {
            const checked = document.querySelectorAll('.fav-checkbox:checked');
            const countEl = document.getElementById('bulkCount');
            const actionsEl = document.getElementById('bulkActions');
            const masterCb = document.getElementById('selectAllFavs');
            const total = document.querySelectorAll('.fav-checkbox').length;

            countEl.style.display = checked.length > 0 ? 'inline' : 'none';
            countEl.textContent = checked.length + ' selected';
            actionsEl.style.display = checked.length > 0 ? 'flex' : 'none';
            masterCb.indeterminate = checked.length > 0 && checked.length < total;
            masterCb.checked = checked.length === total;
        }

        function bulkRemoveSelected() {
            const checked = document.querySelectorAll('.fav-checkbox:checked');
            if (checked.length === 0) return;
            if (!confirm('Remove ' + checked.length + ' selected propert' + (checked.length > 1 ? 'ies' : 'y') + ' from your saved list?')) return;

            const form = document.getElementById('bulkRemoveForm');
            const container = document.getElementById('bulkHiddenIds');
            container.innerHTML = '';
            document.getElementById('bulkMode').value = 'selected';

            checked.forEach(cb => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'selectedIds';
                input.value = cb.value;
                container.appendChild(input);
            });

            form.submit();
        }

        function bulkRemoveAll() {
            const total = document.querySelectorAll('.fav-checkbox').length;
            if (!confirm('Remove all ' + total + ' saved propert' + (total > 1 ? 'ies' : 'y') + '? This cannot be undone.')) return;
            document.getElementById('bulkMode').value = 'all';
            document.getElementById('bulkHiddenIds').innerHTML = '';
            document.getElementById('bulkRemoveForm').submit();
        }
    </script>
    <%-- ── END BULK REMOVE JS ── --%>

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
                <th>Chat</th>
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
                            <td>
                                <c:choose>
                                    <c:when test="${not empty inq.threadId}">
                                        <button type="button" class="btn" style="padding: 8px 12px; font-size: 0.85rem;" onclick="openBuyerChat('${inq.threadId}')">Open</button>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="opacity: 0.6;">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="5" style="text-align:center; padding: 30px; color: var(--ink); opacity: 0.6;">No pending inquiries.</td></tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <!-- ── MY BOOKINGS ─────────────────────────────────────────────────── -->
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">📅 My Bookings</h3>
        </div>

        <!-- Success/Error Messages -->
        <c:if test="${param.update == 'success'}">
            <div style="background: rgba(13,158,110,0.1); border: 1px solid #0d9e6e; color: #0d9e6e; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-weight: 600;">
                ✅ Booking updated successfully! The seller has been notified.
            </div>
        </c:if>
        <c:if test="${param.update == 'error'}">
            <div style="background: rgba(224,40,40,0.1); border: 1px solid #e02828; color: #e02828; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-weight: 600;">
                ❌ Error updating booking. Please try again.
            </div>
        </c:if>
        <c:if test="${param.update == 'notfound'}">
            <div style="background: rgba(224,40,40,0.1); border: 1px solid #e02828; color: #e02828; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-weight: 600;">
                ❌ Booking not found or cannot be updated.
            </div>
        </c:if>
        <c:if test="${param.cancel == 'success'}">
            <c:choose>
                <c:when test="${not empty param.penaltyFee and param.penaltyFee != '0.00'}">
                    <div style="background: rgba(224,40,40,0.1); border: 2px solid #e02828; color: #e02828; padding: 14px 18px; border-radius: 8px; margin-bottom: 16px; font-weight: 600;">
                        ⚠️ Booking cancelled after the return date.
                        A <strong>penalty fee of $${param.penaltyFee}</strong> applies
                        (${param.penaltyDays} overdue day(s) × $${param.penaltyRate} / day).
                        Please settle this amount with the seller directly.
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="background: rgba(13,158,110,0.1); border: 1px solid #0d9e6e; color: #0d9e6e; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-weight: 600;">
                        ✅ Booking cancelled successfully! The seller has been notified.
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>
        <c:if test="${param.booking == 'success'}">
            <div style="background: rgba(13,158,110,0.1); border: 1px solid #0d9e6e; color: #0d9e6e; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-weight: 600;">
                ✅ Booking confirmed successfully! The seller has been notified.
            </div>
        </c:if>
        <c:if test="${param.booking == 'duplicate'}">
            <div style="background: rgba(255,165,0,0.1); border: 1px solid #ffa500; color: #ff8c00; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-weight: 600;">
                ⚠️ You already have an active booking for this property.
            </div>
        </c:if>
        <c:if test="${param.booking == 'unavailable'}">
            <div style="background: rgba(224,40,40,0.1); border: 1px solid #e02828; color: #e02828; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-weight: 600;">
                ❌ This property is currently booked and not available.
            </div>
        </c:if>

        <!-- ENHANCEMENT: Booking Statistics -->
        <c:if test="${not empty myBookings || not empty bookingHistory}">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 12px; margin-bottom: 20px;">
                <div style="background: rgba(26,86,219,0.08); padding: 16px; border-radius: 8px; text-align: center; border: 1px solid rgba(26,86,219,0.2);">
                    <div style="font-size: 1.8rem; font-weight: 700; color: var(--accent);">${totalBookings}</div>
                    <div style="font-size: 0.82rem; color: var(--ink3); margin-top: 4px;">Total Bookings</div>
                </div>
                <div style="background: rgba(13,158,110,0.08); padding: 16px; border-radius: 8px; text-align: center; border: 1px solid rgba(13,158,110,0.2);">
                    <div style="font-size: 1.8rem; font-weight: 700; color: #0d9e6e;">${activeBookings}</div>
                    <div style="font-size: 0.82rem; color: var(--ink3); margin-top: 4px;">Active</div>
                </div>
                <div style="background: rgba(100,100,100,0.08); padding: 16px; border-radius: 8px; text-align: center; border: 1px solid rgba(100,100,100,0.2);">
                    <div style="font-size: 1.8rem; font-weight: 700; color: #666;">${completedBookings}</div>
                    <div style="font-size: 0.82rem; color: var(--ink3); margin-top: 4px;">Completed</div>
                </div>
            </div>
        </c:if>

        <%-- ── OVERDUE GLOBAL WARNING BANNER ── --%>
        <c:forEach var="bk" items="${myBookings}">
            <c:if test="${bk.status == 'OVERDUE'}">
                <div style="background:rgba(224,40,40,0.08);border:1.5px solid rgba(224,40,40,0.35);border-radius:10px;padding:14px 18px;margin-bottom:18px;display:flex;align-items:flex-start;gap:12px;">
                    <span style="font-size:1.4rem;flex-shrink:0;">⚠️</span>
                    <div>
                        <div style="font-weight:700;color:var(--red);font-size:0.95rem;margin-bottom:4px;">Overdue Penalty Active — "${bk.propertyTitle}"</div>
                        <div style="font-size:0.83rem;color:var(--ink);line-height:1.6;">
                            Your return date of <strong>${bk.returnDate}</strong> has passed.
                            A penalty of <strong>$<fmt:formatNumber value="${bk.dailyRate}" pattern="#,##0.00" /> per day</strong>
                            (equal to the property's daily rental rate) is being charged for each overdue day.
                            <c:if test="${not empty bk.daysOverdue}">
                                You are currently <strong>${bk.daysOverdue} day(s) overdue</strong>.
                            </c:if>
                            Total penalty so far: <strong style="color:var(--red);">$<fmt:formatNumber value="${bk.penaltyFee}" pattern="#,##0.00" /></strong>.
                            Please contact the seller <strong>${bk.sellerName}</strong> immediately to settle the outstanding amount.
                        </div>
                    </div>
                </div>
            </c:if>
        </c:forEach>

        <table>
            <thead>
            <tr>
                <th>Booking ID</th>
                <th>Property</th>
                <th>Seller</th>
                <th>Rental Start</th>
                <th>Rental End</th>
                <th>Time Remaining</th>
                <th>Status</th>
                <th>Daily Rate</th>
                <th>Penalty Fee</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty myBookings}">
                    <c:forEach var="bk" items="${myBookings}">
                        <tr style="${bk.status == 'OVERDUE' ? 'background:rgba(224,40,40,0.04);' : ''}">
                            <td style="font-size:0.82rem; opacity:0.75;">${bk.bookingId}</td>
                            <td>
                                <div style="font-weight:600;">${bk.propertyTitle}</div>
                                <div style="font-size:0.8rem; opacity:0.65;">ID: ${bk.propertyId}</div>
                            </td>
                            <td>${bk.sellerName}</td>
                            <td>${bk.bookingDate}</td>
                            <td>
                                <div>${bk.returnDate}</div>
                                <c:if test="${bk.status == 'OVERDUE'}">
                                    <div style="font-size:0.75rem;color:var(--red);font-weight:600;margin-top:2px;">
                                        ⏰ ${bk.daysOverdue} day(s) overdue
                                    </div>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${bk.status == 'OVERDUE'}">
                                        <div style="color:var(--red); font-weight:700;">⏳ Overdue</div>
                                    </c:when>
                                    <c:when test="${bk.status == 'COMPLETED'}">
                                        <span style="opacity:0.4;">—</span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${not empty bk.daysRemaining}">
                                            <div style="font-weight:700; color:#0d9e6e;">
                                                <c:choose>
                                                    <c:when test="${bk.daysRemaining > 0}">
                                                        ${bk.daysRemaining}d ${bk.hoursRemaining}h ${bk.minutesRemaining}m
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${bk.hoursRemaining}h ${bk.minutesRemaining}m
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${bk.status == 'OVERDUE'}">
                                        <span class="status-badge" style="background:rgba(224,40,40,0.12);color:var(--red);">⚠️ Overdue</span>
                                    </c:when>
                                    <c:when test="${bk.status == 'COMPLETED'}">
                                        <span class="status-badge badge-viewed">✅ Completed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge badge-pending">🔵 Reserved</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${bk.status == 'COMPLETED'}">
                                        <span style="opacity:0.4;">—</span>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="font-weight:600;color:var(--accent);">
                                            $<fmt:formatNumber value="${bk.dailyRate}" pattern="#,##0.00" />/day
                                        </div>
                                        <div style="font-size:0.72rem;opacity:0.6;margin-top:1px;">penalty rate</div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${bk.penaltyFee != '0.00'}">
                                        <div style="color:var(--red); font-weight:700;">$<fmt:formatNumber value="${bk.penaltyFee}" pattern="#,##0.00" /></div>
                                        <c:if test="${not empty bk.daysOverdue}">
                                            <div style="font-size:0.72rem;color:var(--red);margin-top:2px;">${bk.daysOverdue} × $<fmt:formatNumber value="${bk.dailyRate}" pattern="#,##0.00" /></div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="opacity:0.5;">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${bk.status != 'COMPLETED'}">
                                    <div style="display: flex; gap: 8px;">
                                        <button type="button" id="bkopenBtn" class="btn-action" style="color:var(--accent);"
                                                onclick="openEditBookingModal('${bk.bookingId}', '${bk.returnDate}')">
                                            Edit
                                        </button>
                                        <form action="cancelBooking" method="post" style="margin:0;" onsubmit="return confirm('⚠️ Are you sure you want to cancel this booking?\n\nThis will permanently remove the booking from the system and notify the seller.');">
                                            <input type="hidden" name="bookingId" value="${bk.bookingId}">
                                            <button type="submit" class="btn-action" id="bkcloseBtn" style="color:var(--red);">Cancel</button>
                                        </form>
                                    </div>
                                </c:if>
                                <c:if test="${bk.status == 'COMPLETED'}">
                                    <span style="opacity:0.4; font-size:0.85rem;">—</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="9" style="text-align:center; padding:40px; opacity:0.6;">You have no bookings yet.</td></tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
    <!-- ─────────────────────────────────────────────────────────────────── -->

</div>

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

<script src="app.js"></script>

<script>
    // Identity bridge for notifications on this page too
    window.currentUser = "${sessionScope.loggedUser}";
    window.currentRole = "${sessionScope.loggedRole}";
    window.allNotifications = [];
    <c:forEach items="${allNotifications}" var="n">
    window.allNotifications.push({
        sender: "${n.sender}",
        receiver: "${n.receiver}",
        message: "${n.content}",
        property: "${n.propTitle}",
        type: "${n.type}",
        threadId: "${n.threadId}"
    });
    </c:forEach>

    console.log("window.allNotifications after JSP population:", window.allNotifications);
    console.log("Number of notifications:", window.allNotifications.length);

    // Explicitly call renderNotifications after window.allNotifications is populated
    if (typeof renderNotifications === 'function') {
        renderNotifications();
    }
</script>

<!-- Buyer Inquiry Chat Modal -->
<div class="chat-overlay" id="buyerChatOverlay" onclick="closeBuyerChatIfOutside(event)">
    <div class="chat-box" onclick="event.stopPropagation()">
        <div class="chat-left">
            <div style="font-weight: 800; margin-bottom: 12px;">Inquiry Details</div>
            <div style="display:flex; flex-direction:column; gap: 10px;">
                <div>
                    <div style="font-size:0.75rem; opacity:0.7; text-transform: uppercase; letter-spacing: .6px;">Seller</div>
                    <div id="bchatSellerName" style="font-weight:700;"></div>
                </div>
                <div style="padding-top: 10px; border-top: 1px solid var(--line);">
                    <div style="font-size:0.75rem; opacity:0.7; text-transform: uppercase; letter-spacing: .6px;">Property</div>
                    <div id="bchatPropTitle" style="font-weight:700;"></div>
                    <div id="bchatPropId" style="font-size:0.85rem; opacity:0.8;"></div>
                </div>
                <div style="padding-top: 10px; border-top: 1px solid var(--line);">
                    <div style="font-size:0.75rem; opacity:0.7; text-transform: uppercase; letter-spacing: .6px;">Thread</div>
                    <div id="bchatThreadId" style="font-size:0.85rem; opacity:0.85; word-break: break-all;"></div>
                </div>
            </div>
        </div>

        <div class="chat-right">
            <div class="chat-top">
                <div class="chat-peer">
                    <div class="avatar">👤</div>
                    <div>
                        <div class="peer-name" id="bchatHeaderName">Seller</div>
                        <div class="peer-sub" id="bchatHeaderSub">Inquiry chat</div>
                    </div>
                </div>
                <button class="btn" type="button" style="background: var(--line); color: var(--ink);" onclick="closeBuyerChat()">Close</button>
            </div>

            <div class="chat-msgs" id="bchatMsgs"></div>

            <form class="chat-compose" id="buyerChatForm" action="replyInquiry" method="post">
                <input type="hidden" name="threadId" id="bchatThreadIdInput">
                <textarea class="chat-input" name="message" id="bchatInput" placeholder="Type a message..." required></textarea>
                <button class="chat-send" type="submit">Send</button>
            </form>
        </div>
    </div>
</div>

<script>
    window.buyerThreads = {};
    <c:forEach var="t" items="${buyerThreads}">
    window.buyerThreads["${t.id}"] = {
        id: "${t.id}",
        propertyId: "${t.propertyId}",
        propertyTitle: "${t.propertyTitle}",
        sellerName: "${t.sellerName}",
        createdDate: "${t.createdDate}",
        status: "${t.status}"
    };
    </c:forEach>

    function openBuyerChat(threadId) {
        const t = window.buyerThreads ? window.buyerThreads[threadId] : null;
        if (!t) return;

        // --- Populate Chat UI ---
        document.getElementById('bchatSellerName').innerText = t.sellerName || '(No seller)';
        document.getElementById('bchatPropTitle').innerText = t.propertyTitle || '(No title)';
        document.getElementById('bchatPropId').innerText = t.propertyId ? ('Property ID: ' + t.propertyId) : '';
        document.getElementById('bchatThreadId').innerText = t.id;
        document.getElementById('bchatHeaderName').innerText = t.sellerName || 'Seller';
        document.getElementById('bchatHeaderSub').innerText = (t.createdDate ? ('Created: ' + t.createdDate) : 'Inquiry chat');
        document.getElementById('bchatThreadIdInput').value = t.id;

        const msgs = document.getElementById('bchatMsgs');
        const container = document.getElementById('bthread-msgs-' + threadId);
        msgs.innerHTML = container ? container.innerHTML : '';

        // --- Show Modal & Focus ---
        document.getElementById('buyerChatOverlay').classList.add('open');
        setTimeout(() => { msgs.scrollTop = msgs.scrollHeight; }, 50);
        setTimeout(() => { document.getElementById('bchatInput').focus(); }, 80);

        // --- Mark as Read & Update UI ---
        const notifIndex = window.allNotifications.findIndex(n => n.threadId === threadId);
        if (notifIndex > -1) {
            window.allNotifications.splice(notifIndex, 1);
            if (typeof renderNotifications === 'function') {
                renderNotifications();
            }
        }

        fetch('markInquiryRead', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'threadId=' + encodeURIComponent(threadId)
        }).catch(err => console.error("Failed to mark as read on server:", err));
    }

    function closeBuyerChat() {
        document.getElementById('buyerChatOverlay').classList.remove('open');
        document.getElementById('bchatInput').value = '';
    }

    function closeBuyerChatIfOutside(event) {
        if (event.target && event.target.id === 'buyerChatOverlay') closeBuyerChat();
    }

    document.addEventListener('DOMContentLoaded', () => {
        const buyerChatForm = document.getElementById('buyerChatForm');
        if(buyerChatForm) {
            buyerChatForm.addEventListener('submit', (e) => handleChatSubmit(e, 'BUYER', buyerChatForm));

            const chatInput = document.getElementById('bchatInput');
            chatInput.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    handleChatSubmit(new Event('submit', { bubbles: true, cancelable: true }), 'BUYER', buyerChatForm);
                }
            });
        }

        const params = new URLSearchParams(window.location.search);
        const threadId = params.get('threadId');
        if (threadId) {
            setTimeout(() => openBuyerChat(threadId), 150);
        }
    });
</script>

<!-- Hidden rendered messages per thread -->
<div style="display:none;">
    <c:forEach var="t" items="${buyerThreads}">
        <div id="bthread-msgs-${t.id}">
            <c:forEach var="m" items="${t.messages}">
                <c:choose>
                    <c:when test="${m.senderRole == 'BUYER'}">
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

<!-- Edit Booking Modal -->
<div id="bkmyModal"
     style="display: none; position:fixed; z-index:1; left:0; top:0; width:100%; height:100%; background-color:rgba(0,0,0,0.4); ">
    <div style="background-color:var(--bg2); margin:15% auto; padding:20px; width:fit-content; border-radius: 8px;">
<%--        <span id="closeBtn" style="cursor:pointer; float:right;">&times;</span>--%>
        <div class="modal-overlay" id="editBookingModal" style="display: none; max-width: 290px; ">
            <div class="modal-box" style="max-width: 500px;">
<%--                <span class="close-btn" onclick="closeEditBookingModal()">&times;</span>--%>
                <h3 class="card-title">✏️ Edit Booking</h3>
                <p style="color: var(--ink); opacity: 0.7; margin-bottom: 20px;">Update your return date for this booking.</p>

                <form action="updateBooking" method="post" style="display: flex; flex-direction: column; gap: 16px;">
                    <input type="hidden" name="bookingId" id="edit-booking-id">

                    <div class="form-group">
                        <label style="font-weight: 600;">New Return Date</label>
                        <input type="date" name="returnDate" id="edit-return-date" required style="padding: 10px; border: 1.5px solid var(--line); border-radius: 6px; background: var(--bg); color: var(--ink);">
                    </div>

                    <div style="display: flex; gap: 10px; margin-top: 10px;">
                        <button type="submit" class="btn" style="flex: 1;">💾 Update Booking</button>
                        <button type="button" class="btn" style="flex: 1; background: var(--line); color: var(--ink);" onclick="closeEditBookingModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function openEditBookingModal(bookingId, currentReturnDate) {
        document.getElementById('edit-booking-id').value = bookingId;
        document.getElementById('edit-return-date').value = currentReturnDate;
        const bkmodal = document.getElementById("bkmyModal");
        const bkbtn = document.getElementById("bkopenBtn");
        const bkspan = document.getElementById("bkcloseBtn");


        bkbtn.onclick = function () {
            bkmodal.style.display = "block";
            document.getElementById('editBookingModal').style.display = 'block';
        }

        bkspan.onclick = function () {
            bkmodal.style.display = "none";
            document.getElementById('editBookingModal').style.display = 'none';
        }

        // Set minimum date to today + 1 day
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        const dateStr = tomorrow.toISOString().split('T')[0];
        document.getElementById('edit-return-date').min = dateStr;


    }

    function closeEditBookingModal() {
        const bkmodal = document.getElementById("bkmyModal");
        bkmodal.style.display = "none";
        document.getElementById('editBookingModal').style.display = 'none';
    }

    // Close modal when clicking outside
    document.getElementById('editBookingModal').addEventListener('click', function(event) {
        if (event.target === this) {
            closeEditBookingModal();
        }
    });
</script>

<script>
    // ── REPLACE PROPERTY DROPDOWN LOGIC ──────────────────────────────
    let isToggling = false;
    function toggleReplaceDropdown(propId, event) {
        event.stopPropagation();
        event.preventDefault();

        // Prevent rapid toggling
        if (isToggling) return;
        isToggling = true;
        setTimeout(() => { isToggling = false; }, 200);

        const dropdown = document.getElementById('rd-' + propId);
        const btn      = event.currentTarget;
        const isOpen   = dropdown.classList.contains('open');

        // Close ALL open replace dropdowns first
        closeAllReplaceDropdowns();

        if (!isOpen) {
            dropdown.classList.add('open');
            btn.classList.add('active');
        }
    }

    function closeAllReplaceDropdowns() {
        document.querySelectorAll('.replace-dropdown.open').forEach(d => {
            d.classList.remove('open');
        });
        document.querySelectorAll('.btn-replace.active').forEach(b => {
            b.classList.remove('active');
        });
    }

    // Close dropdowns when clicking outside
    document.addEventListener('click', function(e) {
        const isInsideDropdown = e.target.closest('.replace-dropdown');
        const isInsideWrapper = e.target.closest('.replace-wrapper');

        // Only close if clicking completely outside the dropdown and wrapper
        if (!isInsideDropdown && !isInsideWrapper) {
            closeAllReplaceDropdowns();
        }
    });
</script>

<!-- Page Transition Animation System -->
<script src="page-transitions.js"></script>

</body>
</html>