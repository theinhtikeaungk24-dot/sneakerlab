package com.sneaker.dao;

import com.sneaker.model.Sneaker;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SneakerDAO {

    // Always get a fresh connection — never cache at construction time
    private Connection getConn() {
        return DBConnection.getInstance().getConnection();
    }

    // Helper: ResultSet → Sneaker
    private Sneaker map(ResultSet rs) throws SQLException {
        return new Sneaker(
            rs.getInt("id"),
            rs.getString("brand"),
            rs.getString("model"),
            rs.getDouble("size"),
            rs.getString("color"),
            rs.getDouble("price"),
            rs.getInt("stock"),
            rs.getString("image_url"),
            rs.getString("category")
        );
    }

    // ── READ ALL ──────────────────────────────────────────
    public List<Sneaker> getAllSneakers() {
        List<Sneaker> list = new ArrayList<>();
        String sql = "SELECT * FROM sneakers ORDER BY id DESC";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── READ BY CATEGORY ──────────────────────────────────
    public List<Sneaker> getByCategory(String category) {
        List<Sneaker> list = new ArrayList<>();
        String sql = "SELECT * FROM sneakers WHERE category = ? ORDER BY id DESC";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setString(1, category);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── READ BY BRAND ─────────────────────────────────────
    public List<Sneaker> getByBrand(String brand) {
        List<Sneaker> list = new ArrayList<>();
        String sql = "SELECT * FROM sneakers WHERE LOWER(brand) = LOWER(?) ORDER BY id DESC";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setString(1, brand);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── SEARCH ────────────────────────────────────────────
    public List<Sneaker> search(String keyword) {
        List<Sneaker> list = new ArrayList<>();
        String sql = "SELECT * FROM sneakers WHERE " +
                     "LOWER(brand) LIKE ? OR LOWER(model) LIKE ? OR LOWER(color) LIKE ?";
        try {
            String k = "%" + keyword.toLowerCase() + "%";
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setString(1, k); ps.setString(2, k); ps.setString(3, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── READ ONE ──────────────────────────────────────────
    public Sneaker getSneakerById(int id) {
        String sql = "SELECT * FROM sneakers WHERE id = ?";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ── CREATE ────────────────────────────────────────────
    public boolean addSneaker(Sneaker s) {
        String sql = "INSERT INTO sneakers (brand, model, size, color, price, stock, image_url, category) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setString(1, s.getBrand());
            ps.setString(2, s.getModel());
            ps.setDouble(3, s.getSize());
            ps.setString(4, s.getColor());
            ps.setDouble(5, s.getPrice());
            ps.setInt(6, s.getStock());
            ps.setString(7, s.getImageUrl());
            ps.setString(8, s.getCategory() != null ? s.getCategory() : "unisex");
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ── UPDATE ────────────────────────────────────────────
    public boolean updateSneaker(Sneaker s) {
        String sql = "UPDATE sneakers SET brand=?, model=?, size=?, color=?, " +
                     "price=?, stock=?, image_url=?, category=? WHERE id=?";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setString(1, s.getBrand());
            ps.setString(2, s.getModel());
            ps.setDouble(3, s.getSize());
            ps.setString(4, s.getColor());
            ps.setDouble(5, s.getPrice());
            ps.setInt(6, s.getStock());
            ps.setString(7, s.getImageUrl());
            ps.setString(8, s.getCategory() != null ? s.getCategory() : "unisex");
            ps.setInt(9, s.getId());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ── DELETE ────────────────────────────────────────────
    public boolean deleteSneaker(int id) {
        String sql = "DELETE FROM sneakers WHERE id = ?";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ── STOCK UPDATE ──────────────────────────────────────
    public boolean updateStock(int id, int quantity) {
        String sql = "UPDATE sneakers SET stock = stock - ? WHERE id = ?";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, id);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
