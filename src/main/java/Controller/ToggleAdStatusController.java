package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.AdBanner;
import Services.AdBannerService;

@WebServlet("/admin/toggleAdStatus")
public class ToggleAdStatusController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String isActiveStr = req.getParameter("isActive"); // 0 hoặc 1

        try {
            int id = Integer.parseInt(idStr);
            boolean newStatus = isActiveStr.equals("1");

            AdBanner ad = AdBannerService.findById(id);
            if (ad != null) {
                ad.setIsActive(newStatus);
                AdBannerService.updateAdBanner(ad);

                String statusText = newStatus ? "Bật" : "Ẩn";
                req.getSession().setAttribute("success", statusText + " banner '" + ad.getTitle() + "' thành công!");
            } else {
                 req.getSession().setAttribute("error", "Không tìm thấy banner cần cập nhật.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi xử lý trạng thái banner: " + e.getMessage());
        }

        // Chuyển hướng về tab Quảng cáo
        resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=ads");
    }
}