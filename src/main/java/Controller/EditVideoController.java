package Controller;

import java.io.File; // Cần thiết cho saveFile
import java.io.IOException;
import java.io.InputStream; // Cần thiết cho việc đọc Part text
import java.nio.file.Files; // Cần thiết cho saveFile
import java.nio.file.Paths; // Cần thiết cho saveFile
import java.nio.file.StandardCopyOption; // Cần thiết cho saveFile
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // Cần thiết
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part; // Cần thiết

import Entities.Category;
import Entities.Video;
import Services.CategoryServices;
import Services.VideoServices;

@WebServlet("/admin/editVideo")
@MultipartConfig(
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class EditVideoController extends HttpServlet {

    // Hàm tiện ích để parse Integer an toàn (Giữ nguyên)
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

    // Hàm tiện ích để lưu File (Cần được copy/định nghĩa tại đây)
    private String saveFile(Part part, HttpServletRequest req) throws IOException {
        if (part == null || part.getSize() == 0) {
			return null;
		}

        String originalName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String fileName = System.currentTimeMillis() + "_" + originalName.replaceAll("\\s+", "_");

        String uploadPath = req.getServletContext().getRealPath("/assets/uploads");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        try (InputStream input = part.getInputStream()) {
            Files.copy(input, Paths.get(uploadPath, fileName), StandardCopyOption.REPLACE_EXISTING);
        }
        return fileName;
    }

    // Hàm tiện ích để đọc Part text (Cần thiết cho Multipart)
    private String getPartValue(Part part) throws IOException {
        if (part == null) {
			return null;
		}
        try (InputStream input = part.getInputStream()) {
            return new String(input.readAllBytes(), "UTF-8");
        }
    }

    // [PHẦN DOGET GIỮ NGUYÊN]
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");

        try {
            int videoId = Integer.parseInt(idStr);

            Video video = VideoServices.getInfoById(videoId);

            if (video == null) {
                req.getSession().setAttribute("error", "Không tìm thấy bài viết cần chỉnh sửa.");
                resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=post");
                return;
            }

            List<Category> categories = CategoryServices.getAll();

            req.setAttribute("videoToEdit", video);
            req.setAttribute("categories", categories);

            req.getRequestDispatcher("/admin/editVideo.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "ID bài viết không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=post");
        }
    }

    // [PHẦN DOPOST ĐÃ SỬA LỖI MULTIPART]
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // Khai báo để dùng trong try/catch
        String title = null;

        try {
            // --- 1. LẤY DỮ LIỆU TỪ PART (Khắc phục lỗi getParameter trong Multipart) ---

            // BẮT BUỘC DÙNG getPart() cho tất cả các trường text
            int id = parseIntSafe(getPartValue(req.getPart("id")));
            title = getPartValue(req.getPart("title"));
            String desc = getPartValue(req.getPart("desc"));
            String url = getPartValue(req.getPart("url"));
            int catId = parseIntSafe(getPartValue(req.getPart("catId")));

            // Checkbox chỉ gửi Part nếu được check
            boolean isPremium = (req.getPart("isPremium") != null && "true".equals(getPartValue(req.getPart("isPremium"))));


            // 2. Tải Entity gốc từ DB (Cần thiết để giữ lại các thông tin views, user, poster cũ)
            Video v = VideoServices.getInfoById(id);
            if (v == null) {
                req.getSession().setAttribute("error", "Không tìm thấy video ID " + id + " để cập nhật.");
                resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=post");
                return;
            }

            // 3. XỬ LÝ UPLOAD POSTER MỚI
            Part filePart = req.getPart("poster");
            String newFileName = null;
            if (filePart != null && filePart.getSize() > 0) {
                 newFileName = saveFile(filePart, req);
            }

            // 4. Cập nhật các trường dữ liệu
            v.setTitle(title);
            v.setDesc(desc);
            v.setUrl(url);
            v.setPremium(isPremium);

            if (newFileName != null) {
                // Nếu có file mới, cập nhật đường dẫn
                v.setPoster(req.getContextPath() + "/assets/uploads/" + newFileName);
            }
            // Nếu newFileName là null, trường poster cũ sẽ được giữ lại


            // 5. Gọi Service cập nhật (Service phải dùng phương pháp Managed Entity đã sửa)
            String result = VideoServices.updateVideo(v, catId);


            if (result == null) {
                req.getSession().setAttribute("success", "Cập nhật bài viết '" + title + "' thành công!");
            } else {
                req.getSession().setAttribute("error", result);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi xử lý hệ thống hoặc dữ liệu: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/admin/adminPanel?tab=post");
    }
}