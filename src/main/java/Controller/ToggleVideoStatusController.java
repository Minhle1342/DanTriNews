package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Services.VideoServices;

@WebServlet("/admin/toggleVideoStatus")
public class ToggleVideoStatusController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String idRaw = req.getParameter("id");
            if (idRaw == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");
                return;
            }

            int videoId = Integer.parseInt(idRaw);

            VideoServices service = new VideoServices();
            boolean result = service.toggleStatus(videoId);

            // Chuyển hướng về giao diện quản lý bài đăng sau khi thay đổi trạng thái
            resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");
        }
    }
}
