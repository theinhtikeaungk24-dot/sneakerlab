<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.sneaker.model.Sneaker, com.sneaker.model.User, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    List<Sneaker> sneakerList = (List<Sneaker>) request.getAttribute("sneakerList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Collection — SneakerLab</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #fff; color: #111; }

        .navbar { position: sticky; top: 0; z-index: 100; background: #fff; border-bottom: 1px solid #ebebeb; }
        .nav-main { display: flex; align-items: center; justify-content: space-between; padding: 0 48px; height: 56px; }
        .nav-social { display: flex; align-items: center; gap: 14px; }
        .nav-social a { color: #bbb; font-size: 13px; text-decoration: none; transition: color 0.2s; }
        .nav-social a:hover { color: #111; }
        .nav-links { display: flex; align-items: center; }
        .nav-links a { color: #333; text-decoration: none; font-size: 11px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; padding: 0 16px; height: 56px; display: flex; align-items: center; border-bottom: 2px solid transparent; transition: all 0.2s; position: relative; }
        .nav-links a:hover { color: #111; border-bottom-color: #111; }
        .nav-links a.active { color: #FF6B2B; border-bottom-color: #FF6B2B; }
        .nav-links a.has-drop::after { content: ' ▾'; font-size: 9px; }
        .drop-wrap { position: relative; }
        .dropdown { display: none; position: absolute; top: 100%; left: 0; background: #fff; min-width: 160px; border-top: 2px solid #FF6B2B; box-shadow: 0 8px 24px rgba(0,0,0,0.08); z-index: 200; }
        .drop-wrap:hover .dropdown { display: block; }
        .dropdown a { display: block; height: auto; padding: 12px 18px; border-bottom: 1px solid #f8f8f8; font-size: 11px; color: #555; }
        .dropdown a:hover { color: #FF6B2B; background: #fafafa; }
        .nav-actions { display: flex; align-items: center; gap: 16px; }
        .nav-icon-btn { background: none; border: none; cursor: pointer; color: #555; font-size: 16px; padding: 4px; transition: color 0.2s; text-decoration: none; }
        .nav-icon-btn:hover { color: #111; }
        .nav-divider { width: 1px; height: 18px; background: #ebebeb; }
        .btn-outline { padding: 7px 18px; border: 1.5px solid #111; border-radius: 2px; font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; color: #111; transition: all 0.2s; }
        .btn-outline:hover { background: #111; color: #fff; }
        .btn-filled { padding: 7px 18px; background: #FF6B2B; border: 1.5px solid #FF6B2B; border-radius: 2px; font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; color: #fff; transition: all 0.2s; }
        .btn-filled:hover { background: #e55a1a; }
        .search-bar { display: none; padding: 12px 48px; border-top: 1px solid #f0f0f0; background: #fafafa; }
        .search-bar.open { display: flex; align-items: center; gap: 12px; }
        .search-bar input { flex: 1; padding: 10px 16px; border: 1.5px solid #e0e0e0; border-radius: 2px; font-size: 13px; font-family: 'Inter', sans-serif; color: #111; background: #fff; }
        .search-bar input:focus { outline: none; border-color: #111; }
        .search-bar button { padding: 10px 20px; background: #111; color: #fff; border: none; border-radius: 2px; font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; cursor: pointer; }
        .search-bar button:hover { background: #FF6B2B; }

        .page-header {
            padding: 60px 60px 40px; background: #f8f8f6;
            border-bottom: 1px solid #ececec; position: relative; overflow: hidden;
        }
        .page-header-bg {
            position: absolute; right: 60px; top: 50%; transform: translateY(-50%);
            font-size: 120px; font-weight: 900; color: #ececec;
            letter-spacing: -4px; text-transform: uppercase;
            pointer-events: none; user-select: none;
            z-index: 0;
        }
        .page-label { font-size: 11px; color: #FF6B2B; letter-spacing: 4px; text-transform: uppercase; font-weight: 600; position: relative; z-index: 1; }
        .page-title { font-size: 42px; font-weight: 900; color: #111; margin-top: 8px; position: relative; z-index: 1; }
        .page-count { font-size: 13px; color: #888; margin-top: 8px; position: relative; z-index: 1; }
        .active-filter { display:inline-block; margin-top:10px; padding:4px 12px; background:#FF6B2B; color:#fff; font-size:11px; font-weight:700; letter-spacing:1px; text-transform:uppercase; border-radius:20px; }

        .grid-wrap { padding: 40px 60px 80px; }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 2px; background: #f0f0f0;
        }
        .product-card {
            background: #fff; padding: 32px 24px 24px;
            cursor: pointer; transition: transform 0.25s;
            position: relative;
        }
        .product-card:hover { transform: translateY(-4px); z-index: 2; box-shadow: 0 12px 40px rgba(0,0,0,0.08); }
        .low-badge {
            position: absolute; top: 16px; left: 16px;
            background: #FF6B2B; color: #fff;
            font-size: 9px; font-weight: 700; letter-spacing: 1px;
            padding: 4px 8px; border-radius: 2px; text-transform: uppercase;
        }
        .out-badge {
            position: absolute; top: 16px; left: 16px;
            background: #111; color: #fff;
            font-size: 9px; font-weight: 700; letter-spacing: 1px;
            padding: 4px 8px; border-radius: 2px; text-transform: uppercase;
        }
        .card-img {
            height: 190px; display: flex; align-items: center;
            justify-content: center; font-size: 96px;
            transition: transform 0.3s;
        }
        .product-card:hover .card-img { transform: scale(1.1) rotate(-5deg); }
        .card-brand { font-size: 10px; color: #aaa; letter-spacing: 2px; text-transform: uppercase; font-weight: 600; margin-top: 8px; }
        .card-name { font-size: 15px; font-weight: 700; color: #111; margin: 6px 0 4px; }
        .card-meta { font-size: 12px; color: #bbb; margin-bottom: 10px; }
        .card-stars { color: #FF6B2B; font-size: 11px; margin-bottom: 10px; }
        .card-bottom { display: flex; justify-content: space-between; align-items: center; }
        .card-price { font-size: 17px; font-weight: 800; color: #111; }
        .card-stock { font-size: 11px; color: #aaa; }
        .card-stock.low { color: #FF6B2B; font-weight: 600; }
        .card-action {
            display: block; margin-top: 16px; text-align: center;
            padding: 11px; border: 1.5px solid #111; font-size: 11px;
            font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase;
            text-decoration: none; color: #111; transition: all 0.2s;
        }
        .card-action:hover { background: #111; color: #fff; }
        .card-action.sold-out { border-color: #ddd; color: #ccc; pointer-events: none; }
        .empty { text-align: center; padding: 100px; color: #bbb; font-size: 16px; grid-column: 1/-1; }
    </style>
</head>
<body>

<div class="navbar">
    <div class="nav-main">
        <div class="nav-social">
            <a href="#">&#x66;</a><a href="#">&#x74;</a>
            <a href="#">&#x25A0;</a><a href="#">&#x40;</a>
        </div>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <div class="drop-wrap">
                <a href="products" class="active has-drop">Collection</a>
                <div class="dropdown">
                    <a href="products">All Sneakers</a>
                    <a href="products">New Arrivals</a>
                    <a href="products">Sale</a>
                </div>
            </div>
            <div class="drop-wrap">
                <a href="products?category=men" class="has-drop">For Him</a>
                <div class="dropdown"><a href="products?category=men">All Men</a><a href="products?category=unisex">Unisex</a></div>
            </div>
            <div class="drop-wrap">
                <a href="products?category=women" class="has-drop">For Her</a>
                <div class="dropdown"><a href="products?category=women">All Women</a><a href="products?category=unisex">Unisex</a></div>
            </div>
            <div class="drop-wrap">
                <a href="products?category=kids" class="has-drop">For Kids</a>
                <div class="dropdown"><a href="products?category=kids">All Kids</a></div>
            </div>
            <div class="drop-wrap">
                <a href="products" class="has-drop">Brands</a>
                <div class="dropdown">
                    <a href="products?brand=Nike">Nike</a>
                    <a href="products?brand=Adidas">Adidas</a>
                    <a href="products?brand=New Balance">New Balance</a>
                </div>
            </div>
            <% if (user != null && "admin".equals(user.getRole())) { %><a href="admin/dashboard.jsp">Admin</a><% } %>
        </div>
        <div class="nav-actions">
            <a href="cart" class="nav-icon-btn">🛒</a>
            <button class="nav-icon-btn" onclick="toggleSearch()">🔍</button>
            <div class="nav-divider"></div>
            <% if (user != null) { %>
                <a href="auth?action=logout" class="btn-outline">Logout</a>
            <% } else { %>
                <a href="login.jsp" class="btn-outline">Login</a>
                <a href="register.jsp" class="btn-filled">Register</a>
            <% } %>
        </div>
    </div>
    <div class="search-bar" id="searchBar">
        <form action="products" method="get" style="display:flex;flex:1;gap:12px;">
            <input type="text" name="search" placeholder="Search sneakers, brands, colors..."
                value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>">
            <button type="submit">Search</button>
        </form>
    </div>
</div>
<script>
function toggleSearch() {
    var bar = document.getElementById('searchBar');
    bar.classList.toggle('open');
    if (bar.classList.contains('open')) bar.querySelector('input').focus();
}
</script>

<div class="page-header">
    <div class="page-header-bg">COLLECTION</div>
    <%
        String activeFilter = (String) request.getAttribute("activeFilter");
        String activeCategory = (String) request.getAttribute("activeCategory");
        String activeBrand = (String) request.getAttribute("activeBrand");
        String searchQuery = (String) request.getAttribute("searchQuery");
        String pageTitle = "Our Collection";
        if ("men".equals(activeCategory))        pageTitle = "For Him";
        else if ("women".equals(activeCategory)) pageTitle = "For Her";
        else if ("kids".equals(activeCategory))  pageTitle = "For Kids";
        else if ("unisex".equals(activeCategory))pageTitle = "Unisex";
        else if (activeBrand != null)            pageTitle = activeBrand;
        else if (searchQuery != null)            pageTitle = "Search Results";
    %>
    <div class="page-label">
        <% if (searchQuery != null) { %>Search Results
        <% } else if (activeCategory != null) { %><%= activeCategory.toUpperCase() %>
        <% } else if (activeBrand != null) { %>Brand
        <% } else { %>Browse All<% } %>
    </div>
    <div class="page-title"><%= pageTitle %></div>
    <div class="page-count"><%= sneakerList != null ? sneakerList.size() : 0 %> products found
        <% if (activeFilter != null && !"all".equals(activeFilter)) { %>
            <span class="active-filter"><%= activeFilter %> &nbsp;✕ <a href="products" style="color:#fff;text-decoration:none;">clear</a></span>
        <% } %>
    </div>
</div>

<div class="grid-wrap">
    <div class="product-grid">
        <% if (sneakerList != null && !sneakerList.isEmpty()) {
             for (Sneaker s : sneakerList) { %>
        <div class="product-card">
            <% if (s.getStock() == 0) { %><div class="out-badge">Sold Out</div>
            <% } else if (s.getStock() < 5) { %><div class="low-badge">Low Stock</div><% } %>
            <div class="card-img">
                <% if (s.getImageUrl() != null && !s.getImageUrl().isEmpty()) { %>
                    <img src="images/sneakers/<%= s.getImageUrl() %>" alt="<%= s.getModel() %>"
                         style="width:100%;height:100%;object-fit:contain;padding:10px;">
                <% } else { %>👟<% } %>
            </div>
            <div class="card-brand"><%= s.getBrand() %></div>
            <div class="card-name"><%= s.getModel() %></div>
            <div class="card-meta">Size <%= s.getSize() %> &nbsp;·&nbsp; <%= s.getColor() %></div>
            <div class="card-stars">★★★★☆</div>
            <div class="card-bottom">
                <span class="card-price">$<%= String.format("%.2f", s.getPrice()) %></span>
                <span class="card-stock <%= s.getStock() < 5 ? "low" : "" %>">
                    <%= s.getStock() > 0 ? "In Stock" : "Sold Out" %>
                </span>
            </div>
            <a href="products?action=detail&id=<%= s.getId() %>"
               class="card-action <%= s.getStock() == 0 ? "sold-out" : "" %>">
                <%= s.getStock() == 0 ? "Sold Out" : "View Details" %>
            </a>
        </div>
        <% } } else { %>
            <div class="empty">No sneakers available yet.</div>
        <% } %>
    </div>
</div>

</body>
</html>
