package Controller;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.AdBanner;
import Services.AdBannerService;
import Utils.DateUtils; // Cần dùng hàm chuyển đổi String sang Date (Nếu chưa có, cần tạo)

@WebServlet("/admin/createAd")
public class CreateAdController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            // 1. Lấy dữ liệu từ Form
            String title = req.getParameter("title");
            String imageUrl = req.getParameter("imageUrl");
            String targetUrl = req.getParameter("targetUrl");
            String position = req.getParameter("position");
            String targetAudience = req.getParameter("targetAudience");
            String endDateStr = req.getParameter("endDate"); // Có thể là null

            // 2. Xử lý Date
            Date endDate = null;
            if (endDateStr != null && !endDateStr.isEmpty()) {
                // Giả định bạn có hàm tiện ích để chuyển đổi yyyy-MM-dd sang Date
                // Nếu chưa có, bạn có thể tự implement hoặc dùng SimpleDateFormat
                endDate = DateUtils.parseDate(endDateStr);
            }

            // 3. Tạo Entity
            AdBanner newAd = new AdBanner(title, imageUrl, targetUrl, position, targetAudience, new Date(), endDate);

            // 4. Lưu vào DB
            boolean success = AdBannerService.createAdBanner(newAd);

            if (success) {
                req.getSession().setAttribute("success", "Đã thêm Banner mới thành công!");
            } else {
                req.getSession().setAttribute("error", "Lỗi: Không thể lưu Banner vào Database.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi xử lý dữ liệu: " + e.getMessage());
        }

        // Chuyển hướng về tab Quảng cáo
        resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=ads");
    }
}