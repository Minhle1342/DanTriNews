package Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Category;
import Entities.Video;
import Services.CategoryServices;
import Services.CommentServices;
import Services.VideoServices;

@WebServlet("/search")
public class SearchController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        // 1. Load danh mục để đổ vào thẻ <select>
        List<Category> categories = CategoryServices.getAll();
        req.setAttribute("categories", categories);

        // 2. Lấy tham số từ Form
        String keyword = req.getParameter("q");
        String catIdStr = req.getParameter("catId");
        String timeFilter = req.getParameter("time");

        // Xử lý tham số an toàn
        if (keyword == null) {
			keyword = "";
		}

        int catId = 0;
        if (catIdStr != null && catIdStr.matches("\\d+")) {
            catId = Integer.parseInt(catIdStr);
        }

        if (timeFilter == null) {
			timeFilter = "all";
		}

        // 3. Gọi Service Tìm kiếm nâng cao
        List<Video> results = VideoServices.searchAdvanced(keyword, catId, timeFilter);

        // 4. Bổ sung thông tin phụ (Comment/Like count)
        if (results != null) {
            for (Video v : results) {
                v.setFavouriteCount(VideoServices.getFavouriteCount(v.getId()));
                v.setCommentCount(CommentServices.getCommentCount(v.getId()));
            }
        }

        // 5. Đẩy dữ liệu ra JSP
        req.setAttribute("results", results);

        // Lưu lại trạng thái đã chọn để hiển thị trên Form
        req.setAttribute("keyword", keyword);
        req.setAttribute("selectedCat", catId);
        req.setAttribute("selectedTime", timeFilter);

        req.getRequestDispatcher("/search.jsp").forward(req, resp);
    }
}