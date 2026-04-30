package Controller;


import java.io.IOException;
import java.util.List;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Comment;
import Services.CommentServices;


@WebServlet("/comment/load")
public class CommentLoadMoreController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int parentId = Integer.parseInt(req.getParameter("parentId"));
        int offset = Integer.parseInt(req.getParameter("offset"));

        List<Comment> list = CommentServices.getChildComments(parentId, offset, 5);

        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html");

        StringBuilder out = new StringBuilder();

        for (Comment c : list) {
            out.append("<div class='child-comment-item mt-2 ps-4 border-start'>")
               .append("<strong>").append(c.getUser().getName()).append("</strong>")
               .append("<p>").append(c.getContent()).append("</p>")
               .append("</div>");
        }

        resp.getWriter().write(out.toString());
    }
}

