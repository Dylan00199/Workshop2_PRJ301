<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Access Denied</title>
        <style>
            body {
                margin: 0;
                padding: 0;
                height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                background-color: #f4f5f7;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                color: #333333;
            }
            .content-wrapper {
                flex-grow: 1;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .container {
                text-align: center;
                padding: 2rem;
            }

            .lock-icon {
                width: 120px;
                height: 120px;
                fill: #4a4a4a;
                margin-bottom: 24px;
            }

            h1 {
                font-size: 2.5rem;
                font-weight: 500;
                margin: 0 0 16px 0;
                color: #212529;
            }

            p {
                font-size: 1.25rem;
                margin: 0;
                color: #555555;
            }
        </style>
    </head>
    <body>
        <%@ include file="navbar.jsp" %>
        <div class="content-wrapper">
            <div class="container">
                <svg class="lock-icon" viewBox="0 0 448 512" xmlns="http://www.w3.org/2000/svg">
                <path d="M400 224h-24v-72C376 68.2 307.8 0 224 0S72 68.2 72 152v72H48c-26.5 0-48 21.5-48 48v192c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V272c0-26.5-21.5-48-48-48zm-104 0H152v-72c0-39.7 32.3-72 72-72s72 32.3 72 72v72z"></path>
                </svg>

                <h1>Access to this page is restricted</h1>
                    <p><c:out value="${msg}"/></p>
            </div>
        </div>

    </body>
</html>