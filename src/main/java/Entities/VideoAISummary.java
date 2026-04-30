package Entities;

import jakarta.persistence.*;
import lombok.Data;

//Entity cho Tóm tắt AI
@Data
@Entity
@Table(name = "video_ai_summary")
public class VideoAISummary {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @OneToOne
    @JoinColumn(name = "video_id")
    private Video video;

    @Column(name = "summary_text", columnDefinition = "NVARCHAR(MAX)")
    private String summaryText;

    @Column(name = "is_premium")
    private boolean isPremium;

}