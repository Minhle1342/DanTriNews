package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.RoleUpgradeRequest;
import Entities.User;
import Services.RoleUpgradeRequestService;

@WebServlet("/admin/role-request-detail")
public class AdminRoleRequestDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

    	req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        User admin = (User) req.getSession().getAttribute("user");
        if (admin == null || admin.getRole() != 3) {
            resp.sendRedirect("../login");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        RoleUpgradeRequest r = RoleUpgradeRequestService.getById(id);

        if (r == null) {
            resp.sendRedirect("./role-requests?error=notfound");
            return;
        }

        req.setAttribute("reqRole", r);
        req.getRequestDispatcher("/admin/role_request_detail.jsp").forward(req, resp);
    }
}

