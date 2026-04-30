package Services;

import java.util.List;

import Entities.VideoChapter;
import Utils.JpaUtil;
import jakarta.persistence.*;
public class ChapterService {
    public List<VideoChapter> getChaptersByVideo(int videoId) {
        EntityManager em = JpaUtil.getEntityManagerFactory().createEntityManager();
        List<VideoChapter> list = em.createQuery("SELECT c FROM VideoChapter c WHERE c.video.id = :vId ORDER BY c.startTime ASC", VideoChapter.class)
                                    .setParameter("vId", videoId).getResultList();
        em.close();
        return list;
    }
}
