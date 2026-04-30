package Entities;

import java.io.Serializable;
import java.util.Date;

import jakarta.persistence.*;

@Entity
@Table(name = "AdBanners")
public class AdBanner implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "title", length = 100, nullable = false)
    private String title;

    @Column(name = "imageUrl", length = 255, nullable = false)
    private String imageUrl;

    @Column(name = "targetUrl", length = 255, nullable = false)
    private String targetUrl;

    // Vị trí hiển thị: SIDEBAR_TOP, IN_CONTENT_1, SIDEBAR_BOTTOM
    @Column(name = "position", length = 50, nullable = false)
    private String position;

    // Đối tượng thấy banner: FREE, VIP, ALL
    @Column(name = "targetAudience", length = 10, nullable = false)
    private String targetAudience;

    @Column(name = "isActive", nullable = false)
    private Boolean isActive = true;

    @Column(name = "viewsCount")
    private Integer viewsCount = 0;

    @Column(name = "clicksCount")
    private Integer clicksCount = 0;

    @Temporal(TemporalType.DATE)
    @Column(name = "startDate")
    private Date startDate;

    @Temporal(TemporalType.DATE)
    @Column(name = "endDate")
    private Date endDate;

    // --- Constructors ---

    public AdBanner() {}

    // Constructor tiện ích cho việc tạo mới
    public AdBanner(String title, String imageUrl, String targetUrl, String position, String targetAudience, Date startDate, Date endDate) {
        this.title = title;
        this.imageUrl = imageUrl;
        this.targetUrl = targetUrl;
        this.position = position;
        this.targetAudience = targetAudience;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = true;
        this.viewsCount = 0;
        this.clicksCount = 0;
    }

    // --- Getters and Setters ---

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getTargetUrl() {
        return targetUrl;
    }

    public void setTargetUrl(String targetUrl) {
        this.targetUrl = targetUrl;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getTargetAudience() {
        return targetAudience;
    }

    public void setTargetAudience(String targetAudience) {
        this.targetAudience = targetAudience;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Integer getViewsCount() {
        return viewsCount;
    }

    public void setViewsCount(Integer viewsCount) {
        this.viewsCount = viewsCount;
    }

    public Integer getClicksCount() {
        return clicksCount;
    }

    public void setClicksCount(Integer clicksCount) {
        this.clicksCount = clicksCount;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    @Override
    public String toString() {
        return "AdBanner{" + "id=" + id + ", title=" + title + ", position=" + position + ", targetAudience=" + targetAudience + ", isActive=" + isActive + '}';
    }
}