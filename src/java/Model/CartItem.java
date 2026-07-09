package Model;

import javax.persistence.*;

/**
 * NOTE: this REPLACES the step-2 version of Model.CartItem, which was a
 * plain session POJO. This version is a JPA entity persisted to the
 * cart_items table, keyed by (account, productId), so the cart survives
 * logout and is tied to the account rather than the browser session.
 */
@Entity
@Table(name = "cart_items")
public class CartItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "account")
    private String account;

    @Column(name = "productId")
    private String productId;

    @Column(name = "quantity")
    private int quantity;

    public CartItem() {
    }

    public CartItem(String account, String productId, int quantity) {
        this.account = account;
        this.productId = productId;
        this.quantity = quantity;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
}
