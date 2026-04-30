package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet({"/forgot-password", "/verify-code", "/reset-password"})
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if (path.equals("/forgot-password")) {
            req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
        }
        // Các trang khác không cho truy cập trực tiếp bằng GET để bảo mật luồng
        else {
            resp.sendRedirect(req.getContextPath() + "/forgot-password");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession();

        // 1. Xử lý Gửi Email
        if (path.equals("/forgot-password")) {
            String email = req.getParameter("email");
            boolean isSent = Services.UserServices.sendResetPasswordCode(email);

            if (isSent) {
                session.setAttribute("resetEmail", email); // Lưu email tạm để dùng bước sau
                req.setAttribute("message", "Mã xác nhận đã được gửi vào email của bạn.");
                req.getRequestDispatcher("/views/auth/verify-code.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Email không tồn tại trong hệ thống.");
                req.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(req, resp);
            }
        }

        // 2. Xử lý Check Mã OTP
        else if (path.equals("/verify-code")) {
            String code = req.getParameter("code");
            String email = (String) session.getAttribute("resetEmail");

            if (email == null) {
                resp.sendRedirect("forgot-password");
                return;
            }

            boolean isValid = Services.UserServices.verifyRecoveryCode(email, code);
            if (isValid) {
                // Mã đúng, chuyển sang trang nhập pass mới
                req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Mã xác nhận không đúng hoặc đã hết hạn.");
                req.setAttribute("message", "Đã gửi mã đến: " + email); // Giữ lại thông báo
                req.getRequestDispatcher("/views/auth/verify-code.jsp").forward(req, resp);
            }
        }

        // 3. Xử lý Đổi mật khẩu mới
        else if (path.equals("/reset-password")) {
            String newPass = req.getParameter("newPassword");
            String confirmPass = req.getParameter("confirmPassword");
            String email = (String) session.getAttribute("resetEmail");

            if (!newPass.equals(confirmPass)) {
                req.setAttribute("error", "Mật khẩu xác nhận không khớp.");
                req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
                return;
            }

            boolean isReset = Services.UserServices.resetPassword(email, newPass);
            if (isReset) {
                session.removeAttribute("resetEmail"); // Xóa session tạm
                req.setAttribute("successMessage", "Đổi mật khẩu thành công! Vui lòng đăng nhập.");
                // Chuyển về trang Login (giả sử đường dẫn là /login)
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Lỗi hệ thống, vui lòng thử lại.");
                req.getRequestDispatcher("/views/auth/reset-password.jsp").forward(req, resp);
            }
        }
    }
}
