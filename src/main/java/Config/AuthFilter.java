package Config;

import java.io.IOException;

// --- ✅ ĐỔI TẤT CẢ JAVAX THÀNH JAKARTA ---
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.User;
import Services.UserServices;
import Utils.Utils;

@WebFilter(urlPatterns = { "/admin/*", "/editor/*" })
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String userId = Utils.getCookie(Utils.COOKIE_KEY_USER_ID, req);
        String role = Utils.getCookie(Utils.COOKIE_KEY_ROLE, req);

        if (userId == null || role == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = null;
        try {
            user = UserServices.getUserInfoById(Integer.parseInt(userId));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (user == null || !user.isStatus()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getRequestURI();
        role = String.valueOf(user.getRole());

        if ((path.contains("/editor/") && !role.equals("2")) || (path.contains("/admin/") && !role.equals("3"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}