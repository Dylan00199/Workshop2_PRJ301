<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Add Account</title>
    </head>
    <body>

        <%@ include file="navbar.jsp" %>

        <div style="padding: 28px 32px; max-width: 860px;">
            <h1 style="font-size:26px; font-weight:400; color:#222; margin-bottom:24px;">Add new account</h1>

            <c:if test="${not empty error_msg}">
                <p class="error-msg"><c:out value="${error_msg}"/></p>
            </c:if>

            <form action="AccountController" method="POST" class="Insert">
                <input type="hidden" name="action" value="addAccount">

                <span class="form-label">Account (Email)</span>
                <input type="text" name="Account" id="Account"
                       placeholder="Enter email" required
                       value="${not empty requestScope.prev_account ? requestScope.prev_account : ''}">

                <span class="form-label">Password</span>
                <div class="pw-wrap">
                    <input type="password" name="Password" id="Password"
                           placeholder="Enter password" required
                           autocomplete="new-password">
                    <%-- Strength meter — hidden until user starts typing --%>
                    <div id="pw-meter" class="pw-meter" aria-live="polite"></div>
                </div>

                <span class="form-label">First name</span>
                <input type="text" name="fn" id="fn"
                       placeholder="First name" required
                       value="${not empty requestScope.prev_fn ? requestScope.prev_fn : ''}">

                <span class="form-label">Last name</span>
                <input type="text" name="ln" id="ln"
                       placeholder="Last name" required
                       value="${not empty requestScope.prev_ln ? requestScope.prev_ln : ''}">

                <span class="form-label">Phone number</span>
                <input type="text" name="phone" id="phone"
                       placeholder="Phone number" required
                       value="${not empty requestScope.prev_phone ? requestScope.prev_phone : ''}">

                <span class="form-label">Date of birth</span>
                <input type="date" name="dob" id="dob" required
                       value="${not empty requestScope.prev_dob ? requestScope.prev_dob : ''}">

                <span class="form-label">Gender</span>
                <div class="gender-group">
                    <label>
                        <input type="radio" name="gender" value="true"
                               ${empty requestScope.prev_gender || requestScope.prev_gender == 'true' ? 'checked' : ''}>
                        Male
                    </label>
                    <label>
                        <input type="radio" name="gender" value="false"
                               ${requestScope.prev_gender == 'false' ? 'checked' : ''}>
                        Female
                    </label>
                </div>

                <span></span>
                <input type="submit" value="Submit">
            </form>
        </div>

        <style>
            .Insert {
                display: grid;
                grid-template-columns: 160px 1fr;
                align-items: start;      /* changed: center → start so meter doesn't shift label */
                row-gap: 12px;
                max-width: 860px;
            }

            /* align single-line labels to center of their input */
            .Insert .form-label {
                text-align: right;
                padding-right: 20px;
                font-weight: 500;
                line-height: 36px;      /* matches input height */
            }

            .Insert input[type="text"],
            .Insert input[type="password"],
            .Insert input[type="date"] {
                width: 100%;
                height: 36px;
                padding: 0 12px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 6px;
                box-sizing: border-box;
            }

            .Insert select {
                width: 100%;
                height: 36px;
                padding: 0 12px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 6px;
                box-sizing: border-box;
            }

            .gender-group {
                display: flex;
                align-items: center;
                gap: 16px;
                line-height: 36px;
            }

            .gender-group label {
                display: flex;
                align-items: center;
                gap: 5px;
                font-weight: normal;
                cursor: pointer;
            }

            .active-row {
                grid-column: 2;
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 14px;
            }

            .Insert input[type="submit"] {
                grid-column: 2;
                width: auto;
                padding: 6px 20px;
                font-size: 14px;
                border: 1px solid #ccc;
                border-radius: 6px;
                background: #fff;
                cursor: pointer;
            }

            .Insert input[type="submit"]:hover {
                background: #f5f5f5;
            }

            .error-msg {
                background: #fdf2f2;
                border: 1px solid #f5c6c6;
                border-radius: 5px;
                padding: 10px 14px;
                color: #c0392b;
                font-size: 13px;
                margin-bottom: 16px;
                max-width: 860px;
            }

            /* ===== PASSWORD WRAPPER (keeps meter in the same grid cell) ===== */
            .pw-wrap {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }
            .pw-wrap input {
                width: 100%;
            }

            /* ===== STRENGTH METER ===== */
            .pw-meter {
                display: none;          /* hidden until user types */
                font-size: 12px;
                font-weight: 600;
                padding: 3px 10px;
                border-radius: 4px;
                width: fit-content;
            }
            .pw-meter.show     { display: block; }

            .pw-meter.invalid  { background: #f8d7da; color: #721c24; }
            .pw-meter.weak     { background: #fde8c8; color: #7d4e00; }
            .pw-meter.fair     { background: #fff3cd; color: #856404; }
            .pw-meter.good     { background: #d4edda; color: #155724; }
            .pw-meter.strong   { background: #c3e6cb; color: #0b4a1e; }
        </style>

        <script>
        (function () {
            const input  = document.getElementById('Password');
            const meter  = document.getElementById('pw-meter');

            const LEVELS = {
                invalid : { label: 'Too short (min 8 characters)',            cls: 'invalid' },
                weak    : { label: 'Weak – add uppercase letters and numbers', cls: 'weak'    },
                fair    : { label: 'Acceptable – meets minimum requirements',  cls: 'fair'    },
                good    : { label: 'Good – strong enough for most uses',       cls: 'good'    },
                strong  : { label: 'Strong – excellent password',              cls: 'strong'  },
            };

            function evaluate(pw) {
                if (!pw)            return null;          
                if (pw.length < 8)  return 'invalid';

                const hasUpper   = /[A-Z]/.test(pw);
                const hasLower   = /[a-z]/.test(pw);
                const hasDigit   = /[0-9]/.test(pw);
                const hasSpecial = /[^A-Za-z0-9]/.test(pw);

                if (!hasUpper || !hasDigit) return 'weak';

                if (pw.length >= 12 && hasUpper && hasLower && hasDigit && hasSpecial)
                    return 'strong';
                if (pw.length >= 10 && hasSpecial)
                    return 'good';

                return 'fair';   
            }

            input.addEventListener('input', function () {
                const level = evaluate(this.value);

                meter.className = 'pw-meter';

                if (!level) {
                    meter.textContent = '';
                    return;   
                }

                const info = LEVELS[level];
                meter.classList.add('show', info.cls);
                meter.textContent = info.label;
            });
        })();
        </script>

    </body>
</html>
