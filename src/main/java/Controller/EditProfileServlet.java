package Controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Beans.UserProfileEditBean;
import Entities.Category;
import Entities.User;
import Services.CategoryServices;
import Services.UserServices;

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("user");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Category> categories = CategoryServices.getAll();
        req.setAttribute("categories", categories);


        UserProfileEditBean bean = new UserProfileEditBean();
        bean.setUsername(loginUser.getUsername());
        bean.setEmail(loginUser.getEmail());
        bean.setName(loginUser.getName());
        bean.setPhone(loginUser.getPhone());

        req.setAttribute("userBean", bean);
        req.getRequestDispatcher("/editProfile.jsp").forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("user");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        UserProfileEditBean bean = new UserProfileEditBean();
        bean.setUsername(loginUser.getUsername());
        bean.setEmail(loginUser.getEmail());
        bean.setName(req.getParameter("name"));
        bean.setPhone(req.getParameter("phone"));
        bean.setPassword(req.getParameter("password"));

        boolean valid = true;

        if (bean.getName() == null || bean.getName().trim().length() < 3) {
            bean.getErrors().put("name", "Họ tên phải có ít nhất 3 ký tự");
            valid = false;
        }

        if (bean.getPhone() == null || !bean.getPhone().matches("^0\\d{9}$")) {
            bean.getErrors().put("phone", "Số điện thoại không hợp lệ");
            valid = false;
        }

        if (bean.getPassword() != null && bean.getPassword().length() > 0 &&
                bean.getPassword().length() < 6) {
            bean.getErrors().put("password", "Mật khẩu phải từ 6 ký tự");
            valid = false;
        }

        if (!valid) {
            req.setAttribute("userBean", bean);
            req.getRequestDispatcher("/editProfile.jsp").forward(req, resp);
            return;
        }

        UserServices service = new UserServices();
        boolean updated = service.updateProfile(loginUser.getId(), bean);

        if (!updated) {
            bean.getErrors().put("name", "Cập nhật thất bại, thử lại");
            req.setAttribute("userBean", bean);
            req.getRequestDispatcher("/editProfile.jsp").forward(req, resp);
            return;
        }

        loginUser.setName(bean.getName());
        loginUser.setPhone(bean.getPhone());
        session.setAttribute("user", loginUser);

        resp.sendRedirect(req.getContextPath() + "/profile?success=1");
    }
}
