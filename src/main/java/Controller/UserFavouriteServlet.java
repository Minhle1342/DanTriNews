package Controller;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Video;
import Services.VideoServices;
@WebServlet("/user/favourites")
public class UserFavouriteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Video> favourites = VideoServices.getFavouritedVideosByUserId(userId);
        req.setAttribute("favourites", favourites);

        req.getRequestDispatcher("/editor/editorWorkSpace.jsp").forward(req, resp);
    }
}

