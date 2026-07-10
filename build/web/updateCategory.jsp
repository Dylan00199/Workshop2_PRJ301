<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Category" %> 
<%@ page import="Model.Service.CategoryService" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String id = request.getParameter("id");
    Category cat = new CategoryService().getObjectById(id);
    pageContext.setAttribute("cat", cat);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Update Category</title>
        <style>
            .page-content {
                padding: 24px 32px;
            }
            .breadcrumb {
                font-size: 13px;
                color: #aaa;
                margin-bottom: 16px;
            }
            .breadcrumb a {
                color: #2980b9;
                text-decoration: none;
            }
            .breadcrumb a:hover {
                text-decoration: underline;
            }
            .breadcrumb span {
                margin: 0 6px;
            }
            h1.page-title {
                font-size: 26px;
                font-weight: 400;
                color: #222;
                margin-bottom: 24px;
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
            /* ===== FORM ===== */
            .cat-form {
                display: grid;
                grid-template-columns: 150px 1fr;
                align-items: start;
                row-gap: 16px;
                max-width: 720px;
            }
            .form-label {
                text-align: right;
                padding-right: 20px;
                font-size: 14px;
                font-weight: 600;
                color: #444;
                padding-top: 8px;
            }
            .form-label .required {
                color: #e74c3c;
                margin-left: 2px;
            }
            .cat-form input[type="text"], .cat-form textarea {
                width: 100%;
                padding: 7px 12px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-family: Arial, sans-serif;
                box-sizing: border-box;
                outline: none;
                resize: vertical;
                transition: border-color 0.15s;
            }
            .cat-form input[type="text"]:focus, .cat-form textarea:focus {
                border-color: #2980b9;
                box-shadow: 0 0 0 3px rgba(41,128,185,0.1);
            }
            .cat-form textarea {
                min-height: 100px;
            }
            /* ===== ID BADGE ===== */
            .id-badge {
                display: inline-block;
                background: #f0f0f0;
                border: 1px solid #ddd;
                border-radius: 4px;
                padding: 6px 12px;
                font-size: 13px;
                color: #888;
                font-family: monospace;
            }
            /* ===== ACTIONS ===== */
            .form-actions {
                grid-column: 2;
                display: flex;
                align-items: center;
                gap: 10px;
                padding-top: 8px;
                border-top: 1px solid #eee;
            }
            .btn-save {
                padding: 8px 26px;
                background: #2980b9;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-save:hover {
                background: #1f6fa0;
            }
            .btn-cancel {
                padding: 8px 18px;
                background: #fff;
                color: #555;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 14px;
                text-decoration: none;
                cursor: pointer;
            }
            .btn-cancel:hover {
                background: #f5f5f5;
            }
            .spacer {
                grid-column: 1;
            }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>
        <c:if test="${empty sessionScope.login || sessionScope.login.roleInSystem != 1}">
            <c:redirect url="index.jsp"></c:redirect> 
        </c:if>
        <div class="page-content">

            <div class="breadcrumb">
                <a href="CategoryController?action=listCategory">Categories</a>
                <span>›</span> Update category
            </div>

            <h1 class="page-title">Update category</h1>

            <c:if test="${not empty success_msg}">
                <div class="alert alert-success">${success_msg}</div>
            </c:if>
            <c:if test="${not empty error_msg}">
                <div class="alert alert-error">${error_msg}</div>
            </c:if>

            <form action="CategoryController" method="POST" class="cat-form">
                <input type="hidden" name="action" value="updateCategory">
                <input type="hidden" name="id" value="${cat.typeId}">

                <%-- ID --%>
                <span class="form-label">ID</span>
                <div>
                    <span class="id-badge">
                        #${cat.typeId == 0 ? '—' : cat.typeId}
                    </span>
                </div>

                <%-- Category name --%>
                <label class="form-label">
                    Category name <span class="required">*</span>
                </label>
                <input type="text" name="categoryName"
                       value="<c:out value="${cat.categoryName}"/>"
                       placeholder="Category name">

                <%-- Memo --%>
                <label class="form-label">Memo</label>
                <textarea name="memo" placeholder="Short description of this category..."><c:out value="${cat.memo}"/></textarea>

                <%-- Actions --%>
                <span class="spacer"></span>
                <div class="form-actions">
                    <button type="submit" class="btn-save">Save changes</button>
                    <a href="CategoryController?action=listCategory" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </div>

    </body>
</html>