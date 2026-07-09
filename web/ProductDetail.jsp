<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:if test="${empty p}">
    <c:redirect url="ProductController?action=home" />
</c:if>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title><c:out value="${p.productName}"/> - Product Detail</title>
        <style>
            .page-content { padding: 28px 32px; max-width: 1000px; }
            .breadcrumb { font-size: 13px; color: #aaa; margin-bottom: 16px; }
            .breadcrumb a { color: #2980b9; text-decoration: none; }
            .breadcrumb a:hover { text-decoration: underline; }
            .breadcrumb span { margin: 0 6px; }

            .detail-layout { display: grid; grid-template-columns: 380px 1fr; gap: 32px; margin-bottom: 40px; }

            .detail-img { width: 100%; height: 320px; object-fit: cover; border-radius: 8px; background: #f5f5f5; }
            .no-img-box { width: 100%; height: 320px; background: #f5f5f5; border: 1px dashed #ccc; border-radius: 8px;
                          display: flex; align-items: center; justify-content: center; color: #bbb; font-size: 13px; }

            .detail-type { font-size: 12px; text-transform: uppercase; color: #2980b9; font-weight: 700; letter-spacing: 0.5px; margin-bottom: 8px; }
            .detail-name { font-size: 26px; font-weight: 700; color: #222; margin-bottom: 12px; }
            .detail-price-row { display: flex; align-items: center; gap: 12px; margin-bottom: 18px; }
            .detail-price { font-size: 26px; font-weight: 700; color: #e74c3c; }
            .detail-original { font-size: 15px; color: #aaa; text-decoration: line-through; }
            .detail-discount { font-size: 13px; background: #e74c3c; color: #fff; padding: 3px 8px; border-radius: 4px; }

            .detail-brief { font-size: 14px; color: #555; line-height: 1.7; margin-bottom: 20px; }

            .detail-meta { display: grid; grid-template-columns: 110px 1fr; row-gap: 8px; font-size: 14px; margin-bottom: 24px; }
            .detail-meta dt { color: #888; font-weight: 600; }
            .detail-meta dd { color: #333; margin: 0; }

            .add-cart-form { display: flex; align-items: center; gap: 10px; }
            .add-cart-form input[type="number"] {
                width: 70px; padding: 8px 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px;
            }
            .btn-add-cart {
                padding: 9px 24px; background: #27ae60; color: #fff; border: none; border-radius: 5px;
                font-size: 14px; font-weight: 600; cursor: pointer;
            }
            .btn-add-cart:hover { background: #1e9050; }

            /* ===== COMMENTS ===== */
            .comments-section h2 { font-size: 18px; font-weight: 700; color: #222; margin-bottom: 16px; }

            .comment-form { margin-bottom: 24px; }
            .comment-form textarea {
                width: 100%; min-height: 80px; padding: 10px 12px; font-size: 14px; border: 1px solid #ccc;
                border-radius: 6px; font-family: Arial, sans-serif; resize: vertical; box-sizing: border-box;
            }
            .comment-form button {
                margin-top: 8px; padding: 8px 22px; background: #2980b9; color: #fff; border: none;
                border-radius: 5px; font-size: 14px; font-weight: 600; cursor: pointer;
            }
            .comment-form button:hover { background: #1f6fa0; }
            .comment-login-hint { font-size: 13px; color: #888; margin-bottom: 20px; }
            .comment-login-hint a { color: #2980b9; text-decoration: none; }

            .comment-item { border-bottom: 1px solid #f0f0f0; padding: 14px 0; }
            .comment-item:last-child { border-bottom: none; }
            .comment-author { font-size: 13px; font-weight: 700; color: #333; }
            .comment-date { font-size: 12px; color: #aaa; margin-left: 8px; }
            .comment-content { font-size: 14px; color: #444; margin-top: 4px; line-height: 1.5; }

            .no-comments { color: #aaa; font-size: 14px; padding: 12px 0; }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">

            <div class="breadcrumb">
                <a href="index.jsp">Home</a>
                <span>&#8250;</span> <c:out value="${p.productName}"/>
            </div>

            <div class="detail-layout">
                <div>
                    <c:choose>
                        <c:when test="${not empty p.productImage}">
                            <img class="detail-img" src="${pageContext.request.contextPath}${p.productImage}"
                                 alt="<c:out value='${p.productName}'/>"
                                 onerror="this.outerHTML='<div class=&quot;no-img-box&quot;>No image</div>'">
                        </c:when>
                        <c:otherwise>
                            <div class="no-img-box">No image</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div>
                    <div class="detail-type"><c:out value="${p.type.categoryName}"/></div>
                    <h1 class="detail-name"><c:out value="${p.productName}"/></h1>

                    <fmt:formatNumber var="discountedPrice" value="${p.price * (1 - p.discount / 100.0)}"
                                       type="number" maxFractionDigits="0" groupingUsed="true" />
                    <fmt:formatNumber var="originalPrice" value="${p.price}"
                                       type="number" maxFractionDigits="0" groupingUsed="true" />

                    <div class="detail-price-row">
                        <span class="detail-price">${discountedPrice} VND</span>
                        <c:if test="${p.discount gt 0}">
                            <span class="detail-original">${originalPrice} VND</span>
                            <span class="detail-discount">-${p.discount}%</span>
                        </c:if>
                    </div>

                    <p class="detail-brief"><c:out value="${p.brief}"/></p>

                    <dl class="detail-meta">
                        <dt>Unit</dt>      <dd><c:out value="${p.unit}"/></dd>
                        <dt>Post date</dt> <dd><c:out value="${p.postedDate}"/></dd>
                    </dl>

                    <form action="CartController" method="POST" class="add-cart-form">
                        <input type="hidden" name="action" value="addToCart">
                        <input type="hidden" name="productId" value="${p.productId}">
                        <input type="number" name="quantity" min="1" value="1">
                        <button type="submit" class="btn-add-cart">Add to cart</button>
                    </form>
                </div>
            </div>

            <div class="comments-section">
                <h2>Comments (${comments.size()})</h2>

                <c:choose>
                    <c:when test="${not empty sessionScope.login}">
                        <form action="ProductController" method="POST" class="comment-form">
                            <input type="hidden" name="action" value="addComment">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <textarea name="content" placeholder="Share your thoughts about this product..." required></textarea><br>
                            <button type="submit">Post comment</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <p class="comment-login-hint">
                            <a href="login.jsp">Log in</a> to leave a comment.
                        </p>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${empty comments}">
                        <p class="no-comments">No comments yet — be the first to share your thoughts.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="c" items="${comments}">
                            <div class="comment-item">
                                <span class="comment-author"><c:out value="${c.account}"/></span>
                                <span class="comment-date"><c:out value="${c.createdAt}"/></span>
                                <div class="comment-content"><c:out value="${c.content}"/></div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

    </body>
</html>
