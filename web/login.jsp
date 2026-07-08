<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Login</title>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: Arial, sans-serif;
                font-size: 14px;
                background: #f4f5f7;
                color: #333;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            /* ===== TOP BAR (no user yet) ===== */
            .top-bar {
                background: #fff;
                border-bottom: 1px solid #ddd;
                padding: 0 24px;
                height: 46px;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .top-bar-brand {
                font-size: 14px;
                color: #555;
            }
            .top-bar-brand strong {
                color: #c0392b;
            }

            /* ===== CENTER CARD ===== */
            .login-wrap {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 40px 16px;
            }

            .login-card {
                background: #fff;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                padding: 36px 40px;
                width: 100%;
                max-width: 400px;
            }

            .login-title {
                font-size: 22px;
                font-weight: 400;
                color: #222;
                margin-bottom: 6px;
            }
            .login-sub {
                font-size: 13px;
                color: #888;
                margin-bottom: 28px;
            }

            /* ===== FORM ===== */
            .form-group {
                margin-bottom: 16px;
            }
            .form-group label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: #444;
                margin-bottom: 5px;
            }
            .form-group input {
                width: 100%;
                height: 38px;
                padding: 0 12px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 5px;
                outline: none;
                transition: border-color 0.15s;
            }
            .form-group input:focus {
                border-color: #2980b9;
                box-shadow: 0 0 0 3px rgba(41,128,185,0.12);
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
            .error-box::before {
                content: "✕";
                font-weight: bold;
            }

            /* ===== SUBMIT ===== */
            .btn-login {
                width: 100%;
                height: 38px;
                background: #2980b9;
                color: #fff;
                border: none;
                border-radius: 5px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                margin-top: 6px;
                transition: background 0.15s;
            }
            .btn-login:hover {
                background: #1f6fa0;
            }
            .btn-login:active {
                background: #1a5d88;
            }

            .login-footer {
                text-align: center;
                margin-top: 20px;
                font-size: 13px;
                color: #888;
            }
            .login-footer a {
                color: #2980b9;
                text-decoration: none;
            }
            .login-footer a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="top-bar">
            <span class="top-bar-brand">Welcome to <strong>Guest</strong></span>
            <a href="index.jsp" style="font-size:13px; color:#2980b9; text-decoration:none;">← Back to Home</a>
        </div>

        <div class="login-wrap">
            <div class="login-card">
                <h1 class="login-title">Sign in</h1>
                <p class="login-sub">Enter your account credentials to continue</p>
                
                <c:if test="${not empty msg}">
                    <div class="error-box"><c:out value="${msg}"/></div>
                </c:if>

                <form action="loginController" method="POST">
                    <div class="form-group">
                        <label for="username">Account (Email)</label>
                        <input type="text" id="username" name="username"
                               placeholder="Enter your email"
                               value="${not empty param.username ? param.username : ""}"
                               autocomplete="username">
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password"
                               placeholder="Enter your password"
                               autocomplete="current-password">
                    </div>

                    <button type="submit" class="btn-login">Sign in</button>
                </form>

                <p class="login-footer">
                    Don't have an account? <a href="addAccount.jsp">Register</a>
                </p>
            </div>
        </div>

    </body>
</html>
