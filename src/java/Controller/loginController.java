package Controller;

import Model.Account;
import Model.Service.AccountService;
import Model.Service.CartService;
import Utilities.PasswordUtils;
import Utilities.SessionManager;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author PC
 */
@WebServlet(name = "loginController", urlPatterns = {"/loginController"})
public class loginController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet loginController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet loginController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String action = request.getParameter("action");
        if ("logout".equalsIgnoreCase(action)) {
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(true);
        String account = request.getParameter("username");
        String pass = request.getParameter("password");
        String msg = "";
        AccountService accountService = new AccountService();
        try {
            Account a = accountService.getObjectById(account);
            if (session.getAttribute("LOCKOUT_TIME") != null) {
                long lockoutTime = (long) session.getAttribute("LOCKOUT_TIME");
                long currentTime = System.currentTimeMillis();

                if (currentTime < lockoutTime) {
                    long remainingMillis = lockoutTime - currentTime;
                    long remainingMinutes = (remainingMillis / 1000) / 60;

                    msg = "Your account is locked. Please wait " + remainingMinutes + " minutes.";
                    request.setAttribute("msg", msg);
                    request.getRequestDispatcher("AccessDenied.jsp").forward(request, response);
                    return;
                } else {
                    session.removeAttribute("LOCKOUT_TIME");
                    session.removeAttribute("NUMBER_WRONG_PASS");
                }
            }

            int NUMBER_WRONG_PASS = 3;

            if (a == null) {
                msg = "Can't find user's name! Please re-enter!";
                request.setAttribute("msg", msg);
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            if (!a.isUse()) {
                msg = "Your account has been deactived! Please contact us if you believe this is a mistake.";
                request.setAttribute("msg", msg);
                request.getRequestDispatcher("AccessDenied.jsp").forward(request, response);
                return;
            }

            if (!PasswordUtils.verify(pass, a.getPass())) {
                if (session.getAttribute("NUMBER_WRONG_PASS") != null) {
                    NUMBER_WRONG_PASS = (int) session.getAttribute("NUMBER_WRONG_PASS");
                }
                NUMBER_WRONG_PASS--;
                session.setAttribute("NUMBER_WRONG_PASS", NUMBER_WRONG_PASS);

                if (NUMBER_WRONG_PASS <= 0) {
                    int lockoutCount = 0;
                    if (session.getAttribute("LOCKOUT_COUNT") != null) {
                        lockoutCount = (int) session.getAttribute("LOCKOUT_COUNT");
                    }
                    lockoutCount++;
                    session.setAttribute("LOCKOUT_COUNT", lockoutCount);

                    long penaltyMinutes = (lockoutCount >= 2) ? 30 * lockoutCount : 30;

                    long futureLockoutTime = System.currentTimeMillis() + (penaltyMinutes * 60 * 1000);
                    session.setAttribute("LOCKOUT_TIME", futureLockoutTime);

                    session.setMaxInactiveInterval((int) (penaltyMinutes + 10) * 60);
                    msg = "Too many failed attempts. Locked for " + penaltyMinutes + " minutes.";
                    request.setAttribute("msg", msg);
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }

                msg = "Incorrect password! Please try again. You have " + NUMBER_WRONG_PASS + " attempts left.";
                request.setAttribute("msg", msg);
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            if (session != null) {
                session.removeAttribute("NUMBER_WRONG_PASS");
                session.removeAttribute("LOCKOUT_TIME");
            }

            if (PasswordUtils.needsRehash(a.getPass())) {
                String newHash = PasswordUtils.hash(pass);
                a.setPass(newHash);
                accountService.updateRec(a);
            }

            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("login", a);

            SessionManager.getInstance().registerLogin(a.getAccount(), newSession);
            CartService cartService = new CartService();
            try {
                newSession.setAttribute("cartCount", cartService.getCartCount(a.getAccount()));
            } finally {
                cartService.close();
            }

            response.sendRedirect("index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred during login.");
        } finally {
            accountService.close();
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
