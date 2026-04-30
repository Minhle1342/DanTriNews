package Entities;

import java.io.Serializable;
import java.util.Objects;

import jakarta.persistence.*;
@Embeddable
public class VideoWatchHistoryId implements Serializable {
    private static final long serialVersionUID = 1L;

    private int userId;
    private int videoId;

    public VideoWatchHistoryId() {}

    public VideoWatchHistoryId(int userId, int videoId) {
        this.userId = userId;
        this.videoId = videoId;
    }

    // Getter & Setter
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getVideoId() { return videoId; }
    public void setVideoId(int videoId) { this.videoId = videoId; }

    // Bắt buộc phải có hashCode và equals cho Composite Key
    @Override
    public boolean equals(Object o) {
        if (this == o) {
			return true;
		}
        if (o == null || getClass() != o.getClass()) {
			return false;
		}
        VideoWatchHistoryId that = (VideoWatchHistoryId) o;
        return userId == that.userId && videoId == that.videoId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, videoId);
    }
}