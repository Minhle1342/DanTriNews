package Services;

import java.util.ArrayList;
import java.util.List;

import Entities.SystemConfig;
import Entities.User;
import Utils.JpaUtil;
import jakarta.persistence.*;

public class RevenueService {

    // 1. Lấy đơn giá từ DB (Không hardcode nữa)
    public static int getViewRate() {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            SystemConfig config = em.find(SystemConfig.class, "view_rate");
            if (config != null) {
                return Integer.parseInt(config.getConfigValue());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return 20; // Giá mặc định nếu DB chưa có
    }

    // 2. Cập nhật đơn giá mới
    public static void updateViewRate(int newRate) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            SystemConfig config = em.find(SystemConfig.class, "view_rate");
            if (config == null) {
                config = new SystemConfig("view_rate", String.valueOf(newRate));
                em.persist(config);
            } else {
                config.setConfigValue(String.valueOf(newRate));
                em.merge(config);
            }
            trans.commit();
        } catch (Exception e) {
            trans.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    // 3. Tính tổng doanh thu VNPay (Giả định bảng Transaction)
    public static long getTotalRevenue() {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            // SỬA LỖI TẠI ĐÂY:
            // 1. Đổi '00' thành 1 (Vì quy ước trong Controller: 1 là Thành công)
            // 2. Status là số nguyên, không cần dấu nháy đơn
            String jpql = "SELECT SUM(t.amount) FROM Transaction t WHERE t.status = 1";

            Query q = em.createQuery(jpql);
            Long sum = (Long) q.getSingleResult();

            return sum != null ? sum : 0;

        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra để debug nếu có
            return 0;
        } finally {
            em.close();
        }
    }



    public static List<Object[]> getEditorRevenueStats() {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            // --- CÁCH SỬA TRIỆT ĐỂ: DÙNG SUBQUERY ---
            // Logic: Chọn User, và cột thứ 2 là (Tổng view của user đó tính từ bảng Video)
            // Cách này không cần JOIN phức tạp, không lo lỗi Group By
            String jpql = "SELECT u, " +
                          "(SELECT COALESCE(SUM(v.viewCount), 0) FROM Video v WHERE v.user.id = u.id) " +
                          "FROM User u " +
                          "WHERE u.role = :roleId"; // Dùng tham số cho an toàn

            // Truyền tham số role = 2 (Editor)
            List<Object[]> results = em.createQuery(jpql)
                                       .setParameter("roleId", 2)
                                       .getResultList();

            // --- DEBUG LOG (Xem trong Console Eclipse) ---
            System.out.println("DEBUG REVENUE: Tìm thấy " + results.size() + " editors.");
            if (results.isEmpty()) {
                 System.out.println("-> Lỗi: Không tìm thấy user nào có role = 2.");
                 System.out.println("-> Hãy kiểm tra lại cột 'role' trong bảng 'Users' xem có phải số 2 không?");
            }
            // ---------------------------------------------

            int rate = getViewRate();
            List<Object[]> stats = new ArrayList<>();

            for (Object[] row : results) {
                User u = (User) row[0];

                // Hibernate trả về Long cho SUM, cẩn thận null
                Long views = (Long) row[1];
                if (views == null) {
					views = 0L;
				}

                long earnings = views * rate;

                // In ra từng người để kiểm tra
                System.out.println("Editor: " + u.getName() + " - Views: " + views + " - Tiền: " + earnings);

                stats.add(new Object[]{u, views, earnings});
            }
            return stats;

        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }
}