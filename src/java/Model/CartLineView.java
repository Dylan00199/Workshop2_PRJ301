package Model;

/**
 * A single row for cart.jsp to render: the live Product joined with the
 * quantity stored in cart_items. Not a JPA entity - built on the fly by
 * CartService.getCartLines(). Showing the live product price (rather than
 * a snapshot from add-time) means the cart always reflects current pricing,
 * matching how ProductDetail.jsp / index.jsp already compute discounted price.
 */
public class CartLineView {

    private final Product product;
    private final int quantity;

    public CartLineView(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    public Product getProduct() {
        return product;
    }

    public int getQuantity() {
        return quantity;
    }

    public int getDiscountedPrice() {
        return (int) Math.round(product.getPrice() * (1 - product.getDiscount() / 100.0));
    }

    public int getLineTotal() {
        return getDiscountedPrice() * quantity;
    }
}
