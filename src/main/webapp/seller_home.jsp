<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String role = (String) session.getAttribute("loggedRole");
    if (role == null || !"SELLER".equalsIgnoreCase(role)) {
        response.sendRedirect("properties");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>NESTIQ — Seller Home</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <style>
        :root{
            --ink:#0f1117; --ink2:#2a2d35; --ink3:#5a5f70; --ink4:#9198a8;
            --line:#e8eaee; --bg:#fff; --bg2:#f7f8fa; --accent:#1a56db; --accent2:#1041b0;
            --green:#0d9e6e; --green-l:#e6f7f3; --amber:#d97706; --amber-l:#fef3c7;
            --r:10px; --r2:16px; --r3:24px; --shadow:0 4px 16px rgba(0,0,0,.08), 0 1px 4px rgba(0,0,0,.04);
            --t:.22s cubic-bezier(.4,0,.2,1);
            --font-serif:'Playfair Display', Georgia, serif;
            --font-sans:'Outfit', system-ui, sans-serif;
        }
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
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:var(--font-sans);background:var(--bg);color:var(--ink);min-height:100vh}
        a{text-decoration:none;color:inherit}
        button{font-family:var(--font-sans);cursor:pointer;border:none}

        .navbar{
            position:sticky; top:0; z-index:10;
            height:68px; display:flex; align-items:center; justify-content:space-between;
            padding:0 40px; background:rgba(255,255,255,.92); backdrop-filter:blur(16px);
            border-bottom:1px solid var(--line);
        }
        [data-theme="dark"] .navbar{ background: rgba(26, 26, 46, 0.92); }
        .brand{display:flex;align-items:center;gap:8px;font-family:var(--font-serif);font-weight:700;font-size:1.5rem;letter-spacing:-.5px}
        .dot{width:8px;height:8px;border-radius:50%;background:var(--accent);display:inline-block}
        .nav-right{display:flex;align-items:center;gap:12px}
        .pill{
            display:flex; align-items:center; gap:10px;
            padding:6px 14px 6px 8px; border:1.5px solid var(--line);
            border-radius:999px; background:var(--bg); transition:all var(--t);
        }
        .pill-badge{
            background: rgba(13,158,110,.12);
            color: var(--green);
            padding: 3px 8px;
            border-radius: 12px;
            font-size: .7rem;
            font-weight: 800;
            letter-spacing: .7px;
        }
        .btn-ghost{
            background:none; border:1.5px solid var(--line); color:var(--ink2);
            padding:8px 16px; border-radius:999px; font-weight:600; transition:all var(--t);
        }
        .btn-ghost:hover{border-color:var(--ink2); background:var(--bg2)}
        .btn-primary{
            background:var(--accent); color:#fff; padding:9px 18px; border-radius:999px;
            font-weight:700; transition:all var(--t);
        }
        .btn-primary:hover{background:var(--accent2); transform:translateY(-1px)}

        .wrap{max-width:1180px;margin:0 auto;padding:38px 40px}
        .hero{
            display:grid; grid-template-columns: 1.2fr .8fr; gap:24px; align-items:stretch;
            padding:28px; border:1px solid var(--line); border-radius:var(--r3);
            background: linear-gradient(135deg, rgba(157, 142, 238, 0.08), rgba(13,158,110,.06));
            box-shadow:var(--shadow);
        }
        .kicker{
            display:inline-flex; align-items:center; gap:8px;
            font-size:.72rem; font-weight:800; letter-spacing:2px; text-transform:uppercase;
            color:var(--accent); background: rgba(157, 142, 238, 0.10); padding:6px 12px; border-radius:999px;
            width:fit-content; margin-bottom:16px;
        }
        .title{font-family:var(--font-serif); font-size: clamp(2.1rem, 3.6vw, 3rem); line-height:1.1; margin-bottom:12px}
        .sub{color:var(--ink3); font-size:1rem; line-height:1.7; max-width:56ch}
        .quick{
            display:grid; gap:12px;
            background: rgba(255,255,255,.75);
            border: 1px solid var(--line);
            border-radius: var(--r2);
            padding: 18px;
        }
        [data-theme="dark"] .quick{ background: rgba(42, 42, 74, 0.75); }
        .q-title{font-weight:800; margin-bottom:6px}
        .q-row{display:flex; gap:10px; flex-wrap:wrap}
        .mini{
            display:flex; align-items:center; gap:10px;
            border:1.5px solid var(--line);
            border-radius: var(--r2);
            padding:12px 14px;
            background: var(--bg);
            transition: all var(--t);
            min-width: 220px;
        }
        .mini:hover{ transform: translateY(-2px); box-shadow: 0 10px 30px rgba(0,0,0,.08); border-color: transparent; }
        .ico{width:36px;height:36px;border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:1.1rem}
        .ico.blue{ background: rgba(157, 142, 238, 0.12); color: var(--accent); }
        .ico.green{ background: rgba(13,158,110,.12); color: var(--green); }
        .ico.amber{ background: rgba(217,119,6,.14); color: var(--amber); }
        .mini-h{font-weight:800}
        .mini-p{font-size:.82rem;color:var(--ink4);margin-top:2px}

        .grid{display:grid; grid-template-columns: repeat(3, 1fr); gap:16px; margin-top:18px}
        .card{
            border:1px solid var(--line); border-radius: var(--r2); background: var(--bg);
            padding:18px; box-shadow: 0 1px 3px rgba(0,0,0,.06);
            transition: all var(--t);
        }
        .card:hover{
            transform: translateY(-4px);
            box-shadow: var(--shadow);
        }
        .card h3{font-size:1rem; margin-bottom:8px}
        .muted{color:var(--ink3); font-size:.9rem; line-height:1.65}

        /* Separate image section (outside hero box) */
        .scene{
            margin-top: 18px;
            border: 1px solid var(--line);
            border-radius: var(--r3);
            overflow: hidden;
            box-shadow: var(--shadow);
            background: var(--bg);
        }
        .scene-img{
            height: 220px;
            width: 100%;
            background-image:
                linear-gradient(90deg, rgba(15,17,23,.10), rgba(15,17,23,.02)),
                url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=2000&q=80');
            background-size: cover;
            background-position: center;
        }
        [data-theme="dark"] .scene-img{
            background-image:
                linear-gradient(90deg, rgba(26, 26, 46, 0.55), rgba(26, 26, 46, 0.30)),
                url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=2000&q=80');
        }
        .scene-body{
            padding: 16px 18px;
            display:flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
        }
        .scene-title{ font-weight: 900; }
        .scene-sub{ color: var(--ink3); font-size: .9rem; }

        .theme-switch{
            width:54px;height:30px;border-radius:30px;background:var(--line);
            padding:4px; display:flex; align-items:center; transition: background-color .35s ease;
        }
        .thumb{
            width:22px;height:22px;border-radius:50%; background:#fff;
            display:flex; align-items:center; justify-content:center; font-size:.75rem;
            transition: transform .35s cubic-bezier(.34,1.56,.64,1);
        }
        [data-theme="dark"] .theme-switch{ background: var(--accent); }
        [data-theme="dark"] .thumb{ transform: translateX(24px); background: var(--bg2); }

        @media (max-width: 980px){
            .hero{grid-template-columns:1fr}
            .grid{grid-template-columns:1fr}
            .navbar{padding:0 18px}
            .wrap{padding:26px 18px}
        }
    </style>
</head>
<body data-theme="light" id="themeRoot">
<nav class="navbar">
    <a class="brand" href="sellerHome">
        <span class="dot"></span> NESTIQ
    </a>
    <div class="nav-right">
        <div class="theme-switch" onclick="toggleTheme()" title="Toggle Dark Mode">
            <div class="thumb" id="themeThumb">🌙</div>
        </div>
        <div class="pill">
            <div style="background:var(--bg2);border-radius:50%;padding:5px;line-height:1">💼</div>
            <div style="display:flex;flex-direction:column;line-height:1.1">
                <span style="font-weight:800;font-size:.92rem">${sessionScope.loggedUser}</span>
                <span style="font-size:.78rem;color:var(--ink4)">Seller workspace</span>
            </div>
            <span class="pill-badge">SELLER</span>
        </div>
        <a class="btn-primary" href="sellerDashboard">Open Dashboard</a>
        <form action="logout" method="post" style="margin:0">
            <button type="submit" class="btn-ghost">Logout</button>
        </form>
    </div>
</nav>

<main class="wrap">
    <section class="hero">
        <div>
            <div class="kicker">Seller Interface</div>
            <div class="title">Manage listings, respond to buyers, and grow faster.</div>
            <div class="sub">
                This page is dedicated to Sellers only. Buyers will never see this workspace, and Sellers won’t be redirected to the Buyer main site.
            </div>
            <div class="grid">
                <div class="card">
                    <h3>List a property</h3>
                    <div class="muted">Add a new listing and publish it to the marketplace from your dashboard.</div>
                </div>
                <div class="card">
                    <h3>Manage your listings</h3>
                    <div class="muted">Edit price, status, and details, or remove listings you no longer want to show.</div>
                </div>
                <div class="card">
                    <h3>Reply to inquiries</h3>
                    <div class="muted">Open your inbox and respond to buyer messages quickly.</div>
                </div>
            </div>
        </div>

        <aside class="quick">
            <div class="q-title">Quick actions</div>
            <div class="q-row">
                <a class="mini" href="sellerDashboard">
                    <div class="ico blue">📋</div>
                    <div>
                        <div class="mini-h">Seller Dashboard</div>
                        <div class="mini-p">Properties + inquiries</div>
                    </div>
                </a>
                <a class="mini" href="sellerDashboard#add">
                    <div class="ico green">➕</div>
                    <div>
                        <div class="mini-h">Add Property</div>
                        <div class="mini-p">Create a new listing</div>
                    </div>
                </a>
                <a class="mini" href="sellerDashboard#inbox">
                    <div class="ico amber">📩</div>
                    <div>
                        <div class="mini-h">Buyer Inquiries</div>
                        <div class="mini-p">Open chat threads</div>
                    </div>
                </a>
            </div>
            <div style="border-top:1px solid var(--line); padding-top:12px; margin-top:6px; color:var(--ink3); font-size:.85rem; line-height:1.6">
                Tip: bookmark this page as your Seller main page: <strong>`/sellerHome`</strong>.
            </div>
        </aside>
    </section>

    <section style="margin-top: 32px;">
        <div class="q-title" style="font-size: 1.2rem; margin-bottom: 20px;">⭐ Recent Buyer Reviews</div>
        <div class="grid" style="grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));">
            <c:set var="hasAnyReview" value="false"/>
            <c:forEach var="p" items="${myProperties}">
                <c:forEach var="r" items="${reviewsByProperty[p.id]}">
                    <c:set var="hasAnyReview" value="true"/>
                    <div class="card" style="display: flex; flex-direction: column; gap: 10px;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                            <div>
                                <div style="font-weight: 800; font-size: 0.95rem;">${r.buyerName}</div>
                                <div style="font-size: 0.75rem; color: var(--ink4); margin-top: 2px;">on ${p.title}</div>
                            </div>
                            <div style="color: var(--amber); letter-spacing: 1px; font-size: 0.85rem;">
                                <c:forEach begin="1" end="${r.rating}" var="i">★</c:forEach>
                                <c:forEach begin="1" end="${5 - r.rating}" var="i">☆</c:forEach>
                            </div>
                        </div>
                        <div class="muted" style="font-style: italic; font-size: 0.85rem;">
                            "${r.comment}"
                        </div>
                        <c:if test="${r.verified}">
                            <div style="font-size: 0.7rem; font-weight: 800; color: var(--green); background: var(--green-l); padding: 2px 6px; border-radius: 4px; width: fit-content; text-transform: uppercase;">
                                Verified Purchase
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:forEach>
            <c:if test="${!hasAnyReview}">
                <div class="card" style="grid-column: 1 / -1; text-align: center; padding: 40px; opacity: 0.6;">
                    No reviews received yet from buyers.
                </div>
            </c:if>
        </div>
    </section>

    <section class="scene" aria-label="Seller workspace highlight">
        <div class="scene-img" role="img" aria-label="Professional real estate workspace image"></div>
        <div class="scene-body">
            <div>
                <div class="scene-title">Stay on top of your portfolio</div>
                <div class="scene-sub">Track listings and handle inquiries in one place.</div>
            </div>
            <a class="btn-ghost" href="sellerDashboard">Go to seller dashboard →</a>
        </div>
    </section>
</main>

<script>
    function toggleTheme() {
        const root = document.getElementById('themeRoot');
        const thumb = document.getElementById('themeThumb');
        const dark = root.getAttribute('data-theme') === 'dark';
        root.setAttribute('data-theme', dark ? 'light' : 'dark');
        if (thumb) thumb.textContent = dark ? '🌙' : '☀️';
        try { localStorage.setItem('nestiq_theme', dark ? 'light' : 'dark'); } catch (e) {}
    }
    (function initTheme() {
        try {
            const saved = localStorage.getItem('nestiq_theme');
            if (saved === 'dark' || saved === 'light') {
                document.getElementById('themeRoot').setAttribute('data-theme', saved);
                document.getElementById('themeThumb').textContent = saved === 'dark' ? '☀️' : '🌙';
            }
        } catch (e) {}
    })();
</script>

<!-- Page Transition Animation System -->
<script src="page-transitions.js"></script>
</body>
</html>