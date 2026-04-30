package Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Category;
import Entities.History;
import Entities.User;
import Entities.Video;
import Services.CategoryServices;
import Services.HistoryServices;
import Services.UserServices;
import Services.VideoServices;
@WebServlet("/profile")
public class UserProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");

        List<Category> categories = CategoryServices.getAll();
        req.setAttribute("categories", categories);


        if (user != null) {
            // 1. Lấy thông tin user mới nhất từ DB (để tránh session cũ)
            User userInfo = UserServices.getById(user.getId());
            req.setAttribute("userInfo", userInfo);

            // 2. Lấy danh sách lịch sử
            // Giả sử HistoryServices.getHistoryByUser trả về List<History>
            List<History> historyList = HistoryServices.getHistoryByUser(user.getId());
            req.setAttribute("historyList", historyList);

            // 3. Lấy danh sách yêu thích
            // Giả sử VideoServices.getFavouritedVideosByUserId trả về List<Video>
            List<Video> favouriteList = VideoServices.getFavouritedVideosByUserId(user.getId());
            req.setAttribute("favouriteList", favouriteList);

            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
