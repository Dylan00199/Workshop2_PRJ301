package Controller;

import Model.Account;
import Model.Service.AccountService;
import Utilities.PasswordUtils;
import Utilities.ValidationUtils;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author PC
 */
@WebServlet(name = "MainController", urlPatterns = {"/AccountController"})
public class AccountController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MainController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MainController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        String msg;
        Account login = (Account) session.getAttribute("login");
        AccountService accountService = new AccountService();
        try {
            switch (action) {
                case "displayAccount":
                    if (login == null) {
                        msg = "Please Login or Regist new account!";
                        request.setAttribute("msg", msg);
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                        return;
                    }
                    String firstName = login.getFirstname();
                    String lastName = login.getLastname();

                    boolean firstEmpty = (firstName == null || firstName.isEmpty());
                    boolean lastEmpty = (lastName == null || lastName.isEmpty());

                    String fullName;
                    if (firstEmpty && lastEmpty) {
                        fullName = login.getAccount();
                    } else {
                        fullName = firstName + ", " + lastName;
                    }
                    request.setAttribute("fullName", fullName);
                    request.getRequestDispatcher("account.jsp").forward(request, response);
                    break;
                case "listAccount":
                    if (login == null || login.getRoleInSystem() != 1) {
                        response.sendRedirect("index.jsp");
                        return;
                    }
                    List<Account> listAccount = accountService.listAll();
                    if (listAccount != null && !listAccount.isEmpty()) {
                        msg = "List accounts successfully!";
                        request.setAttribute("success_msg", msg);
                        request.setAttribute("listAccounts", listAccount);
                        request.getRequestDispatcher("listAccount.jsp").forward(request, response);
                        return;
                    }
                    msg = "List accounts fail!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("listAccount.jsp").forward(request, response);
                    break;
                case "activeAccount": {
                    if (login == null || login.getRoleInSystem() != 1) {
                        response.sendRedirect("index.jsp");
                        return;
                    }

                    Account active = accountService.getObjectById(request.getParameter("id"));
                    if (active != null) {
                        active.setIsUse(true);
                        int r = accountService.updateRec(active);
                        msg = (r == 1) ? "Active account successfully!" : "Active account fail!";
                        request.setAttribute(r == 1 ? "success_msg" : "error_msg", msg);
                        request.getRequestDispatcher("AccountController?action=listAccount").forward(request, response);
                        return;
                    }
                    msg = "Active account fail! Account not found.";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("AccountController?action=listAccount").forward(request, response);
                    break;
                }
                case "deactiveAccount":
                    if (login == null || login.getRoleInSystem() != 1) {
                        response.sendRedirect("index.jsp");
                        return;
                    }

                    Account deactive = accountService.getObjectById(request.getParameter("id"));
                    if (deactive != null) {
                        deactive.setIsUse(false);
                        int r = accountService.updateRec(deactive);
                        msg = (r == 1) ? "Deactive account successfully!" : "Deactive account fail!";
                        request.setAttribute(r == 1 ? "success_msg" : "error_msg", msg);
                        request.getRequestDispatcher("AccountController?action=listAccount").forward(request, response);
                        return;
                    }
                    msg = "Deactive account fail! Account not found.";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("AccountController?action=listAccount").forward(request, response);
                    break;
                case "deleteAccount":
                    if (login == null || login.getRoleInSystem() != 1) {
                        response.sendRedirect("index.jsp");
                        return;
                    }

                    Account del = accountService.getObjectById(request.getParameter("id"));
                    if (del != null) {
                        try {
                            int r = accountService.deleteRec(del);
                            msg = (r == 1) ? "Delete account successfully!" : "Delete account fail!";
                            request.setAttribute(r == 1 ? "success_msg" : "error_msg", msg);
                        } catch (RuntimeException dbEx) {
                            request.setAttribute("error_msg",
                                    "Delete account fail! This account still has related data "
                                    + "(orders, comments, cart, etc.) and cannot be removed.");
                        }
                        request.getRequestDispatcher("AccountController?action=listAccount").forward(request, response);
                        return;
                    }
                    msg = "Delete account fail! Account not found.";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("AccountController?action=listAccount").forward(request, response);
                    break;
                default:
                    response.sendRedirect("index.jsp");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_msg", "System error: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } finally {
            accountService.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String msg;
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        String account = request.getParameter("Account");
        String pw = request.getParameter("Password");
        String firstName = request.getParameter("fn");
        String lastName = request.getParameter("ln");
        String phone = request.getParameter("phone");
        boolean gender = Boolean.parseBoolean(request.getParameter("gender"));
        int role = 3;

        // convert dob into date
        String dobString = request.getParameter("dob");
        java.sql.Date dob = null;
        if (dobString != null && !dobString.isEmpty()) {
            try {
                dob = java.sql.Date.valueOf(dobString);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        AccountService accountService = new AccountService();
        Account login = (Account) session.getAttribute("login");
        try {
            switch (action) {
                case "deleteAccount":
                    if (login == null) {
                        response.sendRedirect("index.jsp");
                        return;
                    }
                    Account del = accountService.getObjectById(login.getAccount());
                    if (del != null) {
                        try {
                            int result = accountService.deleteRec(del);
                            if (result == 1) {
                                response.sendRedirect("loginController?action=logout");
                                return;
                            }
                        } catch (RuntimeException dbEx) {
                            request.setAttribute("error_msg", "Delete account fail! This account still has related data (orders, comments, cart, etc.) and cannot be removed.");
                            request.getRequestDispatcher("AccountController?action=displayAccount").forward(request, response);
                            return;
                        }
                    }
                    request.setAttribute("error_msg", "Delete account fail! Account not found.");
                    request.getRequestDispatcher("AccountController?action=displayAccount").forward(request, response);
                    break;
                case "updateProfile":
                    if (login == null) {
                        response.sendRedirect("index.jsp");
                        return;
                    }
                    //check email
                    if (!ValidationUtils.isValidEmail(account)) {
                        request.setAttribute("error_msg", "Invalid email!");
                        request.getRequestDispatcher("account.jsp").forward(request, response);
                        return;
                    }
                    //chekc phone
                    if (!ValidationUtils.isValidPhone(phone)) {
                        request.setAttribute("error_msg", "Invalid phone number!");
                        request.getRequestDispatcher("account.jsp").forward(request, response);
                        return;
                    }

                    Account profileToUpdate = accountService.getObjectById(login.getAccount());

                    if (profileToUpdate != null) {
                        profileToUpdate.setFirstname(firstName);
                        profileToUpdate.setLastname(lastName);
                        profileToUpdate.setPhone(phone);
                        if (dob != null) {
                            profileToUpdate.setDob(dob);
                        }
                        profileToUpdate.setGender(gender);
                        int r = accountService.updateRec(profileToUpdate);
                        if (r == 1) {
                            session.setAttribute("login", profileToUpdate);
                            response.sendRedirect("AccountController?action=displayAccount");
                            return;
                        } else {
                            request.setAttribute("error_msg", "Profile update failed!");
                            request.getRequestDispatcher("account.jsp").forward(request, response);
                        }
                    }
                    break;
                case "addAccount": {
                    String errorMsg = null;
                    if (!ValidationUtils.isValidEmail(account)) {
                        errorMsg = "Invalid email address.";
                    } else if (!ValidationUtils.isStrongPassword(pw)) {
                        errorMsg = "Password must be at least 8 characters, contain an uppercase letter and a digit.";
                    } else if (!ValidationUtils.isValidPhone(phone)) {
                        errorMsg = "Invalid Vietnamese phone number.";
                    } else if (accountService.getObjectById(account) != null) {
                        errorMsg = "An account with this email already exists.";
                    }

                    if (errorMsg != null) {
                        request.setAttribute("error_msg", errorMsg);
                        request.setAttribute("prev_account", account);
                        request.setAttribute("prev_fn", firstName);
                        request.setAttribute("prev_ln", lastName);
                        request.setAttribute("prev_phone", phone);
                        request.setAttribute("prev_dob", dob);
                        request.setAttribute("prev_gender", gender);
                        request.getRequestDispatcher("addAccount.jsp").forward(request, response);
                        return;
                    }

                    String hashedPass = PasswordUtils.hash(pw);
                    Account obj = new Account(account, hashedPass, firstName, lastName, dob, gender, phone, true, role);
                    try {
                        int result = accountService.insertRec(obj);
                        if (result == 1) {
                            response.sendRedirect("login.jsp");
                            return;
                        }
                        response.sendRedirect("index.jsp");
                    } catch (RuntimeException dbEx) {
                        request.setAttribute("error_msg", "Could not create account: " + dbEx.getMessage());
                        request.setAttribute("prev_account", account);
                        request.setAttribute("prev_fn", firstName);
                        request.setAttribute("prev_ln", lastName);
                        request.setAttribute("prev_phone", phone);
                        request.setAttribute("prev_dob", dob);
                        request.setAttribute("prev_gender", gender);
                        request.getRequestDispatcher("addAccount.jsp").forward(request, response);
                    }
                    break;
                }

                case "changePassword":
                    msg = "Change Password successfully!";
                    String currentPassword = request.getParameter("currentPassword");
                    String newPassword = request.getParameter("newPassword");
                    String confirmPassword = request.getParameter("confirmPassword");

                    if (login == null) {
                        msg = "Account not found!";
                        request.setAttribute("error_msg", msg);
                        request.getRequestDispatcher("account.jsp").forward(request, response);
                        return;
                    }

                    // Validate null
                    if (currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
                        msg = "Missing required fields!";
                        request.setAttribute("error_msg", msg);
                        request.getRequestDispatcher("account.jsp").forward(request, response);
                        return;
                    }

                    if (!PasswordUtils.verify(currentPassword, login.getPass())) {
                        msg = "Incorrect current password!";
                        request.setAttribute("error_msg", msg);
                        request.getRequestDispatcher("account.jsp").forward(request, response);
                        return;
                    }

                    if (!ValidationUtils.isStrongPassword(newPassword)) {
                        msg = "The new password must contain more than 8 characters, which includes both uppercase character and number!";
                        request.setAttribute("error_msg", msg);
                        request.getRequestDispatcher("account.jsp").forward(request, response);
                        return;
                    }

                    if (!newPassword.equals(confirmPassword)) {
                        msg = "New Password doesn't match confirm Password!";
                        request.setAttribute("error_msg", msg);
                        request.getRequestDispatcher("account.jsp").forward(request, response);
                        return;
                    }
                    login.setPass(PasswordUtils.hash(newPassword));
                    int r = accountService.updateRec(login);
                    if (r == 1) {
                        response.sendRedirect("AccountController?action=displayAccount");
                    } else {
                        request.setAttribute("error_msg", "Change Password failed!");
                        request.getRequestDispatcher("account.jsp").forward(request, response);
                    }
                    break;
                default:
                    response.sendRedirect("index.jsp");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_msg", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } finally {
            accountService.close();
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
