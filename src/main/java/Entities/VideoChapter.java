package Entities;


import jakarta.persistence.*;
import lombok.Data;


@Data

@Entity
@Table(name = "video_chapters")
public class VideoChapter {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "video_id")
    private Video video;

    @Column(name = "title")
    private String title;

    @Column(name = "start_time")
    private int startTime; // Seconds

    @Column(name = "is_premium")
    private boolean isPremium;


}



