<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu | Tòa Soạn Online</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Merriweather:wght@700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #059669; /* Xanh ngọc lục bảo - Đồng bộ với trang quên pass */
            --primary-hover: #047857;
            --text-dark: #1f2937;
            --text-muted: #6b7280;
            --bg-color: #f3f4f6;
        }

        body {
            background-color: var(--bg-color);
            background-image: radial-gradient(#e5e7eb 1px, transparent 1px);
            background-size: 24px 24px;
            font-family: 'Inter', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Card Styling */
        .auth-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.01);
            width: 100%;
            max-width: 450px;
            padding: 2.5rem;
            border: 1px solid rgba(0,0,0,0.05);
            animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        /* Typography */
        .brand-heading {
            font-family: 'Merriweather', serif;
            color: var(--text-dark);
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .sub-text {
            color: var(--text-muted);
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
        }

        /* Icon Wrapper */
        .icon-wrapper {
            width: 60px;
            height: 60px;
            background: #ecfdf5;
            color: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin: 0 auto 1rem auto;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }

        /* Input Group & Floating Labels */
        .input-group-text {
            background: white;
            border-left: none;
            border-radius: 0 8px 8px 0;
            cursor: pointer;
            color: var(--text-muted);
        }
        
        .form-floating > .form-control {
            border-right: none;
            border-radius: 8px 0 0 8px;
            border-color: #d1d5db;
        }

        .form-floating > .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: none;
            z-index: 1;
        }
        
        .form-floating > .form-control:focus + label {
            color: var(--primary-color);
        }

        .input-group:focus-within .input-group-text {
            border-color: var(--primary-color);
        }

        /* Button */
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

        /* Alert */
        .alert-custom {
            border-left: 4px solid #dc3545;
            background-color: #fef2f2;
            color: #991b1b;
            font-size: 0.9rem;
            border-radius: 6px;
            display: flex;
            align-items: center;
            animation: shake 0.4s ease-in-out;
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

    <div class="auth-card">
        <div class="text-center">
            <div class="icon-wrapper">
                <i class="bi bi-shield-check"></i>
            </div>
            <h3 class="brand-heading">Thiết lập mật khẩu mới</h3>
            <p class="sub-text">Để bảo mật, hãy chọn mật khẩu mạnh bao gồm chữ hoa, chữ thường và số.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-custom mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <div>${error}</div>
            </div>
        </c:if>

        <form action="reset-password" method="post" id="resetForm">
            <div class="input-group mb-3">
                <div class="form-floating flex-grow-1">
                    <input type="password" name="newPassword" class="form-control" id="newPassword" placeholder="Mật khẩu mới" required>
                    <label for="newPassword">Mật khẩu mới</label>
                </div>
                <span class="input-group-text border-start-0" onclick="togglePassword('newPassword', this)">
                    <i class="bi bi-eye-slash"></i>
                </span>
            </div>

            <div class="input-group mb-4">
                <div class="form-floating flex-grow-1">
                    <input type="password" name="confirmPassword" class="form-control" id="confirmPassword" placeholder="Nhập lại mật khẩu" required>
                    <label for="confirmPassword">Xác nhận mật khẩu</label>
                </div>
                <span class="input-group-text border-start-0" onclick="togglePassword('confirmPassword', this)">
                    <i class="bi bi-eye-slash"></i>
                </span>
            </div>

            <button type="submit" class="btn btn-news w-100">
                <i class="bi bi-check2-circle me-2"></i>Đổi mật khẩu
            </button>
        </form>
    </div>

    <script>
        // Toggle Password Visibility
        function togglePassword(inputId, iconSpan) {
            const input = document.getElementById(inputId);
            const icon = iconSpan.querySelector('i');
            
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove('bi-eye-slash');
                icon.classList.add('bi-eye');
            } else {
                input.type = "password";
                icon.classList.remove('bi-eye');
                icon.classList.add('bi-eye-slash');
            }
        }

        // Loading state on submit
        document.getElementById('resetForm').addEventListener('submit', function(e) {
            const btn = this.querySelector('button[type="submit"]');
            const p1 = document.getElementById('newPassword').value;
            const p2 = document.getElementById('confirmPassword').value;

            // Client-side check đơn giản
            if (p1 !== p2) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không trùng khớp!');
                return;
            }

            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang cập nhật...';
            btn.classList.add('disabled');
        });
    </script>
</body>
</html>