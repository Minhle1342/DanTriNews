package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Services.AdBannerService;

@WebServlet("/admin/deleteAd")
public class DeleteAdController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");

        try {
            int id = Integer.parseInt(idStr);

            boolean success = AdBannerService.deleteAdBanner(id);

            if (success) {
                req.getSession().setAttribute("success", "Đã xóa vĩnh viễn banner ID: " + id + ".");
            } else {
                req.getSession().setAttribute("error", "Không tìm thấy hoặc không thể xóa banner ID: " + id + ".");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi xóa banner: ID không hợp lệ.");
        }

        // Chuyển hướng về tab Quảng cáo
        resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=ads");
    }
}