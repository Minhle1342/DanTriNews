package Services;

import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import Entities.Category;
import Entities.Favourite;
import Entities.User;
import Entities.Video;
import Entities.VideoProduct;
import Utils.JpaUtil;
import Utils.Utils;
import jakarta.persistence.*;

public class VideoServices {

    // EntityManagerFactory singleton
    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("NewsWebsiteDB");

    /* -------------------- Create -------------------- */
//    public static String addVideo(Video video, int userId, int catId) {
//        EntityManager em = emf.createEntityManager();
//        try {
//            Category category = CategoryServices.getInfoById(catId);
//            if (category == null) {
//				return "Danh mục không tồn tại.";
//			}
//
//            User user = UserServices.getUserInfoById(userId);
//            if (user == null) {
//				return "Không tìm thấy người dùng.";
//			}
//
//            em.getTransaction().begin();
//            video.setCategory(category);
//            video.setUser(user);
//            em.persist(video);
//            em.getTransaction().commit();
//            return null;
//        } catch (Exception e) {
//            e.printStackTrace();
//            if (em.getTransaction().isActive()) {
//				em.getTransaction().rollback();
//			}
//            return "Lỗi hệ thống: " + e.getMessage();
//        } finally {
//            em.close();
//        }
//    }

 // Thêm vào Services/VideoServices.java

    public static List<Video> getPremiumVideos() {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            // SỬA: Đổi v.status = 1 thành v.status = 2 (cho khớp với logic JSP của bạn)
            String jpql = "SELECT v FROM Video v WHERE v.premium = true AND v.status = 2 ORDER BY v.createAt DESC";

            List<Video> list = em.createQuery(jpql, Video.class).getResultList();

            // Debug: In ra xem tìm được bao nhiêu video
            System.out.println("DEBUG: Số lượng video Premium tìm thấy: " + list.size());

            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            em.close();
        }
    }

    public static String updateVideo(Video updatedVideo, int newCatId) {
        if (updatedVideo.getTitle() == null || updatedVideo.getTitle().isEmpty()) {
            return "Tiêu đề không được để trống.";
        }
        if (newCatId <= 0) {
            return "Vui lòng chọn danh mục.";
        }

        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        try {
            trans.begin();

            // 1. Tải lại Entity gốc (Managed) bằng ID của nó
            // => Đảm bảo Hibernate theo dõi đối tượng này.
            Video managedVideo = em.find(Video.class, updatedVideo.getId());

            if (managedVideo == null) {
                trans.rollback();
                return "Lỗi: Không tìm thấy Video cần cập nhật (ID không tồn tại).";
            }

            // 2. Tải Category mới (Managed)
            Category category = em.find(Category.class, newCatId);
            if (category == null) {
                trans.rollback();
                return "Danh mục không tồn tại.";
            }

            // 3. CHUYỂN DỮ LIỆU THAY ĐỔI VÀO MANAGED ENTITY
            // Hibernate sẽ tự động lưu các thay đổi này khi commit.
            managedVideo.setTitle(updatedVideo.getTitle());
            managedVideo.setDesc(updatedVideo.getDesc());
            managedVideo.setUrl(updatedVideo.getUrl());
            managedVideo.setPremium(updatedVideo.isPremium());
            managedVideo.setCategory(category);
            // Giữ nguyên các trường khác (poster, viewCount, createAt...)

            // Không cần gọi em.merge(managedVideo) vì nó đã được find (Managed).

            trans.commit();
            return null; // Thành công

        } catch (Exception e) {
            if (trans.isActive()) {
                trans.rollback();
            }
            e.printStackTrace();
            System.err.println("Cập nhật video thất bại: " + e.getMessage());
            return "Lỗi Database khi cập nhật: " + e.getMessage();
        } finally {
            em.close();
        }
    }

    public static boolean deleteVideo(int id) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        try {
            trans.begin();

            // 1. Kiểm tra Video tồn tại
            Video videoToDelete = em.find(Video.class, id);
            if (videoToDelete == null) {
                trans.rollback();
                return false; // Không tìm thấy video
            }

            // 2. XÓA DỮ LIỆU LIÊN QUAN (Khắc phục lỗi Foreign Key)
            // (Giả định các bảng liên quan là Comment, Favorite, History)

            // 2a. Xóa Comments liên quan
            Query deleteComments = em.createQuery("DELETE FROM Comment c WHERE c.video.id = :videoId");
            deleteComments.setParameter("videoId", id);
            deleteComments.executeUpdate();

            // 2b. Xóa Favorites/Likes liên quan (Giả định bảng Favorite)
            Query deleteFavorites = em.createQuery("DELETE FROM Favourite f WHERE f.video.id = :videoId");
            deleteFavorites.setParameter("videoId", id);
            deleteFavorites.executeUpdate();

            // 2c. Xóa History liên quan
            Query deleteHistory = em.createQuery("DELETE FROM History h WHERE h.video.id = :videoId");
            deleteHistory.setParameter("videoId", id);
            deleteHistory.executeUpdate();


            // 3. Xóa Entity Video chính
            em.remove(videoToDelete);

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

    public static void distributeMoneyForView(int videoId, EntityManager em) {
        try {
            // 1. Lấy thông tin video và tác giả (Dùng chung EntityManager 'em' truyền vào)
            Video v = em.find(Video.class, videoId);

            if (v != null && v.getUser() != null) {
                User author = v.getUser();

                // 2. Định nghĩa đơn giá (10 VNĐ / 1 view)
                long pricePerView = 10;

                // 3. Cộng tiền vào ví của tác giả
                long currentBalance = author.getBalance();
                author.setBalance(currentBalance + pricePerView);

                // 4. Cộng tích lũy cho video (Để sau này admin làm báo cáo dòng tiền)
//                v.setEarnedMoney(v.getEarnedMoney() + pricePerView);

                // Lưu thay đổi (Chỉ cần merge, commit sẽ do hàm bên ngoài thực hiện)
                em.merge(author);
                em.merge(v);
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi phân phối tiền: " + e.getMessage());
            throw e; // Ném lỗi ra ngoài để hàm chính thực hiện Rollback
        }
    }

    public static String addVideo(Video video, int userId, int catId) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();

            Category category = em.find(Category.class, catId);
            if (category == null) {
                return "Danh mục không tồn tại.";
            }

            User user = em.find(User.class, userId);
            if (user == null) {
                return "Không tìm thấy người dùng (Vui lòng đăng nhập lại).";
            }

            video.setCategory(category);
            video.setUser(user);

            // Lưu vào DB
            em.persist(video);

            em.getTransaction().commit();
            return null; // Trả về null nghĩa là KHÔNG CÓ LỖI (Thành công)

        } catch (Exception e) {
            e.printStackTrace();
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            return "Lỗi Database: " + e.getMessage();
        } finally {
            em.close();
        }
    }
    public static void increaseView(int videoId, int userId) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();

            Video video = em.find(Video.class, videoId);
            if (video == null) {
				return;
			}

            boolean shouldIncrease = true;

            if (userId > 0) {
                String jpql = "SELECT count(h) FROM History h WHERE h.user.id = :uid AND h.video.id = :vid";
                Long count = em.createQuery(jpql, Long.class)
                               .setParameter("uid", userId)
                               .setParameter("vid", videoId)
                               .getSingleResult();

                if (count > 0) {
                    shouldIncrease = false;
                }
            }



            if (shouldIncrease) {
                // Tăng lượt xem
                video.setViewCount(video.getViewCount() + 1);
                em.merge(video);

                // ✅ GỌI HÀM TÍNH TIỀN: Truyền thêm 'em' vào để dùng chung Transaction
                distributeMoneyForView(videoId, em);
            }

            em.getTransaction().commit(); // Kết thúc: Lưu cả lượt xem và tiền cùng lúc
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
            e.printStackTrace();
        } finally {
            em.close();
        }
    }



    public static List<VideoProduct> getProductsByVideo(int videoId) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            // Truy vấn danh sách sản phẩm theo ID video
            String jpql = "SELECT p FROM VideoProduct p WHERE p.video.id = :vid ORDER BY p.startTime ASC";
            return em.createQuery(jpql, VideoProduct.class)
                     .setParameter("vid", videoId)
                     .getResultList();
        } finally {
            em.close();
        }
    }


    public static List<Video> getRelatedVideos(int videoId, int catId, String title, int limit) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("NewsWebsiteDB");
        EntityManager em = factory.createEntityManager();

        try {
            // Rút gọn title để tìm kiếm gần đúng
            String key = title.replaceAll("[^a-zA-Z0-9\\p{L} ]", "").trim();

            // Truy vấn bài viết cùng danh mục
            String jpql =
                "SELECT v FROM Video v WHERE v.id <> :videoId AND v.category.id = :catId "
                + "ORDER BY v.viewCount DESC, v.createAt DESC";

            List<Video> sameCategory = em.createQuery(jpql, Video.class)
                    .setParameter("videoId", videoId)
                    .setParameter("catId", catId)
                    .setMaxResults(limit)
                    .getResultList();

            // Nếu đủ số lượng thì return luôn
            if (sameCategory.size() >= limit) {
                return sameCategory;
            }

            // Ngược lại → Tìm thêm video có tiêu đề gần giống
            String sql2 =
                "SELECT v FROM Video v WHERE v.id <> :videoId "
                + "AND LOWER(v.title) LIKE LOWER(:title) "
                + "ORDER BY v.viewCount DESC, v.createAt DESC";

            List<Video> similarTitle = em.createQuery(sql2, Video.class)
                    .setParameter("videoId", videoId)
                    .setParameter("title", "%" + key + "%")
                    .setMaxResults(limit)
                    .getResultList();

            // Gộp lại nhưng tránh trùng lặp
            for (Video v : similarTitle) {
                if (!sameCategory.contains(v)) {
                    sameCategory.add(v);
                }
            }

            // Giới hạn đúng số lượng
            return sameCategory.subList(0, Math.min(limit, sameCategory.size()));

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public static List<Video> getAll() {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT v FROM Video v ORDER BY v.createAt DESC";
            return em.createQuery(jpql, Video.class).getResultList();
        } finally {
            em.close();
        }
    }

    /* -------------------- Thống kê (Dashboard) -------------------- */

    // 1. Top 5 video có nhiều lượt xem nhất
    public static List<Video> getTopViewedVideos(int limit) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT v FROM Video v ORDER BY v.viewCount DESC";
            return em.createQuery(jpql, Video.class)
                     .setMaxResults(limit)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    // 2. Top 5 video được yêu thích nhiều nhất
    // Sắp xếp dựa trên số lượng record trong bảng favourites liên kết với video
    public static List<Object[]> getTopLikedVideos(int limit) {
        EntityManager em = emf.createEntityManager();
        try {
            // Trả về mảng Object[]: [0]=Video, [1]=Long(count)
            String jpql = "SELECT v, COUNT(f) as likeCount " +
                          "FROM Video v LEFT JOIN v.favourites f " +
                          "GROUP BY v " +
                          "ORDER BY likeCount DESC";

            return em.createQuery(jpql, Object[].class)
                     .setMaxResults(limit)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public static List<Video> getByCategory(int catId) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("NewsWebsiteDB");
        EntityManager em = factory.createEntityManager();

        try {
            String jpql =
                "SELECT v FROM Video v WHERE v.category.id = :catId "
              + "ORDER BY v.createAt DESC, v.viewCount DESC";

            return em.createQuery(jpql, Video.class)
                     .setParameter("catId", catId)
                     .getResultList();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public static List<Video> searchByTitle(String keyword) {
        EntityManager em = Utils.getEntityManager();

        try {
            String jpql = "SELECT v FROM Video v WHERE v.title LIKE :kw";
            List<Video> list = em.createQuery(jpql, Video.class)
                    .setParameter("kw", "%" + keyword + "%")
                    .getResultList();

            for (Video v : list) {
                long cmt = em.createQuery(
                    "SELECT COUNT(c) FROM Comment c WHERE c.video.id = :vid", Long.class)
                    .setParameter("vid", v.getId())
                    .getSingleResult();

                long fav = em.createQuery(
                    "SELECT COUNT(f) FROM Favourite f WHERE f.video.id = :vid", Long.class)
                    .setParameter("vid", v.getId())
                    .getSingleResult();

                v.setCommentCount(cmt);
                v.setFavouriteCount(fav);
            }

            return list;

        } finally {
            em.close();
        }
    }


    /* -------------------- Read -------------------- */
    public static Video getInfoById(int videoId) {
        EntityManager em = emf.createEntityManager();
        try {
            // Fetch video và comments
            String q1 = "SELECT v FROM Video v "
                      + "LEFT JOIN FETCH v.comments "
                      + "WHERE v.id = :id";
            TypedQuery<Video> query = em.createQuery(q1, Video.class);
            query.setParameter("id", videoId);
            Video video = query.getSingleResult();

            // Force load favourites nhưng KHÔNG FETCH JOIN
            video.getFavourites().size();

            return video;

        } catch (NoResultException nre) {
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public static List<Video> searchApprovedVideos(int userId, int categoryId, String keyword) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT v FROM Video v WHERE v.user.id = :uid AND v.status = 2");

            // Nếu có chọn danh mục (categoryId > 0)
            if (categoryId > 0) {
                jpql.append(" AND v.category.id = :catId");
            }

            // Nếu có nhập từ khóa
            if (keyword != null && !keyword.trim().isEmpty()) {
                jpql.append(" AND v.title LIKE :kw");
            }

            // Sắp xếp mới nhất lên đầu
            jpql.append(" ORDER BY v.createAt DESC");

            TypedQuery<Video> query = em.createQuery(jpql.toString(), Video.class);
            query.setParameter("uid", userId);

            if (categoryId > 0) {
                query.setParameter("catId", categoryId);
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword + "%");
            }

            return query.getResultList();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

 // Sửa lại hàm này: Dùng em.find để tìm bất chấp trạng thái
    public Video getVideoById(int id) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            // em.find tìm theo Primary Key.
            // Nếu Entity khai báo ID là Long thì cần ép kiểu, nếu Int thì để nguyên.
            // Ở đây tôi giả định ID trong Entity Video là int (Integer).
            Video v = em.find(Video.class, id);
            return v;
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console nếu có
            return null;
        } finally {
            em.close();
        }
    }

    public static Video getInfoByIdAndUserId(int videoId, int userId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.id = :vid AND v.user.id = :uid";
            TypedQuery<Video> q = em.createQuery(jpql, Video.class);
            q.setParameter("vid", videoId);
            q.setParameter("uid", userId);
            return q.getSingleResult();
        } catch (NoResultException nre) {
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public static List<Video> getVideosByCategory(int categoryId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.category.id = :cid ORDER BY v.createAt DESC";
            return em.createQuery(jpql, Video.class)
                     .setParameter("cid", categoryId)
                     .getResultList();
        } finally {
            em.close();
        }
    }

    public static List<Video> getAllByUserId(int userId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.user.id = :uid ORDER BY v.createAt DESC";
            TypedQuery<Video> q = em.createQuery(jpql, Video.class);
            q.setParameter("uid", userId);
            List<Video> result = q.getResultList();
            // Log nếu empty (debug)
            if (result.isEmpty()) {
                System.out.println("No videos found for userId: " + userId);
            }
            return result;
        } catch (Exception e) {
            System.err.println("getAllByUserId Error for userId " + userId + ": " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Lỗi tải danh sách video: " + e.getMessage(), e);  // Throw để expose, không che giấu
            // Hoặc nếu muốn graceful: return Collections.emptyList(); nhưng không recommend
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }



    public static int getFavouriteCount(int videoId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT COUNT(f) FROM Favourite f WHERE f.video.id = :videoId";
            TypedQuery<Long> q = em.createQuery(jpql, Long.class);
            q.setParameter("videoId", videoId);
            Long count = q.getSingleResult();
            return count == null ? 0 : count.intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }

    public static List<Video> getFavouritedVideosByUserId(int userId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT f.video FROM Favourite f WHERE f.user.id = :uid";
            return em.createQuery(jpql, Video.class)
                     .setParameter("uid", userId)
                     .getResultList();
        } finally {
            em.close();
        }
    }


    public static boolean isUserFavourited(int userId, int videoId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT COUNT(f) FROM Favourite f WHERE f.user.id = :uid AND f.video.id = :vid";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("uid", userId)
                    .setParameter("vid", videoId)
                    .getSingleResult();

            return count > 0;
        } finally {
            em.close();
        }
    }

    public static void addFavourite(int userId, int videoId) {
        EntityManager em = emf.createEntityManager();

        try {
            em.getTransaction().begin();

            User user = em.find(User.class, userId);
            Video video = em.find(Video.class, videoId);

            Favourite fav = new Favourite();
            fav.setUser(user);
            fav.setVideo(video);

            em.persist(fav);
            em.getTransaction().commit();

        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();

        } finally {
            em.close();
        }
    }

    public static Video getNewestPost() {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT v FROM Video v ORDER BY v.createAt DESC";
            TypedQuery<Video> q = em.createQuery(jpql, Video.class);
            q.setMaxResults(1);
            return q.getSingleResult();
        } catch (NoResultException nre) {
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public static Video getNewestPostByCategory(int categoryId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE v.category.id = :cid ORDER BY v.createAt DESC";
            List<Video> list = em.createQuery(jpql, Video.class)
                    .setParameter("cid", categoryId)
                    .setMaxResults(1)
                    .getResultList();
            return list.isEmpty() ? null : list.get(0);
        } finally {
            em.close();
        }
    }

    public static java.util.Map<String, Long> getUserStats(int userId) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        java.util.Map<String, Long> stats = new java.util.HashMap<>();

        try {
            // 1. Tổng tin
            String jpqlTotal = "SELECT COUNT(v) FROM Video v WHERE v.user.id = :uid";
            Long total = em.createQuery(jpqlTotal, Long.class)
                           .setParameter("uid", userId)
                           .getSingleResult();

            // 2. Tin đã duyệt (Status = 2)
            String jpqlApproved = "SELECT COUNT(v) FROM Video v WHERE v.user.id = :uid AND v.status = 2";
            Long approved = em.createQuery(jpqlApproved, Long.class)
                            .setParameter("uid", userId)
                            .getSingleResult();

            // 3. Tin chờ duyệt (Status = 1)
            String jpqlPending = "SELECT COUNT(v) FROM Video v WHERE v.user.id = :uid AND v.status = 1";
            Long pending = em.createQuery(jpqlPending, Long.class)
                           .setParameter("uid", userId)
                           .getSingleResult();

            // 4. Tin bị từ chối/ẩn (Status = 0) - Optional
            String jpqlRejected = "SELECT COUNT(v) FROM Video v WHERE v.user.id = :uid AND v.status = 0";
            Long rejected = em.createQuery(jpqlRejected, Long.class)
                           .setParameter("uid", userId)
                           .getSingleResult();

            stats.put("total", total);
            stats.put("approved", approved);
            stats.put("pending", pending);
            stats.put("rejected", rejected);

        } catch (Exception e) {
            e.printStackTrace();
            stats.put("total", 0L);
            stats.put("approved", 0L);
            stats.put("pending", 0L);
            stats.put("rejected", 0L);
        } finally {
            em.close();
        }
        return stats;
    }

    public static List<Video> searchAdvanced(String keyword, int catId, String timeFilter) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            // Câu truy vấn gốc: Chỉ lấy video đã duyệt (status = 2)
            StringBuilder jpql = new StringBuilder("SELECT v FROM Video v WHERE v.status = 2");

            // 1. Lọc theo từ khóa
            if (keyword != null && !keyword.trim().isEmpty()) {
                jpql.append(" AND v.title LIKE :kw");
            }

            // 2. Lọc theo danh mục
            if (catId > 0) {
                jpql.append(" AND v.category.id = :catId");
            }

            // 3. Lọc theo thời gian
            Date filterDate = null;
            if (timeFilter != null && !timeFilter.isEmpty() && !timeFilter.equals("all")) {
                Calendar cal = Calendar.getInstance();
                // Reset giờ phút giây về 0 để so sánh ngày chính xác (tùy nhu cầu)

                switch (timeFilter) {
                    case "1": // 24 giờ qua
                        cal.add(Calendar.HOUR_OF_DAY, -24);
                        break;
                    case "2": // Tuần này (7 ngày qua)
                        cal.add(Calendar.DAY_OF_YEAR, -7);
                        break;
                    case "3": // Tháng này (30 ngày qua)
                        cal.add(Calendar.DAY_OF_YEAR, -30);
                        break;
                    case "4": // Năm nay (365 ngày qua)
                        cal.add(Calendar.DAY_OF_YEAR, -365);
                        break;
                }
                filterDate = cal.getTime();

                // Thêm điều kiện ngày tạo >= ngày lọc
                jpql.append(" AND v.createAt >= :filterDate");
            }

            // Sắp xếp mới nhất
            jpql.append(" ORDER BY v.createAt DESC");

            // Tạo Query
            TypedQuery<Video> query = em.createQuery(jpql.toString(), Video.class);

            // Set tham số
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword + "%");
            }
            if (catId > 0) {
                query.setParameter("catId", catId);
            }
            if (filterDate != null) {
                query.setParameter("filterDate", filterDate);
            }

            return query.getResultList();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public static long getTotalViewsByUserId(int userId) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            // LƯU Ý: 'Video' và 'User' ở đây là tên Class Java (Entity), không phải tên bảng SQL
            // 'v.viewCount' phải trùng tên biến trong file Video.java
            // 'v.user.id' phải trùng tên biến user trong Video.java

            String jpql = "SELECT SUM(v.viewCount) FROM Video v WHERE v.user.id = :uid";

            Long sum = em.createQuery(jpql, Long.class)
                         .setParameter("uid", userId)
                         .getSingleResult();

            System.out.println("DEBUG SERVICE: Query View OK. Result = " + sum);

            return sum == null ? 0 : sum;
        } catch (Exception e) {
            e.printStackTrace(); // Xem lỗi chi tiết ở đây
            return 0;
        } finally {
            em.close();
        }
    }
    /* -------------------- Update -------------------- */
 // Ví dụ logic trong VideoServices.java
    public static String updateVideo(Video newInfo, int userId, int catId) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            em.getTransaction().begin();

            // 1. Tìm video cũ trong DB
            Video oldVideo = em.find(Video.class, newInfo.getId());

            if (oldVideo == null) {
				return "Video không tồn tại";
			}
            if (oldVideo.getUser().getId() != userId) {
				return "Bạn không có quyền sửa video này";
			}

            // 2. Cập nhật thông tin mới
            oldVideo.setTitle(newInfo.getTitle());
            oldVideo.setDesc(newInfo.getDesc());
            oldVideo.setUrl(newInfo.getUrl());
            oldVideo.setStatus(newInfo.getStatus()); // Set về 1

            // Cập nhật danh mục
            Category cat = em.find(Category.class, catId);
            if(cat != null) {
				oldVideo.setCategory(cat);
			}

            // 3. Logic giữ ảnh cũ: Chỉ update nếu newInfo có poster mới
            if (newInfo.getPoster() != null && !newInfo.getPoster().isEmpty()) {
                oldVideo.setPoster(newInfo.getPoster());
            }
            // Nếu newInfo.getPoster() là null -> Giữ nguyên oldVideo.getPoster()

            em.merge(oldVideo);
            em.getTransaction().commit();
            return null;
        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
            return "Lỗi hệ thống";
        } finally {
            em.close();
        }
    }

    /* -------------------- Delete -------------------- */
    public static String deleteVideo(int videoId, int userId, String uploadDir) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();

            Video video = em.createQuery(
                "SELECT v FROM Video v WHERE v.id = :vid AND v.user.id = :uid",
                Video.class)
                .setParameter("vid", videoId)
                .setParameter("uid", userId)
                .getSingleResult();

            // Lấy poster filename
            String posterUrl = video.getPoster();
            String posterFileName = null;
            if (posterUrl != null && !posterUrl.isEmpty()) {
                posterFileName = Paths.get(posterUrl).getFileName().toString();
            }

            // Remove Video → Cascade ALL sẽ trigger delete top-level comments (và recursive nested nhờ fix ở Comment entity)
            // + delete favourites
            em.remove(video);
            em.flush();  // Force execute tất cả DELETE SQL (bao gồm cascade recursive)

            em.getTransaction().commit();

            // Log cascade (optional, cho debug)
            System.out.println("Cascaded delete: Video " + videoId + " + comments tree + favourites");

            // Xóa file poster
            if (posterFileName != null && uploadDir != null) {
                java.io.File posterFile = new java.io.File(uploadDir, posterFileName);
                if (posterFile.exists()) {
                    posterFile.delete();
                }
            }

            // Verify (check Video + sample nested comment nếu cần)
            EntityManager verifyEm = emf.createEntityManager();
            try {
                long videoCount = verifyEm.createQuery(
                    "SELECT COUNT(v) FROM Video v WHERE v.id = :vid AND v.user.id = :uid", Long.class)
                    .setParameter("vid", videoId)
                    .setParameter("uid", userId)
                    .getSingleResult();
                if (videoCount > 0) {
                    return "Xóa không thành công: Video vẫn tồn tại.";
                }
                // Optional: Verify no orphaned nested comments (query count comments with video_id = videoId)
                long orphanCount = verifyEm.createQuery(
                    "SELECT COUNT(c) FROM Comment c WHERE c.video.id = :vid", Long.class)
                    .setParameter("vid", videoId)
                    .getSingleResult();
                if (orphanCount > 0) {
                    return "Xóa không sạch: Còn nested comments orphaned (kiểm tra DB).";
                }
            } finally {
                verifyEm.close();
            }

            return null;

        } catch (NoResultException e) {
            if (em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
            return "Không tìm thấy video hoặc không phải bài của bạn.";
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
            String msg = e.getMessage();
            System.err.println("Delete Video Error (cascade issue?): " + e.getClass().getName() + " - " + msg);
            e.printStackTrace();
            return (msg == null || msg.trim().isEmpty()) ?
                "Lỗi xóa: Nested comments constraint (kiểm tra FK parent_id ON DELETE CASCADE)." : msg;
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }


    /* -------------------- Tìm kiếm / Native -------------------- */
    public static List<Video> getVideos(String title, int catId) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT v FROM Video v WHERE "
                        + "(:title IS NULL OR :title = '' OR v.title LIKE :search) "
                        + "AND (:catId = 0 OR v.category.id = :catId) "
                        + "ORDER BY v.createAt DESC";
            TypedQuery<Video> q = em.createQuery(jpql, Video.class);
            String search = (title == null) ? "" : "%" + title.trim() + "%";
            q.setParameter("title", title);
            q.setParameter("search", search);
            q.setParameter("catId", catId);
            return q.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    public List<Video> getAllVideos() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("NewsWebsiteDB");
        EntityManager em = emf.createEntityManager();

        try {
            String jpql = "SELECT v FROM Video v ORDER BY v.createAt DESC";
            return em.createQuery(jpql, Video.class).getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
            emf.close();
        }
    }

    public boolean toggleStatus(int videoId) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("NewsWebsiteDB");
        EntityManager manager = factory.createEntityManager();

        try {
            manager.getTransaction().begin();

            Video v = manager.find(Video.class, videoId);
            if (v == null) {
				return false;
			}

            v.setStatus(v.getStatus() == 1 ? 0 : 1); // 1 = hiển thị, 0 = ẩn
            manager.merge(v);

            manager.getTransaction().commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            manager.close();
        }
    }



    // Nếu bạn vẫn cần native query version (giữ nguyên tên)
    public static List<Video> getVideoListByUserId(int userId) {
        EntityManager em = emf.createEntityManager();
        try {
            String sql = "SELECT * FROM videos WHERE user_id = ?1";
            Query q = em.createNativeQuery(sql, Video.class);
            q.setParameter(1, userId);
            @SuppressWarnings("unchecked")
            List<Video> list = q.getResultList();
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }
}
