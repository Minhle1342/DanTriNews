package Entities;

import java.util.Date; // ✅ SỬA: Dùng java.util.Date để giữ cả giờ phút
import java.util.List;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table(name = "videos")
public class Video {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id") // Tên cột ID trong DB
    private int id;

    @Column(name = "title", nullable = false, columnDefinition = "NVARCHAR(MAX)")
    private String title;

    @Column(name = "description", nullable = false, columnDefinition = "NVARCHAR(MAX)") // Sửa thành MAX cho thoải mái nếu bài viết dài
    private String desc;

    @Column(name = "url", nullable = false, length = 500) // Tăng độ dài đề phòng link dài
    private String url;

    @Column(name = "poster", nullable = true, length = 500) // Poster có thể null nếu chưa có ảnh
    private String poster;

    @Column(name = "view_count", nullable = false)
    private int viewCount = 0; // ✅ Thêm giá trị mặc định để tránh null

    // ✅ SỬA QUAN TRỌNG: Lưu đầy đủ ngày giờ
    @Column(name = "create_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date createAt;

    @Column(name = "status", nullable = false)
    private int status;

 // Sửa thành:
    @Column(name = "duration")
    private Integer duration = 0; // Thêm giá trị mặc định

    // --- Cập nhật Getter và Setter ---

    public Integer getDuration() {
        // Trả về 0 nếu null để tránh lỗi tính toán ở View
        return duration == null ? 0 : duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

 // Thêm vào trong class Video.java
    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<VideoProduct> videoProducts;

    public List<VideoProduct> getVideoProducts() {
        return videoProducts;
    }

    public void setVideoProducts(List<VideoProduct> videoProducts) {
        this.videoProducts = videoProducts;
    }

    @Transient
    private long commentCount;

    @Transient
    private long favouriteCount;

    // Quan hệ với User (Người đăng)
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id")
    private User user;

    // Quan hệ với Category
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "cat_id")
    private Category category;

    @Column(name = "is_premium")
    private boolean premium = false; // Mặc định là false

 // --- THÊM ĐOẠN NÀY ---
    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<History> histories;

    // Khi xóa Video thì xóa luôn Comment
    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Comment> comments;

    // Khi xóa Video thì xóa luôn Favourite
    @OneToMany(mappedBy = "video", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Favourite> favourites;

 // Trong class Video hiện tại của bạn, thêm:
    @OneToOne(mappedBy = "video", fetch = FetchType.LAZY)
    private VideoAISummary aiSummary;

    @OneToMany(mappedBy = "video", fetch = FetchType.LAZY)
    @OrderBy("startTime ASC") // Tự động sắp xếp chapter theo thời gian
    private List<VideoChapter> chapters;

    // --- Logic Embed URL (Đã bổ sung xử lý link Shorts) ---
    public String getEmbedUrl() {
        if (url == null) {
			return null;
		}
        try {
            String link = url.trim();
            String videoId = null;

            // Case 1: youtube.com/watch?v=xxxxx
            if (link.contains("youtube.com/watch?v=")) {
                videoId = link.substring(link.indexOf("v=") + 2);
                int ampersandIndex = videoId.indexOf("&");
                if (ampersandIndex != -1) {
                    videoId = videoId.substring(0, ampersandIndex);
                }
            }
            // Case 2: youtu.be/xxxxx
            else if (link.contains("youtu.be/")) {
                videoId = link.substring(link.lastIndexOf("/") + 1);
                int questionMark = videoId.indexOf("?"); // Loại bỏ query param nếu có
                if(questionMark != -1) {
					videoId = videoId.substring(0, questionMark);
				}
            }
            // Case 3: youtube.com/shorts/xxxxx (Bổ sung thêm)
            else if (link.contains("youtube.com/shorts/")) {
                videoId = link.substring(link.indexOf("shorts/") + 7);
                int questionMark = videoId.indexOf("?");
                if(questionMark != -1) {
					videoId = videoId.substring(0, questionMark);
				}
            }

            if (videoId != null) {
                return "https://www.youtube.com/embed/" + videoId;
            }
        } catch (Exception e) {
            return null;
        }
        return null; // Không phải link youtube
    }
}