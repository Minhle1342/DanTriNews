<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    // Lấy các tham số từ VNPay trả về
    String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
    String vnp_Amount = request.getParameter("vnp_Amount");
    String vnp_TxnRef = request.getParameter("vnp_TxnRef");
    String vnp_PayDate = request.getParameter("vnp_PayDate"); // Format: yyyyMMddHHmmss
    
    boolean isSuccess = "00".equals(vnp_ResponseCode);
    
    // Xử lý format tiền tệ
    String formattedAmount = "0";
    if (vnp_Amount != null) {
        try {
            long amount = Long.parseLong(vnp_Amount) / 100;
            DecimalFormat formatter = new DecimalFormat("###,###");
            formattedAmount = formatter.format(amount);
        } catch (Exception e) { }
    }

    // Xử lý format ngày giờ
    String formattedDate = "";
    if (vnp_PayDate != null) {
        try {
            SimpleDateFormat originalFormat = new SimpleDateFormat("yyyyMMddHHmmss");
            Date date = originalFormat.parse(vnp_PayDate);
            SimpleDateFormat newFormat = new SimpleDateFormat("HH:mm:ss - dd/MM/yyyy");
            formattedDate = newFormat.format(date);
        } catch (Exception e) { }
    }
    
    // Lấy message từ Controller gửi sang
    String message = (String) request.getAttribute("message");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả thanh toán</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --success-color: #10b981;
            --error-color: #ef4444;
            --bg-color: #f8fafc;
            --card-bg: #ffffff;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-color);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
        }

        .result-card {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 3rem;
            width: 100%;
            max-width: 500px;
            text-align: center;
            box-shadow: 0 20px 40px -10px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }

        /* Animation cho Icon */
        .status-icon-wrapper {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 3rem;
            animation: popIn 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .success .status-icon-wrapper {
            background-color: #dcfce7;
            color: var(--success-color);
        }

        .error .status-icon-wrapper {
            background-color: #fee2e2;
            color: var(--error-color);
        }

        @keyframes popIn {
            0% { transform: scale(0); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        .result-title {
            font-weight: 800;
            margin-bottom: 0.5rem;
            color: #1e293b;
        }

        .result-message {
            color: #64748b;
            margin-bottom: 2rem;
        }

        .transaction-details {
            background-color: #f1f5f9;
            border-radius: 16px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: left;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.8rem;
            font-size: 0.95rem;
        }

        .detail-row:last-child {
            margin-bottom: 0;
            padding-top: 0.8rem;
            border-top: 1px dashed #cbd5e1;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .detail-label { color: #64748b; }
        .detail-value { color: #1e293b; font-weight: 600; }

        .btn-action {
            width: 100%;
            padding: 14px;
            border-radius: 12px;
            font-weight: 700;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }

        .btn-success-custom {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            box-shadow: 0 10px 20px -5px rgba(16, 185, 129, 0.4);
        }

        .btn-error-custom {
            background: #ffffff;
            border: 2px solid #e2e8f0;
            color: #1e293b;
        }
        
        .btn-error-custom:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
        }

        /* Confetti Effect (Optional decorative circles) */
        .deco-circle {
            position: absolute;
            border-radius: 50%;
            opacity: 0.1;
            z-index: 0;
        }
    </style>
</head>
<body>

    <div class="result-card <%= isSuccess ? "success" : "error" %>">
        <div class="deco-circle" style="width: 200px; height: 200px; background: <%= isSuccess ? "#10b981" : "#ef4444" %>; top: -50px; left: -50px;"></div>
        <div class="deco-circle" style="width: 150px; height: 150px; background: <%= isSuccess ? "#10b981" : "#ef4444" %>; bottom: -30px; right: -30px;"></div>

        <div style="position: relative; z-index: 1;">
            <div class="status-icon-wrapper">
                <% if (isSuccess) { %>
                    <i class="bi bi-check-lg"></i>
                <% } else { %>
                    <i class="bi bi-x-lg"></i>
                <% } %>
            </div>

            <h2 class="result-title"><%= isSuccess ? "Thanh toán thành công!" : "Giao dịch thất bại" %></h2>
            <p class="result-message"><%= message != null ? message : (isSuccess ? "Cảm ơn bạn đã nâng cấp VIP." : "Vui lòng kiểm tra lại thông tin và thử lại.") %></p>

            <% if (vnp_TxnRef != null) { %>
            <div class="transaction-details">
                <div class="detail-row">
                    <span class="detail-label">Mã giao dịch</span>
                    <span class="detail-value text-break"><%= vnp_TxnRef %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Thời gian</span>
                    <span class="detail-value"><%= formattedDate %></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Ngân hàng</span>
                    <span class="detail-value">NCB</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Tổng thanh toán</span>
                    <span class="detail-value" style="color: <%= isSuccess ? "#10b981" : "#ef4444" %>;">
                        <%= formattedAmount %> VNĐ
                    </span>
                </div>
            </div>
            <% } %>

            <% if (isSuccess) { %>
                <a href="${pageContext.request.contextPath}/" class="btn-action btn-success-custom">
                    <i class="bi bi-house-door-fill me-2"></i>Về trang chủ
                </a>
                <a href="${pageContext.request.contextPath}/editor/workspace" class="btn btn-link mt-3 text-muted text-decoration-none small">
                    Đến trang quản lý <i class="bi bi-arrow-right"></i>
                </a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/upgradeVip.jsp" class="btn-action btn-success-custom mb-3">
                    <i class="bi bi-arrow-counterclockwise me-2"></i>Thử lại
                </a>
                <a href="${pageContext.request.contextPath}/" class="btn-action btn-error-custom">
                    Về trang chủ
                </a>
            <% } %>
        </div>
    </div>

</body>
</html>