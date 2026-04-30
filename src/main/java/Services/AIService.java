package Services;

import java.util.List;

import Entities.User;
import Entities.VideoAISummary;
import Entities.VideoChapter;
import jakarta.persistence.*;

public class AIService {

    // Factory cho EntityManager (Giả sử bạn đã có class Utils quản lý)
    private EntityManagerFactory emf = Persistence.createEntityManagerFactory("NewsWebsiteDB");

    public VideoAISummary getSummaryForUser(int videoId, User user) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT s FROM VideoAISummary s WHERE s.video.id = :vid";
            VideoAISummary summary = em.createQuery(jpql, VideoAISummary.class)
                                       .setParameter("vid", videoId)
                                       .getSingleResult();

            // Logic che giấu nội dung nếu không phải VIP
            if (summary != null && summary.isPremium()) {
                boolean isVip = (user != null && user.isVip());
                if (!isVip) {
                    // Trả về bản tóm tắt bị che mờ hoặc rút gọn
                    summary.setSummaryText("<ul><li>Nội dung này dành cho VIP...</li><li>Vui lòng nâng cấp để xem chi tiết.</li></ul>");
                }
            }
            return summary;
        } catch (NoResultException e) {
            return null;
        } finally {
            em.close();
        }
    }

    public List<VideoChapter> getChaptersForVideo(int videoId) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT c FROM VideoChapter c WHERE c.video.id = :vid ORDER BY c.startTime ASC", VideoChapter.class)
                     .setParameter("vid", videoId)
                     .getResultList();
        } finally {
            em.close();
        }
    }
}