package Services;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import Entities.AdBanner;
import Utils.JpaUtil;
import jakarta.persistence.*;

public class AdBannerService {
	// Trong AdBannerService.java
	public static List<AdBanner> getBanners(boolean isUserVip, String position) {
	    EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
	    try {
	        // 1. Dùng JPQL chuẩn và sử dụng java.util.Date (new Date())
	        // SỬA: Thay thế CURRENT_DATE bằng :currentDate
	        String jpql = "SELECT a FROM AdBanner a WHERE a.isActive = true AND a.position = :pos "
	                    + "AND (a.endDate IS NULL OR a.endDate >= :currentDate) ";

	        // --- LOGIC PHÂN LOẠI TÀI KHOẢN ---
	        if (isUserVip) {
	            jpql += "AND (a.targetAudience = 'VIP' OR a.targetAudience = 'ALL')";
	        } else {
	            jpql += "AND (a.targetAudience = 'FREE' OR a.targetAudience = 'ALL')";
	        }

	        // Thêm sắp xếp ngẫu nhiên để quảng cáo không bị lặp
	        // SỬA: Dùng TypedQuery để an toàn hơn
	        TypedQuery<AdBanner> q = em.createQuery(jpql, AdBanner.class);

	        // Thiết lập tham số
	        q.setParameter("pos", position);
	        // QUAN TRỌNG: Thiết lập tham số ngày tháng
	        q.setParameter("currentDate", new Date(), TemporalType.DATE);

	        q.setMaxResults(1);

	        return q.getResultList();
	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ArrayList<>();
	    } finally {
	        em.close();
	    }
	}
	// Hàm 1: Lấy tất cả Banner
	// Trong AdBannerService.java
	public static List<AdBanner> getAllBanners() {
	    EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
	    try {
	        // Cú pháp JPQL: SỬ DỤNG TÊN CLASS (AdBanner) chứ KHÔNG PHẢI TÊN BẢNG (AdBanners)
	        String jpql = "SELECT a FROM AdBanner a ORDER BY a.id DESC";
	        TypedQuery<AdBanner> query = em.createQuery(jpql, AdBanner.class);

	        // Thêm log để kiểm tra:
	        System.out.println("DEBUG ADS: Lấy về " + query.getResultList().size() + " banners.");

	        return query.getResultList();
	    } catch (Exception e) {
	        // Nếu có lỗi, log sẽ giúp bạn biết
	        e.printStackTrace();
	        return new ArrayList<>();
	    } finally {
	        em.close();
	    }
	}

    // Hàm 2: Thêm Banner mới (CREATE)
    public static boolean createAdBanner(AdBanner ad) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.persist(ad);
            trans.commit();
            return true;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    // Hàm 3: Lấy Banner theo ID (Dùng cho UPDATE/DELETE)
    public static AdBanner findById(int id) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.find(AdBanner.class, id);
        } finally {
            em.close();
        }
    }

    // Hàm 4: Cập nhật Banner (UPDATE) - Dùng em.merge()
    public static boolean updateAdBanner(AdBanner ad) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            em.merge(ad);
            trans.commit();
            return true;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

    // Hàm 5: Xóa Banner (DELETE)
    public static boolean deleteAdBanner(int id) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            AdBanner ad = em.find(AdBanner.class, id);
            if (ad != null) {
                em.remove(ad);
            }
            trans.commit();
            return true;
        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }

}
