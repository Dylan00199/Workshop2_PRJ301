<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>List of Products</title>
        <style>
            .page-content {
                padding: 24px 32px;
            }

            /* ===== HEADER ===== */
            .page-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 20px;
            }
            h1.page-title {
                font-size: 28px;
                font-weight: 400;
                color: #222;
            }
            .btn-add {
                display: inline-block;
                padding: 7px 18px;
                background: #27ae60;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 13px;
                font-weight: 600;
                text-decoration: none;
            }
            .btn-add:hover {
                background: #1e9050;
            }

            /* ===== TABLE ===== */
            .data-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
            }
            .data-table th {
                text-align: left;
                padding: 9px 12px;
                border-bottom: 2px solid #dee2e6;
                color: #555;
                font-weight: 600;
                font-size: 13px;
                background: #f8f9fa;
                white-space: nowrap;
            }
            .data-table td {
                padding: 9px 12px;
                border-bottom: 1px solid #f0f0f0;
                vertical-align: middle;
            }
            .data-table tr:last-child td {
                border-bottom: none;
            }
            .data-table tr:hover td {
                background: #f8f9fa;
            }

            /* ===== PRODUCT THUMB ===== */
            .product-thumb {
                width: 48px;
                height: 48px;
                object-fit: cover;
                border-radius: 5px;
                background: #eee;
                display: block;
            }
            .no-img {
                width: 48px;
                height: 48px;
                background: #f0f0f0;
                border-radius: 5px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                color: #bbb;
            }

            /* ===== ALERTS ===== */
            .alert {
                padding: 10px 16px;
                border-radius: 5px;
                font-size: 13px;
                margin-bottom: 18px;
                display: flex;
                align-items: center;
                gap: 8px;
                max-width: 720px;
            }
            .alert-success {
                background: #eafaf1;
                border: 1px solid #a9dfbf;
                color: #1e8449;
            }
            .alert-error   {
                background: #fdf2f2;
                border: 1px solid #f5c6c6;
                color: #c0392b;
            }

            /* ===== BADGES ===== */
            .badge-cat {
                display: inline-block;
                padding: 2px 8px;
                background: #e8f4fd;
                color: #1a6fa0;
                border-radius: 10px;
                font-size: 12px;
                font-weight: 600;
            }
            .price-cell {
                font-weight: 700;
                color: #e74c3c;
                white-space: nowrap;
            }
            .price-original {
                font-size: 12px;
                color: #aaa;
                text-decoration: line-through;
                display: block;
            }
            .discount-badge {
                display: inline-block;
                background: #e74c3c;
                color: #fff;
                font-size: 11px;
                padding: 1px 5px;
                border-radius: 3px;
                font-weight: 600;
                margin-left: 4px;
            }

            /* ===== ACTION BUTTONS ===== */
            .btn {
                display: inline-block;
                padding: 4px 10px;
                border: none;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                color: #fff;
                margin-right: 3px;
                white-space: nowrap;
            }
            .btn-update {
                background: #2980b9;
            }
            .btn-update:hover {
                background: #1f6fa0;
            }
            .btn-delete {
                background: #e74c3c;
            }
            .btn-delete:hover {
                background: #c0392b;
            }

            /* ===== EMPTY ===== */
            .empty-row td {
                text-align: center;
                padding: 48px 0;
                color: #aaa;
                font-size: 14px;
            }
            /* ===== PRODUCT NAME ===== */
            .product-name {
                font-weight: 600;
                color: #222;
            }
            .product-brief {
                font-size: 12px;
                color: #888;
                margin-top: 2px;
                max-width: 200px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <c:if test="${not empty success_msg}">
            <div class="alert alert-success">${success_msg}</div>
        </c:if>
        <c:if test="${not empty error_msg}">
            <div class="alert alert-error">${error_msg}</div>
        </c:if>

        <div class="page-content">
            <div class="page-header">
                <h1 class="page-title">List of products</h1>
                <a href="addProduct.jsp" class="btn-add">+ Add product</a>
            </div>

            <%-- ===== TABLE ===== --%>
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width:36px">#</th>
                        <th style="width:56px">Image</th>
                        <th>Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Discount</th>
                        <th>Post date</th>
                        <th style="width:140px">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <%-- Kiểm tra list products có rỗng hay không --%>
                        <c:when test="${empty products}">
                            <tr class="empty-row">
                                <td colspan="8">No products found.</td>
                            </tr>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="p" items="${products}" varStatus="loop">
                                <tr>
                                    <td>${loop.count}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty p.productImage}">
                                                <img class="product-thumb"
                                                     src="${pageContext.request.contextPath}${p.productImage}"
                                                     alt="<c:out value='${p.productName}'/>"
                                                     loading="lazy"
                                                     onerror="this.style.display='none'">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="no-img">N/A</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="product-name"><c:out value="${p.productName}"/></div>
                                        <div class="product-brief"><c:out value="${p.brief}"/></div>
                                    </td>

                                    <td><span class="badge-cat"><c:out value="${p.type.categoryName}"/></span></td>

                                    <td class="price-cell">
                                        <fmt:formatNumber value="${p.price * (1 - p.discount / 100.0)}" pattern="#,##0"/> VND
                                        <c:if test="${p.discount > 0}">
                                            <span class="price-original">
                                                <fmt:formatNumber value="${p.price}" pattern="#,##0"/> VND
                                            </span>
                                        </c:if>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${p.discount > 0}">
                                                <span class="discount-badge">-${p.discount}%</span>
                                            </c:when>
                                            <c:otherwise>&#8212;</c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>${p.postedDate}</td>

                                    <%-- Always render the Action cell so row/header column counts stay aligned,
                                         regardless of role. Buttons themselves are still admin-only. --%>
                                    <c:choose>
                                        <c:when test="${not empty currentRole and currentRole.toLowerCase() eq 'admin'}">
                                            <td>
                                                <a href="updateProduct.jsp?id=${p.productId}" class="btn btn-update">Update</a>
                                                <a href="ProductController?action=deleteProduct&amp;id=${p.productId}"
                                                   class="btn btn-delete"
                                                   onclick="return confirm('Delete product &quot;<c:out value="${p.productName}"/>&quot;?')">Delete</a>
                                            </td>
                                        </c:when>
                                        <c:otherwise>
                                            <td>&#8212;</td>
                                        </c:otherwise>
                                    </c:choose>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

    </body>
</html>
