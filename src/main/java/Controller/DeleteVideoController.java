package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Video;
import Services.VideoServices; // Đảm bảo import đúng gói Services

@WebServlet("/admin/deleteVideo")
public class DeleteVideoController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");

        try {
            int id = Integer.parseInt(idStr);

            // Lấy thông tin video trước khi xóa để hiển thị thông báo
            Video videoToDelete = VideoServices.getInfoById(id);

            boolean success = VideoServices.deleteVideo(id);

            if (success) {
                String title = (videoToDelete != null) ? videoToDelete.getTitle() : "Bài viết";
                req.getSession().setAttribute("success", "Đã xóa vĩnh viễn bài viết: " + title + ".");
            } else {
                req.getSession().setAttribute("error", "Lỗi: Không thể xóa bài viết ID " + id + ".");
            }

        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "ID bài viết không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi hệ thống khi xóa bài viết.");
        }

        // Chuyển hướng về tab quản lý bài viết
        resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=post");
    }



}