package com.sneaker.servlet;

import com.sneaker.dao.SneakerDAO;
import com.sneaker.model.Sneaker;
import com.sneaker.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.List;
import java.util.UUID;

@WebServlet("/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1 MB — buffer to disk after this
    maxFileSize       = 5 * 1024 * 1024,   // 5 MB max per file
    maxRequestSize    = 10 * 1024 * 1024   // 10 MB max total
)
public class ProductServlet extends HttpServlet {

    private SneakerDAO sneakerDAO = new SneakerDAO();

    // ── GET: List / Filter / Search / Detail ─────────────
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action   = request.getParameter("action");
        String category = request.getParameter("category");
        String brand    = request.getParameter("brand");
        String search   = request.getParameter("search");

        if ("detail".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Sneaker sneaker = sneakerDAO.getSneakerById(id);
            request.setAttribute("sneaker", sneaker);
            request.getRequestDispatcher("product-detail.jsp").forward(request, response);

        } else {
            List<Sneaker> list;

            if (search != null && !search.trim().isEmpty()) {
                list = sneakerDAO.search(search.trim());
                request.setAttribute("activeFilter", "Search: " + search);
                request.setAttribute("searchQuery", search.trim());

            } else if (category != null && !category.isEmpty()) {
                list = sneakerDAO.getByCategory(category);
                request.setAttribute("activeFilter", category);
                request.setAttribute("activeCategory", category);

            } else if (brand != null && !brand.isEmpty()) {
                list = sneakerDAO.getByBrand(brand);
                request.setAttribute("activeFilter", brand);
                request.setAttribute("activeBrand", brand);

            } else {
                list = sneakerDAO.getAllSneakers();
                request.setAttribute("activeFilter", "all");
            }

            request.setAttribute("sneakerList", list);
            request.getRequestDispatcher("product-list.jsp").forward(request, response);
        }
    }

    // ── POST: Admin add / edit / delete ──────────────────
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            Sneaker s = extractSneaker(request);
            String imageFile = saveUploadedImage(request, null);
            if (imageFile != null) s.setImageUrl(imageFile);
            sneakerDAO.addSneaker(s);
            response.sendRedirect("admin/inventory.jsp");

        } else if ("edit".equals(action)) {
            Sneaker s = extractSneaker(request);
            s.setId(Integer.parseInt(request.getParameter("id")));
            // Keep old image if no new one uploaded
            String existingImage = request.getParameter("existingImage");
            String imageFile = saveUploadedImage(request, existingImage);
            s.setImageUrl(imageFile != null ? imageFile : existingImage);
            sneakerDAO.updateSneaker(s);
            response.sendRedirect("admin/inventory.jsp");

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            // Delete image file if exists
            Sneaker old = sneakerDAO.getSneakerById(id);
            if (old != null && old.getImageUrl() != null && !old.getImageUrl().isEmpty()) {
                String uploadDir = getServletContext().getRealPath("/images/sneakers/");
                File f = new File(uploadDir, old.getImageUrl());
                if (f.exists()) f.delete();
            }
            sneakerDAO.deleteSneaker(id);
            response.sendRedirect("admin/inventory.jsp");
        }
    }

    // ── Save uploaded image, return filename ─────────────
    private String saveUploadedImage(HttpServletRequest request, String existing) throws IOException, ServletException {
        Part filePart = request.getPart("imageFile");
        if (filePart == null || filePart.getSize() == 0) return null;

        String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        if (originalName == null || originalName.isEmpty()) return null;

        String ext = "";
        int dot = originalName.lastIndexOf('.');
        if (dot >= 0) ext = originalName.substring(dot).toLowerCase();

        // Only allow image types
        if (!ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".png") && !ext.equals(".webp")) {
            return null;
        }

        String uniqueName = UUID.randomUUID().toString() + ext;
        String uploadDir  = getServletContext().getRealPath("/images/sneakers/");
        Files.createDirectories(Paths.get(uploadDir));
        filePart.write(uploadDir + File.separator + uniqueName);
        return uniqueName;
    }

    // ── Helper: Form data → Sneaker ──────────────────────
    private Sneaker extractSneaker(HttpServletRequest request) {
        Sneaker s = new Sneaker();
        s.setBrand(request.getParameter("brand"));
        s.setModel(request.getParameter("model"));
        String sizeStr = request.getParameter("size");
        s.setSize(sizeStr != null && !sizeStr.isEmpty() ? Double.parseDouble(sizeStr) : 0);
        s.setColor(request.getParameter("color"));
        String priceStr = request.getParameter("price");
        s.setPrice(priceStr != null && !priceStr.isEmpty() ? Double.parseDouble(priceStr) : 0);
        String stockStr = request.getParameter("stock");
        s.setStock(stockStr != null && !stockStr.isEmpty() ? Integer.parseInt(stockStr) : 0);
        s.setCategory(request.getParameter("category"));
        return s;
    }
}
