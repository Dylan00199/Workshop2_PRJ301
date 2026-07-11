package Controller;

import Model.Account;
import Model.Category;
import Model.Comment;
import Model.Product;
import Model.Service.CommentService;
import Model.Service.ProductService;
import Model.Service.CategoryService;
import Model.Service.ViewHistoryService;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; 
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

    private List<Product> runSearch(HttpServletRequest request, ProductService productService) {
        String keyword = request.getParameter("keyword");

        Integer categoryId = null;
        String categoryIdStr = request.getParameter("categoryId");
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException ignored) {
            }
        }

        Integer minPrice = null;
        String minPriceStr = request.getParameter("minPrice");
        if (minPriceStr != null && !minPriceStr.isEmpty()) {
            try {
                minPrice = Integer.parseInt(minPriceStr);
            } catch (NumberFormatException ignored) {
            }
        }

        Integer maxPrice = null;
        String maxPriceStr = request.getParameter("maxPrice");
        if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
            try {
                maxPrice = Integer.parseInt(maxPriceStr);
            } catch (NumberFormatException ignored) {
            }
        }

        Boolean discountedOnly = null;
        String discountFilter = request.getParameter("discountFilter");
        if ("discounted".equals(discountFilter)) {
            discountedOnly = Boolean.TRUE;
        } else if ("noDiscount".equals(discountFilter)) {
            discountedOnly = Boolean.FALSE;
        }

        String sortByPrice = request.getParameter("sortByPrice"); 

        boolean anyFilter = (keyword != null && !keyword.isEmpty()) || categoryId != null
                || minPrice != null || maxPrice != null || discountedOnly != null
                || (sortByPrice != null && !sortByPrice.isEmpty());

        if (anyFilter) {
            return productService.search(keyword, categoryId, minPrice, maxPrice, discountedOnly, sortByPrice);
        }
        return productService.listAll();
    }

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
                case "listProduct": {
                    List<Product> list = runSearch(request, productService);
                    request.setAttribute("cats", categoryService.listAll());
                    if (list != null && !list.isEmpty()) {
                        msg = "List products successfully!";
                        request.setAttribute("products", list);
                        request.setAttribute("success_msg", msg);
                        request.getRequestDispatcher("listProducts.jsp").forward(request, response);
                        return;
                    }
                    msg = "No products match your search/filter.";
                    request.setAttribute("products", list);
                    request.setAttribute("error_msg", msg);
                    request.getRequestDispatcher("listProducts.jsp").forward(request, response);
                    break;
                }

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

                case "home": {
                    List<Product> listPublic = runSearch(request, productService);
                    request.setAttribute("list", listPublic);
                    request.setAttribute("cats", categoryService.listAll());
                    request.getRequestDispatcher("index.jsp").forward(request, response);
                    break;
                }

                case "detail": {
                    String detailId = request.getParameter("id");
                    if (detailId == null || detailId.isEmpty()) {
                        response.sendRedirect("ProductController?action=home");
                        return;
                    }
                    Product detail = productService.getObjectById(detailId);
                    if (detail == null) {
                        request.setAttribute("error_msg", "Product not found.");
                        request.getRequestDispatcher("ProductController?action=home").forward(request, response);
                        return;
                    }

                    if (login != null) {
                        ViewHistoryService viewHistoryService = new ViewHistoryService();
                        try {
                            viewHistoryService.recordView(login.getAccount(), detail.getProductId(), detail.getPrice());
                        } finally {
                            viewHistoryService.close();
                        }
                    }

                    CommentService commentService = new CommentService();
                    try {
                        request.setAttribute("comments", commentService.listByProduct(detailId));
                    } finally {
                        commentService.close();
                    }

                    request.setAttribute("p", detail);
                    request.getRequestDispatcher("ProductDetail.jsp").forward(request, response);
                    break;
                }
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
        String unit = request.getParameter("unit");

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

                        String imageUrl = null;
                        Part filePart = request.getPart("image");
                        if (filePart != null && filePart.getSize() > 0) {
                            String originalFileName = filePart.getSubmittedFileName();
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
                        response.sendRedirect("ProductController?action=listProduct");
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error_msg", "Systen error: " + e.getMessage());
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
                        String imageUrl = null;
                        Part filePart = request.getPart("image");
                        if (filePart != null && filePart.getSize() > 0) {
                            String originalFileName = filePart.getSubmittedFileName();
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
                        obj.setUnit(unit);

                        Category cat = new Category();
                        cat.setTypeId(categoryId);
                        obj.setType(cat);

                        productService.updateRec(obj);
                        response.sendRedirect("ProductController?action=listProduct");
                    } catch (Exception e) {
                        e.printStackTrace();
                        request.setAttribute("error_msg", "System error: " + e.getMessage());
                        response.sendRedirect("ProductController?action=updateProduct&id=" + request.getParameter("id") + "&error=System Error");
                    }
                    break;

                case "addComment": {
                    String productId = request.getParameter("productId");
                    String content = request.getParameter("content");

                    if (login == null) {
                        response.sendRedirect("login.jsp");
                        return;
                    }
                    if (productId == null || productId.isEmpty() || content == null || content.trim().isEmpty()) {
                        response.sendRedirect("ProductController?action=detail&id=" + productId);
                        return;
                    }

                    CommentService commentService = new CommentService();
                    try {
                        Comment c = new Comment(productId, login.getAccount(), content.trim(), new Date());
                        commentService.insertRec(c);
                    } finally {
                        commentService.close();
                    }
                    response.sendRedirect("ProductController?action=detail&id=" + productId);
                    break;
                }

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
