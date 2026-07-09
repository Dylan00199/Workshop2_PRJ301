package Model;

import Model.Account;
import Model.Category;
import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.7.9.v20210604-rNA", date="2026-07-09T21:45:10")
@StaticMetamodel(Product.class)
public class Product_ { 

    public static volatile SingularAttribute<Product, String> brief;
    public static volatile SingularAttribute<Product, String> unit;
    public static volatile SingularAttribute<Product, String> productImage;
    public static volatile SingularAttribute<Product, String> productId;
    public static volatile SingularAttribute<Product, Integer> price;
    public static volatile SingularAttribute<Product, Integer> discount;
    public static volatile SingularAttribute<Product, Category> type;
    public static volatile SingularAttribute<Product, String> productName;
    public static volatile SingularAttribute<Product, Account> account;
    public static volatile SingularAttribute<Product, Date> postedDate;

}