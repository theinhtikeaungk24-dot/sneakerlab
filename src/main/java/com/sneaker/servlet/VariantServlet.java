package com.sneaker.servlet;

import com.sneaker.dao.SneakerVariantDAO;
import com.sneaker.model.SneakerVariant;
import com.sneaker.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.List;
import java.util.UUID;

@WebServlet("/variants")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 5  * 1024 * 1024,
    maxRequestSize    = 10 * 1024 * 1024
)
public class VariantServlet extends HttpServlet {

    private final SneakerVariantDAO dao = new SneakerVariantDAO();

    // ── GET /variants?sneakerId=X  →  JSON array ─────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("sneakerId");
        if (idStr == null) { resp.sendError(400, "sneakerId required"); return; }

        List<SneakerVariant> variants = dao.getVariantsBySneakerId(Integer.parseInt(idStr));

        resp.setContentType("application/json; charset=UTF-8");
        PrintWriter out = resp.getWriter();
        out.print("[");
        for (int i = 0; i < variants.size(); i++) {
            SneakerVariant v = variants.get(i);
            if (i > 0) out.print(",");
            out.printf("{\"id\":%d,\"sneakerId\":%d,\"color\":\"%s\",\"imageUrl\":\"%s\"}",
                v.getId(), v.getSneakerId(),
                esc(v.getColor()),
                v.getImageUrl() != null ? esc(v.getImageUrl()) : "");
        }
        out.print("]");
    }

    // ── POST /variants  action=add | delete ──────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Admin guard
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("{\"error\":\"forbidden\"}");
            return;
        }

        resp.setContentType("application/json; charset=UTF-8");
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            int    sneakerId = Integer.parseInt(req.getParameter("sneakerId"));
            String color     = req.getParameter("color");
            String imageFile = saveUploadedImage(req);

            if (imageFile == null) {
                resp.getWriter().write("{\"error\":\"No image uploaded or unsupported format\"}");
                return;
            }

            SneakerVariant v = new SneakerVariant(sneakerId, color, imageFile);
            dao.addVariant(v);

            resp.getWriter().printf("{\"success\":true,\"color\":\"%s\",\"imageUrl\":\"%s\"}",
                esc(color), esc(imageFile));

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            // optionally delete the physical file
            SneakerVariant v = dao.getVariantById(id);
            if (v != null && v.getImageUrl() != null && !v.getImageUrl().isEmpty()) {
                String dir = getServletContext().getRealPath("/images/sneakers/");
                File f = new File(dir, v.getImageUrl());
                if (f.exists()) f.delete();
            }
            dao.deleteVariant(id);
            resp.getWriter().write("{\"success\":true}");

        } else {
            resp.setStatus(400);
            resp.getWriter().write("{\"error\":\"unknown action\"}");
        }
    }

    // ── Save uploaded image ──────────────────────────────
    private String saveUploadedImage(HttpServletRequest req)
            throws IOException, ServletException {
        Part part = req.getPart("imageFile");
        if (part == null || part.getSize() == 0) return null;

        String name = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        if (name == null || name.isEmpty()) return null;

        String ext = "";
        int dot = name.lastIndexOf('.');
        if (dot >= 0) ext = name.substring(dot).toLowerCase();

        if (!ext.equals(".jpg") && !ext.equals(".jpeg")
                && !ext.equals(".png") && !ext.equals(".webp")) return null;

        String unique    = UUID.randomUUID() + ext;
        String uploadDir = getServletContext().getRealPath("/images/sneakers/");
        Files.createDirectories(Paths.get(uploadDir));
        part.write(uploadDir + File.separator + unique);
        return unique;
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
