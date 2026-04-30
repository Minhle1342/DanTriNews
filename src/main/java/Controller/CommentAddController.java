package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Entities.Comment;
import Entities.User;
import Entities.Video;
import Services.CommentServices;
import Services.NotificationServices; // Import Service mới
import Services.VideoServices;

@WebServlet("/comment/add")
public class CommentAddController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int videoId;
        try {
            videoId = Integer.parseInt(req.getParameter("videoId"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        String content = req.getParameter("content");
        if (content == null || content.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/postdetail?id=" + videoId);
            return;
        }

        Video video = VideoServices.getInfoById(videoId);
        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

     // Lấy parent comment nếu có
        Comment parent = null;
        try {
            String parentIdStr = req.getParameter("parentId");
            if (parentIdStr != null && !parentIdStr.isEmpty()) {
                parent = CommentServices.getById(Integer.parseInt(parentIdStr));
            }
        } catch (Exception ignore) {}

        // 1. Thêm bình luận vào DB
        CommentServices.addComment(user, video, content.trim(), parent);

        // 2. GỬI THÔNG BÁO (LOGIC MỚI)
        if (parent != null) {
            User receiver = parent.getUser(); // Mặc định gửi cho chủ comment cha

            // Kiểm tra xem có đang trả lời cụ thể một người trong nhóm sub-comment không
            try {
                String replyToUserIdStr = req.getParameter("replyToUserId");
                if (replyToUserIdStr != null && !replyToUserIdStr.isEmpty()) {
                    int targetId = Integer.parseInt(replyToUserIdStr);
                    // Nếu có targetId hợp lệ, đổi người nhận thành người đó
                    User targetUser = Services.UserServices.getById(targetId); // Giả sử bạn có hàm này
                    if (targetUser != null) {
                        receiver = targetUser;
                    }
                }
            } catch (Exception e) {}

            // Gửi thông báo
            NotificationServices.addNotification(
                receiver,   // Người nhận (đã xử lý logic ở trên)
                user,       // Người gửi
                video,
                "đã trả lời bình luận của bạn.",
                1
            );
        }

        // 3. Redirect ...
        resp.sendRedirect(req.getContextPath() + "/postdetail?id=" + videoId + "#comments-section");
}
}