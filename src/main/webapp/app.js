// ── DARK MODE LOGIC ───────────────────────────────────
if (window.localStorage.getItem('nestiq_theme') === 'dark') {
    window.document.documentElement.setAttribute('data-theme', 'dark');
    window.document.addEventListener("DOMContentLoaded", () => {
        const btn = window.document.getElementById('theme-toggle');
        if(btn) btn.textContent = '☀️';
    });
}

function toggleTheme() {
    const html = window.document.documentElement;
    const btn = window.document.getElementById('theme-toggle');
    if (html.getAttribute('data-theme') === 'dark') {
        html.removeAttribute('data-theme');
        window.localStorage.setItem('nestiq_theme', 'light');
        if(btn) btn.textContent = '🌙';
    } else {
        html.setAttribute('data-theme', 'dark');
        window.localStorage.setItem('nestiq_theme', 'dark');
        if(btn) btn.textContent = '☀️';
    }
}

// ── DATA ──────────────────────────────────────────────
// Sri Lankan names + Sri Lanka-focused face photos (Unsplash source query).
// (Using `source.unsplash.com` keeps it simple without needing local image assets.)
const AGENTS = [
    { id: 1, name: "Senuri Fernando", title: "Senior Luxury Specialist", agency: "Nestiq Colombo 07", phone: "+94 77 101 2020", email: "s.fernando@nestiq.lk", img: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=600&q=80&fit=crop", listings: 24, sold: 187, rating: 4.9, spec: "luxury", years: 12 },
    { id: 2, name: "Dinesh Perera", title: "Investment & Commercial", agency: "Nestiq Kandy", phone: "+94 71 202 3030", email: "d.perera@nestiq.lk", img: "https://images.unsplash.com/photo-1560250097-0b93528c311a?w=600&q=80&fit=crop", listings: 18, sold: 143, rating: 4.8, spec: "investment", years: 9 },
    { id: 3, name: "Kavindi De Silva", title: "Residential Expert", agency: "Nestiq Kurunegala", phone: "+94 70 303 4040", email: "k.desilva@nestiq.lk", img: "https://images.unsplash.com/photo-1580489944761-15a19d654956?w=600&q=80&fit=crop", listings: 31, sold: 210, rating: 4.9, spec: "residential", years: 15 },
    { id: 4, name: "Nuwan Rathnayake", title: "Commercial Specialist", agency: "Nestiq Galle", phone: "+94 76 404 5050", email: "n.rathnayake@nestiq.lk", img: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=600&q=80&fit=crop", listings: 12, sold: 98, rating: 4.7, spec: "commercial", years: 7 },
    { id: 5, name: "Anjali Jayasooriya", title: "Luxury Condo Specialist", agency: "Nestiq Mount Lavinia", phone: "+94 77 505 6060", email: "a.jayasooriya@nestiq.lk", img: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=600&q=80&fit=crop", listings: 20, sold: 156, rating: 4.8, spec: "luxury", years: 10 },
    { id: 6, name: "Mohammed Rizwan", title: "Investment Properties", agency: "Nestiq Negombo", phone: "+94 75 606 7070", email: "m.rizwan@nestiq.lk", img: "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=600&q=80&fit=crop", listings: 15, sold: 121, rating: 4.7, spec: "investment", years: 8 },
    { id: 7, name: "Thilini Wijeratne", title: "Residential Advisor", agency: "Nestiq Malabe", phone: "+94 76 909 1010", email: "t.wijeratne@nestiq.lk", img: "https://images.unsplash.com/photo-1554151228-14d9def656e4?w=600&q=80&fit=crop", listings: 22, sold: 132, rating: 4.8, spec: "residential", years: 8 },
    { id: 8, name: "Isuru Bandara", title: "Commercial Leasing", agency: "Nestiq Colombo 03", phone: "+94 77 808 1212", email: "i.bandara@nestiq.lk", img: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80&fit=crop", listings: 14, sold: 76, rating: 4.6, spec: "commercial", years: 6 },
    { id: 9, name: "Ruwan Gunawardena", title: "Luxury Beachfront Expert", agency: "Nestiq Bentota", phone: "+94 77 111 2222", email: "r.gunawardena@nestiq.lk", img: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=600&q=80&fit=crop", listings: 18, sold: 112, rating: 4.9, spec: "luxury", years: 11 },
    { id: 10, name: "Nilanthi Wickramasinghe", title: "Investment Strategist", agency: "Nestiq Colombo 01", phone: "+94 71 333 4444", email: "n.wickramasinghe@nestiq.lk", img: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=600&q=80&fit=crop", listings: 25, sold: 165, rating: 4.8, spec: "investment", years: 14 },
    { id: 11, name: "Prasanna Kumarage", title: "Residential Sales Head", agency: "Nestiq Maharagama", phone: "+94 76 555 6666", email: "p.kumarage@nestiq.lk", img: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=600&q=80&fit=crop", listings: 40, sold: 280, rating: 5.0, spec: "residential", years: 18 },
    { id: 12, name: "Kusal Janith", title: "Commercial Portfolio Manager", agency: "Nestiq Ratnapura", phone: "+94 70 777 8888", email: "k.janith@nestiq.lk", img: "https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?w=600&q=80&fit=crop", listings: 10, sold: 65, rating: 4.7, spec: "commercial", years: 5 }
];

const TESTIMONIALS = [
    { name:"Chamathka Silva", role:"Bought in Colombo 07", img:"https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&q=80", text:"Nestiq made finding our dream apartment effortless. Senuri guided us with exceptional patience and expertise — we couldn't be happier.", stars:5 },
    { name:"Kasun & Tharushi", role:"Sold in Kurunegala", img:"https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=100&q=80", text:"Sold our villa in under two weeks for above the asking price. Dinesh's market knowledge and professional network are truly unmatched.", stars:5 },
    { name:"Ashan Dias", role:"Renting in Malabe", img:"https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80", text:"The entire process was transparent, fast and stress-free. Kavindi found us the perfect annex near the campus. Exceptional service from start to finish.", stars:5 }
];

let currentFilters = { soldStatus: 'all', status: 'all', type: 'all', city: 'all', beds: 'any', priceMin: 0, priceMax: Infinity };
// Removed: Unused variable savedIds

// ── ROUTER ────────────────────────────
function showPage(name) {
    document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
    const pageObj = document.getElementById('page-' + name);
    if(pageObj) pageObj.classList.add('active');

    document.querySelectorAll('.nav-links a').forEach(a => a.classList.remove('active'));
    const navItem = document.getElementById('nav-' + name);
    if(navItem) navItem.classList.add('active');
    window.scrollTo(0,0);

    if (name === 'listings') applyFilters();
    if (name === 'agents') renderAgentsFull();
    if (name === 'home') initHome();
}

// ── HOME PAGE FILTER STATE ──────────────────────────
let homeFilterType = 'all';
let homeSearchCity = '';

// ── INIT HOME ──────────────────────────
function initHome() {
    renderTestimonials();
    renderHomeAgents();
    homeFilterType = 'all';
    homeSearchCity = '';
    renderHomeFeaturedProperties();
}

function filterHome(btn, filterType) {
    document.querySelectorAll('.filter-bar .filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    homeFilterType = filterType;
    renderHomeFeaturedProperties();
}

function searchHomeByCity(searchTerm, searchType) {
    homeSearchCity = searchTerm.toLowerCase().trim();
    homeFilterType = searchType.toLowerCase().trim();
    renderHomeFeaturedProperties();

    const messageContainer = document.getElementById('search-message-container');
    if (messageContainer) {
        if (homeSearchCity === '') {
            messageContainer.innerHTML = '';
            return;
        }

        const cityProperties = (window.properties || []).filter(p => p.location && p.location.toLowerCase().includes(homeSearchCity));
        if (cityProperties.length > 0) {
            const typeProperties = cityProperties.filter(p => homeFilterType === '' || (p.type && p.type.toLowerCase() === homeFilterType));
            if (typeProperties.length > 0) {
                messageContainer.innerHTML = `<div class="search-message" style="color: var(--green); background-color: var(--green-l);">Properties Found</div>`;
            } else {
                messageContainer.innerHTML = `<div class="search-message" style="color: var(--amber); background-color: var(--amber-l);">No Properties found with the category of ${searchType}</div>`;
            }
        } else {
            messageContainer.innerHTML = `<div class="search-message" style="color: var(--red); background-color: var(--amber-l);">No Properties found in the city of ${searchTerm}</div>`;
        }
    }
}

function renderHomeFeaturedProperties() {
    const grid = document.getElementById('home-prop-grid');
    if (!grid || typeof window.properties === 'undefined') return;

    // Filter properties based on both the type filter and city search
    let filtered = (window.properties || []).filter(p => {
        // Combined filter for status (sale/rent) and type (apartment/house)
        const statusOrType = homeFilterType.toLowerCase();
        let matchFilter;
        if (statusOrType === 'all' || statusOrType === '') {
            matchFilter = true;
        } else if (statusOrType === 'sale' || statusOrType === 'rent') {
            // The filter is for status — exact match to avoid 'sold'.includes('sale') false positive
            if (statusOrType === 'sale') {
                matchFilter = p.status && p.status.toLowerCase() === 'for sale';
            } else {
                matchFilter = p.status && p.status.toLowerCase().includes('rent');
            }
        } else {
            // The filter is for property type
            matchFilter = p.type && p.type.toLowerCase().includes(statusOrType);
        }

        // City search filter
        let matchCity = homeSearchCity === '' || (p.location && p.location.toLowerCase().includes(homeSearchCity));

        return matchFilter && matchCity;
    });

    // Re-render the grid
    if (filtered.length === 0) {
        grid.innerHTML = '<p style="grid-column: 1 / -1; text-align: center; color: var(--ink3); padding: 40px;">No properties match your search.</p>';
        return;
    }

    grid.innerHTML = filtered.map(p => {
        const displayPrice = typeof p.price === 'number' ? p.price.toLocaleString() : p.price;
        const safeStatus = p.status ? p.status.toLowerCase() : 'sale';
        const isSold = safeStatus === 'sold';
        const isRent = !isSold && safeStatus.includes('rent');
        const tagClass = isSold ? 'tag-sold' : (isRent ? 'tag-rent' : 'tag-sale');
        const tagText = isSold ? 'Sold' : (isRent ? 'For Rent' : 'For Sale');
        const rentSuffixSimple = isRent ? '<span style="font-size:0.58em;font-weight:400;color:var(--ink3)">/day</span>' : '';

        return `
        <div class="prop-card${isSold ? ' prop-card--sold' : ''}" onclick="openDetail('${p.id}')" style="cursor: pointer;">
            <div class="prop-img-wrap">
                <img src="${p.image}" alt="${p.title}"/>
                <div class="prop-tags">
                    <span class="prop-tag ${tagClass}">${tagText}</span>
                </div>
                ${window.currentRole === 'BUYER' && !isSold ? `
                <button class="heart-btn${window.favPropertyIds && window.favPropertyIds.has(p.id) ? ' heart-btn--saved' : ''}"
                    title="${window.favPropertyIds && window.favPropertyIds.has(p.id) ? 'Remove from Favorites' : 'Save to Favorites'}"
                    onclick="event.stopPropagation(); toggleFavorite(this, '${p.id}')">&#10084;</button>` : ''}
            </div>
            <div class="prop-body">
                ${isSold ? '<span class="sold-tape">🔴 Sold</span>' : ''}
                <div class="prop-price">LKR ${displayPrice} ${rentSuffixSimple}</div>
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
        </div>`;
    }).join('');
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
    grid.innerHTML = AGENTS.slice(0, 4).map((a, i) => `
    <div class="agent-card" style="animation-delay:${i*0.06}s" onclick="openAgentModal(${a.id})" role="button" tabindex="0" aria-label="View profile of ${a.name}">
        <div class="agent-card-img"><img src="${a.img}" alt="${a.name}" loading="lazy"/></div>
        <div class="agent-card-body">
            <div class="agent-card-name">${a.name}</div>
            <div class="agent-card-role">${a.title}</div>
            <div style="font-size:.78rem;color:var(--ink4);margin-bottom:14px">${a.agency} · ${a.years} yrs exp</div>
            <div style="font-size:.75rem;color:var(--accent);font-weight:500;text-align:center;padding-top:10px;border-top:1px solid var(--line2);">View Profile →</div>
        </div>
    </div>`).join('');
}

// ── AGENTS PAGE ENGINE ──────────────────────
let currentAgentFilter = 'all';

function agentCardTemplate(a, i = 0) {
    const safeRating = (typeof a.rating === 'number') ? a.rating.toFixed(1) : (a.rating || '4.8');
    return `
    <div class="agent-card" style="animation-delay:${i * 0.05}s" onclick="openAgentModal(${a.id})" role="button" tabindex="0" aria-label="View profile of ${a.name}">
        <div class="agent-card-img">
            <img src="${a.img}" alt="${a.name}" loading="lazy" onerror="this.onerror=null; this.src='https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&q=80&fit=crop';"/>
        </div>
        <div class="agent-card-body">
            <div class="agent-card-name">${a.name}</div>
            <div class="agent-card-role">${a.title}</div>
            <div style="font-size:.78rem;color:var(--ink4);margin-bottom:14px">${a.agency} · ${a.years} yrs exp</div>
            <div class="agent-card-stats">
                <div class="ac-stat">
                    <div class="ac-stat-val">${a.listings}</div>
                    <div class="ac-stat-label">Listings</div>
                </div>
                <div class="ac-stat">
                    <div class="ac-stat-val">${a.sold}</div>
                    <div class="ac-stat-label">Sold</div>
                </div>
                <div class="ac-stat">
                    <div class="ac-stat-val">${safeRating}</div>
                    <div class="ac-stat-label">Rating</div>
                </div>
            </div>
            <div style="margin-top:14px;padding-top:12px;border-top:1px solid var(--line2);font-size:.75rem;color:var(--accent);font-weight:500;text-align:center;">
                View Full Profile →
            </div>
        </div>
    </div>`;
}

function renderAgentsFull() {
    const grid = document.getElementById('agents-grid');
    if (!grid) return;

    const list = (currentAgentFilter === 'all')
        ? AGENTS
        : AGENTS.filter(a => String(a.spec).toLowerCase() === String(currentAgentFilter).toLowerCase());

    if (!list || list.length === 0) {
        grid.innerHTML = `<p style="grid-column: 1/-1; text-align: center; color: var(--ink3); padding: 40px; font-weight: 500;">No agents found in this category.</p>`;
        return;
    }

    grid.innerHTML = list.map((a, i) => agentCardTemplate(a, i)).join('');
}

function filterAgents(btn, spec) {
    document.querySelectorAll('#page-agents .filter-btn').forEach(b => b.classList.remove('active'));
    if (btn) btn.classList.add('active');
    currentAgentFilter = spec || 'all';
    renderAgentsFull();
}

// ── AGENT PROFILE MODAL ──────────────────────
function openAgentModal(agentId) {
    const a = AGENTS.find(x => x.id === agentId);
    if (!a) return;

    const safeRating = (typeof a.rating === 'number') ? a.rating.toFixed(1) : (a.rating || '4.8');
    const stars = '★'.repeat(Math.round(a.rating)) + '☆'.repeat(5 - Math.round(a.rating));

    // Hero & avatar
    document.getElementById('agent-modal-hero-img').src = a.img;
    document.getElementById('agent-modal-hero-img').alt = a.name;
    document.getElementById('agent-modal-avatar').src = a.img;
    document.getElementById('agent-modal-avatar').alt = a.name;

    // Text fields
    document.getElementById('agent-modal-name').textContent = a.name;
    document.getElementById('agent-modal-role').textContent = a.title;
    document.getElementById('agent-modal-agency').textContent = a.agency;
    document.getElementById('agent-modal-rating').innerHTML =
        `<span style="letter-spacing:1px">${stars}</span><span>${safeRating} / 5.0</span>`;
    document.getElementById('agent-modal-spec-text').textContent = a.spec.charAt(0).toUpperCase() + a.spec.slice(1) + ' Specialist';

    // Stats
    document.getElementById('agent-modal-listings').textContent = a.listings;
    document.getElementById('agent-modal-sold').textContent = a.sold;
    document.getElementById('agent-modal-years').textContent = a.years;

    // Contact
    document.getElementById('agent-modal-phone').textContent = a.phone;
    const emailEl = document.getElementById('agent-modal-email');
    emailEl.textContent = a.email;
    emailEl.href = 'mailto:' + a.email;
    document.getElementById('agent-modal-call-btn').href = 'tel:' + a.phone.replace(/\s/g, '');
    document.getElementById('agent-modal-email-btn').href = 'mailto:' + a.email;

    // Open
    document.getElementById('agent-modal-overlay').classList.add('open');
    document.body.style.overflow = 'hidden';
}

function closeAgentModal() {
    document.getElementById('agent-modal-overlay').classList.remove('open');
    document.body.style.overflow = '';
}

function handleAgentModalBackdrop(e) {
    if (e.target === document.getElementById('agent-modal-overlay')) closeAgentModal();
}

// Close modal with Escape key
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeAgentModal();
});

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
let currentListingsPage = 0;
let itemsPerPage = 10;
let allFilteredProperties = [];
let currentSort = 'default';  // 'default'|'price_asc'|'price_desc'|'newest'|'views'
let currentViewMode = 'grid'; // 'grid'|'list'



function toggleChip(btn, category, value) {
    let siblings = btn.parentElement.querySelectorAll('.filter-chip');
    siblings.forEach(s => s.classList.remove('active'));
    btn.classList.add('active');
    currentFilters[category] = value;
    currentListingsPage = 0;  // Reset to first page when filtering
    applyFilters();
}

function setBeds(btn, value) {
    let siblings = btn.parentElement.querySelectorAll('.bed-btn');
    siblings.forEach(s => s.classList.remove('active'));
    btn.classList.add('active');
    currentFilters.beds = value;
    currentListingsPage = 0;  // Reset to first page when filtering
    applyFilters();
}

function resetFilters() {
    currentFilters = { soldStatus: 'all', status: 'all', type: 'all', city: 'all', beds: 'any', priceMin: 0, priceMax: Infinity };
    const priceSelect = document.getElementById('priceRangeSelect');
    if (priceSelect) priceSelect.value = 'all';
    currentListingsPage = 0;  // Reset to first page
    document.querySelectorAll('.filter-chip, .bed-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.filter-chip[onclick*="\'all\'"]').forEach(c => c.classList.add('active'));
    document.querySelectorAll('.bed-btn[onclick*="\'any\'"]').forEach(b => b.classList.add('active'));
    applyFilters();
}

// DYNAMIC PRICE RANGE BUILDER
// Reads window.properties, finds real min/max prices, and generates
// smart brackets that always cover every property - including new ones sellers add.
function buildPriceRangeDropdown() {
    const select = document.getElementById('priceRangeSelect');
    if (!select || !(window.properties && window.properties.length > 0)) return;

    const prices = window.properties.map(p => parseFloat(p.price)).filter(v => !isNaN(v));
    if (prices.length === 0) return;

    const realMin = Math.min(...prices);
    const realMax = Math.max(...prices);

    // Generate smart breakpoints based on actual property prices
    let breaks = [];

    if (realMax <= 100000) {
        // Low range properties (under $100K)
        breaks = [0, 10000, 25000, 50000, 100000];
    } else if (realMax <= 500000) {
        // Mid range properties ($100K - $500K)
        breaks = [0, 50000, 100000, 200000, 350000, 500000];
    } else if (realMax <= 1000000) {
        // High range properties ($500K - $1M)
        breaks = [0, 100000, 250000, 500000, 750000, 1000000];
    } else if (realMax <= 5000000) {
        // Luxury properties ($1M - $5M)
        breaks = [0, 250000, 500000, 1000000, 2000000, 3500000, 5000000];
    } else {
        // Ultra luxury properties (above $5M)
        breaks = [0, 500000, 1000000, 2000000, 5000000, 10000000, 20000000];
    }

    // Extend breaks if realMax exceeds current ceiling
    while (realMax > breaks[breaks.length - 1]) {
        const last = breaks[breaks.length - 1];
        const magnitude = Math.pow(10, Math.floor(Math.log10(last)));
        const next = Math.ceil((last + 1) / magnitude) * magnitude * 3;
        breaks.push(next);
    }

    // Ensure realMin is covered by starting from a break below it
    const minBreak = breaks.find(b => b <= realMin);
    if (minBreak && minBreak > 0) {
        breaks.unshift(0);
    }

    function fmt(n) {
        if (n >= 1000000) return 'LKR ' + (n / 1000000).toLocaleString(undefined, {maximumFractionDigits: 1}) + 'M';
        if (n >= 1000)    return 'LKR ' + Math.round(n / 1000) + 'K';
        return 'LKR ' + n.toLocaleString();
    }

    // Remember current selection so it survives a rebuild
    const prevValue = select.value;

    select.innerHTML = '<option value="all">All Prices</option>';

    // Count properties in each range to show count
    for (let i = 0; i < breaks.length - 1; i++) {
        const lo = breaks[i];
        const hi = breaks[i + 1];
        // Count properties in this range
        const count = prices.filter(price => price >= lo && price < hi).length;
        if (count === 0) continue; // Skip empty ranges

        const label = lo === 0 ? 'Under ' + fmt(hi) : fmt(lo) + ' - ' + fmt(hi);
        const opt = document.createElement('option');
        opt.value = lo + '|' + hi;
        opt.textContent = label + ' (' + count + ' props)';
        select.appendChild(opt);
    }

    // 'Above X' bracket for anything at or above the last break
    const topBreak = breaks[breaks.length - 1];
    const aboveCount = prices.filter(price => price >= topBreak).length;
    if (aboveCount > 0) {
        const opt = document.createElement('option');
        opt.value = topBreak + '|max';
        opt.textContent = 'Above ' + fmt(topBreak) + ' (' + aboveCount + ' props)';
        select.appendChild(opt);
    }

    // Restore previous selection if it still exists
    if (prevValue && select.querySelector('option[value="' + prevValue + '"]')) {
        select.value = prevValue;
    }

    console.log('Price range dropdown built with ' + (select.options.length - 1) + ' ranges');
    console.log('Price range: ' + fmt(realMin) + ' to ' + fmt(realMax));
}

// Public function to rebuild price ranges (called when new properties are added)
window.rebuildPriceRanges = function() {
    if (typeof buildPriceRangeDropdown === 'function') {
        buildPriceRangeDropdown();
        console.log('Price ranges rebuilt automatically');
    }
};

function applyPriceRange(value) {
    if (value === 'all') {
        currentFilters.priceMin = 0;
        currentFilters.priceMax = Infinity;
    } else {
        const parts = value.split('|');
        currentFilters.priceMin = parseFloat(parts[0]);
        currentFilters.priceMax = parts[1] === 'max' ? Infinity : parseFloat(parts[1]);
    }
    applyFilters();
}

function applyFilters() {
    if(typeof window.properties === 'undefined') return;

    let filtered = (window.properties || []).filter(p => {
        // STATUS (Sold / Booked / Available / All) filter
        let matchSoldStatus = true;
        if (currentFilters.soldStatus !== 'all') {
            const s = p.status ? p.status.trim().toLowerCase() : '';
            const isBookedRental = s === 'sold' && window.propertyBookingEndDates && window.propertyBookingEndDates[String(p.id)];

            if (currentFilters.soldStatus === 'sold') {
                // Permanently sold (NOT booked)
                matchSoldStatus = s === 'sold' && !isBookedRental;
            } else if (currentFilters.soldStatus === 'booked') {
                // Booked rentals (sold status with active booking)
                matchSoldStatus = isBookedRental;
            } else if (currentFilters.soldStatus === 'available') {
                // Available (not sold at all)
                matchSoldStatus = s !== 'sold';
            }
        }

        let matchStatus = currentFilters.status === 'all' || (() => {
            const s = p.status ? p.status.toLowerCase() : '';
            if (currentFilters.status === 'sale') return s === 'for sale';
            if (currentFilters.status === 'rent') return s.includes('rent');
            return s.includes(currentFilters.status.toLowerCase());
        })();
        let matchType = currentFilters.type === 'all' || (p.type && p.type.toLowerCase() === currentFilters.type.toLowerCase());
        let matchCity = currentFilters.city === 'all' || (p.location && p.location.toLowerCase().includes(currentFilters.city.toLowerCase()));

        // Price Range Filtering
        let matchPrice = true;
        let numPrice = typeof p.price === 'string' ? parseFloat(p.price.replace(/[^0-9.]/g, '')) : parseFloat(p.price);
        if (!isNaN(numPrice)) {
            if (currentFilters.priceMin > 0 && numPrice < currentFilters.priceMin) matchPrice = false;
            if (currentFilters.priceMax !== Infinity && numPrice > currentFilters.priceMax) matchPrice = false;
        }

        // Bedrooms Filtering
        let matchBeds = true;
        if (currentFilters.beds !== 'any') {
            let minBeds = parseInt(currentFilters.beds, 10);
            let propBeds = parseInt(p.bedrooms, 10);
            matchBeds = propBeds >= minBeds;
        }

        return matchSoldStatus && matchStatus && matchType && matchCity && matchPrice && matchBeds;
    });

    allFilteredProperties = sortProperties(filtered);
    currentListingsPage = 0;
    renderListings();
}

function renderListings() {
    const grid = document.getElementById('listings-grid');
    const countEl = document.getElementById('listings-count');
    const loadMoreBtn = document.getElementById('listings-load-more');
    if (!grid) return;

    if (allFilteredProperties.length === 0) {
        grid.innerHTML = '<p style="grid-column: 1/-1; text-align: center; color: var(--ink3); padding: 40px; font-weight: 500;">No properties match your filters.</p>';
        if (countEl) countEl.innerText = "0";
        if (loadMoreBtn) loadMoreBtn.style.display = 'none';
        return;
    }

    // Calculate pagination
    const startIndex = currentListingsPage * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const paginatedList = allFilteredProperties.slice(startIndex, endIndex);

    // Build HTML for current page – supports grid and list view modes
    const html = paginatedList.map(p => {
        const displayPrice = typeof p.price === 'number' ? p.price.toLocaleString() : p.price;
        const safeStatus   = p.status ? p.status.toLowerCase() : 'sale';
        const isSold       = safeStatus === 'sold';
        const isRent       = !isSold && safeStatus.includes('rent');
        const isBookedRental = isSold && window.propertyBookingEndDates && window.propertyBookingEndDates[String(p.id)];
        const realSeller   = (p.seller && p.seller !== "null" && p.seller.trim() !== "") ? p.seller : "Verified Seller";
        const agent        = getAgentForSeller(realSeller);
        const typeLabel    = p.type ? p.type.charAt(0).toUpperCase() + p.type.slice(1) : 'Property';
        const statusTag    = isBookedRental ? 'Booked' : (isSold ? 'Sold' : (isRent ? 'For Rent' : 'For Sale'));
        const tagClass     = isBookedRental ? 'tag-booked' : (isSold ? 'tag-sold' : (isRent ? 'tag-rent' : 'tag-sale'));
        const rentSuffix   = isRent ? '<span style="font-size:0.58em;font-weight:400;color:var(--ink4)">/day</span>' : '';

        // Build overlay HTML based on sold/booked status
        let overlayHTML = '';
        if (isSold) {
            if (isBookedRental) {
                overlayHTML = `<div class="sold-img-overlay booked-overlay"><div class="sold-title">BOOKED</div><div class="sold-message">This property has been booked until <strong style="color:#fff;font-size:1.1rem;">${window.propertyBookingEndDates[String(p.id)]}</strong></div></div>`;
            } else {
                overlayHTML = '<div class="sold-img-overlay"><div class="sold-title">SOLD</div><div class="sold-message">This property has been sold and is no longer available</div></div>';
            }
        }

        // Build tape/badge HTML
        let tapeHTML = '';
        if (isBookedRental) {
            tapeHTML = '<span class="sold-tape" style="background:rgba(16,185,129,0.15);color:#10b981;border-bottom:2px solid #10b981;">✅ Booked</span>';
        } else if (isSold) {
            tapeHTML = '<span class="sold-tape"> Sold</span>';
        }

        // Build list tape HTML
        let listTapeHTML = '';
        if (isBookedRental) {
            listTapeHTML = '<span class="plc-sold-tape" style="background:rgba(16,185,129,0.15);color:#10b981;border-bottom:2px solid #10b981;">✅ Booked</span>';
        } else if (isSold) {
            listTapeHTML = '<span class="plc-sold-tape"> Sold</span>';
        }

        // Build tag style for booked rental
        const bookedTagStyle = isBookedRental ? ' style="background:rgba(16,185,129,0.15);color:#10b981;border:1px solid rgba(16,185,129,0.3);"' : '';

        if (currentViewMode === 'list') {
            // ── LIST ROW ──
            return `<div class="prop-card prop-card--list${isSold ? ' prop-card--sold' : ''}" onclick="openDetail('${p.id}')">
                <div class="plc-img">
                    <img src="${p.image}" alt="${p.title}">
                    <span class="prop-tag ${tagClass} plc-tag"${bookedTagStyle}>${statusTag}</span>
                    ${overlayHTML}
                </div>
                <div class="plc-body">
                    <div class="plc-type">🏠 ${typeLabel}</div>
                    <div class="plc-title">${p.title}</div>
                    <div class="plc-loc">📍 ${p.location}</div>
                    <div class="plc-meta">
                        <span>🛏️ ${p.bedrooms} Beds</span>
                        <span>🛁 ${p.bathrooms} Baths</span>
                        <span>👁️ ${p.views || '—'} Views</span>
                    </div>
                </div>
                <div class="plc-right">
                    ${listTapeHTML}
                    <div class="plc-price">LKR ${displayPrice}${rentSuffix}</div>
                    <div class="plc-agent">
                        <img src="${agent.img}" alt="${realSeller}">
                        <span>${realSeller}</span>
                    </div>
                </div>
            </div>`;
        }

        // ── GRID CARD ──
        return `<div class="prop-card${isSold ? ' prop-card--sold' : ''}" onclick="openDetail('${p.id}')" style="cursor:pointer;">
            <div class="prop-img-wrap">
                <img src="${p.image}" alt="${p.title}">
                <div class="prop-tags">
                    <span class="prop-tag ${tagClass}"${bookedTagStyle}>${statusTag}</span>
                </div>
                ${window.currentRole === 'BUYER' && !isSold ? `
                <button class="heart-btn${window.favPropertyIds && window.favPropertyIds.has(p.id) ? ' heart-btn--saved' : ''}"
                    title="${window.favPropertyIds && window.favPropertyIds.has(p.id) ? 'Remove from Favorites' : 'Save to Favorites'}"
                    onclick="event.stopPropagation(); toggleFavorite(this, '${p.id}')">&#10084;</button>` : ''}
                ${overlayHTML}
            </div>
            <div class="prop-body">
                ${tapeHTML}
                <div class="prop-price">LKR ${displayPrice} ${rentSuffix}</div>
                <div class="prop-name">${p.title}</div>
                <div style="display:flex;align-items:center;gap:8px;margin-bottom:6px;">
                    <span style="font-size:0.78rem;font-weight:600;color:var(--accent);background:var(--accent-l);padding:3px 10px;border-radius:6px;text-transform:capitalize;">🏠 ${typeLabel}</span>
                </div>
                <div class="prop-loc">📍 ${p.location}</div>
                <div class="prop-divider"></div>
                <div class="prop-meta">
                    <div class="prop-meta-item">🛏️ ${p.bedrooms} Beds</div>
                    <div class="prop-meta-item">🛁 ${p.bathrooms} Baths</div>
                    <div class="prop-meta-item">👁️ ${p.views || '—'} Views</div>
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

    if (startIndex === 0) {
        // First page - replace content
        grid.innerHTML = html;
    } else {
        // Load more - append content
        grid.innerHTML += html;
    }

    if (countEl) countEl.innerText = String(allFilteredProperties.length); // Fixed: Explicitly convert to string

    // Show/hide Load More button
    if (loadMoreBtn) {
        if (endIndex >= allFilteredProperties.length) {
            loadMoreBtn.style.display = 'none';
        } else {
            loadMoreBtn.style.display = 'flex';
        }
    }
}

function loadMoreListings() {
    currentListingsPage++;
    renderListings();
}

// ── DETAIL PAGE ENGINE ──────────────────────
function openDetail(id) {
    if(typeof window.properties === 'undefined') return;
    const p = (window.properties || []).find(prop => String(prop.id) === String(id));
    if (!p) { console.error("Property not found!"); return; }

    fetch('trackView', {
        method: 'POST',
        body: new URLSearchParams({ propertyId: id })
    }).catch(() => {});

    document.getElementById('detail-main-img').src = p.image;
    document.getElementById('detail-title').innerText = p.title;
    document.getElementById('detail-address-text').innerText = p.location;

    const displayPrice = typeof p.price === 'number' ? p.price.toLocaleString() : p.price;
    const isSoldDetail = p.status && String(p.status).toLowerCase() === 'sold';
    const isRentDetail = !isSoldDetail && p.status && String(p.status).toLowerCase().includes('rent');
    document.getElementById('detail-price').innerHTML = "LKR " + displayPrice + (isRentDetail ? ' <span style="font-size:0.55em;font-weight:400;color:var(--ink4)">/day</span>' : '');
    const priceLabelEl = document.getElementById('detail-price-label');
    if (priceLabelEl) priceLabelEl.innerText = isRentDetail ? 'Daily Rental Price' : (isSoldDetail ? 'Sold Price' : 'Listing Price');

    const favInput = document.getElementById('fav-property-id');
    if (favInput) favInput.value = String(id);

    // Hide "Save to Dashboard" button for sold properties
    const saveBtnContainer = document.getElementById('fav-property-id');
    if (saveBtnContainer) {
        const saveForm = saveBtnContainer.closest('form');
        if (saveForm) {
            saveForm.style.display = isSoldDetail ? 'none' : 'block';
        }
    }

    // Set description
    const detailDescEl = document.getElementById('detail-desc');
    if (detailDescEl) {
        detailDescEl.innerText = p.description && p.description.trim() !== "" ? p.description : "No Description yet..";
    }

    // Set Premium Amenities based on property type
    const detailFeaturesEl = document.getElementById('detail-features');
    if (detailFeaturesEl) {
        const propertyType = (p.type || '').toLowerCase();
        let amenitiesHTML = '';

        if (propertyType === 'villa') {
            // Villa-specific premium amenities
            amenitiesHTML = `
                <div>✔️ Private Swimming Pool</div>
                <div>✔️ Landscaped Garden</div>
                <div>✔️ Outdoor BBQ Area</div>
                <div>✔️ Smart Home Automation</div>
                <div>✔️ 3-Car Garage</div>
                <div>✔️ Home Theater Room</div>
                <div>✔️ Wine Cellar</div>
                <div>✔️ Gym & Spa Suite</div>
            `;
        } else if (propertyType === 'apartment') {
            // Apartment-specific premium amenities
            amenitiesHTML = `
                <div>✔️ Fully Air Conditioned</div>
                <div>✔️ Imported Teak Floors</div>
                <div>✔️ Smart Home Security</div>
                <div>✔️ Backup Solar Power</div>
                <div>✔️ Infinity Pool Access</div>
                <div>✔️ 2-Car Private Parking</div>
            `;
        } else if (propertyType === 'house') {
            // House-specific premium amenities
            amenitiesHTML = `
                <div>✔️ Central Heating System</div>
                <div>✔️ Modern Kitchen</div>
                <div>✔️ Hardwood Flooring</div>
                <div>✔️ Security Alarm System</div>
                <div>✔️ Private Backyard</div>
                <div>✔️ 2-Car Garage</div>
            `;
        } else {
            // Default amenities for other types (studio, etc.)
            amenitiesHTML = `
                <div>✔️ Fully Furnished</div>
                <div>✔️ High-Speed Internet</div>
                <div>✔️ Modern Appliances</div>
                <div>✔️ 24/7 Security</div>
                <div>✔️ Laundry Facilities</div>
                <div>✔️ Parking Space</div>
            `;
        }

        detailFeaturesEl.innerHTML = amenitiesHTML;
    }

    // Set bedrooms and bathrooms in detail-specs
    const detailSpecsEl = document.getElementById('detail-specs');
    if (detailSpecsEl) {
        detailSpecsEl.innerHTML = `
            <div class="spec-box">
                <div class="spec-icon">🛏️</div>
                <div class="spec-value">${p.bedrooms}</div>
                <div class="spec-label">Bedrooms</div>
            </div>
            <div class="spec-box">
                <div class="spec-icon">🛁</div>
                <div class="spec-value">${p.bathrooms}</div>
                <div class="spec-label">Bathrooms</div>
            </div>
            <div class="spec-box">
                <div class="spec-icon">📐</div>
                <div class="spec-value">1,200</div>
                <div class="spec-label">Sq Ft</div>
            </div>
            <div class="spec-box">
                <div class="spec-icon">🏡</div>
                <div class="spec-value">${p.type}</div>
                <div class="spec-label">Type</div>
            </div>
        `;
    }

    // Face Router Execution for Details Page
    const realSeller = (p.seller && p.seller !== "null" && p.seller.trim() !== "") ? p.seller : "Verified Seller";
    const agent = getAgentForSeller(realSeller);

    document.getElementById('detail-agent-img').src = agent.img;
    if(document.getElementById('detail-agent-name')) document.getElementById('detail-agent-name').innerText = realSeller;
    if(document.getElementById('detail-agent-title')) document.getElementById('detail-agent-title').innerText = agent.title || "Real Estate Professional";

    window.setTimeout(() => {
        if(document.getElementById('inq-prop-id')) document.getElementById('inq-prop-id').value = String(id);
        if(document.getElementById('inq-prop-title')) document.getElementById('inq-prop-title').value = p.title;
        if(document.getElementById('inq-agent-name')) document.getElementById('inq-agent-name').value = realSeller;

        // ── BOOKING FORM LOGIC ──
        const bookingForm = document.getElementById('booking-form');
        const isSold = p.status && String(p.status).toLowerCase() === 'sold';
        const isRent = !isSold && p.status && String(p.status).toLowerCase().includes('rent');
        const isBuyer = window.currentRole && String(window.currentRole).toUpperCase() === 'BUYER';

        console.log('Property Status:', p.status);
        console.log('Is Rent:', isRent);
        console.log('Is Buyer:', isBuyer);
        console.log('Current Role:', window.currentRole);

        // ── SOLD STATUS BANNER & INQUIRY FORM TOGGLE ──
        const soldBanner = document.getElementById('sold-status-banner');
        const inquiryWrapper = document.getElementById('inquiry-form-wrapper');
        if (soldBanner && inquiryWrapper) {
            if (isSold) {
                // Show sold/rented banner; hide inquiry form
                soldBanner.style.display = 'block';
                inquiryWrapper.style.display = 'none';

                // Check if this property has an active booking end date (confirmed rental)
                const bookingEndDate = window.propertyBookingEndDates && window.propertyBookingEndDates[String(id)];

                const soldIcon = document.getElementById('sold-icon');
                const soldTitleText = document.getElementById('sold-title-text');
                const soldMessage = document.getElementById('sold-message');
                const soldSellerImg = document.getElementById('sold-seller-img');
                const soldSellerName = document.getElementById('sold-seller-name');
                const soldSellerTitle = document.getElementById('sold-seller-title');

                if (bookingEndDate) {
                    // ✅ CONFIRMED RENTAL: Show green "Booked until" message
                    soldBanner.style.background = 'rgba(13,158,110,0.08)';
                    soldBanner.style.borderColor = 'rgba(13,158,110,0.3)';
                    if (soldIcon) soldIcon.innerHTML = '✅';
                    if (soldTitleText) {
                        soldTitleText.style.color = '#0d9e6e';
                        soldTitleText.innerText = 'PROPERTY BOOKED';
                    }
                    if (soldMessage) {
                        soldMessage.style.color = '#0d9e6e';
                        soldMessage.innerHTML = `This property is currently <strong>booked</strong> and unavailable for new reservations until <strong style="color:#10b981;font-size:1rem;">${bookingEndDate}</strong>. It will become available again after this date. The due date may be extended or early!`;
                    }
                    if (soldSellerImg) soldSellerImg.src = agent.img || '';
                    if (soldSellerName) soldSellerName.innerText = realSeller;
                    if (soldSellerTitle) soldSellerTitle.innerText = agent.title || 'Real Estate Professional';
                } else {
                    // 🔴 PERMANENTLY SOLD: Show red "Sold" message
                    soldBanner.style.background = 'rgba(224,40,40,0.09)';
                    soldBanner.style.borderColor = 'rgba(224,40,40,0.35)';
                    if (soldIcon) soldIcon.innerHTML = '🔴';
                    if (soldTitleText) {
                        soldTitleText.style.color = '#c0392b';
                        soldTitleText.innerText = 'PROPERTY SOLD';
                    }
                    if (soldMessage) {
                        soldMessage.style.color = '#c0392b';
                        soldMessage.innerHTML = `This property has been <strong>sold</strong> and is <strong>no longer available</strong> for purchase or booking. Contact details have been disabled.`;
                    }
                    if (soldSellerImg) soldSellerImg.src = agent.img || '';
                    if (soldSellerName) soldSellerName.innerText = realSeller;
                    if (soldSellerTitle) soldSellerTitle.innerText = agent.title || 'Real Estate Professional';
                }
            } else {
                // Not sold — hide banner, show inquiry form normally
                soldBanner.style.display = 'none';
                inquiryWrapper.style.display = 'block';
            }
        }

        if (bookingForm) {
            if (isRent && isBuyer) {
                // Show booking form for "For Rent" properties AND logged-in BUYER users
                bookingForm.style.display = 'flex';
                bookingForm.style.setProperty('display', 'flex', 'important'); // Force override any CSS
                document.getElementById('book-prop-id').value = String(id);
                document.getElementById('book-prop-title').value = p.title;
                document.getElementById('book-seller-name').value = realSeller;
                // Pass the property's daily price so the servlet can use it as penalty rate
                const bookPropPriceEl = document.getElementById('book-prop-price');
                if (bookPropPriceEl) bookPropPriceEl.value = typeof p.price === 'number' ? p.price : (parseFloat(p.price) || 0);

                // Inject penalty warning notice (only once)
                if (!document.getElementById('penalty-warning-notice')) {
                    const priceFormatted = typeof p.price === 'number'
                        ? p.price.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2})
                        : parseFloat(p.price).toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                    const notice = document.createElement('div');
                    notice.id = 'penalty-warning-notice';
                    notice.innerHTML = `⚠️ <strong>Penalty Notice:</strong> If the rental amount is not settled before the <em>Return Date</em>, a penalty of <strong>$${priceFormatted}/day</strong> will be charged automatically. This amount increases every day until full payment is received.`;
                    notice.style.cssText = 'background:rgba(224,40,40,0.08);border:1px solid rgba(224,40,40,0.3);border-radius:8px;padding:12px 14px;font-size:0.82rem;color:#c0392b;line-height:1.5;margin-top:4px;';
                    bookingForm.appendChild(notice);
                } else {
                    // Update price if notice already exists (different property opened)
                    const priceFormatted = typeof p.price === 'number'
                        ? p.price.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2})
                        : parseFloat(p.price).toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                    document.getElementById('penalty-warning-notice').innerHTML = `⚠️ <strong>Penalty Notice:</strong> If the rental amount is not settled before the <em>Return Date</em>, a penalty of <strong>$${priceFormatted}/day</strong> will be charged automatically. This amount increases every day until full payment is received.`;
                }

                // Pre-fill with user data if available
                if (window.currentUser) {
                    document.getElementById('book-buyer-name').value = window.currentUser;
                }
                if (window.currentEmail) { // Added check for window.currentEmail
                    document.getElementById('book-buyer-email').value = window.currentEmail;
                }

                // Set minimum start date to today
                const today = new Date();
                const todayStr = today.toISOString().split('T')[0];
                document.getElementById('book-start-date').min = todayStr;
                document.getElementById('book-start-date').value = todayStr;

                // Set minimum end date to tomorrow
                const tomorrow = new Date();
                tomorrow.setDate(tomorrow.getDate() + 1);
                const tomorrowStr = tomorrow.toISOString().split('T')[0];
                document.getElementById('book-return-date').min = tomorrowStr;
                document.getElementById('book-return-date').value = tomorrowStr;

                // Update end date min when start date changes
                document.getElementById('book-start-date').addEventListener('change', function() {
                    const startDate = new Date(this.value);
                    const endDateInput = document.getElementById('book-return-date');
                    const minEndDate = new Date(startDate);
                    minEndDate.setDate(minEndDate.getDate() + 1);
                    endDateInput.min = minEndDate.toISOString().split('T')[0];

                    // If current end date is before new min, update it
                    if (new Date(endDateInput.value) <= startDate) {
                        endDateInput.value = minEndDate.toISOString().split('T')[0];
                    }
                });

                console.log('✅ Booking form shown for property:', p.title);
            } else {
                // Hide booking form for "For Sale" / "Sold" properties or if not a logged-in buyer
                bookingForm.style.display = 'none';
                console.log('❌ Booking form hidden - isRent:', isRent, 'isBuyer:', isBuyer, 'isSold:', isSold);
            }
        }
    }, 400);

    showPage('detail');
    renderPropertyReviews(id);
    window.scrollTo({ top: 0, behavior: 'smooth' });
} // <--- End of openDetail function

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
    window.setTimeout(() => t.classList.remove('show'), 3000);
}

// ── BOOKING FORM VALIDATION & SUBMISSION ──────────────────────
function validateAndSubmitBooking(event) {
    event.preventDefault();

    // Check if user is logged in as a BUYER
    const isBuyer = window.currentRole && String(window.currentRole).toUpperCase() === 'BUYER';
    if (!isBuyer || !window.currentUser || window.currentUser.trim() === "") {
        alert('❌ You must be logged in as a BUYER to book a property.\n\nPlease log in first.');
        showPage('login');
        return false;
    }

    const startDateInput = document.getElementById('book-start-date');
    const returnDateInput = document.getElementById('book-return-date');
    const buyerNameInput = document.getElementById('book-buyer-name');
    const buyerEmailInput = document.getElementById('book-buyer-email');
    const bookingForm = event.target;

    // Check start date is selected
    if (!startDateInput || !startDateInput.value) {
        alert('⚠️ Please select a start date');
        return false;
    }

    // Check return date is selected
    if (!returnDateInput || !returnDateInput.value) {
        alert('⚠️ Please select an end date');
        return false;
    }

    // Check buyer name is filled
    if (!buyerNameInput || !buyerNameInput.value.trim()) {
        alert('⚠️ Please enter your full name');
        return false;
    }

    // Check buyer email is filled
    if (!buyerEmailInput || !buyerEmailInput.value.trim()) {
        alert('⚠️ Please enter your email address');
        return false;
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(buyerEmailInput.value)) {
        alert('⚠️ Please enter a valid email address');
        return false;
    }

    // Check that start date is today or later
    const selectedStartDate = new Date(startDateInput.value + 'T00:00:00');
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    if (selectedStartDate < today) {
        alert('⚠️ Start date must be today or in the future');
        return false;
    }

    // Check that end date is after start date
    const selectedEndDate = new Date(returnDateInput.value + 'T00:00:00');
    if (selectedEndDate <= selectedStartDate) {
        alert('⚠️ End date must be after start date');
        return false;
    }

    // All validations passed - submit the form
    console.log("✅ Booking form validated. Submitting...");
    bookingForm.submit();
    return false;
}


window.addEventListener('scroll', () => {
    const nav = document.getElementById('navbar');
    if(nav) nav.classList.toggle('scrolled', window.scrollY > 20);
});

// ── SYSTEM BOOT ─────────────────────────────────
window.document.addEventListener("DOMContentLoaded", () => {
    initHome();
    buildPriceRangeDropdown(); // Build price range from real property data

    // Force the Dark Mode button to listen for clicks safely!
    const themeBtn = window.document.getElementById('theme-toggle');
    if (themeBtn) {
        themeBtn.onclick = toggleTheme;
    }

    // Listen for the main hero search form submission
    const heroSearchForm = document.querySelector('.hero-search-form');
    if (heroSearchForm) {
        heroSearchForm.addEventListener('submit', function(event) {
            event.preventDefault(); // Stop the form from reloading the page
            const locationInput = heroSearchForm.querySelector('input[name="location"]');
            const typeInput = heroSearchForm.querySelector('select[name="type"]');
            if (locationInput && typeInput) {
                searchHomeByCity(locationInput.value, typeInput.value);
            }
        });
    }
});

// ── REVIEWS ENGINE ────────────────────────────
function renderPropertyReviews(propId) {
    if (!window.allReviews) return;
    const filtered = (window.allReviews || []).filter(r => String(r.propId) === String(propId));
    const container = document.getElementById('reviews-container');
    if (!container) return;

    const reviewPropIdInput = document.getElementById('review-prop-id');
    if (reviewPropIdInput) reviewPropIdInput.value = propId;

    container.innerHTML = filtered.length === 0 ?
        "<p style='color: var(--ink4); padding: 10px;'>No reviews yet.</p>" :
        filtered.map(r => {
            const isOwner = (window.currentUser && String(window.currentUser).trim() === String(r.name).trim());
            return `
            <div style="border-bottom: 1px solid var(--line); padding: 20px 0;">
                <div class="rev-header">
                    <div>
                        <strong style="color: var(--ink);">${r.name} ${r.isVerified ? '✅' : ''}</strong>
                        <div style="color: var(--amber); font-size: 0.75rem; margin-top: 2px;">${'★'.repeat(r.rating)}</div>
                    </div>
                    ${isOwner ? (
                '<div class="rev-menu-wrap">' +
                '<button class="rev-dots-btn" onclick="toggleRevMenu(event, \'' + r.id + '\')">⋮</button>' +
                '<div id="drop-' + r.id + '" class="rev-dropdown">' +
                '<button class="rev-drop-item" onclick="editReview(\'' + r.id + '\', \'' + propId + '\')">✏️ Update</button>' +
                '<button class="rev-drop-item del" onclick="deleteReview(\'' + r.id + '\', \'' + propId + '\')">🗑️ Delete</button>' +
                '</div>' +
                '</div>'
            ) : ''}
                </div>
                <div id="comment-container-${r.id}">
                    <p style="color: var(--ink3); margin-top: 10px; font-size: 0.95rem; line-height: 1.5;">${r.comment}</p>
                </div>
            </div>`;
        }).join('');
}

function toggleRevMenu(event, revId) {
    event.stopPropagation();
    document.querySelectorAll('.rev-dropdown').forEach(d => d.classList.remove('show'));
    const drop = document.getElementById('drop-' + revId);
    if (drop) drop.classList.toggle('show');
}

function deleteReview(revId, propId) {
    if (window.confirm("Delete this review forever?")) {
        const form = document.createElement('form');
        form.method = 'POST'; form.action = 'reviews';
        form.innerHTML = `
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="reviewId" value="${revId}">
            <input type="hidden" name="propertyId" value="${propId}">
        `;
        document.body.appendChild(form);
        form.submit();
    }
}

function editReview(revId, propId) {
    const container = document.getElementById('comment-container-' + revId);
    if (!container) return;
    const oldText = container.querySelector('p').innerText;

    container.innerHTML = `
        <div style="margin-top: 10px; display: flex; flex-direction: column; gap: 8px;">
            <textarea id="inline-edit-${revId}" class="contact-form-input" style="min-height: 80px; border: 1.5px solid var(--accent); color: var(--ink);">${oldText}</textarea>
            <div style="display: flex; gap: 8px;">
                <button onclick="saveInlineEdit('${revId}', '${propId}')" style="background: var(--accent); color:white; padding:6px 12px; border-radius:6px; font-size:0.75rem; font-weight:600; cursor:pointer;">Save Changes</button>
                <button onclick="window.location.reload()" style="background:none; border:1px solid var(--line); color:var(--ink3); padding:6px 12px; border-radius:6px; font-size:0.75rem; cursor:pointer;">Cancel</button>
            </div>
        </div>
    `;
    const editBox = document.getElementById('inline-edit-' + revId);
    if (editBox) editBox.focus();
}

function saveInlineEdit(revId, propId) {
    const editBox = document.getElementById('inline-edit-' + revId);
    if (!editBox) return;
    const newMsg = editBox.value;

    if (newMsg.trim() === "") {
        window.alert("Feedback cannot be empty!");
        return;
    }

    const form = document.createElement('form');
    form.method = 'POST'; form.action = 'reviews';
    form.innerHTML = `
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="reviewId" value="${revId}">
        <input type="hidden" name="propertyId" value="${propId}">
        <input type="hidden" name="comment" value="${newMsg}">
    `;
    document.body.appendChild(form);
    form.submit();
}

window.onclick = () => document.querySelectorAll('.rev-dropdown').forEach(d => d.classList.remove('show'));

function renderNotifications() {
    if (!window.allNotifications || !window.currentUser) return;

    // 1. Filter: Only show messages where I am the RECEIVER
    const myMail = (window.allNotifications || []).filter(n => n.receiver === window.currentUser);

    // Separate announcements from regular messages
    const announcementItems = myMail.filter(n => n.type === 'ANNOUNCEMENT');
    const messageItems      = myMail.filter(n => n.type !== 'ANNOUNCEMENT');

    // Expose unread announcement count for the Announcements tab badge
    window.unreadAnnouncementCount = announcementItems.length;

    // 2. Update the Bell Badge — counts ONLY regular (non-announcement) messages
    const badge = document.getElementById('notif-count');
    if (badge) {
        if (messageItems.length > 0) {
            badge.innerText = String(messageItems.length); // Fixed: Explicitly convert to string
            badge.style.display = 'flex';
        } else {
            badge.style.display = 'none';
        }
    }

    // 2b. Update the Announcements tab badge
    const annBadge = document.getElementById('ann-tab-count');
    if (annBadge) {
        if (announcementItems.length > 0) {
            annBadge.innerText = String(announcementItems.length); // Fixed: Explicitly convert to string
            annBadge.style.display = 'flex';
        } else {
            annBadge.style.display = 'none';
        }
    }

    // 3. Build the HTML for the dropdown list — announcements are NOT shown here
    const listContainer = document.getElementById('notif-list');
    if (listContainer) {
        if (messageItems.length === 0) {
            listContainer.innerHTML = '<p style="padding: 20px; text-align: center; color: var(--ink4); font-size: 0.85rem;">No new notifications</p>';
        } else {
            listContainer.innerHTML = messageItems.map(n => {
                let icon = '💬';
                if (n.type === 'INQUIRY') {
                    icon = '📩';
                } else if (n.type === 'BOOKING_CANCEL') {
                    icon = '❌';
                } else if (n.type === 'BOOKING_UPDATE') {
                    icon = '✏️';
                }
                const clickHandler = "openNotifThread('" + (n.threadId || '') + "')";
                const subLine = `<span style="font-size:0.65rem;color:var(--accent);font-weight:600;margin-top:2px;display:block;">Re: ${n.property || ''}</span>`;

                return `
                <div onclick="${clickHandler}"
                     style="padding: 12px 16px; border-bottom: 1px solid var(--line);
                            display: flex; align-items: flex-start; gap: 12px; cursor: pointer;
                            transition: background 0.15s;"
                     onmouseover="this.style.background='var(--bg2)'"
                     onmouseout="this.style.background='transparent'">
                    <div style="background: var(--accent-l); min-width: 40px; height: 40px; border-radius: 50%;
                                display: flex; align-items: center; justify-content: center; font-size: 1.2rem; margin-top: 2px;">
                        ${icon}
                    </div>
                    <div style="flex: 1; min-width: 0;">
                        <div style="font-size: 0.85rem; font-weight: 700; color: var(--ink);">${n.sender}</div>
                        <div style="font-size: 0.78rem; color: var(--ink); opacity: 0.65; white-space: nowrap;
                                    overflow: hidden; text-overflow: ellipsis; max-width: 230px; margin-top: 2px;">
                            ${n.message}
                        </div>
                        ${subLine}
                    </div>
                </div>`;
            }).join('');
        }
    }

    // 4. Update Announcements tab badge with clickable handler
    const annTabCount = document.getElementById('ann-tab-count');
    if (annTabCount && announcementItems.length > 0) {
        // Make the entire announcements tab clickable to view all announcements
        const annTab = document.querySelector('[data-panel="announcements"]');
        if (annTab) {
            annTab.style.cursor = 'pointer';
            annTab.onclick = function() {
                window.location.href = 'announcements';
            };
        }
    }
}

// ── NOTIFICATION PANEL TOGGLE (shared pages) ──
function toggleNotif(event) {
    if (event && event.stopPropagation) event.stopPropagation();
    const panel = document.getElementById('notif-panel');
    if (!panel) return;
    const isVisible = panel.style.display === 'block';
    panel.style.display = isVisible ? 'none' : 'block';
}

window.addEventListener('click', () => {
    const panel = document.getElementById('notif-panel');
    if (panel) panel.style.display = 'none';
});

function openNotifThread(threadId) {
    if (!threadId) return;

    // Check if this is a booking cancellation or update notification
    if (threadId.startsWith('BOOKING_CANCEL_') || threadId.startsWith('BOOKING_UPDATE_')) {
        // Just mark it as read and remove from UI
        const notifIndex = window.allNotifications ? window.allNotifications.findIndex(n => n.threadId === threadId) : -1;
        if (notifIndex > -1 && window.allNotifications) {
            window.allNotifications.splice(notifIndex, 1);
            if (typeof renderNotifications === 'function') {
                renderNotifications();
            }
        }

        // Send mark as read request
        fetch('markInquiryRead', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'threadId=' + encodeURIComponent(threadId)
        }).catch(err => console.error("Failed to mark notification as read:", err));

        const panel = document.getElementById('notif-panel');
        if (panel) panel.style.display = 'none';
        return;
    }

    // If we are already on a dashboard that can open the modal, open directly.
    if (window.currentRole && String(window.currentRole).toUpperCase() === 'SELLER' && typeof window.openChat === 'function') {
        window.openChat(threadId);
        const panel = document.getElementById('notif-panel');
        if (panel) panel.style.display = 'none';
        return;
    }
    if (window.currentRole && String(window.currentRole).toUpperCase() === 'BUYER' && typeof window.openBuyerChat === 'function') {
        window.openBuyerChat(threadId);
        const panel = document.getElementById('notif-panel');
        if (panel) panel.style.display = 'none';
        return;
    }

    // Otherwise route to the right dashboard and auto-open.
    const role = window.currentRole ? String(window.currentRole).toUpperCase() : '';
    if (role === 'SELLER') {
        window.location.href = 'sellerDashboard?threadId=' + encodeURIComponent(threadId);
    } else {
        window.location.href = 'buyerDashboard?threadId=' + encodeURIComponent(threadId);
    }
}

// Run this logic as soon as the page loads
window.document.addEventListener("DOMContentLoaded", renderNotifications);
// ── SORT ─────────────────────────────────
function sortProperties(arr) {
    if (currentSort === 'default') return arr;
    return [...arr].sort((a, b) => {
        const toNum = v => (typeof v === 'string' ? parseInt(v.replace(/[^0-9]/g, ''), 10) : (v || 0));
        if (currentSort === 'price_asc')  return toNum(a.price) - toNum(b.price);
        if (currentSort === 'price_desc') return toNum(b.price) - toNum(a.price);
        if (currentSort === 'newest')     return (parseInt(b.id, 10) || 0) - (parseInt(a.id, 10) || 0);
        if (currentSort === 'views')      return (parseInt(b.views, 10) || 0) - (parseInt(a.views, 10) || 0);
        return 0;
    });
}

function sortListings(value) {
    currentSort = value;
    currentListingsPage = 0;
    applyFilters();   // re-filter + sort + render
}

// ── VIEW TOGGLE ──────────────────────────
function setViewMode(mode) {
    if (currentViewMode === mode) return;
    currentViewMode = mode;
    const grid = document.getElementById('listings-grid');
    if (grid) grid.classList.toggle('prop-grid--list', mode === 'list');
    document.querySelectorAll('.view-btn').forEach((btn, i) => {
        btn.classList.toggle('active', (mode === 'grid' && i === 0) || (mode === 'list' && i === 1));
    });
    currentListingsPage = 0;
    renderListings();
}

// ── UNIVERSAL CHAT SUBMISSION HANDLER ──────────────────
function handleChatSubmit(event, role, formElement) {
    event.preventDefault();

    // formElement is passed explicitly when triggered by Enter key (synthetic event has no .target form)
    const form = formElement || event.target;
    const messageInput = form.querySelector('.chat-input');
    const threadIdInput = form.querySelector('input[name="threadId"]');
    const message = messageInput.value.trim();

    if (!message) return;

    const threadId = threadIdInput.value;
    const chatMsgs = form.closest('.chat-right').querySelector('.chat-msgs');

    const escapeHTML = (str) => {
        const p = document.createElement('p');
        p.appendChild(document.createTextNode(str));
        return p.innerHTML;
    };

    const senderName = escapeHTML(window.currentUser || 'You');
    const safeMessage = escapeHTML(message);
    const timeString = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

    const newBubble = document.createElement('div');
    newBubble.className = 'bubble bubble-right';
    newBubble.innerHTML = `
        <div class="bubble-meta">
            <strong>${senderName}</strong> · ${timeString}
        </div>
        <div style="white-space: pre-wrap;">${safeMessage}</div>
    `;
    chatMsgs.appendChild(newBubble);
    chatMsgs.scrollTop = chatMsgs.scrollHeight;

    messageInput.value = '';
    messageInput.focus();

    const formData = new URLSearchParams();
    formData.append('threadId', threadId);
    formData.append('message', message);
    formData.append('role', role);

    fetch('replyInquiry', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: formData
    })
        .then(response => {
            if (!response.ok) {
                newBubble.style.opacity = '0.6';
                newBubble.title = 'Failed to send. Please try again.';
            }
        })
        .catch(error => {
            console.error('Network error sending message:', error);
            newBubble.style.opacity = '0.6';
            newBubble.title = 'Network error. Could not send message.';
        });
}

// ── Heart Toggle: Save / Remove Favorite without page reload ──────────────
function toggleFavorite(btn, propertyId) {
    if (!window.favPropertyIds) window.favPropertyIds = new Set();

    const isSaved = window.favPropertyIds.has(propertyId);
    const url = isSaved ? 'removeFavorite' : 'saveFavorite';

    const formData = new URLSearchParams();
    formData.append('propertyId', propertyId);

    fetch(url, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: formData.toString()
    })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'ok') {
                if (isSaved) {
                    // Remove from favorites
                    window.favPropertyIds.delete(propertyId);
                    btn.classList.remove('heart-btn--saved');
                    btn.title = 'Save to Favorites';
                } else {
                    // Add to favorites
                    window.favPropertyIds.add(propertyId);
                    btn.classList.add('heart-btn--saved');
                    btn.title = 'Remove from Favorites';
                }
            }
        })
        .catch(err => console.error('Favorite toggle failed:', err));
}
