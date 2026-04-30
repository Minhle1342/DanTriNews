package Beans;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Part;


public class EditorPostBean {
	private int videoId; // thêm
    private String tieuDe;
    private String noiDung;
    private int category;
    private Part anhBaiDang;
    private String anhFileName;
    private String videoBaiDang;
    private int status;



    private Map<String, String> errors = new HashMap<>();


    public void validate() {
        errors.clear();

        // tiêu đề
        if (tieuDe == null || tieuDe.trim().isEmpty()) {
            errors.put("errTieuDe", "Tiêu đề không được để trống.");
        }

        // nội dung
        if (noiDung == null || noiDung.trim().isEmpty()) {
            errors.put("errNoiDung", "Nội dung không được để trống.");
        }


            if (anhBaiDang == null || anhBaiDang.getSize() == 0) {
                errors.put("errAnh", "Ảnh bài đăng không được để trống.");
            } else {
                String type = anhBaiDang.getContentType();
                if (type == null || !type.startsWith("image/")) {
                    errors.put("errAnh", "File ảnh phải là định dạng hình ảnh.");
                }
            }

//         // Thêm đoạn check này vào EditPostBean.java
//            if (videoBaiDang == null || videoBaiDang.trim().isEmpty()) {
//                errors.put("errVideo", "Vui lòng nhập URL video.");
//            } else if (!videoBaiDang.contains("youtube.com") && !videoBaiDang.contains("youtu.be")) {
//                // Validate định dạng
//                errors.put("errVideo", "Đường dẫn video phải là link YouTube hợp lệ.");
//            }


        // video
        if (videoBaiDang == null || videoBaiDang.trim().isEmpty()) {
            errors.put("errVideo", "Vui lòng nhập URL video.");
        } else {
            String link = videoBaiDang.trim();
            if (!link.startsWith("http://") && !link.startsWith("https://")) {
                errors.put("errVideo", "URL video không hợp lệ (phải bắt đầu bằng http hoặc https).");
            }
        }

        // category
        if (category <= 0) {
            errors.put("errCategory", "Vui lòng chọn danh mục.");
        }

        // status
        if (status != 0 && status != 1) {
            errors.put("errStatus", "Trạng thái không hợp lệ.");
        }
    }



    public boolean hasErrors() { return !errors.isEmpty(); }

    public int getVideoId() { return videoId; }
    public void setVideoId(int videoId) { this.videoId = videoId; }

    // getters & setters
    public String getAnhFileName() { return anhFileName; }
    public void setAnhFileName(String anhFileName) { this.anhFileName = anhFileName; }

    public String getTieuDe() { return tieuDe; }
    public void setTieuDe(String tieuDe) { this.tieuDe = tieuDe; }

    public String getNoiDung() { return noiDung; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }

    public Part getAnhBaiDang() { return anhBaiDang; }
    public void setAnhBaiDang(Part anhBaiDang) { this.anhBaiDang = anhBaiDang; }

    public String getVideoBaiDang() { return videoBaiDang; }
    public void setVideoBaiDang(String videoBaiDang) { this.videoBaiDang = videoBaiDang; }

    public Map<String, String> getErrors() { return errors; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public int getCategory() { return category; }
    public void setCategory(int category) { this.category = category; }
}
