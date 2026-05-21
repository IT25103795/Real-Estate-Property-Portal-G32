<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - NESTIQ</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        :root {
            --bg: #ffffff; --bg2: #f4f6fb; --bg3: #eef1f8; --ink: #0a0e1a; --line: #e2e6f0;
            --accent: #2563eb; --accent2: #1d4ed8; --font-sans: 'Outfit', sans-serif;
            --font-mono: 'DM Mono', monospace; --r: 12px;
            --green: #059669; --green-bg: #ecfdf5;
            --red: #dc2626; --red-bg: #fef2f2;
            --amber: #d97706; --amber-bg: #fffbeb;
            --purple: #7c3aed; --purple-bg: #f5f3ff;
            --blue-bg: #eff6ff;
            --shadow: 0 2px 12px rgba(10,14,26,0.06);
            --shadow-lg: 0 8px 32px rgba(10,14,26,0.10);
        }
        [data-theme="dark"] {
            --bg: #0a0e1a; --bg2: #111827; --bg3: #1f2937; --ink: #f1f5f9; --line: #334155;
            --accent: #3b82f6; --accent2: #60a5fa;
            --green: #10b981; --green-bg: rgba(16,185,129,0.1);
            --red: #ef4444; --red-bg: rgba(239,68,68,0.1);
            --amber: #f59e0b; --amber-bg: rgba(245,158,11,0.1);
            --purple: #8b5cf6; --purple-bg: rgba(139,92,246,0.1);
            --blue-bg: rgba(59,130,246,0.1);
            --shadow: 0 4px 20px rgba(0,0,0,0.4), 0 0 0 1px rgba(255,255,255,0.05);
            --shadow-lg: 0 8px 40px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.08);
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: var(--font-sans);
            background: var(--bg2);
            color: var(--ink);
            min-height: 100vh;
            transition: background 0.3s, color 0.3s;
        }

        /* ══ LAYOUT ══ */
        .layout { display: flex; min-height: 100vh; }

        /* ══ SIDEBAR ══ */
        .sidebar {
            width: 260px; min-height: 100vh; background: var(--bg);
            border-right: 1px solid var(--line);
            display: flex; flex-direction: column;
            padding: 0;
            position: sticky; top: 0; height: 100vh; overflow-y: auto;
            flex-shrink: 0;
            transition: background 0.3s, box-shadow 0.3s;
        }
        [data-theme="dark"] .sidebar {
            box-shadow: 4px 0 24px rgba(0,0,0,0.3), 0 0 0 1px rgba(255,255,255,0.05);
        }
        .sidebar-logo {
            padding: 28px 24px 20px;
            border-bottom: 1px solid var(--line);
        }
        .sidebar-logo .logo-text {
            font-size: 1.5rem; font-weight: 800; letter-spacing: -0.5px; color: var(--accent);
        }
        .sidebar-logo .logo-sub {
            font-size: 0.75rem; opacity: 0.5; margin-top: 2px; font-weight: 500; text-transform: uppercase; letter-spacing: 1px;
        }
        .sidebar-nav { padding: 16px 12px; flex: 1; }
        .sidebar-section-label {
            font-size: 0.68rem; font-weight: 700; opacity: 0.4; text-transform: uppercase;
            letter-spacing: 1.2px; padding: 8px 12px 6px;
        }
        .nav-item {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 14px; border-radius: 9px;
            border: none; background: transparent; color: var(--ink); opacity: 0.65;
            font-family: var(--font-sans); font-size: 0.9rem; font-weight: 600;
            cursor: pointer; transition: all 0.18s; width: 100%; text-align: left;
            margin-bottom: 2px; white-space: nowrap;
        }
        .nav-item:hover { opacity: 1; background: var(--bg2); }
        [data-theme="dark"] .nav-item:hover {
            background: rgba(59,130,246,0.08);
            box-shadow: inset 0 0 0 1px rgba(59,130,246,0.1);
        }
        .nav-item { opacity: 1; background: var(--bg2); color: var(--accent); font-weight: 700; }
        [data-theme="dark"] .nav-item.active {
            background: linear-gradient(135deg, rgba(59,130,246,0.15), rgba(96,165,250,0.08));
            box-shadow: 0 0 0 1px rgba(59,130,246,0.2), inset 0 1px 0 rgba(255,255,255,0.05);
        }
        .nav-item .nav-icon { font-size: 1rem; width: 20px; text-align: center; }
        .nav-item .nav-badge {
            margin-left: auto; background: var(--accent); color: white;
            font-size: 0.68rem; font-weight: 700; padding: 2px 7px;
            border-radius: 99px; font-family: var(--font-mono);
        }
        .sidebar-footer {
            padding: 16px 12px 20px;
            border-top: 1px solid var(--line);
        }
        .admin-badge-pill {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 12px; background: var(--amber-bg);
            border-radius: 9px; margin-bottom: 10px;
            border: 1px solid transparent;
            transition: all 0.3s ease;
        }
        [data-theme="dark"] .admin-badge-pill {
            background: rgba(245,158,11,0.1);
            border-color: rgba(245,158,11,0.2);
            box-shadow: 0 2px 8px rgba(245,158,11,0.15);
        }
        .admin-badge-pill .name { font-size: 0.85rem; font-weight: 700; }
        .admin-badge-pill .role { font-size: 0.73rem; opacity: 0.6; }

        /* ══ MAIN ══ */
        .main { flex: 1; overflow: hidden; min-width: 0; }
        .topbar {
            background: var(--bg); border-bottom: 1px solid var(--line);
            padding: 16px 32px; display: flex; align-items: center;
            justify-content: space-between; gap: 16px; flex-wrap: wrap;
            position: sticky; top: 0; z-index: 50;
            transition: background 0.3s;
        }
        .topbar-title { font-size: 1.05rem; font-weight: 700; }
        .topbar-actions { display: flex; gap: 10px; align-items: center; }

        .content { padding: 28px 32px; }

        /* ══ STAT CARDS ══ */
        .stats-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 18px; margin-bottom: 28px;
        }
        .stat-card {
            background: var(--bg); border: 1px solid var(--line);
            border-radius: var(--r); padding: 22px 24px;
            box-shadow: var(--shadow); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); cursor: default;
            position: relative; overflow: hidden;
        }
        .stat-card::before {
            content: ''; position: absolute; top: 0; left: 0;
            width: 4px; height: 100%; border-radius: var(--r) 0 0 var(--r);
        }
        .stat-card.blue::before  { background: linear-gradient(180deg, var(--accent), #2563eb); }
        .stat-card.green::before { background: linear-gradient(180deg, var(--green), #059669); }
        .stat-card.amber::before { background: linear-gradient(180deg, var(--amber), #d97706); }
        .stat-card.purple::before{ background: linear-gradient(180deg, var(--purple), #7c3aed); }
        .stat-card.red::before   { background: linear-gradient(180deg, var(--red), #dc2626); }
        .stat-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-lg); }
        [data-theme="dark"] .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 48px rgba(0,0,0,0.6), 0 0 0 1px rgba(255,255,255,0.1);
        }
        .stat-icon { font-size: 1.5rem; margin-bottom: 12px; opacity: 0.9; }
        .stat-label { font-size: 0.73rem; opacity: 0.6; font-weight: 700; text-transform: uppercase; letter-spacing: 0.6px; margin-bottom: 8px; }
        .stat-value { font-size: 2.1rem; font-weight: 800; line-height: 1; letter-spacing: -1px; margin-bottom: 6px; }
        .stat-card.blue .stat-value  { color: var(--accent); }
        .stat-card.green .stat-value { color: var(--green); }
        .stat-card.amber .stat-value { color: var(--amber); }
        .stat-card.purple .stat-value{ color: var(--purple); }
        .stat-card.red .stat-value   { color: var(--red); }
        .stat-sub { font-size: 0.78rem; opacity: 0.55; margin-top: 8px; line-height: 1.4; }

        /* ══ PANELS ══ */
        .panel { display: none; }
        .panel.active { display: block; }

        /* ══ CARDS ══ */
        .card {
            background: var(--bg); border: 1px solid var(--line);
            border-radius: var(--r); padding: 24px;
            margin-bottom: 20px; box-shadow: var(--shadow);
            transition: box-shadow 0.3s ease, transform 0.3s ease;
        }
        [data-theme="dark"] .card {
            box-shadow: 0 4px 24px rgba(0,0,0,0.4), 0 0 0 1px rgba(255,255,255,0.06);
        }
        [data-theme="dark"] .card:hover {
            box-shadow: 0 8px 32px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.1);
            transform: translateY(-2px);
        }
        .card-title { font-size: 1.05rem; font-weight: 700; margin-bottom: 16px; display: flex; align-items: center; gap: 8px; }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; flex-wrap: wrap; gap: 12px; }

        /* ══ TABLE ══ */
        .table-wrap { overflow-x: auto; overflow-y: auto; max-height: 520px; border-radius: 10px; border: 1px solid var(--line); }
        table { width: 100%; border-collapse: collapse; font-size: 0.875rem; }
        th { padding: 13px 16px; border-bottom: 2px solid var(--line); font-weight: 700; color: var(--accent); background: var(--bg3); font-size: 0.76rem; text-transform: uppercase; letter-spacing: 0.5px; position: sticky; top: 0; z-index: 3; white-space: nowrap; }
        td { padding: 13px 16px; border-bottom: 1px solid var(--line); vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: var(--bg2); }
        [data-theme="dark"] tr:hover td { background: rgba(59,130,246,0.05); }
        .truncate { max-width: 220px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

        /* ══ BUTTONS ══ */
        .btn { display: inline-flex; align-items: center; gap: 7px; background: var(--accent); color: white; padding: 10px 20px; border: none; border-radius: 9px; font-weight: 700; font-family: var(--font-sans); cursor: pointer; transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1); font-size: 0.875rem; text-decoration: none; box-shadow: 0 2px 8px rgba(37,99,235,0.15); }
        .btn:hover { background: var(--accent2); transform: translateY(-2px); box-shadow: 0 6px 20px rgba(37,99,235,0.35); }
        [data-theme="dark"] .btn { box-shadow: 0 2px 12px rgba(59,130,246,0.25); }
        [data-theme="dark"] .btn:hover { box-shadow: 0 6px 24px rgba(59,130,246,0.45); }
        .btn-sm { padding: 6px 14px; font-size: 0.8rem; border-radius: 7px; }
        .btn-danger { background: var(--red); box-shadow: 0 2px 8px rgba(220,38,38,0.15); } .btn-danger:hover { background: #b91c1c; box-shadow: 0 6px 20px rgba(220,38,38,0.35); }
        [data-theme="dark"] .btn-danger { box-shadow: 0 2px 12px rgba(239,68,68,0.25); }
        [data-theme="dark"] .btn-danger:hover { box-shadow: 0 6px 24px rgba(239,68,68,0.45); }
        .btn-amber  { background: var(--amber); box-shadow: 0 2px 8px rgba(217,119,6,0.15); } .btn-amber:hover  { background: #b45309; box-shadow: 0 6px 20px rgba(217,119,6,0.35); }
        [data-theme="dark"] .btn-amber { box-shadow: 0 2px 12px rgba(245,158,11,0.25); }
        [data-theme="dark"] .btn-amber:hover { box-shadow: 0 6px 24px rgba(245,158,11,0.45); }
        .btn-green  { background: var(--green); box-shadow: 0 2px 8px rgba(5,150,105,0.15); } .btn-green:hover  { background: #047857; box-shadow: 0 6px 20px rgba(5,150,105,0.35); }
        [data-theme="dark"] .btn-green { box-shadow: 0 2px 12px rgba(16,185,129,0.25); }
        [data-theme="dark"] .btn-green:hover { box-shadow: 0 6px 24px rgba(16,185,129,0.45); }
        .btn-purple { background: var(--purple); box-shadow: 0 2px 8px rgba(124,58,237,0.15); } .btn-purple:hover { background: #5b21b6; box-shadow: 0 6px 20px rgba(124,58,237,0.35); }
        [data-theme="dark"] .btn-purple { box-shadow: 0 2px 12px rgba(139,92,246,0.25); }
        [data-theme="dark"] .btn-purple:hover { box-shadow: 0 6px 24px rgba(139,92,246,0.45); }
        .btn-ghost { background: none; border: 1.5px solid var(--line); color: var(--ink); padding: 9px 18px; border-radius: 9px; cursor: pointer; font-weight: 600; font-family: var(--font-sans); font-size: 0.875rem; transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1); }
        .btn-ghost:hover { border-color: var(--ink); background: var(--bg2); transform: translateY(-2px); }
        [data-theme="dark"] .btn-ghost:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.3); }

        /* ══ BADGES ══ */
        .badge { display: inline-block; padding: 3px 10px; border-radius: 99px; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.4px; }
        .badge-buyer    { background: var(--blue-bg);   color: var(--accent); }
        .badge-seller   { background: var(--green-bg);  color: var(--green); }
        .badge-admin    { background: var(--amber-bg);  color: var(--amber); }
        .badge-sale     { background: var(--green-bg);  color: var(--green); }
        .badge-rent     { background: var(--blue-bg);   color: var(--accent); }
        .badge-verified { background: var(--purple-bg); color: var(--purple); }
        .badge-public   { background: var(--bg3); color: var(--ink); opacity:0.7; }
        .badge-completed{ background: var(--green-bg);  color: var(--green); }
        .badge-reserved { background: var(--blue-bg);   color: var(--accent); }
        .badge-cancelled{ background: var(--red-bg);    color: var(--red); }
        .badge-sold     { background: var(--amber-bg);  color: var(--amber); }

        /* ══ SEARCH ══ */
        .search-box { padding: 9px 16px; border: 1.5px solid var(--line); border-radius: 9px; background: var(--bg); color: var(--ink); font-family: var(--font-sans); font-size: 0.875rem; min-width: 240px; transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1); }
        .search-box:focus { border-color: var(--accent); outline: none; box-shadow: 0 0 0 3px rgba(37,99,235,0.12); }
        [data-theme="dark"] .search-box:focus { box-shadow: 0 0 0 3px rgba(59,130,246,0.2), 0 2px 8px rgba(0,0,0,0.3); }
        .search-box::placeholder { opacity: 0.5; }

        /* ══ THEME SWITCH ══ */
        .theme-switch { position: relative; width: 50px; height: 28px; background-color: var(--line); border-radius: 30px; cursor: pointer; display: flex; align-items: center; padding: 4px; transition: background-color 0.4s ease; }
        .theme-switch-thumb { width: 20px; height: 20px; background-color: white; border-radius: 50%; box-shadow: 0 2px 5px rgba(0,0,0,0.2); display: flex; align-items: center; justify-content: center; font-size: 0.7rem; transition: transform 0.4s cubic-bezier(0.34,1.56,0.64,1); }
        [data-theme="dark"] .theme-switch { background-color: var(--accent); }
        [data-theme="dark"] .theme-switch-thumb { transform: translateX(22px); }

        /* ══ FLASH ══ */
        .flash-message { padding: 14px 18px; margin-bottom: 20px; border-radius: var(--r); font-weight: 600; border: 1px solid transparent; display: flex; justify-content: space-between; align-items: center; }
        .flash-success { background: var(--green-bg); color: var(--green); border-color: var(--green); }
        .flash-error   { background: var(--red-bg);   color: var(--red);   border-color: var(--red); }

        /* ══ ROLE SELECT ══ */
        .role-select { padding: 5px 10px; border: 1.5px solid var(--line); border-radius: 6px; background: var(--bg); color: var(--ink); font-family: var(--font-sans); font-size: 0.8rem; cursor: pointer; }

        /* ══ CHARTS ══ */
        .charts-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; margin-bottom: 20px; }
        .chart-card { background: var(--bg); border: 1px solid var(--line); border-radius: var(--r); padding: 24px; box-shadow: var(--shadow); }
        .chart-card canvas { max-height: 240px; }
        .chart-title { font-size: 0.95rem; font-weight: 700; margin-bottom: 16px; display: flex; align-items: center; gap: 6px; }

        /* ══ STARS ══ */
        .stars { color: #f59e0b; letter-spacing: 1px; }

        /* ══ ADMIN ROW ══ */
        tr.admin-row { background: var(--amber-bg) !important; }
        tr.admin-row td { border-bottom: 1px solid rgba(217,119,6,0.2) !important; font-weight: 600; }
        .pin-icon { font-size: 0.65rem; opacity: 0.7; margin-left: 5px; }

        /* ══ EMPTY STATE ══ */
        .empty-state { text-align: center; padding: 48px; opacity: 0.4; font-size: 0.9rem; }

        /* ══ MODAL ══ */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center; backdrop-filter: blur(4px); }
        .modal-box { background: var(--bg); border-radius: 14px; padding: 32px; width: 100%; max-width: 520px; box-shadow: var(--shadow-lg); border: 1px solid var(--line); }
        .modal-title { font-size: 1.1rem; font-weight: 700; margin-bottom: 20px; }
        .form-group { margin-bottom: 16px; }
        .form-label { display: block; font-size: 0.82rem; font-weight: 700; margin-bottom: 6px; opacity: 0.7; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-input { width: 100%; padding: 10px 12px; border: 1.5px solid var(--line); border-radius: 8px; background: var(--bg); color: var(--ink); font-family: var(--font-sans); font-size: 0.9rem; box-sizing: border-box; transition: border-color 0.2s; }
        .form-input:focus { border-color: var(--accent); outline: none; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }

        /* ══ INFO GRID ══ */
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; }
        .info-block { background: var(--bg2); border-radius: 10px; padding: 16px; border: 1px solid var(--line); }
        .info-label { font-size: 0.73rem; opacity: 0.5; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 6px; font-weight: 700; }
        .info-value { font-size: 1rem; font-weight: 700; }

        /* ══ CAPABILITY CARDS ══ */
        .cap-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 14px; }
        .cap-card { padding: 16px; background: var(--bg2); border-radius: 10px; border: 1px solid var(--line); }
        .cap-icon { font-size: 1.4rem; margin-bottom: 8px; }
        .cap-title { font-weight: 700; margin-bottom: 4px; font-size: 0.9rem; }
        .cap-desc  { font-size: 0.8rem; opacity: 0.55; }

        /* ══ PLATFORM SUMMARY ══ */
        .summary-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(170px, 1fr)); gap: 14px; }
        .summary-item { background: var(--bg2); border-radius: 10px; padding: 16px; border: 1px solid var(--line); text-align: center; }
        .summary-num { font-size: 1.6rem; font-weight: 800; letter-spacing: -0.5px; }
        .summary-lbl { font-size: 0.75rem; opacity: 0.5; margin-top: 4px; font-weight: 600; text-transform: uppercase; }

        /* ══ ACTIVITY FEED ══ */
        .activity-feed { display: flex; flex-direction: column; gap: 0; }
        .activity-item {
            display: flex; align-items: flex-start; gap: 14px;
            padding: 12px 0; border-bottom: 1px solid var(--line); position: relative;
        }
        .activity-item:last-child { border-bottom: none; }
        .activity-dot { width: 34px; height: 34px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.85rem; flex-shrink: 0; margin-top: 2px; }
        .activity-dot.booking  { background: var(--blue-bg);   color: var(--accent); }
        .activity-dot.sold     { background: var(--amber-bg);  color: var(--amber); }
        .activity-dot.review   { background: var(--purple-bg); color: var(--purple); }
        .activity-dot.user     { background: var(--green-bg);  color: var(--green); }
        .activity-text { font-size: 0.875rem; font-weight: 600; line-height: 1.4; }
        .activity-time { font-size: 0.75rem; opacity: 0.45; margin-top: 2px; font-family: var(--font-mono); }

        /* ══ TOP SELLERS TABLE ══ */
        .leaderboard { display: flex; flex-direction: column; gap: 8px; }
        .leaderboard-row { display: flex; align-items: center; gap: 12px; padding: 10px 14px; background: var(--bg2); border-radius: 8px; border: 1px solid var(--line); }
        .leaderboard-rank { font-family: var(--font-mono); font-size: 0.8rem; font-weight: 700; opacity: 0.4; width: 20px; }
        .leaderboard-name { font-weight: 700; font-size: 0.875rem; flex: 1; }
        .leaderboard-bar-wrap { flex: 2; background: var(--bg3); border-radius: 4px; height: 6px; overflow: hidden; }
        .leaderboard-bar { height: 100%; background: var(--accent); border-radius: 4px; transition: width 0.6s ease; }
        .leaderboard-count { font-family: var(--font-mono); font-size: 0.8rem; font-weight: 700; color: var(--accent); width: 28px; text-align: right; }

        /* ══ BOOKING DETAIL BADGE ══ */
        .booking-status { padding: 4px 10px; border-radius: 99px; font-size: 0.7rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.4px; }

        /* ══ RESPONSIVE ══ */
        @media (max-width: 900px) {
            .sidebar { display: none; }
            .content { padding: 20px 16px; }
            .topbar { padding: 14px 16px; }
        }

        /* ══ ANIMATIONS ══ */
        .panel.active { animation: fadeIn 0.2s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }

        /* ══ SCROLL ══ */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: var(--line); border-radius: 3px; }
    </style>
</head>
<body data-theme="light" id="body-theme">

<div class="layout">

    <!-- ══════════════ SIDEBAR ══════════════ -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <div class="logo-text">NESTIQ</div>
            <div class="logo-sub">Admin Control Panel</div>
        </div>

        <nav class="sidebar-nav">
            <div class="sidebar-section-label">Overview</div>
            <button class="nav-item active" onclick="showPanel('overview', this)">
                <span class="nav-icon">🏠</span> Dashboard
            </button>

            <div class="sidebar-section-label" style="margin-top:12px;">Management</div>
            <button class="nav-item" onclick="showPanel('users', this)">
                <span class="nav-icon">👥</span> Users
                <span class="nav-badge" id="badge-users">${totalUsers}</span>
            </button>
            <button class="nav-item" onclick="showPanel('properties', this)">
                <span class="nav-icon">🏘️</span> Properties
                <span class="nav-badge" id="badge-props">${totalProperties}</span>
            </button>
            <button class="nav-item" onclick="showPanel('bookings', this)">
                <span class="nav-icon">📅</span> Bookings
                <span class="nav-badge" id="badge-bookings">${totalBookings}</span>
            </button>
            <button class="nav-item" onclick="showPanel('sold', this)">
                <span class="nav-icon">🏆</span> Sold Properties
                <span class="nav-badge" id="badge-sold">${totalSoldProperties}</span>
            </button>
            <button class="nav-item" onclick="showPanel('reviews', this)">
                <span class="nav-icon">⭐</span> Reviews
                <span class="nav-badge" id="badge-reviews">${totalReviews}</span>
            </button>
            <button class="nav-item" onclick="showPanel('announcements', this)">
                <span class="nav-icon">📢</span> Announcements
            </button>

            <div class="sidebar-section-label" style="margin-top:12px;">Insights</div>
            <button class="nav-item" onclick="showPanel('analytics', this)">
                <span class="nav-icon">📊</span> Analytics
            </button>

            <div class="sidebar-section-label" style="margin-top:12px;">Account</div>
            <button class="nav-item" onclick="showPanel('account', this)">
                <span class="nav-icon">👑</span> My Account
            </button>
        </nav>

        <div class="sidebar-footer">
            <div class="admin-badge-pill">
                <span style="font-size:1.2rem;">👑</span>
                <div>
                    <div class="name">${sessionScope.loggedUser}</div>
                    <div class="role">System Administrator</div>
                </div>
            </div>
            <form action="logout" method="post" style="margin:0;">
                <button type="submit" class="btn btn-danger" style="width:100%; justify-content:center;">Sign Out</button>
            </form>
        </div>
    </aside>

    <!-- ══════════════ MAIN CONTENT ══════════════ -->
    <div class="main">

        <!-- TOPBAR -->
        <div class="topbar">
            <div class="topbar-title" id="topbar-title">Dashboard Overview</div>
            <div class="topbar-actions">
                <div class="theme-switch" onclick="toggleTheme()" title="Toggle Theme">
                    <div class="theme-switch-thumb" id="theme-toggle">🌙</div>
                </div>
            </div>
        </div>

        <!-- CONTENT -->
        <div class="content">

            <!-- FLASH MESSAGE -->
            <c:if test="${not empty sessionScope.flashMessage}">
                <div class="flash-message ${sessionScope.flashMessageType == 'success' ? 'flash-success' : 'flash-error'}">
                    <span>${sessionScope.flashMessage}</span>
                    <button onclick="this.parentElement.remove()" style="background:none;border:none;cursor:pointer;font-size:1.1rem;opacity:0.6;">✕</button>
                </div>
                <c:remove var="flashMessage" scope="session"/>
                <c:remove var="flashMessageType" scope="session"/>
            </c:if>

            <!-- ══════════ PANEL: OVERVIEW ══════════ -->
            <div class="panel active" id="panel-overview">

                <!-- STAT CARDS -->
                <div class="stats-grid">
                    <div class="stat-card blue">
                        <div class="stat-icon">👥</div>
                        <div class="stat-label">Total Users</div>
                        <div class="stat-value">${totalUsers}</div>
                        <div class="stat-sub">Buyers, Sellers & Admins</div>
                    </div>
                    <div class="stat-card green">
                        <div class="stat-icon">🏘️</div>
                        <div class="stat-label">Active Properties</div>
                        <div class="stat-value">${totalProperties}</div>
                        <div class="stat-sub">Currently listed for sale/rent</div>
                    </div>
                    <div class="stat-card amber">
                        <div class="stat-icon">📅</div>
                        <div class="stat-label">Total Bookings</div>
                        <div class="stat-value">${totalBookings}</div>
                        <div class="stat-sub">${reservedBookings} active reservations</div>
                    </div>
                    <div class="stat-card purple">
                        <div class="stat-icon">⭐</div>
                        <div class="stat-label">Platform Reviews</div>
                        <div class="stat-value">${totalReviews}</div>
                        <div class="stat-sub">Verified & public feedback</div>
                    </div>
                    <div class="stat-card green">
                        <div class="stat-icon">✅</div>
                        <div class="stat-label">Completed Bookings</div>
                        <div class="stat-value">${completedBookings}</div>
                        <div class="stat-sub">Successfully closed deals</div>
                    </div>
                    <div class="stat-card amber">
                        <div class="stat-icon">🏆</div>
                        <div class="stat-label">Sold Properties</div>
                        <div class="stat-value">${totalSoldProperties}</div>
                        <div class="stat-sub">Marked as sold by sellers</div>
                    </div>
                    <div class="stat-card blue">
                        <div class="stat-icon">💼</div>
                        <div class="stat-label">Market Value</div>
                        <div class="stat-value" style="font-size:1.35rem;">LKR <fmt:formatNumber value="${totalPropertyValue}" pattern="#,##0"/></div>
                        <div class="stat-sub">Combined listing values</div>
                    </div>
                    <div class="stat-card green">
                        <div class="stat-icon">💰</div>
                        <div class="stat-label">Total Revenue</div>
                        <div class="stat-value" style="font-size:1.35rem;">LKR <fmt:formatNumber value="${not empty totalEarnings ? totalEarnings : 0}" pattern="#,##0.00"/></div>
                        <div class="stat-sub">From completed bookings</div>
                    </div>
                    <div class="stat-card purple">
                        <div class="stat-icon">🏷️</div>
                        <div class="stat-label">Sellers Active</div>
                        <div class="stat-value">${totalSellers}</div>
                        <div class="stat-sub">${totalBuyers} buyers registered</div>
                    </div>
                </div>

                <!-- OVERVIEW CHARTS + ACTIVITY -->
                <div style="display:grid; grid-template-columns: 1fr 340px; gap: 20px;">
                    <div class="charts-grid" style="margin-bottom:0; grid-template-columns: 1fr 1fr;">
                        <div class="chart-card">
                            <div class="chart-title">👤 User Distribution</div>
                            <canvas id="overviewUserPie"></canvas>
                        </div>
                        <div class="chart-card">
                            <div class="chart-title">📅 Booking Status</div>
                            <canvas id="overviewBookingStatus"></canvas>
                        </div>
                    </div>

                    <!-- RECENT ACTIVITY -->
                    <div class="card" style="margin-bottom:0;">
                        <div class="card-title">⚡ Recent Activity</div>
                        <div class="activity-feed" id="activity-feed">
                            <!-- populated by JS from table data -->
                        </div>
                    </div>
                </div>

                <!-- TOP SELLERS -->
                <div class="card" style="margin-top:20px;">
                    <div class="card-title">🏅 Top Sellers by Listings</div>
                    <div class="leaderboard" id="top-sellers-board"></div>
                </div>

            </div><!-- /panel-overview -->


            <!-- ══════════ PANEL: USERS ══════════ -->
            <div class="panel" id="panel-users">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title" style="margin-bottom:4px;">👥 User Management</div>
                            <p style="margin:0; opacity:0.6; font-size:0.85rem; line-height:1.5;">Manage user accounts, change roles, or remove users from the platform</p>
                        </div>
                        <div style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                            <input type="text" id="user-search" class="search-box" placeholder="🔍 Search by name or email…" autocomplete="off"/>
                            <button class="btn-ghost btn-sm btn" onclick="exportTableToCSV('user-management-table','users.csv')" title="Download user data as CSV">⬇ Export CSV</button>
                        </div>
                    </div>
                    <div class="table-wrap">
                        <table id="user-management-table">
                            <thead>
                                <tr>
                                    <th>Name</th><th>Email Address</th><th>Phone</th><th>Current Role</th><th>Change Role</th><th>Delete Account</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty allUsers}">
                                        <c:forEach var="user" items="${allUsers}">
                                            <tr ${user.role eq 'ADMIN' ? 'class="admin-row"' : ''}>
                                                <td><strong>${user.username}</strong><c:if test="${user.role eq 'ADMIN'}"><span class="pin-icon" title="System Administrator">📌</span></c:if></td>
                                                <td>${user.email}</td>
                                                <td>${not empty user.phoneNumber ? user.phoneNumber : '—'}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.role eq 'BUYER'}"><span class="badge badge-buyer">🏠 Buyer</span></c:when>
                                                        <c:when test="${user.role eq 'SELLER'}"><span class="badge badge-seller">💼 Seller</span></c:when>
                                                        <c:when test="${user.role eq 'ADMIN'}"><span class="badge badge-admin">👑 Admin</span></c:when>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.role ne 'ADMIN'}">
                                                            <form action="changeRole" method="post" style="display:inline-flex; gap:6px; align-items:center;">
                                                                <input type="hidden" name="userEmail" value="${user.email}"/>
                                                                <select name="newRole" class="role-select">
                                                                    <option value="BUYER"  ${user.role eq 'BUYER'  ? 'selected' : ''}>Buyer</option>
                                                                    <option value="SELLER" ${user.role eq 'SELLER' ? 'selected' : ''}>Seller</option>
                                                                </select>
                                                                <button type="submit" class="btn btn-amber btn-sm">Save</button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise><span style="opacity:0.4; font-size:0.8rem;">Protected</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.role ne 'ADMIN'}">
                                                            <form action="deleteUser" method="post" style="display:inline;" onsubmit="return confirm('Delete ${user.username}? This cannot be undone.');">
                                                                <input type="hidden" name="userEmail" value="${user.email}"/>
                                                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise><span style="color:var(--amber); font-weight:700; font-size:0.8rem;">System User</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise><tr><td colspan="6" class="empty-state"><div style="font-size:3rem; margin-bottom:12px;">👥</div>No users found<br/><small style="opacity:0.5;">User accounts will appear here after registration</small></td></tr></c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div><!-- /panel-users -->


            <!-- ══════════ PANEL: PROPERTIES ══════════ -->
            <div class="panel" id="panel-properties">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title" style="margin-bottom:4px;">🏘️ Property Management</div>
                            <p style="margin:0; opacity:0.6; font-size:0.85rem; line-height:1.5;">View and manage all active property listings across the platform</p>
                        </div>
                        <div style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                            <input type="text" id="property-search" class="search-box" placeholder="🔍 Search by title or seller…" autocomplete="off"/>
                            <button class="btn-ghost btn-sm btn" onclick="exportTableToCSV('property-management-table','properties.csv')" title="Download property data as CSV">⬇ Export CSV</button>
                        </div>
                    </div>
                    <div class="table-wrap">
                        <table id="property-management-table">
                            <thead>
                                <tr><th>ID</th><th>Property Title</th><th>Price</th><th>Location</th><th>Type</th><th>Status</th><th>Seller</th><th>Action</th></tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty allProperties}">
                                        <c:forEach var="prop" items="${allProperties}">
                                            <tr>
                                                <td><small style="opacity:0.4; font-family:var(--font-mono);">${prop.id}</small></td>
                                                <td><strong>${prop.title}</strong></td>
                                                <td><strong>LKR <fmt:formatNumber value="${prop.price}" pattern="#,##0"/></strong></td>
                                                <td>${prop.location}</td>
                                                <td>${prop.type}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${prop.status eq 'For Sale'}"><span class="badge badge-sale">For Sale</span></c:when>
                                                        <c:otherwise><span class="badge badge-rent">For Rent</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${prop.sellerName}</td>
                                                <td>
                                                    <form action="deleteProperty" method="post" style="display:inline;" onsubmit="return confirm('Delete property &quot;${prop.title}&quot;?');">
                                                        <input type="hidden" name="propertyId" value="${prop.id}"/>
                                                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise><tr><td colspan="8" class="empty-state"><div style="font-size:3rem; margin-bottom:12px;">🏘️</div>No properties found<br/><small style="opacity:0.5;">Active listings will appear here when sellers add properties</small></td></tr></c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div><!-- /panel-properties -->


            <!-- ══════════ PANEL: BOOKINGS (NEW) ══════════ -->
            <div class="panel" id="panel-bookings">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title" style="margin-bottom:4px;">📅 Booking Management</div>
                            <p style="margin:0; opacity:0.6; font-size:0.85rem; line-height:1.5;">Monitor all property reservations, completed deals, and cancellations</p>
                        </div>
                        <div style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                            <select id="booking-status-filter" class="role-select" onchange="filterBookingsByStatus(this.value)">
                                <option value="">All Statuses</option>
                                <option value="RESERVED">Reserved</option>
                                <option value="COMPLETED">Completed</option>
                                <option value="CANCELLED">Cancelled</option>
                            </select>
                            <input type="text" id="booking-search" class="search-box" placeholder="🔍 Search by buyer, property or seller…" autocomplete="off"/>
                            <button class="btn-ghost btn-sm btn" onclick="exportTableToCSV('bookings-table','bookings.csv')" title="Download booking data as CSV">⬇ Export CSV</button>
                        </div>
                    </div>

                    <!-- Booking Summary Pills -->
                    <div style="display:flex; gap:12px; flex-wrap:wrap; margin-bottom:20px;">
                        <div style="display:flex; align-items:center; gap:10px; background:var(--blue-bg); border-radius:9px; padding:10px 16px; border: 1px solid var(--line);">
                            <span style="font-size:0.85rem; font-weight:700; color:var(--accent);">📅 Total Bookings</span>
                            <span style="font-family:var(--font-mono); font-weight:800; color:var(--accent); font-size:1.1rem;">${totalBookings}</span>
                        </div>
                        <div style="display:flex; align-items:center; gap:10px; background:var(--green-bg); border-radius:9px; padding:10px 16px; border: 1px solid var(--line);">
                            <span style="font-size:0.85rem; font-weight:700; color:var(--green);">✅ Completed</span>
                            <span style="font-family:var(--font-mono); font-weight:800; color:var(--green); font-size:1.1rem;">${completedBookings}</span>
                        </div>
                        <div style="display:flex; align-items:center; gap:10px; background:var(--amber-bg); border-radius:9px; padding:10px 16px; border: 1px solid var(--line);">
                            <span style="font-size:0.85rem; font-weight:700; color:var(--amber);">🔖 Reserved</span>
                            <span style="font-family:var(--font-mono); font-weight:800; color:var(--amber); font-size:1.1rem;">${reservedBookings}</span>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <table id="bookings-table">
                            <thead>
                                <tr>
                                    <th>Booking ID</th><th>Property</th><th>Seller</th>
                                    <th>Buyer</th><th>Buyer Email</th>
                                    <th>Rental Start</th><th>Rental End</th><th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty allBookings}">
                                        <c:forEach var="booking" items="${allBookings}">
                                            <tr>
                                                <td><small style="opacity:0.45; font-family:var(--font-mono);">${booking[0]}</small></td>
                                                <td>
                                                    <div style="font-weight:600;">${booking[2]}</div>
                                                    <small style="opacity:0.45; font-family:var(--font-mono);">${booking[1]}</small>
                                                </td>
                                                <td>${booking[3]}</td>
                                                <td><strong>${booking[5]}</strong></td>
                                                <td style="font-size:0.82rem; opacity:0.75;">${booking[6]}</td>
                                                <td style="font-family:var(--font-mono); font-size:0.82rem;">${booking[8]}</td>
                                                <td style="font-family:var(--font-mono); font-size:0.82rem;">${booking[9]}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${booking[10] eq 'COMPLETED'}"><span class="badge badge-completed">✅ Completed</span></c:when>
                                                        <c:when test="${booking[10] eq 'RESERVED'}"><span class="badge badge-reserved">🔖 Reserved</span></c:when>
                                                        <c:when test="${booking[10] eq 'CANCELLED'}"><span class="badge badge-cancelled">❌ Cancelled</span></c:when>
                                                        <c:otherwise><span class="badge badge-public">${booking[10]}</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise><tr><td colspan="8" class="empty-state"><div style="font-size:3rem; margin-bottom:12px;">📅</div>No bookings found<br/><small style="opacity:0.5;">Bookings will appear here when buyers reserve properties</small></td></tr></c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div><!-- /panel-bookings -->


            <!-- ══════════ PANEL: SOLD PROPERTIES (NEW) ══════════ -->
            <div class="panel" id="panel-sold">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title" style="margin-bottom:4px;">🏆 Sold Properties</div>
                            <p style="margin:0; opacity:0.6; font-size:0.85rem; line-height:1.5;">View all properties marked as 'Sold' by sellers on the platform</p>
                        </div>
                        <div style="display:flex; gap:10px; align-items:center;">
                            <input type="text" id="sold-search" class="search-box" placeholder="🔍 Search by title or location…" autocomplete="off"/>
                            <button class="btn-ghost btn-sm btn" onclick="exportTableToCSV('sold-table','sold_properties.csv')" title="Download sold properties data as CSV">⬇ Export CSV</button>
                        </div>
                    </div>

                    <div style="margin-bottom:18px;">
                        <div style="display:inline-flex; align-items:center; gap:10px; background:var(--amber-bg); border-radius:9px; padding:10px 16px; border: 1px solid var(--line);">
                            <span style="font-size:0.85rem; font-weight:700; color:var(--amber);">🏆 Total Sold Properties</span>
                            <span style="font-family:var(--font-mono); font-weight:800; color:var(--amber); font-size:1.1rem;">${totalSoldProperties}</span>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <table id="sold-table">
                            <thead>
                                <tr><th>Property ID</th><th>Title</th><th>Price</th><th>Location</th><th>Type</th><th>Seller</th></tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty allProperties}">
                                        <c:forEach var="prop" items="${allProperties}">
                                            <c:if test="${prop.status eq 'Sold'}">
                                                <tr>
                                                    <td><small style="opacity:0.45; font-family:var(--font-mono);">${prop.id}</small></td>
                                                    <td><strong>${prop.title}</strong></td>
                                                    <td><strong style="color:var(--green);">LKR <fmt:formatNumber value="${prop.price}" pattern="#,##0"/></strong></td>
                                                    <td>${prop.location}</td>
                                                    <td>${prop.type}</td>
                                                    <td>${prop.sellerName}</td>
                                                </tr>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise><tr><td colspan="6" class="empty-state"><div style="font-size:3rem; margin-bottom:12px;">🏠</div>No sold properties found yet<br/><small style="opacity:0.5;">Sold properties will appear here when sellers mark them as sold</small></td></tr></c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div><!-- /panel-sold -->


            <!-- ══════════ PANEL: REVIEWS ══════════ -->
            <div class="panel" id="panel-reviews">
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title" style="margin-bottom:4px;">⭐ Review Management</div>
                            <p style="margin:0; opacity:0.6; font-size:0.85rem; line-height:1.5;">Monitor and remove inappropriate reviews to maintain platform quality</p>
                        </div>
                        <div style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                            <input type="text" id="review-search" class="search-box" placeholder="🔍 Search by buyer name or property ID…" autocomplete="off"/>
                            <button class="btn-ghost btn-sm btn" onclick="exportTableToCSV('review-management-table','reviews.csv')" title="Download review data as CSV">⬇ Export CSV</button>
                        </div>
                    </div>
                    <div class="table-wrap">
                        <table id="review-management-table">
                            <thead>
                                <tr><th>Review ID</th><th>Property ID</th><th>Buyer</th><th>Rating</th><th>Comment</th><th>Type</th><th>Action</th></tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty allReviews}">
                                        <c:forEach var="rev" items="${allReviews}">
                                            <tr>
                                                <td><small style="opacity:0.4; font-family:var(--font-mono);">${rev.reviewID}</small></td>
                                                <td><small style="font-family:var(--font-mono);">${rev.propertyID}</small></td>
                                                <td><strong>${rev.buyerName}</strong></td>
                                                <td>
                                                    <span class="stars">
                                                        <c:forEach begin="1" end="${rev.rating}">★</c:forEach><c:forEach begin="${rev.rating + 1}" end="5">☆</c:forEach>
                                                    </span>
                                                    <small style="opacity:0.5;"> ${rev.rating}/5</small>
                                                </td>
                                                <td class="truncate" title="${rev.comment}" style="font-style:italic; opacity:0.8;">${rev.comment}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${rev.verified}"><span class="badge badge-verified">✔ Verified</span></c:when>
                                                        <c:otherwise><span class="badge badge-public">Public</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <form action="adminDeleteReview" method="post" style="display:inline;" onsubmit="return confirm('Remove this review by ${rev.buyerName}?');">
                                                        <input type="hidden" name="reviewId" value="${rev.reviewID}"/>
                                                        <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise><tr><td colspan="7" class="empty-state"><div style="font-size:3rem; margin-bottom:12px;">⭐</div>No reviews found<br/><small style="opacity:0.5;">Reviews will appear here as buyers submit feedback</small></td></tr></c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div><!-- /panel-reviews -->


            <!-- ══════════ PANEL: ANNOUNCEMENTS ══════════ -->
            <div class="panel" id="panel-announcements">
                <div class="card" style="margin-bottom:0; border-bottom:none; border-radius:var(--r) var(--r) 0 0; border-left:4px solid var(--accent);">
                    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
                        <div>
                            <div class="card-title" style="margin-bottom:4px;">📢 Platform Announcements</div>
                            <p style="margin:0; opacity:0.6; font-size:0.85rem; line-height:1.5;">Create, manage and track platform-wide communications with targeted audience and expiration dates</p>
                        </div>
                        <button class="btn" onclick="document.getElementById('create-ann-modal').style.display='flex'">+ New Announcement</button>
                    </div>
                </div>

                <!-- Announcement Summary Stats -->
                <div class="card" style="border-radius:0; border-top:none; border-bottom:none; padding:18px 24px;">
                    <div style="display:flex; gap:14px; flex-wrap:wrap;">
                        <div style="display:flex; align-items:center; gap:10px; background:var(--blue-bg); border-radius:9px; padding:10px 16px; border: 1px solid var(--line);">
                            <span style="font-size:0.85rem; font-weight:700; color:var(--accent);">📢 Total</span>
                            <span style="font-family:var(--font-mono); font-weight:800; color:var(--accent); font-size:1.1rem;">${not empty announcements ? announcements.size() : 0}</span>
                        </div>
                        <div style="display:flex; align-items:center; gap:10px; background:#fee2e2; border-radius:9px; padding:10px 16px; border: 1px solid var(--line);">
                            <span style="font-size:0.85rem; font-weight:700; color:#b91c1c;">🔴 High Priority</span>
                            <span style="font-family:var(--font-mono); font-weight:800; color:#b91c1c; font-size:1.1rem;" id="count-high">0</span>
                        </div>
                        <div style="display:flex; align-items:center; gap:10px; background:#fef9c3; border-radius:9px; padding:10px 16px; border: 1px solid var(--line);">
                            <span style="font-size:0.85rem; font-weight:700; color:#92400e;">🟡 Medium</span>
                            <span style="font-family:var(--font-mono); font-weight:800; color:#92400e; font-size:1.1rem;" id="count-medium">0</span>
                        </div>
                        <div style="display:flex; align-items:center; gap:10px; background:#dcfce7; border-radius:9px; padding:10px 16px; border: 1px solid var(--line);">
                            <span style="font-size:0.85rem; font-weight:700; color:#15803d;">🟢 Low</span>
                            <span style="font-family:var(--font-mono); font-weight:800; color:#15803d; font-size:1.1rem;" id="count-low">0</span>
                        </div>
                    </div>
                </div>

                <div class="card" style="border-radius:0 0 var(--r) var(--r); overflow-x:auto;">
                    <!-- Advanced Filters -->
                    <div style="display:flex; gap:10px; margin-bottom:18px; flex-wrap:wrap; align-items:center;">
                        <input type="text" id="announcement-search" class="search-box" placeholder="🔍 Search by title or message…" autocomplete="off" style="min-width:280px;"/>
                        <select id="announcement-priority-filter" class="role-select" onchange="filterAnnouncements()" style="min-width:140px;">
                            <option value="">All Priorities</option>
                            <option value="HIGH">🔴 High Priority</option>
                            <option value="MEDIUM">🟡 Medium Priority</option>
                            <option value="LOW">🟢 Low Priority</option>
                        </select>
                        <select id="announcement-category-filter" class="role-select" onchange="filterAnnouncements()" style="min-width:140px;">
                            <option value="">All Categories</option>
                            <option value="MAINTENANCE">🛠️ Maintenance</option>
                            <option value="UPDATE">💡 Updates</option>
                            <option value="EVENT">🎉 Events</option>
                            <option value="ALERT">⚠️ Alerts</option>
                            <option value="GENERAL">📢 General</option>
                        </select>
                        <button class="btn-ghost btn-sm btn" onclick="exportTableToCSV('announcements-table','announcements.csv')" title="Download announcements data as CSV">⬇ Export CSV</button>
                    </div>

                    <table id="announcements-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Category</th>
                                <th>Message</th>
                                <th>Priority</th>
                                <th>Audience</th>
                                <th>Posted By</th>
                                <th>Date</th>
                                <th>Expires</th>
                                <th style="text-align:center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty announcements}">
                                    <c:forEach var="ann" items="${announcements}">
                                        <tr data-priority="${ann[3]}" data-category="${not empty ann[6] ? ann[6] : 'GENERAL'}">
                                            <td style="font-weight:700;">${ann[1]}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty ann[6]}">
                                                        <c:choose>
                                                            <c:when test="${ann[6] eq 'MAINTENANCE'}"><span class="badge" style="background:#dbeafe; color:#1e40af;">🛠️ Maintenance</span></c:when>
                                                            <c:when test="${ann[6] eq 'UPDATE'}"><span class="badge" style="background:#f3e8ff; color:#6b21a8;">💡 Update</span></c:when>
                                                            <c:when test="${ann[6] eq 'EVENT'}"><span class="badge" style="background:#fce7f3; color:#9d174d;">🎉 Event</span></c:when>
                                                            <c:when test="${ann[6] eq 'ALERT'}"><span class="badge" style="background:#fee2e2; color:#991b1b;">⚠️ Alert</span></c:when>
                                                            <c:otherwise><span class="badge" style="background:#f3f4f6; color:#374151;">📢 General</span></c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    <c:otherwise><span class="badge" style="background:#f3f4f6; color:#374151;">📢 General</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="truncate" style="max-width:240px; font-style:italic; opacity:0.8;">${ann[2]}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${ann[3] eq 'HIGH'}"><span class="badge" style="background:#fee2e2; color:#b91c1c;">🔴 HIGH</span></c:when>
                                                    <c:when test="${ann[3] eq 'LOW'}"><span class="badge" style="background:#dcfce7; color:#15803d;">🟢 LOW</span></c:when>
                                                    <c:otherwise><span class="badge" style="background:#fef9c3; color:#92400e;">🟡 MEDIUM</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span style="opacity:0.5; font-size:0.82rem;">🌐 All Users</span>
                                            </td>
                                            <td>${ann[4]}</td>
                                            <td style="opacity:0.6; font-size:0.82rem; font-family:var(--font-mono);">${ann[5]}</td>
                                            <td style="font-size:0.82rem; font-family:var(--font-mono);">
                                                <c:choose>
                                                    <c:when test="${not empty ann[8]}">
                                                        <span style="color:var(--amber);">${ann[8]}</span>
                                                    </c:when>
                                                    <c:otherwise><span style="opacity:0.4;">Never</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="text-align:center; white-space:nowrap;">
                                                <button class="btn btn-ghost btn-sm" onclick="openEditModal('${ann[0]}','${ann[1]}','${ann[2]}','${ann[3]}','${not empty ann[6] ? ann[6] : "GENERAL"}','${not empty ann[8] ? ann[8] : ""}')" title="Edit announcement">✏️ Edit</button>
                                                <form action="adminAnnouncement" method="post" style="display:inline;" onsubmit="return confirm('Delete this announcement? This action cannot be undone.');">
                                                    <input type="hidden" name="action" value="delete"/>
                                                    <input type="hidden" name="announcementId" value="${ann[0]}"/>
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Delete announcement permanently">🗑️ Delete</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="9" class="empty-state"><div style="font-size:3rem; margin-bottom:12px;">📢</div>No announcements yet<br/><small style="opacity:0.5;">Click "+ New Announcement" to create your first platform communication</small></td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div><!-- /panel-announcements -->


            <!-- ══════════ PANEL: ANALYTICS (ENHANCED) ══════════ -->
            <div class="panel" id="panel-analytics">

                <!-- Row 1: 4 charts -->
                <div class="charts-grid" style="grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));">
                    <div class="chart-card">
                        <div class="chart-title">👤 User Distribution</div>
                        <canvas id="userPieChart"></canvas>
                    </div>
                    <div class="chart-card">
                        <div class="chart-title">🏠 Properties by Type</div>
                        <canvas id="propertyTypeChart"></canvas>
                    </div>
                    <div class="chart-card">
                        <div class="chart-title">📋 Properties by Status</div>
                        <canvas id="propertyStatusChart"></canvas>
                    </div>
                    <div class="chart-card">
                        <div class="chart-title">⭐ Review Ratings</div>
                        <canvas id="ratingsChart"></canvas>
                    </div>
                </div>

                <!-- Row 2: 2 new charts -->
                <div class="charts-grid" style="grid-template-columns: 1fr 1fr;">
                    <div class="chart-card">
                        <div class="chart-title">📅 Booking Status Breakdown</div>
                        <canvas id="bookingStatusChart"></canvas>
                    </div>
                    <div class="chart-card">
                        <div class="chart-title">💼 Top Sellers by Listings</div>
                        <canvas id="topSellersChart"></canvas>
                    </div>
                </div>

                <!-- Platform Summary -->
                <div class="card" style="border-left:4px solid var(--accent);">
                    <div class="card-title">📈 Platform Summary</div>
                    <div class="summary-grid">
                        <div class="summary-item">
                            <div class="summary-num" style="color:var(--accent);">LKR <fmt:formatNumber value="${totalProperties > 0 && (totalProperties - totalSoldProperties) > 0 ? totalPropertyValue / (totalProperties - totalSoldProperties) : 0}" pattern="#,##0"/></div>
                            <div class="summary-lbl">Avg. Active Property Price</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-num" style="color:var(--green);"><fmt:formatNumber value="${totalSellers > 0 ? totalBuyers / totalSellers : totalBuyers}" pattern="#,##0.0"/> : 1</div>
                            <div class="summary-lbl">Buyer-to-Seller Ratio</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-num" style="color:var(--amber);"><fmt:formatNumber value="${totalSellers > 0 ? totalProperties / totalSellers : 0}" pattern="#,##0.0"/></div>
                            <div class="summary-lbl">Listings per Seller</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-num" style="color:var(--purple);"><fmt:formatNumber value="${totalProperties > 0 ? totalReviews / totalProperties : 0}" pattern="#,##0.0"/></div>
                            <div class="summary-lbl">Reviews per Property</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-num" style="color:var(--green);">${completedBookings}</div>
                            <div class="summary-lbl">Completed Bookings</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-num" style="color:var(--amber);">${totalSoldProperties}</div>
                            <div class="summary-lbl">Properties Sold</div>
                        </div>
                        <div class="summary-item">
                            <div class="summary-num" style="color:var(--green); font-size:1.1rem;">LKR <fmt:formatNumber value="${not empty totalEarnings ? totalEarnings : 0}" pattern="#,##0.00"/></div>
                            <div class="summary-lbl">Total Earned</div>
                        </div>
                    </div>
                </div>

            </div><!-- /panel-analytics -->


            <!-- ══════════ PANEL: MY ACCOUNT ══════════ -->
            <div class="panel" id="panel-account">
                <div class="card" style="border-left:4px solid var(--amber); margin-bottom:20px;">
                    <div class="card-title">👑 Admin Information</div>
                    <div class="info-grid">
                        <div class="info-block">
                            <div class="info-label">Admin Name</div>
                            <div class="info-value">${sessionScope.loggedUser}</div>
                        </div>
                        <div class="info-block">
                            <div class="info-label">Email Address</div>
                            <div class="info-value">${sessionScope.loggedEmail}</div>
                        </div>
                        <div class="info-block">
                            <div class="info-label">Role</div>
                            <div class="info-value"><span class="badge badge-admin">👑 System Administrator</span></div>
                        </div>
                        <div class="info-block">
                            <div class="info-label">Session Status</div>
                            <div class="info-value" style="color:var(--green);">● Active</div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-title">🔐 Admin Capabilities</div>
                    <div class="cap-grid">
                        <div class="cap-card">
                            <div class="cap-icon">👥</div>
                            <div class="cap-title">User Management</div>
                            <div class="cap-desc">View, search, change roles, and delete any non-admin user</div>
                        </div>
                        <div class="cap-card">
                            <div class="cap-icon">🏘️</div>
                            <div class="cap-title">Property Control</div>
                            <div class="cap-desc">Remove any listing from the platform regardless of seller</div>
                        </div>
                        <div class="cap-card">
                            <div class="cap-icon">📅</div>
                            <div class="cap-title">Booking Overview</div>
                            <div class="cap-desc">Monitor all reservations and completed bookings platform-wide</div>
                        </div>
                        <div class="cap-card">
                            <div class="cap-icon">🏆</div>
                            <div class="cap-title">Sold Property Tracker</div>
                            <div class="cap-desc">Full history of all sold properties with timestamps</div>
                        </div>
                        <div class="cap-card">
                            <div class="cap-icon">⭐</div>
                            <div class="cap-title">Review Moderation</div>
                            <div class="cap-desc">Remove spam or inappropriate reviews platform-wide</div>
                        </div>
                        <div class="cap-card">
                            <div class="cap-icon">📢</div>
                            <div class="cap-title">Announcements</div>
                            <div class="cap-desc">Post, edit and delete platform-wide notices with priority levels</div>
                        </div>
                        <div class="cap-card">
                            <div class="cap-icon">📊</div>
                            <div class="cap-title">Platform Analytics</div>
                            <div class="cap-desc">Visual charts and live statistics across the entire platform</div>
                        </div>
                    </div>
                </div>
            </div><!-- /panel-account -->

        </div><!-- /content -->
    </div><!-- /main -->
</div><!-- /layout -->


<!-- ══════════ MODAL: CREATE ANNOUNCEMENT ══════════ -->
<div id="create-ann-modal" class="modal-overlay">
    <div class="modal-box" style="max-width:580px;">
        <div class="modal-title">📢 New Platform Announcement</div>
        <form action="adminAnnouncement" method="post">
            <input type="hidden" name="action" value="create"/>
            <div class="form-group">
                <label class="form-label">Title *</label>
                <input type="text" name="announcementTitle" required maxlength="120" class="form-input" placeholder="e.g. Scheduled Maintenance on 10 May"/>
            </div>
            <div class="form-group">
                <label class="form-label">Message *</label>
                <textarea name="announcementMessage" required rows="4" maxlength="400" class="form-input" style="resize:vertical;" placeholder="Write the announcement body here…"></textarea>
            </div>
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:16px;">
                <div class="form-group">
                    <label class="form-label">Category</label>
                    <select name="announcementCategory" class="form-input">
                        <option value="GENERAL" selected>📢 General</option>
                        <option value="MAINTENANCE">🛠️ Maintenance</option>
                        <option value="UPDATE">💡 Update</option>
                        <option value="EVENT">🎉 Event</option>
                        <option value="ALERT">⚠️ Alert</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Priority</label>
                    <select name="announcementPriority" class="form-input">
                        <option value="LOW">🟢 Low</option>
                        <option value="MEDIUM" selected>🟡 Medium</option>
                        <option value="HIGH">🔴 High</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Expiration Date (Optional)</label>
                <input type="date" name="announcementExpiry" class="form-input" title="Leave empty for no expiration"/>
            </div>
            <div style="display:flex; gap:10px; justify-content:flex-end; margin-top:8px;">
                <button type="button" class="btn-ghost btn" onclick="document.getElementById('create-ann-modal').style.display='none'">Cancel</button>
                <button type="submit" class="btn">Post Announcement</button>
            </div>
        </form>
    </div>
</div>

<!-- ══════════ MODAL: EDIT ANNOUNCEMENT ══════════ -->
<div id="edit-ann-modal" class="modal-overlay">
    <div class="modal-box" style="max-width:580px;">
        <div class="modal-title">✏️ Edit Announcement</div>
        <form action="adminAnnouncement" method="post">
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="announcementId" id="edit-ann-id"/>
            <div class="form-group">
                <label class="form-label">Title *</label>
                <input type="text" name="announcementTitle" id="edit-ann-title" required maxlength="120" class="form-input"/>
            </div>
            <div class="form-group">
                <label class="form-label">Message *</label>
                <textarea name="announcementMessage" id="edit-ann-message" required rows="4" maxlength="400" class="form-input" style="resize:vertical;"></textarea>
            </div>
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:16px;">
                <div class="form-group">
                    <label class="form-label">Category</label>
                    <select name="announcementCategory" id="edit-ann-category" class="form-input">
                        <option value="GENERAL">📢 General</option>
                        <option value="MAINTENANCE">🛠️ Maintenance</option>
                        <option value="UPDATE">💡 Update</option>
                        <option value="EVENT">🎉 Event</option>
                        <option value="ALERT">⚠️ Alert</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">Priority</label>
                    <select name="announcementPriority" id="edit-ann-priority" class="form-input">
                        <option value="LOW">🟢 Low</option>
                        <option value="MEDIUM">🟡 Medium</option>
                        <option value="HIGH">🔴 High</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Expiration Date (Optional)</label>
                <input type="date" name="announcementExpiry" id="edit-ann-expiry" class="form-input" title="Leave empty for no expiration"/>
            </div>
            <div style="display:flex; gap:10px; justify-content:flex-end; margin-top:8px;">
                <button type="button" class="btn-ghost btn" onclick="document.getElementById('edit-ann-modal').style.display='none'">Cancel</button>
                <button type="submit" class="btn">Save Changes</button>
            </div>
        </form>
    </div>
</div>


<!-- ══ HIDDEN DATA FOR CHARTS ══ -->
<div id="chart-data"
     data-buyers="${totalBuyers}"
     data-sellers="${totalSellers}"
     data-admins="${totalAdmins}"
     data-total-reviews="${totalReviews}"
     data-total-bookings="${totalBookings}"
     data-completed="${completedBookings}"
     data-reserved="${reservedBookings}"
     style="display:none;"></div>


<script>
/* ─── THEME ─── */
function toggleTheme() {
    const body = document.getElementById('body-theme');
    const isDark = body.getAttribute('data-theme') === 'dark';
    body.setAttribute('data-theme', isDark ? 'light' : 'dark');
    localStorage.setItem('nestiq-theme', isDark ? 'light' : 'dark');
    document.getElementById('theme-toggle').innerHTML = isDark ? '🌙' : '☀️';
    rebuildCharts();
}

/* ─── PANEL NAVIGATION ─── */
const panelTitles = {
    overview: 'Dashboard Overview',
    users: 'User Management',
    properties: 'Property Management',
    bookings: 'Booking Management',
    sold: 'Sold Properties',
    reviews: 'Review Management',
    announcements: 'Announcements',
    analytics: 'Analytics & Insights',
    account: 'My Account'
};

function showPanel(name, btn) {
    document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.nav-item').forEach(t => t.classList.remove('active'));
    document.getElementById('panel-' + name).classList.add('active');
    if (btn) btn.classList.add('active');
    document.getElementById('topbar-title').textContent = panelTitles[name] || name;
    if (name === 'analytics' || name === 'overview') { rebuildCharts(); }
    if (name === 'overview') { buildActivityFeed(); buildTopSellers(); }
}

/* ─── LIVE SEARCH ─── */
document.addEventListener('DOMContentLoaded', function () {
    // Restore theme
    const saved = localStorage.getItem('nestiq-theme') || 'light';
    document.getElementById('body-theme').setAttribute('data-theme', saved);
    document.getElementById('theme-toggle').innerHTML = saved === 'dark' ? '☀️' : '🌙';

    const searches = [
        { id: 'user-search',     table: 'user-management-table',    cols: [0,1] },
        { id: 'property-search', table: 'property-management-table', cols: [1,6] },
        { id: 'booking-search',  table: 'bookings-table',            cols: [1,2,3,4] },
        { id: 'sold-search',     table: 'sold-table',                cols: [1,3] },
        { id: 'review-search',   table: 'review-management-table',   cols: [1,2] },
        { id: 'announcement-search', table: 'announcements-table',  cols: [0,2] },
    ];
    searches.forEach(s => {
        const el = document.getElementById(s.id);
        if (el) el.addEventListener('input', function() { filterTable(s.table, this.value, s.cols); });
    });

    // Initialize announcement counts
    countAnnouncements();

    buildActivityFeed();
    buildTopSellers();
    setTimeout(buildCharts, 100);
});

function filterTable(tableId, term, cols) {
    const t = term.toLowerCase().trim();
    document.querySelectorAll('#' + tableId + ' tbody tr').forEach(row => {
        if (!row.cells || row.cells.length < 2) return;
        const match = !t || cols.some(c => row.cells[c] && row.cells[c].textContent.toLowerCase().includes(t));
        row.style.display = match ? '' : 'none';
    });
}

/* ─── BOOKING STATUS FILTER ─── */
function filterBookingsByStatus(status) {
    document.querySelectorAll('#bookings-table tbody tr').forEach(row => {
        if (!row.cells || row.cells.length < 8) return;
        const s = row.cells[7].textContent.trim().toUpperCase();
        row.style.display = (!status || s.includes(status)) ? '' : 'none';
    });
}

/* ─── ANNOUNCEMENT FILTERS ─── */
function filterAnnouncements() {
    const searchTerm = document.getElementById('announcement-search')?.value.toLowerCase().trim() || '';
    const priorityFilter = document.getElementById('announcement-priority-filter')?.value || '';
    const categoryFilter = document.getElementById('announcement-category-filter')?.value || '';

    document.querySelectorAll('#announcements-table tbody tr').forEach(row => {
        if (!row.cells || row.cells.length < 9) return;

        // Check search term
        const titleMatch = !searchTerm || row.cells[0].textContent.toLowerCase().includes(searchTerm);
        const messageMatch = !searchTerm || row.cells[2].textContent.toLowerCase().includes(searchTerm);
        const searchMatch = titleMatch || messageMatch;

        // Check priority filter
        const priority = row.getAttribute('data-priority') || '';
        const priorityMatch = !priorityFilter || priority === priorityFilter;

        // Check category filter
        const category = row.getAttribute('data-category') || 'GENERAL';
        const categoryMatch = !categoryFilter || category === categoryFilter;

        // Show/hide based on all filters
        row.style.display = (searchMatch && priorityMatch && categoryMatch) ? '' : 'none';
    });
}

/* ─── COUNT ANNOUNCEMENTS BY PRIORITY ─── */
function countAnnouncements() {
    let high = 0, medium = 0, low = 0;
    document.querySelectorAll('#announcements-table tbody tr').forEach(row => {
        const priority = row.getAttribute('data-priority');
        if (priority === 'HIGH') high++;
        else if (priority === 'MEDIUM') medium++;
        else if (priority === 'LOW') low++;
    });

    const highEl = document.getElementById('count-high');
    const mediumEl = document.getElementById('count-medium');
    const lowEl = document.getElementById('count-low');

    if (highEl) highEl.textContent = high;
    if (mediumEl) mediumEl.textContent = medium;
    if (lowEl) lowEl.textContent = low;
}

/* ─── EXPORT CSV ─── */
function exportTableToCSV(tableId, filename) {
    const rows = document.querySelectorAll('#' + tableId + ' tr');
    const csv = [];
    rows.forEach(row => {
        const cols = [];
        row.querySelectorAll('th, td').forEach(cell => {
            let text = cell.textContent.trim().replace(/\s+/g, ' ');
            cols.push('"' + text.replace(/"/g, '""') + '"');
        });
        csv.push(cols.slice(0, -1).join(','));
    });
    const blob = new Blob([csv.join('\n')], { type: 'text/csv' });
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = filename;
    a.click();
}

/* ─── ACTIVITY FEED ─── */
function buildActivityFeed() {
    const feed = document.getElementById('activity-feed');
    if (!feed) return;
    const activities = [];

    // From bookings table
    document.querySelectorAll('#bookings-table tbody tr').forEach(row => {
        if (!row.cells || row.cells.length < 8) return;
        const status = row.cells[7].textContent.trim();
        const property = row.cells[1].querySelector('div') ? row.cells[1].querySelector('div').textContent.trim() : row.cells[1].textContent.trim();
        const buyer = row.cells[4].textContent.trim();
        const date = row.cells[5].textContent.trim();
        activities.push({ type: 'booking', icon: '📅', text: buyer + ' booked "' + property + '"', time: date, cls: 'booking' });
    });

    // From sold_properties.txt via server (real timestamps)
    (window.soldActivities || []).forEach(function(sp) {
        activities.push({ type: 'sold', icon: '🏆', text: '"' + sp.title + '" marked as sold', time: sp.time, cls: 'sold' });
    });

    // Sort by time descending (simple string sort works for ISO dates)
    activities.sort((a, b) => b.time.localeCompare(a.time));

    const recent = activities.slice(0, 8);
    if (recent.length === 0) {
        feed.innerHTML = '<div style="opacity:0.4; text-align:center; padding:24px;">No recent activity</div>';
        return;
    }
    feed.innerHTML = recent.map(a =>
        '<div class="activity-item">' +
        '<div class="activity-dot ' + a.cls + '">' + a.icon + '</div>' +
        '<div><div class="activity-text">' + a.text + '</div><div class="activity-time">' + a.time + '</div></div>' +
        '</div>'
    ).join('');
}

/* ─── TOP SELLERS ─── */
function buildTopSellers() {
    const board = document.getElementById('top-sellers-board');
    if (!board) return;
    const counts = {};
    document.querySelectorAll('#property-management-table tbody tr').forEach(row => {
        if (!row.cells || row.cells.length < 8) return;
        const seller = row.cells[6].textContent.trim();
        if (seller) counts[seller] = (counts[seller] || 0) + 1;
    });
    const sorted = Object.entries(counts).sort((a,b) => b[1]-a[1]); // show ALL sellers, no cap
    if (sorted.length === 0) { board.innerHTML = '<div style="opacity:0.4; text-align:center; padding:24px;">No seller data available</div>'; return; }
    const max = sorted[0][1];
    board.innerHTML = sorted.map(([name,cnt], i) =>
        '<div class="leaderboard-row">' +
        '<div class="leaderboard-rank">' + (i+1) + '</div>' +
        '<div class="leaderboard-name">' + name + '</div>' +
        '<div class="leaderboard-bar-wrap"><div class="leaderboard-bar" style="width:' + Math.round(cnt/max*100) + '%;"></div></div>' +
        '<div class="leaderboard-count">' + cnt + '</div>' +
        '</div>'
    ).join('');
}

/* ─── CHARTS ─── */
let chartInstances = {};

function rebuildCharts() {
    Object.values(chartInstances).forEach(c => c.destroy());
    chartInstances = {};
    buildCharts();
}

function buildCharts() {
    const isDark = document.getElementById('body-theme').getAttribute('data-theme') === 'dark';
    const textColor = isDark ? '#e8ecf4' : '#0a0e1a';
    const gridColor = isDark ? '#252d42' : '#e2e6f0';
    const d = document.getElementById('chart-data');

    const buyers    = parseInt(d.dataset.buyers)    || 0;
    const sellers   = parseInt(d.dataset.sellers)   || 0;
    const admins    = parseInt(d.dataset.admins)    || 0;
    const completed = parseInt(d.dataset.completed) || 0;
    const reserved  = parseInt(d.dataset.reserved)  || 0;
    const cancelled = (parseInt(d.dataset.totalBookings) || 0) - completed - reserved;

    // Compute from tables
    const typeCounts   = {};
    const statusCounts = { 'For Sale': 0, 'For Rent': 0 };
    document.querySelectorAll('#property-management-table tbody tr').forEach(row => {
        if (row.cells.length < 7) return;
        const type   = row.cells[4].textContent.trim();
        const status = row.cells[5].textContent.trim();
        typeCounts[type] = (typeCounts[type] || 0) + 1;
        if (status.includes('Sale')) statusCounts['For Sale']++;
        else statusCounts['For Rent']++;
    });
    const sellerCounts = {};
    document.querySelectorAll('#property-management-table tbody tr').forEach(row => {
        if (row.cells.length < 8) return;
        const s = row.cells[6].textContent.trim();
        if (s) sellerCounts[s] = (sellerCounts[s] || 0) + 1;
    });
    const ratingCounts = {'1★':0,'2★':0,'3★':0,'4★':0,'5★':0};
    document.querySelectorAll('#review-management-table tbody tr').forEach(row => {
        if (row.cells.length < 4) return;
        const m = row.cells[3].textContent.trim().match(/(\d)\/5/);
        if (m) ratingCounts[m[1]+'★']++;
    });

    const barPalette = ['#2563eb','#059669','#d97706','#7c3aed','#dc2626','#0891b2','#be185d','#65a30d','#ea580c','#6366f1','#0f766e','#b45309'];
    const allSellers = Object.entries(sellerCounts).sort((a,b)=>b[1]-a[1]); // ALL sellers, no cap
    const opts = { responsive:true, maintainAspectRatio:true };
    const legendOpts = { labels: { color: textColor, font: { family: 'Outfit', size: 12 }, padding: 14 } };
    const scaleOpts = (axis) => ({ ticks: { color:textColor, font:{family:'Outfit'} }, grid: { color:gridColor } });

    const make = (id, config) => {
        if (!chartInstances[id]) {
            const el = document.getElementById(id);
            if (el) chartInstances[id] = new Chart(el, config);
        }
    };

    // 1 User pie
    make('userPieChart', { type:'doughnut', data: { labels:['Buyers','Sellers','Admins'], datasets:[{data:[buyers,sellers,admins], backgroundColor:['#2563eb','#059669','#d97706'], borderWidth:0}] }, options:{...opts, cutout:'60%', plugins:{legend:legendOpts}} });
    make('overviewUserPie', { type:'doughnut', data:{ labels:['Buyers','Sellers','Admins'], datasets:[{data:[buyers,sellers,admins], backgroundColor:['#2563eb','#059669','#d97706'], borderWidth:0}] }, options:{...opts, cutout:'60%', plugins:{legend:legendOpts}} });

    // 2 Property type bar
    make('propertyTypeChart', { type:'bar', data:{ labels:Object.keys(typeCounts), datasets:[{label:'Properties', data:Object.values(typeCounts), backgroundColor:'#2563eb', borderRadius:6}] }, options:{...opts, plugins:{legend:{display:false}}, scales:{x:scaleOpts(),y:{...scaleOpts(), ticks:{...scaleOpts().ticks, stepSize:1}}}} });

    // 3 Property status pie
    make('propertyStatusChart', { type:'doughnut', data:{ labels:Object.keys(statusCounts), datasets:[{data:Object.values(statusCounts), backgroundColor:['#059669','#2563eb'], borderWidth:0}] }, options:{...opts, cutout:'60%', plugins:{legend:legendOpts}} });

    // 4 Ratings bar
    make('ratingsChart', { type:'bar', data:{ labels:Object.keys(ratingCounts), datasets:[{label:'Reviews', data:Object.values(ratingCounts), backgroundColor:'#f59e0b', borderRadius:6}] }, options:{...opts, plugins:{legend:{display:false}}, scales:{x:scaleOpts(),y:{...scaleOpts(), ticks:{...scaleOpts().ticks, stepSize:1}}}} });

    // 5 Booking status doughnut (new)
    make('bookingStatusChart', { type:'doughnut', data:{ labels:['Completed','Reserved','Cancelled'], datasets:[{data:[completed, reserved, Math.max(0,cancelled)], backgroundColor:['#059669','#2563eb','#dc2626'], borderWidth:0}] }, options:{...opts, cutout:'60%', plugins:{legend:legendOpts}} });
    make('overviewBookingStatus', { type:'doughnut', data:{ labels:['Completed','Reserved','Cancelled'], datasets:[{data:[completed, reserved, Math.max(0,cancelled)], backgroundColor:['#059669','#2563eb','#dc2626'], borderWidth:0}] }, options:{...opts, cutout:'60%', plugins:{legend:legendOpts}} });

    // 6 Top sellers bar — shows every seller, no arbitrary cap
    make('topSellersChart', { type:'bar', data:{ labels:allSellers.map(x=>x[0]), datasets:[{label:'Listings', data:allSellers.map(x=>x[1]), backgroundColor:allSellers.map((_,i)=>barPalette[i % barPalette.length]), borderRadius:6}] }, options:{...opts, indexAxis:'y', plugins:{legend:{display:false}}, scales:{x:{...scaleOpts(), ticks:{...scaleOpts().ticks, stepSize:1}}, y:scaleOpts()}} });
}

/* ─── MODAL HELPERS ─── */
function openEditModal(id, title, message, priority, category, expiry) {
    document.getElementById('edit-ann-id').value = id;
    document.getElementById('edit-ann-title').value = title;
    document.getElementById('edit-ann-message').value = message;
    document.getElementById('edit-ann-priority').value = priority || 'MEDIUM';
    document.getElementById('edit-ann-category').value = category || 'GENERAL';
    document.getElementById('edit-ann-expiry').value = expiry || '';
    document.getElementById('edit-ann-modal').style.display = 'flex';
}
['create-ann-modal','edit-ann-modal'].forEach(function(id) {
    const el = document.getElementById(id);
    if (el) el.addEventListener('click', function(e) { if (e.target === this) this.style.display = 'none'; });
});
</script>

<%-- ── Inject real sold-activity timestamps from sold_properties.txt ── --%>
<script>
window.soldActivities = [
    <c:forEach var="sp" items="${allSoldProperties}" varStatus="vs">
    {
        title: "<c:out value='${sp[2]}'/>",
        time:  "<c:out value='${sp[0]}'/>"
    }<c:if test="${!vs.last}">,</c:if>
    </c:forEach>
];
// Newest first so Recent Activity shows the most recent sold events
window.soldActivities.reverse();
</script>

<!-- Page Transition Animation System -->
<script src="page-transitions.js"></script>

</body>
</html>