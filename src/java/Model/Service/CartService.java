package Model.Service;

import Model.CartItem;
import Model.CartLineView;
import Model.Product;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.NoResultException;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;

public class CartService {

    private EntityManagerFactory emf;
    private final String PERSISTENCE_NAME = "Workshop2_SE205044PU";

    public CartService() {
        this.emf = Persistence.createEntityManagerFactory(PERSISTENCE_NAME);
    }

    public void close() {
        if (this.emf != null && this.emf.isOpen()) {
            this.emf.close();
        }
    }

    private CartItem findRow(EntityManager em, String account, String productId) {
        try {
            TypedQuery<CartItem> q = em.createQuery(
                    "SELECT c FROM CartItem c WHERE c.account = :acc AND c.productId = :pid", CartItem.class);
            q.setParameter("acc", account);
            q.setParameter("pid", productId);
            return q.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /** Adds qty of productId to account's cart, or increments the existing row. */
    public void addToCart(String account, String productId, int qty) {
        EntityManager em = this.emf.createEntityManager();
        try {
            em.getTransaction().begin();
            CartItem row = findRow(em, account, productId);
            if (row != null) {
                row.setQuantity(row.getQuantity() + qty);
                em.merge(row);
            } else {
                em.persist(new CartItem(account, productId, qty));
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    /** Sets the exact quantity for a row; removes the row entirely if qty <= 0. */
    public void updateQuantity(String account, String productId, int qty) {
        EntityManager em = this.emf.createEntityManager();
        try {
            em.getTransaction().begin();
            CartItem row = findRow(em, account, productId);
            if (row != null) {
                if (qty <= 0) {
                    em.remove(row);
                } else {
                    row.setQuantity(qty);
                    em.merge(row);
                }
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void removeItem(String account, String productId) {
        EntityManager em = this.emf.createEntityManager();
        try {
            em.getTransaction().begin();
            CartItem row = findRow(em, account, productId);
            if (row != null) {
                em.remove(row);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public void clearCart(String account) {
        EntityManager em = this.emf.createEntityManager();
        try {
            em.getTransaction().begin();
            em.createQuery("DELETE FROM CartItem c WHERE c.account = :acc")
                    .setParameter("acc", account)
                    .executeUpdate();
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    /** Number of distinct product rows in the cart - used for the navbar badge. */
    public int getCartCount(String account) {
        EntityManager em = this.emf.createEntityManager();
        try {
            Long count = em.createQuery(
                    "SELECT COUNT(c) FROM CartItem c WHERE c.account = :acc", Long.class)
                    .setParameter("acc", account)
                    .getSingleResult();
            return count == null ? 0 : count.intValue();
        } finally {
            em.close();
        }
    }

    /**
     * Full cart contents for display: joins each cart_items row with its
     * live Product. If a product was deleted after being added to a cart,
     * that row is silently skipped (rather than crashing the page).
     */
    public List<CartLineView> getCartLines(String account) {
        EntityManager em = this.emf.createEntityManager();
        try {
            List<CartItem> rows = em.createQuery(
                    "SELECT c FROM CartItem c WHERE c.account = :acc", CartItem.class)
                    .setParameter("acc", account)
                    .getResultList();

            List<CartLineView> lines = new ArrayList<>();
            for (CartItem row : rows) {
                Product p = em.find(Product.class, row.getProductId());
                if (p != null) {
                    lines.add(new CartLineView(p, row.getQuantity()));
                }
            }
            return lines;
        } finally {
            em.close();
        }
    }
}
