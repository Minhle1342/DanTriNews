package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.User;
import Services.RoleUpgradeRequestService;

@WebServlet("/admin/role-request-action")
public class AdminRoleRequestActionController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            // DEBUG: In ra console server để kiểm tra
            String idStr = req.getParameter("id");
            String action = req.getParameter("action");
            System.out.println("DEBUG ACTION: ID=" + idStr + ", Action=" + action);

            if (idStr == null || action == null) {
                throw new Exception("Tham số ID hoặc Action bị null");
            }

            // Kiểm tra session user
            User admin = (User) req.getSession().getAttribute("user");
            if (admin == null) {
                System.out.println("DEBUG: Session User bị null");
                resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Hết phiên đăng nhập");
                return;
            }

            int id = Integer.parseInt(idStr);
            boolean success = false;

            if ("approve".equals(action)) {
                success = RoleUpgradeRequestService.approveRequest(id, admin.getId());
            } else if ("reject".equals(action)) {
                success = RoleUpgradeRequestService.rejectRequest(id, admin.getId());
            }

            if (success) {
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("OK");
            } else {
                System.out.println("DEBUG: Service trả về false");
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Service xử lý thất bại");
            }

        } catch (Exception e) {
            e.printStackTrace(); // Quan trọng: In lỗi ra console server
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }
}