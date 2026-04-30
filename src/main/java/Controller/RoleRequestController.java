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

@WebServlet("/role-request")
public class RoleRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

    	req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        User user = (User) req.getSession().getAttribute("user");

        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        RoleUpgradeRequest existing = RoleUpgradeRequestService.getByUserId(user.getId());

        if (existing != null) {
            String statusText = "";

            switch (existing.getStatus()) {
                case 0: statusText = "pending"; break;
                case 1: statusText = "approved"; break;
                case 2: statusText = "rejected"; break;
            }

            req.setAttribute("requestStatus", statusText);
        }

        req.getRequestDispatcher("role_request.jsp").forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

    	req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        User user = (User) req.getSession().getAttribute("user");

        if (user == null) {
            resp.sendRedirect("login");
            return;
        }

        RoleUpgradeRequest r = new RoleUpgradeRequest();
        r.setUser(user);
        r.setReason(req.getParameter("reason"));
        r.setExperience(req.getParameter("experience"));
        r.setPortfolio(req.getParameter("portfolio"));
        r.setStatus(0); // pending

        RoleUpgradeRequestService.create(r);

        resp.sendRedirect("role-request");
    }
}