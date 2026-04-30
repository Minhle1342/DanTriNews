package Entities;

import java.util.Date;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "video_watch_history")
public class VideoWatchHistory {

    @EmbeddedId
    private VideoWatchHistoryId id;

    @ManyToOne
    @MapsId("userId") // Map với field userId trong VideoWatchHistoryId
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @MapsId("videoId") // Map với field videoId trong VideoWatchHistoryId
    @JoinColumn(name = "video_id")
    private Video video;

    @Column(name = "watch_time", nullable = false)
    private int watchTime;

    @Column(name = "is_completed", nullable = false)
    private boolean isCompleted;

    @Column(name = "last_watch_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date lastWatchAt;
}