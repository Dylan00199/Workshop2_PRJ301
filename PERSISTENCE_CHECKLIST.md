# persistence.xml checklist

I don't have your actual `persistence.xml` in this conversation, so I can't hand you
a literal diff — but here is exactly what it needs to contain after steps 1-3.
Open `src/java/META-INF/persistence.xml` (or wherever NetBeans put it) and check
each item below.

## 1. Persistence unit name

Must match what every Service class uses:

```java
private final String PERSISTENCE_NAME = "Workshop2_SE205044PU";
```

So your persistence.xml needs:

```xml
<persistence-unit name="Workshop2_SE205044PU" transaction-type="RESOURCE_LOCAL">
```

## 2. Managed classes

If your persistence.xml has `<exclude-unlisted-classes>false</exclude-unlisted-classes>`
(or omits the tag, which defaults to `false` for `RESOURCE_LOCAL` in most containers),
EclipseLink auto-discovers every `@Entity` on the classpath and you can skip to
section 3.

If instead it explicitly lists classes (common with older NetBeans-generated
persistence.xml, and required if `<exclude-unlisted-classes>true</exclude-unlisted-classes>`
is set), make sure ALL of these are present:

```xml
<class>Model.Account</class>
<class>Model.Category</class>
<class>Model.Product</class>
<class>Model.ViewHistory</class>   <!-- NEW - step 1 -->
<class>Model.Comment</class>       <!-- NEW - step 2 -->
<class>Model.CartItem</class>      <!-- NEW - step 3 (JPA entity, not the old POJO) -->
```

`Model.CartLineView` is deliberately **not** an entity (no `@Entity` annotation) —
don't add it here, it will fail to map since it has no `@Id`.

## 3. Table name collisions

Double check no other table in your schema is already named `view_history`,
`comments`, or `cart_items` for something unrelated. If your DB uses a prefix
convention (e.g. `tbl_products`), you'll need to add `@Table(name = "...")`
overrides to match — the three new entities currently assume the exact table
names created by the `sql/*.sql` scripts.

## 4. Run the three SQL scripts, in this order

```
sql/view_history.sql   (step 1)
sql/comments.sql       (step 2)
sql/cart_items.sql     (step 3)
```

All three assume `accounts` and `products` already exist (they add FKs to both).

## 5. Sanity check after deploying

Look at the GlassFish/Tomcat startup log for EclipseLink's entity-weaving output.
You should see `Model.ViewHistory`, `Model.Comment`, and `Model.CartItem` listed
among the managed types. If one is missing, that's almost always an
`exclude-unlisted-classes` or classpath issue, not a code bug.
