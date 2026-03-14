// ── DARK MODE LOGIC ───────────────────────────────────
if (localStorage.getItem('nestiq_theme') === 'dark') {
    document.documentElement.setAttribute('data-theme', 'dark');
    document.addEventListener("DOMContentLoaded", () => {
        const btn = document.getElementById('theme-toggle');
        if(btn) btn.textContent = '☀️';
    });
}

function toggleTheme() {
    const html = document.documentElement;
    const btn = document.getElementById('theme-toggle');
    if (html.getAttribute('data-theme') === 'dark') {
        html.removeAttribute('data-theme');
        localStorage.setItem('nestiq_theme', 'light');
        if(btn) btn.textContent = '🌙';
    } else {
        html.setAttribute('data-theme', 'dark');
        localStorage.setItem('nestiq_theme', 'dark');
        if(btn) btn.textContent = '☀️';
    }
}

// ── DATA ──────────────────────────────────────────────
const AGENTS = [
    { id:1, name:"Senuri Fernando", title:"Senior Luxury Specialist", agency:"Nestiq Colombo 07", phone:"+94 77 101 2020", email:"s.fernando@nestiq.lk", img:"https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80", listings:24, sold:187, rating:4.9, spec:"luxury", years:12 },
    { id:2, name:"Dinesh Perera", title:"Investment & Commercial", agency:"Nestiq Kandy", phone:"+94 71 202 3030", email:"d.perera@nestiq.lk", img:"https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80", listings:18, sold:143, rating:4.8, spec:"investment", years:9 },
    { id:3, name:"Kavindi De Silva", title:"Residential Expert", agency:"Nestiq Kurunegala", phone:"+94 70 303 4040", email:"k.desilva@nestiq.lk", img:"https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80", listings:31, sold:210, rating:4.9, spec:"residential", years:15 },
    { id:4, name:"Nuwan Rathnayake", title:"Commercial Specialist", agency:"Nestiq Galle", phone:"+94 76 404 5050", email:"n.rathnayake@nestiq.lk", img:"https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&q=80", listings:12, sold:98, rating:4.7, spec:"commercial", years:7 },
    { id:5, name:"Anjali Jayasooriya", title:"Luxury Condo Specialist", agency:"Nestiq Mount Lavinia", phone:"+94 77 505 6060", email:"a.jayasooriya@nestiq.lk", img:"https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400&q=80", listings:20, sold:156, rating:4.8, spec:"luxury", years:10 },
    { id:6, name:"Mohammed Rizwan", title:"Investment Properties", agency:"Nestiq Negombo", phone:"+94 75 606 7070", email:"m.rizwan@nestiq.lk", img:"https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400&q=80", listings:15, sold:121, rating:4.7, spec:"investment", years:8 }
];

const TESTIMONIALS = [
    { name:"Chamathka Silva", role:"Bought in Colombo 07", img:"https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&q=80", text:"Nestiq made finding our dream apartment effortless. Senuri guided us with exceptional patience and expertise — we couldn't be happier.", stars:5 },
    { name:"Kasun & Tharushi", role:"Sold in Kurunegala", img:"https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=100&q=80", text:"Sold our villa in under two weeks for above the asking price. Dinesh's market knowledge and professional network are truly unmatched.", stars:5 },
    { name:"Ashan Dias", role:"Renting in Malabe", img:"https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80", text:"The entire process was transparent, fast and stress-free. Kavindi found us the perfect annex near the campus. Exceptional service from start to finish.", stars:5 }
];

let currentFilters = { status: 'all', type: 'all', city: 'all', beds: 'any', minPrice: '', maxPrice: '' };
let savedIds = [];

// ── ROUTER ────────────────────────────
function showPage(name) {
    document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
    const pageObj = document.getElementById('page-' + name);
    if(pageObj) pageObj.classList.add('active');

    document.querySelectorAll('.nav-links a').forEach(a => a.classList.remove('active'));
    window.scrollTo(0,0);

    if (name === 'listings') applyFilters();
    if (name === 'agents') renderAgentsFull();
    if (name === 'home') initHome();
}

// ── INIT HOME ──────────────────────────
function initHome() {
    renderTestimonials();
    renderHomeAgents();
}

function filterHome(btn, filterType) {
    document.querySelectorAll('.filter-bar .filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    const cards = document.querySelectorAll('#home-prop-grid .prop-card');
    cards.forEach(card => {
        const cardText = card.innerText.toLowerCase();
        if (filterType === 'all' || cardText.includes(filterType.toLowerCase())) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
}

function renderTestimonials() {
    const grid = document.getElementById('testi-grid');
    if(!grid) return;
    grid.innerHTML = TESTIMONIALS.map(t => `
    <div class="testi-card">
        <div class="testi-stars">${'★'.repeat(t.stars)}</div>
        <p class="testi-text">"${t.text}"</p>
        <div class="testi-author">
            <img src="${t.img}" alt="${t.name}"/>
            <div>
                <div class="testi-name">${t.name}</div>
                <div class="testi-role">${t.role}</div>
            </div>
        </div>
    </div>`).join('');
}

function renderHomeAgents() {
    const grid = document.getElementById('home-agents-grid');
    if(!grid) return;
    grid.innerHTML = AGENTS.slice(0,4).map((a,i) => `
    <div class="agent-card" style="animation-delay:${i*0.06}s">
        <div class="agent-card-img"><img src="${a.img}" alt="${a.name}" loading="lazy"/></div>
        <div class="agent-card-body">
            <div class="agent-card-name">${a.name}</div>
            <div class="agent-card-role">${a.title}</div>
            <div style="font-size:.78rem;color:var(--ink4);margin-bottom:14px">${a.agency} · ${a.years} yrs exp</div>
        </div>
    </div>`).join('');
}

// 🔥 THE FACE ROUTER 🔥
function getAgentForSeller(sellerName) {
    if (!sellerName || sellerName === "null") return AGENTS[0];
    let name = sellerName.toLowerCase();

    // Force specific faces based on test accounts
    if (name.includes('silva') && !name.includes('kavindi')) return AGENTS[3]; // Nuwan face
    if (name.includes('kavindi')) return AGENTS[2]; // Kavindi face
    if (name.includes('dinesh')) return AGENTS[5];  // Rizwan face
    if (name.includes('rizwan')) return AGENTS[1];

    // Default dynamic face for anyone else
    let sum = 0;
    for(let i = 0; i < name.length; i++) sum += name.charCodeAt(i);
    return AGENTS[sum % AGENTS.length];
}

// ── LISTINGS ENGINE ──────────────────────
function toggleChip(btn, category, value) {
    let siblings = btn.parentElement.querySelectorAll('.filter-chip');
    siblings.forEach(s => s.classList.remove('active'));
    btn.classList.add('active');
    currentFilters[category] = value;
    applyFilters();
}

function setBeds(btn, value) {
    let siblings = btn.parentElement.querySelectorAll('.bed-btn');
    siblings.forEach(s => s.classList.remove('active'));
    btn.classList.add('active');
    currentFilters.beds = value;
    applyFilters();
}

function resetFilters() {
    currentFilters = { status: 'all', type: 'all', city: 'all', beds: 'any', minPrice: '', maxPrice: '' };
    document.querySelectorAll('.filter-chip, .bed-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.filter-chip[onclick*="\'all\'"]').forEach(c => c.classList.add('active'));
    document.querySelectorAll('.bed-btn[onclick*="\'any\'"]').forEach(b => b.classList.add('active'));
    if(document.getElementById('filterMinPrice')) document.getElementById('filterMinPrice').value = '';
    if(document.getElementById('filterMaxPrice')) document.getElementById('filterMaxPrice').value = '';
    applyFilters();
}

function applyFilters() {
    if(typeof properties === 'undefined') return;

    const minInput = document.getElementById('filterMinPrice');
    const maxInput = document.getElementById('filterMaxPrice');
    if (minInput) currentFilters.minPrice = minInput.value;
    if (maxInput) currentFilters.maxPrice = maxInput.value;

    let filtered = properties.filter(p => {
        let matchStatus = currentFilters.status === 'all' || (p.status && p.status.toLowerCase() === currentFilters.status.toLowerCase());
        let matchType = currentFilters.type === 'all' || (p.type && p.type.toLowerCase() === currentFilters.type.toLowerCase());
        let matchCity = currentFilters.city === 'all' || (p.location && p.location.toLowerCase().includes(currentFilters.city.toLowerCase()));

        let matchPrice = true;
        let numPrice = typeof p.price === 'string' ? parseInt(p.price.replace(/[^0-9]/g, '')) : p.price;
        if (currentFilters.minPrice && numPrice < parseInt(currentFilters.minPrice)) matchPrice = false;
        if (currentFilters.maxPrice && numPrice > parseInt(currentFilters.maxPrice)) matchPrice = false;

        return matchStatus && matchType && matchCity && matchPrice;
    });

    renderListings(filtered);
}

function renderListings(list) {
    const grid = document.getElementById('listings-grid');
    const countEl = document.getElementById('listings-count');
    if (!grid) return;

    if (list.length === 0) {
        grid.innerHTML = '<p style="grid-column: 1/-1; text-align: center; color: var(--ink3); padding: 40px; font-weight: 500;">No properties match your filters.</p>';
        if (countEl) countEl.innerText = "0";
        return;
    }

    grid.innerHTML = list.map(p => {
        const displayPrice = typeof p.price === 'number' ? p.price.toLocaleString() : p.price;
        const safeStatus = p.status ? p.status.toLowerCase() : 'sale';

        // Face Router execution
        const realSeller = (p.seller && p.seller !== "null" && p.seller.trim() !== "") ? p.seller : "Verified Seller";
        const agent = getAgentForSeller(realSeller);

        return `
        <div class="prop-card" onclick="openDetail('${p.id}')" style="cursor: pointer;">
            <div class="prop-img-wrap">
                <img src="${p.image}" alt="${p.title}">
                <div class="prop-tags">
                    <span class="prop-tag tag-sale">${safeStatus === 'rent' ? 'For Rent' : 'For Sale'}</span>
                </div>
            </div>
            <div class="prop-body">
                <div class="prop-price">$${displayPrice} ${safeStatus === 'rent' ? '<span style="font-size:0.6em; color:var(--ink4)">/mo</span>' : ''}</div>
                <div class="prop-name">${p.title}</div>
                <div class="prop-loc">📍 ${p.location}</div>
                <div class="prop-divider"></div>
                <div class="prop-meta">
                    <div class="prop-meta-item">🛏️ 3 Beds</div>
                    <div class="prop-meta-item">🛁 2 Baths</div>
                    <div class="prop-meta-item">👁️ 342 Views</div>
                </div>
                <div class="prop-agent-row">
                    <div class="prop-agent">
                        <img src="${agent.img}" alt="Agent">
                        <div class="prop-agent-name">${realSeller}</div>
                    </div>
                </div>
            </div>
        </div>`;
    }).join('');

    if (countEl) countEl.innerText = list.length;
}

// ── DETAIL PAGE ENGINE ──────────────────────
function openDetail(id) {
    if(typeof properties === 'undefined') return;
    const p = properties.find(prop => String(prop.id) === String(id));
    if (!p) { console.error("Property not found!"); return; }

    document.getElementById('detail-main-img').src = p.image;
    document.getElementById('detail-title').innerText = p.title;
    document.getElementById('detail-address-text').innerText = p.location;

    const displayPrice = typeof p.price === 'number' ? p.price.toLocaleString() : p.price;
    document.getElementById('detail-price').innerText = "$" + displayPrice;

    const favInput = document.getElementById('fav-property-id');
    if (favInput) favInput.value = String(id);

    // Face Router Execution for Details Page
    const realSeller = (p.seller && p.seller !== "null" && p.seller.trim() !== "") ? p.seller : "Verified Seller";
    const agent = getAgentForSeller(realSeller);

    document.getElementById('detail-agent-img').src = agent.img;
    if(document.getElementById('detail-agent-name')) document.getElementById('detail-agent-name').innerText = realSeller;

    setTimeout(() => {
        if(document.getElementById('inq-prop-id')) document.getElementById('inq-prop-id').value = String(id);
        if(document.getElementById('inq-prop-title')) document.getElementById('inq-prop-title').value = p.title;
        if(document.getElementById('inq-agent-name')) document.getElementById('inq-agent-name').value = realSeller;
    }, 400);

    showPage('detail');
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// ── AUTH ROLE SELECTOR ENGINE ─────────────────────────
function selectRole(btn, role) {
    document.querySelectorAll('.role-btn').forEach(b => b.classList.remove('selected'));
    btn.classList.add('selected');
    const hiddenInput = document.getElementById('hiddenRole');
    if(hiddenInput) hiddenInput.value = role;
}

// ── UI HELPERS ───────────────────────────────
function showToast(icon, msg, isError=false) {
    const t = document.getElementById('toast');
    if(!t) return;
    document.getElementById('toast-icon').textContent = icon;
    document.getElementById('toast-msg').textContent = msg;
    t.style.background = isError ? '#c53030' : 'var(--ink)';
    t.classList.add('show');
    setTimeout(() => t.classList.remove('show'), 3000);
}

window.addEventListener('scroll', () => {
    const nav = document.getElementById('navbar');
    if(nav) nav.classList.toggle('scrolled', scrollY > 20);
});

// ── SYSTEM BOOT ─────────────────────────────────
document.addEventListener("DOMContentLoaded", () => {
    initHome();

    // Force the Dark Mode button to listen for clicks safely!
    const themeBtn = document.getElementById('theme-toggle');
    if (themeBtn) {
        themeBtn.onclick = toggleTheme;
    }
});