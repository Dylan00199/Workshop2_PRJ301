<%@page import="Model.Service.CategoryService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Model.Category" %> 
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Add New Product</title>
        <style>
            .page-content {
                padding: 24px 32px;
            }

            h1.page-title {
                font-size: 28px;
                font-weight: 400;
                color: #222;
                margin-bottom: 24px;
            }

            /* ===== TWO-COLUMN LAYOUT ===== */
            .form-layout {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 0 40px;
                max-width: 900px;
            }

            /* ===== SECTION TITLE ===== */
            .form-section-title {
                font-size: 13px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: #888;
                margin: 0 0 14px;
                padding-bottom: 6px;
                border-bottom: 1px solid #eee;
                grid-column: 1 / -1;
            }

            /* ===== FORM GROUP ===== */
            .form-group {
                display: flex;
                flex-direction: column;
                margin-bottom: 14px;
            }
            .form-group.full-width {
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

            .form-group input[type="text"],
            .form-group input[type="number"],
            .form-group input[type="date"],
            .form-group input[type="file"],
            .form-group select,
            .form-group textarea {
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
            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
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

            /* ===== PRICE ROW ===== */
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
                color: #666;
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

            /* ===== IMAGE PREVIEW ===== */
            .image-preview-wrap {
                margin-top: 8px;
            }
            #imagePreview {
                max-width: 180px;
                max-height: 140px;
                object-fit: cover;
                border-radius: 6px;
                border: 1px solid #ddd;
                display: none;
            }
            .preview-placeholder {
                width: 180px;
                height: 120px;
                background: #f5f5f5;
                border: 1px dashed #ccc;
                border-radius: 6px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 12px;
                color: #bbb;
            }

            /* ===== CHECKBOX ROW ===== */
            .checkbox-label {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                color: #333;
                cursor: pointer;
                margin-top: 4px;
            }
            .checkbox-label input[type="checkbox"] {
                width: 16px;
                height: 16px;
                accent-color: #2980b9;
                cursor: pointer;
            }

            /* ===== ERROR ===== */
            .error-msg {
                color: #c0392b;
                font-size: 13px;
                margin-bottom: 14px;
                background: #fdf2f2;
                border: 1px solid #f5c6c6;
                border-radius: 5px;
                padding: 10px 14px;
            }

            /* ===== ACTIONS ===== */
            .form-actions {
                grid-column: 1 / -1;
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 8px;
                padding-top: 16px;
                border-top: 1px solid #eee;
            }
            .btn-submit {
                padding: 8px 28px;
                background: #2980b9;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-submit:hover {
                background: #1f6fa0;
            }
            .btn-cancel {
                padding: 8px 20px;
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

            /* ===== HINT TEXT ===== */
            .hint {
                font-size: 12px;
                color: #aaa;
                margin-top: 4px;
            }
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">
            <h1 class="page-title">Add new product</h1>

            <%-- Error display --%>
            <% CategoryService categoryService = new CategoryService();
                String errorMsg = (String) request.getAttribute("error_msg");
                if (errorMsg != null) {%>
            <div class="error-msg"><%= errorMsg%></div>
            <% }%>

            <form action="ProductController" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="action" value="addProduct">

                <div class="form-layout">

                    <%-- ===== SECTION: BASIC INFO ===== --%>
                    <div class="form-section-title">Basic information</div>

                    <%-- Product name --%>
                    <div class="form-group full-width">
                        <label>Product name <span class="required">*</span></label>
                        <input type="text" name="productName"
                               placeholder="Enter product name"
                               >
                    </div>

                    <%-- Category --%>
                    <div class="form-group">
                        <label>Category <span class="required">*</span></label>
                        <select name="categoryId">
                            <option value="">-- Select category --</option>
                            <c:if test="${not empty cats}">
                                <c:forEach var="c" items="${categoryService.listAll()}">
                                    <option value="${c.typeId}" ${c.typeId == param.categoryId ? 'selected' : ''}>
                                        ${c.categoryName}
                                    </option>
                                </c:forEach>
                            </c:if>
                        </select>
                    </div>

                    <%-- Post date --%>
                    <div class="form-group">
                        <label>Post date <span class="required">*</span></label>
                        <input type="date" name="postDate">
                    </div>

                    <%-- Brief --%>
                    <div class="form-group full-width">
                        <label>Brief description</label>
                        <textarea name="brief" placeholder="Short description shown on product card..."></textarea>
                    </div>

                    <%-- Unit --%>
                    <div class="form-group full-width">
                        <label>Unit</label>
                        <input type ="text" name="unit" placeholder="Describe the unit of the product...">
                    </div>

                    <%-- ===== SECTION: PRICING ===== --%>
                    <div class="form-section-title" style="margin-top:8px">Pricing</div>

                    <%-- Price --%>
                    <div class="form-group">
                        <label>Price (VND) <span class="required">*</span></label>
                        <div class="input-prefix-wrap">
                            <span class="input-prefix">VND</span>
                            <input type="number" name="price" min="0" step="1000"
                                   placeholder="e.g. 1800000"
                                   >
                        </div>
                    </div>

                    <%-- Discount --%>
                    <div class="form-group">
                        <label>Discount (%)</label>
                        <div class="input-prefix-wrap">
                            <span class="input-prefix">%</span>
                            <input type="number" name="discount" min="0" max="100" step="1"
                                   placeholder="0"
                                   >
                        </div>
                        <span class="hint">Leave 0 if no discount</span>
                    </div>

                    <%-- ===== SECTION: MEDIA ===== --%>
                    <div class="form-section-title" style="margin-top:8px">Product image</div>

                    <%-- Image upload --%>
                    <div class="form-group">
                        <label>Upload image</label>
                        <input type="file" name="image" accept="image/*" onchange="previewImage(this)">
                        <span class="hint">JPG, PNG, WEBP — max 5MB</span>
                    </div>

                    <%-- Preview --%>
                    <div class="form-group full-width">
                        <div class="image-preview-wrap">
                            <div class="preview-placeholder" id="previewPlaceholder">No image selected</div>
                            <img id="imagePreview" src="" alt="Preview">
                        </div>
                    </div>

                    <%-- ===== SECTION: STATUS ===== --%>
                    <div class="form-section-title" style="margin-top:8px">Status</div>

                    <div class="form-group full-width">
                        <label class="checkbox-label">
                            <input type="checkbox" name="active" value="true"
                                   >
                            Active (visible on public page)
                        </label>
                    </div>

                    <%-- ===== ACTIONS ===== --%>
                    <div class="form-actions">
                        <button type="submit" class="btn-submit">Save product</button>
                        <a href="index.jsp" class="btn-cancel">Cancel</a>
                    </div>

                </div><%-- end .form-layout --%>
            </form>
        </div>

        <script>
            function previewImage(input) {
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        showPreview(e.target.result);
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }
            function previewUrl(url) {
                if (url && url.trim() !== '') {
                    showPreview(url.trim());
                } else {
                    hidePreview();
                }
            }
            function showPreview(src) {
                var img = document.getElementById('imagePreview');
                var ph = document.getElementById('previewPlaceholder');
                img.src = src;
                img.style.display = 'block';
                ph.style.display = 'none';
            }
            function hidePreview() {
                document.getElementById('imagePreview').style.display = 'none';
                document.getElementById('previewPlaceholder').style.display = 'flex';
            }
        </script>

    </body>
</html>
