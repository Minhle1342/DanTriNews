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
import Utils.DateUtils;

@WebServlet("/admin/updateAd")
public class UpdateAdController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            // 1. Lấy dữ liệu từ Form
            int id = Integer.parseInt(req.getParameter("id"));
            String title = req.getParameter("title");
            String imageUrl = req.getParameter("imageUrl");
            String targetUrl = req.getParameter("targetUrl");
            String position = req.getParameter("position");
            String targetAudience = req.getParameter("targetAudience");
            String endDateStr = req.getParameter("endDate");

            // 2. Tìm Entity gốc để giữ lại các thông số tracking (views/clicks)
            AdBanner existingAd = AdBannerService.findById(id);

            if (existingAd == null) {
                 req.getSession().setAttribute("error", "Lỗi: Không tìm thấy banner cần cập nhật.");
                 resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=ads");
                 return;
            }

            // 3. Xử lý Date
            Date endDate = DateUtils.parseDate(endDateStr);

            // 4. Cập nhật các trường
            existingAd.setTitle(title);
            existingAd.setImageUrl(imageUrl);
            existingAd.setTargetUrl(targetUrl);
            existingAd.setPosition(position);
            existingAd.setTargetAudience(targetAudience);
            existingAd.setEndDate(endDate);

            // 5. Lưu vào DB (Hàm merge() trong Service)
            boolean success = AdBannerService.updateAdBanner(existingAd);

            if (success) {
                req.getSession().setAttribute("success", "Cập nhật Banner '" + title + "' thành công!");
            } else {
                req.getSession().setAttribute("error", "Lỗi: Không thể cập nhật Banner vào Database.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi xử lý dữ liệu: Vui lòng kiểm tra lại ID và ngày tháng.");
        }

        // Chuyển hướng về tab Quảng cáo
        resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=ads");
    }
}