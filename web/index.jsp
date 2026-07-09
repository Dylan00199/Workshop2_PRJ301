<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>

<c:if test="${empty list && empty param.keyword && empty param.categoryId && empty param.minPrice && empty param.maxPrice && empty param.discountFilter && empty param.sortByPrice}">
    <c:redirect url="ProductController?action=home" />
</c:if>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Product Portfolio</title>
        <style>
            .page-content { padding: 28px 32px; }

            .section-title { font-size: 24px; font-weight: 400; color: #222; margin-bottom: 8px; }
            .section-sub { font-size: 13px; color: #888; margin-bottom: 20px; }

            /* ===== SEARCH & FILTER BAR ===== */
            .filter-bar {
                display: flex; flex-wrap: wrap; align-items: end; gap: 12px;
                padding: 16px 18px; background: #f8f9fa; border: 1px solid #eee; border-radius: 8px;
                margin-bottom: 24px;
            }
            .filter-group { display: flex; flex-direction: column; gap: 4px; }
            .filter-group label { font-size: 11px; font-weight: 700; text-transform: uppercase; color: #999; letter-spacing: 0.3px; }
            .filter-group input[type="text"],
            .filter-group input[type="number"],
            .filter-group select {
                padding: 7px 10px; font-size: 13px; border: 1px solid #ccc; border-radius: 5px; outline: none;
                min-width: 110px;
            }
            .filter-group input:focus, .filter-group select:focus { border-color: #2980b9; }
            .filter-price-range { display: flex; align-items: center; gap: 6px; }
            .filter-price-range span { color: #aaa; font-size: 12px; }
            .filter-actions { display: flex; gap: 8px; }
            .btn-filter { padding: 8px 20px; background: #2980b9; color: #fff; border: none; border-radius: 5px; font-size: 13px; font-weight: 600; cursor: pointer; }
            .btn-filter:hover { background: #1f6fa0; }
            .btn-reset { padding: 8px 16px; background: #fff; color: #666; border: 1px solid #ccc; border-radius: 5px; font-size: 13px; cursor: pointer; text-decoration: none; }
            .btn-reset:hover { background: #f0f0f0; }

            /* ===== PRODUCT GRID ===== */
            .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 20px; }

            .product-card {
                border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden; background: #fff;
                transition: box-shadow 0.2s; text-decoration: none; color: inherit; display: block;
            }
            .product-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.12); }

            .card-img { width: 100%; height: 160px; object-fit: cover; background: #f5f5f5; display: flex; align-items: center; justify-content: center; color: #bbb; font-size: 13px; }
            .card-img img { width: 100%; height: 160px; object-fit: cover; }

            .card-body { padding: 12px 14px; }
            .card-type { font-size: 11px; text-transform: uppercase; color: #2980b9; font-weight: 600; letter-spacing: 0.5px; margin-bottom: 4px; }
            .card-name { font-size: 15px; font-weight: 600; color: #222; margin-bottom: 6px; line-height: 1.3; }
            .card-brief {
                font-size: 13px; color: #666; margin-bottom: 10px; line-height: 1.5;
                display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
            }
            .card-footer { display: flex; align-items: center; justify-content: space-between; margin-top: 6px; }
            .card-price { font-size: 16px; font-weight: 700; color: #e74c3c; }
            .card-original-price { font-size: 12px; color: #aaa; text-decoration: line-through; margin-right: 4px; }
            .card-discount { font-size: 11px; background: #e74c3c; color: #fff; padding: 2px 6px; border-radius: 3px; font-weight: 600; }
            .card-postdate { font-size: 11px; color: #aaa; margin-top: 6px; }

            .empty-state { text-align: center; padding: 60px 0; color: #aaa; font-size: 15px; }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">
            <h1 class="section-title">Product Portfolio</h1>
            <p class="section-sub">Browse our latest products</p>

            <%-- ===== SEARCH & FILTER BAR ===== --%>
            <form action="ProductController" method="GET" class="filter-bar">
                <input type="hidden" name="action" value="home">

                <div class="filter-group">
                    <label>Search</label>
                    <input type="text" name="keyword" placeholder="Product name..."
                           value="${param.keyword}">
                </div>

                <div class="filter-group">
                    <label>Category</label>
                    <select name="categoryId">
                        <option value="">All categories</option>
                        <c:forEach var="c" items="${cats}">
                            <option value="${c.typeId}" ${param.categoryId == c.typeId ? 'selected' : ''}>
                                <c:out value="${c.categoryName}"/>
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="filter-group">
                    <label>Price range (VND)</label>
                    <div class="filter-price-range">
                        <input type="number" name="minPrice" min="0" placeholder="Min" value="${param.minPrice}">
                        <span>&#8212;</span>
                        <input type="number" name="maxPrice" min="0" placeholder="Max" value="${param.maxPrice}">
                    </div>
                </div>

                <div class="filter-group">
                    <label>Discount</label>
                    <select name="discountFilter">
                        <option value="">All products</option>
                        <option value="discounted" ${param.discountFilter == 'discounted' ? 'selected' : ''}>Discounted only</option>
                        <option value="noDiscount" ${param.discountFilter == 'noDiscount' ? 'selected' : ''}>No discount</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label>Sort by price</label>
                    <select name="sortByPrice">
                        <option value="">Default</option>
                        <option value="asc" ${param.sortByPrice == 'asc' ? 'selected' : ''}>Low to high</option>
                        <option value="desc" ${param.sortByPrice == 'desc' ? 'selected' : ''}>High to low</option>
                    </select>
                </div>

                <div class="filter-actions">
                    <button type="submit" class="btn-filter">Apply</button>
                    <a href="ProductController?action=home" class="btn-reset">Reset</a>
                </div>
            </form>

            <c:choose>
                <c:when test="${empty list}">
                    <div class="empty-state">No products found.</div>
                </c:when>
                <c:otherwise>
                    <div class="product-grid">
                        <c:forEach var="p" items="${list}">

                            <fmt:formatNumber var="discountedPrice"
                                             value="${p.price * (1 - p.discount / 100.0)}"
                                             type="number" maxFractionDigits="0" groupingUsed="true" />
                            <fmt:formatNumber var="originalPrice"
                                             value="${p.price}"
                                             type="number" maxFractionDigits="0" groupingUsed="true" />

                            <a class="product-card" href="ProductController?action=detail&id=${p.productId}">
                                <div class="card-img">
                                    <img src="${pageContext.request.contextPath}${p.productImage}"
                                         alt="<c:out value='${p.productName}'/>"
                                         onerror="this.parentElement.textContent='No image'">
                                </div>

                                <div class="card-body">
                                    <div class="card-type"><c:out value="${p.type.categoryName}"/></div>
                                    <div class="card-name"><c:out value="${p.productName}"/></div>
                                    <div class="card-brief"><c:out value="${p.brief}"/></div>

                                    <div class="card-footer">
                                        <div>
                                            <c:if test="${p.discount gt 0}">
                                                <span class="card-original-price">${originalPrice} VND</span>
                                            </c:if>
                                            <span class="card-price">${discountedPrice} VND</span>
                                        </div>
                                        <c:if test="${p.discount gt 0}">
                                            <span class="card-discount">-${p.discount}%</span>
                                        </c:if>
                                    </div>

                                    <div class="card-postdate">Posted: <c:out value="${p.postedDate}"/></div>
                                </div>
                            </a>

                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </body>
</html>
