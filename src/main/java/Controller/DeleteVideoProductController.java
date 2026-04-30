package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.VideoProduct;
import jakarta.persistence.EntityManager;

@WebServlet("/admin/deleteVideoProduct")
public class DeleteVideoProductController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        String videoId = req.getParameter("videoId");

        if (idStr != null) {
            EntityManager em = Utils.JpaUtil.getEntityManagerFactory().createEntityManager();
            try {
                em.getTransaction().begin();
                VideoProduct vp = em.find(VideoProduct.class, Integer.parseInt(idStr));
                if (vp != null) {
                    em.remove(vp);
                }
                em.getTransaction().commit();
            } finally {
                em.close();
            }
        }
        // Quay lại trang quản lý chính của video đó
        resp.sendRedirect(req.getContextPath() + "/admin/videoMarker?videoId=" + videoId);
    }
}
