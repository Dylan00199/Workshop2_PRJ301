package Model.Service;

import Model.ViewHistory;
import java.util.Date;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class ViewHistoryService {

    private EntityManagerFactory emf;
    private final String PERSISTENCE_NAME = "Workshop2_SE205044PU";

    public ViewHistoryService() {
        this.emf = Persistence.createEntityManagerFactory(PERSISTENCE_NAME);
    }

    public void close() {
        if (this.emf != null && this.emf.isOpen()) {
            this.emf.close();
        }
    }

    /** Records that `account` viewed `productId` at `price` right now. */
    public void recordView(String account, String productId, int price) {
        EntityManager em = this.emf.createEntityManager();
        try {
            em.getTransaction().begin();
            ViewHistory vh = new ViewHistory(account, productId, price, new Date());
            em.persist(vh);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    /** All raw view rows, most recent first - used to render the Admin "view history" list. */
    public List<ViewHistory> listAll() {
        EntityManager em = this.emf.createEntityManager();
        try {
            return em.createQuery(
                    "SELECT v FROM ViewHistory v ORDER BY v.viewedAt DESC", ViewHistory.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    /** Average of priceAtView for a single account - the number the segmentation rule runs on. */
    public Double getAverageViewedPrice(String account) {
        EntityManager em = this.emf.createEntityManager();
        try {
            return em.createQuery(
                    "SELECT AVG(v.priceAtView) FROM ViewHistory v WHERE v.account = :acc", Double.class)
                    .setParameter("acc", account)
                    .getSingleResult();
        } finally {
            em.close();
        }
    }

    /** Distinct accounts that have at least one recorded view - for the Admin dashboard table. */
    public List<String> listViewedAccounts() {
        EntityManager em = this.emf.createEntityManager();
        try {
            return em.createQuery(
                    "SELECT DISTINCT v.account FROM ViewHistory v", String.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }
}
