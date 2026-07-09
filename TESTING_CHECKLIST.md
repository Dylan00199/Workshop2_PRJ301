# Manual test checklist

Run through these after deploying. Grouped by the feature area they exercise.

## 1. Concurrent login prevention (SessionManager + SessionTrackingListener)

- [ ] Log in as the same account in two different browsers (or one normal + one incognito window).
- [ ] The **first** browser should get silently logged out the next time it makes a request
      (any click redirects to `login.jsp`, since its session was invalidated).
- [ ] The **second** browser continues working normally.
- [ ] Log out from the second browser, then log back in as the same account — should succeed
      with no "already logged in" false positive (confirms `SessionManager.onSessionDestroyed`
      correctly clears the registry entry on explicit logout, not just on the "kick out" path).
- [ ] Let a session sit idle past `session-timeout` (or force it via
      `session.setMaxInactiveInterval(1)` temporarily for testing) — confirm
      `SessionTrackingListener.sessionDestroyed` fires and the account can log in
      elsewhere afterward without being blocked.

## 2. Admin area security filter (AdminAuthFilter)

- [ ] Not logged in, navigate directly to `Admin.jsp` — redirected to `login.jsp`.
- [ ] Logged in as a non-admin (`roleInSystem` 2 or 3), navigate to `Admin.jsp` —
      redirected to `AccessDenied.jsp`.
- [ ] Logged in as admin (`roleInSystem == 1`) — `Admin.jsp` loads normally.

## 3. Search / filter / sort (ProductService.search + ProductController)

On both `index.jsp` (public) and `listProducts.jsp` (admin):

- [ ] Search by partial product name, case-insensitive — matches expected products.
- [ ] Filter by category alone.
- [ ] Filter by min price only, max price only, and both together.
- [ ] Filter "Discounted only" — every result has `discount > 0`.
- [ ] Filter "No discount" — every result has `discount == 0`.
- [ ] Sort by price ascending / descending.
- [ ] Combine 3+ filters at once (e.g. keyword + category + price range + sort) —
      confirm the JPQL `AND` chain in `ProductService.search()` behaves as expected.
- [ ] "Reset" link clears all filters and returns to the unfiltered list.
- [ ] Search with zero matches shows the empty state, not an error.

## 4. Product detail page + comments

- [ ] Click a product card from `index.jsp` — lands on `ProductDetail.jsp` with correct data.
- [ ] Not logged in: comment form is hidden, "log in to comment" prompt shows instead.
- [ ] Logged in: submit a comment — appears immediately in the list, newest first.
- [ ] Submit an empty/whitespace-only comment — rejected (redirects back without inserting).
- [ ] View a product while logged in — confirm a row appears in `Admin.jsp`'s
      "Product view history" panel afterward.
- [ ] View a product while NOT logged in — confirm no row is recorded (anonymous
      views are intentionally not tracked, since segmentation is account-based).

## 5. Shopping cart (DB-backed, CartController + CartService)

- [ ] Not logged in, try to add to cart — redirected to `login.jsp`.
- [ ] Logged in, add a product — appears in `cart.jsp`, navbar badge count increments.
- [ ] Add the same product again — quantity increments on the existing row
      rather than creating a duplicate line (tests `CartService.addToCart`'s
      find-or-create logic).
- [ ] Update quantity to a valid number — line total and grand total recalculate.
- [ ] Update quantity to `0` or a negative number — row is removed entirely.
- [ ] Remove a single item — disappears from the table, badge count decrements.
- [ ] Clear cart — table shows the empty state, badge disappears.
- [ ] Log out and log back in — cart contents persist (confirms it's DB-backed,
      not session-based).
- [ ] Add a product to cart, then delete that product from the admin panel,
      then reload `cart.jsp` — the now-orphaned cart row is silently skipped
      rather than throwing an error (tests the `null` check in
      `CartService.getCartLines`).

## 6. Income segmentation (Admin.jsp)

- [ ] As a non-admin account, view several products priced under 5,000,000 VND.
      Log in as admin, check `Admin.jsp` — that account should show as **Low Income**.
- [ ] Same account, now view a product priced above 15,000,000 VND enough times
      to shift the average — segment should recompute to **Middle** or **High**
      depending on the new average (confirms `SegmentationUtils.classify` runs
      against a live `AVG()` query, not a stale/cached value).
- [ ] Confirm the boundary values behave as specified: exactly 5,000,000 →
      Middle (not Low, since the rule is `< 5_000_000`), exactly 15,000,000 →
      Middle (not High, since the rule is `<= 15_000_000`).

## 7. Regression check on existing features

- [ ] Add/update/delete category still works (`CategoryController` untouched).
- [ ] Add/update/delete product still works, including image upload.
- [ ] Account list, activate/deactivate/delete account still work.
- [ ] Login lockout after repeated wrong passwords still works.
- [ ] `listProducts.jsp`'s admin-only Update/Delete buttons now correctly check
      `sessionScope.login.roleInSystem == 1` — this was silently broken before
      (the original template referenced an undefined `currentRole` variable, so
      those buttons never rendered for anyone). Confirm they now show for admins
      and stay hidden for everyone else.
