package Controller;


import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Category;
import Entities.Video;
import Services.CategoryServices;
import Services.VideoServices;

@WebServlet("/category")
public class CategoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idRaw = req.getParameter("id");

        if (idRaw == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        int id = Integer.parseInt(idRaw);

        // danh mục
        Category category = CategoryServices.getInfoById(id);
        if (category == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        req.setAttribute("currentCategory", category);

        // danh sách danh mục để render navbar
        List<Category> categories = CategoryServices.getAll();
        req.setAttribute("categories", categories);

        // lấy danh sách bài viết theo danh mục
        List<Video> videos = VideoServices.getByCategory(id);
        req.setAttribute("videos", videos);

        req.getRequestDispatcher("home.jsp").forward(req, resp);
    }
}

