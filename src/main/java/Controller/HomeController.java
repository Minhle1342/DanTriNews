package Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Category;
import Entities.User;
import Entities.Video;
import Entities.VideoWatchHistory;
import Services.CategoryServices;
import Services.HistoryServices;
import Services.VideoServices;


@WebServlet("/")
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Category> categories = CategoryServices.getAll();
        req.setAttribute("categories", categories);

     // 2. --- THÊM ĐOẠN NÀY: LẤY DỮ LIỆU CHO PREMIUM ZONE ---
        List<Video> vipVideos = VideoServices.getPremiumVideos(); // Hàm bạn đã viết ở bước trước
        req.setAttribute("vipVideos", vipVideos);

        // Kiểm tra quyền VIP để xử lý giao diện khóa/mở
        User user = (User) req.getSession().getAttribute("user");
        boolean isVip = (user != null && user.isVip());
        req.setAttribute("isVip", isVip);
        // ------------------------------------------------------

        String catIdStr = req.getParameter("cat");

        Video newestPost;
        List<Video> videos;          // danh sách video theo category
        Category currentCategory = null;

        // ==============================
        // TRƯỜNG HỢP LỌC THEO DANH MỤC
        // ==============================
        if (catIdStr != null && catIdStr.matches("\\d+")) {
            int catId = Integer.parseInt(catIdStr);

            // lấy bài mới nhất theo category
            newestPost = VideoServices.getNewestPostByCategory(catId);

            // lấy toàn bộ video theo category
            videos = VideoServices.getVideosByCategory(catId);

            // lấy thông tin danh mục để hiển thị tiêu đề
            currentCategory = CategoryServices.getInfoById(catId);
        }
        else {
            // ==============================
            // MẶC ĐỊNH: HOME KHÔNG CHỌN DANH MỤC
            // ==============================

            newestPost = VideoServices.getNewestPost();

            // lấy tất cả video
            videos = VideoServices.getAll();

            currentCategory = null;
        }

        if (user != null) {
            // Nếu đã đăng nhập -> Gọi DB lấy lịch sử
            List<VideoWatchHistory> historyList = HistoryServices.getContinueWatching(user.getId());
            req.setAttribute("watchHistoryList", historyList);
        }

        req.setAttribute("newestPost", newestPost);
        req.setAttribute("videos", videos);
        req.setAttribute("currentCategory", currentCategory);

        req.getRequestDispatcher("/home.jsp").forward(req, resp);
    }
}


