package Controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Entities.Video;
import Services.AdBannerService;
import Services.CategoryServices;
import Services.RoleUpgradeRequestService;
import Services.UserServices;
import Services.VideoServices;

@WebServlet("/admin/adminPanel")
@MultipartConfig
public class AdminPanelController extends HttpServlet {

	private int parseIntSafe(String value) {
	    try {
	        if (value == null || value.trim().isEmpty()) {
				return 0;
			}
	        return Integer.parseInt(value.trim());
	    } catch (NumberFormatException e) {
	        return 0;
	    }
	}

	private void loadData(HttpServletRequest req) {
	    String currentTab = req.getParameter("tab");

	    // --- 1. Load Thống kê chung ---
	    List<Object[]> topLiked = VideoServices.getTopLikedVideos(5);
	    List<String> likedTitles = new ArrayList<>();
	    List<Long> likedCounts = new ArrayList<>();
	    if (topLiked != null) {
	        for (Object[] row : topLiked) {
	            Video v = (Video) row[0];
	            likedTitles.add(v.getTitle());
	            likedCounts.add((Long) row[1]);
	        }
	    }

	    req.setAttribute("totalRevenue", Services.RevenueService.getTotalRevenue());
	    req.setAttribute("viewRate", Services.RevenueService.getViewRate());
	    List<Object[]> editorStats = Services.RevenueService.getEditorRevenueStats();
	    req.setAttribute("editorStats", editorStats);

	    long totalExpense = 0;
	    for(Object[] row : editorStats) { totalExpense += (long) row[2]; }
	    req.setAttribute("totalExpense", totalExpense);
	    req.setAttribute("netProfit", (long)req.getAttribute("totalRevenue") - totalExpense);
	    req.setAttribute("ads", AdBannerService.getAllBanners());

	    // --- 2. XỬ LÝ LỌC NGƯỜI DÙNG (CHỈ CHẠY KHI Ở TAB USER) ---
	    if ("user".equals(currentTab)) {
	        String keyword = req.getParameter("keyword");
	        int roleId = parseIntSafe(req.getParameter("roleId"));
	        req.setAttribute("users", UserServices.getFilteredUsers(roleId, keyword));
	    } else {
	        // Mặc định load tất cả nếu không ở tab user
	        req.setAttribute("users", UserServices.getAllUsers());
	    }

	    // --- 3. Load dữ liệu các tab khác ---
	    req.setAttribute("topViewed", VideoServices.getTopViewedVideos(5));
	    req.setAttribute("likedTitles", likedTitles);
	    req.setAttribute("likedCounts", likedCounts);
	    req.setAttribute("videos", new VideoServices().getAllVideos());
	    req.setAttribute("categories", CategoryServices.getAll());
	    req.setAttribute("roleRequests", RoleUpgradeRequestService.getAll());

	}

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String idStr = req.getParameter("id");

        // --- XỬ LÝ CÁC HÀNH ĐỘNG GET (Link bấm, Xóa, Xem chi tiết...) ---

        // 1. Khóa/Mở khóa tài khoản User
        if ("toggle".equals(action) && idStr != null) {
            try {
                 UserServices.toggleStatus(Integer.parseInt(idStr)); // Giữ nguyên code cũ
                req.getSession().setAttribute("success", "Cập nhật trạng thái người dùng thành công!");
            } catch (Exception e) {
                req.getSession().setAttribute("error", "Lỗi khi cập nhật trạng thái user.");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=user");
            return;
        }

        // 2. Xem chi tiết User
        if ("view".equals(action) && idStr != null) {
            try {
                 req.setAttribute("userDetail", UserServices.getInfo(Integer.parseInt(idStr))); // Giữ nguyên code cũ
                req.getRequestDispatcher("/admin/userDetail.jsp").forward(req, resp);
                return;
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        // 3. Xóa Danh mục
        if ("deleteCategory".equals(action) && idStr != null) {
            try {
                int idCate = Integer.parseInt(idStr);
                 String error = CategoryServices.delete(idCate); // Giữ nguyên code cũ

                if (error == null) {
                    req.getSession().setAttribute("success", "Đã xóa danh mục thành công!");
                } else {
                    req.getSession().setAttribute("error", error);
                }
            } catch (Exception e) {
                e.printStackTrace();
                req.getSession().setAttribute("error", "ID danh mục không hợp lệ.");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");
            return;
        }



        // --- LOAD DỮ LIỆU ĐỂ HIỂN THỊ DASHBOARD ---

        // Chuyển thông báo từ Session sang Request Attribute để hiển thị 1 lần rồi xóa
        HttpSession session = req.getSession();
        if (session.getAttribute("success") != null) {
            req.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }
        if (session.getAttribute("error") != null) {
            req.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        // Nếu có thông báo lỗi từ AddVideoController (code cũ của bạn dùng key này)
        if (session.getAttribute("errCategory") != null) {
            req.setAttribute("errCategory", session.getAttribute("errCategory"));
            session.removeAttribute("errCategory");
        }



        // Nếu Admin đang ở tab Quảng cáo


        // Load dữ liệu chung cho các tab (Ví dụ: danh sách videos, users, categories)
        loadData(req);

        // Forward đến trang Admin Panel chung
        req.getRequestDispatcher("/admin/adminPanel.jsp").forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        // 1. Xử lý Thêm Danh Mục (Add Category)
        if ("addCategory".equals(action)) {
            String name = req.getParameter("name");

            if(name != null && !name.trim().isEmpty()) {
                boolean ok = CategoryServices.add(name);
                if (ok) {
                    req.getSession().setAttribute("success", "Thêm danh mục mới thành công!");
                } else {
                    req.getSession().setAttribute("error", "Thêm thất bại. Có thể tên đã tồn tại.");
                }
            } else {
                req.getSession().setAttribute("error", "Tên danh mục không được để trống.");
            }

            resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");
            return;
        }

        // Fallback: Nếu action lạ thì load lại trang
        doGet(req, resp);
    }
}