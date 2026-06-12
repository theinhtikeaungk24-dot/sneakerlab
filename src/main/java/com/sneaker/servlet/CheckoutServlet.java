package com.sneaker.servlet;

import com.sneaker.dao.OrderDAO;
import com.sneaker.model.User;
import com.sneaker.servlet.CartServlet.CartItem;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    // ── GET: Show checkout confirmation ───────────────────
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    // ── POST: Process checkout ────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        boolean allSuccess = true;
        for (CartItem item : cart) {
            double itemTotal = item.getSubtotal();
            boolean ok = orderDAO.placeOrder(
                user.getId(),
                item.sneaker.getId(),
                item.quantity,
                itemTotal
            );
            if (!ok) {
                allSuccess = false;
                request.setAttribute("errorItem", item.sneaker.getModel());
                break;
            }
        }

        if (allSuccess) {
            session.removeAttribute("cart");
            response.sendRedirect("checkout?success=1");
        } else {
            request.setAttribute("error", "Insufficient stock for: " + request.getAttribute("errorItem"));
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}
