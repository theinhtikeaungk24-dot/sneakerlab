<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.sneaker.model.User, com.sneaker.dao.SneakerDAO, com.sneaker.dao.OrderDAO, com.sneaker.dao.UserDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp"); return;
    }
    SneakerDAO sneakerDAO = new SneakerDAO();
    OrderDAO   orderDAO   = new OrderDAO();
    UserDAO    userDAO    = new UserDAO();
    java.util.List<com.sneaker.model.Sneaker> allSneakers = sneakerDAO.getAllSneakers();
    int totalProducts = allSneakers.size();
    int totalOrders   = orderDAO.countOrders();
    int totalUsers    = userDAO.countUsers();
    int totalStock    = 0;
    for (com.sneaker.model.Sneaker s : allSneakers) { totalStock += s.getStock(); }
    double revenue    = orderDAO.totalRevenue();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard — SneakerLab Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f8f8f6; color: #111; display: flex; min-height: 100vh; }

        .sidebar {
            width: 240px; background: #111; min-height: 100vh;
            display: flex; flex-direction: column; flex-shrink: 0;
        }
        .sidebar-logo {
            padding: 28px 28px 24px; border-bottom: 1px solid #222;
            font-size: 18px; font-weight: 900; letter-spacing: 3px; color: #fff;
        }
        .sidebar-logo span { color: #FF6B2B; }
        .sidebar-badge {
            display: inline-block; margin-top: 6px; background: #FF6B2B;
            color: #fff; font-size: 9px; font-weight: 700;
            letter-spacing: 1.5px; padding: 3px 8px; text-transform: uppercase;
        }
        .sidebar-menu { flex: 1; padding: 16px 0; }
        .sidebar-menu a {
            display: flex; align-items: center; gap: 12px;
            padding: 14px 28px; color: #666; text-decoration: none;
            font-size: 13px; font-weight: 500; transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        .sidebar-menu a:hover { color: #fff; background: #1a1a1a; }
        .sidebar-menu a.active { color: #fff; background: #1a1a1a; border-left-color: #FF6B2B; }
        .sidebar-footer { padding: 20px 28px; border-top: 1px solid #222; }
        .sidebar-user { font-size: 12px; color: #555; margin-bottom: 10px; }
        .sidebar-user strong { color: #fff; display: block; font-size: 13px; }
        .btn-logout {
            display: block; width: 100%; padding: 10px;
            background: transparent; border: 1px solid #333; color: #666;
            font-size: 11px; font-weight: 700; letter-spacing: 1px;
            text-transform: uppercase; text-decoration: none; text-align: center;
            transition: all 0.2s;
        }
        .btn-logout:hover { border-color: #FF6B2B; color: #FF6B2B; }

        .main { flex: 1; display: flex; flex-direction: column; }
        .topbar {
            background: #fff; padding: 20px 40px;
            border-bottom: 1px solid #f0f0f0;
            display: flex; justify-content: space-between; align-items: center;
        }
        .topbar-title { font-size: 22px; font-weight: 800; color: #111; }
        .topbar-sub { font-size: 13px; color: #aaa; margin-top: 2px; }
        .btn-action {
            padding: 9px 20px; background: #111; color: #fff;
            font-size: 11px; font-weight: 700; letter-spacing: 1px;
            text-transform: uppercase; text-decoration: none; border-radius: 2px;
            transition: background 0.2s;
        }
        .btn-action:hover { background: #FF6B2B; }

        .content { padding: 36px 40px; }
        .section-title {
            font-size: 11px; font-weight: 700; letter-spacing: 2px;
            text-transform: uppercase; color: #aaa; margin-bottom: 16px;
        }

        .stats { display: grid; grid-template-columns: repeat(5, 1fr); gap: 2px; background: #f0f0f0; margin-bottom: 36px; }
        .stat-card {
            background: #fff; padding: 28px 24px;
            border-top: 3px solid transparent; transition: border-color 0.2s;
        }
        .stat-card:hover { border-top-color: #FF6B2B; }
        .stat-icon { font-size: 28px; margin-bottom: 14px; }
        .stat-num { font-size: 34px; font-weight: 900; color: #111; line-height: 1; }
        .stat-label { font-size: 11px; color: #aaa; margin-top: 6px; letter-spacing: 1px; text-transform: uppercase; font-weight: 600; }

        .quick-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 2px; background: #f0f0f0; }
        .quick-card {
            background: #fff; padding: 32px 28px; text-decoration: none;
            transition: all 0.2s; border-top: 3px solid transparent; display: block;
        }
        .quick-card:hover { border-top-color: #FF6B2B; transform: translateY(-2px); }
        .q-icon { font-size: 36px; margin-bottom: 14px; }
        .q-title { font-size: 16px; font-weight: 700; color: #111; margin-bottom: 6px; }
        .q-desc { font-size: 13px; color: #aaa; line-height: 1.5; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-logo">
        Sneaker<span>Lab</span>
        <div class="sidebar-badge">Admin Panel</div>
    </div>
    <div class="sidebar-menu">
        <a href="dashboard.jsp" class="active">📊 &nbsp;Dashboard</a>
        <a href="inventory.jsp">📦 &nbsp;Inventory</a>
        <a href="order.jsp">📋 &nbsp;Orders</a>
        <a href="../products">🛍️ &nbsp;View Store</a>
    </div>
    <div class="sidebar-footer">
        <div class="sidebar-user">Logged in as<strong><%= user.getUsername() %></strong></div>
        <a href="../auth?action=logout" class="btn-logout">Logout</a>
    </div>
</div>

<div class="main">
    <div class="topbar">
        <div>
            <div class="topbar-title">Dashboard</div>
            <div class="topbar-sub">Welcome back, <%= user.getUsername() %></div>
        </div>
        <a href="inventory.jsp" class="btn-action">+ Add Product</a>
    </div>

    <div class="content">
        <div class="section-title">Store Overview</div>
        <div class="stats">
            <div class="stat-card"><div class="stat-icon">👟</div><div class="stat-num"><%= totalProducts %></div><div class="stat-label">Products</div></div>
            <div class="stat-card"><div class="stat-icon">📋</div><div class="stat-num"><%= totalOrders %></div><div class="stat-label">Orders</div></div>
            <div class="stat-card"><div class="stat-icon">👥</div><div class="stat-num"><%= totalUsers %></div><div class="stat-label">Users</div></div>
            <div class="stat-card"><div class="stat-icon">📦</div><div class="stat-num"><%= totalStock %></div><div class="stat-label">Total Stock</div></div>
            <div class="stat-card"><div class="stat-icon">💰</div><div class="stat-num">$<%= String.format("%.0f", revenue) %></div><div class="stat-label">Revenue</div></div>
        </div>

        <div class="section-title">Quick Actions</div>
        <div class="quick-grid">
            <a href="inventory.jsp" class="quick-card"><div class="q-icon">📦</div><div class="q-title">Manage Inventory</div><div class="q-desc">Add, edit or remove sneakers from your stock</div></a>
            <a href="order.jsp"     class="quick-card"><div class="q-icon">📋</div><div class="q-title">View Orders</div><div class="q-desc">Track and update customer order status</div></a>
            <a href="../products"   class="quick-card"><div class="q-icon">🛍️</div><div class="q-title">View Store</div><div class="q-desc">See your store from the customer perspective</div></a>
        </div>
    </div>
</div>

</body>
</html>
