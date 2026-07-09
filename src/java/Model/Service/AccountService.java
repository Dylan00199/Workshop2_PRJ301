
package Model.Service;

import java.util.List;
import Model.Account;
import javax.persistence.*;

public class AccountService implements Accessible<Account> {

    private EntityManagerFactory emf;
    private final String PERSISTENCE_NAME = "Workshop2_SE205044PU";

    public AccountService() {
        this.emf = Persistence.createEntityManagerFactory(PERSISTENCE_NAME);
    }

    @Override
    public void close() {
        if (this.emf != null && this.emf.isOpen()) {
            this.emf.close();
        }
    }

    @Override
    public int insertRec(Account obj) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        EntityTransaction tx = em.getTransaction();
        try {
            if (obj != null) {
                tx.begin();
                em.persist(obj);
                tx.commit();
                result = 1;
            }
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("insertRec failed: " + e.getMessage(), e);
        } finally {
            em.close();
        }
        return result;
    }

    @Override
    public int updateRec(Account obj) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        EntityTransaction tx = em.getTransaction();
        try {
            Account existing = em.find(Account.class, obj.getAccount());
            if (existing != null) {
                tx.begin();
                em.merge(obj);
                tx.commit();
                result = 1;
            }
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("updateRec failed: " + e.getMessage(), e);
        } finally {
            em.close();
        }
        return result;
    }

    @Override
    public int deleteRec(Account obj) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        EntityTransaction tx = em.getTransaction();
        try {
            Account accountDelete = em.find(Account.class, obj.getAccount());
            if (accountDelete != null) {
                tx.begin();
                em.remove(accountDelete);
                tx.commit();
                result = 1;
            }
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            e.printStackTrace();
            throw new RuntimeException("deleteRec failed: " + e.getMessage(), e);
        } finally {
            em.close();
        }
        return result;
    }

    @Override
    public Account getObjectById(String id) {
        EntityManager em = this.emf.createEntityManager();
        try {
            return em.find(Account.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Account> listAll() {
        EntityManager em = this.emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM Account u", Account.class).getResultList();
        } finally {
            em.close();
        }
    }

}