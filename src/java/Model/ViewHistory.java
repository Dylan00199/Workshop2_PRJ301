package Model;

import java.util.Date;
import javax.persistence.*;

@Entity
@Table(name = "view_history")
public class ViewHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @Column(name = "account")
    private String account;

    @Column(name = "productId")
    private String productId;

    @Column(name = "priceAtView")
    private int priceAtView;

    @Column(name = "viewedAt")
    private Date viewedAt;

    public ViewHistory() {
    }

    public ViewHistory(String account, String productId, int priceAtView, Date viewedAt) {
        this.account = account;
        this.productId = productId;
        this.priceAtView = priceAtView;
        this.viewedAt = viewedAt;
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

    public int getPriceAtView() {
        return priceAtView;
    }

    public void setPriceAtView(int priceAtView) {
        this.priceAtView = priceAtView;
    }

    public Date getViewedAt() {
        return viewedAt;
    }

    public void setViewedAt(Date viewedAt) {
        this.viewedAt = viewedAt;
    }
}
