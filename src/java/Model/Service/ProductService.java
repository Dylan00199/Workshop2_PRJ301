/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.Service;

import java.util.List;
import Model.Product;
import Model.Product;
import javax.persistence.*;

public class ProductService implements Accessible<Product> {

    private EntityManagerFactory emf;
    private final String PERSISTENCE_NAME = "Workshop2_SE205044PU";

    public ProductService() {
        this.emf = Persistence.createEntityManagerFactory(PERSISTENCE_NAME);
    }

    @Override
    public void close() {
        if (this.emf != null && this.emf.isOpen()) {
            this.emf.close();
        }
    }

    @Override
    public int insertRec(Product obj) {
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
    public int updateRec(Product obj) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        try {
            Product ProductUpdate = em.find(Product.class, obj.getProductId());
            if (ProductUpdate != null) {
                em.getTransaction().begin();
                em.merge(ProductUpdate);
                em.getTransaction().commit();
                result = 1;
            }
        } finally {
            em.close();
        }
        return result;
    }

    @Override
    public int deleteRec(Product obj) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        try {
            Product ProductDelete = em.find(Product.class, obj.getProductId());
            if (ProductDelete != null) {
                em.getTransaction().begin();
                em.remove(ProductDelete);
                em.getTransaction().commit();
                result = 1;
            }
        } finally {
            em.close();
        }
        return result;
    }

    @Override
    public Product getObjectById(String id) {
        EntityManager em = this.emf.createEntityManager();
        int result = 0;
        try {
            Product ProductFound = em.find(Product.class, id);
            if (ProductFound != null) {
                return ProductFound;
            }
        } finally {
            em.close();
        }
        return null;
    }

    @Override
    public List<Product> listAll() {
        EntityManager em = this.emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM Product u", Product.class).getResultList();
        } finally {
            em.close();
        }
    }

}
