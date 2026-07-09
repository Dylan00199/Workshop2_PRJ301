<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Shopping Cart</title>
        <style>
            .page-content {
                padding: 24px 32px;
            }
            h1.page-title {
                font-size: 28px;
                font-weight: 400;
                color: #222;
                margin-bottom: 20px;
            }

            .alert {
                padding: 10px 16px;
                border-radius: 5px;
                font-size: 13px;
                margin-bottom: 18px;
                display: flex;
                align-items: center;
                gap: 8px;
                max-width: 960px;
            }
            .alert-success {
                background: #eafaf1;
                border: 1px solid #a9dfbf;
                color: #1e8449;
            }

            .cart-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
                max-width: 960px;
            }
            .cart-table th {
                text-align: left;
                padding: 9px 12px;
                border-bottom: 2px solid #dee2e6;
                color: #555;
                font-weight: 600;
                font-size: 13px;
                background: #f8f9fa;
            }
            .cart-table td {
                padding: 10px 12px;
                border-bottom: 1px solid #f0f0f0;
                vertical-align: middle;
            }

            .cart-thumb {
                width: 56px;
                height: 56px;
                object-fit: cover;
                border-radius: 5px;
                background: #eee;
                display: block;
            }
            .no-img {
                width: 56px;
                height: 56px;
                background: #f0f0f0;
                border-radius: 5px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                color: #bbb;
            }

            .qty-form {
                display: flex;
                align-items: center;
                gap: 6px;
            }
            .qty-form input[type="number"] {
                width: 60px;
                padding: 5px 8px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 13px;
            }
            .btn {
                display: inline-block;
                padding: 5px 12px;
                border: none;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                color: #fff;
            }
            .btn-update {
                background: #2980b9;
            }
            .btn-update:hover {
                background: #1f6fa0;
            }
            .btn-remove {
                background: #e74c3c;
            }
            .btn-remove:hover {
                background: #c0392b;
            }

            .line-total {
                font-weight: 700;
                color: #e74c3c;
                white-space: nowrap;
            }

            .cart-summary {
                max-width: 960px;
                margin-top: 20px;
                padding: 18px 20px;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .grand-total {
                font-size: 20px;
                font-weight: 700;
                color: #e74c3c;
            }
            .cart-actions {
                display: flex;
                gap: 10px;
            }
            .btn-clear {
                padding: 8px 18px;
                background: #fff;
                color: #555;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 13px;
                cursor: pointer;
            }
            .btn-clear:hover {
                background: #f5f5f5;
            }
            .btn-checkout {
                padding: 8px 24px;
                background: #27ae60;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-checkout:hover {
                background: #1e9050;
            }

            .empty-state {
                text-align: center;
                padding: 60px 0;
                color: #aaa;
                font-size: 15px;
            }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">
            <h1 class="page-title">Shopping cart</h1>

            <c:if test="${param.checkout == 'success'}">
                <div class="alert alert-success">
                    &#10003; Your order has been placed successfully. Thank you for shopping with us!
                </div>
            </c:if>

            <c:set var="grandTotal" value="${0}" />

            <c:choose>
                <c:when test="${empty cartLines}">
                    <div class="empty-state">Your cart is empty. <a href="index.jsp">Continue shopping &#8594;</a></div>
                </c:when>
                <c:otherwise>
                    <table class="cart-table">
                        <thead>
                            <tr>
                                <th style="width:64px">Image</th>
                                <th>Product</th>
                                <th style="width:120px">Unit price</th>
                                <th style="width:150px">Quantity</th>
                                <th style="width:120px">Subtotal</th>
                                <th style="width:80px">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="line" items="${cartLines}">
                                <c:set var="grandTotal" value="${grandTotal + line.lineTotal}" />
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty line.product.productImage}">
                                                <img class="cart-thumb"
                                                     src="${pageContext.request.contextPath}${line.product.productImage}"
                                                     alt="<c:out value='${line.product.productName}'/>"
                                                     onerror="this.style.display='none'">
                                            </c:when>
                                            <c:otherwise><div class="no-img">N/A</div></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="ProductController?action=detail&id=${line.product.productId}" style="color:#222; text-decoration:none;">
                                            <c:out value="${line.product.productName}"/>
                                        </a>
                                    </td>
                                    <td><fmt:formatNumber value="${line.discountedPrice}" pattern="#,##0"/> VND</td>
                                    <td>
                                        <form action="CartController" method="POST" class="qty-form">
                                            <input type="hidden" name="action" value="updateQuantity">
                                            <input type="hidden" name="productId" value="${line.product.productId}">
                                            <input type="number" name="quantity" min="1" value="${line.quantity}">
                                            <button type="submit" class="btn btn-update">Update</button>
                                        </form>
                                    </td>
                                    <td class="line-total"><fmt:formatNumber value="${line.lineTotal}" pattern="#,##0"/> VND</td>
                                    <td>
                                        <form action="CartController" method="POST">
                                            <input type="hidden" name="action" value="removeItem">
                                            <input type="hidden" name="productId" value="${line.product.productId}">
                                            <button type="submit" class="btn btn-remove"
                                                    onclick="return confirm('Remove this item from cart?')">Remove</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div class="cart-summary">
                        <div>Total: <span class="grand-total"><fmt:formatNumber value="${grandTotal}" pattern="#,##0"/> VND</span></div>
                        <div class="cart-actions">
                            <form action="CartController" method="POST">
                                <input type="hidden" name="action" value="clearCart">
                                <button type="submit" class="btn-clear" onclick="return confirm('Clear the entire cart?')">Clear cart</button>
                            </form>
                            <form action="CartController" method="POST">
                                <input type="hidden" name="action" value="checkout">
                                <button type="submit" class="btn-checkout"
                                        onclick="return confirm('Place this order? Your cart will be cleared.')">Checkout</button>
                            </form>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </body>
</html>
