package Controller;

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
        String action = request.getParameter("action");
        String msg;
        if (action == null) {
            action = "listCategory"; // Mặc định nếu không có action
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

                case "updateCategory":
                    String updateId = request.getParameter("id");
                    if (updateId != null && !updateId.isEmpty()) {
                        Category catUpdate = categoryService.getObjectById(updateId);
                        request.setAttribute("cat", catUpdate);
                        request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
                        return;
                    }
                    msg = "Invalid update id";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
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

        String action = request.getParameter("action");
        String categoryName = request.getParameter("categoryName");
        String memo = request.getParameter("memo");
        String msg;
        CategoryService categoryService = new CategoryService();
        try {
            switch (action) {
                case "addCategory":
                    if (categoryName != null && !categoryName.isEmpty()) {
                        Category newObj = new Category(0, categoryName.trim(), memo);
                        categoryService.insertRec(newObj);
                        msg = "Add category successfully!";
                        request.setAttribute("success_msg", msg);
                        request.getRequestDispatcher("CategoryController?action=listCategory").forward(request, response);
                        return;
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
                        categoryService.updateRec(catUpdate);

                        request.setAttribute("success_msg", "Category updated successfully!");
                        request.setAttribute("cat", catUpdate); // Giữ lại data để hiện lên form
                        request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
                        return;
                    }
                    request.setAttribute("error_msg", "Updated category fail!");
                    request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
                    break;

                default:
                    response.sendRedirect("index.jsp");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_msg", "An error occurred: " + e.getMessage());
            if ("updateCategory".equals(action)) {
                request.getRequestDispatcher("updateCategory.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("CategoryController?action=listCategory").forward(request, response);
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
