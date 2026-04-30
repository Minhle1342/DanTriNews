package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.User;
import Services.HistoryServices;

@WebServlet("/api/history-save")
public class HistoryAPIController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("-------------------------------------------------");
        System.out.println("DEBUG: API /api/history-save ĐƯỢC GỌI");

        req.setCharacterEncoding("UTF-8");

        // 1. Kiểm tra User
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            System.out.println("DEBUG: User chưa đăng nhập (Session user is null) -> Dừng xử lý.");
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // Trả về lỗi 401 để JS biết
            return;
        }
        System.out.println("DEBUG: User đang request: ID = " + user.getId() + ", Name = " + user.getName());

        try {
            // 2. Kiểm tra tham số gửi lên
            String videoIdStr = req.getParameter("videoId");
            String currentTimeStr = req.getParameter("currentTime");
            String durationStr = req.getParameter("duration");

            System.out.println("DEBUG: Params nhận được -> videoId: " + videoIdStr + ", currentTime: " + currentTimeStr + ", duration: " + durationStr);

            if (videoIdStr == null || currentTimeStr == null) {
                System.out.println("DEBUG: Lỗi -> Tham số bị Null/Rỗng");
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            int videoId = Integer.parseInt(videoIdStr);
            int currentTime = Integer.parseInt(currentTimeStr);
            int duration = Integer.parseInt(durationStr);

            // 3. Logic kiểm tra thời gian
            boolean isCompleted = false;
            if (duration > 0) {
                isCompleted = (currentTime >= duration * 0.90);
            }

            // Chỉ lưu nếu xem > 3s (giảm xuống để dễ test)
            if (currentTime > 3) {
                System.out.println("DEBUG: Đủ điều kiện lưu -> Đang gọi Service...");
                HistoryServices.saveProgress(user.getId(), videoId, currentTime, isCompleted);
            } else {
                System.out.println("DEBUG: Bỏ qua -> Thời gian xem quá ngắn (< 3s)");
            }

            resp.setStatus(HttpServletResponse.SC_OK);

        } catch (NumberFormatException e) {
            System.out.println("DEBUG: Lỗi parse số -> " + e.getMessage());
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            System.out.println("DEBUG: Lỗi không xác định -> " + e.getMessage());
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}