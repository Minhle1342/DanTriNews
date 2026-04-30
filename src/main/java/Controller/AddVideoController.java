package Controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import Entities.User;
import Entities.Video;
import Services.VideoServices;

@WebServlet("/admin/addVideo")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AddVideoController extends HttpServlet {

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

    // Hàm saveFile tách riêng giống EditorWorkSpace để code gọn hơn
    private String saveFile(Part part, HttpServletRequest req) throws IOException {
        if (part == null || part.getSize() == 0) {
			return null;
		}

        String originalName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        // Thêm timestamp để tránh trùng tên
        String fileName = System.currentTimeMillis() + "_" + originalName.replaceAll("\\s+", "_");

        String uploadPath = req.getServletContext().getRealPath("/assets/uploads");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        part.write(uploadPath + File.separator + fileName);
        return fileName;
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        try {
            // 1. Lấy dữ liệu Text
            String title = req.getParameter("title");
            String desc = req.getParameter("desc");
            String url = req.getParameter("url");
            int catId = parseIntSafe(req.getParameter("catId"));

            // ✅ BƯỚC CẬP NHẬT: Lấy giá trị Premium
            String isPremiumParam = req.getParameter("isPremium");
            // Checkbox chỉ trả về giá trị (true) nếu được check. Nếu không check, nó là null.
            boolean isPremium = "true".equals(isPremiumParam);

            // 2. Lấy User từ Session
            User currentUser = (User) req.getSession().getAttribute("user");
            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            int userId = currentUser.getId();

            // 3. Xử lý Upload Ảnh (SỬA LẠI THEO LOGIC CỦA EditorWorkSpace)
            Part filePart = req.getPart("poster");
            String fileName = null;

            try {
                if (filePart != null && filePart.getSize() > 0) {
                    fileName = saveFile(filePart, req);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (fileName == null) {
                req.getSession().setAttribute("error", "Vui lòng chọn ảnh thumbnail.");
                resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");
                return;
            }

            // 4. Lưu vào Entity Video
            Video v = new Video();
            v.setTitle(title);
            v.setDesc(desc);
            v.setUrl(url);

            // Lưu đường dẫn tuyệt đối từ root context (giống EditorWorkSpace)
            v.setPoster(req.getContextPath() + "/assets/uploads/" + fileName);

            v.setCreateAt(new Date(System.currentTimeMillis()));
            v.setStatus(2); // Auto duyệt vì là Admin
            v.setViewCount(0);

            // ✅ BƯỚC CẬP NHẬT: Gán giá trị Premium
            v.setPremium(isPremium);

            // 5. Gọi Service
            String result = VideoServices.addVideo(v, userId, catId);

            if (result == null) {
                req.getSession().setAttribute("success", "Thêm bài đăng thành công!");
            } else {
                req.getSession().setAttribute("error", result);
            }

            resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/adminPanel");
        }
    }
}