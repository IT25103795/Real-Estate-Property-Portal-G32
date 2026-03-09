// ── DARK MODE LOGIC ───────────────────────────────────
// Check if the user previously chose Dark Mode
if (localStorage.getItem('nestiq_theme') === 'dark') {
  document.documentElement.setAttribute('data-theme', 'dark');
  document.addEventListener("DOMContentLoaded", () => {
      document.getElementById('theme-toggle').textContent = '☀️';
  });
}

function toggleTheme() {
  const html = document.documentElement;
  const btn = document.getElementById('theme-toggle');

  if (html.getAttribute('data-theme') === 'dark') {
      html.removeAttribute('data-theme');
      localStorage.setItem('nestiq_theme', 'light');
      btn.textContent = '🌙'; // Change back to Moon
  } else {
      html.setAttribute('data-theme', 'dark');
      localStorage.setItem('nestiq_theme', 'dark');
      btn.textContent = '☀️'; // Change to Sun
  }
}

// ── DATA ──────────────────────────────────────────────

const AGENTS = [
  { id:1, name:"Senuri Fernando", title:"Senior Luxury Specialist", agency:"Nestiq Colombo 07", phone:"+94 77 101 2020", email:"s.fernando@nestiq.lk", img:"https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80", listings:24, sold:187, rating:4.9, spec:"luxury", years:12 },
  { id:2, name:"Dinesh Perera", title:"Investment & Commercial", agency:"Nestiq Kandy", phone:"+94 71 202 3030", email:"d.perera@nestiq.lk", img:"https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80", listings:18, sold:143, rating:4.8, spec:"investment", years:9 },
  { id:3, name:"Kavindi De Silva", title:"Residential Expert", agency:"Nestiq Kurunegala", phone:"+94 70 303 4040", email:"k.desilva@nestiq.lk", img:"https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80", listings:31, sold:210, rating:4.9, spec:"residential", years:15 },
  { id:4, name:"Nuwan Rathnayake", title:"Commercial Specialist", agency:"Nestiq Galle", phone:"+94 76 404 5050", email:"n.rathnayake@nestiq.lk", img:"https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&q=80", listings:12, sold:98, rating:4.7, spec:"commercial", years:7 },
  { id:5, name:"Anjali Jayasooriya", title:"Luxury Condo Specialist", agency:"Nestiq Mount Lavinia", phone:"+94 77 505 6060", email:"a.jayasooriya@nestiq.lk", img:"https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400&q=80", listings:20, sold:156, rating:4.8, spec:"luxury", years:10 },
  { id:6, name:"Mohammed Rizwan", title:"Investment Properties", agency:"Nestiq Negombo", phone:"+94 75 606 7070", email:"m.rizwan@nestiq.lk", img:"https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400&q=80", listings:15, sold:121, rating:4.7, spec:"investment", years:8 },
];

const TESTIMONIALS = [
  { name:"Chamathka Silva", role:"Bought in Colombo 07", img:"https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&q=80", text:"Nestiq made finding our dream apartment effortless. Senuri guided us with exceptional patience and expertise — we couldn't be happier.", stars:5 },
  { name:"Kasun & Tharushi", role:"Sold in Kurunegala", img:"https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=100&q=80", text:"Sold our villa in under two weeks for above the asking price. Dinesh's market knowledge and professional network are truly unmatched.", stars:5 },
  { name:"Ashan Dias", role:"Renting in Malabe", img:"https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80", text:"The entire process was transparent, fast and stress-free. Kavindi found us the perfect annex near the campus. Exceptional service from start to finish.", stars:5 },
];

// ── STATE ─────────────────────────────
let state = {
  filterStatus: 'all',
  filterType:   'all',
  filterCity:   'all',
  filterBeds:   'any',
  minPrice: null,
  maxPrice: null,
  sortBy: 'default',
  listingsPage: 1,
  homeFilter: 'all',
  currentPropertyId: null,
  savedIds: [],
  lastPage: 'listings',
};

// ── ROUTER ────────────────────────────
function showPage(name) {
  document.querySelectorAll('.page').forEach(p => p.classList.remove('active'));
  document.getElementById('page-' + name).classList.add('active');
  document.querySelectorAll('.nav-links a').forEach(a => a.classList.remove('active'));
  const map = {home:'nav-home'};
  if (map[name]) document.getElementById(map[name])?.classList.add('active');
  window.scrollTo(0,0);
  if (name === 'listings') renderListings();
  if (name === 'agents')   renderAgentsFull();
  if (name === 'home')     initHome();
}

// ── FORMAT ────────────────────────────
function fmt(price, status) {
  if (status === 'rent') return `$${price.toLocaleString()}<span>/mo</span>`;
  if (price >= 1e6) return `$${(price/1e6).toFixed(1)}M`;
  return `$${price.toLocaleString()}`;
}

// ── PROPERTY CARD HTML ─────────────────
function propCardHTML(p, delay=0) {
  const agent = AGENTS.find(a => a.id === p.agentId) || AGENTS[0];
  const saved = state.savedIds.includes(p.id);
  return `
  <div class="prop-card" style="animation-delay:${delay}s" onclick="openDetail(${p.id})">
    <div class="prop-img-wrap">
      <img src="${p.images[0]}" alt="${p.title}" loading="lazy"/>
      <div class="prop-tags">
        <span class="prop-tag ${p.status === 'rent' ? 'tag-rent':'tag-sale'}">${p.status==='rent'?'For Rent':'For Sale'}</span>
        ${p.featured ? '<span class="prop-tag tag-feat">⭐ Featured</span>' : ''}
      </div>
      <button class="prop-save ${saved?'saved':''}" onclick="toggleSave(event,${p.id})">
        ${saved ? '♥' : '♡'}
      </button>
    </div>
    <div class="prop-body">
      <div class="prop-price">${fmt(p.price, p.status)}</div>
      <div class="prop-name">${p.title}</div>
      <div class="prop-loc">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/></svg>
        ${p.city}
      </div>
      <div class="prop-divider"></div>
      <div class="prop-meta">
        <div class="prop-meta-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
          ${p.beds > 0 ? p.beds + ' Beds' : 'Studio'}
        </div>
        <div class="prop-meta-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 20h20M9 4v16M9 4H5a2 2 0 00-2 2v3h18V6a2 2 0 00-2-2h-4"/></svg>
          ${p.baths} Baths
        </div>
        <div class="prop-meta-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/></svg>
          ${p.area.toLocaleString()} ft²
        </div>
      </div>
      <div class="prop-agent-row">
        <div class="prop-agent">
          <img src="${agent.img}" alt="${agent.name}"/>
          <div class="prop-agent-name">${agent.name}</div>
        </div>
        <div class="prop-views">👁 ${p.views}</div>
      </div>
    </div>
  </div>`;
}

// ── AGENT CARD HTML ────────────────────
function agentCardHTML(a, delay=0) {
  return `
  <div class="agent-card" style="animation-delay:${delay}s">
    <div class="agent-card-img">
      <img src="${a.img}" alt="${a.name}" loading="lazy"/>
    </div>
    <div class="agent-card-body">
      <div class="agent-card-name">${a.name}</div>
      <div class="agent-card-role">${a.title}</div>
      <div style="font-size:.78rem;color:var(--ink4);margin-bottom:14px">${a.agency} · ${a.years} yrs exp</div>
      <div class="agent-card-stats">
        <div class="ac-stat"><div class="ac-stat-val">${a.listings}</div><div class="ac-stat-label">Listings</div></div>
        <div class="ac-stat"><div class="ac-stat-val">${a.sold}</div><div class="ac-stat-label">Sold</div></div>
        <div class="ac-stat"><div class="ac-stat-val">★${a.rating}</div><div class="ac-stat-label">Rating</div></div>
      </div>
    </div>
  </div>`;
}

// ── INIT HOME ──────────────────────────
function initHome() {
  //renderHomeProps();
  renderTestimonials();
  renderHomeAgents();
  animateStats();
}

function renderHomeProps() {
  const f = state.homeFilter;
  let props = PROPERTIES.filter(p => {
    if (f === 'all') return true;
    if (f === 'sale') return p.status === 'sale';
    if (f === 'rent') return p.status === 'rent';
    return p.type === f;
  }).slice(0,6);
  document.getElementById('home-prop-grid').innerHTML =
    props.map((p,i) => propCardHTML(p, i*0.06)).join('');
}

function filterHome(btn, f) {
  document.querySelectorAll('#page-home .filter-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  state.homeFilter = f;
  renderHomeProps();
}

function renderTestimonials() {
  document.getElementById('testi-grid').innerHTML = TESTIMONIALS.map(t => `
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
  document.getElementById('home-agents-grid').innerHTML =
    AGENTS.slice(0,4).map((a,i) => agentCardHTML(a, i*0.06)).join('');
}

function animateStats() {
  [[0,12400,'+'],[1,340,''],[2,98,'%']].forEach(([i,target,suffix]) => {
    const el = document.getElementById('stat'+i);
    if (!el || el._done) return;
    el._done = true;
    let v = 0; const step = target / 50;
    const iv = setInterval(() => {
      v = Math.min(v + step, target);
      el.textContent = Math.floor(v).toLocaleString();
      if (v >= target) { el.textContent = target.toLocaleString(); clearInterval(iv); }
    }, 30);
  });
}

// ── LISTINGS PAGE ──────────────────────
function getFilteredProps() {
  return PROPERTIES.filter(p => {
    const okStatus = state.filterStatus === 'all' || p.status === state.filterStatus;
    const okType   = state.filterType   === 'all' || p.type   === state.filterType;
    const okCity   = state.filterCity   === 'all' || p.city   === state.filterCity;
    const okBeds   = state.filterBeds   === 'any' || p.beds   >= parseInt(state.filterBeds);
    const okMin    = !state.minPrice    || p.price >= state.minPrice;
    const okMax    = !state.maxPrice    || p.price <= state.maxPrice;
    return okStatus && okType && okCity && okBeds && okMin && okMax;
  }).sort((a,b) => {
    if (state.sortBy === 'price_asc')  return a.price - b.price;
    if (state.sortBy === 'price_desc') return b.price - a.price;
    if (state.sortBy === 'views')      return b.views - a.views;
    return (b.featured?1:0) - (a.featured?1:0);
  });
}

function renderListings() {
  const props = getFilteredProps();
  const show = props.slice(0, state.listingsPage * 6);
  document.getElementById('listings-count').textContent = props.length;
  document.getElementById('listings-grid').innerHTML = show.map((p,i) => propCardHTML(p, i*0.04)).join('');
  document.getElementById('listings-load-more').style.display = show.length >= props.length ? 'none' : 'flex';
}

function loadMoreListings() { state.listingsPage++; renderListings(); }

function toggleChip(el, group, val) {
  const parent = el.parentElement;
  parent.querySelectorAll('.filter-chip').forEach(c => c.classList.remove('active'));
  el.classList.add('active');
  if (group === 'status') state.filterStatus = val;
  if (group === 'type')   state.filterType   = val;
  if (group === 'city')   state.filterCity   = val;
}

function setBeds(el, val) {
  el.parentElement.querySelectorAll('.bed-btn').forEach(b => b.classList.remove('active'));
  el.classList.add('active');
  state.filterBeds = val;
}

function applyFilters() {
  state.minPrice = parseFloat(document.getElementById('filterMinPrice').value) || null;
  state.maxPrice = parseFloat(document.getElementById('filterMaxPrice').value) || null;
  state.listingsPage = 1;
  renderListings();
  showToast('✓', 'Filters applied');
}

function resetFilters() {
  state.filterStatus = 'all'; state.filterType = 'all';
  state.filterCity = 'all'; state.filterBeds = 'any';
  state.minPrice = null; state.maxPrice = null;
  document.querySelectorAll('#page-listings .filter-chip').forEach((c,i) => c.classList.toggle('active', i === 0 || i === 5 || i === 10));
  document.querySelectorAll('.bed-btn').forEach((b,i) => b.classList.toggle('active', i===0));
  document.getElementById('filterMinPrice').value = '';
  document.getElementById('filterMaxPrice').value = '';
  state.listingsPage = 1;
  renderListings();
}

function sortListings(val) { state.sortBy = val; state.listingsPage = 1; renderListings(); }

// ── DETAIL PAGE ────────────────────────
function openDetail(id) {
  state.currentPropertyId = id;
  state.lastPage = document.querySelector('.page.active')?.id.replace('page-','') || 'listings';
  const p = PROPERTIES.find(p => p.id === id);
  const agent = AGENTS.find(a => a.id === p.agentId) || AGENTS[0];

  document.getElementById('detail-main-img').src = p.images[0];
  document.getElementById('detail-img-count').textContent = `📷 ${p.images.length} Photos`;
  document.getElementById('detail-title').textContent = p.title;
  document.getElementById('detail-address-text').textContent = p.address;
  document.getElementById('detail-price').innerHTML = fmt(p.price, p.status);
  document.getElementById('detail-price-label').textContent = p.status === 'rent' ? 'Monthly Rent' : 'Listing Price';
  document.getElementById('detail-desc').textContent = p.desc;

  document.getElementById('detail-tags').innerHTML = `
    <span class="detail-tag ${p.status==='rent'?'badge-blue':'badge-green'}">${p.status==='rent'?'🔵 For Rent':'🟢 For Sale'}</span>
    <span class="detail-tag badge-amber">${p.type.charAt(0).toUpperCase()+p.type.slice(1)}</span>
    ${p.featured ? '<span class="detail-tag" style="background:var(--amber-l);color:var(--amber)">⭐ Featured</span>' : ''}`;

  document.getElementById('detail-specs').innerHTML = `
    <div class="spec-box"><div class="spec-icon">🛏</div><div class="spec-value">${p.beds||'—'}</div><div class="spec-label">Bedrooms</div></div>
    <div class="spec-box"><div class="spec-icon">🚿</div><div class="spec-value">${p.baths}</div><div class="spec-label">Bathrooms</div></div>
    <div class="spec-box"><div class="spec-icon">📐</div><div class="spec-value">${p.area.toLocaleString()}</div><div class="spec-label">Sq Footage</div></div>
    <div class="spec-box"><div class="spec-icon">👁</div><div class="spec-value">${p.views}</div><div class="spec-label">Views</div></div>`;

  document.getElementById('detail-features').innerHTML =
    p.features.map(f => `<div class="feature-item"><div class="feature-check">✓</div>${f}</div>`).join('');

  document.getElementById('detail-thumbs').innerHTML =
    p.images.map((img,i) => `<img src="${img}" class="${i===0?'active':''}" alt="" onclick="switchDetailImg(this,'${img}')" loading="lazy"/>`).join('');

  document.getElementById('detail-agent-img').src = agent.img;
  document.getElementById('detail-agent-name').textContent = agent.name;
  document.getElementById('detail-agent-title').textContent = agent.title;
  document.getElementById('detail-agent-rating').textContent = `${agent.rating} (${agent.sold} sales)`;


  if (document.getElementById('inq-prop-id')) document.getElementById('inq-prop-id').value = p.id;
  if (document.getElementById('inq-prop-title')) document.getElementById('inq-prop-title').value = p.title;
  if (document.getElementById('inq-agent-name')) document.getElementById('inq-agent-name').value = agent.name;

  showPage('detail');
  p.views++;
}

function switchDetailImg(el, src) {
  document.getElementById('detail-main-img').src = src;
  document.querySelectorAll('#detail-thumbs img').forEach(i => i.classList.remove('active'));
  el.classList.add('active');
}

function sendInquiry() {
  const name = document.getElementById('ci-name').value.trim();
  const email = document.getElementById('ci-email').value.trim();
  if (!name || !email) { showToast('⚠', 'Please fill in name and email', true); return; }
  ['ci-name','ci-email','ci-phone','ci-message'].forEach(id => document.getElementById(id).value = '');
  showToast('✓', 'Message sent! Agent will contact you soon.');
}

function scheduleViewing() { showToast('📅', 'Viewing request sent! We\'ll confirm by email.'); }

// ── AGENTS PAGE ────────────────────────
function renderAgentsFull(filter='all') {
  const filtered = filter === 'all' ? AGENTS : AGENTS.filter(a => a.spec === filter);
  document.getElementById('agents-grid').innerHTML = filtered.map((a,i) => agentCardHTML(a, i*0.06)).join('');
}
function filterAgents(btn, f) {
  document.querySelectorAll('#page-agents .filter-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  renderAgentsFull(f);
}

// ── SAVE / FAV ─────────────────────────
function toggleSave(e, id) {
  e.stopPropagation();
  const idx = state.savedIds.indexOf(id);
  if (idx > -1) { state.savedIds.splice(idx,1); showToast('', 'Removed from saved'); }
  else { state.savedIds.push(id); showToast('♥', 'Property saved!'); }
  const activePage = document.querySelector('.page.active');
  const gridId = activePage?.id === 'page-home' ? 'home-prop-grid' : 'listings-grid';
  const btn = activePage?.querySelector(`[onclick="toggleSave(event,${id})"]`);
  if (btn) { btn.classList.toggle('saved', state.savedIds.includes(id)); btn.textContent = state.savedIds.includes(id) ? '♥' : '♡'; }
}

// ── SEARCH ─────────────────────────────
function doHeroSearch() {
  const loc  = document.getElementById('heroLocation').value.toLowerCase();
  const type = document.getElementById('heroType').value.toLowerCase();
  const stat = document.getElementById('heroStatus').value;
  if (loc) { state.filterCity = PROPERTIES.find(p => p.city.toLowerCase().includes(loc))?.city || 'all'; }
  if (type && type !== '') state.filterType = type;
  if (stat) state.filterStatus = stat;
  showPage('listings');
}

// ── AUTH ───────────────────────────────
function selectRole(el, role) {

  document.querySelectorAll('.role-btn').forEach(b => b.classList.remove('selected'));
  el.classList.add('selected');
  document.getElementById('hiddenRole').value = role;
}
function doLogin() {
  const e = document.getElementById('login-email').value;
  const p = document.getElementById('login-password').value;
  if (!e || !p) { showToast('⚠', 'Please fill in all fields', true); return; }
  showToast('✓', 'Welcome back! Signed in successfully.');
  setTimeout(() => showPage('home'), 800);
}

// ── TOAST ──────────────────────────────
function showToast(icon, msg, isError=false) {
  const t = document.getElementById('toast');
  document.getElementById('toast-icon').textContent = icon;
  document.getElementById('toast-msg').textContent = msg;
  t.style.background = isError ? '#c53030' : 'var(--ink)';
  t.classList.add('show');
  setTimeout(() => t.classList.remove('show'), 3000);
}

// ── NAVBAR SCROLL ──────────────────────
window.addEventListener('scroll', () => {
  document.getElementById('navbar').classList.toggle('scrolled', scrollY > 20);
});

// ── INIT ───────────────────────────────
initHome();

// OVERRIDE: Bulletproof Homepage Filter Engine
function filterHome(btn, filterType) {
    // 1. Switch the blue active button color
    document.querySelectorAll('.filter-bar .filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    // 2. Scan every Java-generated card on the homepage
    const cards = document.querySelectorAll('#home-prop-grid .prop-card');

    cards.forEach(card => {
        // Read all the text on the card (like "Apartment", "Colombo", etc.)
        const cardText = card.innerText.toLowerCase();

        // If they clicked "All", show everything
        if (filterType === 'all') {
            card.style.display = 'block';
        }
        // Otherwise, check if the card contains the filter word
        else if (cardText.includes(filterType.toLowerCase())) {
            card.style.display = 'block';
        }
        // If it doesn't match, hide it!
        else {
            card.style.display = 'none';
        }
    });
}

// ==========================================
// 🔥 MASTER BROWSE ENGINE OVERRIDE 🔥
// ==========================================

let currentFilters = { status: 'all', type: 'all', city: 'all', beds: 'any', minPrice: '', maxPrice: '' };

// 1. Bulletproof Filter Memory
function toggleChip(btn, category, value) {
    let siblings = btn.parentElement.querySelectorAll('.filter-chip');
    siblings.forEach(s => s.classList.remove('active'));
    btn.classList.add('active');
    currentFilters[category] = value;
    applyFilters();
}

// 2. Bulletproof Bed Button Memory
function setBeds(btn, value) {
    let siblings = btn.parentElement.querySelectorAll('.bed-btn');
    siblings.forEach(s => s.classList.remove('active'));
    btn.classList.add('active');
    currentFilters.beds = value;
    applyFilters();
}

// 3. The Reset Switch
function resetFilters() {
    currentFilters = { status: 'all', type: 'all', city: 'all', beds: 'any', minPrice: '', maxPrice: '' };

    // Reset visual buttons
    document.querySelectorAll('.filter-chip, .bed-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.filter-chip[onclick*="\'all\'"]').forEach(c => c.classList.add('active'));
    document.querySelectorAll('.bed-btn[onclick*="\'any\'"]').forEach(b => b.classList.add('active'));

    // Clear Price Boxes
    if(document.getElementById('filterMinPrice')) document.getElementById('filterMinPrice').value = '';
    if(document.getElementById('filterMaxPrice')) document.getElementById('filterMaxPrice').value = '';

    applyFilters();
}

// 4. Bulletproof Filtering Logic
function applyFilters() {
    const minInput = document.getElementById('filterMinPrice');
    const maxInput = document.getElementById('filterMaxPrice');
    if (minInput) currentFilters.minPrice = minInput.value;
    if (maxInput) currentFilters.maxPrice = maxInput.value;

    let filtered = PROPERTIES.filter(p => {
        // Safe, case-insensitive matching
        let matchStatus = currentFilters.status === 'all' || (p.status && p.status.toLowerCase() === currentFilters.status.toLowerCase());
        let matchType = currentFilters.type === 'all' || (p.type && p.type.toLowerCase() === currentFilters.type.toLowerCase());
        let matchCity = currentFilters.city === 'all' || (p.city && p.city.toLowerCase() === currentFilters.city.toLowerCase());

        let matchBeds = true;
        if (currentFilters.beds !== 'any' && p.beds) {
            matchBeds = p.beds >= parseInt(currentFilters.beds);
        }

        // Price matching (strips out any $ or commas safely!)
        let matchPrice = true;
        let numPrice = typeof p.price === 'string' ? parseInt(p.price.replace(/[^0-9]/g, '')) : p.price;
        if (currentFilters.minPrice && numPrice < parseInt(currentFilters.minPrice)) matchPrice = false;
        if (currentFilters.maxPrice && numPrice > parseInt(currentFilters.maxPrice)) matchPrice = false;

        return matchStatus && matchType && matchCity && matchBeds && matchPrice;
    });

    renderListings(filtered);
}

// 5. Bulletproof Render Engine
// 5. Bulletproof Render Engine
function renderListings(list) {
    const grid = document.getElementById('listings-grid');
    if (!grid) return; // Stop safely if we aren't on the Browse page

    const countEl = document.getElementById('listings-count');

    if (list.length === 0) {
        grid.innerHTML = '<p style="grid-column: 1/-1; text-align: center; color: var(--ink3); padding: 40px; font-weight: 500;">No properties match your exact filters. Try clearing some!</p>';
        if (countEl) countEl.innerText = "0";
        return;
    }

    grid.innerHTML = list.map(p => {
        const agent = AGENTS.find(a => a.id === p.agentId) || AGENTS[0];
        const displayPrice = typeof p.price === 'number' ? p.price.toLocaleString() : p.price;
        const safeStatus = p.status ? p.status.toLowerCase() : 'sale';

        return `
        <div class="prop-card" onclick="openDetail('${p.id}')" style="cursor: pointer;">
            <div class="prop-img-wrap">
                <img src="${p.img}" alt="${p.title}">
                <div class="prop-tags">
                    <span class="prop-tag tag-sale">${safeStatus === 'rent' ? 'For Rent' : 'For Sale'}</span>
                    ${p.featured ? '<span class="prop-tag tag-feat">Featured</span>' : ''}
                </div>
            </div>
            <div class="prop-body">
                <div class="prop-price">$${displayPrice} ${safeStatus === 'rent' ? '<span style="font-size:0.6em; color:var(--ink4)">/mo</span>' : ''}</div>
                <div class="prop-name">${p.title}</div>
                <div class="prop-loc">📍 ${p.city}, ${p.location}</div>
                <div class="prop-divider"></div>
                <div class="prop-meta">
                    <div class="prop-meta-item">🛏️ ${p.beds || 0} Beds</div>
                    <div class="prop-meta-item">🛁 ${p.baths || 0} Baths</div>
                    <div class="prop-meta-item">📐 ${p.sqft || 0} sqft</div>
                </div>
                <div class="prop-agent-row">
                    <div class="prop-agent">
                        <img src="${agent.img}" alt="${agent.name}">
                        <div class="prop-agent-name">${agent.name}</div>
                    </div>
                    <div class="prop-views">👁️ ${p.views || 342}</div>
                </div>
            </div>
        </div>`;
    }).join('');

    if (countEl) countEl.innerText = list.length;
}
// ==========================================
// 🔥 MASTER DETAIL PAGE ENGINE 🔥
// ==========================================
function openDetail(id) {
    // 1. Find the exact property from our Live Data Bridge
    // (We use String(id) just in case Java passed it as a weird format!)
    const p = PROPERTIES.find(prop => String(prop.id) === String(id));

    if (!p) {
        console.error("Bro! Couldn't find the property ID: " + id);
        return;
    }

    // 2. Populate the massive Hero Image and Text
    document.getElementById('detail-main-img').src = p.img;
    document.getElementById('detail-title').innerText = p.title;
    document.getElementById('detail-address-text').innerText = p.city + ", " + p.location;

    // Format the price beautifully with commas
    const displayPrice = typeof p.price === 'number' ? p.price.toLocaleString() : p.price;
    document.getElementById('detail-price').innerText = "$" + displayPrice;

    // Wire the hidden input to the current property ID!
    const favInput = document.getElementById('fav-property-id');
    if (favInput) favInput.value = String(id);

    // 3. Find the matching Sri Lankan agent and populate the sidebar
    const agent = AGENTS.find(a => a.id === p.agentId) || AGENTS[0];
    document.getElementById('detail-agent-img').src = agent.img;
    document.getElementById('detail-agent-name').innerText = agent.name;
    document.getElementById('detail-agent-title').innerText = agent.title;

    // 4. Fill in the specific specs (Beds, Baths, Sqft)
    const specsContainer = document.getElementById('detail-specs');
    if (specsContainer) {
        specsContainer.innerHTML = `
            <div class="spec-box"><div class="spec-icon">🛏️</div><div class="spec-value">${p.beds || 3}</div><div class="spec-label">Bedrooms</div></div>
            <div class="spec-box"><div class="spec-icon">🛁</div><div class="spec-value">${p.baths || 2}</div><div class="spec-label">Bathrooms</div></div>
            <div class="spec-box"><div class="spec-icon">📐</div><div class="spec-value">${p.sqft || 1500}</div><div class="spec-label">Square Feet</div></div>
            <div class="spec-box"><div class="spec-icon">🏠</div><div class="spec-value">${p.type.charAt(0).toUpperCase() + p.type.slice(1)}</div><div class="spec-label">Property Type</div></div>
        `;
    }

    // 5. Finally, visually swap to the detail page and scroll to the top!
    showPage('detail');
    window.scrollTo({ top: 0, behavior: 'smooth' });
}
// 🔥 BULLETPROOF INQUIRY DATA SCRAPER 🔥
    setTimeout(() => {
        // 1. Set the Property ID
        const propIdInput = document.getElementById('inq-prop-id');
        if (propIdInput) propIdInput.value = String(id);

        // 2. Scrape the Title directly from the UI text
        const propTitleInput = document.getElementById('inq-prop-title');
        const titleElement = document.getElementById('detail-title') || document.querySelector('.detail-title') || document.querySelector('h1');
        if (propTitleInput) {
            propTitleInput.value = titleElement ? titleElement.innerText : 'Premium Property';
        }

        // 3. Scrape the Agent Name directly from the UI text
        const agentNameInput = document.getElementById('inq-agent-name');
        const agentElement = document.getElementById('detail-agent-name');
        if (agentNameInput) {
            agentNameInput.value = agentElement ? agentElement.innerText : 'Assigned Agent';
        }
    }, 400); // Give the UI 400 milliseconds to draw before scraping!