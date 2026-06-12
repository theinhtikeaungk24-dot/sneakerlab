<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.sneaker.model.User, com.sneaker.servlet.CartServlet.CartItem, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cart — SneakerLab</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #0D1B2A; color: #fff; }
        nav {
            background: #1A3050; padding: 16px 40px;
            display: flex; justify-content: space-between; align-items: center;
            border-bottom: 3px solid #2366A0;
        }
        .logo { font-size: 22px; font-weight: bold; color: #5BB8F5; }
        .nav-links a { color: #A8D4F0; text-decoration: none; margin-left: 24px; font-size: 14px; }
        .nav-links a:hover { color: #5BB8F5; }
        .btn-nav {
            background: #2366A0; color: #fff; padding: 8px 18px;
            border-radius: 6px; text-decoration: none; font-size: 13px; margin-left: 12px;
        }
        .btn-nav:hover { background: #5BB8F5; color: #0D1B2A; }

        .container { max-width: 800px; margin: 50px auto; padding: 0 24px; }
        .page-title { font-size: 26px; font-weight: bold; margin-bottom: 6px; }
        .page-sub { color: #7BAABF; font-size: 14px; margin-bottom: 30px; }

        /* CART ITEMS */
        .cart-item {
            background: #1A3050; border-radius: 10px;
            padding: 20px 24px; margin-bottom: 16px;
            display: flex; align-items: center;
            gap: 20px; border: 1px solid #2366A0;
        }
        .item-icon { font-size: 40px; }
        .item-info { flex: 1; }
        .item-brand { color: #5BB8F5; font-size: 11px; text-transform: uppercase; font-weight: bold; }
        .item-model { font-size: 16px; font-weight: bold; margin: 4px 0; }
        .item-meta  { color: #7BAABF; font-size: 12px; }
        .item-qty   { color: #A8D4F0; font-size: 14px; text-align: center; }
        .item-price { font-size: 18px; font-weight: bold; color: #5BB8F5; min-width: 80px; text-align: right; }
        .btn-remove {
            background: #ff3b3022; color: #ff3b30;
            padding: 6px 14px; border-radius: 6px;
            border: 1px solid #ff3b30; font-size: 12px; cursor: pointer;
        }
        .btn-remove:hover { background: #ff3b30; color: #fff; }

        /* SUMMARY */
        .summary {
            background: #1A3050; border-radius: 12px;
            padding: 28px; margin-top: 24px;
            border-top: 4px solid #2366A0;
        }
        .summary-row {
            display: flex; justify-content: space-between;
            padding: 10px 0; border-bottom: 1px solid #2366A044;
            font-size: 14px; color: #A8D4F0;
        }
        .summary-total {
            display: flex; justify-content: space-between;
            padding: 16px 0 0; font-size: 20px;
            font-weight: bold; color: #5BB8F5;
        }
        .btn-checkout {
            width: 100%; padding: 14px;
            background: #2366A0; color: #fff;
            border: none; border-radius: 8px;
            font-size: 16px; cursor: pointer; margin-top: 20px;
        }
        .btn-checkout:hover { background: #5BB8F5; color: #0D1B2A; }
        .btn-clear {
            width: 100%; padding: 10px;
            background: transparent; color: #7BAABF;
            border: 1px solid #2366A0; border-radius: 8px;
            font-size: 13px; cursor: pointer; margin-top: 10px;
        }
        .btn-clear:hover { border-color: #ff3b30; color: #ff3b30; }

        .empty {
            text-align: center; padding: 80px;
            color: #7BAABF; font-size: 16px;
        }
        .empty a { color: #5BB8F5; text-decoration: none; }
    </style>
</head>
<body>

<%
    User user = (User) session.getAttribute("user");
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    double total = 0;
    if (cart != null) {
        for (CartItem item : cart) total += item.getSubtotal();
    }
%>

<!-- NAV -->
<nav>
    <div class="logo">👟 SneakerLab</div>
    <div class="nav-links">
        <a href="products">Browse</a>
        <a href="cart">🛒 Cart</a>
        <% if (user != null) { %>
            <a class="btn-nav" href="auth?action=logout">Logout</a>
        <% } else { %>
            <a class="btn-nav" href="login.jsp">Login</a>
        <% } %>
    </div>
</nav>

<!-- CART -->
<div class="container">
    <div class="page-title">🛒 Your Cart</div>
    <div class="page-sub">Review your items before checkout</div>

    <% if (cart == null || cart.isEmpty()) { %>
        <div class="empty">
            Your cart is empty.<br><br>
            <a href="products">← Browse Sneakers</a>
        </div>
    <% } else { %>

        <!-- ITEMS -->
        <% for (CartItem item : cart) { %>
        <div class="cart-item">
            <div class="item-icon">👟</div>
            <div class="item-info">
                <div class="item-brand"><%= item.sneaker.getBrand() %></div>
                <div class="item-model"><%= item.sneaker.getModel() %></div>
                <div class="item-meta">
                    Size: <%= item.sneaker.getSize() %> &nbsp;|&nbsp;
                    Color: <%= item.sneaker.getColor() %>
                </div>
            </div>
            <div class="item-qty">Qty: <%= item.quantity %></div>
            <div class="item-price">$<%= String.format("%.2f", item.getSubtotal()) %></div>
            <form action="cart" method="post">
                <input type="hidden" name="action"    value="remove">
                <input type="hidden" name="sneakerId" value="<%= item.sneaker.getId() %>">
                <button type="submit" class="btn-remove">Remove</button>
            </form>
        </div>
        <% } %>

        <!-- SUMMARY -->
        <div class="summary">
            <div class="summary-row">
                <span>Items (<%= cart.size() %>)</span>
                <span>$<%= String.format("%.2f", total) %></span>
            </div>
            <div class="summary-row">
                <span>Shipping</span>
                <span>Free</span>
            </div>
            <div class="summary-total">
                <span>Total</span>
                <span>$<%= String.format("%.2f", total) %></span>
            </div>

            <% if (user != null) { %>
                <form action="checkout" method="get">
                    <button type="submit" class="btn-checkout">✅ Checkout</button>
                </form>
            <% } else { %>
                <a href="login.jsp">
                    <button class="btn-checkout">Login to Checkout</button>
                </a>
            <% } %>

            <form action="cart" method="post">
                <input type="hidden" name="action" value="clear">
                <button type="submit" class="btn-clear">🗑️ Clear Cart</button>
            </form>
        </div>

    <% } %>
</div>

</body>
</html>