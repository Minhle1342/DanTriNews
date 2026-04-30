package Services;


import Entities.Transaction;
import Entities.User;
import Utils.JpaUtil;
import jakarta.persistence.*;

public class TransactionServices {

	public static boolean saveTransaction(Transaction trans, int userId) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        EntityTransaction et = em.getTransaction();

        try {
            et.begin();

            // 1. Tìm User tươi từ DB để đảm bảo Hibernate quản lý nó
            User managedUser = em.find(User.class, userId);

            if (managedUser == null) {
                System.out.println("❌ LỖI: Không tìm thấy User ID = " + userId);
                return false;
            }

            // 2. Gán User vào Transaction
            trans.setUser(managedUser);

            // 3. Lưu Transaction
            em.persist(trans);

            et.commit();
            System.out.println("✅ Đã lưu Transaction thành công! ID: " + trans.getId());
            return true;

        } catch (Exception e) {
            System.out.println("❌ LỖI KHI LƯU TRANSACTION:");
            e.printStackTrace();
            if (et.isActive()) {
                et.rollback();
            }
            return false;
        } finally {
            em.close();
        }
    }
}