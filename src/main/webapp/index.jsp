<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.sneaker.model.User, com.sneaker.model.Sneaker, com.sneaker.dao.SneakerDAO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    SneakerDAO dao = new SneakerDAO();
    List<Sneaker> featured = dao.getAllSneakers();
%>
<!DOCTYPE html>
<html>
<head>
    <title>SneakerLab — Premium Sneakers</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #fff; color: #111; }

        /* ── SPLASH ── */
        #splash {
            position: fixed; inset: 0; background: #fff;
            display: flex; flex-direction: column;
            align-items: center; justify-content: center;
            z-index: 9999;
            transition: opacity 0.6s ease, visibility 0.6s ease;
        }
        #splash.hide { opacity: 0; visibility: hidden; }
        .splash-sneaker {
            font-size: 90px;
            animation: sneakerDrop 0.7s cubic-bezier(.22,1.2,.6,1) both,
                       sneakerBounce 0.4s ease 0.7s both;
            filter: drop-shadow(0 20px 40px rgba(0,0,0,0.15));
        }
        .splash-title {
            font-size: 32px; font-weight: 900; color: #111;
            margin-top: 20px; letter-spacing: 4px; text-transform: uppercase;
            opacity: 0; animation: fadeUp 0.5s ease 1s forwards;
        }
        .splash-title span { color: #FF6B2B; }
        .splash-bar {
            width: 180px; height: 2px; background: #eee;
            border-radius: 10px; margin-top: 18px; overflow: hidden;
            opacity: 0; animation: fadeUp 0.5s ease 1.1s forwards;
        }
        .splash-bar-fill {
            height: 100%; width: 0; background: #FF6B2B;
            animation: barFill 1s ease 1.2s forwards;
        }
        @keyframes sneakerDrop {
            0%   { transform: translateY(-180px) rotate(-15deg); opacity: 0; }
            100% { transform: translateY(0) rotate(0deg); opacity: 1; }
        }
        @keyframes sneakerBounce {
            0% { transform: scaleY(0.85) scaleX(1.1); }
            50% { transform: scaleY(1.08) scaleX(0.96); }
            100% { transform: scaleY(1) scaleX(1); }
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(14px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes barFill { from { width: 0; } to { width: 100%; } }

        #main-content { opacity: 0; transition: opacity 0.5s ease; }
        #main-content.visible { opacity: 1; }

        /* ── NAV ── */
        .navbar {
            position: sticky; top: 0; z-index: 100;
            background: #fff; border-bottom: 1px solid #ebebeb;
        }
        .nav-main {
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 48px; height: 56px;
        }

        /* Social icons */
        .nav-social { display: flex; align-items: center; gap: 14px; }
        .nav-social a { color: #bbb; font-size: 13px; text-decoration: none; transition: color 0.2s; }
        .nav-social a:hover { color: #111; }

        /* Center links */
        .nav-links { display: flex; align-items: center; gap: 0; }
        .nav-links a {
            color: #333; text-decoration: none; font-size: 11px;
            font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase;
            padding: 0 16px; height: 56px; display: flex; align-items: center;
            border-bottom: 2px solid transparent; transition: all 0.2s; position: relative;
        }
        .nav-links a:hover { color: #111; border-bottom-color: #111; }
        .nav-links a.active { color: #FF6B2B; border-bottom-color: #FF6B2B; }

        /* Dropdown arrow */
        .nav-links a.has-drop::after { content: ' ▾'; font-size: 9px; }

        /* Dropdown menu */
        .nav-links .drop-wrap { position: relative; }
        .nav-links .dropdown {
            display: none; position: absolute; top: 100%; left: 0;
            background: #fff; min-width: 160px; border-top: 2px solid #FF6B2B;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08); z-index: 200;
        }
        .nav-links .drop-wrap:hover .dropdown { display: block; }
        .nav-links .dropdown a {
            display: block; height: auto; padding: 12px 18px;
            border-bottom: 1px solid #f8f8f8; border-left: none; border-right: none;
            border-top: none; font-size: 11px; color: #555;
        }
        .nav-links .dropdown a:hover { color: #FF6B2B; background: #fafafa; border-bottom-color: #f8f8f8; }

        /* Right actions */
        .nav-actions { display: flex; align-items: center; gap: 16px; }
        .nav-icon-btn { background: none; border: none; cursor: pointer; color: #555; font-size: 16px; padding: 4px; transition: color 0.2s; text-decoration: none; }
        .nav-icon-btn:hover { color: #111; }
        .nav-divider { width: 1px; height: 18px; background: #ebebeb; }
        .btn-login {
            padding: 7px 18px; border: 1.5px solid #111;
            border-radius: 2px; font-size: 11px; font-weight: 700;
            text-decoration: none; color: #111; letter-spacing: 1px;
            text-transform: uppercase; transition: all 0.2s;
        }
        .btn-login:hover { background: #111; color: #fff; }
        .btn-register {
            padding: 7px 18px; background: #FF6B2B; border: 1.5px solid #FF6B2B;
            border-radius: 2px; font-size: 11px; font-weight: 700;
            text-decoration: none; color: #fff; letter-spacing: 1px;
            text-transform: uppercase; transition: all 0.2s;
        }
        .btn-register:hover { background: #e55a1a; }

        /* Search bar (hidden by default) */
        .search-bar {
            display: none; padding: 12px 48px;
            border-top: 1px solid #f0f0f0; background: #fafafa;
        }
        .search-bar.open { display: flex; align-items: center; gap: 12px; }
        .search-bar input {
            flex: 1; padding: 10px 16px; border: 1.5px solid #e0e0e0;
            border-radius: 2px; font-size: 13px; font-family: 'Inter', sans-serif;
            color: #111; background: #fff;
        }
        .search-bar input:focus { outline: none; border-color: #111; }
        .search-bar button {
            padding: 10px 20px; background: #111; color: #fff; border: none;
            border-radius: 2px; font-size: 11px; font-weight: 700;
            letter-spacing: 1px; text-transform: uppercase; cursor: pointer;
        }
        .search-bar button:hover { background: #FF6B2B; }

        /* ── HERO ── */
        .hero {
            display: flex; align-items: center;
            min-height: 88vh; padding: 0 60px;
            background: #f8f8f6; overflow: hidden; position: relative;
        }
        .hero-text { flex: 1; z-index: 2; }
        .hero-sub {
            font-size: 11px; font-weight: 600; letter-spacing: 4px;
            text-transform: uppercase; color: #FF6B2B; margin-bottom: 16px;
        }
        .hero-title {
            font-size: clamp(56px, 8vw, 110px);
            font-weight: 900; line-height: 0.9;
            color: #111; text-transform: lowercase; letter-spacing: -2px;
        }
        .hero-title .dot { color: #FF6B2B; }
        .hero-desc {
            font-size: 15px; color: #777; margin: 28px 0 36px;
            font-weight: 400; max-width: 380px; line-height: 1.7;
        }
        .btn-shop {
            display: inline-flex; align-items: center; gap: 10px;
            background: #111; color: #fff; padding: 16px 36px;
            font-size: 12px; font-weight: 700; letter-spacing: 2px;
            text-transform: uppercase; text-decoration: none;
            border-radius: 2px; transition: all 0.25s;
        }
        .btn-shop:hover { background: #FF6B2B; }
        .hero-image {
            flex: 1; display: flex; align-items: center; justify-content: center;
            font-size: 240px; position: relative;
            animation: heroFloat 3s ease-in-out infinite;
            filter: drop-shadow(0 40px 60px rgba(0,0,0,0.12));
        }
        .hero-bg-text {
            position: absolute; font-size: clamp(80px, 14vw, 180px);
            font-weight: 900; color: #ececec; letter-spacing: -4px;
            text-transform: uppercase; right: 60px; bottom: 40px;
            z-index: 1; pointer-events: none; user-select: none;
        }
        @keyframes heroFloat {
            0%, 100% { transform: translateY(0) rotate(-5deg); }
            50%       { transform: translateY(-18px) rotate(-5deg); }
        }

        /* ── SECTION HEADER ── */
        .section-header {
            text-align: center; padding: 80px 60px 50px; position: relative;
        }
        .section-bg-text {
            font-size: clamp(50px, 9vw, 120px); font-weight: 900;
            color: #f0f0f0; letter-spacing: -3px; text-transform: uppercase;
            position: absolute; top: 50%; left: 50%;
            transform: translate(-50%, -30%);
            white-space: nowrap; pointer-events: none; user-select: none;
            z-index: 0;
        }
        .section-label { font-size: 11px; color: #FF6B2B; letter-spacing: 4px; text-transform: uppercase; font-weight: 600; position: relative; z-index: 1; }
        .section-title { font-size: 36px; font-weight: 800; color: #111; margin-top: 6px; position: relative; z-index: 1; }

        /* ── PRODUCT GRID ── */
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 2px; padding: 0 60px 80px; background: #f0f0f0;
        }
        .product-card {
            background: #fff; padding: 28px 20px 24px;
            cursor: pointer; transition: transform 0.25s;
            position: relative;
        }
        .product-card:hover { transform: translateY(-4px); }
        .sale-badge {
            position: absolute; top: 16px; left: 16px;
            background: #FF6B2B; color: #fff;
            font-size: 10px; font-weight: 700; letter-spacing: 1px;
            padding: 4px 8px; border-radius: 2px; text-transform: uppercase;
        }
        .card-img {
            height: 180px; display: flex; align-items: center;
            justify-content: center; font-size: 90px; margin-bottom: 20px;
            transition: transform 0.3s;
        }
        .product-card:hover .card-img { transform: scale(1.08) rotate(-3deg); }
        .card-brand { font-size: 10px; color: #aaa; letter-spacing: 2px; text-transform: uppercase; font-weight: 600; }
        .card-name { font-size: 15px; font-weight: 700; color: #111; margin: 6px 0; }
        .card-stars { color: #FF6B2B; font-size: 12px; margin-bottom: 10px; }
        .card-price { font-size: 16px; font-weight: 700; color: #111; }
        .card-price .old { color: #bbb; text-decoration: line-through; font-size: 13px; margin-right: 6px; font-weight: 400; }
        .card-action {
            display: block; margin-top: 14px; text-align: center;
            padding: 10px; border: 1.5px solid #111; font-size: 11px;
            font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase;
            text-decoration: none; color: #111; transition: all 0.2s;
        }
        .card-action:hover { background: #111; color: #fff; }

        /* ── BANNER ── */
        .banner {
            background: #111; color: #fff;
            display: flex; align-items: center; justify-content: space-between;
            padding: 60px; margin: 0;
        }
        .banner h2 { font-size: 36px; font-weight: 900; }
        .banner h2 span { color: #FF6B2B; }
        .banner p { color: #888; margin-top: 10px; font-size: 14px; }
        .btn-banner {
            padding: 16px 40px; border: 2px solid #fff; color: #fff;
            font-size: 12px; font-weight: 700; letter-spacing: 2px;
            text-transform: uppercase; text-decoration: none;
            transition: all 0.2s; white-space: nowrap;
        }
        .btn-banner:hover { background: #FF6B2B; border-color: #FF6B2B; }

        /* ── FOOTER ── */
        footer {
            text-align: center; padding: 30px;
            color: #aaa; font-size: 12px; border-top: 1px solid #f0f0f0;
            letter-spacing: 1px; text-transform: uppercase;
        }
    </style>
</head>
<body>

<!-- SPLASH -->
<div id="splash">
    <div class="splash-sneaker">👟</div>
    <div class="splash-title">Sneaker<span>Lab</span></div>
    <div class="splash-bar"><div class="splash-bar-fill"></div></div>
</div>

<div id="main-content">

<!-- NAVBAR -->
<div class="navbar">
    <div class="nav-main">

        <!-- LEFT: Social Icons -->
        <div class="nav-social">
            <a href="#" title="Facebook">&#x66;</a>
            <a href="#" title="Twitter">&#x74;</a>
            <a href="#" title="YouTube">&#x25A0;</a>
            <a href="#" title="Instagram">&#x40;</a>
        </div>

        <!-- CENTER: Nav Links -->
        <div class="nav-links">
            <a href="index.jsp" class="active">Home</a>

            <div class="drop-wrap">
                <a href="products" class="has-drop">Collection</a>
                <div class="dropdown">
                    <a href="products">All Sneakers</a>
                    <a href="products">New Arrivals</a>
                    <a href="products">Sale</a>
                </div>
            </div>

            <div class="drop-wrap">
                <a href="products?category=men" class="has-drop">For Him</a>
                <div class="dropdown">
                    <a href="products?category=men">All Men</a>
                    <a href="products?category=unisex">Unisex</a>
                </div>
            </div>

            <div class="drop-wrap">
                <a href="products?category=women" class="has-drop">For Her</a>
                <div class="dropdown">
                    <a href="products?category=women">All Women</a>
                    <a href="products?category=unisex">Unisex</a>
                </div>
            </div>

            <div class="drop-wrap">
                <a href="products?category=kids" class="has-drop">For Kids</a>
                <div class="dropdown">
                    <a href="products?category=kids">All Kids</a>
                </div>
            </div>

            <div class="drop-wrap">
                <a href="products" class="has-drop">Brands</a>
                <div class="dropdown">
                    <a href="products?brand=Nike">Nike</a>
                    <a href="products?brand=Adidas">Adidas</a>
                    <a href="products?brand=New Balance">New Balance</a>
                </div>
            </div>

            <% if (user != null && "admin".equals(user.getRole())) { %>
                <a href="admin/dashboard.jsp">Admin</a>
            <% } %>
        </div>

        <!-- RIGHT: Actions -->
        <div class="nav-actions">
            <a href="cart" class="nav-icon-btn" title="Cart">🛒</a>
            <button class="nav-icon-btn" onclick="toggleSearch()" title="Search">🔍</button>
            <div class="nav-divider"></div>
            <% if (user != null) { %>
                <a href="auth?action=logout" class="btn-login">Logout</a>
            <% } else { %>
                <a href="login.jsp"    class="btn-login">Login</a>
                <a href="register.jsp" class="btn-register">Register</a>
            <% } %>
        </div>
    </div>

    <!-- SEARCH BAR -->
    <div class="search-bar" id="searchBar">
        <form action="products" method="get" style="display:flex;flex:1;gap:12px;">
            <input type="text" name="search" placeholder="Search sneakers, brands, colors...">
            <button type="submit">Search</button>
        </form>
    </div>
</div>

<!-- HERO -->
<div class="hero">
    <div class="hero-text">
        <div class="hero-sub">New Collection 2026</div>
        <div class="hero-title">snea<span class="dot">.</span>ker</div>
        <p class="hero-desc">Discover the latest styles from top brands. Premium quality, unbeatable comfort.</p>
        <a href="products" class="btn-shop">Shop Now &nbsp;→</a>
    </div>
    <div class="hero-image">👟</div>
    <div class="hero-bg-text">SNEAKER</div>
</div>

<!-- FEATURED PRODUCTS -->
<div class="section-header">
    <div class="section-bg-text">FEATURED</div>
    <div class="section-label">Our Collection</div>
    <div class="section-title">Featured Products</div>
</div>

<div class="product-grid">
    <% if (featured != null && !featured.isEmpty()) {
         int count = 0;
         for (Sneaker s : featured) {
           if (count >= 4) break;
           count++;
    %>
    <div class="product-card">
        <% if (s.getStock() < 5 && s.getStock() > 0) { %><div class="sale-badge">Low Stock</div><% } %>
        <div class="card-img">
            <% if (s.getImageUrl() != null && !s.getImageUrl().isEmpty()) { %>
                <img src="images/sneakers/<%= s.getImageUrl() %>" alt="<%= s.getModel() %>"
                     style="width:100%;height:100%;object-fit:contain;padding:8px;">
            <% } else { %>👟<% } %>
        </div>
        <div class="card-brand"><%= s.getBrand() %></div>
        <div class="card-name"><%= s.getModel() %></div>
        <div class="card-stars">★★★★☆</div>
        <div class="card-price">$<%= String.format("%.2f", s.getPrice()) %></div>
        <a href="products?action=detail&id=<%= s.getId() %>" class="card-action">View Details</a>
    </div>
    <% } } else { %>
        <div style="padding:60px; color:#aaa; text-align:center;">No products yet.</div>
    <% } %>
</div>

<!-- BANNER -->
<div class="banner">
    <div>
        <h2>Best <span>Seller</span> Products</h2>
        <p>Top picks from our warehouse — loved by thousands of customers.</p>
    </div>
    <a href="products" class="btn-banner">View All Products</a>
</div>

<!-- FOOTER -->
<footer>© 2026 SneakerLab. All rights reserved.</footer>

</div><!-- end main-content -->

<script>
    window.addEventListener('load', function () {
        setTimeout(function () {
            document.getElementById('splash').classList.add('hide');
            document.getElementById('main-content').classList.add('visible');
        }, 2400);
    });

    function toggleSearch() {
        var bar = document.getElementById('searchBar');
        bar.classList.toggle('open');
        if (bar.classList.contains('open')) {
            bar.querySelector('input').focus();
        }
    }
</script>
</body>
</html>
