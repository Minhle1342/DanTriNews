<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - News Portal</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #006837; /* Màu chủ đạo xanh lục đậm */
            --light-green: #e8f5e9;
            --text-dark: #333;
            --glass-bg: rgba(255, 255, 255, 0.95);
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-image: url('https://images.unsplash.com/photo-1504711434969-e33886168f5c?q=80&w=2070&auto=format&fit=crop'); /* Ảnh nền báo chí/tin tức */
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }

        /* Lớp phủ màu xanh lên nền */
        body::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(135deg, rgba(0, 104, 55, 0.8), rgba(0, 0, 0, 0.6));
            z-index: -1;
        }

        /* Container chính của card đăng nhập */
        .login-card {
            background: var(--glass-bg);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            width: 100%;
            max-width: 900px;
            min-height: 550px;
            display: flex;
            position: relative;
        }

        /* Phần hình ảnh bên trái (Ẩn trên mobile) */
        .login-banner {
            background: linear-gradient(135deg, #006837, #2e7d32);
            width: 45%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: white;
            padding: 40px;
            position: relative;
            overflow: hidden;
        }
        
        /* Hiệu ứng trang trí bên trái */
        .login-banner::after {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            bottom: -50px;
            right: -50px;
        }

        /* Phần form bên phải */
        .login-form-container {
            width: 55%;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .brand-title {
            font-weight: 700;
            color: var(--primary-green);
            margin-bottom: 10px;
        }

        .welcome-text {
            color: #666;
            font-size: 14px;
            margin-bottom: 30px;
        }

        /* Tùy chỉnh Floating Labels của Bootstrap */
        .form-floating > .form-control {
            border: 2px solid #eee;
            border-radius: 12px;
            padding-left: 20px;
        }

        .form-floating > .form-control:focus {
            border-color: var(--primary-green);
            box-shadow: 0 0 0 4px rgba(0, 104, 55, 0.1); /* Hiệu ứng focus xanh lục */
        }

        .form-floating > label {
            padding-left: 20px;
            color: #999;
        }

        .input-group-text {
            background: transparent;
            border: none;
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 5;
            color: var(--primary-green);
        }

        /* Nút đăng nhập */
        .btn-login {
            background: var(--primary-green);
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 16px;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(0, 104, 55, 0.3);
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 10px;
        }

        .btn-login:hover {
            background: #00502b;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 104, 55, 0.4);
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        .register-link a {
            color: var(--primary-green);
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        /* Style cho thông báo lỗi */
        .error-feedback {
            font-size: 12px;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Responsive cho Mobile */
        @media (max-width: 768px) {
            .login-card {
                flex-direction: column;
                height: auto;
                max-width: 450px;
                margin: 20px;
            }
            .login-banner {
                display: none; /* Ẩn phần banner trên mobile để tập trung form */
            }
            .login-form-container {
                width: 100%;
                padding: 40px 30px;
            }
        }
    </style>
</head>
<body>

    <div class="login-card">
        <div class="login-banner">
            <img src="${pageContext.request.contextPath}/assets/uploads/DanTriLogo.png" 
                 alt="Logo" width="180" class="mb-4 bg-white p-2 rounded">
            <h2 class="fw-bold mb-3">Dân Trí</h2>
            <p class="text-center opacity-75">Cập nhật tin tức nóng hổi, chính xác và nhanh chóng nhất mọi lúc mọi nơi.</p>
        </div>

        <div class="login-form-container">
            <h2 class="brand-title">Xin chào! 👋</h2>
            <p class="welcome-text">Vui lòng đăng nhập để tiếp tục.</p>

            <c:forEach var="c" items="${cookie}">
                <c:if test="${c.key == 'registerSuccess'}">
                    <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        <div>${c.value.value}</div>
                    </div>
                </c:if>
            </c:forEach>

            <form action="${pageContext.request.contextPath}/login" method="post">
                
                <div class="mb-4">
                    <div class="form-floating position-relative">
                        <input type="text" class="form-control ${not empty bean.errors.errUsernameOrEmail ? 'is-invalid' : ''}" 
                               id="username" 
                               name="usernameOrEmail" 
                               value="${bean.usernameOrEmail}" 
                               placeholder="Tên đăng nhập">
                        <label for="username">Tên đăng nhập hoặc Email</label>
                        <i class="bi bi-person input-group-text pe-none"></i> </div>
                    <c:if test="${not empty bean.errors.errUsernameOrEmail}">
                        <small class="text-danger error-feedback">
                            <i class="bi bi-exclamation-circle"></i> ${bean.errors.errUsernameOrEmail}
                        </small>
                    </c:if>
                </div>

                <div class="mb-2">
                   <div class="form-floating position-relative">
    <input type="password" 
           class="form-control ${not empty bean.errors.errPassword ? 'is-invalid' : ''}" 
           id="password" 
           name="password" 
           value="${bean.password}" 
           placeholder="Mật khẩu"
           style="padding-right: 45px;"> 
           
    <label for="password">Mật khẩu</label>

    <span class="position-absolute top-50 end-0 translate-middle-y me-3" 
          onclick="togglePassword('password', 'iconEye')" 
          style="cursor: pointer; z-index: 10;">
        <i id="iconEye" class="bi bi-eye-slash"></i>
    </span>
</div>
                    <c:if test="${not empty bean.errors.errPassword}">
                        <small class="text-danger error-feedback">
                            <i class="bi bi-exclamation-circle"></i> ${bean.errors.errPassword}
                        </small>
                    </c:if>
                </div>

                <c:if test="${not empty errLogin}">
                    <div class="alert alert-danger d-flex align-items-center mt-3 py-2" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <div>${errLogin}</div>
                    </div>
                </c:if>

               <div class="text-end mb-4">
    <a href="${pageContext.request.contextPath}/forgot-password" 
       class="text-decoration-none text-muted small">
       Quên mật khẩu?
    </a>
</div>

                <button type="submit" class="btn btn-primary btn-login">
                    Đăng Nhập
                </button>
                
                <hr class="my-4">
                        
                        <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080/ASM1_NguyenLeMinh_PC10524/login-google&response_type=code&client_id=113952238746-6vuqm6e78osnf04sb8fmn8fdsrphmtdq.apps.googleusercontent.com&approval_prompt=force" 
                           class="btn btn-danger w-100 d-flex align-items-center justify-content-center">
                            <i class="fab fa-google me-2"></i> Đăng nhập bằng Google
                        </a>

                <div class="register-link">
                    Chưa có tài khoản? 
                    <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
                </div>
                <hr>
                 <div class="register-link">
                   
                    <a href="${pageContext.request.contextPath}/">Quay về trang chủ</a>
                </div>
            </form>
            </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <c:if test="${lockedAccount == true}">
        <script>
            Swal.fire({
                icon: 'error',
                title: 'Tài khoản đã bị khóa',
                text: 'Vui lòng liên hệ quản trị viên để mở khóa.',
                confirmButtonColor: '#006837', /* Đổi màu nút alert theo theme */
                background: '#fff',
                iconColor: '#d33'
            });
        </script>
    </c:if>
    
    <script>
    function togglePassword(inputId, iconId) {
        const passwordInput = document.getElementById(inputId);
        const icon = document.getElementById(iconId);

        // Kiểm tra loại hiện tại của input
        if (passwordInput.type === "password") {
            // Chuyển sang text để hiện mật khẩu
            passwordInput.type = "text";
            // Đổi icon sang con mắt mở (bi-eye)
            icon.classList.remove("bi-eye-slash");
            icon.classList.add("bi-eye");
        } else {
            // Chuyển lại password để ẩn
            passwordInput.type = "password";
            // Đổi icon sang con mắt đóng (bi-eye-slash)
            icon.classList.remove("bi-eye");
            icon.classList.add("bi-eye-slash");
        }
    }
</script>

</body>
</html>