package Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Video;
import Entities.VideoProduct;
import Services.VideoServices;
import Utils.JpaUtil;
import jakarta.persistence.*;
@WebServlet("/admin/videoDetail")
public class VideoDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String idRaw = req.getParameter("id");
            if (idRaw == null || idRaw.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?err=no_id");
                return;
            }

            int id = Integer.parseInt(idRaw);
            VideoServices service = new VideoServices();

            // 1. Lấy thông tin chi tiết Video
            Video video = service.getVideoById(id);

            if (video == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?err=not_found");
                return;
            }

            // 2. Lấy danh sách sản phẩm đã gán cho video này (Mới cập nhật)
            List<VideoProduct> vProducts = VideoServices.getProductsByVideo(id);

            // 3. Đẩy dữ liệu ra giao diện
            req.setAttribute("video", video);
            req.setAttribute("vProducts", vProducts);
            req.getRequestDispatcher("/admin/video-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().println("Lỗi hệ thống: " + e.getMessage());
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            String productIdStr = req.getParameter("productId");
            int videoId = Integer.parseInt(req.getParameter("videoId"));

            EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
            em.getTransaction().begin();

            VideoProduct vp;
            if (productIdStr != null && !productIdStr.isEmpty()) {
                // Trường hợp SỬA
                vp = em.find(VideoProduct.class, Integer.parseInt(productIdStr));
            } else {
                // Trường hợp THÊM MỚI
                vp = new VideoProduct();
                vp.setVideo(em.find(Video.class, videoId));
            }

            vp.setProductName(req.getParameter("productName"));
            vp.setAffiliateUrl(req.getParameter("affiliateUrl"));
            vp.setPriceDisplay(req.getParameter("priceDisplay"));
            vp.setStartTime(Integer.parseInt(req.getParameter("startTime")));
            vp.setEndTime(Integer.parseInt(req.getParameter("endTime")));

            em.merge(vp); // Merge xử lý được cả thêm và sửa
            em.getTransaction().commit();
            em.close();

            req.getSession().setAttribute("success", "Thành công!");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
        resp.sendRedirect("videoDetail?id=" + req.getParameter("videoId"));
    }
}