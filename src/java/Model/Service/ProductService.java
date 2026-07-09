/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.Service;

import java.util.List;
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

    /**
     * Dynamic search/filter/sort used by both the public home page and the
     * admin product list. Any parameter can be null/empty to skip that
     * filter, so callers can reuse this single method for "list all" too.
     *
     * @param keyword        case-insensitive substring match on product name (nullable)
     * @param categoryId     exact category match (nullable)
     * @param minPrice       inclusive lower bound on price (nullable)
     * @param maxPrice       inclusive upper bound on price (nullable)
     * @param discountedOnly TRUE = only discount > 0, FALSE = only discount == 0, null = no filter
     * @param sortByPrice    "asc", "desc", or null/anything else = no explicit sort
     */
    public List<Product> search(String keyword, Integer categoryId, Integer minPrice, Integer maxPrice,
            Boolean discountedOnly, String sortByPrice) {
        EntityManager em = this.emf.createEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT p FROM Product p WHERE 1=1");

            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            if (hasKeyword) {
                jpql.append(" AND LOWER(p.productName) LIKE :keyword");
            }
            if (categoryId != null) {
                jpql.append(" AND p.type.typeId = :categoryId");
            }
            if (minPrice != null) {
                jpql.append(" AND p.price >= :minPrice");
            }
            if (maxPrice != null) {
                jpql.append(" AND p.price <= :maxPrice");
            }
            if (discountedOnly != null) {
                jpql.append(discountedOnly ? " AND p.discount > 0" : " AND p.discount = 0");
            }
            if ("asc".equalsIgnoreCase(sortByPrice)) {
                jpql.append(" ORDER BY p.price ASC");
            } else if ("desc".equalsIgnoreCase(sortByPrice)) {
                jpql.append(" ORDER BY p.price DESC");
            }

            TypedQuery<Product> query = em.createQuery(jpql.toString(), Product.class);
            if (hasKeyword) {
                query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (categoryId != null) {
                query.setParameter("categoryId", categoryId);
            }
            if (minPrice != null) {
                query.setParameter("minPrice", minPrice);
            }
            if (maxPrice != null) {
                query.setParameter("maxPrice", maxPrice);
            }

            return query.getResultList();
        } finally {
            em.close();
        }
    }

}
