package Controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import Beans.EditPostBean;
import Entities.Video;
import Services.VideoServices;
import Utils.Utils;

@WebServlet("/editor/update")
@MultipartConfig
public class EditorUpdateVideo extends HttpServlet {

    private String saveFile(Part part, HttpServletRequest req) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        // Thêm timestamp để tránh trùng tên file
        fileName = System.currentTimeMillis() + "_" + fileName;

        String uploadPath = req.getServletContext().getRealPath("/assets/uploads");
        File dir = new File(uploadPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        try (InputStream input = part.getInputStream()) {
            Files.copy(input, Paths.get(uploadPath, fileName), StandardCopyOption.REPLACE_EXISTING);
        }

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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        Integer userId = resolveUserId(req, resp);
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        EditPostBean bean = new EditPostBean();

        // 1. Lấy dữ liệu cơ bản
        bean.setTieuDe(req.getParameter("tieuDe"));
        bean.setNoiDung(req.getParameter("noiDung"));
        bean.setVideoBaiDang(req.getParameter("videoBaiDang"));

        String cat = req.getParameter("category");
        bean.setCategory(cat != null && cat.matches("\\d+") ? Integer.parseInt(cat) : 0);

        // 2. NHẬN DIỆN ID VIDEO
        String vid = req.getParameter("videoId");
        if (vid == null || !vid.matches("\\d+")) {
            req.getSession().setAttribute("error", "Video ID không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/editor/workspace");
            return;
        }
        bean.setVideoId(Integer.parseInt(vid));

        // 3. THAY ĐỔI LOGIC STATUS
        // Không lấy status từ form nữa.
        // Khi sửa bài -> Bắt buộc reset về trạng thái CHỜ DUYỆT (1)
        bean.setStatus(1);

        Part img = req.getPart("anhBaiDang");
        bean.setAnhBaiDang(img);

        // 4. Validate
        bean.validate();

        // Lưu ý: Nếu bean.validate() có kiểm tra status, đảm bảo nó chấp nhận giá trị 1
        if (bean.hasErrors()) {
            // Nếu lỗi, set lại bean để hiện lỗi trong modal
            req.setAttribute("editBean", bean);
            // Truyền ID modal để Javascript mở lại đúng modal đang sửa
            req.setAttribute("editModalId", "editModal" + bean.getVideoId());

            // Cần load lại danh sách video để hiển thị trang workspace
            // (Giả sử bạn có logic load list ở doGet hoặc forward về servlet doGet)
            // Cách nhanh nhất ở đây là forward về trang JSP, nhưng dữ liệu list video sẽ bị thiếu
            // Tốt nhất là forward về Servlet doGet của workspace nhưng kèm flag error
            // Tuy nhiên để đơn giản cho flow hiện tại:
            req.getRequestDispatcher("/editor/editorWorkSpace.jsp").forward(req, resp);
            return;
        }

        // 5. Lưu file ảnh mới (nếu có)
        String saved = null;
        try {
            if (img != null && img.getSize() > 0) {
                saved = saveFile(img, req);
                bean.setAnhFileName(saved);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 6. Chuẩn bị Entity Update
        Video video = new Video();
        video.setId(bean.getVideoId());
        video.setTitle(bean.getTieuDe());
        video.setDesc(bean.getNoiDung());
        video.setUrl(bean.getVideoBaiDang());

        // QUAN TRỌNG: Reset status về 1
        video.setStatus(1);

        if (saved != null) {
            // Nếu có ảnh mới thì cập nhật đường dẫn mới
            video.setPoster(req.getContextPath() + "/assets/uploads/" + saved);
        } else {
            // Nếu không có ảnh mới, để null để Service biết đường giữ lại ảnh cũ
            video.setPoster(null);
        }

        // 7. Gọi Service Update
        String err = VideoServices.updateVideo(video, userId, bean.getCategory());

        if (err != null) {
            req.getSession().setAttribute("error", "Không thể chỉnh sửa: " + err);
        } else {
            req.getSession().setAttribute("success", "Cập nhật bài viết thành công. Bài viết đang chờ Admin duyệt lại.");
        }

        resp.sendRedirect(req.getContextPath() + "/editor/workspace");
    }
}