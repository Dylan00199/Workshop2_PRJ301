<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Category" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>List of Categories</title>
        <style>
            .page-content {
                padding: 24px 32px;
            }

            /* ===== HEADER ROW ===== */
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
                cursor: pointer;
            }
            .btn-add:hover {
                background: #1e9050;
            }

            /* ===== SEARCH BAR ===== */
            .search-bar {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 18px;
            }
            .search-bar input[type="text"] {
                padding: 6px 12px;
                font-size: 13px;
                border: 1px solid #ccc;
                border-radius: 5px;
                width: 260px;
                outline: none;
            }
            .search-bar input[type="text"]:focus {
                border-color: #2980b9;
            }
            .btn-search {
                padding: 6px 16px;
                font-size: 13px;
                border: 1px solid #bbb;
                border-radius: 5px;
                background: #fff;
                cursor: pointer;
            }
            .btn-search:hover {
                background: #f0f0f0;
            }

            /* ===== TABLE ===== */
            .data-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
            }
            .data-table th {
                text-align: left;
                padding: 9px 14px;
                border-bottom: 2px solid #dee2e6;
                color: #555;
                font-weight: 600;
                font-size: 13px;
                background: #f8f9fa;
            }
            .data-table th:first-child {
                border-radius: 5px 0 0 0;
            }
            .data-table th:last-child  {
                border-radius: 0 5px 0 0;
            }
            .data-table td {
                padding: 10px 14px;
                border-bottom: 1px solid #f0f0f0;
                vertical-align: middle;
            }
            .data-table tr:last-child td {
                border-bottom: none;
            }
            .data-table tr:hover td {
                background: #f8f9fa;
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

            /* ===== MEMO CELL ===== */
            .memo-cell {
                max-width: 360px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                color: #666;
                font-size: 13px;
            }

            /* ===== ACTION BUTTONS ===== */
            .btn {
                display: inline-block;
                padding: 4px 12px;
                border: none;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                text-decoration: none;
                color: #fff;
                margin-right: 4px;
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

            /* ===== EMPTY STATE ===== */
            .empty-row td {
                text-align: center;
                padding: 48px 0;
                color: #aaa;
                font-size: 14px;
            }

            /* ===== PAGINATION ===== */
            .pagination {
                display: flex;
                align-items: center;
                gap: 4px;
                margin-top: 20px;
                justify-content: flex-end;
            }
            .page-btn {
                min-width: 32px;
                height: 32px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 13px;
                text-decoration: none;
                color: #333;
                background: #fff;
                cursor: pointer;
                padding: 0 8px;
            }
            .page-btn:hover {
                background: #f0f0f0;
            }
            .page-btn.active {
                background: #2980b9;
                color: #fff;
                border-color: #2980b9;
            }
            .page-btn.disabled {
                color: #ccc;
                cursor: default;
                pointer-events: none;
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
                <h1 class="page-title">List of categories</h1>
                <a href="addCategory.jsp" class="btn-add">+ Add category</a>
            </div>

            <%-- ===== TABLE ===== --%>
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width:50px">#</th>
                        <th>Category name</th>
                        <th>Memo</th>
                        <th style="width:160px">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty categoryList}">
                            <tr class="empty-row">
                                <td colspan="4">No categories found.</td>
                            </tr>
                        </c:when>

                        <c:otherwise>
                            <c:forEach var="cat" items="${categoryList}" varStatus="loop">
                                <tr>
                                    <td>${loop.count}</td>
                                    <td><strong><c:out value="${cat.categoryName}"/></strong></td>
                                    <td class="memo-cell"><c:out value="${cat.memo}"/></td>
                                    <td>
                                        <a href="updateCategory.jsp?id=${cat.typeId}" class="btn btn-update">Update</a>
                                        <a href="CategoryController?action=deleteCategory&amp;id=${cat.typeId}"
                                           class="btn btn-delete"
                                           onclick="return confirm('Delete category &quot;<c:out value="${cat.categoryName}"/>&quot;?')">Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

        </div>

    </body>
</html>
