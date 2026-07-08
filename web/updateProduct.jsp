<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Model.Service.ProductService" %>
<%@ page import="Model.Service.CategoryService" %>
<%@ page import="Model.Product" %> 
<%@ page import="Model.Category" %> 
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Đẩy dữ liệu vào pageContext để sử dụng với EL
    String id = request.getParameter("id");
    Product p = new ProductService().getObjectById(id);
    List<Category> cats = new CategoryService().listAll();

    pageContext.setAttribute("p", p);
    pageContext.setAttribute("cats", cats);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Update Product</title>
        <style>
            /* (Tui giữ nguyên toàn bộ CSS của bạn, vì nó đã hiển thị tốt rồi) */
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
            .alert {
                padding: 10px 16px;
                border-radius: 5px;
                font-size: 13px;
                margin-bottom: 18px;
                display: flex;
                align-items: center;
                gap: 8px;
                max-width: 920px;
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
            .form-layout {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 0 40px;
                max-width: 920px;
            }
            .form-section-title {
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: #aaa;
                margin: 0 0 14px;
                padding-bottom: 6px;
                border-bottom: 1px solid #eee;
                grid-column: 1 / -1;
            }
            .form-section-title.mt {
                margin-top: 10px;
            }
            .form-group {
                display: flex;
                flex-direction: column;
                margin-bottom: 14px;
            }
            .form-group.full {
                grid-column: 1 / -1;
            }
            .form-group label {
                font-size: 13px;
                font-weight: 600;
                color: #444;
                margin-bottom: 5px;
            }
            .form-group label .required {
                color: #e74c3c;
                margin-left: 2px;
            }
            .form-group input[type="text"], .form-group input[type="number"], .form-group input[type="date"], .form-group input[type="file"], .form-group select, .form-group textarea {
                padding: 7px 12px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-family: Arial, sans-serif;
                outline: none;
                box-sizing: border-box;
                width: 100%;
                transition: border-color 0.15s;
            }
            .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
                border-color: #2980b9;
                box-shadow: 0 0 0 3px rgba(41,128,185,0.1);
            }
            .form-group input[type="file"] {
                padding: 5px 12px;
                cursor: pointer;
            }
            .form-group textarea {
                resize: vertical;
                min-height: 80px;
            }
            .input-prefix-wrap {
                display: flex;
                align-items: center;
                border: 1px solid #ccc;
                border-radius: 5px;
                overflow: hidden;
                transition: border-color 0.15s;
            }
            .input-prefix-wrap:focus-within {
                border-color: #2980b9;
                box-shadow: 0 0 0 3px rgba(41,128,185,0.1);
            }
            .input-prefix {
                padding: 7px 10px;
                background: #f5f5f5;
                font-size: 13px;
                color: #777;
                border-right: 1px solid #ddd;
                white-space: nowrap;
            }
            .input-prefix-wrap input {
                border: none !important;
                border-radius: 0 !important;
                box-shadow: none !important;
                flex: 1;
            }
            .input-prefix-wrap input:focus {
                box-shadow: none !important;
            }
            .image-section {
                display: flex;
                gap: 20px;
                align-items: flex-start;
            }
            .current-img-wrap {
                flex-shrink: 0;
            }
            .current-img-wrap img {
                width: 120px;
                height: 100px;
                object-fit: cover;
                border-radius: 6px;
                border: 1px solid #ddd;
                display: block;
            }
            .no-img-box {
                width: 120px;
                height: 100px;
                background: #f5f5f5;
                border: 1px dashed #ccc;
                border-radius: 6px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 11px;
                color: #bbb;
            }
            .img-inputs {
                flex: 1;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .img-inputs label {
                font-size: 13px;
                font-weight: 600;
                color: #444;
                margin-bottom: 2px;
                display: block;
            }
            .img-inputs input[type="file"], .img-inputs input[type="text"] {
                padding: 6px 12px;
                font-size: 13px;
                border: 1px solid #ccc;
                border-radius: 5px;
                outline: none;
                width: 100%;
                box-sizing: border-box;
            }
            .img-inputs input:focus {
                border-color: #2980b9;
            }
            #imagePreview {
                max-width: 120px;
                max-height: 100px;
                object-fit: cover;
                border-radius: 6px;
                border: 1px solid #ddd;
                display: none;
                margin-top: 6px;
            }
            .hint {
                font-size: 12px;
                color: #aaa;
                margin-top: 3px;
            }
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
            .form-actions {
                grid-column: 1 / -1;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 8px;
                padding-top: 16px;
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
            .btn-delete-prod {
                margin-left: auto;
                padding: 8px 18px;
                background: #fff;
                color: #e74c3c;
                border: 1px solid #e74c3c;
                border-radius: 5px;
                font-size: 14px;
                text-decoration: none;
                cursor: pointer;
                font-weight: 600;
            }
            .btn-delete-prod:hover {
                background: #fdf2f2;
            }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">

            <div class="breadcrumb">
                <a href="ProductController?action=listProduct">Products</a>
                <span>›</span> Update product
            </div>

            <h1 class="page-title">Update product</h1>
            
            <c:if test="${not empty param.success_msg}">
                <div class="alert alert-success">${param.success_msg}</div>
            </c:if>
            <c:if test="${not empty param.error_msg}">
                <div class="alert alert-error">&#10007; <c:out value="${param.error_msg}"/></div>
            </c:if>

            <form action="ProductController" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="updateProduct">
                <input type="hidden" name="id" value="<c:out value="${param.id}"/>">

                <div class="form-layout">

                    <%-- ===== BASIC INFO ===== --%>
                    <div class="form-section-title">Basic information</div>

                    <div class="form-group">
                        <label>Product ID</label>
                        <span class="id-badge">#<c:out value="${param.id}"/></span>
                    </div>

                    <div class="form-group">
                        <label>Post date <span class="required">*</span></label>
                        <input type="date" name="postDate" value="${p.postedDate}">
                    </div>

                    <div class="form-group full">
                        <label>Product name <span class="required">*</span></label>
                        <input type="text" name="productName" value="<c:out value="${p.productName}"/>" placeholder="Product name">
                    </div>

                    <div class="form-group">
                        <label>Category <span class="required">*</span></label>
                        <select name="categoryId">
                            <option value="">-- Select category --</option>
                            <c:forEach var="c" items="${cats}">
                                <%-- Dùng toán tử 3 ngôi (Ternary) của EL để auto-select category cũ --%>
                                <option value="${c.typeId}" ${c.typeId eq p.type.typeId ? 'selected' : ''}>
                                    <c:out value="${c.categoryName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group full">
                        <label>Brief description</label>
                        <textarea name="brief" placeholder="Short description..."><c:out value="${p.brief}"/></textarea>
                    </div>

                    <%-- ===== PRICING ===== --%>
                    <div class="form-section-title mt">Pricing</div>

                    <div class="form-group">
                        <label>Price (VND) <span class="required">*</span></label>
                        <div class="input-prefix-wrap">
                            <span class="input-prefix">₫</span>
                            <input type="number" name="price" min="0" step="1000" value="${p.price}" placeholder="${p.price}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Discount (%)</label>
                        <div class="input-prefix-wrap">
                            <span class="input-prefix">%</span>
                            <input type="number" name="discount" min="0" max="100" step="1" value="${p.discount}" placeholder="${p.discount}">
                        </div>
                        <span class="hint">Set 0 if no discount</span>
                    </div>

                    <%-- ===== IMAGE ===== --%>
                    <div class="form-section-title mt">Product image</div>

                    <div class="form-group full">
                        <label>Current &amp; new image</label>
                        <div class="image-section">
                            <div class="current-img-wrap">
                                <c:choose>
                                    <c:when test="${not empty p.productImage}">
                                        <img src="${p.productImage}" alt="Current image"
                                             onerror="this.style.display='none';document.getElementById('noImgBox').style.display='flex'">
                                        <div id="noImgBox" class="no-img-box" style="display:none">No image</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-img-box">No image</div>
                                    </c:otherwise>
                                </c:choose>
                                <span class="hint" style="text-align:center;display:block;margin-top:4px">Current</span>
                            </div>

                            <%-- Inputs upload ảnh --%>
                            <div class="img-inputs">
                                <div>
                                    <label>Upload new image</label>
                                    <input type="file" name="image" accept="image/*" onchange="previewFile(this)">
                                    <span class="hint">Leave blank to keep current image</span>
                                </div>
                                <div>
                                    <label>Or new image URL</label>
                                    <input type="text" name="imageUrl" value="" oninput="previewUrl(this.value)">
                                </div>
                                <img id="imagePreview" src="" alt="New preview">
                            </div>
                        </div>
                    </div>

                    <%-- ===== ACTIONS ===== --%>
                    <div class="form-actions full" style="grid-column: 1 / -1">
                        <button type="submit" class="btn-save">Save changes</button>
                        <a href="ProductController?action=listProduct" class="btn-cancel">Cancel</a>
                        <a href="ProductController?action=deleteProduct&amp;id=<c:out value="${param.id}"/>" class="btn-delete-prod"
                           onclick="return confirm('Delete this product? This cannot be undone.')">
                            Delete product
                        </a>
                    </div>

                </div>
            </form>
        </div>

        <script>
            function previewFile(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        showPreview(e.target.result);
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }
            function previewUrl(url) {
                if (url && url.trim())
                    showPreview(url.trim());
                else
                    hidePreview();
            }
            function showPreview(src) {
                var img = document.getElementById('imagePreview');
                img.src = src;
                img.style.display = 'block';
            }
            function hidePreview() {
                document.getElementById('imagePreview').style.display = 'none';
            }
        </script>

    </body>
</html>