package Controller;

import Model.Account;
import Model.Category;
import Model.Product;
import Model.Service.ProductService;
import Model.Service.CategoryService;
import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // RẤT QUAN TRỌNG
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
@WebServlet(name = "ProductController", urlPatterns = {"/ProductController"})
public class ProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "listProduct";
        }
        String msg;
        HttpSession session = request.getSession();
        Account login = (Account) session.getAttribute("login");

        ProductService productService = new ProductService();
        CategoryService categoryService = new CategoryService();
        try {
            switch (action) {
                case "listProduct":
                    List<Product> list = productService.listAll();
                    if (list != null && !list.isEmpty()) {
                        msg = "List products successfully!";
                        request.setAttribute("products", list);
                        request.setAttribute("success_msg", msg);
                        request.getRequestDispatcher("listProducts.jsp").forward(request, response);
                        return;
                    }
                    msg = "List products fail!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("listProducts.jsp").forward(request, response);
                    break;

                case "deleteProduct":
                    if (login == null || login.getRoleInSystem() != 1) {
                        response.sendRedirect("index.jsp");
                        return;
                    }
                    String delId = request.getParameter("id");
                    if (delId != null && !delId.isEmpty()) {
                        Product del = productService.getObjectById(delId);
                        if (del != null) {
                            productService.deleteRec(del);
                            msg = "Delete product successfully!";
                            request.setAttribute("success_msg", msg);
                            request.getRequestDispatcher("ProductController?action=listProduct").forward(request, response);
                            return;
                        }
                    }
                    msg = "Delete product fail!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("ProductController?action=listProduct").forward(request, response);
                    break;

                case "home":
                    List<Product> listPublic = productService.listAll();
                    request.setAttribute("list", listPublic);
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                    break;
                case "updateProduct":
                    if (login == null || login.getRoleInSystem() != 1) {
                        response.sendRedirect("index.jsp");
                        return;
                    }
                    String updateId = request.getParameter("id");
                    if (updateId != null) {
                        Product p = productService.getObjectById(updateId);
                        if (p != null) {
                            List<Category> cats = categoryService.listAll();

                            request.setAttribute("p", p);
                            request.setAttribute("cats", cats);
                            request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
                            return;
                        }
                    }
                    msg = "Load updated product fail!";
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
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
            productService.close();
            categoryService.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Account login = (Account) session.getAttribute("login");

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "";
        }
        String id = request.getParameter("id");
        String productName = request.getParameter("productName");
        String categoryIdStr = request.getParameter("categoryId");
        String postDateString = request.getParameter("postDate");
        String brief = request.getParameter("brief");
        String priceStr = request.getParameter("price");
        String discountStr = request.getParameter("discount");

        String msg;
        ProductService productService = new ProductService();
        try {
            switch (action) {
                case "addProduct":
                    if (login == null || login.getRoleInSystem() != 1) {
                        response.sendRedirect("index.jsp");
                        return;
                    }
                    if (productName == null || productName.trim().isEmpty()) {
                        msg = "Empty product name";
                        request.setAttribute("error_msg", msg);
                        request.getRequestDispatcher("addProduct.jsp").forward(request, response);
                        return;
                    }
                    try {

                        String productId = "SP" + (System.currentTimeMillis() % 100000);

                        int categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : 0;
                        int price = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;
                        int discount = (discountStr != null && !discountStr.isEmpty()) ? Integer.parseInt(discountStr) : 0;

                        java.sql.Date postDate = null;
                        if (postDateString != null && !postDateString.isEmpty()) {
                            postDate = java.sql.Date.valueOf(postDateString);
                        }

                        // ĐÃ FIX LỖI UPLOAD ẢNH
                        String imageUrl = null;
                        Part filePart = request.getPart("image");
                        if (filePart != null && filePart.getSize() > 0) {
                            String originalFileName = filePart.getSubmittedFileName();
                            // Fix path: Đưa hẳn vào thư mục /images/sanPham/ để frontend gọi lên được
                            String uploadPath = getServletContext().getRealPath("/images/sanPham");
                            File uploadFolder = new File(uploadPath);
                            if (!uploadFolder.exists()) {
                                uploadFolder.mkdirs();
                            }

                            filePart.write(uploadPath + File.separator + originalFileName);
                            imageUrl = "/images/sanPham/" + originalFileName;
                        }

                        Product obj = new Product();
                        obj.setProductId(productId);
                        obj.setProductName(productName);
                        obj.setBrief(brief);
                        obj.setPrice(price);
                        obj.setDiscount(discount);
                        obj.setPostedDate(postDate);
                        obj.setAccount(login);
                        obj.setProductImage(imageUrl);

                        Category cat = new Category();
                        cat.setTypeId(categoryId);
                        obj.setType(cat);

                        productService.insertRec(obj);
                        // Nên redirect về trang quản lý thay vì index
                        response.sendRedirect("ProductController?action=listProduct");
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error_msg", "Lỗi hệ thống: " + e.getMessage());
                        request.getRequestDispatcher("addProduct.jsp").forward(request, response);
                        return;
                    }
                    break;

                case "updateProduct":
                    if (login == null || login.getRoleInSystem() != 1) {
                        response.sendRedirect("index.jsp");
                        return;
                    }
                    try {

                        int categoryId = (categoryIdStr != null && !categoryIdStr.isEmpty()) ? Integer.parseInt(categoryIdStr) : 0;
                        int price = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;
                        int discount = (discountStr != null && !discountStr.isEmpty()) ? Integer.parseInt(discountStr) : 0;

                        java.sql.Date postDate = null;
                        if (postDateString != null && !postDateString.isEmpty()) {
                            postDate = java.sql.Date.valueOf(postDateString);
                        }

                        // ĐÃ FIX LỖI UPLOAD ẢNH
                        String imageUrl = null;
                        Part filePart = request.getPart("image");
                        if (filePart != null && filePart.getSize() > 0) {
                            String originalFileName = filePart.getSubmittedFileName();
                            // Fix path
                            String uploadPath = getServletContext().getRealPath("/images/sanPham");
                            File uploadFolder = new File(uploadPath);
                            if (!uploadFolder.exists()) {
                                uploadFolder.mkdirs();
                            }

                            filePart.write(uploadPath + File.separator + originalFileName);
                            imageUrl = "/images/sanPham/" + originalFileName;
                        } else {
                            String imageUrlParam = request.getParameter("imageUrl");
                            if (imageUrlParam != null && !imageUrlParam.trim().isEmpty()) {
                                imageUrl = imageUrlParam.trim();
                            } else {
                                Product existing = productService.getObjectById(id);
                                if (existing != null) {
                                    imageUrl = existing.getProductImage();
                                }
                            }
                        }

                        Product obj = new Product();
                        obj.setProductId(id);
                        obj.setProductName(productName);
                        obj.setBrief(brief);
                        obj.setPrice(price);
                        obj.setDiscount(discount);
                        obj.setPostedDate(postDate);
                        obj.setAccount(login);
                        obj.setProductImage(imageUrl);

                        Category cat = new Category();
                        cat.setTypeId(categoryId);
                        obj.setType(cat);

                        productService.updateRec(obj);
                        // Nên redirect về trang quản lý thay vì index
                        response.sendRedirect("ProductController?action=listProduct");
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error_msg", "Lỗi hệ thống: " + e.getMessage());
                        // Nếu lỗi, điều hướng lại về trang update kèm theo ID để load lại form
                        response.sendRedirect("ProductController?action=updateProduct&id=" + request.getParameter("id") + "&error=System Error");
                    }
                    break;
                default:
                    response.sendRedirect("index.jsp");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error_msg", "System Error: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        } finally {
            productService.close();
        }
    }

    @Override
    public String getServletInfo() {
        return "Product Controller - Handled Multipart & MVC";
    }
}
