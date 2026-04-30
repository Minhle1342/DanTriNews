package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.User;
import Entities.UserAvatar;
import Utils.JpaUtil;
import jakarta.persistence.*;
//AvatarController.java
@WebServlet("/api/avatar")
public class AvatarController extends HttpServlet {

 @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
     // Lấy Avatar hiện tại của User để hiển thị lên Video
     User user = (User) req.getSession().getAttribute("user");
     if (user == null) {
		return; // Hoặc trả về avatar mặc định
	 }

     EntityManager em = JpaUtil.getEntityManager();
     UserAvatar avatar = em.find(UserAvatar.class, user.getId());

     // Trả về JSON để JS xử lý (Gồm link ảnh gốc và trạng thái)
     resp.setContentType("application/json");
     resp.setCharacterEncoding("UTF-8");

     if (avatar != null) {
         String json = String.format("{\"skinUrl\": \"%s\", \"isActive\": %b}",
             avatar.getCurrentSkin().getBaseUrl(), avatar.isActive());
         resp.getWriter().write(json);
     } else {
         // Trả về skin mặc định nếu chưa set
         resp.getWriter().write("{\"skinUrl\": \"assets/avatars/default_\", \"isActive\": true}");
     }
     em.close();
 }

 @Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
     // Xử lý mua Skin hoặc Đổi Skin (Logic rút gọn)
     String action = req.getParameter("action");
     if ("toggle".equals(action)) {
         // Bật/Tắt Avatar
         // Logic update DB set is_active = !is_active
     }
 }
}
