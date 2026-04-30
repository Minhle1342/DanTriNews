package Controller;



import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.User;
import Services.VideoServices;

@WebServlet("/favourite")
public class FavouriteController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Kiểm tra login
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = user.getId();
        int videoId = Integer.parseInt(req.getParameter("videoId"));

        // Không được thêm trùng
        boolean exists = VideoServices.isUserFavourited(userId, videoId);

        if (!exists) {
            VideoServices.addFavourite(userId, videoId);
        }

        // Quay lại trang chi tiết
        resp.sendRedirect(req.getContextPath() + "/postdetail?id=" + videoId);
    }
}
