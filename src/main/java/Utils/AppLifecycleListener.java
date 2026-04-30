package Utils;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppLifecycleListener implements ServletContextListener {

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        JpaUtil.shutdown();  // đóng EntityManagerFactory
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // không cần làm gì
    }
}

