<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.sneaker.model.User, com.sneaker.model.Order, com.sneaker.dao.OrderDAO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect("../login.jsp"); return;
    }
    OrderDAO orderDAO = new OrderDAO();

    String updateId     = request.getParameter("updateId");
    String updateStatus = request.getParameter("updateStatus");
    if (updateId != null && updateStatus != null) {
        orderDAO.updateStatus(Integer.parseInt(updateId), updateStatus);
        response.sendRedirect("order.jsp"); return;
    }

    List<Order> orders = orderDAO.getAllOrders();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Orders — SneakerLab Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;900&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f8f8f6; color: #111; display: flex; min-height: 100vh; }

        .sidebar { width: 240px; background: #111; min-height: 100vh; display: flex; flex-direction: column; flex-shrink: 0; }
        .sidebar-logo { padding: 28px 28px 24px; border-bottom: 1px solid #222; font-size: 18px; font-weight: 900; letter-spacing: 3px; color: #fff; }
        .sidebar-logo span { color: #FF6B2B; }
        .sidebar-badge { display: inline-block; margin-top: 6px; background: #FF6B2B; color: #fff; font-size: 9px; font-weight: 700; letter-spacing: 1.5px; padding: 3px 8px; text-transform: uppercase; }
        .sidebar-menu { flex: 1; padding: 16px 0; }
        .sidebar-menu a { display: flex; align-items: center; gap: 12px; padding: 14px 28px; color: #666; text-decoration: none; font-size: 13px; font-weight: 500; transition: all 0.2s; border-left: 3px solid transparent; }
        .sidebar-menu a:hover { color: #fff; background: #1a1a1a; }
        .sidebar-menu a.active { color: #fff; background: #1a1a1a; border-left-color: #FF6B2B; }
        .sidebar-footer { padding: 20px 28px; border-top: 1px solid #222; }
        .sidebar-user { font-size: 12px; color: #555; margin-bottom: 10px; }
        .sidebar-user strong { color: #fff; display: block; font-size: 13px; }
        .btn-logout { display: block; width: 100%; padding: 10px; background: transparent; border: 1px solid #333; color: #666; font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; text-decoration: none; text-align: center; transition: all 0.2s; }
        .btn-logout:hover { border-color: #FF6B2B; color: #FF6B2B; }

        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { background: #fff; padding: 20px 40px; border-bottom: 1px solid #f0f0f0; display: flex; justify-content: space-between; align-items: center; }
        .topbar-title { font-size: 22px; font-weight: 800; color: #111; }
        .topbar-sub { font-size: 13px; color: #aaa; margin-top: 2px; }
        .content { padding: 32px 40px; overflow-y: auto; }

        .table-wrap { background: #fff; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { border-bottom: 2px solid #f0f0f0; }
        th { padding: 14px 18px; text-align: left; font-size: 10px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; color: #aaa; }
        tbody tr { border-bottom: 1px solid #f8f8f8; transition: background 0.15s; }
        tbody tr:hover { background: #fafafa; }
        td { padding: 16px 18px; font-size: 13px; color: #333; }

        .badge { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 10px; font-weight: 700; letter-spacing: 0.5px; text-transform: uppercase; }
        .pending   { background: #fff7ed; color: #FF6B2B; border: 1px solid #FF6B2B; }
        .shipped   { background: #eff6ff; color: #3b82f6; border: 1px solid #3b82f6; }
        .delivered { background: #f0fdf4; color: #22c55e; border: 1px solid #22c55e; }
        .cancelled { background: #fef2f2; color: #ef4444; border: 1px solid #ef4444; }

        .status-form { display: inline-flex; align-items: center; gap: 8px; }
        select { padding: 6px 10px; border: 1.5px solid #e8e8e8; border-radius: 2px; font-size: 12px; font-family: 'Inter', sans-serif; color: #111; background: #fff; cursor: pointer; transition: border-color 0.2s; }
        select:focus { outline: none; border-color: #111; }
        .btn-update { padding: 6px 14px; background: #111; color: #fff; border: none; border-radius: 2px; font-size: 11px; font-weight: 700; letter-spacing: 0.5px; cursor: pointer; transition: background 0.2s; }
        .btn-update:hover { background: #FF6B2B; }

        .empty { text-align: center; padding: 80px; color: #ccc; font-size: 15px; }
        .empty-icon { font-size: 48px; margin-bottom: 16px; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-logo">Sneaker<span>Lab</span><div class="sidebar-badge">Admin Panel</div></div>
    <div class="sidebar-menu">
        <a href="dashboard.jsp">📊 &nbsp;Dashboard</a>
        <a href="inventory.jsp">📦 &nbsp;Inventory</a>
        <a href="order.jsp" class="active">📋 &nbsp;Orders</a>
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
            <div class="topbar-title">Orders</div>
            <div class="topbar-sub"><%= orders.size() %> total orders</div>
        </div>
    </div>

    <div class="content">
        <% if (orders.isEmpty()) { %>
            <div class="table-wrap">
                <div class="empty">
                    <div class="empty-icon">📋</div>
                    No orders yet. Orders will appear here once customers checkout.
                </div>
            </div>
        <% } else { %>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>#</th><th>Customer</th><th>Sneaker</th>
                        <th>Qty</th><th>Total</th><th>Date</th>
                        <th>Status</th><th>Update</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Order o : orders) { %>
                    <tr>
                        <td style="color:#ccc">#<%= o.getId() %></td>
                        <td style="font-weight:700;color:#111"><%= o.getUsername() %></td>
                        <td><%= o.getSneakerBrand() %> <%= o.getSneakerModel() %></td>
                        <td><%= o.getQuantity() %></td>
                        <td style="font-weight:700">$<%= String.format("%.2f", o.getTotal()) %></td>
                        <td style="color:#aaa;font-size:12px"><%= o.getOrderDate() %></td>
                        <td><span class="badge <%= o.getStatus() %>"><%= o.getStatus().toUpperCase() %></span></td>
                        <td>
                            <form action="order.jsp" method="get" class="status-form">
                                <input type="hidden" name="updateId" value="<%= o.getId() %>">
                                <select name="updateStatus">
                                    <option value="pending"   <%= "pending".equals(o.getStatus())   ? "selected" : "" %>>Pending</option>
                                    <option value="shipped"   <%= "shipped".equals(o.getStatus())   ? "selected" : "" %>>Shipped</option>
                                    <option value="delivered" <%= "delivered".equals(o.getStatus()) ? "selected" : "" %>>Delivered</option>
                                    <option value="cancelled" <%= "cancelled".equals(o.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                </select>
                                <button type="submit" class="btn-update">Save</button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

</body>
</html>
