package Services;

import java.util.ArrayList;
import java.util.List;

import Entities.Category;
import jakarta.persistence.*;

public class CategoryServices {

	private static EntityManagerFactory managerFactory =
	        Persistence.createEntityManagerFactory("NewsWebsiteDB");

	public static List<Category> getAll() {
		List<Category> categories = new ArrayList<>();

		EntityManagerFactory managerFactory = Persistence.createEntityManagerFactory("NewsWebsiteDB");
		EntityManager manager = managerFactory.createEntityManager();

		try {

			String sql = "SELECT * FROM categories";

			Query query = manager.createNativeQuery(sql, Category.class);

			categories = query.getResultList();

		} catch (Exception e) {
			e.printStackTrace();
		}

		manager.close();
		return categories;

	}

	public static String delete(int id) {
        // Lưu ý: Nên dùng JpaUtil để lấy Factory thay vì tạo mới liên tục (gây chậm)
        // Nhưng tôi sẽ viết theo cách bạn đang dùng trong getAll() để code chạy được ngay.
        EntityManagerFactory managerFactory = Persistence.createEntityManagerFactory("NewsWebsiteDB");
        EntityManager em = managerFactory.createEntityManager();

        try {
            em.getTransaction().begin();

            // 1. Tìm Category
            Category category = em.find(Category.class, id);

            if (category == null) {
                return "Danh mục không tồn tại!";
            }

            // 2. Kiểm tra ràng buộc: Đếm số video thuộc danh mục này
            // Sử dụng HQL/JPQL để đếm
            String countHql = "SELECT COUNT(v) FROM Video v WHERE v.category.id = :catId";
            Long count = (Long) em.createQuery(countHql)
                                  .setParameter("catId", id)
                                  .getSingleResult();

            if (count > 0) {
                // Có bài viết -> Không cho xóa
                return "Không thể xóa! Danh mục này đang chứa " + count + " bài viết.";
            }

            // 3. Nếu không có bài viết -> Xóa
            em.remove(category);
            em.getTransaction().commit();

            return null; // Null nghĩa là thành công (không có lỗi)

        } catch (Exception e) {
            e.printStackTrace();
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return "Lỗi hệ thống: " + e.getMessage();
        } finally {
            em.close();
            // managerFactory.close(); // Không đóng factory nếu dùng chung
        }
    }

	public static boolean add(String name) {
	    // Sử dụng JpaUtil hoặc Factory singleton đã có của bạn
	    // EntityManagerFactory factory = Persistence.createEntityManagerFactory("NewsWebsiteDB"); // <- Dòng này gây chậm nếu gọi liên tục

	    // Giả sử bạn có class Utils.JpaUtil trả về Factory đã khởi tạo 1 lần
	    EntityManager manager = Utils.JpaUtil.getEntityManagerFactory().createEntityManager();

	    try {
	        manager.getTransaction().begin();
	        Category c = new Category();
	        c.setName(name);
	        manager.persist(c);
	        manager.getTransaction().commit();
	        return true;
	    } catch (Exception e) {
	        e.printStackTrace();
	        if(manager.getTransaction().isActive()) {
				manager.getTransaction().rollback();
			}
	    } finally {
	        manager.close();
	        // factory.close(); // Không đóng factory nếu dùng chung cho cả app
	    }
	    return false;
	}

	public static int count() {
	    int total = 0;

	    EntityManagerFactory factory = Persistence.createEntityManagerFactory("NewsWebsiteDB");
	    EntityManager manager = factory.createEntityManager();

	    try {
	        String sql = "SELECT COUNT(*) FROM categories";
	        Query query = manager.createNativeQuery(sql);
	        total = Integer.parseInt(query.getSingleResult().toString());
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    manager.close();
	    return total;
	}

	public static Category getInfoById(int id) {
	    EntityManager manager = managerFactory.createEntityManager();

	    try {
	        return manager.find(Category.class, id);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    } finally {
	        manager.close();
	    }
	}

	   public static Category getCategoryByVideoId(int videoId) {

	        EntityManagerFactory managerFactory = Persistence.createEntityManagerFactory("NewsWebsiteDB");
	        EntityManager manager = managerFactory.createEntityManager();

	        try {
	            String sql = "SELECT c.* FROM categories c "
	                       + "JOIN videos v ON c.id = v.cat_id "
	                       + "WHERE v.id = ?1";

	            Query query = manager.createNativeQuery(sql, Category.class);
	            query.setParameter(1, videoId);

	            List<Category> result = query.getResultList();
	            if (result.isEmpty()) {
	                return null;
	            }

	            return result.get(0);

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        manager.close();
	        return null;
	    }

	public static String addCategory(Category category) {
		EntityManagerFactory managerFactory = Persistence.createEntityManagerFactory("NewsWebsiteDB");
		EntityManager manager = managerFactory.createEntityManager();

		try {

			String name = category.getName().trim();

			String[] nameArr = name.split("//s+");

			String nameFinal = String.join(" ", nameArr).toLowerCase();

			String sql = "SELECT * FROM Category WHERE LOWER(name)=?1";

			Query query = manager.createNativeQuery(sql, Category.class);
			query.setParameter(1, nameFinal);

			Category categoryCheck = (Category) query.getSingleResult();

			if (categoryCheck != null) {
				return "Trùng tên";
			}

			if (!manager.getTransaction().isActive()) {
				manager.getTransaction().begin();
			}

			String[] nameFinalFinal = nameFinal.split(" ");
			for(int index = 0; index < nameFinalFinal.length; index++) {
				String firstStr = nameFinalFinal[index].substring(0, 1).toUpperCase();
				nameFinalFinal[index] = String.format("%s%s", firstStr, nameFinalFinal[index].substring(1));
			}

			category.setName(String.join(" ", nameFinalFinal));

			manager.merge(category);

			manager.getTransaction().commit();

		} catch (Exception e) {
			e.printStackTrace();

			manager.getTransaction().rollback();
		}

		manager.close();
		return null;

	}

	public static String deleteCategory(int id) {

		EntityManagerFactory managerFactory = Persistence.createEntityManagerFactory("NewsWebsiteDB");
		EntityManager manager = managerFactory.createEntityManager();

		try {

			Category category = manager.find(Category.class, id);
			if ((category == null) || (category.getVideos().size() > 0)) {  //Kiểm tra có video trong category đó không?

				return "Lỗi";

			}

            if(!manager.getTransaction().isActive()) {
            	manager.getTransaction().begin();
            }

            manager.remove(category);

            manager.getTransaction().commit();

		}catch(Exception e) {
			e.printStackTrace();
			manager.getTransaction().rollback();
			manager.close();
			return e.getMessage();
		}

		manager.close();
		return null;

	}

}
