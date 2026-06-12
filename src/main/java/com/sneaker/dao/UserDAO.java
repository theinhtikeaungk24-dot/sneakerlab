package com.sneaker.dao;

import com.sneaker.model.User;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

public class UserDAO {

    // Always get a fresh connection — never cache it at constructor time
    private Connection getConn() {
        return DBConnection.getInstance().getConnection();
    }

    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

    // ── LOGIN CHECK ───────────────────────────────────────
    public User login(String username, String password) {
        User user = null;
        String hashed = hashPassword(password);
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, hashed);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("email"),
                    rs.getString("role")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    // ── REGISTER ──────────────────────────────────────────
    public boolean register(User u) {
        String sql = "INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, 'customer')";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setString(1, u.getUsername());
            ps.setString(2, hashPassword(u.getPassword()));
            ps.setString(3, u.getEmail());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── CHECK USERNAME EXISTS ─────────────────────────────
    public boolean usernameExists(String username) {
        String sql = "SELECT id FROM users WHERE username = ?";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── COUNT USERS ───────────────────────────────────────
    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try {
            PreparedStatement ps = getConn().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
