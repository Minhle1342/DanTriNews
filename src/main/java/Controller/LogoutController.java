package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Utils.Utils;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Hủy Session (Quan trọng nhất)
        // Lấy session hiện tại, false nghĩa là nếu không có session thì không tạo mới
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("user");   // Xóa attribute user
            session.removeAttribute("userId"); // Xóa attribute userId
            session.invalidate();              // Hủy hoàn toàn session
        }

        // 2. Xóa Cookie (Đồng bộ với LoginController)
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                // Kiểm tra nếu cookie tên là USER_ID hoặc ROLE (các key trong Utils)
                if (Utils.COOKIE_KEY_USER_ID.equals(c.getName()) ||
                    Utils.COOKIE_KEY_ROLE.equals(c.getName())) {

                    c.setMaxAge(0); // Đặt thời gian sống = 0 để trình duyệt xóa ngay lập tức
                    c.setPath("/"); // QUAN TRỌNG: Phải set Path giống hệt lúc tạo cookie thì mới xóa được
                    c.setValue(""); // Xóa giá trị cho chắc chắn
                    resp.addCookie(c);
                }
            }
        }

        // 3. Chuyển hướng về trang đăng nhập
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}