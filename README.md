# Workshop2 - Step 3 / Final export

This package assumes you've **already merged** the step-1 and step-2 exports into
your project. It only contains what's new or changed from step 3 onward.

## Merge order

1. Steps 1 and 2 (already done on your end).
2. This package (step 3):
   - Run `sql/cart_items.sql`.
   - Overwrite `Model/CartItem.java` — **important**: this replaces the step-2
     session POJO with a JPA entity. If you still have the old POJO version,
     it must be fully overwritten, not merged.
   - Add `Model/CartLineView.java` (new).
   - Add `Model/Service/CartService.java` (new).
   - Overwrite `Controller/CartController.java` (now DB-backed, requires login).
   - Overwrite `Controller/loginController.java` (adds `cartCount` session priming).
   - Overwrite `web/cart.jsp` (renders `cartLines` instead of `sessionScope.cart`).
   - Overwrite `web/navbar.jsp` (badge now reads `sessionScope.cartCount`).
   - Overwrite `web/listProducts.jsp` (adds the search/filter/sort bar, fixes
     the dead `currentRole` check on the admin action buttons).
3. Read `PERSISTENCE_CHECKLIST.md` and confirm `Model.CartItem` is registered
   correctly (and that it's the entity version, not lingering as the old POJO).
4. Work through `TESTING_CHECKLIST.md` before considering the workshop done.

## Full file manifest (this package only)

```
src/java/Model/CartItem.java              (replaces step-2 POJO — now a JPA entity)
src/java/Model/CartLineView.java          (new)
src/java/Model/Service/CartService.java   (new)
src/java/Controller/CartController.java   (replaces step-2 version — DB-backed)
src/java/Controller/loginController.java  (replaces step-1 version — adds cartCount)
web/cart.jsp                              (replaces step-2 version)
web/navbar.jsp                            (replaces step-2 version)
web/listProducts.jsp                      (replaces original — adds filter bar)
sql/cart_items.sql                        (new)
PERSISTENCE_CHECKLIST.md                  (new — read this before deploying)
TESTING_CHECKLIST.md                      (new — manual QA pass)
```

## Cumulative feature summary (all 3 steps)

**Public area**
- Home page: search bar, category/price-range/discount filters, price sort,
  product cards linking to a real detail page.
- Product detail page: full info + comment thread (login required to post).
- Shopping cart: DB-backed, tied to account, survives logout.

**Admin area**
- `Admin.jsp`, protected by `AdminAuthFilter`: raw product-view history table,
  and a per-account income segmentation table (Low / Middle / High based on
  average viewed product price).
- Admin product list (`listProducts.jsp`) now has the same filter bar as the
  public home page.

**Cross-cutting**
- `AdminAuthFilter` — blocks unauthenticated and non-admin access to `Admin.jsp`.
- `SessionManager` + `SessionTrackingListener` — one active session per account;
  a second login invalidates the first.
- `ViewHistoryService` + `SegmentationUtils` — records every logged-in product
  view and classifies accounts into income segments.

## Known simplifications (flagging, not hiding)

- No checkout/payment flow — "Checkout" is a placeholder alert in `cart.jsp`.
- Comments have no edit/delete/moderation — append-only, matching workshop scope.
- Income segmentation recomputes live on every `Admin.jsp` load (fine at
  workshop data volumes; would need caching or a materialized view at real scale).
- Concurrent-login handling **kicks out the old session** rather than rejecting
  the new login. If your rubric wants "reject new login" instead, that's a
  ~5-line change in `loginController.doPost` — say the word and I'll swap it.
