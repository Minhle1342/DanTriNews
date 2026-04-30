package Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.RoleUpgradeRequest;
import Services.CategoryServices;
import Services.RoleUpgradeRequestService;
import Services.UserServices;
import Services.VideoServices;


@WebServlet("/admin/role-request")
public class AdminRoleRequestListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

    	req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        // LỌC THEO STATUS
        String status = req.getParameter("status");
        List<RoleUpgradeRequest> list;

        if (status == null || status.equals("")) {
            list = RoleUpgradeRequestService.getAll();   // phải trả đủ 100%
        } else {
            list = RoleUpgradeRequestService.getByStatus(Integer.parseInt(status));
        }

        // Gửi list request vào JSP
        req.setAttribute("list", list);
        System.out.println("SIZE = " + list.size());


        // Vẫn phải load thêm các phần khác để trang adminPanel không lỗi:
        req.setAttribute("categories", CategoryServices.getAll());
        req.setAttribute("videos", VideoServices.getAll());
        req.setAttribute("users", UserServices.getAllUsers());



        req.getRequestDispatcher("/admin/roleRequestList.jsp").forward(req, resp);
    }
}

