package Controller;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Entities.User;
import Services.UserServices;
import Utils.GooglePojo;
import Utils.GoogleUtils;
import Utils.Utils; // Đừng quên import Utils để set Cookie

@WebServlet("/login-google")
public class LoginGoogleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            response.sendRedirect("login.jsp?error=GoogleLoginFailed");
            return;
        }

        try {
            // 1. Lấy Token & Info
            String accessToken = GoogleUtils.getToken(code);
            GooglePojo googleUser = GoogleUtils.getUserInfo(accessToken);

            // 2. Xử lý Logic nghiệp vụ
            UserServices service = new UserServices();
            User user = service.findByEmail(googleUser.getEmail());

            if (user == null) {
                // TẠO MỚI USER NẾU CHƯA CÓ
                user = new User();
                user.setUsername(googleUser.getEmail());
                user.setEmail(googleUser.getEmail());
                user.setName(googleUser.getName());
                user.setPassword(UUID.randomUUID().toString());

                // Lưu ý: LoginController đang check role == 1 cho User thường
                // Nên set role = 1 thay vì 0 để đồng bộ logic redirect
                user.setRole(1);

                user.setStatus(true);
                user.setPhone("");

                service.create(user);
            } else {
                // KIỂM TRA TRẠNG THÁI KHÓA (Đồng bộ logic chặn login)
                if (!user.isStatus()) {
                    // Chuyển hướng về login và báo lỗi khóa tài khoản
                    request.setAttribute("lockedAccount", true);
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    return;
                }
            }

            // 3. THIẾT LẬP SESSION (Đồng bộ với LoginController)
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId()); // Thêm dòng này để khớp với LoginController

            // 4. THIẾT LẬP COOKIE (Đồng bộ với LoginController)
            // Giúp giữ trạng thái đăng nhập lâu dài hoặc hỗ trợ các filter
            Utils.setCookie(Utils.COOKIE_KEY_USER_ID, String.valueOf(user.getId()), response);
            Utils.setCookie(Utils.COOKIE_KEY_ROLE, String.valueOf(user.getRole()), response);

            // 5. PHÂN QUYỀN CHUYỂN HƯỚNG (Đồng bộ với LoginController)
            int role = user.getRole();

            // Role 1 (User thường) hoặc Role 0 (Mặc định cũ nếu có) -> Trang chủ
            if (role == 1 || role == 0) {
                response.sendRedirect(request.getContextPath() + "/");
                return;
            }

            // Role 2 -> Editor
            if (role == 2) {
                response.sendRedirect(request.getContextPath() + "/editor/workspace");
                return;
            }

            // Role 3 -> Admin
            if (role == 3) {
                response.sendRedirect(request.getContextPath() + "/admin/adminPanel");
                return;
            }

            // Mặc định nếu không khớp role nào
            response.sendRedirect(request.getContextPath() + "/");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=SystemError");
        }
    }
}