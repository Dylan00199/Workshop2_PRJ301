<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>My Account</title>
        <style>
            .page-content {
                padding: 32px;
                max-width: 860px;
            }

            h1.page-title {
                font-size: 26px;
                font-weight: 400;
                color: #222;
                margin-bottom: 28px;
            }

            /* ===== ALERT MESSAGES ===== */
            .alert {
                padding: 10px 16px;
                border-radius: 5px;
                font-size: 13px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 8px;
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

            /* ===== LAYOUT: SIDEBAR + MAIN ===== */
            .profile-wrap {
                display: grid;
                grid-template-columns: 220px 1fr;
                gap: 28px;
                align-items: start;
            }

            /* ===== SIDEBAR CARD ===== */
            .sidebar-card {
                border: 1px solid #e0e0e0;
                border-radius: 10px;
                padding: 28px 20px;
                text-align: center;
                background: #fff;
            }

            .avatar-circle {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                background: #2980b9;
                color: #fff;
                font-size: 28px;
                font-weight: 600;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 14px;
                letter-spacing: 1px;
                overflow: hidden;
            }
            .avatar-circle img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block;
            }

            .sidebar-name {
                font-size: 16px;
                font-weight: 700;
                color: #222;
                margin-bottom: 4px;
                word-break: break-word;
            }
            .sidebar-username {
                font-size: 13px;
                color: #888;
                margin-bottom: 10px;
            }
            .badge-role {
                display: inline-block;
                padding: 3px 12px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 700;
                letter-spacing: 0.3px;
                background: #eafaf1;
                color: #1e8449;
            }

            .status-row {
                margin-top: 14px;
                font-size: 12px;
                color: #aaa;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
            }
            .status-dot {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background: #27ae60;
                display: inline-block;
            }
            .status-dot.inactive {
                background: #e74c3c;
            }

            .sidebar-divider {
                border: none;
                border-top: 1px solid #eee;
                margin: 18px 0;
            }

            .sidebar-nav {
                list-style: none;
                text-align: left;
            }
            .sidebar-nav li {
                margin-bottom: 2px;
            }
            .sidebar-nav a {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 7px 10px;
                border-radius: 5px;
                font-size: 13px;
                color: #444;
                text-decoration: none;
                cursor: pointer;
            }
            .sidebar-nav a:hover  {
                background: #f5f5f5;
            }
            .sidebar-nav a.active-tab {
                background: #e8f4fd;
                color: #1a6fa0;
                font-weight: 600;
            }
            .sidebar-nav .icon {
                font-size: 15px;
                width: 18px;
                text-align: center;
            }

            /* ===== MAIN PANEL ===== */
            .main-panel {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .info-card {
                border: 1px solid #e0e0e0;
                border-radius: 10px;
                background: #fff;
                overflow: hidden;
            }
            .info-card-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 14px 20px;
                border-bottom: 1px solid #f0f0f0;
                background: #fafafa;
            }
            .info-card-header h2 {
                font-size: 14px;
                font-weight: 700;
                color: #333;
                margin: 0;
                text-transform: uppercase;
                letter-spacing: 0.4px;
            }
            .btn-edit {
                font-size: 12px;
                padding: 4px 14px;
                border: 1px solid #2980b9;
                border-radius: 4px;
                color: #2980b9;
                background: #fff;
                cursor: pointer;
                text-decoration: none;
                font-weight: 600;
            }
            .btn-edit:hover {
                background: #e8f4fd;
            }

            /* ===== INFO GRID ===== */
            .info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                padding: 20px;
                gap: 18px 32px;
            }
            .info-item {
            }
            .info-item.full {
                grid-column: 1 / -1;
            }
            .info-label {
                font-size: 11px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.4px;
                color: #aaa;
                margin-bottom: 4px;
            }
            .info-value {
                font-size: 14px;
                color: #222;
                font-weight: 500;
            }
            .info-value.muted {
                color: #aaa;
                font-weight: 400;
                font-style: italic;
            }

            /* ===== EDIT FORM (hidden by default) ===== */
            .edit-form {
                display: none;
                padding: 20px;
                border-top: 1px solid #f0f0f0;
            }
            .edit-form.open {
                display: block;
            }

            .edit-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 14px 24px;
            }
            .edit-group {
                display: flex;
                flex-direction: column;
            }
            .edit-group.full {
                grid-column: 1 / -1;
            }
            .edit-group label {
                font-size: 12px;
                font-weight: 600;
                color: #555;
                margin-bottom: 4px;
                text-transform: uppercase;
                letter-spacing: 0.3px;
            }
            .edit-group input,
            .edit-group select {
                padding: 7px 11px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                outline: none;
                box-sizing: border-box;
            }
            .edit-group input:focus,
            .edit-group select:focus {
                border-color: #2980b9;
                box-shadow: 0 0 0 3px rgba(41,128,185,0.1);
            }
            .edit-actions {
                display: flex;
                gap: 10px;
                margin-top: 16px;
            }
            .btn-save {
                padding: 7px 22px;
                background: #2980b9;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
            }
            .btn-save:hover {
                background: #1f6fa0;
            }
            .btn-cancel-edit {
                padding: 7px 16px;
                background: #fff;
                color: #555;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 13px;
                cursor: pointer;
            }
            .btn-cancel-edit:hover {
                background: #f5f5f5;
            }

            /* ===== CHANGE PASSWORD CARD ===== */
            .pw-form {
                padding: 20px;
            }
            .pw-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 14px 24px;
            }
            .pw-group {
                display: flex;
                flex-direction: column;
            }
            .pw-group.full {
                grid-column: 1 / -1;
            }
            .pw-group label {
                font-size: 12px;
                font-weight: 600;
                color: #555;
                margin-bottom: 4px;
                text-transform: uppercase;
                letter-spacing: 0.3px;
            }
            .pw-group input {
                padding: 7px 11px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                outline: none;
            }
            .pw-group input:focus {
                border-color: #2980b9;
                box-shadow: 0 0 0 3px rgba(41,128,185,0.1);
            }
            .hint {
                font-size: 11px;
                color: #aaa;
                margin-top: 3px;
            }

            /* ===== DANGER ZONE ===== */
            .danger-card .info-card-header {
                background: #fff9f9;
                border-bottom-color: #fde8e8;
            }
            .danger-card .info-card-header h2 {
                color: #c0392b;
            }
            .danger-body {
                padding: 16px 20px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 16px;
            }
            .danger-desc {
                font-size: 13px;
                color: #666;
                line-height: 1.5;
            }
            .btn-danger {
                padding: 7px 18px;
                background: #fff;
                color: #e74c3c;
                border: 1px solid #e74c3c;
                border-radius: 5px;
                font-size: 13px;
                font-weight: 600;
                cursor: pointer;
                white-space: nowrap;
            }
            .btn-danger:hover {
                background: #fdf2f2;
            }

            /* ===== ERROR ===== */
            .error-box {
                background: #fdf2f2;
                border: 1px solid #f5c6c6;
                border-radius: 5px;
                padding: 10px 14px;
                font-size: 13px;
                color: #c0392b;
                margin-bottom: 18px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            @media (max-width: 680px) {
                .profile-wrap {
                    grid-template-columns: 1fr;
                }
                .info-grid, .edit-grid, .pw-grid {
                    grid-template-columns: 1fr;
                }
                .info-item.full, .edit-group.full, .pw-group.full {
                    grid-column: 1;
                }
            }

        </style>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>
        <c:if test="${empty sessionScope.login}">
            <c:redirect url="login.jsp"/>
        </c:if>
        <div class="page-content">
            <h1 class="page-title">My account</h1>

            <%-- ===== ALERTS ===== --%>
            <c:if test = "${not empty success_msg}">
                <div class="alert alert-success"><c:out value = "${success_msg}"/></div>
            </c:if>

            <c:if test = "${not empty error_msg}">
                <div class="alert alert-error"><c:out value = "${error_msg}"/></div>
            </c:if>

            <div class="profile-wrap">


                <div class="sidebar-card">
                    <c:if test="${login.gender eq true}">
                        <div class="avatar-circle"><img src="./images/img_avatar1.png" alt="alt"/></div>
                        </c:if>
                        <c:if test="${login.gender eq false}">
                        <div class="avatar-circle"><img src="./images/img_avatar2.png" alt="alt"/></div>
                        </c:if>
                    <div class="sidebar-name">${fullName}</div>
                    <div class="sidebar-username">${sessionScope.login.account}</div>



                    <span class="badge-role ${roleClass}">
                        ${not empty AccountRole ? AccountRole : "User"}
                    </span>
                    <div class="status-row">
                        <span class="status-dot ${login.use ? '' : 'inactive'}"></span>
                        ${login.use ? "Active" : "Inactive"}
                    </div>

                    <hr class="sidebar-divider">

                    <ul class="sidebar-nav">
                        <li>
                            <a class="active-tab" onclick="showTab('info', this)">
                                <span class="icon">&#128100;</span> Profile info
                            </a>
                        </li>
                        <li>
                            <a onclick="showTab('password', this)">
                                <span class="icon">&#128274;</span> Change password
                            </a>
                        </li>
                    </ul>
                </div>

                <div class="main-panel">

                    <div id="tab-info">

                        <div class="info-card">
                            <div class="info-card-header">
                                <h2>Personal information</h2>
                                <a class="btn-edit" onclick="toggleEdit('personal')">Edit</a>
                            </div>

                            <div class="info-grid" id="view-personal">
                                <div class="info-item">
                                    <div class="info-label">Full name</div>
                                    <div class="info-value">${fullName}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Username (email)</div>
                                    <div class="info-value">${sessionScope.login.account}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Phone number</div>
                                    <div class="info-value ${login.phone eq '—' ? 'muted' : ''}">${login.phone}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Date of birth</div>
                                    <div class="info-value ${login.dob eq '—' ? 'muted' : ''}">
                                        <c:choose>
                                            <c:when test="${login.dob eq '—'}">
                                                ${login.dob}
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatDate value="${login.dob}" pattern="dd/MM/yyyy" />
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Gender</div>
                                    <div class="info-value">${login.gender ? 'Male' : 'Female'}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Role</div>
                                    <div class="info-value">${not empty AccountRole ? AccountRole : "—"}</div>
                                </div>
                            </div>

                            <div class="edit-form" id="edit-personal">
                                <form action="AccountController" method="POST">
                                    <input type="hidden" name="action" value="updateProfile">
                                    <input type="hidden" name="Account" value="${sessionScope.login.account}">
                                    <input type="hidden" name="role" value="${sessionScope.login.roleInSystem}">
                                    <div class="edit-grid">
                                        <div class="edit-group">
                                            <label>First name</label>
                                            <input type="text" name="fn" placeholder="First Name" value="${login.firstname eq '—' ? '' : login.firstname}">
                                        </div>
                                        <div class="edit-group">
                                            <label>Last name</label>
                                            <input type="text" name="ln" placeholder="Last Name" value="${login.lastname eq '—' ? '' : login.lastname}">
                                        </div>
                                        <div class="edit-group">
                                            <label>Phone number</label>
                                            <input type="text" name="phone" placeholder="Phone number" value="${login.phone eq '—' ? '' : login.phone}">
                                        </div>
                                        <div class="edit-group">
                                            <label>Date of birth</label>
                                            <input type="date" name="${login.dob eq '—' ? '' : login.dob}">
                                        </div>
                                        <div class="edit-group">
                                            <label>Gender</label>
                                            <select name="gender">
                                                <option value="true" ${fn:toLowerCase(login.gender) eq 'male' ? 'selected' : ''}>Male</option>
                                                <option value="false" ${fn:toLowerCase(login.gender) eq 'female' ? 'selected' : ''}>Female</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="edit-actions">
                                        <button type="submit" class="btn-save">Save changes</button>
                                        <button type="button" class="btn-cancel-edit" onclick="toggleEdit('personal')">Cancel</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <div class="info-card">
                            <div class="info-card-header">
                                <h2>Account status</h2>
                            </div>
                            <div class="info-grid">
                                <div class="info-item">
                                    <div class="info-label">Status</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${login.use}">
                                                <span style="color:#27ae60; font-weight:700;">&#9679; Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color:#e74c3c; font-weight:700;">&#9679; Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Role in system</div>
                                    <div class="info-value">${not empty AccountRole ? AccountRole : "—"}</div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div id="tab-password" style="display:none">
                        <div class="info-card">
                            <div class="info-card-header">
                                <h2>Change password</h2>
                            </div>

                            <c:if test="${not empty msg}">
                                <div class="error-box"><c:out value="${msg}"/></div>
                            </c:if>

                            <div class="pw-form">
                                <form action="AccountController" method="POST">
                                    <input type="hidden" name="action" value="changePassword">
                                    <input type="hidden" name="accountToChangeP" value="${sessionScope.login.account}">
                                    <div class="pw-grid">
                                        <div class="pw-group full">
                                            <label>Current password</label>
                                            <input type="password" name="currentPassword" 
                                                   placeholder="Enter current password" 
                                                   required
                                                   autocomplete="current-password">
                                        </div>
                                        <div class="pw-group">
                                            <label>New password</label>
                                            <input type="password" name="newPassword" 
                                                   placeholder="New password"
                                                   required
                                                   autocomplete="new-password">
                                        </div>
                                        <div class="pw-group">
                                            <label>Confirm new password</label>
                                            <input type="password" name="confirmPassword" 
                                                   placeholder="Repeat new password" 
                                                   required
                                                   autocomplete="new-password">
                                        </div>
                                    </div>
                                    <div class="edit-actions">
                                        <button type="submit" class="btn-save">Update password</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="info-card danger-card" id="danger-zone" style="display:none">
                        <div class="info-card-header">
                            <h2>Danger zone</h2>
                        </div>
                        <div class="danger-body">
                            <div class="danger-desc">
                                Once you delete your account, all data will be permanently removed.<br>
                                This action cannot be undone.
                            </div>
                            <form action="AccountController" method="POST">
                                <input type="hidden" name="action" value="deleteAccount">
                                <button type="submit" class="btn-danger"
                                        onclick="return confirm('Are you sure you want to delete your account? This cannot be undone.')">
                                    Delete account
                                </button>
                            </form>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <script>
            function showTab(tab, el) {
                document.getElementById('tab-info').style.display = tab === 'info' ? 'flex' : 'none';
                document.getElementById('tab-password').style.display = tab === 'password' ? 'block' : 'none';
                document.getElementById('danger-zone').style.display = tab === 'password' ? 'block' : 'none';

                document.querySelectorAll('.sidebar-nav a').forEach(function (a) {
                    a.classList.remove('active-tab');
                });
                if (el)
                    el.classList.add('active-tab');
            }

            document.getElementById('tab-info').style.display = 'flex';
            document.getElementById('tab-info').style.flexDirection = 'column';
            document.getElementById('tab-info').style.gap = '20px';

            function toggleEdit(section) {
                var view = document.getElementById('view-' + section);
                var form = document.getElementById('edit-' + section);
                var isOpen = form.classList.contains('open');
                if (isOpen) {
                    form.classList.remove('open');
                } else {
                    form.classList.add('open');
                    form.scrollIntoView({behavior: 'smooth', block: 'nearest'});
                }
            }

            <c:if test="${not empty msg}">
            showTab('password');
            document.querySelectorAll('.sidebar-nav a').forEach(function (a) {
                if (a.getAttribute('onclick') && a.getAttribute('onclick').includes('password')) {
                    a.classList.add('active-tab');
                }
            });
            </c:if>
        </script>

    </body>
</html>
