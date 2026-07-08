<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.updateAccount}">
    <c:redirect url="login.jsp"/>
</c:if>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Update Account</title>
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

            .alert {
                padding: 10px 16px;
                border-radius: 5px;
                font-size: 13px;
                margin-bottom: 18px;
                display: flex;
                align-items: center;
                gap: 8px;
                max-width: 860px;
            }
            .alert-success {
                background: #eafaf1;
                border: 1px solid #a9dfbf;
                color: #1e8449;
            }
            .alert-error {
                background: #fdf2f2;
                border: 1px solid #f5c6c6;
                color: #c0392b;
            }

            .form-layout {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 0 40px;
                max-width: 860px;
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

            .form-group input[type="text"],
            .form-group input[type="password"],
            .form-group input[type="date"],
            .form-group select {
                padding: 7px 12px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                outline: none;
                box-sizing: border-box;
                width: 100%;
                font-family: Arial, sans-serif;
                transition: border-color 0.15s;
            }
            .form-group input:focus,
            .form-group select:focus {
                border-color: #2980b9;
                box-shadow: 0 0 0 3px rgba(41,128,185,0.1);
            }
            .form-group input[readonly] {
                background: #f8f8f8;
                color: #999;
                cursor: not-allowed;
            }

            .radio-group {
                display: flex;
                align-items: center;
                gap: 20px;
                margin-top: 4px;
            }
            .radio-label {
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
                color: #333;
                cursor: pointer;
            }
            .radio-label input[type="radio"] {
                width: 16px;
                height: 16px;
                accent-color: #2980b9;
                cursor: pointer;
            }

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

            .hint {
                font-size: 12px;
                color: #aaa;
                margin-top: 3px;
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
        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div class="page-content">

            <div class="breadcrumb">
                <a href="AccountController?action=listAccount">Accounts</a>
                <span>&#8250;</span> Update account
            </div>

            <h1 class="page-title">Update account</h1>

            <c:if test="${not empty success_msg}">
                <div class="alert alert-success"><c:out value="${success_msg}"/></div>
            </c:if>
            <c:if test="${not empty error_msg}">
                <div class="alert alert-error"><c:out value="${error_msg}"/></div>
            </c:if>

            <form action="AccountController" method="POST">
                <input type="hidden" name="action"   value="updateAccount">
                <input type="hidden" name="Account"  value="${sessionScope.updateAccount.account}">
                <input type="hidden" name="Password" value="${sessionScope.updateAccount.pass}">

                <div class="form-layout">

                    <div class="form-section-title">Account information</div>

                    <div class="form-group full">
                        <label>Account (Email) <span class="required">*</span></label>
                        <input type="text" name="AccountDisplay"
                               value="<c:out value='${sessionScope.updateAccount.account}'/>"
                               readonly>
                        <span class="hint">Email cannot be changed after creation</span>
                    </div>

                    <div class="form-group">
                        <label>First name <span class="required">*</span></label>
                        <input type="text" name="fn"
                               value="<c:out value='${sessionScope.updateAccount.firstname}'/>"
                               placeholder="First name">
                    </div>

                    <div class="form-group">
                        <label>Last name <span class="required">*</span></label>
                        <input type="text" name="ln"
                               value="<c:out value='${sessionScope.updateAccount.lastname}'/>"
                               placeholder="Last name">
                    </div>

                    <div class="form-group">
                        <label>Phone number</label>
                        <input type="text" name="phone"
                               value="<c:out value='${sessionScope.updateAccount.phone}'/>"
                               placeholder="Phone number">
                    </div>

                    <div class="form-group">
                        <label>Date of birth</label>
                        <input type="date" name="dob"
                               value="${sessionScope.updateAccount.dob}">
                    </div>

                    <div class="form-group">
                        <label>Gender</label>
                        <div class="radio-group">
                            <label class="radio-label">
                                <input type="radio" name="gender" value="true"
                                       ${sessionScope.updateAccount.gender ? 'checked' : ''}> Male
                            </label>
                            <label class="radio-label">
                                <input type="radio" name="gender" value="false"
                                       ${sessionScope.updateAccount.gender ? '' : 'checked'}> Female
                            </label>
                        </div>
                    </div>

                    <div class="form-section-title mt">Role &amp; Status</div>
                    <c:if test="${sessionScope.updateAccount.roleInSystem == 1}">
                        <div class="form-group">
                            <label>Role in system</label>
                            <select name="role">
                                <option value="Administrator" ${sessionScope.updateAccount.roleInSystem == 1 ? 'selected' : ''}>Administrator</option>
                                <option value="Manager"       ${sessionScope.updateAccount.roleInSystem == 2 ? 'selected' : ''}>Manager</option>
                                <option value="User"          ${sessionScope.updateAccount.roleInSystem == 3 ? 'selected' : ''}>User</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Account status</label>
                            <label class="checkbox-label">
                                <input type="checkbox" name="active" value="true"
                                       ${sessionScope.updateAccount.use ? 'checked' : ''}>
                                Is active
                            </label>
                        </div>
                    </c:if>




                    <div class="form-section-title mt">Reset password (optional)</div>

                    <div class="form-group">
                        <label>New password</label>
                        <input type="password" name="newPassword"
                               placeholder="Leave blank to keep current">
                    </div>

                    <div class="form-group">
                        <label>Confirm new password</label>
                        <input type="password" name="confirmPassword"
                               placeholder="Repeat new password">
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-save">Save changes</button>
                        <a href="AccountController?action=listAccount" class="btn-cancel">Cancel</a>
                    </div>

                </div>
            </form>
        </div>

    </body>
</html>
