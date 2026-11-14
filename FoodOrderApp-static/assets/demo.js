/* =========================================================
   Vishakkunnu - static front-end demo layer

   GitHub Pages can only serve static files, so the original
   Java servlets / MySQL database are replaced here by the
   browser's own storage:

     - login / register / admin login  -> accepted locally
     - menu, orders, messages, users   -> localStorage
     - checkout hand-off between pages -> sessionStorage

   Nothing leaves the visitor's browser (except the optional
   Stripe test-mode card token on payment.html).
   ========================================================= */
(function (w) {
  'use strict';

  /* ---------- storage (falls back to memory if the browser blocks it) ---------- */
  function makeStore(kind) {
    var mem = {}, real = null;
    try { real = w[kind]; real.setItem('__vk', '1'); real.removeItem('__vk'); } catch (e) { real = null; }
    return {
      get: function (k, d) {
        try {
          var v = (k in mem) ? mem[k] : (real ? real.getItem(k) : null);
          return v ? JSON.parse(v) : d;
        } catch (e) { return d; }
      },
      set: function (k, v) {
        var s = JSON.stringify(v);
        try { if (real) { real.setItem(k, s); delete mem[k]; } else { mem[k] = s; } }
        catch (e) { mem[k] = s; }
      },
      del: function (k) { try { if (real) real.removeItem(k); } catch (e) {} delete mem[k]; }
    };
  }
  var L = makeStore('localStorage');
  var S = makeStore('sessionStorage');

  /* ---------- helpers ---------- */
  function esc(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }
  function money(n) { return (Math.round(Number(n) * 100) / 100).toFixed(2); }
  function prettyName(email) {
    var base = String(email || '').split('@')[0].replace(/[._\-+]+/g, ' ').trim();
    if (!base) return 'Guest';
    return base.replace(/\b\w/g, function (c) { return c.toUpperCase(); });
  }
  function placeholder(emoji) {
    var svg = '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="280" viewBox="0 0 400 280">' +
      '<defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1">' +
      '<stop offset="0" stop-color="#3a1519"/><stop offset="1" stop-color="#1c1c24"/></linearGradient></defs>' +
      '<rect width="400" height="280" fill="url(#g)"/>' +
      '<text x="200" y="170" font-size="110" text-anchor="middle">' + (emoji || '\uD83C\uDF7D\uFE0F') + '</text></svg>';
    return 'data:image/svg+xml;utf8,' + encodeURIComponent(svg);
  }

  /* ---------- menu (this replaces the `menu` table) ---------- */
  var DEFAULT_MENU = [
    { id: 1,  name: 'Pothu Roast',             price: 14.50, emoji: '\uD83C\uDF56', desc: 'Slow-roasted buffalo, Kerala style, with crisp onions and curry leaves.' },
    { id: 2,  name: 'Pazhampori',              price: 4.99,  emoji: '\uD83C\uDF4C', desc: 'Golden banana fritters, crisp outside and soft inside.' },
    { id: 3,  name: 'Kattan Chaya',            price: 2.50,  emoji: '\u2615',       desc: 'Strong, sweet black tea for a grey 4 pm.' },
    { id: 4,  name: 'Kerala Fish Curry',       price: 12.99, emoji: '\uD83D\uDC1F', desc: 'Tangy kudampuli fish curry simmered in coconut oil.' },
    { id: 5,  name: 'Appam & Veg Stew',        price: 9.99,  emoji: '\uD83E\uDD58', desc: 'Lacy rice hoppers with a mild coconut-milk vegetable stew.' },
    { id: 6,  name: 'Malabar Chicken Biryani', price: 13.50, emoji: '\uD83C\uDF5B', desc: 'Fragrant Malabar dum biryani with fried onions and cashews.' },
    { id: 7,  name: 'Karimeen Pollichathu',    price: 16.99, emoji: '\uD83D\uDC20', desc: 'Pearl spot fish marinated in masala and steamed in banana leaf.' },
    { id: 8,  name: 'Parotta & Beef Fry',      price: 11.99, emoji: '\uD83E\uDD5E', desc: 'Flaky layered parotta with spicy pepper beef fry.' },
    { id: 9,  name: 'Puttu & Kadala Curry',    price: 8.50,  emoji: '\uD83E\uDD65', desc: 'Steamed rice-coconut cylinders with black chickpea curry.' },
    { id: 10, name: 'Kerala Sadhya',           price: 18.00, emoji: '\uD83C\uDF7D\uFE0F', desc: 'The classic banana-leaf feast with more than a dozen dishes.' },
    { id: 11, name: 'Palada Payasam',          price: 5.50,  emoji: '\uD83C\uDF6E', desc: 'Creamy rice-ada dessert simmered in milk and sugar.' },
    { id: 12, name: 'Unniyappam',              price: 4.50,  emoji: '\uD83C\uDF69', desc: 'Sweet jaggery and banana rice fritters.' }
  ];
  var Menu = {
    all: function () {
      var m = L.get('vk_menu', null);
      return (m && m.length !== undefined) ? m : DEFAULT_MENU.slice();
    },
    save: function (list) { L.set('vk_menu', list); },
    nextId: function () {
      return Menu.all().reduce(function (mx, i) { return Math.max(mx, i.id); }, 0) + 1;
    },
    add: function (item) {
      var list = Menu.all();
      item.id = Menu.nextId();
      list.unshift(item);
      Menu.save(list);
      return item;
    },
    update: function (id, patch) {
      var list = Menu.all();
      list.forEach(function (i) { if (i.id === id) { for (var k in patch) i[k] = patch[k]; } });
      Menu.save(list);
    },
    remove: function (id) {
      Menu.save(Menu.all().filter(function (i) { return i.id !== id; }));
    },
    img: function (item) { return item.image || placeholder(item.emoji); }
  };

  /* ---------- sample data so the admin dashboard is not empty on first visit ---------- */
  function cartJson(pairs) {
    var byName = {};
    DEFAULT_MENU.forEach(function (i) { byName[i.name] = i; });
    return JSON.stringify(pairs.map(function (p) {
      return { name: p[0], price: byName[p[0]].price, quantity: p[1] };
    }));
  }
  function billFor(pairs, hasTable) {
    var byName = {}, sub = 0;
    DEFAULT_MENU.forEach(function (i) { byName[i.name] = i; });
    pairs.forEach(function (p) { sub += byName[p[0]].price * p[1]; });
    var fee = hasTable ? 5 : 0;
    return money((sub + fee) * 1.05);
  }
  function seed() {
    if (L.get('vk_seeded', false)) return;
    var o1 = [['Pothu Roast', 2], ['Kattan Chaya', 2]];
    var o2 = [['Malabar Chicken Biryani', 1], ['Pazhampori', 2]];
    var o3 = [['Kerala Sadhya', 2]];
    L.set('vk_users', [
      { id: 1, fullname: 'Demo Customer', email: 'demo@example.com' },
      { id: 2, fullname: 'Anjali Menon',   email: 'anjali@example.com' },
      { id: 3, fullname: 'Rahul Nair',     email: 'rahul@example.com' }
    ]);
    L.set('vk_orders', [
      { id: 1, fullname: 'Demo Customer', tableId: 'T3',   bookingDate: '2026-11-10', bookingTime: '19:30:00', totalBill: billFor(o1, true),  cartData: cartJson(o1), status: 'Confirmed' },
      { id: 2, fullname: 'Anjali Menon',  tableId: 'None', bookingDate: '2099-01-01', bookingTime: '00:00:00', totalBill: billFor(o2, false), cartData: cartJson(o2), status: 'Confirmed' },
      { id: 3, fullname: 'Rahul Nair',    tableId: 'T4',   bookingDate: '2026-11-12', bookingTime: '13:00:00', totalBill: billFor(o3, true),  cartData: cartJson(o3), status: 'Confirmed' }
    ]);
    L.set('vk_messages', [
      { id: 1, name: 'Anjali Menon', email: 'anjali@example.com', message: 'Loved the pothu roast! Do you take bookings for 10 or more people?', submitted_at: '2026-11-11 18:42' },
      { id: 2, name: 'Rahul Nair',   email: 'rahul@example.com',  message: 'Is there a vegetarian sadhya option on weekends?',                  submitted_at: '2026-11-12 09:15' }
    ]);
    L.set('vk_seeded', true);
  }

  /* ---------- users + session (replaces LoginServlet / RegisterServlet) ---------- */
  var Auth = {
    user: function () { var u = L.get('vk_user', null); return u ? u.fullname : null; },
    isLoggedIn: function () { return !!Auth.user(); },
    register: function (fullname, email) {
      var users = L.get('vk_users', []);
      var found = users.filter(function (u) { return u.email.toLowerCase() === String(email).toLowerCase(); })[0];
      if (!found) {
        found = { id: users.reduce(function (m, u) { return Math.max(m, u.id); }, 0) + 1, fullname: fullname, email: email };
        users.push(found);
        L.set('vk_users', users);
      }
      L.set('vk_user', { fullname: found.fullname, email: found.email });
      Auth.changed();
    },
    login: function (email) {
      var users = L.get('vk_users', []);
      var found = users.filter(function (u) { return u.email.toLowerCase() === String(email).toLowerCase(); })[0];
      L.set('vk_user', { fullname: found ? found.fullname : prettyName(email), email: email });
      Auth.changed();
    },
    logout: function () { L.del('vk_user'); S.del('vk_checkout'); S.del('vk_receipt'); Auth.changed(); },
    isAdmin: function () { return S.get('vk_admin', false) === true; },
    adminLogin: function () { S.set('vk_admin', true); },
    adminLogout: function () { S.del('vk_admin'); },
    changed: function () {
      refreshNav();
      try { w.dispatchEvent(new CustomEvent('vk-auth-change')); } catch (e) {}
    }
  };

  /* ---------- orders (replaces the `bookings` table + CompleteOrderServlet) ---------- */
  var Orders = {
    all: function () { return L.get('vk_orders', []).slice().sort(function (a, b) { return b.id - a.id; }); },
    forUser: function (name) { return Orders.all().filter(function (o) { return o.fullname === name; }); },
    add: function (o) {
      var list = L.get('vk_orders', []);
      var id = list.reduce(function (m, x) { return Math.max(m, x.id); }, 0) + 1;
      var tableId = (o.tableId && String(o.tableId).trim()) ? o.tableId : 'None';
      var date = o.bookingDate, time = o.bookingTime;
      if (tableId === 'None') {
        if (!date) date = '2099-01-01';
        if (!time) time = '00:00:00';
      } else if (time && time.length === 5) {
        time += ':00';
      }
      var rec = {
        id: id, fullname: o.fullname, tableId: tableId, bookingDate: date, bookingTime: time,
        totalBill: o.totalBill, cartData: o.cartData || '[]', status: 'Confirmed'
      };
      list.push(rec);
      L.set('vk_orders', list);
      return rec;
    },
    bookedTables: function (date, time) {
      var t = String(time || '').slice(0, 5);
      return Orders.all().filter(function (o) {
        return o.tableId !== 'None' && o.bookingDate === date && String(o.bookingTime || '').slice(0, 5) === t;
      }).map(function (o) { return o.tableId; });
    }
  };

  /* ---------- contact messages + users for the admin view ---------- */
  var Data = {
    messages: function () { return L.get('vk_messages', []).slice().sort(function (a, b) { return b.id - a.id; }); },
    addMessage: function (m) {
      var list = L.get('vk_messages', []);
      var d = new Date(), p = function (n) { return (n < 10 ? '0' : '') + n; };
      m.id = list.reduce(function (mx, x) { return Math.max(mx, x.id); }, 0) + 1;
      m.submitted_at = d.getFullYear() + '-' + p(d.getMonth() + 1) + '-' + p(d.getDate()) + ' ' + p(d.getHours()) + ':' + p(d.getMinutes());
      list.push(m);
      L.set('vk_messages', list);
    },
    users: function () { return L.get('vk_users', []).slice().sort(function (a, b) { return b.id - a.id; }); }
  };

  /* ---------- checkout hand-off (replaces POST params / forward) ---------- */
  var Checkout = {
    get: function () { return S.get('vk_checkout', null); },
    set: function (v) { S.set('vk_checkout', v); },
    clear: function () { S.del('vk_checkout'); },
    getReceipt: function () { return S.get('vk_receipt', null); },
    setReceipt: function (v) { S.set('vk_receipt', v); }
  };

  /* ---------- downscale an uploaded dish photo so it fits in localStorage ---------- */
  function readImage(file, cb) {
    if (!file) { cb(null); return; }
    var fr = new FileReader();
    fr.onerror = function () { cb(null); };
    fr.onload = function () {
      var img = new Image();
      img.onerror = function () { cb(null); };
      img.onload = function () {
        var max = 600, r = Math.min(1, max / Math.max(img.width, img.height));
        var c = document.createElement('canvas');
        c.width = Math.round(img.width * r); c.height = Math.round(img.height * r);
        c.getContext('2d').drawImage(img, 0, 0, c.width, c.height);
        cb(c.toDataURL('image/jpeg', 0.72));
      };
      img.src = fr.result;
    };
    fr.readAsDataURL(file);
  }

  /* ---------- navbar: show the right logged-in / logged-out controls ---------- */
  function refreshNav() {
    var user = Auth.user();
    [].forEach.call(document.querySelectorAll('[data-auth="in"]'), function (el) {
      if (user) el.style.removeProperty('display'); else el.style.setProperty('display', 'none', 'important');
    });
    [].forEach.call(document.querySelectorAll('[data-auth="out"]'), function (el) {
      if (user) el.style.setProperty('display', 'none', 'important'); else el.style.removeProperty('display');
    });
    [].forEach.call(document.querySelectorAll('.vk-user-name'), function (el) { el.textContent = user || ''; });
  }

  function afterAuth() {
    if (typeof w.closeAuth === 'function') w.closeAuth();
  }

  function wire() {
    refreshNav();

    // If a page has no login panel, the navbar "Log in" button goes to the home page.
    if (typeof w.openAuth !== 'function') {
      w.openAuth = function () { location.href = 'index.html'; };
    }

    [].forEach.call(document.querySelectorAll('[data-vk="logout"]'), function (a) {
      a.addEventListener('click', function () { Auth.logout(); });
    });

    [].forEach.call(document.querySelectorAll('form[data-vk]'), function (f) {
      f.addEventListener('submit', function (e) {
        var kind = f.getAttribute('data-vk');
        e.preventDefault();
        if (kind === 'login') {
          Auth.login(f.elements.email.value);
          afterAuth();
        } else if (kind === 'register') {
          Auth.register(f.elements.fullname.value, f.elements.email.value);
          afterAuth();
        } else if (kind === 'admin') {
          Auth.adminLogin();
          location.href = 'admin_dashboard.html';
        } else if (kind === 'contact') {
          Data.addMessage({
            name: f.elements.userName.value,
            email: f.elements.userEmail.value,
            message: f.elements.userMessage.value
          });
          f.reset();
          var ok = document.getElementById('contactSuccess');
          if (ok) ok.style.display = 'block';
        }
      });
    });
  }

  seed();
  w.VK = { Auth: Auth, Menu: Menu, Orders: Orders, Data: Data, Checkout: Checkout, esc: esc, money: money, readImage: readImage, refreshNav: refreshNav };

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', wire);
  else wire();
})(window);
