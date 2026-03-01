<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>NESTIQ — Real Estate</title>
<link rel="preconnect" href="https://fonts.googleapis.com"/>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet"/>
<style>
/* ════════════════════════════════════════════
   NESTIQ — Professional Real Estate UI
   Theme: Clean Modern Light
   Font: Playfair Display + Outfit
════════════════════════════════════════════ */
:root {
  --ink:      #0f1117;
  --ink2:     #2a2d35;
  --ink3:     #5a5f70;
  --ink4:     #9198a8;
  --line:     #e8eaee;
  --line2:    #f2f4f7;
  --bg:       #ffffff;
  --bg2:      #f7f8fa;
  --bg3:      #eef0f4;
  --accent:   #1a56db;
  --accent2:  #1041b0;
  --accent-l: #eff3fd;
  --green:    #0d9e6e;
  --green-l:  #e6f7f3;
  --amber:    #d97706;
  --amber-l:  #fef3c7;
  --red:      #e02828;
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
  background: rgba(255,255,255,.92);
  backdrop-filter: blur(16px);
  border-bottom: 1px solid var(--line);
  display: flex; align-items: center; justify-content: space-between;
  padding: 0 40px;
  transition: box-shadow var(--t);
}
.navbar.scrolled { box-shadow: var(--shadow); }
.nav-logo {
  font-family: var(--font-serif);
  font-size: 1.5rem;
  font-weight: 700;
  letter-spacing: -0.5px;
  color: var(--ink);
  display: flex; align-items: center; gap: 8px;
}
.nav-logo .dot { width: 8px; height: 8px; background: var(--accent); border-radius: 50%; display: inline-block; }
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
}
.btn-ghost:hover { border-color: var(--ink2); background: var(--bg2); }
.btn-primary {
  font-size: .875rem; font-weight: 600;
  color: #fff; background: var(--accent);
  padding: 8px 20px; border-radius: var(--r);
  border: 1.5px solid transparent;
  transition: all var(--t);
  display: flex; align-items: center; gap: 6px;
}
.btn-primary:hover { background: var(--accent2); transform: translateY(-1px); box-shadow: 0 4px 14px rgba(26,86,219,.35); }
.btn-primary:active { transform: translateY(0); }

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
}
@keyframes fadeInLeft { from { opacity:0; transform: translateX(-30px); } to { opacity:1; transform: none; } }
.hero-eyebrow {
  display: inline-flex; align-items: center; gap: 8px;
  font-size: .75rem; font-weight: 600; letter-spacing: 2px;
  text-transform: uppercase; color: var(--accent);
  background: var(--accent-l); padding: 6px 14px; border-radius: 99px;
  margin-bottom: 28px; width: fit-content;
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
  display: flex; gap: 32px;
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
  background: white;
  border-radius: var(--r2);
  padding: 16px 20px;
  box-shadow: var(--shadow-xl);
  animation: floatCard 4s ease-in-out infinite;
}
@keyframes floatCard { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-8px); } }
.hcf-1 { bottom: 120px; left: -24px; min-width: 220px; }
.hcf-2 { top: 100px; right: 24px; min-width: 180px; animation-delay: 1.5s; }
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
.section-tag::before { content:''; width: 20px; height: 2px; background: var(--accent); border-radius: 99px; }
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
  border-color: rgba(26,86,219,.2);
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
  grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
  gap: 24px;
}
.prop-card {
  background: var(--bg);
  border: 1.5px solid var(--line);
  border-radius: var(--r2);
  overflow: hidden;
  transition: all var(--t);
  cursor: pointer;
  animation: cardIn .4s ease both;
}
@keyframes cardIn { from { opacity:0; transform: translateY(12px); } to { opacity:1; transform: none; } }
.prop-card:hover {
  border-color: transparent;
  box-shadow: var(--shadow-xl);
  transform: translateY(-4px);
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
.prop-tag {
  font-size: .68rem; font-weight: 700; letter-spacing: .5px;
  padding: 4px 10px; border-radius: 99px;
  backdrop-filter: blur(8px);
}
.tag-sale { background: rgba(255,255,255,.95); color: var(--green); }
.tag-rent { background: rgba(255,255,255,.95); color: var(--accent); }
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

/* ── AUTH PAGES ── */
.auth-page {
  min-height: 100vh; display: grid; grid-template-columns: 1fr 1fr;
}
.auth-left {
  background: var(--ink);
  position: relative; overflow: hidden;
  display: flex; flex-direction: column; justify-content: flex-end;
  padding: 60px;
}
.auth-left-img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; opacity: .4; }
.auth-left-content { position: relative; z-index: 1; }
.auth-left-logo {
  font-family: var(--font-serif);
  font-size: 1.8rem; font-weight: 700; color: white;
  position: absolute; top: 40px; left: 60px; z-index: 1;
  display: flex; align-items: center; gap: 8px;
}
.auth-left-logo .dot { width: 8px; height: 8px; background: var(--accent); border-radius: 50%; }
.auth-quote {
  font-family: var(--font-serif);
  font-size: 2.2rem; font-weight: 400; font-style: italic;
  color: white; line-height: 1.3; margin-bottom: 20px;
}
.auth-quote-attr { font-size: .875rem; color: rgba(255,255,255,.6); }
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
.auth-input:focus { border-color: var(--accent); background: white; box-shadow: 0 0 0 3px rgba(26,86,219,.1); }
.auth-input::placeholder { color: var(--ink4); }
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
.auth-submit:hover { background: var(--accent2); box-shadow: 0 4px 14px rgba(26,86,219,.35); }
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
.price-input {
  flex:1; background: var(--bg2); border: 1.5px solid transparent;
  border-radius: var(--r); padding: 9px 12px;
  font-size: .82rem; color: var(--ink); transition: border-color var(--t);
}
.price-input:focus { border-color: var(--accent); }
.filter-chips { display: flex; flex-wrap: wrap; gap: 6px; }
.filter-chip {
  font-size: .75rem; font-weight: 500; color: var(--ink3);
  background: var(--bg2); border: 1.5px solid transparent;
  padding: 5px 12px; border-radius: 99px; cursor: pointer; transition: all var(--t);
}
.filter-chip:hover { background: var(--bg3); }
.filter-chip.active { color: var(--accent); background: var(--accent-l); border-color: rgba(26,86,219,.25); }
.filter-beds { display: flex; gap: 6px; }
.bed-btn {
  width: 40px; height: 36px; border-radius: var(--r);
  background: var(--bg2); border: 1.5px solid transparent;
  font-size: .82rem; font-weight: 600; color: var(--ink3); cursor: pointer; transition: all var(--t);
}
.bed-btn.active { background: var(--accent-l); color: var(--accent); border-color: rgba(26,86,219,.25); }
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
.view-btn.active { background: var(--accent-l); color: var(--accent); border-color: rgba(26,86,219,.25); }

/* ── WHY SECTION ── */
.why-section { background: var(--ink); padding: 96px 40px; }
.why-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 2px; }
.why-card {
  background: rgba(255,255,255,.04);
  padding: 40px 36px;
  transition: background var(--t);
}
.why-card:hover { background: rgba(255,255,255,.07); }
.why-icon {
  width: 48px; height: 48px; border-radius: var(--r);
  background: rgba(26,86,219,.3);
  display: flex; align-items: center; justify-content: center;
  font-size: 1.4rem; margin-bottom: 20px;
}
.why-title { font-size: 1.1rem; font-weight: 600; color: white; margin-bottom: 10px; }
.why-desc { font-size: .875rem; color: rgba(255,255,255,.5); line-height: 1.7; }

/* ── TESTIMONIALS ── */
.testi-grid { display: grid; grid-template-columns: repeat(3,1fr); gap: 24px; }
.testi-card {
  background: var(--bg2); border-radius: var(--r2);
  padding: 28px; transition: all var(--t);
}
.testi-card:hover { box-shadow: var(--shadow-lg); transform: translateY(-3px); background: white; }
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

/* ── FOOTER ── */
.footer { background: var(--bg2); border-top: 1px solid var(--line); padding: 64px 40px 32px; }
.footer-top { display: grid; grid-template-columns: 2fr 1fr 1fr 1fr; gap: 48px; margin-bottom: 48px; }
.footer-logo { font-family: var(--font-serif); font-size: 1.5rem; font-weight: 700; color: var(--ink); margin-bottom: 12px; display: flex; align-items: center; gap: 6px; }
.footer-desc { font-size: .875rem; color: var(--ink3); line-height: 1.7; max-width: 280px; margin-bottom: 20px; }
.footer-socials { display: flex; gap: 8px; }
.social-btn {
  width: 36px; height: 36px; border-radius: var(--r);
  background: var(--bg3); border: 1px solid var(--line);
  display: flex; align-items: center; justify-content: center;
  color: var(--ink3); font-size: .875rem;
  transition: all var(--t); cursor: pointer;
}
.social-btn:hover { background: var(--accent); color: white; border-color: var(--accent); }
.footer-col-title { font-size: .75rem; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; color: var(--ink3); margin-bottom: 16px; }
.footer-links { list-style: none; }
.footer-links li { margin-bottom: 10px; }
.footer-links a { font-size: .875rem; color: var(--ink3); transition: color var(--t); }
.footer-links a:hover { color: var(--accent); }
.footer-bottom { border-top: 1px solid var(--line); padding-top: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; }
.footer-copy { font-size: .8rem; color: var(--ink4); }
.footer-legal { display: flex; gap: 20px; }
.footer-legal a { font-size: .8rem; color: var(--ink4); transition: color var(--t); }
.footer-legal a:hover { color: var(--accent); }

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
</style>
</head>
<body>

<nav class="navbar" id="navbar">
  <div class="nav-logo" onclick="showPage('home')" style="cursor:pointer">
    <span class="dot"></span>NESTIQ
  </div>
  <ul class="nav-links">
    <li><a href="#" onclick="showPage('home')" id="nav-home" class="active">Home</a></li>
    <li><a href="#" onclick="showPage('listings')">Browse</a></li>
    <li><a href="#" onclick="showPage('agents')">Agents</a></li>
    <li><a href="#" onclick="showPage('home')">About</a></li>
  </ul>
  <div class="nav-actions">
    <button class="btn-ghost" onclick="showPage('login')">Sign In</button>
    <button class="btn-primary" onclick="showPage('register')">
      <svg viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="2"><path d="M8 2v12M2 8h12"/></svg>
      List Property
    </button>
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

      <form action="properties" method="get" class="hero-search">

          <div class="hero-search-field">
            <label>Location</label>
            <input type="text" name="location" placeholder="City, neighborhood..." id="heroLocation"/>
          </div>

          <div class="hero-search-field" style="max-width:140px">
            <label>Type</label>
            <select id="heroType">
              <option value="">Any Type</option>
              <option>Apartment</option>
              <option>House</option>
              <option>Villa</option>
              <option>Studio</option>
            </select>
          </div>

          <div class="hero-search-field" style="max-width:140px">
            <label>Status</label>
            <select id="heroStatus">
              <option value="">Buy or Rent</option>
              <option value="sale">For Sale</option>
              <option value="rent">For Rent</option>
            </select>
          </div>

          <button type="submit" class="hero-search-btn">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            Search
          </button>
      </form>

      <div class="hero-stats">
        <div class="hstat">
          <div class="hstat-num" data-target="12400" id="stat0">0</div>
          <div class="hstat-label">Active Listings</div>
        </div>
        <div class="hstat-divider"></div>
        <div class="hstat">
          <div class="hstat-num" data-target="340" id="stat1">0</div>
          <div class="hstat-label">Expert Agents</div>
        </div>
        <div class="hstat-divider"></div>
        <div class="hstat">
          <div class="hstat-num" data-target="98" id="stat2">0</div>
          <div class="hstat-label">% Client Satisfaction</div>
        </div>
      </div>
    </div>

    <div class="hero-right">
      <img src="https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=1200&q=85" class="hero-main-img" alt="hero"/>
      <div class="hero-img-overlay"></div>

      <div class="hero-card-float hcf-1">
        <div class="hcf-label">Latest Listing</div>
        <div class="hcf-value">The Meridian Loft</div>
        <div class="hcf-sub">Downtown Manhattan, NY</div>
        <span class="hcf-badge badge-green">✓ Just Listed</span>
      </div>

      <div class="hero-card-float hcf-2">
        <div class="hcf-label">This Week</div>
        <div class="hcf-value" style="font-size:1.4rem;font-family:var(--font-serif)">$4.2M</div>
        <div class="hcf-sub">Avg. Sale Price</div>
        <span class="hcf-badge badge-amber">↑ 12% vs last month</span>
      </div>
    </div>
  </section>

  <section class="section" style="background:var(--bg)">
    <div class="container">
      <div style="display:flex;align-items:flex-end;justify-content:space-between;margin-bottom:36px;flex-wrap:wrap;gap:16px">
        <div>
          <div class="section-tag">Hand-Picked</div>
          <h2 class="section-title">Featured Properties</h2>
        </div>
        <button class="btn-ghost" onclick="showPage('listings')">View all listings →</button>
      </div>
      <div class="filter-bar">
        <button class="filter-btn active" onclick="filterHome(this,'all')">All</button>
        <button class="filter-btn" onclick="filterHome(this,'sale')">For Sale</button>
        <button class="filter-btn" onclick="filterHome(this,'rent')">For Rent</button>
        <button class="filter-btn" onclick="filterHome(this,'apartment')">Apartments</button>
        <button class="filter-btn" onclick="filterHome(this,'house')">Houses</button>
        <button class="filter-btn" onclick="filterHome(this,'villa')">Villas</button>
      </div>
      <div class="prop-grid" id="home-prop-grid">
                <c:choose>
                    <c:when test="${not empty properties}">
                        <c:forEach var="p" items="${properties}">
                            <div class="prop-card" onclick="openDetail('${p.id}')">
                                <div class="prop-img-wrap">
                                    <img src="https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80" alt="Property Image"/>
                                    <div class="prop-tags">
                                        <span class="prop-tag tag-sale">${p.type}</span>
                                    </div>
                                </div>
                                <div class="prop-body">
                                    <div class="prop-price">$<fmt:formatNumber value="${p.price}" pattern="#,##0.00" /></div>
                                    <div class="prop-name">${p.title}</div>
                                    <div class="prop-loc">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
                                        ${p.location}
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p>No properties available at the moment. Please check back later!</p>
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
          <div class="footer-col-title">Company</div>
          <ul class="footer-links">
            <li><a href="#">About Us</a></li>
            <li><a href="#">Careers</a></li>
            <li><a href="#">Press</a></li>
            <li><a href="#">Blog</a></li>
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
          <div class="filter-chip" onclick="toggleChip(this,'type','studio')">Studio</div>
        </div>
      </div>

      <div class="filter-section">
        <div class="filter-section-title">Price Range</div>
        <div class="price-range">
          <input class="price-input" type="number" placeholder="Min $" id="filterMinPrice"/>
          <input class="price-input" type="number" placeholder="Max $" id="filterMaxPrice"/>
        </div>
      </div>

      <div class="filter-section">
        <div class="filter-section-title">Bedrooms</div>
        <div class="filter-beds">
          <button class="bed-btn active" onclick="setBeds(this,'any')">Any</button>
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
          <div class="filter-chip" onclick="toggleChip(this,'city','New York')">New York</div>
          <div class="filter-chip" onclick="toggleChip(this,'city','Los Angeles')">Los Angeles</div>
          <div class="filter-chip" onclick="toggleChip(this,'city','Miami')">Miami</div>
          <div class="filter-chip" onclick="toggleChip(this,'city','Chicago')">Chicago</div>
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
            <div class="view-btn active" title="Grid view">⊞</div>
            <div class="view-btn" title="List view">☰</div>
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
    <button class="detail-back-btn" onclick="history.back(); showPage(lastPage)">
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
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
        <span id="detail-address-text"></span>
      </div>

      <div class="detail-price-row">
        <div>
          <div class="detail-price-sub" id="detail-price-label">Listing Price</div>
          <div class="detail-price" id="detail-price"></div>
        </div>
        <div id="detail-price-badges"></div>
      </div>

      <div class="detail-specs" id="detail-specs"></div>

      <div class="detail-section-title">About This Property</div>
      <p class="detail-desc" id="detail-desc"></p>

      <div class="detail-section-title">Features & Amenities</div>
      <div class="features-grid" id="detail-features"></div>
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

        <input class="contact-form-input" placeholder="Your Name" id="ci-name"/>
        <input class="contact-form-input" placeholder="Email Address" id="ci-email"/>
        <input class="contact-form-input" placeholder="Phone Number" id="ci-phone"/>
        <textarea class="contact-form-input" rows="3" placeholder="I'm interested in this property..." id="ci-message"></textarea>
        <button class="btn-contact" onclick="sendInquiry()">Send Message</button>
        <button class="btn-contact-outline" onclick="scheduleViewing()">📅 Schedule Viewing</button>
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
      <img src="https://images.unsplash.com/photo-1600607687644-c7171b42498b?w=900&q=80" class="auth-left-img" alt=""/>
      <div class="auth-left-logo"><span class="dot"></span>NESTIQ</div>
      <div class="auth-left-content">
        <p class="auth-quote">"The best investment on earth is earth."</p>
        <p class="auth-quote-attr">— Louis Glickman</p>
      </div>
    </div>
    <div class="auth-right">
      <div class="auth-box">
        <h2 class="auth-title">Welcome back</h2>
        <p class="auth-sub">Sign in to your Nestiq account</p>

        <div class="auth-social">
          <button class="auth-social-btn">🔵 Google</button>
          <button class="auth-social-btn">🍎 Apple</button>
        </div>
   <div class="auth-divider"><span>or continue with email</span></div>

   <form action="login" method="post">

       <p style="color: var(--red); font-size: 0.8rem; margin-bottom: 10px; font-weight: 500;">
           ${errorMessage}
       </p>

       <div class="auth-field">
         <label>Username</label>
         <input class="auth-input" type="text" name="username" placeholder="admin" required/>
       </div>

       <div class="auth-field">
         <label>Password</label>
         <input class="auth-input" type="password" name="password" placeholder="••••••••" required/>
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
      <img src="https://images.unsplash.com/photo-1560185127-6ed189bf02f4?w=900&q=80" class="auth-left-img" alt=""/>
      <div class="auth-left-logo"><span class="dot"></span>NESTIQ</div>
      <div class="auth-left-content">
        <p class="auth-quote">"Home is where love resides and memories are created."</p>
      </div>
    </div>
    <div class="auth-right">
      <div class="auth-box">
        <h2 class="auth-title">Create account</h2>
        <p class="auth-sub">Join 50,000+ users on Nestiq</p>

        <div class="filter-section-title" style="margin-bottom:10px">I am a...</div>
        <div class="auth-role-grid" id="role-grid">
          <div class="role-btn selected" onclick="selectRole(this,'BUYER')"><span class="ri">🏠</span>Buyer</div>
          <div class="role-btn" onclick="selectRole(this,'SELLER')"><span class="ri">💼</span>Seller</div>
          <div class="role-btn" onclick="selectRole(this,'AGENT')"><span class="ri">🤝</span>Agent</div>
        </div>

        <div class="auth-field">
          <label>Full Name</label>
          <input class="auth-input" type="text" placeholder="John Smith" id="reg-name"/>
        </div>
        <div class="auth-field">
          <label>Email Address</label>
          <input class="auth-input" type="email" placeholder="you@example.com" id="reg-email"/>
        </div>
        <div class="auth-field">
          <label>Password</label>
          <input class="auth-input" type="password" placeholder="Min 8 characters" id="reg-password"/>
        </div>

        <button class="auth-submit" onclick="doRegister()">Create Account →</button>
        <p class="auth-switch">Already have an account? <a onclick="showPage('login')">Sign in</a></p>
      </div>
    </div>
  </div>
</div>

<div class="toast" id="toast">
  <span class="toast-icon" id="toast-icon">✓</span>
  <span id="toast-msg"></span>
</div>

<script src="app.js"></script>

</body>
</html>