<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // Role separation: sellers must not see buyer-facing main site pages.
    String _role = (String) session.getAttribute("loggedRole");
    if (_role != null && "SELLER".equalsIgnoreCase(_role)) {
        response.sendRedirect("sellerHome");
        return;
    }

    // FIX: If propertyList is null (user hit index.jsp directly instead of /properties servlet),
    // redirect to /properties which loads all data then forwards back here.
    // This ensures Featured Properties and Browse page always have data, even when not logged in.
    // IMPORTANT: Preserve login error message across redirects
    if (request.getAttribute("propertyList") == null) {
        // If there's a login error, preserve it in a request param so PropertyServlet can keep it
        String loginError = (String) session.getAttribute("loginError");
        String qs = request.getQueryString();
        String redirect = request.getContextPath() + "/properties" + (qs != null ? "?" + qs : "");
        if (loginError != null) {
            redirect += (qs == null ? "?" : "&") + "loginError=true";
        }
        response.sendRedirect(redirect);
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>NESTIQ Real Estate</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <style>
        /* ════════════════════════════════════════════
           NESTIQ — Professional Real Estate UI
           Theme: Clean Modern Light
           Font: Playfair Display + Outfit
        ════════════════════════════════════════════ */
        :root {
            /* ── PREMIUM LIGHT THEME COLORS ── */
            --ink:      #0f1117;
            --ink2:     #2a2d35;
            --ink3:     #5a5f70;
            --ink4:     #9198a8;
            --line:     #e8eaee;
            --line2:    #f2f4f7;
            --bg:       #ffffff;
            --bg2:      #f7f8fa;
            --bg3:      #eef0f4;

            /* Premium Accent Colors - Royal Blue Palette */
            --accent:   #2563eb;
            --accent2:  #1d4ed8;
            --accent-l: #eff6ff;
            --accent-glow: rgba(37, 99, 235, 0.15);

            /* Success Green - Emerald */
            --green:    #059669;
            --green-l:  #ecfdf5;
            --green-glow: rgba(5, 150, 105, 0.15);

            /* Warning Amber - Golden */
            --amber:    #d97706;
            --amber-l:  #fffbeb;
            --amber-glow: rgba(217, 119, 6, 0.15);

            /* Error Red - Rose */
            --red:      #dc2626;
            --red-l:    #fef2f2;
            --red-glow: rgba(220, 38, 38, 0.15);

            /* Shadows & Effects */
            --r: 10px;
            --r2: 16px;
            --r3: 24px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,.06), 0 1px 2px rgba(0,0,0,.04);
            --shadow:    0 4px 16px rgba(0,0,0,.08), 0 1px 4px rgba(0,0,0,.04);
            --shadow-lg: 0 16px 48px rgba(0,0,0,.12), 0 4px 12px rgba(0,0,0,.06);
            --shadow-xl: 0 32px 80px rgba(0,0,0,.16);
            --t: .22s cubic-bezier(.4,0,.2,1);
            --font-serif: 'Playfair Display', Georgia, serif;
            --font-sans:  'Outfit', system-ui, sans-serif;
        }

        /* ── PREMIUM DARK MODE OVERRIDES ── */
        [data-theme="dark"] {
            /* Deep Space Background */
            --bg:        #1a1a2e;
            --bg2:       #2a2a4a;
            --bg3:       #3a3a6a;

            /* Light Text on Dark */
            --ink:       #f0f0ff;
            --ink2:      #d0d0f0;
            --ink3:      #a0a0d0;
            --ink4:      #7070a0;

            /* Subtle Borders */
            --line:      #3a3a6a;
            --line2:     #4a4a8a;

            /* Premium Accent Colors - Vibrant Purple */
            --accent:    #9d8eee;
            --accent2:   #8b7cdc;
            --accent-l:  rgba(157, 142, 238, 0.15);
            --accent-glow: rgba(157, 142, 238, 0.25);

            /* Success Green - Bright Emerald */
            --green:     #10b981;
            --green-l:   rgba(16, 185, 129, 0.15);
            --green-glow: rgba(16, 185, 129, 0.25);

            /* Warning Amber - Vibrant Gold */
            --amber:     #f59e0b;
            --amber-l:   rgba(245, 158, 11, 0.15);
            --amber-glow: rgba(245, 158, 11, 0.25);

            /* Error Red - Bright Rose */
            --red:       #ef4444;
            --red-l:     rgba(239, 68, 68, 0.15);
            --red-glow:  rgba(239, 68, 68, 0.25);

            /* Enhanced Shadows for Depth */
            --shadow-sm: 0 1px 4px rgba(0,0,0,.5), 0 1px 2px rgba(0,0,0,.3);
            --shadow:    0 4px 20px rgba(0,0,0,.6), 0 1px 6px rgba(0,0,0,.35);
            --shadow-lg: 0 12px 40px rgba(0,0,0,.7), 0 4px 14px rgba(0,0,0,.4);
            --shadow-xl: 0 28px 70px rgba(0,0,0,.8), 0 8px 20px rgba(0,0,0,.45);
        }

        [data-theme="dark"] .detail-back-btn {
            color: #0f1117;
        }

        /* Fix stubborn hardcoded white backgrounds */
        [data-theme="dark"] .navbar {
            background: rgba(26, 26, 46, 0.95);
            border-bottom: 1px solid var(--line);
            box-shadow: 0 1px 0 rgba(255,255,255,0.05);
        }
        [data-theme="dark"] .navbar.scrolled {
            background: rgba(26, 26, 46, 0.98);
            box-shadow: var(--shadow-lg), 0 0 0 1px var(--accent-glow);
        }

        [data-theme="dark"] .hero-card-float {
            background: linear-gradient(135deg, rgba(17,24,39,0.98) 0%, rgba(31,41,55,0.98) 100%);
            border: 1.5px solid rgba(59,130,246,0.2);
            box-shadow: var(--shadow-xl), 0 0 0 1px rgba(59, 130, 246, 0.25);
        }

        [data-theme="dark"] .auth-social-btn,
        [data-theme="dark"] .testi-card:hover {
            background: linear-gradient(135deg, rgba(42, 42, 74, 0.98) 0%, rgba(58, 58, 106, 0.98) 100%);
            border: 1.5px solid rgba(157, 142, 238, 0.2);
            box-shadow: var(--shadow-xl), 0 0 0 1px var(--accent-glow);
        }

        [data-theme="dark"] input:focus,
        [data-theme="dark"] select:focus,
        [data-theme="dark"] textarea:focus,
        [data-theme="dark"] .contact-form-input:focus {
            background: var(--bg);
        }

        *, *::before, *::after { box-sizing: border-box; margin:0; padding:0; }
        html { scroll-behavior: smooth; font-size: 16px; }
        body {
            font-family: var(--font-sans);
            background: var(--bg);
            color: var(--ink);
            line-height: 1.6;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }
        img { display: block; max-width: 100%; }
        a { text-decoration: none; color: inherit; }
        button { font-family: var(--font-sans); cursor: pointer; border: none; outline: none; }
        input, select, textarea { font-family: var(--font-sans); outline: none; }
        ::-webkit-scrollbar { width: 5px; }
        ::-webkit-scrollbar-track { background: var(--bg2); }
        ::-webkit-scrollbar-thumb { background: var(--line); border-radius: 99px; }

        /* ── PAGE ROUTER ── */
        .page { display: none; }
        .page.active { display: block; }

        /* ── NAVBAR ── */
        .navbar {
            position: fixed; top: 0; left: 0; right: 0; z-index: 1000;
            height: 68px;
            background: rgba(255,255,255,.95);
            backdrop-filter: blur(20px) saturate(180%);
            border-bottom: 1px solid var(--line);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 40px;
            transition: all var(--t);
            box-shadow: 0 1px 0 rgba(0,0,0,0.05);
        }
        .navbar.scrolled {
            box-shadow: var(--shadow-lg), 0 0 0 1px var(--accent-glow);
            background: rgba(255,255,255,.98);
        }
        .nav-logo {
            font-family: var(--font-serif);
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: -0.5px;
            color: var(--ink);
            display: flex; align-items: center; gap: 8px;
            cursor: pointer;
            position: relative;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            user-select: none;
        }
        .nav-logo::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: radial-gradient(circle, rgba(157, 142, 238, 0.15) 0%, transparent 70%);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s ease, height 0.6s ease;
            z-index: -1;
        }
        .nav-logo:hover {
            transform: scale(1.05);
            text-shadow: 0 0 20px rgba(157, 142, 238, 0.4);
        }
        .nav-logo:hover::before {
            width: 120px;
            height: 120px;
        }
        .nav-logo:active {
            transform: scale(0.98);
        }
        [data-theme="dark"] .nav-logo:hover {
            text-shadow: 0 0 25px rgba(157, 142, 238, 0.6), 0 0 40px rgba(157, 142, 238, 0.3);
        }
        
        /* Animated gradient text for NESTIQ */
        .nav-logo-text {
            background: linear-gradient(135deg, var(--ink) 0%, var(--accent) 50%, var(--ink) 100%);
            background-size: 200% auto;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: shimmer 3s ease-in-out infinite;
            transition: all 0.4s ease;
        }
        @keyframes shimmer {
            0%, 100% { background-position: 0% center; }
            50% { background-position: 100% center; }
        }
        .nav-logo:hover .nav-logo-text {
            animation-duration: 1.5s;
            filter: brightness(1.1);
        }
        
        /* Premium dot with pulse animation */
        .nav-logo .dot { 
            width: 8px; 
            height: 8px; 
            background: var(--accent); 
            border-radius: 50%; 
            display: inline-block;
            position: relative;
            box-shadow: 0 0 0 0 rgba(157, 142, 238, 0.7);
            animation: pulse-dot 2s ease-in-out infinite;
            transition: all 0.3s ease;
        }
        @keyframes pulse-dot {
            0%, 100% {
                box-shadow: 0 0 0 0 rgba(157, 142, 238, 0.7);
                transform: scale(1);
            }
            50% {
                box-shadow: 0 0 0 8px rgba(157, 142, 238, 0);
                transform: scale(1.2);
            }
        }
        .nav-logo:hover .dot {
            animation-duration: 0.8s;
            box-shadow: 0 0 15px rgba(157, 142, 238, 0.8), 0 0 30px rgba(157, 142, 238, 0.4);
            transform: scale(1.3);
            background: linear-gradient(135deg, var(--accent) 0%, #fff 100%);
        }
        [data-theme="dark"] .nav-logo:hover .dot {
            box-shadow: 0 0 20px rgba(157, 142, 238, 1), 0 0 40px rgba(157, 142, 238, 0.6);
        }
        .nav-links {
            display: flex; align-items: center; gap: 8px;
            list-style: none;
        }
        .nav-links a {
            font-size: .875rem; font-weight: 500;
            color: var(--ink3);
            padding: 6px 14px; border-radius: var(--r);
            transition: all var(--t);
        }
        .nav-links a:hover, .nav-links a.active { color: var(--ink); background: var(--bg2); }
        .nav-actions { display: flex; align-items: center; gap: 10px; }
        .btn-ghost {
            font-size: .875rem; font-weight: 500;
            color: var(--ink2); background: none;
            padding: 8px 18px; border-radius: var(--r);
            border: 1.5px solid var(--line);
            transition: all var(--t);
            backdrop-filter: blur(8px);
        }
        .btn-ghost:hover {
            border-color: var(--accent);
            background: var(--accent-l);
            color: var(--accent);
            box-shadow: 0 2px 8px var(--accent-glow);
        }
        .btn-primary {
            font-size: .875rem; font-weight: 600;
            color: #fff;
            background: linear-gradient(135deg, var(--accent) 0%, var(--accent2) 100%);
            padding: 8px 20px; border-radius: var(--r);
            border: 1.5px solid transparent;
            transition: all var(--t);
            display: flex; align-items: center; gap: 6px;
            box-shadow: 0 4px 14px var(--accent-glow);
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, var(--accent2) 0%, var(--accent) 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px var(--accent-glow), 0 0 0 1px rgba(255,255,255,0.1) inset;
        }
        .btn-primary:active { transform: translateY(0); }

        /* ── PREMIUM BADGES FOR NAV USER BUTTON ── */
        .buyer-badge-premium {
            background: linear-gradient(135deg, rgba(157, 142, 238, 0.15) 0%, rgba(130, 120, 238, 0.12) 100%);
            color: var(--accent);
            padding: 4px 10px;
            border-radius: 14px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            border: 1.5px solid rgba(157, 142, 238, 0.25);
            transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(157, 142, 238, 0.1);
            display: inline-block;
        }
        .buyer-badge-premium::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: radial-gradient(circle, rgba(157, 142, 238, 0.3) 0%, transparent 70%);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.5s ease, height 0.5s ease;
            z-index: 0;
        }
        .buyer-badge-premium:hover {
            background: linear-gradient(135deg, rgba(157, 142, 238, 0.25) 0%, rgba(130, 120, 238, 0.22) 100%);
            color: #fff;
            border-color: rgba(157, 142, 238, 0.6);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 4px 16px rgba(157, 142, 238, 0.3), 0 0 0 1px rgba(255,255,255,0.1) inset;
            text-shadow: 0 0 8px rgba(157, 142, 238, 0.5);
        }
        .buyer-badge-premium:hover::before {
            width: 100px;
            height: 100px;
        }
        .buyer-badge-premium:active {
            transform: translateY(0) scale(0.98);
        }
        [data-theme="dark"] .buyer-badge-premium {
            background: linear-gradient(135deg, rgba(157, 142, 238, 0.18) 0%, rgba(130, 120, 238, 0.15) 100%);
            border-color: rgba(157, 142, 238, 0.3);
            box-shadow: 0 2px 12px rgba(157, 142, 238, 0.15);
        }
        [data-theme="dark"] .buyer-badge-premium:hover {
            background: linear-gradient(135deg, rgba(157, 142, 238, 0.35) 0%, rgba(130, 120, 238, 0.32) 100%);
            border-color: rgba(157, 142, 238, 0.7);
            box-shadow: 0 6px 20px rgba(157, 142, 238, 0.4), 0 0 25px rgba(157, 142, 238, 0.25);
            text-shadow: 0 0 12px rgba(157, 142, 238, 0.7);
        }

        .seller-badge-premium {
            background: linear-gradient(135deg, rgba(13, 158, 110, 0.15) 0%, rgba(10, 138, 95, 0.12) 100%);
            color: #0d9e6e;
            padding: 4px 10px;
            border-radius: 14px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            border: 1.5px solid rgba(13, 158, 110, 0.25);
            transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(13, 158, 110, 0.1);
            display: inline-block;
        }
        .seller-badge-premium::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: radial-gradient(circle, rgba(13, 158, 110, 0.3) 0%, transparent 70%);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.5s ease, height 0.5s ease;
            z-index: 0;
        }
        .seller-badge-premium:hover {
            background: linear-gradient(135deg, rgba(13, 158, 110, 0.25) 0%, rgba(10, 138, 95, 0.22) 100%);
            color: #fff;
            border-color: rgba(13, 158, 110, 0.6);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 4px 16px rgba(13, 158, 110, 0.3), 0 0 0 1px rgba(255,255,255,0.1) inset;
            text-shadow: 0 0 8px rgba(13, 158, 110, 0.5);
        }
        .seller-badge-premium:hover::before {
            width: 100px;
            height: 100px;
        }
        .seller-badge-premium:active {
            transform: translateY(0) scale(0.98);
        }
        [data-theme="dark"] .seller-badge-premium {
            background: linear-gradient(135deg, rgba(13, 158, 110, 0.18) 0%, rgba(10, 138, 95, 0.15) 100%);
            border-color: rgba(13, 158, 110, 0.3);
            box-shadow: 0 2px 12px rgba(13, 158, 110, 0.15);
        }
        [data-theme="dark"] .seller-badge-premium:hover {
            background: linear-gradient(135deg, rgba(13, 158, 110, 0.35) 0%, rgba(10, 138, 95, 0.32) 100%);
            border-color: rgba(13, 158, 110, 0.7);
            box-shadow: 0 6px 20px rgba(13, 158, 110, 0.4), 0 0 25px rgba(13, 158, 110, 0.25);
            text-shadow: 0 0 12px rgba(13, 158, 110, 0.7);
        }

        .nav-user-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 5px 15px 5px 8px;
            border: 1.5px solid var(--line);
            border-radius: 30px;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        .nav-user-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: left 0.5s ease;
        }
        .nav-user-btn:hover {
            border-color: var(--accent);
            box-shadow: 0 4px 16px rgba(157, 142, 238, 0.15);
            transform: translateY(-1px);
        }
        .nav-user-btn:hover::before {
            left: 100%;
        }
        [data-theme="dark"] .nav-user-btn:hover {
            box-shadow: 0 4px 16px rgba(157, 142, 238, 0.25);
        }

        /* ── HERO ── */
        .hero {
            min-height: 100vh;
            padding-top: 68px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0;
            overflow: hidden;
        }
        .hero-left {
            display: flex; flex-direction: column; justify-content: center;
            padding: 80px 64px 80px 40px;
            animation: fadeInLeft .8s ease both;
            background: linear-gradient(135deg, var(--bg) 0%, var(--bg2) 100%);
        }
        @keyframes fadeInLeft { from { opacity:0; transform: translateX(-30px); } to { opacity:1; transform: none; } }
        .hero-eyebrow {
            display: inline-flex; align-items: center; gap: 8px;
            font-size: .75rem; font-weight: 600; letter-spacing: 2px;
            text-transform: uppercase; color: var(--accent);
            background: linear-gradient(135deg, var(--accent-l) 0%, rgba(157, 142, 238, 0.08) 100%);
            padding: 6px 14px; border-radius: 99px;
            margin-bottom: 28px; width: fit-content;
            border: 1px solid var(--accent-glow);
            box-shadow: 0 2px 8px var(--accent-glow);
            transition: all var(--t);
        }
        .hero-eyebrow:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 16px var(--accent-glow);
        }
        .hero-title {
            font-family: var(--font-serif);
            font-size: clamp(2.8rem, 5vw, 4.2rem);
            font-weight: 700; line-height: 1.1;
            color: var(--ink);
            margin-bottom: 24px;
            letter-spacing: -1px;
        }
        .hero-title em { color: var(--accent); font-style: italic; }
        .hero-sub {
            font-size: 1.05rem; color: var(--ink3); font-weight: 300;
            line-height: 1.7; max-width: 460px; margin-bottom: 40px;
        }

        /* 🔥 THE NEW SEARCH BAR CSS ENGINE 🔥 */
        .hero-search-form {
            display: flex;
            gap: 15px;
            align-items: flex-end;
            background: linear-gradient(135deg, var(--bg2) 0%, var(--bg3) 100%);
            padding: 24px;
            border-radius: var(--r);
            box-shadow: var(--shadow-lg), 0 0 0 1px var(--accent-glow);
            border: 1.5px solid var(--line);
            margin-top: 30px;
            position: relative;
            z-index: 10;
            backdrop-filter: blur(10px);
        }

        .hero-search {
            background: var(--bg);
            border: 1.5px solid var(--line);
            border-radius: var(--r2);
            padding: 8px;
            display: flex; align-items: center; gap: 0;
            box-shadow: var(--shadow-lg);
            max-width: 560px;
            margin-bottom: 40px;
        }
        .hero-search-field {
            flex: 1; padding: 10px 16px;
            border-right: 1.5px solid var(--line);
        }
        .hero-search-field:last-of-type { border-right: none; }
        .hero-search-field label {
            display: block; font-size: .65rem; font-weight: 600;
            letter-spacing: 1px; text-transform: uppercase; color: var(--ink4);
            margin-bottom: 2px;
        }
        .hero-search-field input, .hero-search-field select {
            width: 100%; border: none; background: none;
            font-size: .9rem; color: var(--ink); font-weight: 500;
        }
        .hero-search-field select { -webkit-appearance: none; }
        .hero-search-btn {
            background: var(--accent); color: white;
            border: none; border-radius: var(--r);
            padding: 14px 22px; font-size: .875rem; font-weight: 600;
            display: flex; align-items: center; gap: 8px;
            transition: all var(--t); flex-shrink: 0;
        }
        .hero-search-btn:hover { background: var(--accent2); }
        .hero-search-btn svg { width: 16px; height: 16px; }
        .hero-stats {
            display: flex;
            gap: 32px;
            margin-top: 50px;
        }
        .hstat { }
        .hstat-num {
            font-family: var(--font-serif);
            font-size: 1.8rem; font-weight: 700;
            color: var(--ink); line-height: 1;
        }
        .hstat-label {
            font-size: .78rem; color: var(--ink4); font-weight: 400; margin-top: 2px;
        }
        .hstat-divider { width: 1px; background: var(--line); }

        .hero-right {
            position: relative; overflow: hidden;
            animation: fadeInRight .8s .15s ease both;
        }
        @keyframes fadeInRight { from { opacity:0; transform: translateX(30px); } to { opacity:1; transform: none; } }
        .hero-main-img {
            width: 100%; height: 100%;
            object-fit: cover;
        }
        .hero-img-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to right, rgba(255,255,255,.15) 0%, transparent 40%);
        }
        .hero-card-float {
            position: absolute;
            background: linear-gradient(135deg, rgba(255,255,255,0.98) 0%, rgba(247,248,250,0.98) 100%);
            border-radius: var(--r2);
            padding: 16px 20px;
            box-shadow: var(--shadow-xl), 0 0 0 1px var(--accent-glow);
            animation: floatCard 4s ease-in-out infinite;
            backdrop-filter: blur(20px) saturate(180%);
            border: 1.5px solid rgba(255,255,255,0.3);
        }
        @keyframes floatCard { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-8px); } }
        .hcf-1 { bottom: 120px; left: 24px; min-width: 220px; }
        .hcf-2 { top: 100px; right: 24px; min-width: 180px; animation-delay: 1.5s; }
        .hcf-3 {
            bottom: 32px;
            right: 24px;
            min-width: 280px;
            animation-delay: 3s;
            display: none;
            background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
            border: 1px solid rgba(224,40,40,.25);
            box-shadow: 0 8px 32px rgba(224,40,40,.15), 0 4px 16px rgba(0,0,0,.08);
            padding: 18px 20px;
            border-radius: 16px;
        }
        [data-theme="dark"] .hcf-3 {
            background: linear-gradient(135deg, #232736 0%, #1a1d27 100%);
            border: 1px solid rgba(224,40,40,.4);
            box-shadow: 0 8px 32px rgba(224,40,40,.25), 0 4px 16px rgba(0,0,0,.4);
        }

        /* ── PREMIUM DARK MODE FOR LISTINGS/BROWSE PAGE (see full block below) ── */
        .hcf-3 .hcf-label {
            color: var(--ink);
            font-size: .7rem;
            letter-spacing: 1.5px;
        }
        [data-theme="dark"] .hcf-3 .hcf-badge {
            background: rgba(224,40,40,.2);
            border: 1px solid rgba(224,40,40,.4);
            color: #ff6b6b;
            font-size: .7rem;
            padding: 4px 10px;
        }
        .hcf-sold-thumb {
            width: 52px;
            height: 52px;
            border-radius: 10px;
            object-fit: cover;
            flex-shrink: 0;
            border: 2px solid rgba(224,40,40,.3);
            box-shadow: 0 4px 12px rgba(0,0,0,.3);
        }
        .hcf-sold-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 10px;
        }
        .hcf-sold-info {
            flex: 1;
            min-width: 0;
        }
        .hcf-sold-name {
            font-size: .92rem;
            font-weight: 700;
            color: var(--ink);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 150px;
            line-height: 1.3;
        }
        [data-theme="dark"] .hcf-sold-name {
            color: #ffffff;
        }
        .hcf-sold-loc  {
            font-size: .75rem;
            color: var(--ink3);
            margin-top: 2px;
        }
        [data-theme="dark"] .hcf-sold-loc {
            color: rgba(255,255,255,.6);
        }
        .hcf-sold-price {
            font-size: .88rem;
            font-weight: 800;
            color: #e02828;
            margin-top: 3px;
            font-family: var(--font-serif);
        }
        [data-theme="dark"] .hcf-sold-price {
            color: #ff6b6b;
        }
        .hcf-sold-btn  {
            background: linear-gradient(135deg, #e02828 0%, #c41e1e 100%);
            color: white;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 0.85rem;
            flex-shrink: 0;
            box-shadow: 0 4px 12px rgba(224,40,40,.5);
            transition: all .2s;
        }
        .hcf-sold-btn:hover {
            transform: scale(1.15);
            box-shadow: 0 6px 20px rgba(224,40,40,.7);
        }
        .badge-red { background: rgba(224,40,40,.12); color: #e02828; }
        .hcf-label { font-size: .65rem; font-weight: 600; letter-spacing: 1px; text-transform: uppercase; color: var(--ink4); margin-bottom: 4px; }
        .hcf-value { font-size: 1rem; font-weight: 600; color: var(--ink); }
        .hcf-sub { font-size: .78rem; color: var(--ink4); margin-top: 2px; }
        .hcf-badge { display: inline-flex; align-items: center; gap: 4px; font-size: .72rem; font-weight: 600; padding: 3px 8px; border-radius: 99px; margin-top: 6px; }
        .badge-green { background: var(--green-l); color: var(--green); }
        .badge-amber { background: var(--amber-l); color: var(--amber); }
        .badge-blue  { background: var(--accent-l); color: var(--accent); }
        .hcf-avatars { display: flex; margin-top: 8px; }
        .hcf-avatars img { width: 28px; height: 28px; border-radius: 50%; object-fit: cover; border: 2px solid white; margin-left: -8px; }
        .hcf-avatars:first-child { margin-left: 0; }

        /* ── SECTION COMMONS ── */
        .section { padding: 96px 40px; }
        .section-sm { padding: 64px 40px; }
        .container { max-width: 1280px; margin: 0 auto; }
        .section-tag {
            font-size: .7rem; font-weight: 700; letter-spacing: 2.5px;
            text-transform: uppercase; color: var(--accent);
            display: flex; align-items: center; gap: 8px; margin-bottom: 12px;
        }
        .section-tag::before {
            content:'';
            width: 24px;
            height: 3px;
            background: linear-gradient(90deg, var(--accent) 0%, var(--accent2) 100%);
            border-radius: 99px;
            box-shadow: 0 2px 6px var(--accent-glow);
        }
        .section-title {
            font-family: var(--font-serif);
            font-size: clamp(2rem, 3.5vw, 2.8rem);
            font-weight: 700; line-height: 1.15;
            color: var(--ink); letter-spacing: -0.5px;
        }
        .section-sub { font-size: 1rem; color: var(--ink3); font-weight: 300; line-height: 1.7; max-width: 520px; margin-top: 12px; }

        /* ── FILTER BAR ── */
        .filter-bar {
            display: flex; align-items: center; gap: 8px;
            flex-wrap: wrap; margin-bottom: 36px;
        }
        .filter-btn {
            font-size: .8rem; font-weight: 500;
            color: var(--ink3); background: var(--bg2);
            padding: 7px 16px; border-radius: 99px;
            border: 1.5px solid transparent;
            transition: all var(--t);
        }
        .filter-btn:hover { color: var(--ink); background: var(--bg3); }
        .filter-btn.active {
            color: var(--accent); background: var(--accent-l);
            border-color: rgba(157, 142, 238, 0.2);
        }
        .filter-right { margin-left: auto; display: flex; gap: 8px; }
        .sort-select {
            font-size: .8rem; font-weight: 500; color: var(--ink2);
            background: var(--bg2); border: 1.5px solid var(--line);
            padding: 7px 14px; border-radius: var(--r);
            -webkit-appearance: none; cursor: pointer;
        }

        /* ── PROPERTY CARD ── */
        .prop-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
        }
        .prop-card {
            background: var(--bg);
            border: 1.5px solid var(--line);
            border-radius: var(--r2);
            overflow: hidden;
            transition: all var(--t);
            cursor: pointer;
            animation: cardIn .4s ease both;
            box-shadow: var(--shadow-sm);
        }
        @keyframes cardIn { from { opacity:0; transform: translateY(12px); } to { opacity:1; transform: none; } }
        .prop-card:hover {
            border-color: transparent;
            box-shadow: var(--shadow-xl), 0 0 0 1px var(--accent-glow);
            transform: translateY(-6px) scale(1.02);
        }
        .prop-img-wrap { position: relative; height: 230px; overflow: hidden; }
        .prop-img-wrap img {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform .5s ease;
        }
        .prop-card:hover .prop-img-wrap img { transform: scale(1.05); }
        .prop-tags {
            position: absolute; top: 14px; left: 14px;
            display: flex; gap: 6px;
        }
        /* ── Heart Favorite Button ── */
        .heart-btn {
            position: absolute; top: 10px; right: 10px;
            z-index: 10;
            background: rgba(255,255,255,0.92);
            border: none; border-radius: 50%;
            width: 36px; height: 36px;
            font-size: 17px; color: #ccc;
            cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.18);
            transition: color 0.2s, transform 0.15s;
            line-height: 1;
        }
        .heart-btn:hover { color: #e63946; transform: scale(1.18); }
        .heart-btn--saved { color: #e63946; }
        .prop-tag {
            font-size: .68rem; font-weight: 700; letter-spacing: .5px;
            padding: 4px 10px; border-radius: 99px;
            /* No backdrop-filter here — it bleeds through semi-transparent dark-mode backgrounds */
        }
        .tag-sale { background: rgba(255,255,255,.97); color: var(--green); box-shadow: 0 1px 6px rgba(0,0,0,.14); }
        .tag-rent { background: rgba(255,255,255,.97); color: var(--accent); box-shadow: 0 1px 6px rgba(0,0,0,.14); }
        .tag-sold { background: rgba(224,40,40,.92); color: #fff; font-weight: 700; letter-spacing: .5px; box-shadow: 0 1px 6px rgba(0,0,0,.18); }
        .prop-card--sold { opacity: 0.82; position: relative; }
        .sold-tape {
            display: block;
            width: calc(100% + 32px);
            margin: -4px -16px 10px -16px;
            background: #e02828;
            color: #fff;
            font-size: 0.72rem;
            font-weight: 800;
            letter-spacing: 2.5px;
            text-transform: uppercase;
            text-align: center;
            padding: 6px 0;
            box-shadow: 0 2px 8px rgba(224,40,40,.35);
            user-select: none;
        }
        .plc-sold-tape {
            display: block;
            background: #e02828;
            color: #fff;
            font-size: 0.7rem;
            font-weight: 800;
            letter-spacing: 2px;
            text-transform: uppercase;
            text-align: center;
            padding: 5px 14px;
            margin-bottom: 8px;
            border-radius: 4px;
            box-shadow: 0 2px 6px rgba(224,40,40,.3);
            user-select: none;
            white-space: nowrap;
        }
        .prop-card--sold .prop-img-wrap img,
        .prop-card--sold .plc-img img { filter: grayscale(30%); }
        .sold-img-overlay {
            position: absolute; inset: 0;
            display: flex; flex-direction: column; align-items: center; justify-content: center;
            background: rgba(180,20,20,.45);
            pointer-events: none;
            padding: 20px;
            text-align: center;
        }
        .sold-img-overlay.booked-overlay {
            background: rgba(16,185,129,.45);
        }
        .sold-img-overlay .sold-title {
            font-size: 2rem;
            font-weight: 900;
            letter-spacing: 6px;
            color: #fff;
            text-shadow: 0 2px 12px rgba(0,0,0,.6);
            margin-bottom: 8px;
        }
        .sold-img-overlay .sold-message {
            font-size: 0.85rem;
            font-weight: 500;
            color: rgba(255,255,255,.95);
            text-shadow: 0 1px 6px rgba(0,0,0,.5);
            max-width: 200px;
            line-height: 1.4;
        }
        .tag-feat { background: var(--amber); color: white; }
        .prop-save {
            position: absolute; top: 14px; right: 14px;
            width: 36px; height: 36px; border-radius: 50%;
            background: rgba(255,255,255,.9); backdrop-filter: blur(8px);
            display: flex; align-items: center; justify-content: center;
            border: none; color: var(--ink3); font-size: 1rem;
            transition: all var(--t);
        }
        .prop-save:hover, .prop-save.saved { color: var(--red); background: white; }
        .prop-body { padding: 20px; }
        .prop-price {
            font-family: var(--font-serif);
            font-size: 1.5rem; font-weight: 700; color: var(--ink);
            margin-bottom: 4px;
        }
        .prop-price span { font-size: .875rem; font-weight: 400; color: var(--ink3); }
        .prop-name { font-size: .95rem; font-weight: 500; color: var(--ink2); margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .prop-loc { font-size: .82rem; color: var(--ink4); display: flex; align-items: center; gap: 4px; margin-bottom: 16px; }
        .prop-loc svg { width: 12px; height: 12px; flex-shrink: 0; }
        .prop-divider { height: 1px; background: var(--line2); margin-bottom: 14px; }
        .prop-meta { display: flex; gap: 16px; }
        .prop-meta-item {
            display: flex; align-items: center; gap: 5px;
            font-size: .78rem; color: var(--ink3); font-weight: 400;
        }
        .prop-meta-item svg { width: 14px; height: 14px; color: var(--ink4); flex-shrink: 0; }
        .prop-agent-row {
            display: flex; align-items: center; justify-content: space-between;
            margin-top: 14px; padding-top: 14px; border-top: 1px solid var(--line2);
        }
        .prop-agent { display: flex; align-items: center; gap: 8px; }
        .prop-agent img { width: 28px; height: 28px; border-radius: 50%; object-fit: cover; }
        .prop-agent-name { font-size: .75rem; font-weight: 500; color: var(--ink3); }
        .prop-views { font-size: .72rem; color: var(--ink4); display: flex; align-items: center; gap: 4px; }

        /* ── PROPERTY DETAIL PAGE ── */
        #page-detail { background: var(--bg); }
        .detail-hero { position: relative; height: 520px; overflow: hidden; margin-top: 68px; }
        .detail-hero img { width: 100%; height: 100%; object-fit: cover; }
        .detail-hero-overlay { position: absolute; inset: 0; background: linear-gradient(to top, rgba(15,17,23,.6) 0%, transparent 60%); }
        .detail-back-btn {
            position: absolute; top: 24px; left: 40px;
            background: rgba(255,255,255,.9); backdrop-filter: blur(8px);
            border: none; border-radius: var(--r);
            padding: 8px 16px; font-size: .82rem; font-weight: 500;
            display: flex; align-items: center; gap: 6px; color: var(--ink);
            transition: all var(--t); cursor: pointer;
        }
        .detail-back-btn:hover { background: white; }
        .detail-img-count {
            position: absolute; bottom: 24px; right: 40px;
            background: rgba(0,0,0,.5); backdrop-filter: blur(8px);
            color: white; padding: 6px 14px; border-radius: var(--r);
            font-size: .78rem; font-weight: 500;
            display: flex; align-items: center; gap: 6px;
        }
        .detail-thumbs {
            display: flex; gap: 8px; margin-top: 12px; overflow-x: auto; padding-bottom: 4px;
        }
        .detail-thumbs img {
            width: 100px; height: 70px; object-fit: cover;
            border-radius: var(--r); cursor: pointer; flex-shrink: 0;
            border: 2px solid transparent; transition: all var(--t);
        }
        .detail-thumbs img.active, .detail-thumbs img:hover { border-color: var(--accent); }

        .detail-layout { display: grid; grid-template-columns: 1fr 380px; gap: 48px; padding: 48px 40px; max-width: 1280px; margin: 0 auto; }
        .detail-main {}
        .detail-tag-row { display: flex; gap: 8px; margin-bottom: 12px; flex-wrap: wrap; }
        .detail-tag {
            font-size: .7rem; font-weight: 700; letter-spacing: .5px;
            padding: 4px 12px; border-radius: 99px;
        }
        .detail-title {
            font-family: var(--font-serif);
            font-size: 2.4rem; font-weight: 700; line-height: 1.15;
            color: var(--ink); margin-bottom: 8px; letter-spacing: -.5px;
        }
        .detail-address { font-size: .95rem; color: var(--ink3); display: flex; align-items: center; gap: 6px; margin-bottom: 28px; }
        .detail-price-row { display: flex; align-items: flex-end; gap: 16px; margin-bottom: 28px; padding-bottom: 28px; border-bottom: 1px solid var(--line); }
        .detail-price {
            font-family: var(--font-serif);
            font-size: 2.6rem; font-weight: 700; color: var(--ink); line-height: 1;
        }
        .detail-price-sub { font-size: .875rem; color: var(--ink4); margin-bottom: 4px; }
        .detail-specs { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 36px; }
        .spec-box {
            background: var(--bg2); border-radius: var(--r);
            padding: 16px; text-align: center;
        }
        .spec-icon { font-size: 1.3rem; margin-bottom: 6px; }
        .spec-value { font-size: 1.1rem; font-weight: 700; color: var(--ink); }
        .spec-label { font-size: .7rem; color: var(--ink4); font-weight: 400; margin-top: 2px; }
        .detail-section-title { font-size: 1rem; font-weight: 700; color: var(--ink); margin-bottom: 14px; margin-top: 32px; }
        .detail-desc { font-size: .925rem; color: var(--ink3); line-height: 1.8; }
        .features-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; }
        .feature-item {
            display: flex; align-items: center; gap: 10px;
            font-size: .875rem; color: var(--ink2); font-weight: 400;
        }
        .feature-check {
            width: 20px; height: 20px; border-radius: 50%;
            background: var(--green-l); color: var(--green);
            display: flex; align-items: center; justify-content: center;
            font-size: .65rem; flex-shrink: 0;
        }

        .detail-sidebar {}
        .sidebar-card {
            background: var(--bg); border: 1.5px solid var(--line);
            border-radius: var(--r2); padding: 24px; margin-bottom: 20px;
            position: sticky; top: 88px;
        }
        .agent-profile { display: flex; align-items: center; gap: 14px; margin-bottom: 20px; }
        .agent-profile img { width: 60px; height: 60px; border-radius: 50%; object-fit: cover; }
        .agent-profile-name { font-size: 1rem; font-weight: 700; color: var(--ink); }
        .agent-profile-title { font-size: .78rem; color: var(--ink4); margin-top: 2px; }
        .agent-stars { display: flex; align-items: center; gap: 4px; font-size: .78rem; color: var(--amber); margin-top: 4px; }
        .agent-stars span { color: var(--ink3); }
        .contact-form-input {
            width: 100%; background: var(--bg2); border: 1.5px solid transparent;
            border-radius: var(--r); padding: 11px 14px;
            font-size: .875rem; color: var(--ink); margin-bottom: 10px;
            transition: border-color var(--t);
        }
        .contact-form-input:focus { border-color: var(--accent); background: white; }
        .contact-form-input::placeholder { color: var(--ink4); }
        .btn-contact {
            width: 100%; background: var(--accent); color: white;
            padding: 12px; border-radius: var(--r); font-size: .875rem; font-weight: 600;
            border: none; margin-bottom: 10px; cursor: pointer; transition: all var(--t);
        }
        .btn-contact:hover { background: var(--accent2); }
        .btn-contact-outline {
            width: 100%; background: none; color: var(--ink2);
            padding: 11px; border-radius: var(--r); font-size: .875rem; font-weight: 500;
            border: 1.5px solid var(--line); cursor: pointer; transition: all var(--t);
        }
        .btn-contact-outline:hover { border-color: var(--ink2); }

        /* ── AGENTS PAGE ── */
        .agents-hero {
            background: var(--bg2);
            padding: 80px 40px 60px;
            margin-top: 68px;
            border-bottom: 1px solid var(--line);
        }
        .agent-card {
            background: var(--bg); border: 1.5px solid var(--line);
            border-radius: var(--r2); overflow: hidden;
            transition: all var(--t); cursor: pointer;
            animation: cardIn .4s ease both;
        }
        .agent-card:hover { box-shadow: var(--shadow-xl); transform: translateY(-4px); border-color: transparent; }
        .agent-card-img { position: relative; height: 220px; overflow: hidden; }
        .agent-card-img img { width: 100%; height: 100%; object-fit: cover; transition: transform .5s; }
        .agent-card:hover .agent-card-img img { transform: scale(1.05); }
        .agent-card-body { padding: 22px; }
        .agent-card-name { font-family: var(--font-serif); font-size: 1.2rem; font-weight: 700; color: var(--ink); margin-bottom: 2px; }
        .agent-card-role { font-size: .78rem; color: var(--accent); font-weight: 600; letter-spacing: .5px; text-transform: uppercase; margin-bottom: 12px; }
        .agent-card-stats { display: flex; gap: 0; border-top: 1px solid var(--line2); padding-top: 14px; }
        .ac-stat { flex: 1; text-align: center; }
        .ac-stat:not(:last-child) { border-right: 1px solid var(--line2); }
        .ac-stat-val { font-size: 1.1rem; font-weight: 700; color: var(--ink); }
        .ac-stat-label { font-size: .68rem; color: var(--ink4); font-weight: 400; margin-top: 2px; }

        /* ── AUTH PAGES (FIXED BULLETPROOF) ── */
        /* ── AUTH PAGES (FOOLPROOF HTML FIX) ── */
        .auth-page {
            min-height: 100vh;
            display: grid;
            grid-template-columns: 1fr 1fr;
            padding-top: 68px;
        }

        .auth-left {
            background-color: #1a1d27;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 60px;
        }

        /* These control the physical HTML images */
        .auth-bg-img {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: 0;
            transition: opacity 0.5s ease;
        }

        .auth-dark-img { display: none; }
        [data-theme="dark"] .auth-light-img { display: none; }
        [data-theme="dark"] .auth-dark-img { display: block; }

        /* The Dark Glass Overlay */
        .auth-left::before {
            content: '';
            position: absolute;
            inset: 0;
            background: rgba(15, 17, 23, 0.4);
            z-index: 1;
        }

        .auth-left-content {
            position: relative;
            z-index: 10;
        }

        .auth-quote {
            font-family: var(--font-serif);
            font-size: 2.2rem; font-weight: 400; font-style: italic;
            color: white; line-height: 1.3; margin-bottom: 20px;
            text-shadow: 0 2px 8px rgba(0,0,0,0.6); /* Adds a shadow so text is always readable */
        }

        .auth-quote-attr { font-size: .875rem; color: rgba(255,255,255,.9); }

        .auth-right {
            display: flex; align-items: center; justify-content: center;
            padding: 60px 80px; background: var(--bg);
        }
        .auth-box { width: 100%; max-width: 420px; }
        .auth-title { font-family: var(--font-serif); font-size: 2rem; font-weight: 700; color: var(--ink); margin-bottom: 6px; }
        .auth-sub { font-size: .9rem; color: var(--ink3); margin-bottom: 36px; }
        .auth-field { margin-bottom: 16px; }
        .auth-field label { display: block; font-size: .78rem; font-weight: 600; color: var(--ink2); margin-bottom: 6px; }
        .auth-input {
            width: 100%; background: var(--bg2); border: 1.5px solid transparent;
            border-radius: var(--r); padding: 12px 14px;
            font-size: .9rem; color: var(--ink); transition: all var(--t);
        }
        .auth-input:focus { border-color: var(--accent); background: white; box-shadow: 0 0 0 3px rgba(157, 142, 238, 0.1); }
        .auth-input::placeholder { color: var(--ink4); }

        /* ── PASSWORD EYE TOGGLE ── */
        .pw-wrap { position: relative; }
        .pw-wrap .auth-input { padding-right: 46px; }
        .pw-eye {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            width: 36px;
            height: 36px;
            border-radius: 12px;
            border: 1px solid transparent;
            background: transparent;
            color: var(--ink4);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all var(--t);
        }
        .pw-eye:hover {
            background: var(--bg2);
            border-color: var(--line);
            color: var(--ink2);
        }
        .pw-eye:active { transform: translateY(-50%) scale(0.98); }
        .pw-eye:focus-visible {
            outline: none;
            box-shadow: 0 0 0 3px rgba(157, 142, 238, 0.18);
            border-color: rgba(157, 142, 238, 0.35);
            background: var(--accent-l);
            color: var(--accent);
        }
        .pw-eye svg { width: 18px; height: 18px; }
        .auth-divider { display: flex; align-items: center; gap: 12px; margin: 20px 0; }
        .auth-divider::before, .auth-divider::after { content:''; flex:1; height:1px; background:var(--line); }
        .auth-divider span { font-size: .78rem; color: var(--ink4); white-space: nowrap; }
        .auth-social { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 20px; }
        .auth-social-btn {
            display: flex; align-items: center; justify-content: center; gap: 8px;
            padding: 10px; border-radius: var(--r); border: 1.5px solid var(--line);
            font-size: .82rem; font-weight: 500; color: var(--ink2); background: white;
            cursor: pointer; transition: all var(--t);
        }
        .auth-social-btn:hover { border-color: var(--ink2); }
        .auth-submit {
            width: 100%; background: var(--accent); color: white;
            padding: 13px; border-radius: var(--r); font-size: .9rem; font-weight: 600;
            border: none; margin-top: 8px; cursor: pointer; transition: all var(--t);
        }
        .auth-submit:hover { background: var(--accent2); box-shadow: 0 4px 14px rgba(157, 142, 238, 0.35); }
        .auth-switch { text-align: center; margin-top: 20px; font-size: .85rem; color: var(--ink3); }
        .auth-switch a { color: var(--accent); font-weight: 600; cursor: pointer; }
        .auth-role-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 8px; margin-bottom: 20px; }
        .role-btn {
            padding: 10px 8px; border-radius: var(--r); border: 1.5px solid var(--line);
            background: var(--bg2); font-size: .78rem; font-weight: 500; color: var(--ink3);
            cursor: pointer; transition: all var(--t); text-align: center;
        }
        .role-btn.selected { border-color: var(--accent); background: var(--accent-l); color: var(--accent); }
        .role-btn .ri { font-size: 1.2rem; display: block; margin-bottom: 4px; }

        /* ── LISTINGS PAGE ── */
        .listings-header {
            background: var(--bg); padding: 40px 40px 0;
            margin-top: 68px; border-bottom: 1px solid var(--line);
        }
        .listings-layout { display: grid; grid-template-columns: 300px 1fr; gap: 0; min-height: calc(100vh - 68px); }
        .listings-sidebar {
            border-right: 1px solid var(--line); padding: 28px;
            height: calc(100vh - 68px); overflow-y: auto; position: sticky; top: 68px;
        }
        .filter-section { margin-bottom: 28px; }
        .filter-section-title { font-size: .75rem; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: var(--ink3); margin-bottom: 12px; }
        .price-range { display: flex; gap: 8px; }
        .price-range-input {
            flex: 1; box-sizing: border-box;
            background: var(--bg2); border: 1.5px solid var(--line);
            border-radius: var(--r); padding: 10px 14px;
            font-size: .82rem; color: var(--ink);
            transition: border-color var(--t), box-shadow var(--t);
        }
        .price-range-input::placeholder { color: rgba(var(--ink-rgb, 55,65,81),.5); }
        .price-range-input::-webkit-outer-spin-button,
        .price-range-input::-webkit-inner-spin-button {
            -webkit-appearance: none; margin: 0;
        }
        .price-range-input[type=number] { -moz-appearance: textfield; }
        .price-range-input:focus { border-color: var(--accent); outline: none; box-shadow: 0 0 0 3px rgba(var(--accent-rgb, 99,102,241),.15); background: var(--bg); }
        .price-dropdown-wrap { position: relative; }
        .price-range-select {
            width: 100%; box-sizing: border-box;
            background: var(--bg2); border: 1.5px solid var(--line);
            border-radius: var(--r); padding: 10px 36px 10px 14px;
            font-size: .82rem; color: var(--ink); cursor: pointer;
            appearance: none; -webkit-appearance: none;
            transition: border-color var(--t), box-shadow var(--t);
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%236C7B8B' stroke-width='2.5'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
        }
        .price-range-select:focus { border-color: var(--accent); outline: none; box-shadow: 0 0 0 3px rgba(var(--accent-rgb, 99,102,241),.15); }
        .price-range-select option { background: var(--bg2); color: var(--ink); }
        .filter-chips { display: flex; flex-wrap: wrap; gap: 6px; }
        .filter-chip {
            font-size: .75rem; font-weight: 500; color: var(--ink3);
            background: var(--bg2); border: 1.5px solid transparent;
            padding: 5px 12px; border-radius: 99px; cursor: pointer; transition: all var(--t);
        }
        .filter-chip:hover { background: var(--bg3); }
        .filter-chip.active { color: var(--accent); background: var(--accent-l); border-color: rgba(157, 142, 238, 0.25); }
        .filter-beds { display: flex; gap: 6px; }
        .bed-btn {
            width: 40px; height: 36px; border-radius: var(--r);
            background: var(--bg2); border: 1.5px solid transparent;
            font-size: .82rem; font-weight: 600; color: var(--ink3); cursor: pointer; transition: all var(--t);
        }
        .bed-btn.active { background: var(--accent-l); color: var(--accent); border-color: rgba(157, 142, 238, 0.25); }
        .apply-filter-btn {
            width: 100%; background: var(--accent); color: white;
            padding: 11px; border-radius: var(--r); font-size: .875rem; font-weight: 600;
            border: none; cursor: pointer; transition: all var(--t); margin-top: 20px;
        }
        .apply-filter-btn:hover { background: var(--accent2); }
        .clear-filter-btn {
            width: 100%; background: none; color: var(--ink3);
            padding: 9px; border-radius: var(--r); font-size: .82rem; font-weight: 500;
            border: 1.5px solid var(--line); cursor: pointer; transition: all var(--t); margin-top: 8px;
        }
        .listings-main { padding: 28px; overflow-y: auto; }
        .listings-top-bar { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; flex-wrap: wrap; gap: 12px; }
        .listings-count { font-size: .875rem; color: var(--ink3); }
        .listings-count strong { color: var(--ink); }
        .view-toggle { display: flex; gap: 4px; }
        .view-btn {
            width: 34px; height: 34px; border-radius: var(--r);
            background: var(--bg2); border: 1.5px solid transparent;
            display: flex; align-items: center; justify-content: center;
            color: var(--ink3); cursor: pointer; transition: all var(--t);
        }
        .view-btn.active { background: var(--accent-l); color: var(--accent); border-color: rgba(157, 142, 238, 0.25); }

        /* ── LIST VIEW LAYOUT ── */
        .prop-grid--list {
            display: flex; flex-direction: column; gap: 14px;
        }
        .prop-card--list {
            display: flex; flex-direction: row; align-items: stretch;
            border-radius: var(--r2); overflow: hidden; cursor: pointer;
            background: var(--bg); border: 1.5px solid var(--line);
            transition: all var(--t); animation: cardIn .35s ease both;
            min-height: 140px; width: 100%; grid-column: 1 / -1;
        }
        .prop-card--list:hover {
            border-color: transparent; box-shadow: var(--shadow-xl);
            transform: translateY(-2px);
        }
        .plc-img {
            position: relative; width: 220px; flex-shrink: 0; overflow: hidden;
        }
        .plc-img img { width: 100%; height: 100%; object-fit: cover; transition: transform .5s ease; }
        .prop-card--list:hover .plc-img img { transform: scale(1.06); }
        .plc-tag { position: absolute; top: 10px; left: 10px; }
        .plc-body {
            flex: 1; padding: 18px 20px; display: flex; flex-direction: column;
            justify-content: center; gap: 6px; min-width: 0;
        }
        .plc-type {
            font-size: .72rem; font-weight: 700; text-transform: capitalize;
            color: var(--accent); background: var(--accent-l);
            padding: 2px 9px; border-radius: 6px; width: fit-content;
        }
        .plc-title {
            font-size: 1rem; font-weight: 600; color: var(--ink2);
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        .plc-loc { font-size: .8rem; color: var(--ink4); }
        .plc-meta {
            display: flex; gap: 14px; font-size: .78rem; color: var(--ink3);
            flex-wrap: wrap;
        }
        .plc-right {
            display: flex; flex-direction: column; align-items: flex-end;
            justify-content: center; gap: 10px;
            padding: 18px 22px; border-left: 1px solid var(--line); flex-shrink: 0;
            min-width: 180px;
        }
        .plc-price {
            font-family: var(--font-serif); font-size: 1.35rem; font-weight: 700;
            color: var(--ink); white-space: nowrap;
        }
        .plc-agent { display: flex; align-items: center; gap: 7px; }
        .plc-agent img { width: 26px; height: 26px; border-radius: 50%; object-fit: cover; }
        .plc-agent span { font-size: .75rem; font-weight: 500; color: var(--ink3); white-space: nowrap; }
        @media (max-width: 640px) {
            .prop-card--list { flex-direction: column; }
            .plc-img { width: 100%; height: 180px; }
            .plc-right { border-left: none; border-top: 1px solid var(--line); flex-direction: row; justify-content: space-between; align-items: center; min-width: unset; }
        }

        /* ══════════════════════════════════════════════
           RANDOM MULTI-VIEW CARD STYLES
           Each property in Browse gets one of 5 layouts
           ══════════════════════════════════════════════ */

        /* ── VIEW: COMPACT (small horizontal pill) ── */
        .prop-card--compact {
            display: flex; flex-direction: row; align-items: center;
            border-radius: var(--r2); overflow: hidden; cursor: pointer;
            background: var(--bg); border: 1.5px solid var(--line);
            transition: all var(--t); animation: cardIn .35s ease both;
            min-height: 90px; gap: 0;
        }
        .prop-card--compact:hover { border-color: transparent; box-shadow: var(--shadow-xl); transform: translateY(-2px); }
        .pcc-img { position: relative; width: 110px; flex-shrink: 0; overflow: hidden; align-self: stretch; }
        .pcc-img img { width: 100%; height: 100%; object-fit: cover; transition: transform .5s ease; }
        .prop-card--compact:hover .pcc-img img { transform: scale(1.08); }
        .pcc-tag { position: absolute; top: 6px; left: 6px; font-size: .65rem !important; padding: 2px 7px !important; }
        .pcc-body { flex: 1; padding: 10px 14px; display: flex; flex-direction: column; justify-content: center; gap: 3px; min-width: 0; }
        .pcc-title { font-size: .88rem; font-weight: 600; color: var(--ink2); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-bottom: 3px; }
        .pcc-loc { font-size: .72rem; color: var(--ink4); }
        .pcc-specs { display: flex; gap: 8px; font-size: .72rem; color: var(--ink3); margin-top: 2px; }
        .pcc-price { font-size: 1rem; font-weight: 700; color: var(--accent); padding: 10px 16px; border-left: 1px solid var(--line); flex-shrink: 0; white-space: nowrap; display: flex; align-items: center; }

        /* ── VIEW: SPOTLIGHT (tall hero card) ── */
        .prop-card--spotlight {
            position: relative; border-radius: var(--r2); overflow: hidden;
            cursor: pointer; min-height: 360px; display: flex; flex-direction: column;
            justify-content: flex-end; animation: cardIn .35s ease both;
            transition: all var(--t); box-shadow: 0 4px 20px rgba(0,0,0,.08);
        }
        .prop-card--spotlight:hover { transform: translateY(-4px) scale(1.01); box-shadow: 0 16px 50px rgba(0,0,0,.18); }
        .pcs-img { position: absolute; inset: 0; }
        .pcs-img img { width: 100%; height: 100%; object-fit: cover; transition: transform .6s ease; }
        .prop-card--spotlight:hover .pcs-img img { transform: scale(1.07); }
        .pcs-gradient { position: absolute; inset: 0; background: linear-gradient(to top, rgba(0,0,0,.85) 0%, rgba(0,0,0,.3) 55%, rgba(0,0,0,.05) 100%); }
        .pcs-body { position: relative; z-index: 2; padding: 22px 20px 18px; color: white; }
        .pcs-tag-row { display: flex; gap: 8px; margin-bottom: 10px; }
        .pcs-type-tag { font-size: .68rem; font-weight: 700; padding: 3px 10px; border-radius: 6px; background: rgba(255,255,255,.18); backdrop-filter: blur(6px); border: 1px solid rgba(255,255,255,.25); text-transform: capitalize; }
        .pcs-title { font-size: 1.15rem; font-weight: 700; line-height: 1.3; margin-bottom: 6px; text-shadow: 0 1px 4px rgba(0,0,0,.5); }
        .pcs-loc { font-size: .78rem; opacity: .85; margin-bottom: 12px; }
        .pcs-footer { display: flex; justify-content: space-between; align-items: center; }
        .pcs-price { font-size: 1.3rem; font-weight: 800; text-shadow: 0 1px 4px rgba(0,0,0,.4); }
        .pcs-meta { display: flex; gap: 12px; font-size: .75rem; opacity: .85; }

        /* ── VIEW: MAGAZINE (wide image left, text right) ── */
        .prop-card--magazine {
            display: flex; flex-direction: row; border-radius: var(--r2);
            overflow: hidden; cursor: pointer; background: var(--bg);
            border: 1.5px solid var(--line); animation: cardIn .35s ease both;
            transition: all var(--t); min-height: 200px;
        }
        .prop-card--magazine:hover { border-color: transparent; box-shadow: var(--shadow-xl); transform: translateY(-3px); }
        .pcm-img { position: relative; width: 52%; flex-shrink: 0; overflow: hidden; }
        .pcm-img img { width: 100%; height: 100%; object-fit: cover; transition: transform .55s ease; }
        .prop-card--magazine:hover .pcm-img img { transform: scale(1.07); }
        .pcm-badge { position: absolute; bottom: 12px; left: 12px; background: rgba(255,255,255,.92); backdrop-filter: blur(8px); border-radius: 8px; padding: 6px 12px; font-size: .72rem; font-weight: 700; color: var(--ink); }
        .pcm-body { flex: 1; padding: 22px 20px; display: flex; flex-direction: column; justify-content: space-between; min-width: 0; }
        .pcm-category { font-size: .68rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: var(--accent); margin-bottom: 8px; }
        .pcm-title { font-size: 1.08rem; font-weight: 700; color: var(--ink); line-height: 1.4; margin-bottom: 8px; }
        .pcm-desc { font-size: .78rem; color: var(--ink3); line-height: 1.5; flex: 1; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; }
        .pcm-footer { margin-top: 14px; padding-top: 12px; border-top: 1px solid var(--line); display: flex; justify-content: space-between; align-items: center; }
        .pcm-price { font-size: 1.15rem; font-weight: 800; color: var(--ink); }
        .pcm-agent { display: flex; align-items: center; gap: 7px; }
        .pcm-agent img { width: 28px; height: 28px; border-radius: 50%; object-fit: cover; }
        .pcm-agent span { font-size: .72rem; color: var(--ink3); font-weight: 500; }

        /* ── VIEW: MINIMAL (text-heavy, no big image) ── */
        .prop-card--minimal {
            display: flex; flex-direction: row; align-items: center; gap: 16px;
            border-radius: var(--r2); cursor: pointer; background: var(--bg);
            border: 1.5px solid var(--line); padding: 16px 20px;
            animation: cardIn .35s ease both; transition: all var(--t);
        }
        .prop-card--minimal:hover { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(157, 142, 238, 0.08); }
        .pcn-thumb { width: 80px; height: 70px; border-radius: 8px; overflow: hidden; flex-shrink: 0; }
        .pcn-thumb img { width: 100%; height: 100%; object-fit: cover; }
        .pcn-body { flex: 1; min-width: 0; }
        .pcn-title { font-size: .95rem; font-weight: 600; color: var(--ink); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-bottom: 3px; }
        .pcn-meta { font-size: .75rem; color: var(--ink3); display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 4px; }
        .pcn-tags { display: flex; gap: 6px; flex-wrap: wrap; }
        .pcn-tag { font-size: .65rem; font-weight: 600; padding: 2px 8px; border-radius: 12px; background: var(--bg2); color: var(--ink3); border: 1px solid var(--line); }
        .pcn-right { text-align: right; flex-shrink: 0; }
        .pcn-price { font-size: 1.05rem; font-weight: 800; color: var(--ink); white-space: nowrap; }
        .pcn-status { font-size: .7rem; color: var(--ink4); margin-top: 3px; }

        /* ── VIEW: POLAROID (square image + bottom info strip) ── */
        .prop-card--polaroid {
            display: flex; flex-direction: column; border-radius: var(--r2);
            overflow: hidden; cursor: pointer; background: var(--bg);
            border: 1.5px solid var(--line); animation: cardIn .35s ease both;
            transition: all var(--t);
        }
        .prop-card--polaroid:hover { border-color: transparent; box-shadow: var(--shadow-xl); transform: translateY(-4px) rotate(0.5deg); }
        .pcp-img { position: relative; width: 100%; padding-top: 75%; overflow: hidden; }
        .pcp-img img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; transition: transform .55s ease; }
        .prop-card--polaroid:hover .pcp-img img { transform: scale(1.07); }
        .pcp-tag { position: absolute; top: 10px; right: 10px; }
        .pcp-body { padding: 14px 16px; }
        .pcp-price { font-size: 1.15rem; font-weight: 800; color: var(--ink); margin-bottom: 4px; }
        .pcp-title { font-size: .88rem; font-weight: 600; color: var(--ink2); margin-bottom: 6px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .pcp-footer { display: flex; justify-content: space-between; align-items: center; }
        .pcp-loc { font-size: .72rem; color: var(--ink4); }
        .pcp-specs { display: flex; gap: 8px; font-size: .72rem; color: var(--ink3); }

        /* ── WHY SECTION ── */
        .why-section {
            background: linear-gradient(135deg, #0f1117 0%, #1a1d27 100%);
            padding: 96px 40px;
            position: relative;
            overflow: hidden;
        }
        .why-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 800px;
            height: 800px;
            background: radial-gradient(circle, rgba(157, 142, 238, 0.08) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .why-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 2px; position: relative; z-index: 1; }
        .why-card {
            background: rgba(255,255,255,.04);
            padding: 40px 36px;
            transition: all var(--t);
            border: 1px solid rgba(255,255,255,0.05);
            backdrop-filter: blur(10px);
        }
        .why-card:hover {
            background: rgba(255,255,255,.08);
            border-color: rgba(157, 142, 238, 0.3);
            box-shadow: 0 8px 32px rgba(0,0,0,0.3), 0 0 0 1px var(--accent-glow);
            transform: translateY(-4px);
        }
        .why-icon {
            width: 48px; height: 48px; border-radius: var(--r);
            background: linear-gradient(135deg, rgba(157, 142, 238, 0.3) 0%, rgba(139, 124, 220, 0.2) 100%);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem; margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(157, 142, 238, 0.2);
            border: 1px solid rgba(157, 142, 238, 0.3);
        }
        .why-title { font-size: 1.1rem; font-weight: 600; color: white; margin-bottom: 10px; }
        .why-desc { font-size: .875rem; color: rgba(255,255,255,.5); line-height: 1.7; }

        /* ── TESTIMONIALS ── */
        .testi-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 24px; }
        .testi-card {
            background: linear-gradient(135deg, var(--bg2) 0%, var(--bg3) 100%);
            border-radius: var(--r2);
            padding: 28px;
            transition: all var(--t);
            border: 1.5px solid var(--line);
            box-shadow: var(--shadow-sm);
        }
        .testi-card:hover {
            box-shadow: var(--shadow-xl), 0 0 0 1px var(--accent-glow);
            transform: translateY(-4px) scale(1.02);
            background: linear-gradient(135deg, var(--bg) 0%, var(--bg2) 100%);
            border-color: var(--accent);
        }
        .testi-stars { color: var(--amber); font-size: .875rem; margin-bottom: 14px; letter-spacing: 2px; }
        .testi-text {
            font-family: var(--font-serif);
            font-style: italic; font-size: 1.05rem;
            color: var(--ink2); line-height: 1.65; margin-bottom: 20px;
        }
        .testi-author { display: flex; align-items: center; gap: 12px; }
        .testi-author img { width: 44px; height: 44px; border-radius: 50%; object-fit: cover; }
        .testi-name { font-size: .875rem; font-weight: 600; color: var(--ink); }
        .testi-role { font-size: .75rem; color: var(--ink4); margin-top: 1px; }

        /* ── FOOTER (PREMIUM DARK) ── */
        .footer {
            background: linear-gradient(135deg, #0f1117 0%, #1a1d27 100%);
            border-top: 1px solid rgba(255,255,255,0.08);
            padding: 64px 40px 32px;
            position: relative;
            overflow: hidden;
        }
        .footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: linear-gradient(90deg, transparent 0%, var(--accent) 50%, transparent 100%);
            opacity: 0.5;
        }
        .footer-top { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 48px; margin-bottom: 48px; }
        .footer-logo { font-family: var(--font-serif); font-size: 1.5rem; font-weight: 700; color: #ffffff; margin-bottom: 12px; display: flex; align-items: center; gap: 6px; }
        .footer-desc { font-size: .875rem; color: #9198a8; line-height: 1.7; max-width: 280px; margin-bottom: 20px; }
        .footer-socials { display: flex; gap: 8px; }
        .social-btn {
            width: 36px; height: 36px; border-radius: var(--r);
            background: linear-gradient(135deg, #1a1d27 0%, #232736 100%);
            border: 1px solid rgba(255,255,255,0.1);
            display: flex; align-items: center; justify-content: center;
            color: #9198a8; font-size: .875rem;
            transition: all var(--t); cursor: pointer;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
        }
        .social-btn:hover {
            background: linear-gradient(135deg, var(--accent) 0%, var(--accent2) 100%);
            color: white;
            border-color: var(--accent);
            box-shadow: 0 4px 16px var(--accent-glow), 0 0 0 1px rgba(255,255,255,0.2) inset;
            transform: translateY(-2px);
        }
        .footer-col-title { font-size: .75rem; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; color: #ffffff; margin-bottom: 16px; }
        .footer-links { list-style: none; }
        .footer-links li { margin-bottom: 10px; }
        .footer-links a { font-size: .875rem; color: #9198a8; transition: color var(--t); }
        .footer-links a:hover { color: var(--accent); }
        .footer-bottom { border-top: 1px solid #1a1d27; padding-top: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; }
        .footer-copy { font-size: .8rem; color: #5a5f70; }
        .footer-legal { display: flex; gap: 20px; }
        .footer-legal a { font-size: .8rem; color: #5a5f70; transition: color var(--t); }
        .footer-legal a:hover { color: #ffffff; }

        /* ── TOAST ── */
        .toast {
            position: fixed; bottom: 28px; right: 28px; z-index: 9999;
            background: var(--ink); color: white; border-radius: var(--r);
            padding: 14px 20px; font-size: .875rem; font-weight: 500;
            box-shadow: var(--shadow-xl); display: flex; align-items: center; gap: 10px;
            transform: translateY(80px); opacity: 0; transition: all .3s cubic-bezier(.34,1.56,.64,1);
            pointer-events: none;
        }
        .toast.show { transform: none; opacity: 1; }
        .toast-icon { font-size: 1rem; }

        /* ── MODAL ── */
        .modal-overlay {
            position: fixed; inset: 0; z-index: 2000;
            background: rgba(15,17,23,.5); backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            opacity: 0; pointer-events: none; transition: opacity var(--t);
            padding: 20px;
        }
        .modal-overlay.open { opacity: 1; pointer-events: all; }
        .modal-box {
            background: white; border-radius: var(--r3);
            padding: 36px; width: 100%; max-width: 480px;
            box-shadow: var(--shadow-xl);
            transform: scale(.95) translateY(10px);
            transition: transform .25s cubic-bezier(.34,1.56,.64,1);
        }
        .modal-overlay.open .modal-box { transform: none; }
        .modal-title { font-family: var(--font-serif); font-size: 1.5rem; font-weight: 700; color: var(--ink); margin-bottom: 6px; }
        .modal-sub { font-size: .875rem; color: var(--ink3); margin-bottom: 24px; }

        /* ── UTILITIES ── */
        .text-center { text-align: center; }
        .mt-8  { margin-top: 8px; }
        .mt-16 { margin-top: 16px; }
        .mt-24 { margin-top: 24px; }
        .mt-48 { margin-top: 48px; }
        .mb-48 { margin-bottom: 48px; }
        .flex { display: flex; }
        .items-center { align-items: center; }
        .justify-between { justify-content: space-between; }
        .gap-8  { gap: 8px; }
        .gap-12 { gap: 12px; }
        .load-more-btn {
            display: flex; align-items: center; justify-content: center;
            gap: 8px; padding: 13px 36px; border-radius: var(--r);
            background: none; border: 1.5px solid var(--line);
            font-size: .875rem; font-weight: 500; color: var(--ink2);
            cursor: pointer; transition: all var(--t); margin: 40px auto 0;
        }
        .load-more-btn:hover { border-color: var(--accent); color: var(--accent); background: var(--accent-l); }
        .page-header { margin-top: 68px; padding: 56px 40px 40px; border-bottom: 1px solid var(--line); background: var(--bg2); }
        .skeleton { background: linear-gradient(90deg, var(--bg2) 25%, var(--bg3) 50%, var(--bg2) 75%); background-size: 200% 100%; animation: shimmer 1.5s infinite; border-radius: var(--r); }
        @keyframes shimmer { 0% { background-position: 200% 0; } 100% { background-position: -200% 0; } }

        /* ── TELEGRAM STYLE THEME TOGGLE ── */
        .theme-switch {
            position: relative;
            width: 54px;
            height: 30px;
            background-color: var(--line); /* Light gray track in day mode */
            border-radius: 30px;
            cursor: pointer;
            display: flex;
            align-items: center;
            padding: 4px;
            transition: background-color 0.4s ease;
            margin-right: 12px;
        }

        .theme-switch-thumb {
            width: 22px;
            height: 22px;
            background-color: white;
            border-radius: 50%;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            /* This creates that bouncy, smooth Telegram slide effect */
            transition: transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
        }

        /* Dark Mode State: Turns the track blue and slides the circle to the right */
        [data-theme="dark"] .theme-switch {
            background-color: var(--accent);
        }

        [data-theme="dark"] .theme-switch-thumb {
            transform: translateX(24px);
            background-color: var(--bg2);
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 1024px) {
            .hero { grid-template-columns: 1fr; }
            .hero-right { display: none; }
            .detail-layout { grid-template-columns: 1fr; }
            .detail-sidebar { position: static; }
            .auth-left { display: none; }
            .auth-page { grid-template-columns: 1fr; }
            .footer-top { grid-template-columns: 1fr 1fr; }
        }
        @media (max-width: 768px) {
            .navbar { padding: 0 20px; }
            .nav-links { display: none; }
            .hero-left { padding: 60px 20px; }
            .hero-search { flex-direction: column; }
            .hero-search-field { border-right: none; border-bottom: 1.5px solid var(--line); }
            .listings-layout { grid-template-columns: 1fr; }
            .listings-sidebar { display: none; }
            .section { padding: 64px 20px; }
            .detail-specs { grid-template-columns: repeat(2,1fr); }
            .testi-grid { grid-template-columns: 1fr; }
            .why-grid { grid-template-columns: 1fr; }
            .footer-top { grid-template-columns: 1fr; }
        }

        /* ── MODERN KEBAB MENU ── */
        .rev-header { display: flex; justify-content: space-between; align-items: flex-start; }
        .rev-menu-wrap { position: relative; }
        .rev-dots-btn {
            background: none; color: var(--ink4); font-size: 1.5rem;
            cursor: pointer; padding: 0 8px; transition: 0.2s;
        }
        .rev-dots-btn:hover { color: var(--accent); }
        .rev-dropdown {
            position: absolute; right: 0; top: 30px; z-index: 100;
            background: var(--bg); border: 1px solid var(--line);
            border-radius: var(--r); box-shadow: var(--shadow-lg);
            min-width: 130px; display: none; overflow: hidden;
        }
        .rev-dropdown.show { display: block; animation: cardIn 0.2s ease; }
        .rev-drop-item {
            width: 100%; text-align: left; padding: 12px 16px;
            font-size: 0.85rem; font-weight: 500; color: var(--ink2);
            background: none; cursor: pointer; transition: 0.2s;
        }
        .rev-drop-item:hover { background: var(--bg2); }
        .rev-drop-item.del { color: var(--red); }

        /* ── NOTIFICATION BELL UI ── */
        .nav-notif {
            position: relative;
            cursor: pointer;
            margin-right: 18px;
            display: flex;
            align-items: center;
        }
        .notif-icon { font-size: 1.5rem; transition: transform 0.2s; }
        .nav-notif:hover .notif-icon { transform: scale(1.1); }

        /* The Red Number Badge */
        .notif-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: var(--red);
            color: white;
            font-size: 0.65rem;
            padding: 2px 6px;
            border-radius: 10px;
            font-weight: bold;
            border: 2px solid var(--bg);
            display: none; /* Hidden by default until we have data */
        }

        /* ── NOTIFICATION PANEL DESIGN ── */
        .notif-panel {
            position: absolute;
            top: 120%; /* Sits exactly below the icon */
            right: 0;
            width: 320px;
            background: var(--bg);
            border: 1px solid var(--line);
            border-radius: var(--r2);
            box-shadow: var(--shadow-xl);
            display: none; /* Hidden until clicked */
            z-index: 2000;
            overflow: hidden;
            animation: slideIn .2s ease-out;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .notif-header {
            padding: 16px;
            border-bottom: 1px solid var(--line);
            font-weight: 700;
            font-size: 0.95rem;
            color: var(--ink);
            background: var(--bg2);
        }

        #notif-list {
            max-height: 350px;
            overflow-y: auto;
        }

        /* Scrollbar Styling */
        #notif-list::-webkit-scrollbar { width: 4px; }
        #notif-list::-webkit-scrollbar-thumb { background: var(--line); border-radius: 10px; }

        .notif-footer {
            padding: 12px;
            text-align: center;
            font-size: 0.8rem;
            color: var(--accent);
            background: var(--bg2);
            border-top: 1px solid var(--line);
            cursor: default;
        }

        .search-message {
            padding: 10px;
            border-radius: 5px;
            font-weight: 500;
            margin-bottom: 15px;
            text-align: center;
        }

        /* ╔══════════════════════════════════════════════════════╗
           ║  PREMIUM DARK MODE — BROWSE / LISTINGS PAGE         ║
           ║  Deep space palette · Glassmorphism · Glow effects  ║
           ╚══════════════════════════════════════════════════════╝ */

        /* ── Listings layout background ── */
        [data-theme="dark"] #page-listings {
            background: radial-gradient(ellipse at 30% 0%, rgba(157, 142, 238, 0.07) 0%, transparent 60%),
            radial-gradient(ellipse at 80% 80%, rgba(45,212,168,.05) 0%, transparent 55%),
            var(--bg);
        }

        /* ── Sidebar: frosted glass panel ── */
        [data-theme="dark"] .listings-sidebar {
            background: linear-gradient(180deg, rgba(26, 26, 46, 0.97) 0%, rgba(26, 26, 46, 0.97) 100%);
            border-right: 1px solid transparent;
            box-shadow:
                    4px 0 32px rgba(0,0,0,.55),
                    inset -1px 0 0 rgba(157, 142, 238, 0.12),
                    1px 0 0 rgba(157, 142, 238, 0.06);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
        }

        /* Sidebar scrollbar */
        [data-theme="dark"] .listings-sidebar::-webkit-scrollbar { width: 4px; }
        [data-theme="dark"] .listings-sidebar::-webkit-scrollbar-track { background: transparent; }
        [data-theme="dark"] .listings-sidebar::-webkit-scrollbar-thumb {
            background: rgba(157, 142, 238, 0.25);
            border-radius: 99px;
        }

        /* ── Filter section headers ── */
        [data-theme="dark"] .filter-section-title {
            color: rgba(160,180,255,.65);
            font-weight: 700;
            letter-spacing: 1.4px;
            text-shadow: 0 0 12px rgba(157, 142, 238, 0.2);
        }

        /* ── Price range dropdown ── */
        [data-theme="dark"] .price-range-select {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.95) 0%, rgba(26, 26, 46, 0.95) 100%);
            border-color: rgba(157, 142, 238, 0.18);
            color: var(--ink2);
            box-shadow: 0 2px 12px rgba(0,0,0,.35), inset 0 1px 0 rgba(255,255,255,.04);
            transition: all .22s ease;
        }
        [data-theme="dark"] .price-range-select:hover {
            border-color: rgba(157, 142, 238, 0.35);
        }
        [data-theme="dark"] .price-range-select:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(157, 142, 238, 0.22), 0 2px 12px rgba(0,0,0,.35);
            background: rgba(26, 26, 46, 1);
        }
        [data-theme="dark"] .price-range-select option {
            background: #0d1225;
            color: var(--ink2);
        }

        /* ── Filter chips ── */
        [data-theme="dark"] .filter-chip {
            background: rgba(42, 42, 74, 0.8);
            border-color: rgba(157, 142, 238, 0.12);
            color: rgba(200,212,255,.65);
            transition: all .2s ease;
        }
        [data-theme="dark"] .filter-chip:hover {
            background: rgba(58, 58, 106, 0.9);
            border-color: rgba(157, 142, 238, 0.28);
            color: rgba(220,230,255,.9);
            box-shadow: 0 2px 10px rgba(0,0,0,.3);
        }
        [data-theme="dark"] .filter-chip.active {
            background: rgba(157, 142, 238, 0.18);
            border-color: rgba(157, 142, 238, 0.55);
            color: #a8c8ff;
            box-shadow:
                    0 0 12px rgba(157, 142, 238, 0.25),
                    0 2px 8px rgba(0,0,0,.3),
                    inset 0 1px 0 rgba(255,255,255,.06);
            text-shadow: 0 0 8px rgba(157, 142, 238, 0.5);
        }

        /* ── Bedroom buttons ── */
        [data-theme="dark"] .bed-btn {
            background: rgba(42, 42, 74, 0.8);
            border-color: rgba(157, 142, 238, 0.12);
            color: rgba(200,212,255,.6);
            transition: all .2s ease;
        }
        [data-theme="dark"] .bed-btn:hover {
            background: rgba(58, 58, 106, 0.9);
            border-color: rgba(157, 142, 238, 0.28);
            color: rgba(220,230,255,.9);
            box-shadow: 0 2px 10px rgba(0,0,0,.3);
        }
        [data-theme="dark"] .bed-btn.active {
            background: rgba(157, 142, 238, 0.18);
            border-color: rgba(157, 142, 238, 0.55);
            color: #a8c8ff;
            box-shadow:
                    0 0 12px rgba(157, 142, 238, 0.25),
                    0 2px 8px rgba(0,0,0,.3),
                    inset 0 1px 0 rgba(255,255,255,.06);
        }

        /* ── Apply filter button ── */
        [data-theme="dark"] .apply-filter-btn {
            background: linear-gradient(135deg, #9d8eee 0%, #8b7cdc 100%);
            box-shadow:
                    0 4px 16px rgba(157, 142, 238, 0.4),
                    0 1px 0 rgba(255,255,255,.08) inset;
            color: #fff;
            letter-spacing: .3px;
        }
        [data-theme="dark"] .apply-filter-btn:hover {
            background: linear-gradient(135deg, #a89aff 0%, #9d8eee 100%);
            box-shadow:
                    0 8px 24px rgba(157, 142, 238, 0.55),
                    0 1px 0 rgba(255,255,255,.1) inset;
            transform: translateY(-2px);
        }
        [data-theme="dark"] .apply-filter-btn:active { transform: translateY(0); }

        /* ── Clear / reset button ── */
        [data-theme="dark"] .clear-filter-btn {
            background: transparent;
            border-color: rgba(157, 142, 238, 0.14);
            color: rgba(160,180,255,.55);
        }
        [data-theme="dark"] .clear-filter-btn:hover {
            border-color: rgba(157, 142, 238, 0.35);
            color: rgba(200,220,255,.85);
            background: rgba(157, 142, 238, 0.06);
        }

        /* ── Main area background ── */
        [data-theme="dark"] .listings-main {
            background: transparent;
        }

        /* ── Top bar: sort select ── */
        [data-theme="dark"] .sort-select {
            background: linear-gradient(135deg, rgba(26, 26, 46, 0.95) 0%, rgba(26, 26, 46, 0.95) 100%);
            border-color: rgba(157, 142, 238, 0.18);
            color: var(--ink2);
            box-shadow: 0 2px 12px rgba(0,0,0,.35), inset 0 1px 0 rgba(255,255,255,.04);
        }
        [data-theme="dark"] .sort-select:hover { border-color: rgba(157, 142, 238, 0.35); }
        [data-theme="dark"] .sort-select:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(157, 142, 238, 0.2);
        }

        /* ── View toggle buttons ── */
        [data-theme="dark"] .view-btn {
            background: rgba(42, 42, 74, 0.8);
            border-color: rgba(157, 142, 238, 0.12);
            color: rgba(160,180,255,.6);
        }
        [data-theme="dark"] .view-btn:hover {
            background: rgba(58, 58, 106, 0.9);
            border-color: rgba(157, 142, 238, 0.3);
            color: rgba(200,220,255,.9);
        }
        [data-theme="dark"] .view-btn.active {
            background: rgba(157, 142, 238, 0.18);
            border-color: rgba(157, 142, 238, 0.5);
            color: #a8c8ff;
            box-shadow: 0 0 10px rgba(157, 142, 238, 0.22);
        }

        /* ── Listings count ── */
        [data-theme="dark"] .listings-count {
            color: rgba(160,180,255,.5);
        }
        [data-theme="dark"] .listings-count strong {
            color: rgba(220,230,255,.9);
            font-weight: 700;
        }

        /* ── Load more button ── */
        [data-theme="dark"] .load-more-btn {
            border-color: rgba(157, 142, 238, 0.2);
            color: rgba(160,180,255,.65);
            background: rgba(26, 26, 46, 0.5);
            backdrop-filter: blur(8px);
        }
        [data-theme="dark"] .load-more-btn:hover {
            border-color: rgba(157, 142, 238, 0.55);
            color: #a8c8ff;
            background: rgba(157, 142, 238, 0.1);
            box-shadow: 0 0 16px rgba(157, 142, 238, 0.2), 0 4px 12px rgba(0,0,0,.3);
            transform: translateY(-1px);
        }

        /* ─── PROPERTY CARDS — ALL VARIANTS ─── */

        /* Shared dark card base */
        [data-theme="dark"] .prop-card,
        [data-theme="dark"] .prop-card--list,
        [data-theme="dark"] .prop-card--compact,
        [data-theme="dark"] .prop-card--magazine,
        [data-theme="dark"] .prop-card--minimal,
        [data-theme="dark"] .prop-card--polaroid {
            background: linear-gradient(145deg, rgba(26, 26, 46, 0.97) 0%, rgba(26, 26, 46, 0.97) 100%);
            border-color: rgba(157, 142, 238, 0.1);
            box-shadow:
                    0 4px 20px rgba(0,0,0,.5),
                    0 1px 0 rgba(255,255,255,.03),
                    inset 0 1px 0 rgba(255,255,255,.025);
        }

        /* Hover glow — standard cards */
        [data-theme="dark"] .prop-card:hover,
        [data-theme="dark"] .prop-card--list:hover,
        [data-theme="dark"] .prop-card--compact:hover,
        [data-theme="dark"] .prop-card--magazine:hover,
        [data-theme="dark"] .prop-card--polaroid:hover {
            border-color: rgba(157, 142, 238, 0.3);
            box-shadow:
                    0 20px 60px rgba(0,0,0,.65),
                    0 0 0 1px rgba(157, 142, 238, 0.2),
                    0 0 30px rgba(157, 142, 238, 0.12),
                    inset 0 1px 0 rgba(255,255,255,.05);
        }

        /* Minimal card special hover (accent border) */
        [data-theme="dark"] .prop-card--minimal:hover {
            border-color: rgba(157, 142, 238, 0.55);
            box-shadow:
                    0 0 0 3px rgba(157, 142, 238, 0.18),
                    0 0 20px rgba(157, 142, 238, 0.15),
                    0 8px 24px rgba(0,0,0,.45);
        }

        /* List card specifics */
        [data-theme="dark"] .plc-right {
            border-left-color: rgba(157, 142, 238, 0.1);
        }
        [data-theme="dark"] .plc-type {
            background: rgba(157, 142, 238, 0.15);
            color: #7ab4ff;
        }

        /* Magazine badge */
        [data-theme="dark"] .pcm-badge {
            background: rgba(8,10,22,.8);
            backdrop-filter: blur(12px);
            color: rgba(220,230,255,.9);
            border: 1px solid rgba(157, 142, 238, 0.18);
        }
        [data-theme="dark"] .pcm-footer {
            border-top-color: rgba(157, 142, 238, 0.1);
        }
        [data-theme="dark"] .pcm-category { color: #7ab4ff; }

        /* Minimal tag pills */
        [data-theme="dark"] .pcn-tag {
            background: rgba(42, 42, 74, 0.9);
            color: rgba(160,180,255,.6);
            border-color: rgba(157, 142, 238, 0.15);
        }

        /* Compact card price cell */
        [data-theme="dark"] .pcc-price {
            border-left-color: rgba(157, 142, 238, 0.1);
            color: #7ab4ff;
        }

        /* ── Save/heart buttons ── */
        [data-theme="dark"] .prop-save {
            background: rgba(8,10,22,.65);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(157, 142, 238, 0.15);
            color: rgba(200,215,255,.6);
        }
        [data-theme="dark"] .prop-save:hover,
        [data-theme="dark"] .prop-save.saved {
            color: var(--red);
            background: rgba(248,113,113,.12);
            border-color: rgba(248,113,113,.3);
            box-shadow: 0 0 12px rgba(248,113,113,.2);
        }
        [data-theme="dark"] .heart-btn {
            background: rgba(8,10,22,.6);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(157, 142, 238, 0.15);
            color: rgba(200,215,255,.5);
            box-shadow: 0 2px 10px rgba(0,0,0,.4);
        }
        [data-theme="dark"] .heart-btn:hover { color: var(--red); box-shadow: 0 0 12px rgba(248,113,113,.2); }
        [data-theme="dark"] .heart-btn--saved {
            color: var(--red);
            box-shadow: 0 0 10px rgba(248,113,113,.25);
        }

        /* ── Property tag badges ── */
        [data-theme="dark"] .tag-sale {
            background: rgba(20, 210, 160, 0.92);
            color: #002f23;
            box-shadow: 0 2px 10px rgba(45,212,168,.35);
        }
        [data-theme="dark"] .tag-rent {
            background: rgba(157, 142, 238, 0.92);
            color: #fff;
            box-shadow: 0 2px 10px rgba(157, 142, 238, 0.35);
        }
        [data-theme="dark"] .tag-sold {
            background: rgba(248,80,80,.92);
            color: #fff;
            box-shadow: 0 2px 10px rgba(248,113,113,.35);
        }
    </style>
</head>
<body>

<nav class="navbar" id="navbar">
    <div class="nav-logo" onclick="showPage('home')" style="cursor:pointer">
        <span class="dot"></span><span class="nav-logo-text">NESTIQ</span>
    </div>
    <ul class="nav-links">
        <li><a href="#" onclick="showPage('home')" id="nav-home" class="active">Home</a></li>
        <li><a href="#" onclick="showPage('listings')" id="nav-listings">Browse</a></li>
        <li><a href="#" onclick="showPage('agents')" id="nav-agents">Agents</a></li>
        <li><a href="#" onclick="showPage('about')" id="nav-about">About</a></li>
    </ul>

    <div class="nav-actions">

        <div class="theme-switch" onclick="toggleTheme()" title="Toggle Dark Mode">
            <div class="theme-switch-thumb" id="theme-toggle">🌙</div>
        </div>

        <c:if test="${sessionScope.loggedRole == 'BUYER' || sessionScope.loggedRole == 'SELLER'}">
            <div class="nav-notif" id="bell-container" onclick="toggleNotif(event)">
                <span class="notif-icon">🔔</span>
                <div id="notif-count" class="notif-badge">0</div>

                <div class="notif-panel" id="notif-panel">
                    <div class="notif-header">Notifications</div>

                    <div id="notif-list">
                        <p style="padding: 20px; text-align: center; color: var(--ink4); font-size: 0.85rem;">
                            No new messages
                        </p>
                    </div>

                    <div class="notif-footer">Nestiq Secure Messaging</div>
                </div>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty sessionScope.loggedUser}">
                <div style="display: flex; align-items: center; gap: 15px;">

                    <c:choose>
                        <%-- 1. IF SELLER IS LOGGED IN --%>
                        <c:when test="${sessionScope.loggedRole == 'SELLER'}">
                            <a href="sellerDashboard" class="nav-user-btn">
                                <div style="background: var(--bg2); border-radius: 50%; padding: 4px; font-size: 1.1rem; display: flex; align-items: center; justify-content: center;">💼</div>
                                <span style="font-weight: 600; color: var(--ink); font-size: 0.95rem;">${sessionScope.loggedUser}</span>
                                <span class="seller-badge-premium">SELLER</span>
                            </a>
                        </c:when>

                        <%-- 2. DEFAULT: BUYER IS LOGGED IN --%>
                        <c:otherwise>
                            <a href="buyerDashboard" class="nav-user-btn">
                                <div style="background: var(--bg2); border-radius: 50%; padding: 4px; font-size: 1.1rem; display: flex; align-items: center; justify-content: center;">👤</div>
                                <span style="font-weight: 600; color: var(--ink); font-size: 0.95rem;">${sessionScope.loggedUser}</span>
                                <span class="buyer-badge-premium">BUYER</span>
                            </a>
                        </c:otherwise>
                    </c:choose>

                    <form action="logout" method="post" style="margin: 0;">
                        <button type="submit" style="background: transparent; border: 1px solid var(--line); color: var(--ink); padding: 6px 16px; border-radius: 20px; font-weight: 500; cursor: pointer; transition: 0.2s;" onmouseover="this.style.borderColor='var(--red)'; this.style.color='var(--red)'" onmouseout="this.style.borderColor='var(--line)'; this.style.color='var(--ink)'">Logout</button>
                    </form>
                </div>
            </c:when>

            <c:otherwise>
                <button class="btn-ghost" onclick="showPage('login')">Sign In</button>
                <button class="btn-primary" onclick="showPage('register')">
                    <svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2" style="width:14px; height:14px;"><path d="M8 2v12M2 8h12"/></svg>
                    List Property
                </button>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<div class="page active" id="page-home">

    <section class="hero">
        <div class="hero-left">
            <div class="hero-eyebrow">
                <svg width="10" height="10" viewBox="0 0 10 10" fill="currentColor"><circle cx="5" cy="5" r="5"/></svg>
                Trusted by 50,000+ home buyers
            </div>
            <h1 class="hero-title">Find Your Perfect<br/><em>Place to Call Home</em></h1>
            <p class="hero-sub">Discover thousands of verified properties across the country. Buy, rent, or sell — we make every step effortless.</p>

            <div id="search-message-container"></div>
            <form action="search" method="get" class="hero-search-form">
                <div class="hero-search-field">
                    <label style="font-weight: 600;">Location</label>
                    <input type="text" name="location" placeholder="e.g. Colombo, Kandy"
                           style="background: var(--bg); border: 1px solid var(--line); padding: 10px; border-radius: 4px; color: var(--ink);">
                </div>

                <div class="hero-search-field" style="max-width: 150px;">
                    <label style="font-weight: 600;">Type</label>
                    <select name="type" style="background: var(--bg); border: 1px solid var(--line); padding: 10px; border-radius: 4px; color: var(--ink);">
                        <option value="">Any Type</option>
                        <option value="Apartment">Apartment</option>
                        <option value="House">House</option>
                        <option value="Villa">Villa</option>
                    </select>
                </div>

                <button type="submit" class="btn-primary" style="height: 44px; padding: 0 30px; font-weight: bold;">Search</button>
            </form>

            <div class="hero-stats">
                <div class="hstat">
                    <div class="hstat-num counter-anim" data-target="12400" id="stat0">0</div>
                    <div class="hstat-label">Active Listings</div>
                </div>
                <div class="hstat-divider"></div>
                <div class="hstat">
                    <div class="hstat-num counter-anim" data-target="340" id="stat1">0</div>
                    <div class="hstat-label">Expert Agents</div>
                </div>
                <div class="hstat-divider"></div>
                <div class="hstat">
                    <div class="hstat-num counter-anim" data-target="98" id="stat2">0</div>
                    <div class="hstat-label">% Client Satisfaction</div>
                </div>
            </div>
        </div>

        <div class="hero-right">
            <img src="https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1200&q=85" class="hero-main-img" alt="hero"/>
            <div class="hero-img-overlay"></div>

            <!-- Floating Card 1: Latest Listing -->
            <div class="hero-card-float hcf-1">
                <div class="hcf-label">Latest Listing</div>
                <div class="hcf-value" id="latest-title" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 180px;">Loading...</div>
                <div class="hcf-sub" id="latest-loc">Loading...</div>

                <div style="display: flex; align-items: center; gap: 8px; margin-top: 6px;">
                    <span class="hcf-badge badge-green" style="margin-top: 0;">✓ Just Listed</span>

                    <div id="latest-btn" style="background: var(--accent); color: white; width: 22px; height: 22px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; font-size: 0.8rem; box-shadow: 0 2px 5px rgba(26,86,219,.3); transition: transform 0.2s;" onmouseover="this.style.transform='scale(1.1)'" onmouseout="this.style.transform='scale(1)'" title="View Property">
                        ➔
                    </div>
                </div>
            </div>

            <!-- Floating Card 2: Market Stats (live from sold_properties.txt) -->
            <div class="hero-card-float hcf-2">
                <div class="hcf-label">This Week</div>
                <div class="hcf-value" style="font-size:1.4rem;font-family:var(--font-serif)">
                    <c:choose>
                        <c:when test="${not empty weekAvgPrice}">${weekAvgPrice}</c:when>
                        <c:otherwise>LKR —</c:otherwise>
                    </c:choose>
                </div>
                <div class="hcf-sub">Avg. Sale Price</div>
                <c:choose>
                    <c:when test="${weekIsUp}">
                        <span class="hcf-badge badge-amber">${weekChangeBadge}</span>
                    </c:when>
                    <c:when test="${not weekHasSales}">
                        <span class="hcf-badge" style="background:#f1f5f9;color:#64748b;">${weekChangeBadge}</span>
                    </c:when>
                    <c:otherwise>
                        <span class="hcf-badge" style="background:#fee2e2;color:#dc2626;">${weekChangeBadge}</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Floating Card 3: Recently Sold -->
            <div class="hero-card-float hcf-3" id="just-sold-card">
                <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:2px;">
                    <div class="hcf-label" style="margin:0;">Just Sold</div>
                    <span class="hcf-badge badge-red" style="margin:0;font-size:.65rem;">🔴 SOLD</span>
                </div>
                <div class="hcf-sold-row">
                    <img class="hcf-sold-thumb" id="sold-thumb" src="" alt="sold property"/>
                    <div class="hcf-sold-info">
                        <div class="hcf-sold-name" id="sold-title">—</div>
                        <div class="hcf-sold-loc"  id="sold-loc">—</div>
                        <div class="hcf-sold-price" id="sold-price">—</div>
                    </div>
                    <div class="hcf-sold-btn" id="sold-btn" title="View this property" onclick="">➔</div>
                </div>
            </div>

        </div>
    </section>

    <section class="section" style="background:var(--bg)">
        <div class="container">
            <div style="display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:36px;flex-wrap:wrap;gap:16px">
                <div>
                    <div class="section-tag">Hand-Picked</div>
                    <h2 class="section-title">Featured Properties</h2>
                    <p style="color: var(--ink3); font-size: 0.95rem; margin-top: 8px; max-width: 500px; line-height: 1.6;">Explore our curated selection of premium properties, verified for quality and value.</p>

                    <c:if test="${not empty searchMessage}">
                        <p style="color: var(--accent); font-weight: 600; margin-bottom: 20px;">${searchMessage}</p>
                    </c:if>

                </div>
                <button class="btn-ghost" onclick="showPage('listings')">View all listings →</button>
            </div>
            <div class="filter-bar">
                <button class="filter-btn active" onclick="filterHome(this,'all')">All</button>
                <button class="filter-btn" onclick="filterHome(this,'sale')">For Sale</button>
                <button class="filter-btn" onclick="filterHome(this,'rent')">For Rent</button>
                <button class="filter-btn" onclick="filterHome(this,'apartment')">Apartment</button>
                <button class="filter-btn" onclick="filterHome(this,'house')">House</button>
                <button class="filter-btn" onclick="filterHome(this,'villa')">Villa</button>
            </div>
            <div class="prop-grid" id="home-prop-grid">
                <c:choose>
                    <c:when test="${not empty propertyList}">
                        <c:forEach var="p" items="${propertyList}">
                            <%-- Use displayStatusMap for display: For Rent + active booking = Sold --%>
                            <c:set var="displayStatus" value="${displayStatusMap[p.id]}"/>
                            <%-- Check if this is a booked rental (has active booking end date) --%>
                            <c:set var="isBookedRental" value="${not empty propertyBookingEndDates[p.id]}"/>
                            <div class="prop-card${displayStatus == 'Sold' ? ' prop-card--sold' : ''}" onclick="openDetail('${p.id}')" style="cursor: pointer;" title="View details for ${p.title}">
                                <div class="prop-img-wrap">
                                    <img src="${p.imageUrl}" alt="${p.title}" loading="lazy"/>
                                    <div class="prop-tags">
                                        <c:choose>
                                            <c:when test="${isBookedRental}">
                                                <span class="prop-tag" style="background:rgba(16,185,129,0.15);color:#10b981;border:1px solid rgba(16,185,129,0.3);">Booked</span>
                                            </c:when>
                                            <c:when test="${displayStatus == 'Sold'}">
                                                <span class="prop-tag tag-sold">Sold</span>
                                            </c:when>
                                            <c:when test="${displayStatus == 'For Rent'}">
                                                <span class="prop-tag tag-rent">${displayStatus}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="prop-tag tag-sale">${displayStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <c:if test="${displayStatus == 'Sold'}">
                                        <div class="sold-img-overlay${isBookedRental ? ' booked-overlay' : ''}">
                                            <c:choose>
                                                <c:when test="${isBookedRental}">
                                                    <div class="sold-title">BOOKED</div>
                                                    <div class="sold-message">This property has been booked until <strong style="color:#fff;font-size:1.1rem;">${propertyBookingEndDates[p.id]}</strong></div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="sold-title">SOLD</div>
                                                    <div class="sold-message">This property has been sold and is no longer available</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="prop-body">
                                    <c:if test="${isBookedRental}"><span class="sold-tape" style="background:rgba(16,185,129,0.15);color:#10b981;border-bottom:2px solid #10b981;"> ✅ Booked</span></c:if>
                                    <c:if test="${displayStatus == 'Sold' and not isBookedRental}"><span class="sold-tape">  Sold</span></c:if>
                                    <div class="prop-price">LKR <fmt:formatNumber value="${p.price}" pattern="#,##0.00" /><c:if test="${p.status.trim() == 'For Rent'}"><span style="font-size:0.58em;font-weight:400;color:var(--ink3)">/day</span></c:if></div>
                                    <div class="prop-name">${p.title}</div>
                                    <div class="prop-loc">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                            ${p.location}
                                    </div>
                                    <div class="prop-divider"></div>
                                    <div class="prop-meta">
                                        <div class="prop-meta-item">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 10V4h-5"/><path d="M15 10l-6 6-4-4"/></svg>
                                                ${p.bedrooms} Beds
                                        </div>
                                        <div class="prop-meta-item">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M19 10V4h-5"/><path d="M15 10l-6 6-4-4"/></svg>
                                                ${p.bathrooms} Baths
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px;">
                            <div style="font-size: 4rem; margin-bottom: 16px;">🏠</div>
                            <div style="font-weight: 600; font-size: 1.1rem; color: var(--ink); margin-bottom: 8px;">No Properties Available</div>
                            <div style="color: var(--ink3); font-size: 0.95rem; max-width: 400px; margin: 0 auto;">We're currently updating our listings. Please check back soon or contact us for assistance!</div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

    <section class="why-section">
        <div class="container">
            <div style="text-align:center;margin-bottom:56px">
                <div class="section-tag" style="justify-content:center;color:rgba(255,255,255,.5)">
                    <span style="background:rgba(255,255,255,.2)"></span>
                    Why Choose Nestiq
                </div>
                <h2 class="section-title" style="color:white;margin-top:8px">A Smarter Way<br/>to Find Home</h2>
            </div>
            <div class="why-grid">
                <div class="why-card">
                    <div class="why-icon">🛡️</div>
                    <div class="why-title">Verified Listings Only</div>
                    <div class="why-desc">Every property is manually reviewed and verified by our team. No fakes, no surprises.</div>
                </div>
                <div class="why-card">
                    <div class="why-icon">⚡</div>
                    <div class="why-title">Lightning Fast Search</div>
                    <div class="why-desc">Advanced filters help you narrow down thousands of listings in seconds, not hours.</div>
                </div>
                <div class="why-card">
                    <div class="why-icon">🤝</div>
                    <div class="why-title">Expert Agents On-Call</div>
                    <div class="why-desc">Connect directly with licensed local agents who know your market inside-out.</div>
                </div>
                <div class="why-card">
                    <div class="why-icon">📊</div>
                    <div class="why-title">Real Market Data</div>
                    <div class="why-desc">Live price trends, neighbourhood analytics, and investment insights at your fingertips.</div>
                </div>
                <div class="why-card">
                    <div class="why-icon">💬</div>
                    <div class="why-title">24/7 Support</div>
                    <div class="why-desc">Our team is always available via chat, email, or phone — even on weekends.</div>
                </div>
                <div class="why-card">
                    <div class="why-icon">🔒</div>
                    <div class="why-title">Secure Transactions</div>
                    <div class="why-desc">Your data and deals are protected with bank-grade encryption at every step.</div>
                </div>
            </div>
        </div>
    </section>

    <section class="section" style="background:var(--bg2)">
        <div class="container">
            <div style="text-align:center;margin-bottom:48px">
                <div class="section-tag" style="justify-content:center">Client Stories</div>
                <h2 class="section-title mt-8">Loved by Thousands</h2>
            </div>
            <div class="testi-grid" id="testi-grid"></div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <div style="display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:40px;flex-wrap:wrap;gap:16px">
                <div>
                    <div class="section-tag">Our Team</div>
                    <h2 class="section-title">Top Agents</h2>
                    <p class="section-sub">Work with the best in the business.</p>
                </div>
                <button class="btn-ghost" onclick="showPage('agents')">Meet all agents →</button>
            </div>
            <div class="prop-grid" id="home-agents-grid"></div>
        </div>
    </section>

    <!-- Call-to-Action for Unsigned Users -->
    <c:if test="${empty sessionScope.loggedUser}">
        <section class="section" style="background: linear-gradient(135deg, var(--accent) 0%, var(--accent2) 100%); padding: 80px 40px; position: relative; overflow: hidden;">
            <!-- Decorative Background Elements -->
            <div style="position: absolute; top: -50%; right: -10%; width: 600px; height: 600px; background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%); border-radius: 50%;"></div>
            <div style="position: absolute; bottom: -30%; left: -5%; width: 400px; height: 400px; background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 70%); border-radius: 50%;"></div>

            <div class="container" style="position: relative; z-index: 1;">
                <div style="text-align: center; max-width: 700px; margin: 0 auto;">
                    <div style="font-size: 3rem; margin-bottom: 20px; filter: drop-shadow(0 4px 12px rgba(0,0,0,0.2));">🏠✨</div>
                    <h2 style="font-family: var(--font-serif); font-size: 2.4rem; color: white; margin-bottom: 16px; line-height: 1.2; text-shadow: 0 2px 8px rgba(0,0,0,0.15);">Ready to Find Your Dream Home?</h2>
                    <p style="color: rgba(255,255,255,0.95); font-size: 1.05rem; line-height: 1.7; margin-bottom: 36px; text-shadow: 0 1px 4px rgba(0,0,0,0.1);">
                        Join thousands of satisfied buyers and sellers. Create your free account to save properties, get personalized recommendations, and connect with top agents.
                    </p>
                    <div style="display: flex; gap: 16px; justify-content: center; flex-wrap: wrap;">
                        <button onclick="showPage('register')" style="background: white; color: var(--accent); padding: 14px 32px; border-radius: var(--r); font-weight: 700; font-size: 0.95rem; border: none; cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 16px rgba(0,0,0,0.2), 0 0 0 1px rgba(255,255,255,0.3) inset;" onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 24px rgba(0,0,0,0.3), 0 0 0 1px rgba(255,255,255,0.4) inset'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 16px rgba(0,0,0,0.2), 0 0 0 1px rgba(255,255,255,0.3) inset'">
                            Get Started Free →
                        </button>
                        <button onclick="showPage('login')" style="background: rgba(255,255,255,0.15); color: white; padding: 14px 32px; border-radius: var(--r); font-weight: 600; font-size: 0.95rem; border: 2px solid rgba(255,255,255,0.5); cursor: pointer; transition: all 0.2s; backdrop-filter: blur(10px);" onmouseover="this.style.borderColor='white'; this.style.background='rgba(255,255,255,0.25)'" onmouseout="this.style.borderColor='rgba(255,255,255,0.5)'; this.style.background='rgba(255,255,255,0.15)'">
                            Sign In
                        </button>
                    </div>
                    <div style="margin-top: 32px; display: flex; gap: 32px; justify-content: center; flex-wrap: wrap;">
                        <div style="color: rgba(255,255,255,0.9); font-size: 0.85rem; display: flex; align-items: center; gap: 6px; text-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                            <span style="font-size: 1.1rem; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.15));">✓</span> Save Favorites
                        </div>
                        <div style="color: rgba(255,255,255,0.9); font-size: 0.85rem; display: flex; align-items: center; gap: 6px; text-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                            <span style="font-size: 1.1rem; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.15));">✓</span> Price Alerts
                        </div>
                        <div style="color: rgba(255,255,255,0.9); font-size: 0.85rem; display: flex; align-items: center; gap: 6px; text-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                            <span style="font-size: 1.1rem; filter: drop-shadow(0 2px 4px rgba(0,0,0,0.15));">✓</span> Direct Messaging
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </c:if>

    <footer class="footer">
        <div class="container">
            <div class="footer-top">
                <div>
                    <div class="footer-logo"><span class="dot" style="background:var(--accent)"></span>NESTIQ</div>
                    <p class="footer-desc">Your trusted partner for finding, buying, and selling exceptional properties across the country.</p>
                    <div class="footer-socials">
                        <div class="social-btn">𝕏</div>
                        <div class="social-btn">in</div>
                        <div class="social-btn">f</div>
                        <div class="social-btn">▶</div>
                    </div>
                </div>
                <div>
                    <div class="footer-col-title">Quick Links</div>
                    <ul class="footer-links">
                        <li><a href="#" onclick="showPage('home')">Home</a></li>
                        <li><a href="#" onclick="showPage('listings')">Browse</a></li>
                        <li><a href="#" onclick="showPage('agents')">Agents</a></li>
                        <li><a href="#" onclick="showPage('about')">About Us</a></li>
                    </ul>
                </div>
                <div>
                    <div class="footer-col-title">Services</div>
                    <ul class="footer-links">
                        <li><a href="#" onclick="showPage('listings')">Buy Property</a></li>
                        <li><a href="#" onclick="showPage('listings')">Rent Property</a></li>
                        <li><a href="#">Sell Property</a></li>
                        <li><a href="#">Property Valuation</a></li>
                    </ul>
                </div>
                <div>
                    <div class="footer-col-title">Support</div>
                    <ul class="footer-links">
                        <li><a href="#">Help Center</a></li>
                        <li><a href="#">Contact Us</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Terms of Service</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <span class="footer-copy">© 2024 Nestiq Real Estate. All rights reserved.</span>
                <div class="footer-legal">
                    <a href="#">Privacy</a>
                    <a href="#">Terms</a>
                    <a href="#">Cookies</a>
                </div>
            </div>
        </div>
    </footer>
</div>

<div class="page" id="page-about">
    <!-- Hero Section -->
    <div class="agents-hero">
        <div class="container">
            <div class="section-tag">Our Story</div>
            <h1 class="section-title mt-8">Redefining Real Estate in Sri Lanka</h1>
            <p class="section-sub" style="max-width: 650px;">At NESTIQ, we believe that finding a home is more than just a transaction — it's the start of a new chapter in your life. We're here to make that journey seamless, transparent, and enjoyable.</p>
        </div>
    </div>

    <!-- Mission Section with Visual Layout -->
    <section class="section">
        <div class="container">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 60px; align-items: center;">
                <div>
                    <div class="section-tag">Our Mission</div>
                    <h2 style="font-family: var(--font-serif); font-size: 2.4rem; margin-bottom: 24px; line-height: 1.2;">Building Trust in Every Transaction</h2>
                    <p style="color: var(--ink3); font-size: 1.05rem; line-height: 1.8; margin-bottom: 20px;">
                        Founded in 2020, NESTIQ emerged from a simple observation: the Sri Lankan real estate market was fragmented, opaque, and difficult to navigate. We set out to build a platform that brings transparency, trust, and professional service to every corner of the island.
                    </p>
                    <p style="color: var(--ink3); font-size: 1.05rem; line-height: 1.8; margin-bottom: 24px;">
                        From the bustling streets of Colombo to the serene beaches of Bentota and the misty hills of Kandy, we are committed to helping every Sri Lankan find their perfect place. Our platform combines cutting-edge technology with deep local expertise.
                    </p>

                    <!-- Key Values -->
                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <div style="display: flex; align-items: flex-start; gap: 12px;">
                            <div style="width: 24px; height: 24px; border-radius: 50%; background: var(--green-l); color: var(--green); display: flex; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: 700; flex-shrink: 0; margin-top: 2px;">✓</div>
                            <div>
                                <div style="font-weight: 600; color: var(--ink); margin-bottom: 4px;">Transparency First</div>
                                <div style="font-size: 0.9rem; color: var(--ink3);">Clear pricing, verified listings, no hidden fees</div>
                            </div>
                        </div>
                        <div style="display: flex; align-items: flex-start; gap: 12px;">
                            <div style="width: 24px; height: 24px; border-radius: 50%; background: var(--accent-l); color: var(--accent); display: flex; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: 700; flex-shrink: 0; margin-top: 2px;">✓</div>
                            <div>
                                <div style="font-weight: 600; color: var(--ink); margin-bottom: 4px;">Local Expertise</div>
                                <div style="font-size: 0.9rem; color: var(--ink3);">Deep knowledge of Sri Lankan neighborhoods and markets</div>
                            </div>
                        </div>
                        <div style="display: flex; align-items: flex-start; gap: 12px;">
                            <div style="width: 24px; height: 24px; border-radius: 50%; background: rgba(217,119,6,0.1); color: var(--amber); display: flex; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: 700; flex-shrink: 0; margin-top: 2px;">✓</div>
                            <div>
                                <div style="font-weight: 600; color: var(--ink); margin-bottom: 4px;">Customer Success</div>
                                <div style="font-size: 0.9rem; color: var(--ink3);">Your satisfaction is our ultimate measure of success</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="border-radius: var(--r3); overflow: hidden; box-shadow: var(--shadow-xl); position: relative;">
                    <img src="https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800&q=80" alt="Sri Lankan Property" style="width: 100%; height: 450px; object-fit: cover;">
                    <div style="position: absolute; bottom: 0; left: 0; right: 0; background: linear-gradient(to top, rgba(0,0,0,0.7), transparent); padding: 30px 24px 24px; color: white;">
                        <div style="font-size: 0.85rem; font-weight: 600; opacity: 0.9;">Serving Since 2020</div>
                        <div style="font-size: 1.1rem; font-weight: 700; margin-top: 4px;">4+ Years of Excellence</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- What Makes Us Different - Enhanced Cards -->
    <section class="section" style="background: var(--bg2);">
        <div class="container">
            <div style="text-align: center; max-width: 700px; margin: 0 auto 60px;">
                <div class="section-tag" style="justify-content: center;">Why Choose Us</div>
                <h2 style="font-family: var(--font-serif); font-size: 2.2rem; margin-bottom: 16px;">What Makes Us Different?</h2>
                <p style="color: var(--ink3); font-size: 1.05rem; line-height: 1.7;">We don't just list properties; we verify them. Every agent on our platform is hand-picked for their integrity and track record.</p>
            </div>

            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px;">
                <div class="why-card" style="background: var(--bg); padding: 40px; border-radius: var(--r2); transition: all 0.3s ease;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-xl)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                    <div style="width: 60px; height: 60px; border-radius: 16px; background: var(--green-l); display: flex; align-items: center; justify-content: center; font-size: 2rem; margin-bottom: 24px;">🛡️</div>
                    <h3 style="margin-bottom: 12px; font-size: 1.25rem; font-weight: 700;">100% Verified Listings</h3>
                    <p style="color: var(--ink4); font-size: 0.95rem; line-height: 1.7;">Every property on NESTIQ undergoes a rigorous verification process to ensure accuracy and prevent fraud. No surprises, just trust.</p>
                </div>
                <div class="why-card" style="background: var(--bg); padding: 40px; border-radius: var(--r2); transition: all 0.3s ease;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-xl)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                    <div style="width: 60px; height: 60px; border-radius: 16px; background: var(--accent-l); display: flex; align-items: center; justify-content: center; font-size: 2rem; margin-bottom: 24px;">💎</div>
                    <h3 style="margin-bottom: 12px; font-size: 1.25rem; font-weight: 700;">Exclusive Portfolios</h3>
                    <p style="color: var(--ink4); font-size: 0.95rem; line-height: 1.7;">Access luxury apartments and colonial villas that aren't available anywhere else in the market. Curated for discerning buyers.</p>
                </div>
                <div class="why-card" style="background: var(--bg); padding: 40px; border-radius: var(--r2); transition: all 0.3s ease;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-xl)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                    <div style="width: 60px; height: 60px; border-radius: 16px; background: rgba(217,119,6,0.1); display: flex; align-items: center; justify-content: center; font-size: 2rem; margin-bottom: 24px;">🤝</div>
                    <h3 style="margin-bottom: 12px; font-size: 1.25rem; font-weight: 700;">Expert Guidance</h3>
                    <p style="color: var(--ink4); font-size: 0.95rem; line-height: 1.7;">Our agents aren't just salespeople; they are consultants with decades of experience in the Sri Lankan market, ready to guide you.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section - Enhanced Visual Design -->
    <section class="section">
        <div class="container">
            <div style="text-align: center; max-width: 700px; margin: 0 auto 60px;">
                <div class="section-tag" style="justify-content: center;">Our Impact</div>
                <h2 style="font-family: var(--font-serif); font-size: 2.2rem; margin-bottom: 16px;">Our Presence Across Sri Lanka</h2>
                <p style="color: var(--ink3); font-size: 1.05rem;">From Colombo to Kandy, we're transforming how Sri Lankans buy, sell, and rent properties.</p>
            </div>

            <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 30px; max-width: 1000px; margin: 0 auto;">
                <div style="text-align: center; padding: 32px 20px; background: var(--bg2); border-radius: var(--r2); border: 1px solid var(--line); transition: all 0.3s ease;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                    <div style="font-size: 3rem; margin-bottom: 8px;">🏙️</div>
                    <div style="font-size: 2.5rem; font-weight: 800; color: var(--accent); line-height: 1; margin-bottom: 8px;">25+</div>
                    <div style="color: var(--ink3); font-weight: 600; font-size: 0.95rem;">Cities Covered</div>
                </div>
                <div style="text-align: center; padding: 32px 20px; background: var(--bg2); border-radius: var(--r2); border: 1px solid var(--line); transition: all 0.3s ease;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                    <div style="font-size: 3rem; margin-bottom: 8px;">🏠</div>
                    <div style="font-size: 2.5rem; font-weight: 800; color: var(--green); line-height: 1; margin-bottom: 8px;">5000+</div>
                    <div style="color: var(--ink3); font-weight: 600; font-size: 0.95rem;">Verified Listings</div>
                </div>
                <div style="text-align: center; padding: 32px 20px; background: var(--bg2); border-radius: var(--r2); border: 1px solid var(--line); transition: all 0.3s ease;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                    <div style="font-size: 3rem; margin-bottom: 8px;">👥</div>
                    <div style="font-size: 2.5rem; font-weight: 800; color: var(--accent); line-height: 1; margin-bottom: 8px;">150+</div>
                    <div style="color: var(--ink3); font-weight: 600; font-size: 0.95rem;">Certified Agents</div>
                </div>
                <div style="text-align: center; padding: 32px 20px; background: var(--bg2); border-radius: var(--r2); border: 1px solid var(--line); transition: all 0.3s ease;" onmouseover="this.style.transform='translateY(-4px)'; this.style.boxShadow='var(--shadow-lg)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">
                    <div style="font-size: 3rem; margin-bottom: 8px;">😊</div>
                    <div style="font-size: 2.5rem; font-weight: 800; color: var(--green); line-height: 1; margin-bottom: 8px;">10k+</div>
                    <div style="color: var(--ink3); font-weight: 600; font-size: 0.95rem;">Happy Families</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Team/Culture Section (New) -->
    <section class="section" style="background: var(--bg2);">
        <div class="container">
            <div style="text-align: center; max-width: 700px; margin: 0 auto 60px;">
                <div class="section-tag" style="justify-content: center;">Our Culture</div>
                <h2 style="font-family: var(--font-serif); font-size: 2.2rem; margin-bottom: 16px;">Driven by Passion, Guided by Values</h2>
                <p style="color: var(--ink3); font-size: 1.05rem;">We're not just building a platform; we're building a community of trusted professionals who care about your journey home.</p>
            </div>

            <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 30px; max-width: 900px; margin: 0 auto;">
                <div style="background: var(--bg); padding: 36px; border-radius: var(--r2); border: 1px solid var(--line);">
                    <div style="font-size: 2.5rem; margin-bottom: 16px;">🎯</div>
                    <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 12px;">Our Vision</h3>
                    <p style="color: var(--ink3); line-height: 1.7; font-size: 0.95rem;">To become Sri Lanka's most trusted real estate platform, where every transaction is transparent, efficient, and rewarding for all parties involved.</p>
                </div>
                <div style="background: var(--bg); padding: 36px; border-radius: var(--r2); border: 1px solid var(--line);">
                    <div style="font-size: 2.5rem; margin-bottom: 16px;">💡</div>
                    <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 12px;">Our Innovation</h3>
                    <p style="color: var(--ink3); line-height: 1.7; font-size: 0.95rem;">Leveraging cutting-edge technology to simplify property searches, streamline transactions, and provide data-driven insights for smarter decisions.</p>
                </div>
                <div style="background: var(--bg); padding: 36px; border-radius: var(--r2); border: 1px solid var(--line);">
                    <div style="font-size: 2.5rem; margin-bottom: 16px;">🌟</div>
                    <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 12px;">Our Commitment</h3>
                    <p style="color: var(--ink3); line-height: 1.7; font-size: 0.95rem;">Every team member is dedicated to delivering exceptional service, maintaining integrity, and ensuring your complete satisfaction throughout your property journey.</p>
                </div>
                <div style="background: var(--bg); padding: 36px; border-radius: var(--r2); border: 1px solid var(--line);">
                    <div style="font-size: 2.5rem; margin-bottom: 16px;">🤲</div>
                    <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 12px;">Community First</h3>
                    <p style="color: var(--ink3); line-height: 1.7; font-size: 0.95rem;">We believe in giving back to the communities we serve, supporting local initiatives, and contributing to Sri Lanka's sustainable development.</p>
                </div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <div class="footer-top">
                <div>
                    <div class="footer-logo"><span class="dot" style="background:var(--accent)"></span>NESTIQ</div>
                    <p class="footer-desc">Your trusted partner for finding, buying, and selling exceptional properties across the country.</p>
                    <div class="footer-socials">
                        <div class="social-btn">𝕏</div>
                        <div class="social-btn">in</div>
                        <div class="social-btn">f</div>
                        <div class="social-btn">▶</div>
                    </div>
                </div>
                <div>
                    <div class="footer-col-title">Quick Links</div>
                    <ul class="footer-links">
                        <li><a href="#" onclick="showPage('home')">Home</a></li>
                        <li><a href="#" onclick="showPage('listings')">Browse</a></li>
                        <li><a href="#" onclick="showPage('agents')">Agents</a></li>
                        <li><a href="#" onclick="showPage('about')">About Us</a></li>
                    </ul>
                </div>
                <div>
                    <div class="footer-col-title">Services</div>
                    <ul class="footer-links">
                        <li><a href="#" onclick="showPage('listings')">Buy Property</a></li>
                        <li><a href="#" onclick="showPage('listings')">Rent Property</a></li>
                        <li><a href="#">Sell Property</a></li>
                        <li><a href="#">Property Valuation</a></li>
                    </ul>
                </div>
                <div>
                    <div class="footer-col-title">Support</div>
                    <ul class="footer-links">
                        <li><a href="#">Help Center</a></li>
                        <li><a href="#">Contact Us</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                        <li><a href="#">Terms of Service</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <span class="footer-copy">© 2024 Nestiq Real Estate. All rights reserved.</span>
                <div class="footer-legal">
                    <a href="#">Privacy</a>
                    <a href="#">Terms</a>
                    <a href="#">Cookies</a>
                </div>
            </div>
        </div>
    </footer>
</div>

<div class="page" id="page-listings">
    <div class="listings-layout" style="margin-top:68px">
        <div class="listings-sidebar">
            <div style="font-size:.875rem;font-weight:700;color:var(--ink);margin-bottom:20px;display:flex;align-items:center;justify-content:space-between">
                Filters
                <span style="font-size:.75rem;font-weight:400;color:var(--accent);cursor:pointer" onclick="resetFilters()">Clear all</span>
            </div>

            <div class="filter-section">
                <div class="filter-section-title">Status</div>
                <div class="filter-chips">
                    <div class="filter-chip active" onclick="toggleChip(this,'soldStatus','all')">All</div>
                    <div class="filter-chip" onclick="toggleChip(this,'soldStatus','available')">Available</div>
                    <div class="filter-chip" onclick="toggleChip(this,'soldStatus','booked')">Booked</div>
                    <div class="filter-chip" onclick="toggleChip(this,'soldStatus','sold')">Sold</div>
                </div>
            </div>

            <div class="filter-section">
                <div class="filter-section-title">Listing Type</div>
                <div class="filter-chips">
                    <div class="filter-chip active" onclick="toggleChip(this,'status','all')">All</div>
                    <div class="filter-chip" onclick="toggleChip(this,'status','sale')">For Sale</div>
                    <div class="filter-chip" onclick="toggleChip(this,'status','rent')">For Rent</div>
                </div>
            </div>

            <div class="filter-section">
                <div class="filter-section-title">Property Type</div>
                <div class="filter-chips">
                    <div class="filter-chip active" onclick="toggleChip(this,'type','all')">All</div>
                    <div class="filter-chip" onclick="toggleChip(this,'type','apartment')">Apartment</div>
                    <div class="filter-chip" onclick="toggleChip(this,'type','house')">House</div>
                    <div class="filter-chip" onclick="toggleChip(this,'type','villa')">Villa</div>
                </div>
            </div>

            <div class="filter-section">
                <div class="filter-section-title">Price Range</div>
                <div class="price-dropdown-wrap">
                    <select id="priceRangeSelect" class="price-range-select" onchange="applyPriceRange(this.value)">
                        <option value="all">All Prices</option>
                    </select>
                </div>
            </div>

            <div class="filter-section">
                <div class="filter-section-title">Bedrooms</div>
                <div class="filter-beds">
                    <button class="bed-btn active" onclick="setBeds(this,1)">Any</button>
                    <button class="bed-btn" onclick="setBeds(this,1)">1+</button>
                    <button class="bed-btn" onclick="setBeds(this,2)">2+</button>
                    <button class="bed-btn" onclick="setBeds(this,3)">3+</button>
                    <button class="bed-btn" onclick="setBeds(this,4)">4+</button>
                </div>
            </div>

            <div class="filter-section">
                <div class="filter-section-title">City</div>
                <div class="filter-chips">
                    <div class="filter-chip active" onclick="toggleChip(this,'city','all')">All Cities</div>
                    <c:forEach var="city" items="${cities}">
                        <div class="filter-chip" onclick="toggleChip(this,'city','${city}')">${city}</div>
                    </c:forEach>
                </div>
            </div>

            <button class="apply-filter-btn" onclick="applyFilters()">Apply Filters</button>
            <button class="clear-filter-btn" onclick="resetFilters()">Reset</button>
        </div>

        <div class="listings-main">
            <div class="listings-top-bar">
                <div class="listings-count"><strong id="listings-count">0</strong> properties found</div>
                <div style="display:flex;align-items:center;gap:10px">
                    <select class="sort-select" onchange="sortListings(this.value)">
                        <option value="default">Sort: Featured First</option>
                        <option value="price_asc">Price: Low to High</option>
                        <option value="price_desc">Price: High to Low</option>
                        <option value="newest">Newest First</option>
                        <option value="views">Most Viewed</option>
                    </select>
                    <div class="view-toggle">
                        <div class="view-btn active" title="Grid view" onclick="setViewMode('grid')">⊞</div>
                        <div class="view-btn" title="List view" onclick="setViewMode('list')">☰</div>
                    </div>
                </div>
            </div>
            <div class="prop-grid" id="listings-grid"></div>
            <button class="load-more-btn" id="listings-load-more" onclick="loadMoreListings()">Load More Properties</button>
        </div>
    </div>
</div>

<div class="page" id="page-detail">
    <div class="detail-hero" id="detail-hero">
        <img id="detail-main-img" src="" alt=""/>
        <div class="detail-hero-overlay"></div>
        <button class="detail-back-btn" onclick="showPage('listings')">
            ← Back to listings
        </button>
        <div class="detail-img-count" id="detail-img-count">📷 4 Photos</div>
    </div>

    <div class="container" style="padding:0 40px">
        <div class="detail-thumbs" id="detail-thumbs"></div>
    </div>

    <div class="detail-layout">
        <div class="detail-main">
            <div class="detail-tag-row" id="detail-tags"></div>
            <h1 class="detail-title" id="detail-title"></h1>
            <div class="detail-address" id="detail-address">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="12" r="3"/></svg>
                <span id="detail-address-text"></span>
            </div>

            <div class="detail-price-row" style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid var(--line);">
                <div>
                    <div class="detail-price-sub" id="detail-price-label">Listing Price</div>
                    <div class="detail-price" id="detail-price"></div>
                </div>

                <form action="saveFavorite" method="post" style="margin: 0;">
                    <input type="hidden" name="propertyId" id="fav-property-id">
                    <button type="submit" class="btn" style="background: rgba(13, 158, 110, 0.1); color: var(--green); border: 2px solid var(--green); display: flex; align-items: center; gap: 8px; font-size: 1.1rem; padding: 12px 24px; cursor: pointer; border-radius: 8px; font-weight: bold; transition: 0.3s;" onmouseover="this.style.background='var(--green)'; this.style.color='white'" onmouseout="this.style.background='rgba(13, 158, 110, 0.1)'; this.style.color='var(--green)'">
                        ❤️ Save to Dashboard
                    </button>
                </form>
            </div>

            <div class="detail-specs" id="detail-specs" style="display: flex; flex-wrap: wrap; gap: 15px; margin-bottom: 40px;"></div>

            <div style="background: var(--bg2); padding: 30px; border-radius: var(--r); border: 1px solid var(--line); margin-bottom: 40px;">
                <div class="detail-section-title">💬 Community Feedback</div>
                <div id="reviews-container" style="margin-bottom: 30px;"></div>

                <div style="background: var(--bg2); padding: 25px; border-radius: var(--r); border: 1px solid var(--line);">
                    <div style="font-weight: 600; margin-bottom: 15px; font-size: 1.1rem;">Post a New Review</div>
                    <form action="reviews" method="post" style="display: flex; flex-direction: column; gap: 12px;">
                        <input type="hidden" name="propertyId" id="review-prop-id">
                        <input type="text" name="buyerName" class="contact-form-input" placeholder="Your Name" required>
                        <select name="rating" class="contact-form-input">
                            <option value="5">⭐⭐⭐⭐⭐ (Excellent)</option>
                            <option value="4">⭐⭐⭐⭐ (Good)</option>
                            <option value="3">⭐⭐⭐ (Average)</option>
                        </select>
                        <textarea name="comment" class="contact-form-input" placeholder="Write your feedback..." required></textarea>
                        <button type="submit" class="btn-primary" style="width: 100%;">Submit Feedback</button>
                    </form>
                </div>
                <div class="detail-section-title" style="font-size: 1.4rem; margin-top: 0; margin-bottom: 15px;">📝 About This Property</div>
                <p class="detail-desc" id="detail-desc" style="line-height: 1.8; color: var(--ink); opacity: 0.8; font-size: 1.05rem;"></p>

                <div class="detail-section-title" style="font-size: 1.4rem; margin-top: 40px; margin-bottom: 20px;">✨ Premium Amenities</div>
                <div class="features-grid" id="detail-features" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; color: var(--ink); opacity: 0.8; font-size: 1.05rem;">
                    <!-- Amenities will be dynamically loaded based on property type -->
                </div>
            </div>
        </div>

        <div class="detail-sidebar">
            <div class="sidebar-card">
                <div class="agent-profile" id="detail-agent-profile">
                    <img id="detail-agent-img" src="" alt=""/>
                    <div>
                        <div class="agent-profile-name" id="detail-agent-name"></div>
                        <div class="agent-profile-title" id="detail-agent-title"></div>
                        <div class="agent-stars">★★★★★ <span id="detail-agent-rating"></span></div>
                    </div>
                </div>

                <!-- ── BOOKING FORM (For Rent Properties Only) ── -->
                <form id="booking-form" action="bookProperty" method="post" style="display: none; flex-direction: column; gap: 10px; margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid var(--line);" onsubmit="return validateAndSubmitBooking(event);">
                    <div style="font-weight: 700; margin-bottom: 10px; color: var(--accent); font-size: 1.05rem;">📅 BOOK THIS PROPERTY</div>

                    <input type="hidden" name="propertyId" id="book-prop-id">
                    <input type="hidden" name="propertyTitle" id="book-prop-title">
                    <input type="hidden" name="sellerName" id="book-seller-name">
                    <input type="hidden" name="propertyPrice" id="book-prop-price">

                    <input type="text" name="buyerName" id="book-buyer-name" class="contact-form-input" placeholder="Your Full Name" required style="width: 100%;"/>
                    <input type="email" name="buyerEmail" id="book-buyer-email" class="contact-form-input" placeholder="Email Address" required style="width: 100%;"/>
                    <input type="tel" name="buyerPhone" id="book-buyer-phone" class="contact-form-input" placeholder="Phone Number" style="width: 100%;"/>

                    <div style="display: flex; gap: 10px;">
                        <div style="display: flex; flex-direction: column; gap: 5px; flex: 1;">
                            <label style="font-size: 0.75rem; color: var(--ink4); text-transform: uppercase; letter-spacing: 0.5px; font-weight: 600;">Start Date *</label>
                            <input type="date" name="startDate" id="book-start-date" class="contact-form-input" required style="width: 100%;"/>
                            <small style="color: var(--ink4); font-size: 0.8rem;">When will you start renting?</small>
                        </div>
                        <div style="display: flex; flex-direction: column; gap: 5px; flex: 1;">
                            <label style="font-size: 0.75rem; color: var(--ink4); text-transform: uppercase; letter-spacing: 0.5px; font-weight: 600;">End Date *</label>
                            <input type="date" name="returnDate" id="book-return-date" class="contact-form-input" required style="width: 100%;"/>
                            <small style="color: var(--ink4); font-size: 0.8rem;">When will you return?</small>
                        </div>
                    </div>

                    <button type="submit" class="btn-contact" style="margin-top: 15px; width: 100%; background: var(--green); font-weight: 700;">🔖 Reserve Now</button>
                </form>

                <!-- ── SOLD/RENTED PROPERTY NOTICE (shown for sold or confirmed rental properties) ── -->
                <div id="sold-status-banner" style="display:none; background:rgba(224,40,40,0.09); border:1.5px solid rgba(224,40,40,0.35); border-radius:10px; padding:16px 18px; margin-bottom:14px;">
                    <div style="display:flex; align-items:center; gap:10px; margin-bottom:10px;">
                        <span id="sold-icon" style="font-size:1.35rem;">🔴</span>
                        <span id="sold-title-text" style="font-weight:700; color:#c0392b; font-size:1rem; letter-spacing:.2px;">PROPERTY SOLD</span>
                    </div>
                    <p id="sold-message" style="margin:0 0 12px 0; font-size:0.88rem; color:#c0392b; line-height:1.6;">
                        This property has been sold and is <strong>no longer available</strong> for purchase or booking. Contact details have been disabled.
                    </p>
                    <div style="background:var(--bg2); border:1px solid var(--line); border-radius:8px; padding:12px 14px; display:flex; align-items:center; gap:12px;">
                        <img id="sold-seller-img" src="" alt="" style="width:42px; height:42px; border-radius:50%; object-fit:cover; border:2px solid rgba(224,40,40,0.4);"/>
                        <div>
                            <div style="font-size:0.72rem; color:var(--ink4); text-transform:uppercase; letter-spacing:.6px; font-weight:600; margin-bottom:2px;">Property Owner</div>
                            <div id="sold-seller-name" style="font-weight:700; font-size:0.97rem; color:var(--ink);"></div>
                            <div id="sold-seller-title" style="font-size:0.8rem; color:var(--ink4);"></div>
                        </div>
                    </div>
                </div>

                <!-- ── INQUIRY FORM (hidden for sold properties) ── -->
                <div id="inquiry-form-wrapper">
                    <form action="submitInquiry" method="post" style="display: flex; flex-direction: column; gap: 10px;" onsubmit="return forceDataGrab();">
                        <input type="hidden" name="propertyId" id="inq-prop-id">
                        <input type="hidden" name="propertyTitle" id="inq-prop-title">
                        <input type="hidden" name="agentName" id="inq-agent-name">

                        <input type="text" name="senderName" class="contact-form-input" placeholder="Your Name" required/>
                        <input type="email" name="senderEmail" class="contact-form-input" placeholder="Email Address" required/>
                        <input type="tel" name="senderPhone" class="contact-form-input" placeholder="Phone Number"/>
                        <textarea name="message" class="contact-form-input" rows="3" placeholder="I'm interested in this property..." required></textarea>

                        <button type="submit" class="btn-contact">Send Message</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="page" id="page-agents">
    <div class="agents-hero">
        <div class="container">
            <div class="section-tag">Our Experts</div>
            <h1 class="section-title mt-8">Meet Our Top Agents</h1>
            <p class="section-sub">Work with the most experienced, highest-rated real estate professionals in your area.</p>
        </div>
    </div>
    <section class="section">
        <div class="container">
            <div class="filter-bar" style="margin-bottom:32px">
                <button class="filter-btn active" onclick="filterAgents(this,'all')">All Agents</button>
                <button class="filter-btn" onclick="filterAgents(this,'luxury')">Luxury</button>
                <button class="filter-btn" onclick="filterAgents(this,'commercial')">Commercial</button>
                <button class="filter-btn" onclick="filterAgents(this,'residential')">Residential</button>
                <button class="filter-btn" onclick="filterAgents(this,'investment')">Investment</button>
            </div>
            <div class="prop-grid" id="agents-grid"></div>
        </div>
    </section>
</div>

<div class="page" id="page-login">
    <div class="auth-page">
        <div class="auth-left">
            <img src="images/day.jpg" class="auth-bg-img auth-light-img" alt="Day House"/>
            <img src="images/night.jpg" class="auth-bg-img auth-dark-img" alt="Night House"/>

            <div class="auth-left-content">
                <p class="auth-quote">"The best investment on earth is earth."</p>
                <p class="auth-quote-attr">— Louis Glickman</p>
            </div>
        </div>

        <div class="auth-right">
            <div class="auth-box">
                <h2 class="auth-title">Welcome back</h2>
                <p class="auth-sub" style="margin-bottom: 30px;">Sign in to your Nestiq account</p>

                <p style="color: var(--green); font-size: 0.9rem; margin-bottom: 10px; font-weight: 600; text-align: center;">
                    ${successMessage}
                </p>

                <form action="login" method="post">
                    <%-- Show error from session (survives redirects) or from request --%>
                    <c:if test="${not empty sessionScope.loginError}">
                        <div style="background: rgba(224,40,40,0.1); border: 1.5px solid rgba(224,40,40,0.4); color: var(--red); padding: 14px 16px; border-radius: 8px; margin-bottom: 18px; font-weight: 600; font-size: 0.9rem; display: flex; align-items: center; gap: 10px;">
                            <span style="font-size: 1.2rem; flex-shrink: 0;">❌</span>
                            <span>${sessionScope.loginError}</span>
                        </div>
                        <%-- Clear the error after displaying so it doesn't show again --%>
                        <% session.removeAttribute("loginError"); %>
                    </c:if>

                    <div class="auth-field">
                        <label>Email</label>
                        <input class="auth-input" type="email" name="email" placeholder="you@example.com" required/>
                    </div>

                    <div class="auth-field">
                        <label>Password</label>
                        <div class="pw-wrap">
                            <input class="auth-input" id="login-password" type="password" name="password" placeholder="••••••••" required/>
                            <button class="pw-eye" type="button" aria-label="Toggle password visibility" onclick="togglePw('login-password', this)">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="auth-submit">Sign In →</button>
                </form>

                <p class="auth-switch">Don't have an account? <a onclick="showPage('register')">Create one free</a></p>
            </div>
        </div>
    </div>
</div>

<div class="page" id="page-register">
    <div class="auth-page">
        <div class="auth-left">
            <img src="images/day.jpg" class="auth-bg-img auth-light-img" alt="Day House"/>
            <img src="images/night.jpg" class="auth-bg-img auth-dark-img" alt="Night House"/>

            <div class="auth-left-content">
                <p class="auth-quote">"The best investment on earth is earth."</p>
                <p class="auth-quote-attr">— Louis Glickman</p>
            </div>
        </div>

        <div class="auth-right">
            <div class="auth-box">
                <h2 class="auth-title">Create account</h2>
                <p class="auth-sub" style="margin-bottom: 30px;">Join 50,000+ users on Nestiq</p>

                <form action="register" method="post">
                    <div class="filter-section-title" style="margin-bottom:10px">I am a...</div>
                    <div class="auth-role-grid" id="role-grid">
                        <div class="role-btn selected" onclick="selectRole(this,'BUYER')"><span class="ri">🏠</span>Buyer</div>
                        <div class="role-btn" onclick="selectRole(this,'SELLER')"><span class="ri">💼</span>Seller</div>
                        <div class="role-btn" onclick="selectRole(this,'ADMIN')"><span class="ri">👑</span>Admin</div>
                    </div>

                    <input type="hidden" name="role" id="hiddenRole" value="BUYER"/>

                    <!-- ADMIN KEY INPUT - HIDDEN BY DEFAULT -->
                    <div id="adminKeySection" style="display: none; margin-top: 20px; padding: 16px; background: rgba(255, 193, 7, 0.1); border: 1.5px solid #FFC107; border-radius: 8px;">
                        <label style="font-weight: 600; color: #FFC107; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; display: block;">Admin License Key</label>
                        <input class="auth-input" type="text" name="adminKey" id="adminKey" placeholder="XXXXX - XXXXX - XXXXX - XXXXX" style="text-transform: uppercase; letter-spacing: 2px; font-weight: 600; font-family: 'Courier New', monospace;"/>
                        <p style="font-size: 0.75rem; color: var(--ink4); margin-top: 8px; text-align: center;">🔐 This key is provided by the main company only</p>
                    </div>

                    <div class="auth-field">
                        <label>Full Name</label>
                        <input class="auth-input" type="text" name="fullName" placeholder="John Smith" required/>
                    </div>
                    <div class="auth-field">
                        <label>Email Address</label>
                        <input class="auth-input" type="email" name="email" placeholder="you@example.com" required/>
                    </div>
                    <div class="auth-field">
                        <label>Phone Number</label>
                        <input class="auth-input" type="tel" name="phoneNumber" placeholder="e.g., 0771234567" required/>
                    </div>
                    <div class="auth-field">
                        <label id="passwordLabel">Password</label>
                        <div class="pw-wrap">
                            <input class="auth-input" id="register-password" type="password" name="password" placeholder="Min 8 characters" required minlength="8"/>
                            <button class="pw-eye" type="button" aria-label="Toggle password visibility" onclick="togglePw('register-password', this)">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
                                    <circle cx="12" cy="12" r="3"></circle>
                                </svg>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="auth-submit">Create Account →</button>
                </form>
                <p class="auth-switch">Already have an account? <a onclick="showPage('login')">Sign in</a></p>
            </div>
        </div>
    </div>
</div>

<div class="toast" id="toast">
    <span class="toast-icon" id="toast-icon">✓</span>
    <span id="toast-msg"></span>
</div>

<script>
    // 1. Identity Bridge
    window.currentUser = "${sessionScope.loggedUser}";
    window.currentRole = "${sessionScope.loggedRole}";
    window.currentEmail = "${sessionScope.loggedEmail}";

    // Convert Java List to JS Array
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

    console.log("📬 Notifications Loaded:", window.allNotifications.length);

    // 2. Properties Bridge
    window.properties = [];
    <c:forEach items="${propertyList}" var="p">
    window.properties.push({
        id: "${p.id}", title: "${p.title}", price: Number("${p.price}"),
        location: "${p.location}", type: "${p.type}", status: "${p.status}",
        image: "${p.imageUrl}", seller: "${p.sellerName}",
        bedrooms: "${p.bedrooms}", bathrooms: "${p.bathrooms}",
        description: "${p.description}",
        views: (function(id) {
            // Stable random view count seeded by property id
            var h = 0, s = String(id);
            for (var i = 0; i < s.length; i++) h = (h * 31 + s.charCodeAt(i)) & 0xffffffff;
            return 50 + (Math.abs(h) % 1951); // range: 50 – 2000
        })("${p.id}")
    });
    </c:forEach>

    // 2.3 Property Booking End Dates Bridge (for "Booked until" display)
    window.propertyBookingEndDates = {};
    <c:forEach items="${propertyBookingEndDates}" var="entry">
    window.propertyBookingEndDates["${entry.key}"] = "${entry.value}";
    </c:forEach>
    console.log("📅 Booking End Dates:", window.propertyBookingEndDates);

    // Build price range dropdown after properties are loaded
    if (typeof buildPriceRangeDropdown === 'function') {
        setTimeout(() => buildPriceRangeDropdown(), 100);
    }

    // 2.5 Favorites Bridge — IDs this buyer has already saved
    window.favPropertyIds = new Set();
    <c:forEach items="${favPropertyIds}" var="fid">
    window.favPropertyIds.add("${fid}");
    </c:forEach>

    // 3. Reviews Bridge (Kalhari's Data)
    window.allReviews = [];
    <c:if test="${not empty allReviews}">
    <c:forEach items="${allReviews}" var="r">
    window.allReviews.push({
        id: "${r.reviewID}", propId: "${r.propertyID}", name: "${r.buyerName}",
        rating: "${r.rating}", comment: `<c:out value="${r.comment}" escapeXml="true"/>`,
        isVerified: ${r.verified}
    });
    </c:forEach>
    </c:if>
    console.log("✅ ENGINE ONLINE. User:", window.currentUser, "| Reviews:", window.allReviews.length);
</script>
<script src="app.js"></script>

<script>
    function selectRole(btn, role) {
        // Remove 'selected' class from all role buttons
        const allRoleButtons = document.querySelectorAll('.role-btn');
        allRoleButtons.forEach(b => b.classList.remove('selected'));

        // Add 'selected' class to clicked button
        btn.classList.add('selected');

        // Set the hidden role input
        document.getElementById('hiddenRole').value = role;

        // Show admin key section only if ADMIN is selected
        const adminKeySection = document.getElementById('adminKeySection');
        const adminKeyInput = document.getElementById('adminKey');
        const passwordLabel = document.getElementById('passwordLabel');

        if (role === 'ADMIN') {
            adminKeySection.style.display = 'block';
            adminKeyInput.setAttribute('required', '');
            // Make password optional for admin (they only need the key)
            document.getElementById('register-password').removeAttribute('required');
            passwordLabel.innerText = 'Password (Optional)';
        } else {
            adminKeySection.style.display = 'none';
            adminKeyInput.removeAttribute('required');
            // Make password required for regular users
            document.getElementById('register-password').setAttribute('required', '');
            passwordLabel.innerText = 'Password';
        }
    }

    function togglePw(inputId, btn) {
        const input = document.getElementById(inputId);
        if (!input) return;
        const show = input.type === 'password';
        input.type = show ? 'text' : 'password';

        if (btn) {
            btn.innerHTML = show
                ? `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
             <path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
             <line x1="1" y1="1" x2="23" y2="23"></line>
           </svg>`
                : `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
             <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
             <circle cx="12" cy="12" r="3"></circle>
           </svg>`;
        }
    }
</script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        const viewId = urlParams.get('viewId');
        const tab = urlParams.get('tab');

        // Auto-show listings tab if ?tab=browse is present
        if (tab === 'browse') {
            setTimeout(() => {
                if (typeof showPage === 'function') {
                    showPage('listings');
                }
                // Remove the tab parameter from URL to prevent it from persisting on refresh
                const newUrl = window.location.pathname + window.location.hash;
                window.history.replaceState({}, document.title, newUrl);
            }, 300);
        }

        if (viewId) {
            // Wait just half a second for the Java data to load, then auto-open the property!
            setTimeout(() => {
                if (typeof openDetail === 'function') {
                    openDetail(viewId);
                }
                // Remove the viewId parameter from URL to prevent it from persisting on refresh
                const newUrl = window.location.pathname + window.location.hash;
                window.history.replaceState({}, document.title, newUrl);
            }, 300);
        }

        // Featured Properties City Search
        const homeCitySearch = document.getElementById('home-city-search');
        if (homeCitySearch) {
            homeCitySearch.addEventListener('input', function() {
                if (typeof searchHomeByCity === 'function') {
                    searchHomeByCity(this.value);
                }
            });
        }
    });
</script>

<script>
    function forceDataGrab() {
        // 1. Find the Agent Name on the screen
        let agentEl = document.getElementById('detail-agent-name') || document.querySelector('.agent-profile-name');
        let agentText = agentEl ? agentEl.innerText.trim() : "Agent Assigned";

        // 2. Find the Title on the screen (Looks for ID, then Class, then H1)
        let titleEl = document.getElementById('detail-title') || document.querySelector('.detail-title') || document.querySelector('h1');
        let titleText = titleEl ? titleEl.innerText.trim() : "Premium Property";

        // 3. Smash them into the hidden inputs right as the form flies to Java!
        document.getElementById('inq-agent-name').value = agentText;
        document.getElementById('inq-prop-title').value = titleText;

        // Ensure the ID is caught too (from your URL if needed, or fallback to a default)
        if(!document.getElementById('inq-prop-id').value) {
            document.getElementById('inq-prop-id').value = "PROP-UNKNOWN";
        }

        return true; // Let the form fly!
    }

    // ── NOTIFICATION TOGGLE ENGINE ──
    function toggleNotif(event) {
        // Prevent the click from "bubbling" up
        event.stopPropagation();

        const panel = document.getElementById('notif-panel');
        const isVisible = panel.style.display === 'block';

        // Toggle logic
        panel.style.display = isVisible ? 'none' : 'block';
    }

    // Close the panel if the user clicks anywhere else on the screen
    window.addEventListener('click', () => {
        const panel = document.getElementById('notif-panel');
        if (panel) panel.style.display = 'none';
    });
</script>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const counters = document.querySelectorAll('.counter-anim');
        const speed = 100; // The lower the number, the faster it counts!

        counters.forEach(counter => {
            const updateCount = () => {
                const target = +counter.getAttribute('data-target');
                const count = +counter.innerText;

                // Calculate the increment step
                const inc = target / speed;

                if (count < target) {
                    // Add the increment and update the text
                    counter.innerText = Math.ceil(count + inc);
                    // Run it again every 15 milliseconds
                    setTimeout(updateCount, 15);
                } else {
                    counter.innerText = target;
                }
            };

            updateCount();
        });
    });
</script>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        // Wait just a millisecond to ensure the properties array is fully loaded from Java
        setTimeout(() => {
            if (window.properties && window.properties.length > 0) {
                // Find the latest non-sold property by iterating backwards
                let latestProperty = null;
                for (let i = window.properties.length - 1; i >= 0; i--) {
                    const prop = window.properties[i];
                    // Check if property status is NOT "Sold" (case-insensitive)
                    if (prop.status && prop.status.trim().toLowerCase() !== 'sold') {
                        latestProperty = prop;
                        break; // Found the latest non-sold property
                    }
                }

                if (latestProperty) {
                    // Inject the real data into the UI
                    document.getElementById('latest-title').innerText = latestProperty.title;
                    document.getElementById('latest-loc').innerText = latestProperty.location;

                    // Make the blue arrow open the property detail page
                    document.getElementById('latest-btn').onclick = function() {
                        openDetail(latestProperty.id);
                    };
                } else {
                    // All properties are sold
                    document.getElementById('latest-title').innerText = "All sold out";
                    document.getElementById('latest-loc').innerText = "New listings coming soon!";
                    document.getElementById('latest-btn').style.display = "none";
                }
            } else {
                // Safe fallback if the database is completely empty
                document.getElementById('latest-title').innerText = "No listings yet";
                document.getElementById('latest-loc').innerText = "Check back soon!";
                document.getElementById('latest-btn').style.display = "none";
            }

            // ── JUST SOLD CARD ─────────────────────────────────────
            // Use the recentlySold data passed from PropertyServlet
            const recentlySoldData = [];
            <c:if test="${not empty recentlySold}">
            <c:forEach var="sold" items="${recentlySold}">
            recentlySoldData.push({
                propertyId: "${sold.propertyId}",
                title: "${sold.title}",
                price: "${sold.price}",
                location: "${sold.location}",
                imageUrl: "${sold.imageUrl}"
            });
            </c:forEach>
            </c:if>

            if (recentlySoldData.length > 0) {
                // Try to find a valid sold property (exists in current listings)
                // Start with the most recent, fallback to second most recent if needed
                let sp = null;
                for (let i = 0; i < recentlySoldData.length; i++) {
                    const candidate = recentlySoldData[i];
                    // Check if this property still exists in the current property list
                    const exists = properties.some(p => p.id === candidate.propertyId);
                    if (exists) {
                        sp = candidate;
                        break;
                    }
                    // If not found, continue to next most recent (fallback logic)
                }

                // If no valid property found in the list, use the first one anyway (might have been deleted from properties.txt but still in sold_properties.txt)
                if (!sp) {
                    sp = recentlySoldData[0];
                }

                const card = document.getElementById('just-sold-card');

                // Format price
                let priceVal = parseFloat(sp.price);
                const fmt = isNaN(priceVal) ? sp.price : 'LKR ' + priceVal.toLocaleString();

                document.getElementById('sold-thumb').src  = sp.imageUrl || 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400&q=80';
                document.getElementById('sold-thumb').alt  = sp.title || 'Sold property';
                document.getElementById('sold-title').innerText = sp.title  || 'Property';
                document.getElementById('sold-loc').innerText   = sp.location || '';
                document.getElementById('sold-price').innerText = fmt;

                document.getElementById('sold-btn').onclick = function () {
                    // Navigate to property detail
                    window.location.href = 'properties?viewId=' + sp.propertyId;
                };

                // Reveal the card with a slight entrance delay
                setTimeout(() => { card.style.display = 'block'; }, 400);
            }
            // If no sold properties exist, card stays hidden (display:none)

        }, 150);
    });
</script>

<!-- Page Transition Animation System -->
<script src="page-transitions.js"></script>

<script>
    // Auto-show login page if redirected back after a failed sign-in attempt
    window.addEventListener('DOMContentLoaded', function() {
        // Check session-based error (set by LoginServlet) OR query-string flag
        var hasSessionError = "${not empty sessionScope.loginError}" === "true";
        var hasQueryError   = new URLSearchParams(window.location.search).get('loginError') === 'true';

        if (hasSessionError || hasQueryError) {
            // Hide all pages, then show the login page
            document.querySelectorAll('.page').forEach(function(p) {
                p.classList.remove('active');
            });
            var loginPage = document.getElementById('page-login');
            if (loginPage) {
                loginPage.classList.add('active');
                loginPage.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
            // Reset nav active state
            document.querySelectorAll('.nav-links a').forEach(function(a) {
                a.classList.remove('active');
            });
            // Clean the query string without a page reload so the flag doesn't persist on F5
            if (hasQueryError && window.history.replaceState) {
                var url = new URL(window.location.href);
                url.searchParams.delete('loginError');
                window.history.replaceState(null, '', url.toString());
            }
        }
    });
</script>

</body>
</html>