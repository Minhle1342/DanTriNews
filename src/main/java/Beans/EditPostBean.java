package Beans;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Part;

public class EditPostBean {

    private int videoId;
    private String tieuDe;
    private String noiDung;
    private int category;
    private Part anhBaiDang;
    private String anhFileName;
    private String videoBaiDang;
    private int status;

    private Map<String,String> errors = new HashMap<>();

    public void validate() {

        errors.clear();

        if (tieuDe == null || tieuDe.trim().isEmpty()) {
            errors.put("errTieuDe","Tiêu đề không được để trống.");
        }

        if (noiDung == null || noiDung.trim().isEmpty()) {
            errors.put("errNoiDung","Nội dung không được để trống.");
        }

        if (anhBaiDang != null && anhBaiDang.getSize() > 0) {
            String type = anhBaiDang.getContentType();
            if (type == null || !type.startsWith("image/")) {
                errors.put("errAnh","File ảnh phải là định dạng hình ảnh.");
            }
        }

        if (videoBaiDang == null || videoBaiDang.trim().isEmpty()) {
            errors.put("errVideo","Vui lòng nhập URL video.");
        }

        if (category <= 0) {
            errors.put("errCategory","Vui lòng chọn danh mục.");
        }

        if (status != 0 && status != 1) {
            errors.put("errStatus","Trạng thái không hợp lệ.");
        }
    }

    public boolean hasErrors() { return !errors.isEmpty(); }
    public Map<String,String> getErrors() { return errors; }

	public int getVideoId() {
		return videoId;
	}

	public void setVideoId(int videoId) {
		this.videoId = videoId;
	}

	public String getTieuDe() {
		return tieuDe;
	}

	public void setTieuDe(String tieuDe) {
		this.tieuDe = tieuDe;
	}

	public String getNoiDung() {
		return noiDung;
	}

	public void setNoiDung(String noiDung) {
		this.noiDung = noiDung;
	}

	public int getCategory() {
		return category;
	}

	public void setCategory(int category) {
		this.category = category;
	}

	public Part getAnhBaiDang() {
		return anhBaiDang;
	}

	public void setAnhBaiDang(Part anhBaiDang) {
		this.anhBaiDang = anhBaiDang;
	}

	public String getAnhFileName() {
		return anhFileName;
	}

	public void setAnhFileName(String anhFileName) {
		this.anhFileName = anhFileName;
	}

	public String getVideoBaiDang() {
		return videoBaiDang;
	}

	public void setVideoBaiDang(String videoBaiDang) {
		this.videoBaiDang = videoBaiDang;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public void setErrors(Map<String, String> errors) {
		this.errors = errors;
	}

    // getters/setters bên dưới


}
