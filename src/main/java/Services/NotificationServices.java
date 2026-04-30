package Services;

import java.util.List;

import Entities.Notification;
import Entities.User;
import Entities.Video;
import Utils.JpaUtil;
import jakarta.persistence.*;
public class NotificationServices {
	public static void addNotification(User receiver, User trigger, Video video, String content, int type) {
        // 1. Không thông báo nếu tự sướng (tự like/reply mình)
        if (receiver.getId() == trigger.getId()) {
			return;
		}

        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();

            // 2. [QUAN TRỌNG] Load lại User và Video trong session này để tránh lỗi "Detached Entity"
            User managedReceiver = em.find(User.class, receiver.getId());
            User managedTrigger = em.find(User.class, trigger.getId());
            Video managedVideo = em.find(Video.class, video.getId());

            // Nếu dữ liệu bị xóa giữa chừng thì bỏ qua
            if (managedReceiver == null || managedTrigger == null || managedVideo == null) {
                return;
            }

            Notification n = new Notification();
            n.setUser(managedReceiver);
            n.setTriggerUser(managedTrigger);
            n.setVideo(managedVideo);
            n.setContent(content);
            n.setType(type);
            n.setRead(false);
            n.setCreateAt(new java.util.Date());

            em.persist(n);
            em.getTransaction().commit();
            System.out.println(">>> Đã lưu thông báo thành công cho User ID: " + receiver.getId());

        } catch (Exception e) {
            e.printStackTrace(); // Xem log console nếu vẫn lỗi
            if(em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
        } finally {
            em.close();
        }
    }

	// Trong Services/NotificationServices.java

    // Tìm thông báo theo ID
    public static Notification findById(int id) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.find(Notification.class, id);
        } finally {
            em.close();
        }
    }

    // Đánh dấu đã đọc
    public static void markAsRead(int id) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();
            Notification n = em.find(Notification.class, id);
            if (n != null) {
                n.setRead(true); // Sửa thành true
                em.merge(n);     // Cập nhật vào DB
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
        } finally {
            em.close();
        }
    }

	public static List<Notification> getTopNotifications(int userId) {
	    EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
	    try {
	        return em.createQuery("SELECT n FROM Notification n WHERE n.user.id = :uid ORDER BY n.createAt DESC", Notification.class)
	                 .setParameter("uid", userId)
	                 .setMaxResults(10) // Lấy 10 thông báo mới nhất
	                 .getResultList();
	    } finally { em.close(); }
	}
}
