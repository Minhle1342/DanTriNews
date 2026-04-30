<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực bảo mật | DanTri</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&family=Merriweather:wght@700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #059669; /* Xanh ngọc lục bảo - Đồng bộ hệ thống */
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
            text-align: center;
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
            font-size: 28px;
            margin: 0 auto 1.5rem auto;
            position: relative;
        }
        
        .icon-badge {
            position: absolute;
            bottom: -5px;
            right: -5px;
            background: white;
            border-radius: 50%;
            padding: 3px;
            color: #f59e0b; /* Màu vàng cam cho icon chìa khóa/security */
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        /* OTP Inputs Container */
        .otp-container {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 1.5rem;
        }

        /* Individual OTP Box */
        .otp-input {
            width: 50px;
            height: 55px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            text-align: center;
            font-size: 24px;
            font-weight: 600;
            color: var(--text-dark);
            background: #f9fafb;
            transition: all 0.2s ease;
        }

        .otp-input:focus {
            background: white;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(5, 150, 105, 0.1);
            outline: none;
            transform: translateY(-2px);
        }

        /* Valid/Error States */
        .otp-input.is-valid { border-color: var(--primary-color); background: #ecfdf5; }
        .otp-input.is-invalid { border-color: #dc3545; background: #fef2f2; animation: shake 0.4s; }

        /* Button */
        .btn-news {
            background-color: var(--primary-color);
            color: white;
            font-weight: 600;
            padding: 12px;
            border-radius: 8px;
            border: none;
            width: 100%;
            transition: all 0.2s ease;
        }

        .btn-news:hover {
            background-color: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        /* Resend Link */
        .resend-link {
            font-size: 0.9rem;
            color: var(--text-muted);
            margin-top: 1.5rem;
        }
        
        .resend-link a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .resend-link a:hover {
            text-decoration: underline;
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
        <div class="icon-wrapper">
            <i class="bi bi-shield-check"></i>
            <div class="icon-badge"><i class="bi bi-key-fill"></i></div>
        </div>

        <h3 class="brand-heading">Xác thực bảo mật</h3>
        <p class="sub-text">
            Mã OTP gồm 6 chữ số đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư.
        </p>

        <c:if test="${not empty message}">
            <div class="alert alert-success py-2 small mb-3">
                <i class="bi bi-check-circle-fill me-1"></i> ${message}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger py-2 small mb-3">
                <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
            </div>
        </c:if>

        <form action="verify-code" method="post" id="otpForm">
            <input type="hidden" name="code" id="fullCode" required>

            <div class="otp-container">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" autocomplete="one-time-code">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric">
                <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric">
            </div>

            <button type="submit" class="btn btn-news" id="submitBtn">
                Xác thực ngay
            </button>
        </form>

        <div class="resend-link">
            Bạn không nhận được mã? <br>
            <a href="#" onclick="resendCode(this); return false;">Gửi lại mã mới</a> 
            <span id="timer" class="text-muted ms-1" style="display:none">(60s)</span>
        </div>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const inputs = document.querySelectorAll(".otp-input");
            const hiddenInput = document.getElementById("fullCode");
            const form = document.getElementById("otpForm");
            const btn = document.getElementById("submitBtn");

            // 1. Tự động Focus ô đầu tiên khi vào trang
            inputs[0].focus();

            // 2. Xử lý sự kiện nhập liệu
            inputs.forEach((input, index) => {
                // Chỉ cho phép nhập số
                input.addEventListener("input", (e) => {
                    // Nếu nhập ký tự không phải số -> xóa
                    e.target.value = e.target.value.replace(/[^0-9]/g, '');

                    if (e.target.value.length === 1) {
                        // Nhập xong -> Focus ô kế tiếp
                        if (index < inputs.length - 1) {
                            inputs[index + 1].focus();
                        } else {
                            // Ô cuối cùng -> Blur để ẩn bàn phím (trên mobile)
                            input.blur();
                        }
                    }
                    updateHiddenInput();
                });

                // Xử lý nút Backspace (Xóa lùi)
                input.addEventListener("keydown", (e) => {
                    if (e.key === "Backspace" && e.target.value === "") {
                        if (index > 0) {
                            inputs[index - 1].focus();
                        }
                    }
                });

                // Xử lý Paste (Dán mã)
                input.addEventListener("paste", (e) => {
                    e.preventDefault();
                    const pastedData = e.clipboardData.getData("text").replace(/[^0-9]/g, '');
                    
                    if (pastedData.length > 0) {
                        inputs.forEach((inp, i) => {
                            if (pastedData[i]) {
                                inp.value = pastedData[i];
                            }
                        });
                        updateHiddenInput();
                        // Focus vào ô cuối cùng sau khi dán
                        inputs[Math.min(inputs.length - 1, pastedData.length - 1)].focus();
                    }
                });
            });

            // 3. Cập nhật giá trị vào Input ẩn để gửi Server
            function updateHiddenInput() {
                let code = "";
                inputs.forEach(input => code += input.value);
                hiddenInput.value = code;
                
                // Hiệu ứng Visual: Nếu đủ 6 số, đổi màu viền xanh
                if (code.length === 6) {
                    inputs.forEach(i => i.classList.add('is-valid'));
                } else {
                    inputs.forEach(i => i.classList.remove('is-valid'));
                }
            }

            // 4. Loading state khi submit
            form.addEventListener("submit", (e) => {
                if (hiddenInput.value.length < 6) {
                    e.preventDefault();
                    // Rung lắc nếu chưa nhập đủ
                    inputs.forEach(i => {
                        i.classList.add('is-invalid');
                        setTimeout(() => i.classList.remove('is-invalid'), 400);
                    });
                    return;
                }
                btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang xác thực...';
                btn.classList.add('disabled');
            });
        });

        // Hàm giả lập gửi lại mã (Frontend only)
        function resendCode(linkElement) {
            if (linkElement.classList.contains('disabled')) return;
            
            // Logic gửi lại mã ở đây (AJAX)
            alert("Mã mới đã được gửi!");
            
            // Countdown Timer UI
            linkElement.classList.add('disabled', 'text-muted');
            linkElement.style.pointerEvents = 'none';
            const timerSpan = document.getElementById('timer');
            timerSpan.style.display = 'inline';
            
            let timeLeft = 60;
            const interval = setInterval(() => {
                timeLeft--;
                timerSpan.textContent = `(${timeLeft}s)`;
                if (timeLeft <= 0) {
                    clearInterval(interval);
                    linkElement.classList.remove('disabled', 'text-muted');
                    linkElement.style.pointerEvents = 'auto';
                    timerSpan.style.display = 'none';
                }
            }, 1000);
        }
    </script>
</body>
</html>