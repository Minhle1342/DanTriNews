package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Video;
import Utils.JpaUtil;
import jakarta.persistence.*;
// URL này phải khớp với href trong file JSP: /admin/updateStatus
@WebServlet("/admin/updateStatus")
public class AdminUpdateStatusController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // 1. Lấy tham số từ URL
        String idStr = req.getParameter("id");
        String statusStr = req.getParameter("status");

        if (idStr != null && statusStr != null) {
            try {
                int videoId = Integer.parseInt(idStr);
                int newStatus = Integer.parseInt(statusStr);

                // 2. Gọi Service cập nhật trạng thái
                updateVideoStatus(videoId, newStatus);

            } catch (Exception e) {
                e.printStackTrace();
            }
        }



        String referer = req.getHeader("referer"); // Cách thông minh: Quay lại trang vừa đứng

        if(referer != null) {
            resp.sendRedirect(referer);
        } else {
            // Fallback nếu không lấy được referer
            resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");
        }
    }

    private void updateVideoStatus(int videoId, int status) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            Video v = em.find(Video.class, videoId);
            if (v != null) {
                v.setStatus(status);
                em.merge(v);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}