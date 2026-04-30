package Services;

import java.util.List;

import Entities.AdminAuditLog;
import Entities.RoleUpgradeRequest;
import Entities.User;
import Utils.JpaUtil;
import jakarta.persistence.*;

public class RoleUpgradeRequestService {

	 private static EntityManagerFactory emf =
		        Persistence.createEntityManagerFactory("NewsWebsiteDB");


		    // Lấy entity manager
		    private static EntityManager getEntityManager() {
		        return emf.createEntityManager();
		    }


		    // ============================================================
		    // 1) Lấy toàn bộ yêu cầu role
		    // ============================================================
		    public static List<RoleUpgradeRequest> getAll() {
		        EntityManager em = getEntityManager();
		        try {
		            return em.createQuery(
		                "SELECT DISTINCT r FROM RoleUpgradeRequest r " +
		                "JOIN FETCH r.user u " +
		                "ORDER BY r.createAt DESC",
		                RoleUpgradeRequest.class
		            ).getResultList();
		        } finally {
		            em.close();
		        }
		    }

		    // ============================================================
		    // 2) Lấy theo status (0=pending, 1=approved, 2=rejected)
		    // ============================================================
		    public static List<RoleUpgradeRequest> getByStatus(int status) {
		        EntityManager em = getEntityManager();
		        try {
		            return em.createQuery(
		                "SELECT r FROM RoleUpgradeRequest r " +
		                "JOIN FETCH r.user u " +
		                "WHERE r.status = :status " +
		                "ORDER BY r.createAt DESC",
		                RoleUpgradeRequest.class
		            )
		            .setParameter("status", status)
		            .getResultList();
		        } finally {
		            em.close();
		        }
		    }

    public static void create(RoleUpgradeRequest req) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        em.persist(req);
        em.getTransaction().commit();
        em.close();
    }

    public static RoleUpgradeRequest getByUserId(int uid) {
        EntityManager em = JpaUtil.getEntityManager();
        List<RoleUpgradeRequest> list = em
                .createQuery("SELECT r FROM RoleUpgradeRequest r WHERE r.user.id = :uid", RoleUpgradeRequest.class)
                .setParameter("uid", uid)
                .getResultList();
        em.close();
        return list.isEmpty() ? null : list.get(0);
    }

    public static void update(RoleUpgradeRequest r) {
        EntityManager em = getEntityManager();

        try {
            em.getTransaction().begin();
            em.merge(r);                     // cập nhật entity
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
    public static RoleUpgradeRequest getById(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.createQuery(
                "SELECT r FROM RoleUpgradeRequest r " +
                "JOIN FETCH r.user u " +
                "WHERE r.id = :id",
                RoleUpgradeRequest.class
            )
            .setParameter("id", id)
            .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }

 // 1. Hàm Phê duyệt (Cần thêm tham số adminId)
    public static boolean approveRequest(int requestId, int adminId) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();

            RoleUpgradeRequest req = em.find(RoleUpgradeRequest.class, requestId);

            if (req != null && req.getStatus() == 0) {
                // Update Logic cũ
                req.setStatus(1);
                User user = req.getUser();
                if (user != null) {
                    user.setRole(2);
                    em.merge(user);
                }
                em.merge(req);

                // --- ĐOẠN CODE MỚI: GHI LOG ---
                AdminAuditLog log = new AdminAuditLog();
                log.setAdminId(adminId);
                log.setRelatedRequest(requestId);
                log.setAction("Phê duyệt yêu cầu nâng quyền (ID: " + requestId + ")");
                log.setLogTime(new java.util.Date());

                em.persist(log); // Lưu log vào DB
                // -----------------------------

                em.getTransaction().commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            if (em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
            return false;
        } finally {
            em.close();
        }
    }

    // 2. Hàm Từ chối (Cần thêm tham số adminId)
    public static boolean rejectRequest(int requestId, int adminId) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();

            RoleUpgradeRequest req = em.find(RoleUpgradeRequest.class, requestId);

            if (req != null && req.getStatus() == 0) {
                // Update Logic cũ
                req.setStatus(2);
                em.merge(req);

                // --- ĐOẠN CODE MỚI: GHI LOG ---
                AdminAuditLog log = new AdminAuditLog();
                log.setAdminId(adminId);
                log.setRelatedRequest(requestId);
                log.setAction("Từ chối yêu cầu nâng quyền (ID: " + requestId + ")");
                log.setLogTime(new java.util.Date());

                em.persist(log); // Lưu log vào DB
                // -----------------------------

                em.getTransaction().commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            if (em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
            return false;
        } finally {
            em.close();
        }
    }



}

