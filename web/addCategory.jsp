<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>New Category</title>
        <style>
            .page-content {
                padding: 24px 32px;
            }

            h1.page-title {
                font-size: 28px;
                font-weight: 400;
                margin-bottom: 24px;
                color: #222;
            }

            /* ===== FORM GRID ===== */
            .cat-form {
                display: grid;
                grid-template-columns: 140px 1fr;
                align-items: start;
                row-gap: 16px;
                max-width: 720px;
            }

            .cat-form .form-label {
                text-align: right;
                padding-right: 20px;
                font-weight: 600;
                font-size: 14px;
                padding-top: 8px;
                color: #333;
            }

            .cat-form input[type="text"],
            .cat-form textarea {
                width: 100%;
                padding: 7px 12px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-family: Arial, sans-serif;
                box-sizing: border-box;
                outline: none;
                resize: vertical;
            }

            .cat-form input[type="text"]:focus,
            .cat-form textarea:focus {
                border-color: #888;
                box-shadow: 0 0 0 2px rgba(0,0,0,0.06);
            }

            .cat-form textarea {
                min-height: 90px;
            }

            .form-actions {
                grid-column: 2;
            }

            .btn-save {
                padding: 6px 20px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                background: #fff;
                cursor: pointer;
            }
            .btn-save:hover {
                background: #f0f0f0;
            }

            .btn-cancel {
                padding: 6px 18px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                background: #fff;
                color: #555;
                text-decoration: none;
                cursor: pointer;
            }
            .btn-cancel:hover {
                background: #f5f5f5;
            }

            /* error message */
            .error-msg {
                color: #c0392b;
                font-size: 13px;
                margin-bottom: 12px;
            }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">
            <h1 class="page-title">New category</h1>

            <%-- Show error from backend if any --%>
            <c:if test="${not empty error_msg}">
                <p class="error-msg"><c:out value="${error_msg}"/></p>
            </c:if>

            <form action="CategoryController" method="POST" class="cat-form">
                <input type="hidden" name="action" value="addCategory">

                <label class="form-label">Category<br>name:</label>
                <input type="text" name="categoryName"
                       placeholder="Nhóm hàng mới"
                       value="<c:out value="${param.categoryName}"/>">

                <label class="form-label">Memo :</label>
                <textarea name="memo"
                          placeholder="Những sản phẩm dùng cho du lịch, thám hiểm..."><c:out value="${param.memo}"/></textarea>

                <span></span>
                <div class="form-actions">
                    <button type="submit" class="btn-save">Save</button>
                    <a href="CategoryController?action=listCategory" class="btn-cancel" style="margin-left:8px">Cancel</a>
                </div>
            </form>
        </div>

    </body>
</html>
