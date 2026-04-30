package Services;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import Beans.UserProfileEditBean;
import Entities.User;
import Utils.JpaUtil;
import jakarta.persistence.*;

public class UserServices {

    /*
     * register() giữ nguyên logic, chỉ bỏ tạo Factory thừa
     */
	public static Map<String, String> register(User user) {

	    Map<String, String> map = new HashMap<>();

	    // Tạo EntityManager
	    EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();

	    try {
	        // Kiểm tra username, email, phone đã tồn tại chưa
	        String sql = "SELECT * FROM users WHERE username = ?1 OR email = ?2 OR phone = ?3";

	        Query q = em.createNativeQuery(sql, User.class);
	        q.setParameter(1, user.getUsername());
	        q.setParameter(2, user.getEmail());
	        q.setParameter(3, user.getPhone());

	        List<User> users = q.getResultList();

	        // Duyệt qua danh sách user tìm được để báo lỗi cụ thể
	        for (User u : users) {
	            if (u.getUsername().equals(user.getUsername())) {
	                map.put("errUsername", "Tên đăng nhập đã tồn tại");
	            }
	            if (u.getEmail().equals(user.getEmail())) {
	                map.put("errEmail", "Email đã tồn tại");
	            }
	            if (u.getPhone().equals(user.getPhone())) {
	                map.put("errPhone", "Số điện thoại đã tồn tại");
	            }
	        }

	        // Nếu có lỗi thì trả về map lỗi ngay, không lưu vào DB
	        if (!map.isEmpty()) {
	            return map;
	        }

	        // Nếu không có lỗi -> Tiến hành lưu
	        em.getTransaction().begin();
	        em.persist(user);
	        em.getTransaction().commit();

	    } catch (Exception e) {
	        e.printStackTrace();
	        if (em.getTransaction().isActive()) {
	            em.getTransaction().rollback();
	        }
	    } finally {
	        em.close(); // Luôn đóng kết nối
	    }

	    return map;
	}

	public User findByEmail(String email) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class);
            query.setParameter("email", email);
            return query.getSingleResult();
        } catch (Exception e) {
            return null; // Không tìm thấy
        } finally {
            em.close();
        }
    }

    public void create(User user) {
        EntityManager em = JpaUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(user);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

	public static List<User> getFilteredUsers(int roleId, String keyword) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        List<User> result = new ArrayList<>();

        try {
            // JPQL cơ sở
            String jpql = "SELECT u FROM User u WHERE 1=1";

            // 1. Lọc theo Vai trò
            if (roleId > 0) {
                jpql += " AND u.role = :roleId";
            }

            // 2. Lọc theo Từ khóa (Tìm kiếm theo name HOẶC username)
            if (keyword != null && !keyword.trim().isEmpty()) {
                jpql += " AND (u.username LIKE :keyword OR u.name LIKE :keyword)";
            }

            // Sắp xếp
            jpql += " ORDER BY u.id DESC";

            TypedQuery<User> query = em.createQuery(jpql, User.class);

            // Gán tham số
            if (roleId > 0) {
                query.setParameter("roleId", roleId);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }

            result = query.getResultList();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            em.close();
        }
        return result;
    }

	public static void updateBankInfo(int userId, String bank, String acc, String name) {
	    EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
	    try {
	        em.getTransaction().begin();
	        User u = em.find(User.class, userId);
	        if (u != null) {
	            u.setBankName(bank);
	            u.setBankAccount(acc);
	            u.setBankAccountName(name.toUpperCase()); // Lưu tên in hoa cho chuẩn ngân hàng
	            em.merge(u);
	        }
	        em.getTransaction().commit();
	    } catch (Exception e) {
	        e.printStackTrace();
	        em.getTransaction().rollback();
	    } finally {
	        em.close();
	    }
	}

	public static void activateVip(int userId, int days) {
	    EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
	    try {
	        em.getTransaction().begin();
	        User u = em.find(User.class, userId);

	        Calendar cal = Calendar.getInstance();
	        // Nếu đang là VIP thì cộng nối tiếp, nếu không thì tính từ hôm nay
	        if (u.getVipExpireDate() != null && u.getVipExpireDate().after(new Date())) {
	            cal.setTime(u.getVipExpireDate());
	        }

	        cal.add(Calendar.DAY_OF_YEAR, days);
	        u.setVipExpireDate(cal.getTime());

	        em.merge(u);
	        em.getTransaction().commit();
	    } finally { em.close(); }
	}

 // 1. Kiểm tra Email và tạo mã OTP
    public static boolean sendResetPasswordCode(String email) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            // Tìm user theo email
            String jpql = "SELECT u FROM User u WHERE u.email = :email";
            User user = em.createQuery(jpql, User.class)
                          .setParameter("email", email)
                          .getResultStream().findFirst().orElse(null);

            if (user == null) {
				return false; // Email không tồn tại
			}

            // Tạo mã OTP 6 số
            String code = String.valueOf(new Random().nextInt(900000) + 100000);

            // Set thời gian hết hạn (ví dụ 5 phút sau)
            Date now = new Date();
            Date expiredTime = new Date(now.getTime() + (5 * 60 * 1000));

            em.getTransaction().begin();
            user.setCodeRecovery(code);
            user.setCodeExpired(expiredTime);
            em.merge(user);
            em.getTransaction().commit();

            // Gửi email
            String subject = "Mã xác nhận khôi phục mật khẩu";
            String body = "Mã xác nhận của bạn là: " + code + "\nMã này sẽ hết hạn sau 5 phút.";
            Utils.EmailUtil.sendEmail(email, subject, body);

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

    // 2. Xác thực mã OTP
    public static boolean verifyRecoveryCode(String email, String code) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.email = :email AND u.codeRecovery = :code";
            User user = em.createQuery(jpql, User.class)
                          .setParameter("email", email)
                          .setParameter("code", code)
                          .getResultStream().findFirst().orElse(null);

            // Kiểm tra hết hạn
            if ((user == null) || new Date().after(user.getCodeExpired())) {
                return false; // Mã đã hết hạn
            }

            return true;
        } finally {
            em.close();
        }
    }

    // 3. Đặt lại mật khẩu mới
    public static boolean resetPassword(String email, String newPassword) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            String jpql = "SELECT u FROM User u WHERE u.email = :email";
            User user = em.createQuery(jpql, User.class)
                          .setParameter("email", email)
                          .getSingleResult();

            if (user == null) {
				return false;
			}

            em.getTransaction().begin();
            user.setPassword(newPassword); // Nhớ mã hóa mật khẩu nếu hệ thống có dùng BCrypt/MD5
            user.setCodeRecovery(null); // Xóa mã sau khi dùng xong
            user.setCodeExpired(null);
            em.merge(user);
            em.getTransaction().commit();

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            em.close();
        }
    }


    /*
     * Login giữ nguyên logic
     */
    public static User login(String usernameOrEmail, String password) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();

        try {
            String jpql = "SELECT u FROM User u "
                    + "WHERE (u.username = :x OR u.email = :x) "
                    + "AND u.password = :p";

            User user = em.createQuery(jpql, User.class)
                    .setParameter("x", usernameOrEmail)
                    .setParameter("p", password)
                    .getResultStream()
                    .findFirst()
                    .orElse(null);

            if (user != null && !user.isStatus()) {
                return new User();
            }

            return user;

        } finally {
            em.close();
        }
    }


    /*
     * updatePassword giữ nguyên code, chỉ sửa cách lấy Factory
     */
    public static boolean updatePassword(int id, String newPass) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();

        try {
            em.getTransaction().begin();

            User user = em.find(User.class, id);
            if (user == null) {
				return false;
			}

            user.setPassword(newPass);
            em.merge(user);

            em.getTransaction().commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            em.getTransaction().rollback();
            return false;

        } finally {
            em.close();
        }
    }


    /*
     * Lấy toàn bộ user – giữ nguyên
     */
    public static List<User> getAllUsers() {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();

        try {
            TypedQuery<User> query = em.createQuery("SELECT u FROM User u", User.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }


    /*
     * toggleStatus giữ nguyên logic
     */
    public static void toggleStatus(int id) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();

        try {
            em.getTransaction().begin();
            User user = em.find(User.class, id);

            if (user != null) {
                user.setStatus(!user.isStatus());
                em.merge(user);
            }

            em.getTransaction().commit();

        } catch (Exception e) {
            e.printStackTrace();
            em.getTransaction().rollback();

        } finally {
            em.close();
        }
    }


    /*
     * getInfo giữ nguyên
     */
    public static User getInfo(int id) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }


    /*
     * getUserInfoById giữ nguyên logic
     */
    public static User getUserInfoById(int id) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();

        try {
            return em.find(User.class, id);

        } catch (Exception e) {
            e.printStackTrace();
            return null;

        } finally {
            em.close();
        }
    }


    /*
     * updateProfile giữ nguyên logic
     */
    public boolean updateProfile(int id, UserProfileEditBean bean) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();

        try {
            em.getTransaction().begin();

            User user = em.find(User.class, id);
            if (user == null) {
				return false;
			}

            user.setName(bean.getName());
            user.setPhone(bean.getPhone());

            if (bean.getPassword() != null && !bean.getPassword().isEmpty()) {
                user.setPassword(bean.getPassword());
            }

            em.merge(user);
            em.getTransaction().commit();
            return true;

        } catch (Exception e) {
            em.getTransaction().rollback();
            return false;

        } finally {
            em.close();
        }
    }


    /*
     * update(u) giữ nguyên
     */
    public static void update(User u) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();

        try {
            em.getTransaction().begin();
            em.merge(u);
            em.getTransaction().commit();

        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();

        } finally {
            em.close();
        }
    }


    /*
     * getById giữ nguyên logic, chỉ bỏ close factory
     */
    public static User getById(int id) {

        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();

        try {
            return em.find(User.class, id);

        } catch (Exception e) {
            e.printStackTrace();
            return null;

        } finally {
            em.close();
        }
    }

}
