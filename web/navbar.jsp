<%@page import="Model.Account"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar">
    <div class="navbar-inner">
        <div class="navbar-brand">
            Welcome to

            <c:choose>
                <c:when test="${not empty sessionScope.login}">
                    <strong class="role-label">
                        <c:choose>
                            <c:when test="${login.roleInSystem == 1}"><c:set var="AccountRole" value="Admin" /></c:when>
                            <c:when test="${login.roleInSystem == 2}"><c:set var="AccountRole" value="Manager" /></c:when>
                            <c:when test="${login.roleInSystem == 3}"><c:set var="AccountRole" value="User" /></c:when>
                            <c:otherwise><c:set var="AccountRole" value="Unknown" /></c:otherwise>
                        </c:choose>
                        <c:out value="${AccountRole}" />
                    </strong> 
                    [<c:out value="${sessionScope.login.account}" />]
                </c:when>
                <c:otherwise>
                    <strong class="role-label">Guest</strong>
                </c:otherwise>
            </c:choose>
        </div>

        <ul class="nav-links">
            <li><a href="index.jsp" class="nav-link">Home</a></li>

            <li class="dropdown">
                <a class="nav-link dropdown-toggle">Accounts</a>
                <ul class="dropdown-menu">
                    <c:if test="${sessionScope.login.roleInSystem == 1}">
                        <li><a href="AccountController?action=listAccount">List Accounts</a></li>
                        </c:if>
                    <li><a href="addAccount.jsp">New Account</a></li>
                    <li><a href="AccountController?action=displayAccount">My Account</a></li>
                </ul>
            </li>

            <li class="dropdown">
                <a class="nav-link dropdown-toggle">Categories</a>
                <ul class="dropdown-menu">
                    <li><a href="CategoryController?action=listCategory">List Categories</a></li>
                        <c:if test="${not empty sessionScope.login}">
                        <li><a href="addCategory.jsp">Add Category</a></li>
                        </c:if>
                </ul>
            </li>

            <li class="dropdown">
                <a class="nav-link dropdown-toggle">Products</a>
                <ul class="dropdown-menu">
                    <li><a href="ProductController?action=listProduct">List Products</a></li>
                        <c:if test="${not empty sessionScope.login}">
                        <li><a href="addProduct.jsp">Add Product</a></li>
                        </c:if>
                </ul>
            </li>

            <li><a href="CartController" class="nav-link">
                    Cart
                    <c:if test="${not empty sessionScope.login && not empty sessionScope.cartCount && sessionScope.cartCount > 0}">
                        (${sessionScope.cartCount})
                    </c:if>
                </a></li>

            <c:if test="${sessionScope.login.roleInSystem == 1}">
                <li><a href="Admin.jsp" class="nav-link">Admin</a></li>
            </c:if>
        </ul>

        <div class="nav-auth">
            <c:choose>
                <c:when test="${not empty sessionScope.login}">
                    <a href="loginController?action=logout" class="btn-logout">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="login.jsp" class="btn-logout">Login</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<style>
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }
    body {
        font-family: Arial, sans-serif;
        font-size: 14px;
        background: #fff;
        color: #333;
    }

    .navbar {
        background: #fff;
        border-bottom: 1px solid #ddd;
        padding: 0 20px;
        position: sticky;
        top: 0;
        z-index: 100;
    }
    .navbar-inner {
        display: flex;
        align-items: center;
        height: 46px;
        gap: 12px;
    }
    .navbar-brand {
        flex: 1;
        font-size: 14px;
        white-space: nowrap;
    }
    .role-label {
        color: #c0392b;
        font-weight: bold;
    }

    .nav-links {
        display: flex;
        list-style: none;
        gap: 2px;
        align-items: center;
    }
    .nav-link {
        display: block;
        padding: 6px 12px;
        border-radius: 4px;
        text-decoration: none;
        color: #333;
        font-size: 14px;
        cursor: pointer;
    }
    .nav-link:hover {
        background: #e9ecef;
    }

    .dropdown {
        position: relative;
    }
    .dropdown-menu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        background: #fff;
        border: 1px solid #ddd;
        border-radius: 4px;
        min-width: 160px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        z-index: 200;
    }
    .dropdown-menu li {
        list-style: none;
    }
    .dropdown-menu a {
        display: block;
        padding: 8px 14px;
        text-decoration: none;
        color: #333;
        font-size: 13px;
    }
    .dropdown-menu a:hover {
        background: #f8f9fa;
    }
    .dropdown:hover .dropdown-menu {
        display: block;
    }

    .btn-logout {
        padding: 5px 14px;
        border: 1px solid #ccc;
        border-radius: 4px;
        text-decoration: none;
        color: #333;
        font-size: 13px;
        white-space: nowrap;
    }
    .btn-logout:hover {
        background: #f0f0f0;
    }
</style>
