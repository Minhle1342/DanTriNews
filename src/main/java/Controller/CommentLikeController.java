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
import Services.CommentServices;
import Services.NotificationServices; // Import Service mới

@WebServlet("/comment/like")
public class CommentLikeController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            int commentId = Integer.parseInt(req.getParameter("id"));

            // Lấy thông tin comment để biết ai là chủ sở hữu (để gửi thông báo)
            Comment comment = CommentServices.getById(commentId);

            if (comment != null) {
                // 1. Toggle Like và lấy trạng thái (true = vừa like, false = vừa unlike)
                boolean isLiked = CommentServices.toggleLike(user.getId(), commentId);

                // 2. Chỉ gửi thông báo khi hành động là LIKE (isLiked == true)
                if (isLiked) {
                    NotificationServices.addNotification(
                        comment.getUser(),  // Người nhận: Chủ comment
                        user,               // Người gửi: Người đang bấm like
                        comment.getVideo(), // Video liên quan
                        "đã thích bình luận của bạn.",
                        2                   // Type: 2 (Like)
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String referer = req.getHeader("referer");
        resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/");
    }
}