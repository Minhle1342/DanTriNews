package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.User;
import Services.UserServices;

// Đảm bảo URL này khớp chính xác với action trong form HTML
@WebServlet("/editor/updateBank")
public class EditorBankController extends HttpServlet {

    // 1. Thêm hàm doGet để xử lý khi người dùng truy cập trực tiếp link này
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Nếu ai đó cố tình vào link này bằng GET, đẩy họ về trang workspace
        resp.sendRedirect(req.getContextPath() + "/editor/workspace");
    }

    // 2. Hàm doPost xử lý Form gửi lên
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            User user = (User) req.getSession().getAttribute("user");

            // Kiểm tra user có tồn tại không
            if (user != null) {
                String bank = req.getParameter("bankName");
                String acc = req.getParameter("bankAccount");
                String name = req.getParameter("bankAccountName");

                // Kiểm tra dữ liệu đầu vào cơ bản (tránh null)
                if(bank != null && acc != null && name != null) {
                    // Gọi Service lưu vào DB
                    UserServices.updateBankInfo(user.getId(), bank, acc, name);

                    // Cập nhật lại Session để hiển thị ngay
                    user.setBankName(bank);
                    user.setBankAccount(acc);
                    user.setBankAccountName(name);
                    req.getSession().setAttribute("user", user);

                    req.getSession().setAttribute("success", "Cập nhật thông tin nhận tiền thành công!");
                } else {
                     req.getSession().setAttribute("error", "Dữ liệu không được để trống!");
                }
            } else {
                // Nếu mất session thì bắt đăng nhập lại
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/editor/workspace");
    }
}