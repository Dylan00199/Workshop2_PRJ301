package Model.Service;

import Model.Comment;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class CommentService {

    private EntityManagerFactory emf;
    private final String PERSISTENCE_NAME = "Workshop2_SE205044PU";

    public CommentService() {
        this.emf = Persistence.createEntityManagerFactory(PERSISTENCE_NAME);
    }

    public void close() {
        if (this.emf != null && this.emf.isOpen()) {
            this.emf.close();
        }
    }

    public int insertRec(Comment obj) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        try {
            if (obj != null) {
                em.getTransaction().begin();
                em.persist(obj);
                em.getTransaction().commit();
                result = 1;
            }
        } finally {
            em.close();
        }
        return result;
    }

    /** Comments for a single product, newest first. */
    public List<Comment> listByProduct(String productId) {
        EntityManager em = this.emf.createEntityManager();
        try {
            return em.createQuery(
                    "SELECT c FROM Comment c WHERE c.productId = :pid ORDER BY c.createdAt DESC", Comment.class)
                    .setParameter("pid", productId)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
