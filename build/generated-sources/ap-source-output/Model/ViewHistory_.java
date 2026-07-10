package Model;

import java.util.Date;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.7.9.v20210604-rNA", date="2026-07-10T12:26:00")
@StaticMetamodel(ViewHistory.class)
public class ViewHistory_ { 

    public static volatile SingularAttribute<ViewHistory, String> productId;
    public static volatile SingularAttribute<ViewHistory, Integer> priceAtView;
    public static volatile SingularAttribute<ViewHistory, Date> viewedAt;
    public static volatile SingularAttribute<ViewHistory, Integer> id;
    public static volatile SingularAttribute<ViewHistory, String> account;

}