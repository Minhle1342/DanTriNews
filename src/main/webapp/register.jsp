<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản - News Portal</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        :root {
            --primary-green: #006837; /* Màu xanh chủ đạo đồng bộ */
            --glass-bg: rgba(255, 255, 255, 0.95);
            --text-dark: #333;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-image: url('https://images.unsplash.com/photo-1585829365295-ab7cd400c167?q=80&w=2070&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }

        /* Lớp phủ màu xanh */
        body::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, rgba(0, 104, 55, 0.85), rgba(0, 0, 0, 0.7));
            z-index: -1;
        }

        .wrapper {
            width: 100%;
            max-width: 1000px;
            min-height: 600px;
            background: var(--glass-bg);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            display: flex;
            overflow: hidden;
            margin: 20px;
        }

        /* Phần hình ảnh bên trái */
        .left-panel {
            width: 40%;
            background: linear-gradient(135deg, #006837, #2e7d32);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
            color: white;
            text-align: center;
            position: relative;
        }
        
        .left-panel img {
            background: white;
            padding: 10px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        /* Phần Form bên phải */
        .right-panel {
            width: 60%;
            padding: 40px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        h2 {
            color: var(--primary-green);
            font-weight: 700;
            margin-bottom: 30px;
            text-align: center;
        }

        /* Tùy chỉnh Floating Labels */
        .form-floating > .form-control {
            border: 1px solid #ddd;
            border-radius: 10px;
        }
        
        .form-floating > .form-control:focus {
            border-color: var(--primary-green);
            box-shadow: 0 0 0 0.25rem rgba(0, 104, 55, 0.15);
        }

        .form-floating > label {
            color: #666;
        }

        /* Style cho phần báo lỗi */
        .error-message {
            font-size: 0.85rem;
            color: #dc3545;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Button Đăng ký */
        .btn-register {
            width: 100%;
            padding: 12px;
            background: var(--primary-green);
            color: white;
            font-weight: 600;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .btn-register:hover {
            background: #00502b;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 104, 55, 0.3);
        }

        .link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        .link a {
            color: var(--primary-green);
            font-weight: 600;
            text-decoration: none;
        }

        .link a:hover {
            text-decoration: underline;
        }

        /* Responsive Mobile */
        @media (max-width: 768px) {
            .wrapper {
                flex-direction: column;
                height: auto;
            }
            .left-panel {
                width: 100%;
                padding: 30px;
            }
            .right-panel {
                width: 100%;
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>

<div class="wrapper">
    <div class="left-panel">
        <img src="${pageContext.request.contextPath}/assets/uploads/DanTriLogo.png" alt="Logo" width="180">
        <h4>Đăng ký</h4>
        <p style="opacity: 0.8; margin-top: 10px;">Đăng ký ngay để trở thành 1 thành viên của báo Dân Trí!</p>
    </div>

    <div class="right-panel">
        <h2>Tạo tài khoản mới</h2>

        <%
            String registerSuccess = null;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if ("registerSuccess".equals(c.getName())) {
                        registerSuccess = c.getValue();
                        c.setMaxAge(0);
                        response.addCookie(c);
                    }
                }
            }
        %>
        <c:if test="${not empty registerSuccess}">
            <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <div><%= registerSuccess %></div>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">

            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="floatingUsername" name="username" placeholder="Tên đăng nhập" value="${bean.username}">
                <label for="floatingUsername">Tên đăng nhập</label>
                
                <c:if test="${not empty bean.errors.errUsername or not empty registerErr.errUsername}">
                    <div class="error-message">
                        <i class="bi bi-exclamation-circle"></i> 
                        ${bean.errors.errUsername} ${registerErr.errUsername}
                    </div>
                </c:if>
            </div>

            <div class="form-floating mb-3">
                <input type="email" class="form-control" id="floatingEmail" name="email" placeholder="name@example.com" value="${bean.email}">
                <label for="floatingEmail">Email</label>
                
                <c:if test="${not empty bean.errors.errEmail or not empty registerErr.errEmail}">
                    <div class="error-message">
                        <i class="bi bi-exclamation-circle"></i>
                        ${bean.errors.errEmail} ${registerErr.errEmail}
                    </div>
                </c:if>
            </div>

            <div class="form-floating mb-3">
                <input type="password" class="form-control" id="floatingPassword" name="password" placeholder="Mật khẩu" value="${bean.password}">
                <label for="floatingPassword">Mật khẩu</label>
                
                <c:if test="${not empty bean.errors.errPassword}">
                    <div class="error-message">
                        <i class="bi bi-exclamation-circle"></i>
                        ${bean.errors.errPassword}
                    </div>
                </c:if>
            </div>

            <div class="form-floating mb-3">
                <input type="text" class="form-control" id="floatingPhone" name="phone" placeholder="Số điện thoại" value="${bean.phone}">
                <label for="floatingPhone">Số điện thoại</label>
                
                <c:if test="${not empty bean.errors.errPhone or not empty registerErr.errPhone}">
                    <div class="error-message">
                        <i class="bi bi-exclamation-circle"></i>
                        ${bean.errors.errPhone} ${registerErr.errPhone}
                    </div>
                </c:if>
            </div>

            <div class="form-floating mb-4">
                <input type="text" class="form-control" id="floatingName" name="name" placeholder="Họ và tên" value="${bean.name}">
                <label for="floatingName">Họ và tên</label>
                
                <c:if test="${not empty bean.errors.errName}">
                    <div class="error-message">
                        <i class="bi bi-exclamation-circle"></i>
                        ${bean.errors.errName}
                    </div>
                </c:if>
            </div>

            <button type="submit" class="btn-register">Đăng ký</button>

            <div class="link">
                <p class="text-secondary">Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a></p>
            </div>

        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>