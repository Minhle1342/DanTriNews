package Controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Entities.Transaction;
import Entities.User;
import Services.TransactionServices;
import Services.UserServices;

@WebServlet("/payment/return")
public class PaymentReturnController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // ... (Đoạn code lấy params map fields giữ nguyên) ...
            Map<String, String> fields = new HashMap<>();
            for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements(); ) {
                String fieldName = URLEncoder.encode(params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(req.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }

         // Lấy tham số trả về từ VNPay
            String responseCode = req.getParameter("vnp_ResponseCode");
            String txnRef = req.getParameter("vnp_TxnRef");
            String vnpTransactionNo = req.getParameter("vnp_TransactionNo");
            String orderInfo = req.getParameter("vnp_OrderInfo");
            String amountStr = req.getParameter("vnp_Amount");

            long amount = 0;
            if (amountStr != null && !amountStr.isEmpty()) {
                amount = Long.parseLong(amountStr) / 100; // Chia 100 để về VNĐ
            }

            // Lấy User từ Session
            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                // Nếu mất session, chuyển về trang login
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            // --- TẠO ĐỐI TƯỢNG TRANSACTION ---
            Transaction trans = new Transaction();
            trans.setAmount(amount);
            trans.setOrderInfo(orderInfo);
            trans.setVnpTxnRef(txnRef);
            trans.setVnpTransactionNo(vnpTransactionNo);
            trans.setCreateAt(new Date()); // Lấy thời gian hiện tại

            String message = "";

            if ("00".equals(responseCode)) {
                // THANH TOÁN THÀNH CÔNG
                trans.setStatus(1);
                message = "Thanh toán thành công!";

                // Kích hoạt VIP (Nếu có lỗi ở đây thì vẫn phải lưu Transaction)
                try {
                    int daysToAdd = (amount >= 500000) ? 365 : 30;
                    UserServices.activateVip(user.getId(), daysToAdd);

                    // Cập nhật lại session
                    User updatedUser = UserServices.getById(user.getId());
                    req.getSession().setAttribute("user", updatedUser);
                } catch (Exception ex) {
                    System.out.println("Lỗi khi kích hoạt VIP: " + ex.getMessage());
                }

            } else {
                // THANH TOÁN THẤT BẠI
                trans.setStatus(2);
                message = "Thanh toán thất bại. Mã lỗi: " + responseCode;
            }

            // --- GỌI SERVICE LƯU VÀO DB ---
            boolean isSaved = TransactionServices.saveTransaction(trans, user.getId());

            if (!isSaved) {
                System.out.println("Cảnh báo: Không lưu được lịch sử giao dịch.");
            }

            req.setAttribute("message", message);
            req.getRequestDispatcher("/payment_result.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("Lỗi xử lý: " + e.getMessage());
        }


        req.getRequestDispatcher("/payment_result.jsp").forward(req, resp);
    }
}