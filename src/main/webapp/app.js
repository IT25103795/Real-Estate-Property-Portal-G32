// ── DATA ──────────────────────────────────────────────
const PROPERTIES = [
  { id:1, title:"The Meridian Penthouse", price:2850000, status:"sale", type:"apartment", beds:4, baths:3, area:3200, city:"New York", address:"1 Central Park West, New York, NY 10023", desc:"A spectacular penthouse with panoramic city views, designer interiors, and a private rooftop terrace. Fully furnished with premium appliances and smart home technology throughout.", features:["Rooftop Terrace","Smart Home System","24h Concierge","Private Gym","Indoor Pool","Panoramic Views","Wine Cellar","Guest Suite"], images:["https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1200&q=80","https://images.unsplash.com/photo-1600607687644-c7171b42498b?w=800&q=80","https://images.unsplash.com/photo-1560185127-6ed189bf02f4?w=800&q=80","https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800&q=80"], agentId:1, views:342, featured:true },
  { id:2, title:"Tuscany Villa Estate", price:5200000, status:"sale", type:"villa", beds:6, baths:5, area:7800, city:"Los Angeles", address:"500 Bel Air Road, Los Angeles, CA 90077", desc:"Breathtaking Mediterranean-style villa set on 2 private acres with sweeping views of the Bel Air hills. Features a private pool, vineyard, 7-car garage, and guest house.", features:["Private Pool","Vineyard","7-Car Garage","Guest House","Tennis Court","Wine Cellar","Outdoor Kitchen","Home Theatre"], images:["https://images.unsplash.com/photo-1613977257363-707ba9348227?w=1200&q=80","https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&q=80","https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&q=80"], agentId:2, views:891, featured:true },
  { id:3, title:"Riverfront Loft", price:4800, status:"rent", type:"apartment", beds:2, baths:2, area:1650, city:"Chicago", address:"123 W Fulton Market, Chicago, IL 60607", desc:"Industrial-chic loft in a converted warehouse with exposed brick, soaring 14-ft ceilings, and spectacular river views. Walk to the best restaurants and galleries in the city.", features:["River Views","Exposed Brick","Doorman","Parking Included","Pet Friendly","In-unit Laundry","Rooftop Deck"], images:["https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=1200&q=80","https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800&q=80"], agentId:3, views:210, featured:false },
  { id:4, title:"The Oaks Residence", price:1250000, status:"sale", type:"house", beds:5, baths:4, area:4100, city:"San Francisco", address:"2800 Pacific Ave, San Francisco, CA 94115", desc:"Stunning Craftsman home on a generous lot with original hardwood floors, a gourmet chef's kitchen, and a serene backyard with mature oak trees.", features:["Chef's Kitchen","Hardwood Floors","Backyard Garden","Solar Panels","3-Car Garage","Home Office","Butler's Pantry"], images:["https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=1200&q=80","https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80","https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&q=80"], agentId:1, views:456, featured:true },
  { id:5, title:"Harbour View Studio", price:2900, status:"rent", type:"studio", beds:0, baths:1, area:550, city:"Miami", address:"100 Harbour Dr, Miami, FL 33132", desc:"A refined studio in the heart of Brickell with floor-to-ceiling windows and unobstructed harbour views. Ideal for professionals seeking a prestigious address.", features:["Harbour Views","Concierge","Infinity Pool","Fitness Center","Furnished Option","Valet Parking"], images:["https://images.unsplash.com/photo-1554995207-c18c203602cb?w=1200&q=80"], agentId:2, views:178, featured:false },
  { id:6, title:"Highland Manor", price:8750000, status:"sale", type:"house", beds:8, baths:7, area:12000, city:"Houston", address:"2500 River Oaks Blvd, Houston, TX 77019", desc:"Grand colonial manor on a private gated estate with equestrian facilities, formal gardens, and a guest cottage. Extraordinary period details throughout.", features:["Equestrian Facilities","Guest Cottage","Formal Gardens","Indoor Pool","Home Theatre","Staff Quarters","Helicopter Pad"], images:["https://images.unsplash.com/photo-1505843490538-5133c6c7d0e1?w=1200&q=80","https://images.unsplash.com/photo-1523217582562-09d0def993a6?w=800&q=80"], agentId:3, views:623, featured:true },
  { id:7, title:"SoHo Design Apartment", price:7200, status:"rent", type:"apartment", beds:3, baths:2, area:1900, city:"New York", address:"120 Spring St, New York, NY 10012", desc:"Chic 3-bedroom apartment in coveted SoHo with designer finishes, private terrace, and access to the building's curated art collection.", features:["Private Terrace","Art Collection","Doorman","Storage Unit","Bicycle Storage","Resident Lounge"], images:["https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=1200&q=80"], agentId:1, views:387, featured:false },
  { id:8, title:"Desert Oasis Villa", price:3100000, status:"sale", type:"villa", beds:5, baths:4, area:5600, city:"Palm Springs", address:"888 Vista Chino, Palm Springs, CA 92262", desc:"Iconic mid-century modern villa with an infinity pool overlooking the Coachella Valley. Featured in Architectural Digest. An entertainer's paradise.", features:["Infinity Pool","Mountain Views","Outdoor Kitchen","Fire Pit","Smart Home","Guest Casita"], images:["https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=1200&q=80","https://images.unsplash.com/photo-1600573472591-ee6b68d14c68?w=800&q=80"], agentId:2, views:741, featured:true },
];

const AGENTS = [
  { id:1, name:"Alexandra Stone", title:"Senior Luxury Specialist", agency:"Nestiq Manhattan", phone:"+1 (555) 101-2020", email:"a.stone@nestiq.com", img:"https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80", listings:24, sold:187, rating:4.9, spec:"luxury", years:12 },
  { id:2, name:"Marcus Chen", title:"Investment & Commercial", agency:"Nestiq Beverly Hills", phone:"+1 (555) 202-3030", email:"m.chen@nestiq.com", img:"https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80", listings:18, sold:143, rating:4.8, spec:"investment", years:9 },
  { id:3, name:"Sophia Laurent", title:"Residential Expert", agency:"Nestiq Chicago", phone:"+1 (555) 303-4040", email:"s.laurent@nestiq.com", img:"https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80", listings:31, sold:210, rating:4.9, spec:"residential", years:15 },
  { id:4, name:"James Okafor", title:"Commercial Specialist", agency:"Nestiq Houston", phone:"+1 (555) 404-5050", email:"j.okafor@nestiq.com", img:"https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&q=80", listings:12, sold:98, rating:4.7, spec:"commercial", years:7 },
  { id:5, name:"Isabella Kim", title:"Luxury Condo Specialist", agency:"Nestiq Miami", phone:"+1 (555) 505-6060", email:"i.kim@nestiq.com", img:"https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400&q=80", listings:20, sold:156, rating:4.8, spec:"luxury", years:10 },
  { id:6, name:"David Mercer", title:"Investment Properties", agency:"Nestiq San Francisco", phone:"+1 (555) 606-7070", email:"d.mercer@nestiq.com", img:"https://images.unsplash.com/photo-1560250097-0b93528c311a?w=400&q=80", listings:15, sold:121, rating:4.7, spec:"investment", years:8 },
];

const TESTIMONIALS = [
  { name:"Emily Harrington", role:"Bought in Manhattan", img:"https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&q=80", text:"Nestiq made finding our dream penthouse effortless. Alexandra guided us with exceptional patience and expertise — we couldn't be happier.", stars:5 },
  { name:"David & Priya Nair", role:"Sold in Beverly Hills", img:"https://images.unsplash.com/photo-1552374196-c4e7ffc6e126?w=100&q=80", text:"Sold our villa in under two weeks for above asking price. Marcus's market knowledge and professional network are truly unmatched.", stars:5 },
  { name:"Jonathan Bray", role:"Renting in Chicago", img:"https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80", text:"The entire process was transparent, fast and stress-free. Sophia found us the perfect loft. Exceptional service from start to finish.", stars:5 },
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
}
function doLogin() {
  const e = document.getElementById('login-email').value;
  const p = document.getElementById('login-password').value;
  if (!e || !p) { showToast('⚠', 'Please fill in all fields', true); return; }
  showToast('✓', 'Welcome back! Signed in successfully.');
  setTimeout(() => showPage('home'), 800);
}
function doRegister() {
  const n = document.getElementById('reg-name').value;
  const e = document.getElementById('reg-email').value;
  const p = document.getElementById('reg-password').value;
  if (!n || !e || !p) { showToast('⚠', 'Please fill in all fields', true); return; }
  if (p.length < 8)    { showToast('⚠', 'Password must be at least 8 characters', true); return; }
  showToast('✓', 'Account created! Welcome to Nestiq 🏡');
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