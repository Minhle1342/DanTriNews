package Utils;

import jakarta.persistence.*;

public class JpaUtil {

    // Khởi tạo EntityManagerFactory một lần duy nhất (Singleton)
    // Tên "NewsWebsiteDB" phải khớp với tên trong file persistence.xml của bạn
    private static final EntityManagerFactory emf = createEntityManagerFactory();

    private static EntityManagerFactory createEntityManagerFactory() {
        try {
            java.util.Map<String, String> properties = new java.util.HashMap<>();
            properties.put("jakarta.persistence.jdbc.user", ConfigLoader.get("db.user"));
            properties.put("jakarta.persistence.jdbc.password", ConfigLoader.get("db.password"));
            
            return Persistence.createEntityManagerFactory("NewsWebsiteDB", properties);
        } catch (Throwable ex) {
            System.err.println("Lỗi khởi tạo EntityManagerFactory: " + ex.getMessage());
            throw new ExceptionInInitializerError(ex);
        }
    }

    // Hàm trả về Factory để bạn gọi .createEntityManager() như yêu cầu
    public static EntityManagerFactory getEntityManagerFactory() {
        return emf;
    }

    // Hàm tiện ích để lấy trực tiếp EntityManager nếu cần dùng nhanh
    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    // Hàm đóng Factory khi ứng dụng dừng (Stop Server)
    public static void shutdown() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}