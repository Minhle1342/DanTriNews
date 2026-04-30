package Controller;

import java.io.IOException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;

import Beans.RegisterBean;
import Entities.User;
import Services.UserServices;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println(">>> REGISTER SERVLET RUNNING");

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        try {
            RegisterBean bean = new RegisterBean();
            BeanUtils.populate(bean, req.getParameterMap());
            req.setAttribute("bean", bean);

            // Nếu Bean không có lỗi validate form
            if (bean.getErrors().isEmpty()) {

                User user = new User();
                user.setUsername(bean.getUsername());
                user.setPassword(bean.getPassword()); // Lưu ý: Nên mã hóa mật khẩu (MD5/BCrypt) ở đây trước khi set
                user.setName(bean.getName());
                user.setEmail(bean.getEmail());
                user.setPhone(bean.getPhone());

                // --- ĐOẠN SỬA QUAN TRỌNG ---
                user.setRole(1);      // Mặc định Role = 1 (User thường)
                user.setStatus(true); // Mặc định Status = true (Hoạt động ngay)
                // ---------------------------

                Map<String, String> registerErr = UserServices.register(user);

                // Nếu Map lỗi rỗng => Đăng ký thành công
                if (registerErr.isEmpty()) {
                    // Tạo cookie thông báo (Lưu ý: Không dùng ký tự đặc biệt hoặc khoảng trắng trong value cookie cũ)
                    Cookie notif = new Cookie("registerSuccess", "Register_Success");
                    notif.setMaxAge(5); // Tồn tại 5 giây
                    notif.setPath("/"); // Set path để cookie có hiệu lực toàn bộ web
                    resp.addCookie(notif);

                    resp.sendRedirect(req.getContextPath() + "/login");
                    return; // Kết thúc hàm để không chạy lệnh forward bên dưới
                } else {
                    // Nếu có lỗi từ Service (trùng tên, email...) -> Gửi lỗi về JSP
                    req.setAttribute("registerErr", registerErr);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("register.jsp").forward(req, resp);
    }
}