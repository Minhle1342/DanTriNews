package Services;

import java.util.Date;
import java.util.List;

import Entities.History;
import Entities.User;
import Entities.Video;
import Entities.VideoWatchHistory;
import Entities.VideoWatchHistoryId;
import Utils.JpaUtil;
import jakarta.persistence.*;

public class HistoryServices {

    static EntityManagerFactory factory = Persistence.createEntityManagerFactory("NewsWebsiteDB");

    // Lưu lịch sử khi xem
    public static void saveHistory(int userId, int videoId) {
        EntityManager em = factory.createEntityManager();

        try {
            em.getTransaction().begin();

            // Kiểm tra có xem rồi chưa
            List<History> list = em.createQuery(
                    "SELECT h FROM History h WHERE h.user.id = :uid AND h.video.id = :vid",
                    History.class)
                    .setParameter("uid", userId)
                    .setParameter("vid", videoId)
                    .getResultList();

            if (list.isEmpty()) {
                History h = new History();
                h.setUser(em.find(User.class, userId));
                h.setVideo(em.find(Video.class, videoId));
                h.setViewedAt(new java.util.Date());

                em.persist(h);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            em.getTransaction().rollback();
        } finally {
            em.close();
        }
    }

    // Lấy danh sách tin đã xem
    public static List<History> getHistoryByUser(int userId) {
        EntityManager em = factory.createEntityManager();

        try {
            return em.createQuery(
                    "SELECT h FROM History h WHERE h.user.id = :uid ORDER BY h.viewedAt DESC",
                    History.class)
                    .setParameter("uid", userId)
                    .getResultList();

        } finally {
            em.close();
        }
    }

    public static void saveProgress(int userId, int videoId, int currentTime, boolean isCompleted) {
        EntityManager em = JpaUtil.getEntityManager();
        System.out.println("DEBUG SERVICE: Bắt đầu saveProgress cho User " + userId + " - Video " + videoId);

        try {
            em.getTransaction().begin();

            VideoWatchHistoryId id = new VideoWatchHistoryId(userId, videoId);
            VideoWatchHistory history = em.find(VideoWatchHistory.class, id);

            if (history == null) {
                System.out.println("DEBUG SERVICE: Chưa có lịch sử -> Tạo mới entity");
                history = new VideoWatchHistory();
                history.setId(id);
                // Dùng find thay vì getReference để chắc chắn ID tồn tại, tránh lỗi Lazy
                User u = em.find(User.class, userId);
                Video v = em.find(Video.class, videoId);

                if (u == null || v == null) {
                     System.out.println("DEBUG SERVICE: LỖI -> Không tìm thấy User hoặc Video trong DB");
                     return;
                }
                history.setUser(u);
                history.setVideo(v);
            } else {
                System.out.println("DEBUG SERVICE: Đã có lịch sử -> Cập nhật watchTime cũ: " + history.getWatchTime());
            }

            history.setWatchTime(currentTime);
            history.setCompleted(isCompleted);
            history.setLastWatchAt(new Date());

            em.merge(history);
            em.getTransaction().commit();
            System.out.println("DEBUG SERVICE: ✅ Commit thành công! WatchTime mới: " + currentTime);

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
            System.out.println("DEBUG SERVICE: ❌ Lỗi transaction -> " + e.getMessage());
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public static List<VideoWatchHistory> getContinueWatching(int userId) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            // JPQL: Chọn lịch sử của User này,
            // Lọc: Chưa hoàn thành (isCompleted = false)
            // Sắp xếp: Mới xem nhất lên đầu
            String jpql = "SELECT h FROM VideoWatchHistory h " +
                          "WHERE h.user.id = :uid " +
                          "AND h.isCompleted = false " +
                          "ORDER BY h.lastWatchAt DESC";

            TypedQuery<VideoWatchHistory> query = em.createQuery(jpql, VideoWatchHistory.class);
            query.setParameter("uid", userId);
            query.setMaxResults(8); // Chỉ lấy tối đa 8 video để hiển thị trang chủ cho gọn

            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

}
