package Entities;

import java.util.Date;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table(name = "notifications")
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user; // Người nhận

    @ManyToOne
    @JoinColumn(name = "trigger_user_id")
    private User triggerUser; // Người tương tác

    @ManyToOne
    @JoinColumn(name = "video_id")
    private Video video;

    @Column(columnDefinition = "NVARCHAR(255)")
    private String content;

    private int type; // 1: Reply, 2: Like

    @Column(name = "is_read")
    private boolean isRead;

    @Column(name = "create_at")
    private Date createAt;
}