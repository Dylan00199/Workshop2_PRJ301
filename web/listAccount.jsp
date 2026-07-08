<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.login}">
    <c:redirect url="login.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>List of Accounts</title>
        <style>
            /* ===== LAYOUT ===== */
            .page-content {
                padding: 24px 32px;
            }

            h1.page-title {
                font-size: 28px;
                font-weight: 400;
                margin-bottom: 20px;
                color: #222;
            }

            /* ===== TABLE ===== */
            .account-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
            }
            .account-table th {
                text-align: left;
                padding: 8px 12px;
                border-bottom: 1px solid #dee2e6;
                color: #555;
                font-weight: 600;
            }
            .account-table td {
                padding: 10px 12px;
                border-bottom: 1px solid #f0f0f0;
                vertical-align: middle;
            }
            .account-table tr:last-child td {
                border-bottom: none;
            }
            .account-table tr:hover td {
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

            /* ===== ACTION BUTTONS ===== */
            .btn {
                display: inline-block;
                padding: 4px 12px;
                border: none;
                border-radius: 4px;
                font-size: 13px;
                font-weight: 500;
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
            .btn-deactive {
                background: #e67e22;
            }
            .btn-deactive:hover {
                background: #cf6d17;
            }
            .btn-active {
                background: #27ae60;
            }
            .btn-active:hover {
                background: #1e9050;
            }
            .btn-delete {
                background: #e74c3c;
            }
            .btn-delete:hover {
                background: #c0392b;
            }

            /* ===== STATUS BADGE ===== */
            .badge {
                display: inline-block;
                padding: 2px 8px;
                border-radius: 10px;
                font-size: 12px;
            }
            .badge-active {
                background: #d4edda;
                color: #155724;
            }
            .badge-inactive {
                background: #f8d7da;
                color: #721c24;
            }

            /* ===== EMPTY STATE ===== */
            .empty-state {
                text-align: center;
                padding: 40px;
                color: #888;
                font-size: 15px;
            }
        </style>
    </head>
    <body>

        <%-- ===== NAVBAR ===== --%>
        <%@ include file="navbar.jsp" %>
        
        <c:if test="${not empty success_msg}">
            <div class="alert alert-success">${success_msg}</div>
        </c:if>
        <c:if test="${not empty error_msg}">
            <div class="alert alert-error">${error_msg}</div>
        </c:if>
            
        <div class="page-content">
            <h1 class="page-title">List of Accounts in System</h1>
            <c:choose>
                <c:when test="${not empty requestScope.listAccounts}">
                    <table class="account-table">
                        <thead>
                            <tr>
                                <th>Account</th>
                                <th>Full Name</th>
                                <th>Birthday</th>
                                <th>Gender</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="acc" items="${requestScope.listAccounts}">

                                <c:choose>
                                    <c:when test="${acc.roleInSystem == 1}">
                                        <c:set var="roleLabel" value="Administrator" />
                                    </c:when>
                                    <c:when test="${acc.roleInSystem == 2}">
                                        <c:set var="roleLabel" value="Manager" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="roleLabel" value="User" />
                                    </c:otherwise>
                                </c:choose>

                                <tr>
                                    <td>${acc.account}</td>
                                    <td>${acc.firstname} ${acc.lastname}</td>
                                    <td>${acc.dob}</td>
                                    <td>${acc.gender ? 'Male' : 'Female'}</td>
                                    <td>${acc.phone}</td>
                                    <td>${roleLabel}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${acc.use}">
                                                <span class="badge badge-active">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-inactive">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <a href="updateAccount.jsp?updateAccount=${acc.account}"
                                           class="btn btn-update">Update</a>

                                        <c:choose>
                                            <c:when test="${acc.use}">
                                                <a href="AccountController?action=deactiveAccount&id=${acc.account}"
                                                   class="btn btn-deactive">Deactivate</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="AccountController?action=activeAccount&id=${acc.account}"
                                                   class="btn btn-active">Activate</a>
                                            </c:otherwise>
                                        </c:choose>

                                        <a href="AccountController?action=deleteAccount&id=${acc.account}"
                                           class="btn btn-delete">Delete</a>
                                    </td>
                                </tr>

                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>

                <%-- BUG FIX #6: Added empty-state message instead of silently showing
                     a blank table when there are no accounts --%>
                <c:otherwise>
                    <p class="empty-state">No accounts found in the system.</p>
                </c:otherwise>
            </c:choose>

        </div>

    </body>
</html>
