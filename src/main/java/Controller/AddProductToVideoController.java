package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Video;
import Entities.VideoProduct;
import jakarta.persistence.EntityManager;

import javax.servlet.*;
@WebServlet("/admin/addProductToVideo")
public class AddProductToVideoController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            String productIdStr = req.getParameter("productId");
            int videoId = Integer.parseInt(req.getParameter("videoId"));

            EntityManager em = Utils.JpaUtil.getEntityManagerFactory().createEntityManager();
            em.getTransaction().begin();

            VideoProduct vp;
            if (productIdStr != null && !productIdStr.isEmpty()) {
                // TRƯỜNG HỢP: CẬP NHẬT
                vp = em.find(VideoProduct.class, Integer.parseInt(productIdStr));
            } else {
                // TRƯỜNG HỢP: THÊM MỚI
                vp = new VideoProduct();
                vp.setVideo(em.find(Video.class, videoId));
            }

            vp.setProductName(req.getParameter("productName"));
            vp.setAffiliateUrl(req.getParameter("affiliateUrl"));
            vp.setPriceDisplay(req.getParameter("priceDisplay"));
            vp.setStartTime(Integer.parseInt(req.getParameter("startTime")));
            vp.setEndTime(Integer.parseInt(req.getParameter("endTime")));

            em.merge(vp);
            em.getTransaction().commit();
            em.close();

            req.getSession().setAttribute("success", "Lưu thông tin sản phẩm thành công!");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
        resp.sendRedirect("videoDetail?id=" + req.getParameter("videoId"));
    }
}