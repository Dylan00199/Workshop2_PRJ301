package Filter;

import Model.Account;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Protects the Admin/Private area. Any unauthenticated request is redirected
 * to login.jsp; any authenticated-but-non-admin request is redirected to
 * AccessDenied.jsp.
 */
@WebFilter(urlPatterns = {"/Admin.jsp", "/AdminController", "/AdminController/*"})
public class AdminAuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        Account login = (session != null) ? (Account) session.getAttribute("login") : null;

        if (login == null) {
            request.setAttribute("msg", "Please log in to access the admin area.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (login.getRoleInSystem() != 1) { // 1 = Administrator, per existing convention
            request.setAttribute("msg", "You do not have permission to access this area.");
            request.getRequestDispatcher("/AccessDenied.jsp").forward(request, response);
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
    }
}
