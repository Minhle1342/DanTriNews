package Controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map; // Import Map

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import Beans.EditorPostBean;
import Entities.Category;
import Entities.History;
import Entities.Video;
import Services.CategoryServices;
import Services.HistoryServices;
import Services.VideoServices;
import Utils.Utils;

@WebServlet("/editor/workspace")
@MultipartConfig
public class EditorWorkSpace extends HttpServlet {

    // ... (Giữ nguyên các hàm saveFile và resolveUserId) ...
    private String saveFile(Part part, HttpServletRequest req) throws IOException {
        if (part == null || part.getSize() == 0) {
			return null;
		}
        String fileName = java.nio.file.Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String uploadPath = req.getServletContext().getRealPath("/assets/uploads");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}
        part.write(uploadPath + File.separator + fileName);
        return fileName;
    }

    private Integer resolveUserId(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Object uidObj = req.getSession().getAttribute("userId");
        if (uidObj instanceof Integer) {
			return (Integer) uidObj;
		}
        if (uidObj instanceof String && ((String) uidObj).matches("\\d+")) {
			return Integer.parseInt((String) uidObj);
		}
        String userIdStr = Utils.getCookie(Utils.COOKIE_KEY_USER_ID, req);
        if (userIdStr != null && userIdStr.matches("\\d+")) {
			return Integer.parseInt(userIdStr);
		}
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Category> categories = CategoryServices.getAll();
        req.setAttribute("categories", categories);

        Integer userId = resolveUserId(req, resp);
        if (userId != null) {

            // --- 1. XỬ LÝ DANH SÁCH VIDEO (TÌM KIẾM HOẶC MẶC ĐỊNH) ---
            String action = req.getParameter("action");
            if ("search".equals(action)) {
                String catStr = req.getParameter("catId");
                String keyword = req.getParameter("keyword");
                int catId = (catStr != null && catStr.matches("\\d+")) ? Integer.parseInt(catStr) : 0;

                List<Video> videos = VideoServices.searchApprovedVideos(userId, catId, keyword);
                req.setAttribute("videos", videos); // Gán list video tìm được

                // Giữ trạng thái form tìm kiếm
                req.setAttribute("searchCatId", catId);
                req.setAttribute("searchKeyword", keyword);
                req.setAttribute("isSearching", true);
            } else {
                // Mặc định load tất cả
                List<Video> videos = VideoServices.getAllByUserId(userId);
                req.setAttribute("videos", videos);
            }

            // --- 2. TÍNH TỔNG VIEW & THU NHẬP (QUAN TRỌNG: Đặt ở đây để luôn chạy) ---
            // Gọi Service tính tổng view
            long totalViews = VideoServices.getTotalViewsByUserId(userId);
            // Gửi sang JSP
            req.setAttribute("totalViews", totalViews);

            // --- 3. CÁC DỮ LIỆU PHỤ KHÁC ---
            List<Video> favourites = VideoServices.getFavouritedVideosByUserId(userId);
            req.setAttribute("favourites", favourites);

            Map<String, Long> stats = VideoServices.getUserStats(userId);
            req.setAttribute("stats", stats);

            List<History> historyList = HistoryServices.getHistoryByUser(userId);
            req.setAttribute("historyList", historyList);

        } else {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // --- FLASH MESSAGES ---
        String success = (String) req.getSession().getAttribute("success");
        if (success != null) {
            req.setAttribute("success", success);
            req.getSession().removeAttribute("success");
        }
        String error = (String) req.getSession().getAttribute("error");
        if (error != null) {
            req.setAttribute("error", error);
            req.getSession().removeAttribute("error");
        }

        req.getRequestDispatcher("/editor/editorWorkSpace.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        List<Category> categories = CategoryServices.getAll();
        req.setAttribute("categories", categories);

        Integer userId = resolveUserId(req, resp);
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        EditorPostBean bean = new EditorPostBean();
        bean.setTieuDe(req.getParameter("tieuDe"));
        bean.setNoiDung(req.getParameter("noiDung"));
        bean.setVideoBaiDang(req.getParameter("videoBaiDang"));

        String catStr = req.getParameter("category");
        bean.setCategory(catStr != null && catStr.matches("\\d+") ? Integer.parseInt(catStr) : 0);
        bean.setStatus(1);

        Part anhPart = req.getPart("anhBaiDang");
        bean.setAnhBaiDang(anhPart);

        String anhFileName = null;
        try {
            if (anhPart != null && anhPart.getSize() > 0) {
                anhFileName = saveFile(anhPart, req);
                bean.setAnhFileName(anhFileName);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        bean.validate();
        req.setAttribute("bean", bean);

        if (bean.hasErrors()) {
            // Khi lỗi, cần load lại đầy đủ dữ liệu nền (bao gồm cả totalViews)
            List<Video> videos = VideoServices.getAllByUserId(userId);
            req.setAttribute("videos", videos);
            List<Video> favourites = VideoServices.getFavouritedVideosByUserId(userId);
            req.setAttribute("favourites", favourites);
            List<History> historyList = HistoryServices.getHistoryByUser(userId);
            req.setAttribute("historyList", historyList);

            // --- BỔ SUNG Ở ĐÂY CHO DOPOST ---
            long totalViews = VideoServices.getTotalViewsByUserId(userId);
            req.setAttribute("totalViews", totalViews);
            Map<String, Long> stats = VideoServices.getUserStats(userId);
            req.setAttribute("stats", stats);
            // --------------------------------

            req.getRequestDispatcher("/editor/editorWorkSpace.jsp").forward(req, resp);
            return;
        }

        Video v = new Video();
        v.setTitle(bean.getTieuDe());
        v.setDesc(bean.getNoiDung());
        v.setUrl(bean.getVideoBaiDang());
        if (bean.getAnhFileName() != null) {
            v.setPoster(req.getContextPath() + "/assets/uploads/" + bean.getAnhFileName());
        } else {
            v.setPoster(null);
        }
        v.setViewCount(0);
        v.setStatus(bean.getStatus());
        v.setCreateAt(new java.util.Date()); // Sửa lại dùng util.Date cho khớp Entity mới

        String isPremium = req.getParameter("isPremium");
        v.setPremium("true".equals(isPremium)); // Nếu tích thì là true

        String err = VideoServices.addVideo(v, userId, bean.getCategory());

        if (err != null) {
            req.setAttribute("error", "Lỗi khi lưu: " + err);
             // Load lại dữ liệu nền khi lỗi save DB
            List<Video> videos = VideoServices.getAllByUserId(userId);
            req.setAttribute("videos", videos);
            List<Video> favourites = VideoServices.getFavouritedVideosByUserId(userId);
            req.setAttribute("favourites", favourites);
            List<History> historyList = HistoryServices.getHistoryByUser(userId);
            req.setAttribute("historyList", historyList);

            // --- BỔ SUNG ---
            long totalViews = VideoServices.getTotalViewsByUserId(userId);
            req.setAttribute("totalViews", totalViews);
            Map<String, Long> stats = VideoServices.getUserStats(userId);
            req.setAttribute("stats", stats);

            req.getRequestDispatcher("/editor/editorWorkSpace.jsp").forward(req, resp);
        } else {
            req.getSession().setAttribute("success", "Đăng bài thành công! Bài viết đang chờ Admin duyệt.");
            resp.sendRedirect(req.getContextPath() + "/editor/workspace");
        }
    }
}