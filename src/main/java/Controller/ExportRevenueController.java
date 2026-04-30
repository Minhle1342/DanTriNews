package Controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Services.RevenueExportService; // Service mới để tạo Excel

@WebServlet("/admin/exportRevenue")
public class ExportRevenueController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // --- 1. Thiết lập Header để trình duyệt hiểu là file Excel ---
        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");

        // Đặt tên file (Chứa ngày tháng hiện tại)
        String headerKey = "Content-Disposition";
        String headerValue = String.format("attachment; filename=\"BaoCaoDoanhThu_%s.xlsx\"",
                                            new java.text.SimpleDateFormat("yyyyMMdd_HHmmss").format(new java.util.Date()));
        resp.setHeader(headerKey, headerValue);

        try {
            // --- 2. Tạo và ghi dữ liệu Excel ---
            RevenueExportService.exportRevenueReport(resp.getOutputStream());

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi tạo báo cáo Excel: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=revenue");
        }
    }
}