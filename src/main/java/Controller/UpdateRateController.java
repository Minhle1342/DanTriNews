package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Services.RevenueService;

@WebServlet("/admin/updateRate")
public class UpdateRateController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int newRate = Integer.parseInt(req.getParameter("viewRate"));
            RevenueService.updateViewRate(newRate);
            req.getSession().setAttribute("success", "Cập nhật đơn giá thành công!");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi cập nhật giá!");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");
    }
}