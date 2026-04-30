<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khôi phục mật khẩu | Tòa Soạn Online</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Merriweather:wght@700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #059669; /* Màu xanh ngọc lục bảo - Tin cậy, Hiện đại */
            --primary-hover: #047857;
            --text-dark: #1f2937;
            --text-muted: #6b7280;
            --bg-color: #f3f4f6;
        }

        body {
            background-color: var(--bg-color);
            background-image: radial-gradient(#e5e7eb 1px, transparent 1px);
            background-size: 24px 24px; /* Họa tiết chấm bi nhỏ tinh tế */
            font-family: 'Inter', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Card Container */
        .auth-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
            width: 100%;
            max-width: 450px;
            padding: 3rem 2.5rem;
            border: 1px solid rgba(0,0,0,0.05);
            animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        /* Typography */
        .brand-heading {
            font-family: 'Merriweather', serif; /* Font báo chí */
            color: var(--text-dark);
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .sub-text {
            color: var(--text-muted);
            font-size: 0.95rem;
            line-height: 1.5;
        }

        /* Icon Circle */
        .icon-wrapper {
            width: 64px;
            height: 64px;
            background: #d1fae5; /* Xanh nhạt */
            color: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin: 0 auto 1.5rem auto;
            transition: transform 0.3s ease;
        }

        .auth-card:hover .icon-wrapper {
            transform: scale(1.05) rotate(-5deg);
        }

        /* Form Elements */
        .form-floating > .form-control {
            border: 1px solid #d1d5db;
            border-radius: 8px;
        }

        .form-floating > .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(5, 150, 105, 0.1);
        }

        .btn-news {
            background-color: var(--primary-color);
            color: white;
            font-weight: 600;
            padding: 12px;
            border-radius: 8px;
            border: none;
            transition: all 0.2s ease;
        }

        .btn-news:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        /* Alert Styling */
        .alert-custom {
            border-left: 4px solid #dc3545;
            background-color: #fef2f2;
            color: #991b1b;
            font-size: 0.9rem;
            border-radius: 6px;
            display: flex;
            align-items: center;
            animation: shake 0.5s ease-in-out;
        }

        /* Link */
        .back-link {
            color: var(--text-muted);
            font-size: 0.9rem;
            transition: color 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .back-link:hover {
            color: var(--primary-color);
        }

        /* Animations */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
    </style>
</head>
<body>

    <div class="container d-flex justify-content-center">
        <div class="auth-card">
            <div class="icon-wrapper">
                <i class="bi bi-shield-lock"></i>
            </div>

            <div class="text-center mb-4">
                <h3 class="brand-heading">Quên mật khẩu?</h3>
                <p class="sub-text">Đừng lo lắng, chúng tôi sẽ giúp bạn lấy lại quyền truy cập ngay lập tức.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-custom mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <div>${error}</div>
                </div>
            </c:if>

            <form action="forgot-password" method="post" class="needs-validation" novalidate>
                <div class="form-floating mb-4">
                    <input type="email" name="email" class="form-control" id="floatingInput" placeholder="name@example.com" required>
                    <label for="floatingInput" class="text-muted">
                        <i class="bi bi-envelope me-1"></i> Nhập địa chỉ email của bạn
                    </label>
                </div>

                <button type="submit" name="guiMaXacNhan" class="btn btn-news w-100 mb-4">
                    <i class="bi bi-send me-2"></i>Gửi mã xác nhận
                </button>
            </form>

            <div class="text-center pt-3 border-top">
                <a href="login" class="text-decoration-none back-link fw-medium">
                    <i class="bi bi-arrow-left"></i> Quay lại trang đăng nhập
                </a>
            </div>
        </div>
    </div>

    <script>
        document.querySelector('form').addEventListener('submit', function(e) {
            const btn = this.querySelector('button[type="submit"]');
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...';
            btn.classList.add('disabled');
        });
    </script>
</body>
</html>