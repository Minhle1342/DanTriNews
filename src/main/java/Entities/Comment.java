package Entities;

import java.sql.Date;
import java.util.ArrayList; // Thêm
import java.util.List;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table(name = "comments")
public class Comment {
    @Id
    @Column(name = "id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "content", nullable = false, columnDefinition = "NVARCHAR(255)")
    private String content;

    @Column(name = "image", nullable = true, length = 255)
    private String image;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "video_id")
    private Video video;

    @Column(name = "create_at", nullable = false)
    private Date createAt;

    @Column(name = "status", nullable = false)
    private int status;

    // --- QUAN HỆ TRẢ LỜI BÌNH LUẬN --- //

 // QUAN TRỌNG: Thêm @ToString.Exclude
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "parent_id")
    @ToString.Exclude
    private Comment parentComment;

    // QUAN TRỌNG: Thêm @ToString.Exclude
    @OneToMany(mappedBy = "parentComment", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @ToString.Exclude
    private List<Comment> replies = new ArrayList<>();

    @OneToMany(mappedBy = "comment", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @ToString.Exclude
    private List<CommentLike> likes;

    // Hàm tiện ích để kiểm tra user đã like chưa (Dùng trong JSP)
    public boolean isLikedByUser(int userId) {
        if (likes == null) {
			return false;
		}
        for (CommentLike cl : likes) {
            if (cl.getUser().getId() == userId) {
                return true;
            }
        }
        return false;
    }
}