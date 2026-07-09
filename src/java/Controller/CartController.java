package Controller;

import Model.Account;
import Model.CartLineView;
import Model.Service.CartService;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet(name = "CartController", urlPatterns = {"/CartController"})
public class CartController extends HttpServlet {

    private void refreshCartCount(HttpSession session, CartService cartService, String account) {
        session.setAttribute("cartCount", cartService.getCartCount(account));
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account login = (Account) session.getAttribute("login");

        if (login == null) {
            request.setAttribute("msg", "Please log in to view your cart.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        CartService cartService = new CartService();
        try {
            List<CartLineView> lines = cartService.getCartLines(login.getAccount());
            request.setAttribute("cartLines", lines);
            refreshCartCount(session, cartService, login.getAccount());
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        } finally {
            cartService.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account login = (Account) session.getAttribute("login");

        if (login == null) {
            request.setAttribute("msg", "Please log in to manage your cart.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        String productId = request.getParameter("productId");

        CartService cartService = new CartService();
        try {
            switch (action) {
                case "addToCart": {
                    int qty = parseQuantity(request.getParameter("quantity"), 1);
                    if (productId != null && !productId.isEmpty() && qty > 0) {
                        cartService.addToCart(login.getAccount(), productId, qty);
                    }
                    break;
                }
                case "updateQuantity": {
                    int qty = parseQuantity(request.getParameter("quantity"), -1);
                    if (productId != null && !productId.isEmpty()) {
                        cartService.updateQuantity(login.getAccount(), productId, qty);
                    }
                    break;
                }
                case "removeItem":
                    if (productId != null && !productId.isEmpty()) {
                        cartService.removeItem(login.getAccount(), productId);
                    }
                    break;
                case "clearCart":
                    cartService.clearCart(login.getAccount());
                    break;
                case "checkout":
                    // Workshop scope: no order/payment record is created - "checking out"
                    // simply empties the cart, simulating a placed order. If a real order
                    // history is ever needed, this is the place to persist an Order entity
                    // from the current cart lines before clearing them.
                    cartService.clearCart(login.getAccount());
                    refreshCartCount(session, cartService, login.getAccount());
                    response.sendRedirect("CartController?checkout=success");
                    return;
                default:
                    break;
            }
            refreshCartCount(session, cartService, login.getAccount());
        } finally {
            cartService.close();
        }

        response.sendRedirect("CartController");
    }

    private int parseQuantity(String raw, int fallback) {
        if (raw == null || raw.isEmpty()) {
            return fallback;
        }
        try {
            return Integer.parseInt(raw);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    @Override
    public String getServletInfo() {
        return "Cart Controller - DB-backed, account-scoped shopping cart";
    }
}
