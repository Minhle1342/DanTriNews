package Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Category;
import Entities.Comment;
import Entities.User;
import Entities.Video;
import Entities.VideoProduct;
import Services.AdBannerService;
import Services.CategoryServices;
import Services.CommentServices;
import Services.HistoryServices;
import Services.VideoServices;

@WebServlet("/postdetail")
public class PostDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        // 1. Load danh mục cho Menu
        List<Category> categories = CategoryServices.getAll();
        req.setAttribute("categories", categories);

        // 2. Kiểm tra ID bài viết
        String idStr = req.getParameter("id");
        if (idStr == null || !idStr.matches("\\d+")) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        int videoId = Integer.parseInt(idStr);

        // 3. Lấy thông tin Video chi tiết
        Video video = VideoServices.getInfoById(videoId);
        if (video == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // 4. Kiểm tra quyền truy cập VIP
        User user = (User) req.getSession().getAttribute("user");
        if (video.isPremium()) {
            if (user == null || !user.isVip()) {
                req.setAttribute("error", "Nội dung này dành riêng cho thành viên VIP. Vui lòng nâng cấp!");
                req.getRequestDispatcher("/upgradeVip.jsp").forward(req, resp);
                return;
            }
        }

        boolean isVip = (user != null && user.isVip());

        // 5. Quản lý Banner theo đối tượng
        req.setAttribute("sidebarBanner", AdBannerService.getBanners(isVip, "SIDEBAR_TOP"));
        req.setAttribute("inContentBanner", AdBannerService.getBanners(isVip, "IN_CONTENT_1"));
        req.setAttribute("bottomBanner", AdBannerService.getBanners(isVip, "SIDEBAR_BOTTOM"));

        // 6. Xử lý Lượt xem và Tính tiền (Đồng bộ logic mới)
        int userId = (user != null) ? user.getId() : 0;
        String viewedKey = "viewed_video_" + videoId;

        // Tránh tăng view ảo khi người dùng nhấn F5 liên tục trong một phiên làm việc
        if (req.getSession().getAttribute(viewedKey) == null) {

            // ✅ Chỉ cần gọi hàm này.
            // Bên trong VideoServices.increaseView đã tự động gọi distributeMoneyForView.
            VideoServices.increaseView(videoId, userId);

            // Đánh dấu vào Session để không tăng thêm trong phiên này
            req.getSession().setAttribute(viewedKey, true);
        }

        // 7. Chuẩn bị các dữ liệu hiển thị khác
        int catId = video.getCategory().getId();
        req.setAttribute("category", video.getCategory());

        // Lấy bài viết liên quan
        List<Video> relatedVideos = VideoServices.getRelatedVideos(videoId, catId, video.getTitle(), 6);
        req.setAttribute("relatedVideos", relatedVideos);

        List<VideoProduct> vProducts = VideoServices.getProductsByVideo(videoId);
        req.setAttribute("vProducts", vProducts);

        // Lấy danh sách bình luận
        List<Comment> comments = CommentServices.getCommentsByVideoId(videoId);
        req.setAttribute("comments", comments);

        // Lưu lịch sử xem và kiểm tra trạng thái yêu thích
        boolean isFavourited = false;
        if (user != null) {
            HistoryServices.saveHistory(user.getId(), videoId);
            isFavourited = VideoServices.isUserFavourited(user.getId(), videoId);
        }

        req.setAttribute("isFavourited", isFavourited);
        req.setAttribute("video", video);
        req.setAttribute("favouriteCount", VideoServices.getFavouriteCount(videoId));

        // 8. Chuyển hướng sang trang giao diện
        req.getRequestDispatcher("postDetail.jsp").forward(req, resp);
    }
}