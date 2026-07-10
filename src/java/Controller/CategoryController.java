package Controller;

import Model.Account;
import Model.Category;
import Model.Service.CategoryService;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CategoryController", urlPatterns = {"/CategoryController"})
public class CategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account login = (Account) session.getAttribute("login");
        String action = request.getParameter("action");
        String msg;
        if (action == null) {
            action = "";
        }
        CategoryService categoryService = new CategoryService();
        try {
            switch (action) {
                case "listCategory":
                    List<Category> list = categoryService.listAll();
                    if (list != null && !list.isEmpty()) {
                        msg = "List categories successfully!";
                        request.setAttribute("categoryList", list);
                        request.setAttribute("success_msg", msg);
                        request.getRequestDispatcher("listCategory.jsp").forward(request, response);
                        return;
                    }
                    msg = "List categories fail!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("listCategory.jsp").forward(request, response);
                    break;

                case "deleteCategory":
                    if (login == null || login.getRoleInSystem() != 1) {
                        response.sendRedirect("index.jsp");
                        return;
                    }
                    String deleteId = request.getParameter("id");
                    Category catDelete = categoryService.getObjectById(deleteId);
                    if (catDelete != null) {
                        categoryService.deleteRec(catDelete);
                        msg = "Delete category successfully!";
                        request.setAttribute("success_msg", msg);
                        request.getRequestDispatcher("CategoryController?action=listCategory").forward(request, response);
                        return;
                    }
                    msg = "Delelte category fail!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("CategoryController?action=listCategory").forward(request, response);
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
            categoryService.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account login = (Account) session.getAttribute("login");
        if (login == null || login.getRoleInSystem() != 1) {
            response.sendRedirect("index.jsp");
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        String categoryName = request.getParameter("categoryName");
        String memo = request.getParameter("memo");
        String msg;
        CategoryService categoryService = new CategoryService();
        try {
            switch (action) {
                case "addCategory":
                    if (categoryName != null && !categoryName.isEmpty()) {
                        Category newObj = new Category(0, categoryName.trim(), memo);
                        int result = categoryService.insertRec(newObj);
                        if (result == 1) {
                            response.sendRedirect("CategoryController?action=listCategory");
                            return;
                        }
                    }
                    msg = "Add category fail!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("CategoryController?action=listCategory").forward(request, response);
                    break;
                case "updateCategory":
                    Category catUpdate = categoryService.getObjectById(request.getParameter("id"));
                    if (catUpdate != null) {
                        if (categoryName != null && !categoryName.isEmpty()) {
                            catUpdate.setCategoryName(categoryName);
                        }
                        if (memo != null) {
                            catUpdate.setMemo(memo);
                        }
                        int result = categoryService.updateRec(catUpdate);
                        if (result == 1) {
                            response.sendRedirect("CategoryController?action=listCategory");
                            return;
                        }
                    }
                    request.setAttribute("error_msg", "Updated category fail!");
                    request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
                    break;
                default:
                    System.out.println("DEFAULT HIT, action=[" + action + "]");
                    response.sendRedirect("index.jsp");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_msg", "An error occurred: " + e.getMessage());
            if ("updateCategory".equals(action)) {
                request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("addCategory.jsp").forward(request, response);
            }
        } finally {
            categoryService.close();
        }
    }

    @Override
    public String getServletInfo() {
        return "Category Controller - Standardized MVC";
    }
}
