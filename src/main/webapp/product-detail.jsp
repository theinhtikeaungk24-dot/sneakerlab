<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.sneaker.model.Sneaker, com.sneaker.model.User, com.sneaker.model.SneakerVariant, com.sneaker.dao.SneakerDAO, com.sneaker.dao.SneakerVariantDAO, java.util.List" %>
<%
    User user   = (User)    session.getAttribute("user");
    Sneaker s   = (Sneaker) request.getAttribute("sneaker");
    SneakerDAO dao = new SneakerDAO();
    List<Sneaker> related = dao.getAllSneakers();
    SneakerVariantDAO variantDAO = new SneakerVariantDAO();
    List<SneakerVariant> variants = (s != null) ? variantDAO.getVariantsBySneakerId(s.getId()) : new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= s != null ? s.getBrand() + " " + s.getModel() : "Product" %> — SneakerLab</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #fff; color: #111; }

        /* PROMO BAR */
        .promo-bar {
            background: #111; color: #fff; text-align: center;
            padding: 12px; font-size: 13px; font-weight: 500; letter-spacing: 0.3px;
        }
        .promo-bar span { color: #FF6B2B; font-weight: 700; margin-left: 10px; }

        /* NAV */
        nav {
            display: flex; justify-content: space-between; align-items: center;
            padding: 18px 60px; border-bottom: 1px solid #f0f0f0;
            position: sticky; top: 0; background: #fff; z-index: 100;
        }
        .logo { font-size: 20px; font-weight: 900; letter-spacing: 3px; color: #111; text-decoration: none; }
        .logo span { color: #FF6B2B; }
        .nav-links { display: flex; gap: 32px; }
        .nav-links a { color: #555; text-decoration: none; font-size: 14px; font-weight: 500; transition: color 0.2s; }
        .nav-links a:hover { color: #111; }
        .nav-actions { display: flex; align-items: center; gap: 20px; }
        .nav-icon { font-size: 20px; cursor: pointer; text-decoration: none; color: #111; }
        .btn-login {
            padding: 8px 20px; border: 1.5px solid #111; border-radius: 2px;
            font-size: 11px; font-weight: 700; letter-spacing: 1px;
            text-transform: uppercase; text-decoration: none; color: #111; transition: all 0.2s;
        }
        .btn-login:hover { background: #111; color: #fff; }

        /* BREADCRUMB */
        .breadcrumb {
            padding: 16px 60px; font-size: 13px; color: #aaa;
            border-bottom: 1px solid #f8f8f8;
        }
        .breadcrumb a { color: #aaa; text-decoration: none; }
        .breadcrumb a:hover { color: #111; }
        .breadcrumb span { margin: 0 8px; }

        /* PRODUCT LAYOUT */
        .product-wrap {
            display: flex; gap: 0; max-width: 1200px;
            margin: 0 auto; padding: 40px 60px 60px;
            align-items: flex-start;
        }

        /* IMAGE SECTION */
        .img-section { flex: 1; margin-right: 60px; }
        .main-img {
            width: 100%; background: #f8f8f6;
            border-radius: 4px; aspect-ratio: 1;
            display: flex; align-items: center; justify-content: center;
            font-size: 200px; margin-bottom: 16px;
            overflow: hidden;
        }
        .main-img img { width: 100%; height: 100%; object-fit: cover; }
        .thumb-row { display: flex; gap: 10px; }
        .thumb {
            width: 100px; height: 100px; background: #f8f8f6;
            border-radius: 4px; display: flex; align-items: center;
            justify-content: center; font-size: 40px; cursor: pointer;
            border: 2px solid transparent; transition: border-color 0.2s;
            overflow: hidden; flex-shrink: 0;
        }
        .thumb.active { border-color: #111; }
        .thumb:hover { border-color: #ccc; }
        .thumb img { width: 100%; height: 100%; object-fit: cover; }

        /* DETAIL SECTION */
        .detail-section { width: 420px; flex-shrink: 0; }

        .product-brand {
            font-size: 11px; color: #aaa; letter-spacing: 3px;
            text-transform: uppercase; font-weight: 600; margin-bottom: 8px;
        }
        .product-name { font-size: 30px; font-weight: 800; color: #111; line-height: 1.2; margin-bottom: 14px; }

        .rating-row { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; }
        .stars { color: #FF6B2B; font-size: 16px; }
        .rating-count { font-size: 13px; color: #aaa; font-weight: 500; }

        .tags { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 24px; }
        .tag {
            padding: 5px 14px; border: 1px solid #e8e8e8; border-radius: 20px;
            font-size: 12px; color: #555; font-weight: 500;
        }

        .divider { height: 1px; background: #f0f0f0; margin: 20px 0; }

        /* DESCRIPTION */
        .section-label { font-size: 14px; font-weight: 700; color: #111; margin-bottom: 10px; }
        .description { font-size: 14px; color: #777; line-height: 1.8; margin-bottom: 24px; }

        /* SIZE CHART */
        .size-toggle { display: flex; gap: 0; border: 1.5px solid #e8e8e8; border-radius: 4px; overflow: hidden; width: fit-content; margin-bottom: 16px; }
        .size-tab {
            padding: 7px 18px; font-size: 12px; font-weight: 600;
            cursor: pointer; background: #fff; color: #aaa;
            border: none; transition: all 0.2s; letter-spacing: 0.5px;
        }
        .size-tab.active { background: #111; color: #fff; }

        .size-grid { display: grid; grid-template-columns: repeat(6, 1fr); gap: 8px; margin-bottom: 24px; }
        .size-btn {
            padding: 10px 6px; border: 1.5px solid #e8e8e8; border-radius: 4px;
            font-size: 13px; font-weight: 600; text-align: center; cursor: pointer;
            background: #fff; color: #333; transition: all 0.2s;
        }
        .size-btn:hover { border-color: #111; }
        .size-btn.selected { background: #111; color: #fff; border-color: #111; }
        .size-btn.unavailable { background: #f8f8f8; color: #ccc; border-color: #f0f0f0; cursor: not-allowed; text-decoration: line-through; }

        /* QUANTITY */
        .qty-label { font-size: 14px; font-weight: 700; color: #111; margin-bottom: 12px; }
        .qty-row { display: flex; align-items: center; gap: 0; margin-bottom: 24px; }
        .qty-btn {
            width: 40px; height: 40px; border: 1.5px solid #e8e8e8;
            background: #fff; font-size: 18px; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            transition: all 0.2s; font-weight: 300; color: #111;
        }
        .qty-btn:hover { background: #111; color: #fff; border-color: #111; }
        .qty-display {
            width: 52px; height: 40px; border-top: 1.5px solid #e8e8e8;
            border-bottom: 1.5px solid #e8e8e8; display: flex;
            align-items: center; justify-content: center;
            font-size: 15px; font-weight: 700; background: #111; color: #fff;
        }

        /* PRICE */
        .price-row { margin-bottom: 16px; }
        .price-main { font-size: 28px; font-weight: 900; color: #111; }

        /* DISCOUNT BOX */
        .discount-box {
            background: #fff7ed; border: 1px solid #fed7aa;
            border-radius: 4px; padding: 14px 16px; margin-bottom: 24px;
        }
        .discount-title { font-size: 13px; font-weight: 700; color: #FF6B2B; margin-bottom: 4px; }
        .discount-desc { font-size: 12px; color: #aaa; line-height: 1.5; }

        /* ACTION BUTTONS */
        .action-row { display: flex; gap: 12px; margin-bottom: 28px; }
        .btn-buy {
            flex: 1; padding: 16px; background: #111; color: #fff;
            border: none; border-radius: 2px; font-size: 13px; font-weight: 700;
            letter-spacing: 1px; text-transform: uppercase; cursor: pointer;
            transition: background 0.2s;
        }
        .btn-buy:hover { background: #FF6B2B; }
        .btn-cart {
            flex: 1; padding: 16px; background: #fff; color: #111;
            border: 1.5px solid #111; border-radius: 2px; font-size: 13px;
            font-weight: 700; letter-spacing: 1px; text-transform: uppercase;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-cart:hover { background: #111; color: #fff; }
        .btn-cart:disabled { border-color: #ddd; color: #ccc; cursor: not-allowed; }

        /* ACCORDION */
        .accordion { border-top: 1px solid #f0f0f0; }
        .accordion-item { border-bottom: 1px solid #f0f0f0; }
        .accordion-header {
            display: flex; justify-content: space-between; align-items: center;
            padding: 18px 0; cursor: pointer; user-select: none;
        }
        .accordion-header span { font-size: 14px; font-weight: 700; color: #111; }
        .accordion-arrow { font-size: 18px; color: #aaa; transition: transform 0.3s; }
        .accordion-header.open .accordion-arrow { transform: rotate(180deg); }
        .accordion-body {
            display: none; padding: 0 0 18px; font-size: 13px;
            color: #777; line-height: 1.8;
        }
        .accordion-body.open { display: block; }

        /* RELATED */
        .related-section { padding: 60px; border-top: 1px solid #f0f0f0; }
        .related-title { font-size: 22px; font-weight: 800; color: #111; margin-bottom: 28px; }
        .related-grid {
            display: grid; grid-template-columns: repeat(4, 1fr); gap: 2px; background: #f0f0f0;
        }
        .related-card {
            background: #fff; padding: 24px 20px 20px; text-decoration: none;
            transition: transform 0.2s; display: block;
        }
        .related-card:hover { transform: translateY(-3px); }
        .related-img { height: 140px; display: flex; align-items: center; justify-content: center; font-size: 70px; margin-bottom: 14px; transition: transform 0.3s; }
        .related-card:hover .related-img { transform: scale(1.08) rotate(-4deg); }
        .related-brand { font-size: 10px; color: #aaa; letter-spacing: 2px; text-transform: uppercase; font-weight: 600; }
        .related-name { font-size: 14px; font-weight: 700; color: #111; margin: 4px 0 8px; }
        .related-price { font-size: 15px; font-weight: 800; color: #111; }

        /* COLOR PICKER */
        .color-row { display: flex; align-items: center; gap: 10px; margin-bottom: 24px; flex-wrap: wrap; }
        .color-swatch {
            width: 34px; height: 34px; border-radius: 50%; cursor: pointer;
            border: 2px solid transparent; transition: all 0.2s;
            position: relative; flex-shrink: 0;
        }
        .color-swatch:hover { transform: scale(1.12); }
        .color-swatch.selected { border-color: #111; box-shadow: 0 0 0 3px #fff, 0 0 0 5px #111; }
        .color-swatch[data-color="White"],
        .color-swatch[data-color="white"] { background: #fff; border-color: #ddd; }
        .color-swatch[data-color="White"].selected,
        .color-swatch[data-color="white"].selected { border-color: #111; }
        .color-name-label { font-size: 12px; color: #888; margin-left: 4px; font-style: italic; }
        .color-section-top { display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px; }
        .color-section-top .section-label { margin-bottom: 0; }
        .selected-color-name { font-size: 12px; color: #888; font-weight: 500; }

        .out-of-stock-msg {
            background: #fef2f2; border: 1px solid #fecaca; border-radius: 4px;
            padding: 14px 16px; margin-bottom: 20px; font-size: 13px;
            color: #ef4444; font-weight: 600;
        }
    </style>
</head>
<body>

<!-- PROMO BAR -->
<div class="promo-bar">
    Get 10% Off Your First Order — Use code SNEAKERLAB10
    <span>Shop Now →</span>
</div>

<!-- NAV -->
<nav>
    <a href="index.jsp" class="logo">Sneaker<span>Lab</span></a>
    <div class="nav-links">
        <a href="products">Collection</a>
        <a href="products">Brands</a>
        <% if (user != null && "admin".equals(user.getRole())) { %><a href="admin/dashboard.jsp">Admin</a><% } %>
    </div>
    <div class="nav-actions">
        <a href="cart" class="nav-icon">🛒</a>
        <% if (user != null) { %>
            <a href="auth?action=logout" class="btn-login">Logout</a>
        <% } else { %>
            <a href="login.jsp" class="btn-login">Login</a>
        <% } %>
    </div>
</nav>

<% if (s != null) { %>

<!-- BREADCRUMB -->
<div class="breadcrumb">
    <a href="index.jsp">Home</a><span>/</span>
    <a href="products">Collection</a><span>/</span>
    <a href="products"><%= s.getBrand() %></a><span>/</span>
    <%= s.getModel() %>
</div>

<!-- PRODUCT -->
<div class="product-wrap">
    <!-- LEFT: IMAGES -->
    <div class="img-section">
        <div class="main-img" id="mainImg">
            <% if (s.getImageUrl() != null && !s.getImageUrl().isEmpty()) { %>
                <img src="images/sneakers/<%= s.getImageUrl() %>" alt="<%= s.getModel() %>"
                     style="width:100%;height:100%;object-fit:contain;">
            <% } else { %>
                <span style="font-size:140px">👟</span>
            <% } %>
        </div>
        <div class="thumb-row">
            <div class="thumb active">
                <% if (s.getImageUrl() != null && !s.getImageUrl().isEmpty()) { %>
                    <img src="images/sneakers/<%= s.getImageUrl() %>" alt="" style="width:100%;height:100%;object-fit:contain;">
                <% } else { %>👟<% } %>
            </div>
        </div>
    </div>

    <!-- RIGHT: DETAILS -->
    <div class="detail-section">
        <div class="product-brand"><%= s.getBrand() %></div>
        <div class="product-name"><%= s.getModel() %></div>

        <div class="rating-row">
            <span class="stars">★★★★☆</span>
            <span class="rating-count">4.0 &nbsp;·&nbsp; 128 Reviews</span>
        </div>

        <div class="tags">
            <span class="tag">Running Shoes</span>
            <span class="tag">Casual Sneakers</span>
            <% if (s.getStock() < 5 && s.getStock() > 0) { %><span class="tag" style="border-color:#FF6B2B;color:#FF6B2B;">Low Stock</span><% } %>
        </div>

        <div class="divider"></div>

        <div class="section-label">Product Description</div>
        <div class="description">
            Experience premium comfort and iconic style with the <%= s.getBrand() %> <%= s.getModel() %>.
            Designed for everyday wear, this sneaker combines a durable outsole with a cushioned
            midsole for all-day support. Available in <%= s.getColor() %>, this pair elevates any outfit.
        </div>

        <%
            // ── Colour palette (name → CSS hex) ─────────────────
            String[][] colorPalette = {
                {"Black","#111111"},{"White","#FFFFFF"},{"Red","#EF4444"},
                {"Blue","#3B82F6"},{"Navy","#1E3A5F"},{"Gray","#9CA3AF"},
                {"Green","#22C55E"},{"Orange","#FF6B2B"},{"Pink","#EC4899"},
                {"Yellow","#EAB308"},{"Brown","#92400E"},{"Purple","#8B5CF6"},
                {"Beige","#D4C5A9"},{"Teal","#14B8A6"},{"Maroon","#7F1D1D"}
            };
            java.util.Map<String,String> paletteMap = new java.util.LinkedHashMap<>();
            for (String[] c : colorPalette) paletteMap.put(c[0].toLowerCase(), c[1]);

            String baseColor    = (s.getColor() != null ? s.getColor().trim() : "Black");
            String baseImageUrl = (s.getImageUrl() != null ? s.getImageUrl() : "");
        %>

        <% if (!variants.isEmpty()) { %>
        <div class="divider"></div>

        <!-- COLOUR PICKER -->
        <div class="color-section-top">
            <div class="section-label">Select Colour</div>
            <span class="selected-color-name" id="selectedColorName"><%= baseColor %></span>
        </div>
        <div class="color-row" id="colorRow">
            <%-- Base product colour (always first) --%>
            <%
                String baseHex = paletteMap.getOrDefault(baseColor.toLowerCase(), "#111111");
                boolean baseIsWhite = baseColor.equalsIgnoreCase("White");
            %>
            <div class="color-swatch selected"
                 data-color="<%= baseColor %>"
                 data-img="<%= baseImageUrl %>"
                 style="background:<%= baseHex %>;<%= baseIsWhite ? "border-color:#ddd;" : "" %>"
                 title="<%= baseColor %>"
                 onclick="selectColor(this, '<%= baseColor %>')"></div>

            <%-- Variant colours ─────────────────────────────────── --%>
            <% for (SneakerVariant vt : variants) {
                   String vColor  = vt.getColor() != null ? vt.getColor().trim() : "Black";
                   String vImg    = vt.getImageUrl() != null ? vt.getImageUrl() : "";
                   String vHex    = paletteMap.getOrDefault(vColor.toLowerCase(), "#888888");
                   boolean vWhite = vColor.equalsIgnoreCase("White");
            %>
            <div class="color-swatch"
                 data-color="<%= vColor %>"
                 data-img="<%= vImg %>"
                 style="background:<%= vHex %>;<%= vWhite ? "border-color:#ddd;" : "" %>"
                 title="<%= vColor %>"
                 onclick="selectColor(this, '<%= vColor %>')"></div>
            <% } %>
        </div>
        <% } %>

        <div class="divider"></div>

        <!-- SIZE CHART -->
        <div class="section-label">Size Chart</div>
        <div class="size-toggle">
            <button class="size-tab active" onclick="switchTab(this)">US</button>
            <button class="size-tab" onclick="switchTab(this)">EU</button>
            <button class="size-tab" onclick="switchTab(this)">CM</button>
        </div>

        <div class="size-grid" id="sizeGrid">
            <%
                double[] sizes = {6.5,7.0,7.5,8.0,8.5,9.0,9.5,10.0,10.5,11.0,11.5,12.0};
                double productSize = s.getSize();
            %>
            <% for (double sz : sizes) { %>
                <div class="size-btn <%= sz == productSize ? "selected" : "" %>"
                     onclick="selectSize(this)"><%= sz == Math.floor(sz) ? String.valueOf((int)sz) + ".0" : String.valueOf(sz) %></div>
            <% } %>
        </div>

        <!-- QUANTITY -->
        <div class="qty-label">Item Quantity</div>
        <div class="qty-row">
            <button class="qty-btn" onclick="changeQty(-1)">−</button>
            <div class="qty-display" id="qtyDisplay">1</div>
            <button class="qty-btn" onclick="changeQty(1)">+</button>
        </div>

        <!-- PRICE -->
        <div class="price-row">
            <div class="price-main">$<%= String.format("%.2f", s.getPrice()) %></div>
        </div>

        <!-- DISCOUNT -->
        <div class="discount-box">
            <div class="discount-title">🏷️ Member Discount Available</div>
            <div class="discount-desc">Register an account to unlock exclusive member pricing and early access to new drops.</div>
        </div>

        <!-- OUT OF STOCK -->
        <% if (s.getStock() == 0) { %>
            <div class="out-of-stock-msg">⚠️ This item is currently out of stock.</div>
        <% } %>

        <!-- ACTION BUTTONS -->
        <div class="action-row">
            <% if (s.getStock() > 0) { %>
                <form action="cart" method="post" style="flex:1;display:flex;gap:12px;" id="cartForm">
                    <input type="hidden" name="sneakerId" value="<%= s.getId() %>">
                    <input type="hidden" name="action"    value="add">
                    <input type="hidden" name="quantity"  id="qtyInput" value="1">
                    <button type="submit" class="btn-buy" onclick="setQty()">Buy Now</button>
                    <button type="submit" class="btn-cart" onclick="setQty()">Add To Cart</button>
                </form>
            <% } else { %>
                <button class="btn-buy" disabled style="flex:1;opacity:0.4;cursor:not-allowed;">Out of Stock</button>
                <button class="btn-cart" disabled style="flex:1;opacity:0.4;cursor:not-allowed;">Out of Stock</button>
            <% } %>
        </div>

        <!-- ACCORDION -->
        <div class="accordion">
            <div class="accordion-item">
                <div class="accordion-header" onclick="toggleAccordion(this)">
                    <span>Reviews</span>
                    <span class="accordion-arrow">∨</span>
                </div>
                <div class="accordion-body">
                    ★★★★☆ &nbsp;"Great sneakers, very comfortable for daily use."<br><br>
                    ★★★★★ &nbsp;"Perfect fit, exactly as described. Highly recommend!"<br><br>
                    ★★★★☆ &nbsp;"Good quality, fast shipping. Will buy again."
                </div>
            </div>
            <div class="accordion-item">
                <div class="accordion-header" onclick="toggleAccordion(this)">
                    <span>Shipping Method</span>
                    <span class="accordion-arrow">∨</span>
                </div>
                <div class="accordion-body">
                    🚚 &nbsp;<strong>Standard Shipping</strong> — 3-5 business days &nbsp;(Free)<br><br>
                    ⚡ &nbsp;<strong>Express Shipping</strong> — 1-2 business days &nbsp;($9.99)<br><br>
                    Free returns within 30 days on all orders.
                </div>
            </div>
        </div>
    </div>
</div>

<!-- RELATED PRODUCTS -->
<div class="related-section">
    <div class="related-title">You May Also Like</div>
    <div class="related-grid">
        <% int count = 0;
           for (Sneaker r : related) {
               if (r.getId() == s.getId() || count >= 4) continue;
               count++;
        %>
        <a href="products?action=detail&id=<%= r.getId() %>" class="related-card">
            <div class="related-img">👟</div>
            <div class="related-brand"><%= r.getBrand() %></div>
            <div class="related-name"><%= r.getModel() %></div>
            <div class="related-price">$<%= String.format("%.2f", r.getPrice()) %></div>
        </a>
        <% } %>
    </div>
</div>

<% } else { %>
    <div style="text-align:center; padding:100px; color:#bbb; font-size:16px;">Product not found.</div>
<% } %>

<script>
    // Quantity
    let qty = 1;
    const maxStock = <%= s != null ? s.getStock() : 0 %>;

    function changeQty(delta) {
        qty = Math.max(1, Math.min(maxStock, qty + delta));
        document.getElementById('qtyDisplay').textContent = qty;
    }
    function setQty() {
        document.getElementById('qtyInput').value = qty;
    }

    // Size selector
    function selectSize(el) {
        document.querySelectorAll('.size-btn').forEach(b => b.classList.remove('selected'));
        el.classList.add('selected');
    }

    // Size tab toggle
    function switchTab(el) {
        document.querySelectorAll('.size-tab').forEach(t => t.classList.remove('active'));
        el.classList.add('active');
    }

    // ── Colour selector + image swap ────────────────────
    var baseImageUrl = '<%= (s != null && s.getImageUrl() != null) ? s.getImageUrl() : "" %>';
    var ctxPath      = '<%= request.getContextPath() %>';

    function selectColor(el, colorName) {
        // Highlight selected swatch
        document.querySelectorAll('.color-swatch').forEach(sw => sw.classList.remove('selected'));
        el.classList.add('selected');
        document.getElementById('selectedColorName').textContent = colorName;

        // Swap main image
        var imgUrl = el.getAttribute('data-img');
        var mainEl = document.getElementById('mainImg');
        var thumbEl = document.querySelector('.thumb.active img') || document.querySelector('.thumb img');

        if (imgUrl && imgUrl !== '') {
            var src = ctxPath + '/images/sneakers/' + imgUrl;
            // update main image
            var mainImg = mainEl.querySelector('img');
            if (mainImg) {
                mainImg.src = src;
            } else {
                // was an emoji — replace with img
                mainEl.innerHTML = '<img src="' + src + '" alt="' + colorName + '" style="width:100%;height:100%;object-fit:contain;">';
            }
            // update active thumbnail
            if (thumbEl) thumbEl.src = src;
        }
    }

    // Accordion
    function toggleAccordion(header) {
        header.classList.toggle('open');
        const body = header.nextElementSibling;
        body.classList.toggle('open');
    }
</script>

</body>
</html>
