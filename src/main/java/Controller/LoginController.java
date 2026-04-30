package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;

import Beans.LoginBean;
import Entities.User;
import Services.UserServices;
import Utils.Utils;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // Xóa cookie thông báo đăng ký thành công
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("registerSuccess".equals(c.getName())) {
                    c.setMaxAge(0);
                    resp.addCookie(c);
                }
            }
        }

        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        // Xóa cookie message đăng ký
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("registerSuccess".equals(c.getName())) {
                    c.setMaxAge(0);
                    resp.addCookie(c);
                }
            }
        }

        try {
            LoginBean bean = new LoginBean();
            BeanUtils.populate(bean, req.getParameterMap());
            req.setAttribute("bean", bean);

            // Kiểm tra lỗi form
            if (!bean.getErrors().isEmpty()) {
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return; // NGĂN FORWARD LẶP
            }

            // Check login
            User user = UserServices.login(bean.getUsernameOrEmail(), bean.getPassword());

            if (user == null) {
                req.setAttribute("errLogin", "Sai tài khoản hoặc mật khẩu");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }


         // User bị khóa → status = false → chặn login
            if (user.getId() == 0 && user.getUsername() == null) {
                req.setAttribute("lockedAccount", true);
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }

            // Đăng nhập thành công → LƯU SESSION
            req.getSession().setAttribute("user", user);      // Quan trọng
            req.getSession().setAttribute("userId", user.getId());

            // Set cookie nếu muốn giữ login
            Utils.setCookie(Utils.COOKIE_KEY_USER_ID, String.valueOf(user.getId()), resp);
            Utils.setCookie(Utils.COOKIE_KEY_ROLE, String.valueOf(user.getRole()), resp);

            int role = user.getRole();

            if (role == 1) {
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }

            if (role == 2) {
                resp.sendRedirect(req.getContextPath() + "/editor/workspace");
                return;
            }

            if (role == 3) {
                resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");
                return;
            }

            req.setAttribute("errLogin", "Không xác định được vai trò người dùng");

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

}
