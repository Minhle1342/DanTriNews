package Entities;

import java.util.Date;

import jakarta.persistence.*;

@Entity
@Table(name="history")
public class History {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name="user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name="video_id")
    private Video video;

    @Column(name="viewed_at")
    private Date viewedAt;



    public int getId() { return id; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Video getVideo() { return video; }
    public void setVideo(Video video) { this.video = video; }

    public Date getViewedAt() { return viewedAt; }
    public void setViewedAt(Date viewedAt) { this.viewedAt = viewedAt; }
}
