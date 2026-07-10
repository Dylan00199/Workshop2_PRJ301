/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.Service;

import java.util.List;
import Model.Category;
import Model.Category;
import javax.persistence.*;

public class CategoryService implements Accessible<Category> {

    private EntityManagerFactory emf;
    private final String PERSISTENCE_NAME = "Workshop2_SE205044PU";

    public CategoryService() {
        this.emf = Persistence.createEntityManagerFactory(PERSISTENCE_NAME);
    }

    @Override
    public void close() {
        if (this.emf != null && this.emf.isOpen()) {
            this.emf.close();
        }
    }

    @Override
    public int insertRec(Category obj) {
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

    @Override
    public int updateRec(Category obj) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        try {
            Category catUpdate = em.find(Category.class, obj.getTypeId());
            if (catUpdate != null) {
                em.getTransaction().begin();
                em.merge(obj);
                em.getTransaction().commit();
                result = 1;
            }
        } finally {
            em.close();
        }
        return result;
    }

    @Override
    public int deleteRec(Category obj) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        try {
            Category catDelete = em.find(Category.class, obj.getTypeId());
            if (catDelete != null) {
                em.getTransaction().begin();
                em.remove(catDelete);
                em.getTransaction().commit();
                result = 1;
            }
        } finally {
            em.close();
        }
        return result;
    }

    @Override
    public Category getObjectById(String id) {
        int Id = Integer.parseInt(id);
        return this.getObjectById(Id);
    }

    public Category getObjectById(int id) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        try {
            Category catFound = em.find(Category.class, id);
            if (catFound != null) {
                return catFound;
            }
        } finally {
            em.close();
        }
        return null;
    }

    @Override
    public List<Category> listAll() {
        EntityManager em = this.emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM Category u", Category.class).getResultList();
        } finally {
            em.close();
        }
    }

}
