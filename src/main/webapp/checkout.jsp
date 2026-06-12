<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.sneaker.model.User, com.sneaker.servlet.CartServlet.CartItem, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout — SneakerLab</title>
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
        .btn-nav {
            background: #2366A0; color: #fff; padding: 8px 18px;
            border-radius: 6px; text-decoration: none; font-size: 13px; margin-left: 12px;
        }

        .container { max-width: 640px; margin: 60px auto; padding: 0 24px; }

        /* SUCCESS */
        .success-box {
            background: #1A3050; border-radius: 16px;
            padding: 48px; text-align: center;
            border-top: 4px solid #30d158;
        }
        .success-icon { font-size: 64px; margin-bottom: 20px; }
        .success-box h2 { font-size: 28px; color: #30d158; margin-bottom: 12px; }
        .success-box p { color: #7BAABF; margin-bottom: 28px; line-height: 1.6; }
        .btn-home {
            background: #2366A0; color: #fff;
            padding: 12px 32px; border-radius: 8px;
            text-decoration: none; font-size: 15px; display: inline-block; margin: 6px;
        }
        .btn-home:hover { background: #5BB8F5; color: #0D1B2A; }

        /* ORDER REVIEW */
        .order-card {
            background: #1A3050; border-radius: 12px;
            padding: 28px; margin-bottom: 20px;
            border-top: 4px solid #2366A0;
        }
        .order-card h3 { color: #5BB8F5; margin-bottom: 20px; font-size: 18px; }
        .item-row {
            display: flex; justify-content: space-between;
            padding: 10px 0; border-bottom: 1px solid #2366A044;
            font-size: 14px;
        }
        .item-row:last-child { border-bottom: none; }
        .item-name { color: #A8D4F0; }
        .item-price { color: #5BB8F5; font-weight: bold; }
        .total-row {
            display: flex; justify-content: space-between;
            padding: 16px 0 0; font-size: 20px;
            font-weight: bold; color: #5BB8F5;
        }
        .btn-confirm {
            width: 100%; padding: 14px;
            background: #30d158; color: #fff;
            border: none; border-radius: 8px;
            font-size: 16px; cursor: pointer; margin-top: 20px;
            font-weight: bold;
        }
        .btn-confirm:hover { background: #28a745; }
        .error {
            background: #ff3b3022; border: 1px solid #ff3b30;
            color: #ff3b30; padding: 12px; border-radius: 8px; margin-bottom: 16px;
        }
    </style>
</head>
<body>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    String success = request.getParameter("success");
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    double total = 0;
    if (cart != null) for (CartItem item : cart) total += item.getSubtotal();
%>

<nav>
    <div class="logo">👟 SneakerLab</div>
    <div class="nav-links">
        <a href="products">Browse</a>
        <a href="cart">🛒 Cart</a>
        <a class="btn-nav" href="auth?action=logout">Logout</a>
    </div>
</nav>

<div class="container">

<% if ("1".equals(success)) { %>
    <!-- ORDER SUCCESS -->
    <div class="success-box">
        <div class="success-icon">✅</div>
        <h2>Order Placed!</h2>
        <p>Thank you, <%= user.getUsername() %>!<br>
           Your order has been received and is being processed.<br>
           You will receive an update once it ships.</p>
        <a href="products" class="btn-home">🛍️ Continue Shopping</a>
        <a href="orders" class="btn-home" style="background:#1A3050; border:1px solid #2366A0;">📋 My Orders</a>
    </div>

<% } else { %>
    <!-- ORDER REVIEW -->
    <% if (request.getAttribute("error") != null) { %>
        <div class="error">⚠️ <%= request.getAttribute("error") %></div>
    <% } %>

    <% if (cart == null || cart.isEmpty()) { %>
        <div style="text-align:center; padding:60px; color:#7BAABF;">
            Your cart is empty. <a href="products" style="color:#5BB8F5;">Browse sneakers</a>
        </div>
    <% } else { %>
    <div class="order-card">
        <h3>📋 Review Your Order</h3>

        <% for (CartItem item : cart) { %>
        <div class="item-row">
            <span class="item-name">
                <%= item.sneaker.getBrand() %> <%= item.sneaker.getModel() %>
                &nbsp;×&nbsp;<%= item.quantity %>
            </span>
            <span class="item-price">$<%= String.format("%.2f", item.getSubtotal()) %></span>
        </div>
        <% } %>

        <div class="total-row">
            <span>Total</span>
            <span>$<%= String.format("%.2f", total) %></span>
        </div>

        <form action="checkout" method="post">
            <button type="submit" class="btn-confirm">✅ Confirm & Place Order</button>
        </form>
    </div>
    <% } %>
<% } %>

</div>
</body>
</html>
