package Services;

import java.sql.Date;
import java.util.List;

import Entities.Comment;
import Entities.User;
import Entities.Video;
import Utils.JpaUtil;
import jakarta.persistence.*;

public class CommentServices {

    // Tạo duy nhất 1 EntityManagerFactory
    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("NewsWebsiteDB");


    // Lấy EntityManager
    private static EntityManager getManager() {
        return emf.createEntityManager();
    }


    // Thêm comment
    public static void addComment(User user, Video video, String content, Comment parent) {
        EntityManager manager = getManager();

        try {
            manager.getTransaction().begin();

            Comment c = new Comment();
            c.setUser(user);
            c.setVideo(video);
            c.setContent(content);
            c.setParentComment(parent);
            c.setCreateAt(new Date(System.currentTimeMillis()));
            c.setStatus(1);

            manager.persist(c);
            manager.getTransaction().commit();

        } catch (Exception e) {
            e.printStackTrace();
            if (manager.getTransaction().isActive()) {
                manager.getTransaction().rollback();
            }
        } finally {
            manager.close();
        }
    }


    public static Comment getById(int id) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("NewsWebsiteDB");
        EntityManager manager = factory.createEntityManager();
        try {
            return manager.find(Comment.class, id);
        } finally {
            manager.close();
        }
    }

 // Trong file Services/CommentServices.java

    public static List<Comment> getCommentsByVideoId(int videoId) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        try {
            String jpql = "SELECT c FROM Comment c WHERE c.video.id = :vid AND c.parentComment IS NULL ORDER BY c.createAt DESC";
            List<Comment> list = em.createQuery(jpql, Comment.class)
                                   .setParameter("vid", videoId)
                                   .getResultList();

            for (Comment c : list) {
                c.getReplies().size(); // Nạp replies
                c.getLikes().size();   // <--- NẠP LIKES CHO CHA

                for(Comment reply : c.getReplies()) {
                    reply.getLikes().size(); // <--- NẠP LIKES CHO CON
                }
            }
            return list;
        } finally {
            em.close();
        }
    }

 // 1. Thêm hàm Toggle Like (Like/Unlike)
 // Sửa void -> boolean
    public static boolean toggleLike(int userId, int commentId) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        boolean isLiked = false; // Biến đánh dấu kết quả
        try {
            em.getTransaction().begin();

            String jpql = "SELECT cl FROM CommentLike cl WHERE cl.user.id = :uid AND cl.comment.id = :cid";
            Entities.CommentLike existingLike = em.createQuery(jpql, Entities.CommentLike.class)
                    .setParameter("uid", userId)
                    .setParameter("cid", commentId)
                    .getResultStream().findFirst().orElse(null);

            if (existingLike != null) {
                em.remove(existingLike);
                isLiked = false; // Đã xóa like
            } else {
                User u = em.find(User.class, userId);
                Entities.Comment c = em.find(Entities.Comment.class, commentId);

                Entities.CommentLike newLike = new Entities.CommentLike();
                newLike.setUser(u);
                newLike.setComment(c);
                newLike.setLikedAt(new java.util.Date());

                em.persist(newLike);
                isLiked = true; // Đã thêm like mới
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            if(em.getTransaction().isActive()) {
				em.getTransaction().rollback();
			}
        } finally {
            em.close();
        }
        return isLiked; // Trả về kết quả
    }




    // Lấy reply theo parentId
    public static List<Comment> getChildComments(int parentId, int offset, int limit) {
        EntityManagerFactory factory = Persistence.createEntityManagerFactory("NewsWebsiteDB");
        EntityManager manager = factory.createEntityManager();

        try {
            return manager.createQuery(
                    "SELECT c FROM Comment c WHERE c.comment.id = :parentId ORDER BY c.createAt ASC",
                    Comment.class)
                    .setParameter("parentId", parentId)
                    .setFirstResult(offset)
                    .setMaxResults(limit)
                    .getResultList();
        } finally {
            manager.close();
        }
    }


    // Đếm comment của video
    public static int getCommentCount(int videoId) {
        EntityManager em = getManager();
        try {
            String jpql = "SELECT COUNT(c) FROM Comment c WHERE c.video.id = :videoId";
            Long count = em.createQuery(jpql, Long.class)
                    .setParameter("videoId", videoId)
                    .getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        } finally {
            em.close();
        }
    }


    // Lấy comment gốc
    public static List<Comment> getCommentsByVideo(int videoId) {
        EntityManager manager = getManager();

        try {
            String sql = "SELECT * FROM comments WHERE video_id = ?1 AND parent_id IS NULL ORDER BY create_at DESC";

            return manager.createNativeQuery(sql, Comment.class)
                    .setParameter(1, videoId)
                    .getResultList();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            manager.close();
        }
    }
}
