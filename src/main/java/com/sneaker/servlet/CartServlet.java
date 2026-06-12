package com.sneaker.servlet;

import com.sneaker.dao.SneakerDAO;
import com.sneaker.model.Sneaker;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private SneakerDAO sneakerDAO = new SneakerDAO();

    // Cart item inner class
    public static class CartItem {
        public Sneaker sneaker;
        public int quantity;

        public CartItem(Sneaker sneaker, int quantity) {
            this.sneaker  = sneaker;
            this.quantity = quantity;
        }

        public double getSubtotal() {
            return sneaker.getPrice() * quantity;
        }
    }

    // ── GET: Show cart ────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("cart.jsp")
               .forward(request, response);
    }

    // ── POST: Add / Remove / Clear ────────────────────────
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // Get or create cart
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        if ("add".equals(action)) {
            int sneakerId = Integer.parseInt(request.getParameter("sneakerId"));
            int quantity  = Integer.parseInt(request.getParameter("quantity"));

            Sneaker sneaker = sneakerDAO.getSneakerById(sneakerId);

            // Check if already in cart
            boolean found = false;
            for (CartItem item : cart) {
                if (item.sneaker.getId() == sneakerId) {
                    item.quantity += quantity;
                    found = true;
                    break;
                }
            }
            if (!found) {
                cart.add(new CartItem(sneaker, quantity));
            }

            session.setAttribute("cart", cart);
            response.sendRedirect("cart");

        } else if ("remove".equals(action)) {
            int sneakerId = Integer.parseInt(request.getParameter("sneakerId"));
            cart.removeIf(item -> item.sneaker.getId() == sneakerId);
            session.setAttribute("cart", cart);
            response.sendRedirect("cart");

        } else if ("clear".equals(action)) {
            session.removeAttribute("cart");
            response.sendRedirect("cart");
        }
    }
}