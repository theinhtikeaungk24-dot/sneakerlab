package com.sneaker.dao;

import com.sneaker.model.Order;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // Always get a fresh connection — never cache at construction time
    private Connection getConn() {
        return DBConnection.getInstance().getConnection();
    }

    // ── PLACE ORDER (with stock decrement in one transaction) ──
    public boolean placeOrder(int userId, int sneakerId, int quantity, double total) {
        Connection conn = getConn();
        try {
            conn.setAutoCommit(false);

            String insertSql = "INSERT INTO orders (user_id, sneaker_id, quantity, total, status) " +
                               "VALUES (?, ?, ?, ?, 'pending')";
            PreparedStatement ins = conn.prepareStatement(insertSql);
            ins.setInt(1, userId);
            ins.setInt(2, sneakerId);
            ins.setInt(3, quantity);
            ins.setDouble(4, total);
            ins.executeUpdate();

            String updateSql = "UPDATE sneakers SET stock = stock - ? WHERE id = ? AND stock >= ?";
            PreparedStatement upd = conn.prepareStatement(updateSql);
            upd.setInt(1, quantity);
            upd.setInt(2, sneakerId);
            upd.setInt(3, quantity);
            int rows = upd.executeUpdate();

            if (rows == 0) {
                conn.rollback();
                conn.setAutoCommit(true);
                return false;
            }

            conn.commit();
            conn.setAutoCommit(true);
            return true;
        } catch (SQLException e) {
            try { conn.rollback(); conn.setAutoCommit(true); } catch (SQLException ignored) {}
            e.printStackTrace();
            return false;
        }
    }

    // ── GET ALL ORDERS (with user + sneaker info) ─────────────
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.username, s.brand, s.model " +
                     "FROM orders o " +
                     "JOIN users u    ON o.user_id    = u.id " +
                     "JOIN sneakers s ON o.sneaker_id = s.id " +
                     "ORDER BY o.order_date DESC";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getInt("sneaker_id"),
                    rs.getInt("quantity"),
                    rs.getDouble("total"),
                    rs.getString("status"),
                    rs.getTimestamp("order_date")
                );
                o.setUsername(rs.getString("username"));
                o.setSneakerBrand(rs.getString("brand"));
                o.setSneakerModel(rs.getString("model"));
                list.add(o);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── GET ORDERS BY USER ────────────────────────────────────
    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, s.brand, s.model " +
                     "FROM orders o " +
                     "JOIN sneakers s ON o.sneaker_id = s.id " +
                     "WHERE o.user_id = ? ORDER BY o.order_date DESC";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order o = new Order(
                    rs.getInt("id"),
                    rs.getInt("user_id"),
                    rs.getInt("sneaker_id"),
                    rs.getInt("quantity"),
                    rs.getDouble("total"),
                    rs.getString("status"),
                    rs.getTimestamp("order_date")
                );
                o.setSneakerBrand(rs.getString("brand"));
                o.setSneakerModel(rs.getString("model"));
                list.add(o);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── UPDATE STATUS ─────────────────────────────────────────
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ── COUNT ALL ORDERS ──────────────────────────────────────
    public int countOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // ── TOTAL REVENUE ─────────────────────────────────────────
    public double totalRevenue() {
        String sql = "SELECT COALESCE(SUM(total), 0) FROM orders WHERE status != 'cancelled'";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
