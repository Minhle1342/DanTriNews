package Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.User;
import Entities.Video;
import Services.VideoServices;

@WebServlet("/premium-zone")
public class PremiumZoneController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Lấy danh sách video VIP
        List<Video> vipVideos = VideoServices.getPremiumVideos();
        req.setAttribute("vipVideos", vipVideos);

        // 2. Kiểm tra user hiện tại có phải VIP không (để hiển thị giao diện khóa/mở)
        User user = (User) req.getSession().getAttribute("user");
        boolean isVip = (user != null && user.isVip());
        req.setAttribute("isVip", isVip);

        req.getRequestDispatcher("/premiumZone.jsp").forward(req, resp);
    }
}