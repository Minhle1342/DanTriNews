package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.User;
import Services.CategoryServices;
import Services.RoleUpgradeRequestService;
import Services.UserServices;
import Services.VideoServices;

@WebServlet("/admin/changePassword")
public class ChangePasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || user.getRole() != 3) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.getRequestDispatcher("/admin/adminPanel.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        User user = (User) req.getSession().getAttribute("user");

        if (user == null || user.getRole() != 3) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String current = req.getParameter("currentPassword");
        String newPass = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        // Kiểm tra rỗng
        if (current == null || newPass == null || confirm == null ||
            current.isEmpty() || newPass.isEmpty() || confirm.isEmpty()) {

            req.setAttribute("err", "Không được để trống.");
            req.getRequestDispatcher("/admin/adminPanel.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra mật khẩu cũ đúng không
        User checkUser = UserServices.login(user.getUsername(), current);
        if (checkUser == null) {
            req.setAttribute("err", "Mật khẩu hiện tại không đúng.");
            req.getRequestDispatcher("/admin/adminPanel.jsp").forward(req, resp);
            return;
        }

        // Kiểm tra xác nhận mật khẩu
        if (!newPass.equals(confirm)) {
            req.setAttribute("err", "Xác nhận mật khẩu không khớp.");
            req.getRequestDispatcher("/admin/adminPanel.jsp").forward(req, resp);
            return;
        }

        // Gọi hàm đổi mật khẩu
        boolean ok = UserServices.updatePassword(user.getId(), newPass);

        if (ok) {
            req.setAttribute("success", "Đổi mật khẩu thành công.");


        } else {
            req.setAttribute("err", "Đổi mật khẩu thất bại.");
        }

        // Vẫn phải load thêm các phần khác để trang adminPanel không lỗi:
        req.setAttribute("categories", CategoryServices.getAll());
        req.setAttribute("videos", VideoServices.getAll());
        req.setAttribute("users", UserServices.getAllUsers());
        req.setAttribute("roleRequests", RoleUpgradeRequestService.getAll());


        req.getRequestDispatcher("/admin/adminPanel.jsp").forward(req, resp);
    }
}
