package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Notification;
import Services.NotificationServices; // Đảm bảo đã import Service này

@WebServlet("/notification/read")
public class NotificationReadController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // 1. Lấy ID thông báo từ tham số
            int notiId = Integer.parseInt(req.getParameter("id"));

            // 2. Tìm thông báo trong DB
            Notification n = NotificationServices.findById(notiId);

            if (n != null) {
                // 3. Đánh dấu đã đọc (nếu chưa đọc)
                if (!n.isRead()) {
                    NotificationServices.markAsRead(notiId);
                }

                // 4. Chuyển hướng đến bài viết liên quan
                // Lưu ý: Nếu Video object lazy load, cần đảm bảo service findById đã fetch Video
                resp.sendRedirect(req.getContextPath() + "/postdetail?id=" + n.getVideo().getId());
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Nếu lỗi hoặc không tìm thấy, quay về trang chủ
        resp.sendRedirect(req.getContextPath() + "/");
    }
}