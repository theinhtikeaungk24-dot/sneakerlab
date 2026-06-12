package com.sneaker.dao;

import com.sneaker.model.SneakerVariant;
import java.sql.*;
import java.util.*;

public class SneakerVariantDAO {

    // ── Add a new colour variant ─────────────────────────
    public void addVariant(SneakerVariant v) {
        String sql = "INSERT INTO sneaker_variants (sneaker_id, color, image_url) VALUES (?, ?, ?)";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, v.getSneakerId());
            ps.setString(2, v.getColor());
            ps.setString(3, v.getImageUrl());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // ── Get all variants for a sneaker ───────────────────
    public List<SneakerVariant> getVariantsBySneakerId(int sneakerId) {
        List<SneakerVariant> list = new ArrayList<>();
        String sql = "SELECT * FROM sneaker_variants WHERE sneaker_id = ? ORDER BY id";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, sneakerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SneakerVariant v = new SneakerVariant();
                v.setId(rs.getInt("id"));
                v.setSneakerId(rs.getInt("sneaker_id"));
                v.setColor(rs.getString("color"));
                v.setImageUrl(rs.getString("image_url"));
                list.add(v);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ── Delete a single variant ──────────────────────────
    public SneakerVariant getVariantById(int id) {
        String sql = "SELECT * FROM sneaker_variants WHERE id = ?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                SneakerVariant v = new SneakerVariant();
                v.setId(rs.getInt("id"));
                v.setSneakerId(rs.getInt("sneaker_id"));
                v.setColor(rs.getString("color"));
                v.setImageUrl(rs.getString("image_url"));
                return v;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public void deleteVariant(int id) {
        String sql = "DELETE FROM sneaker_variants WHERE id = ?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // ── Delete ALL variants for a sneaker (used on sneaker delete) ──
    public void deleteVariantsBySneakerId(int sneakerId) {
        String sql = "DELETE FROM sneaker_variants WHERE sneaker_id = ?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, sneakerId);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}
