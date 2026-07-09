/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
        try {
            if (obj != null) {
                em.getTransaction().begin();
                em.persist(obj);
                em.getTransaction().commit();
                result = 1;
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        finally {
            em.close();
        }
        return result;
    }

    @Override
    public int updateRec(Account obj) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        try {
            Account accountUpdate = em.find(Account.class, obj.getAccount());
            if (accountUpdate != null) {
                em.getTransaction().begin();
                em.merge(accountUpdate);
                em.getTransaction().commit();
                result = 1;
            }
        } finally {
            em.close();
        }
        return result;
    }

    @Override
    public int deleteRec(Account obj) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        try {
            Account accountDelete = em.find(Account.class, obj.getAccount());
            if (accountDelete != null) {
                em.getTransaction().begin();
                em.remove(accountDelete);
                em.getTransaction().commit();
                result = 1;
            }
        } finally {
            em.close();
        }
        return result;
    }

    @Override
    public Account getObjectById(String id) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        try {
            Account accountFound = em.find(Account.class, id);
            if (accountFound != null) {
                return accountFound;
            }
        } finally {
            em.close();
        }
        return null;
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
