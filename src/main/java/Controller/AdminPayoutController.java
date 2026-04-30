package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.User;
import Services.PayoutService; // Cần tạo service này ở bước 4

@WebServlet("/admin/confirmPayout")
public class AdminPayoutController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            // Lấy thông tin từ form
            int editorId = Integer.parseInt(req.getParameter("editorId"));
            long amount = Long.parseLong(req.getParameter("amount"));
            String bankName = req.getParameter("bankName");
            String bankAccount = req.getParameter("bankAccount");

            // Lấy Admin đang đăng nhập
            User admin = (User) req.getSession().getAttribute("user");

            if (admin != null && admin.getRole() == 3) {
                // Gọi Service lưu vào DB
                boolean success = PayoutService.savePayout(admin.getId(), editorId, amount, bankName, bankAccount);

                if (success) {
                    req.getSession().setAttribute("success", "Đã lưu lịch sử thanh toán thành công!");
                } else {
                    req.getSession().setAttribute("error", "Lỗi khi lưu dữ liệu.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");
    }
}