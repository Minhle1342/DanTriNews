package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Services.VideoServices;
import Utils.Utils;

@WebServlet("/editor/delete")
public class EditorDeleteVideo extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
	        throws ServletException, IOException {
	    req.setCharacterEncoding("UTF-8");
	    resp.setContentType("text/html; charset=UTF-8");
	    // Lấy userId từ cookie
	    String userIdStr = Utils.getCookie(Utils.COOKIE_KEY_USER_ID, req);
	    if (userIdStr == null || !userIdStr.matches("\\d+")) {
	        resp.sendRedirect(req.getContextPath() + "/login");
	        return;
	    }
	    int userId = Integer.parseInt(userIdStr);
	    // Lấy videoId từ form
	    String videoIdStr = req.getParameter("videoId");
	    if (videoIdStr == null || !videoIdStr.matches("\\d+")) {  // Thêm validate param
	        req.getSession().setAttribute("error", "ID video không hợp lệ.");
	        resp.sendRedirect(req.getContextPath() + "/editor/workspace");
	        return;
	    }
	    int videoId = Integer.parseInt(videoIdStr);
	    // Lấy upload dir
	    String uploadDir = req.getServletContext().getRealPath("/assets/uploads");
	    // Gọi service xóa
	    String err = VideoServices.deleteVideo(videoId, userId, uploadDir);
	    if (err != null) {
	        req.getSession().setAttribute("error", "Không thể xóa: " + err);
	    } else {
	        req.getSession().setAttribute("success", "Xóa bài đăng thành công.");
	    }
	    // Redirect
	    resp.sendRedirect(req.getContextPath() + "/editor/workspace");
	}
}
