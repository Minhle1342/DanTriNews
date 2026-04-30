package Services;


import Entities.Payout;
import Entities.User;
import Utils.JpaUtil;
import jakarta.persistence.*;
public class PayoutService {
    public static boolean savePayout(int adminId, int editorId, long amount, String bank, String acc) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();

            User admin = em.find(User.class, adminId);
            User editor = em.find(User.class, editorId);

            Payout p = new Payout();
            p.setAdmin(admin);
            p.setEditor(editor);
            p.setAmount(amount);
            p.setBankName(bank);
            p.setBankAccount(acc);
            p.setPayDate(new java.util.Date());
            p.setNote("Thanh toán lương Editor");

            em.persist(p);
            em.getTransaction().commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if(em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
            return false;
        } finally {
            em.close();
        }
    }
}