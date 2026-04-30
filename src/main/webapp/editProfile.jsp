<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa hồ sơ - Dân Trí</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
    
    :root {
            --dantri-green: #006837; 
        }
    
        :root {
            --primary-green: #006837;
            --light-bg: #f3f4f6;
            --card-shadow: 0 10px 30px rgba(0,0,0,0.08);
        }

        body {
            background-color: var(--light-bg);
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
          .dantri-footer {
            background-color: #fff; /* Nền trắng */
            color: #333; /* Màu chữ chính */
            font-family: Arial, sans-serif; /* Font chữ cơ bản */
            font-size: 14px; /* Cỡ chữ nhỏ như trong hình */
            line-height: 1.6;
            padding-top: 20px;
            padding-bottom: 20px;
        }

        /* Đường kẻ mỏng màu xanh ở trên cùng */
        .footer-top-line {
            border: 0;
            height: 3px;
            background-color: var(--dantri-green);
            opacity: 1;
            margin-top: 0;
            margin-bottom: 25px;
        }

        /* --- Cột 1: Thông tin --- */
        .footer-info .footer-logo {
            font-size: 32px;
            font-weight: 900;
            color: var(--dantri-green);
            text-decoration: none;
            margin-bottom: 15px;
            display: inline-block;
        }

        .footer-info p {
            margin-bottom: 5px; /* Giảm khoảng cách giữa các dòng */
        }
        
        /* Khối văn phòng TPHCM */
        .info-block-hcm {
            margin-top: 15px;
        }

        /* Dòng copyright */
        .copyright {
            margin-top: 20px;
            font-size: 13px;
            color: #555;
        }

        /* --- Cột 2: Links --- */
        .footer-links {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .footer-links li {
            margin-bottom: 10px;
        }

        .footer-links a {
            color: #333;
            text-decoration: none;
        }

        .footer-links a:hover {
            color: var(--dantri-green);
            text-decoration: underline;
        }

        /* --- Cột 3: Apps & Social --- */
        .footer-title {
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .app-buttons img {
            height: 40px; /* Chiều cao chuẩn cho 2 nút */
            margin-right: 10px;
            margin-bottom: 10px;
        }
        
        .social-icons {
            margin-top: 15px; /* Khoảng cách giữa "Theo dõi" và các icon */
        }

        .social-icons a {
            text-decoration: none;
            margin-right: 15px;
            font-size: 28px; /* Kích thước icon */
        }
        
        /* Màu cho từng icon */
        .social-icons .bi-facebook { color: #1877F2; }
        .social-icons .bi-youtube { color: #FF0000; }
        .social-icons .bi-tiktok { color: #000000; }

        .main-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .edit-card {
            background: #fff;
            border-radius: 20px;
            box-shadow: var(--card-shadow);
            width: 100%;
            max-width: 800px;
            overflow: hidden;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .card-header-custom {
            background: linear-gradient(135deg, #006837, #43a047);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .form-section {
            padding: 40px;
        }

        /* Input Styling */
        .form-label {
            font-weight: 600;
            font-size: 0.9rem;
            color: #555;
            margin-bottom: 8px;
        }

        .input-group-text {
            background-color: #f8f9fa;
            border-right: none;
            color: #006837;
        }

        .form-control {
            border-left: none;
            padding: 12px;
            font-size: 0.95rem;
        }

        .form-control:focus {
            box-shadow: none;
            border-color: #dee2e6;
        }

        .input-group:focus-within {
            box-shadow: 0 0 0 4px rgba(0, 104, 55, 0.15);
            border-radius: 6px;
        }

        .input-group:focus-within .input-group-text,
        .input-group:focus-within .form-control {
            border-color: var(--primary-green);
        }

        /* Readonly Fields */
        .readonly-field {
            background-color: #e9ecef !important;
            color: #6c757d;
            cursor: not-allowed;
        }

        /* Buttons */
        .btn-action {
            padding: 12px 30px;
            font-weight: 700;
            border-radius: 50px;
            transition: all 0.3s;
        }

        .btn-save {
            background-color: var(--primary-green);
            border: none;
            color: white;
        }

        .btn-save:hover {
            background-color: #00502b;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 104, 55, 0.3);
        }

        .btn-cancel {
            background-color: #fff;
            border: 2px solid #eee;
            color: #666;
        }

        .btn-cancel:hover {
            background-color: #f8f9fa;
            border-color: #ddd;
            color: #333;
        }

        .avatar-preview {
            width: 100px;
            height: 100px;
            background: #fff;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: var(--primary-green);
        }
    </style>
</head>

<body>

    <jsp:include page="navbar.jsp" />

    <div class="main-container">
        <div class="edit-card">
            
            <div class="card-header-custom">
                <div class="avatar-preview">
                    <i class="bi bi-person-bounding-box" style="color: #006837;"></i>
                </div>
                <h3 class="fw-bold mb-1">Cập nhật hồ sơ</h3>
                <p class="mb-0 opacity-75 small">Chỉnh sửa thông tin cá nhân của bạn</p>
            </div>

            <div class="form-section">
                <form action="${pageContext.request.contextPath}/editProfile" method="post">
                    
                    <div class="row g-4">
                        <div class="col-12">
                            <div class="alert alert-light border d-flex align-items-center mb-0" role="alert">
                                <i class="bi bi-shield-lock-fill text-muted me-3 fs-4"></i>
                                <div>
                                    <div class="small fw-bold text-muted text-uppercase">Tài khoản</div>
                                    <div class="fw-bold text-dark">
                                        ${userBean.username} <span class="mx-2">•</span> ${userBean.email}
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" name="username" value="${userBean.username}">
                            <input type="hidden" name="email" value="${userBean.email}">
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Họ và tên</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" name="name" 
                                       value="${userBean.name}" placeholder="Nhập họ tên của bạn">
                            </div>
                            <c:if test="${not empty userBean.errors.name}">
                                <small class="text-danger mt-1 d-block"><i class="bi bi-exclamation-circle me-1"></i>${userBean.errors.name}</small>
                            </c:if>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <input type="text" class="form-control" name="phone" 
                                       value="${userBean.phone}" placeholder="Nhập số điện thoại">
                            </div>
                            <c:if test="${not empty userBean.errors.phone}">
                                <small class="text-danger mt-1 d-block"><i class="bi bi-exclamation-circle me-1"></i>${userBean.errors.phone}</small>
                            </c:if>
                        </div>

                        <div class="col-12">
                            <hr class="my-2 text-muted opacity-25">
                            <label class="form-label mt-2">Mật khẩu mới (Bỏ trống nếu không đổi)</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-key"></i></span>
                                <input type="password" class="form-control" name="password" 
                                       placeholder="Nhập mật khẩu mới...">
                            </div>
                            <c:if test="${not empty userBean.errors.password}">
                                <small class="text-danger mt-1 d-block"><i class="bi bi-exclamation-circle me-1"></i>${userBean.errors.password}</small>
                            </c:if>
                        </div>
                    </div>

                    <div class="d-flex justify-content-center gap-3 mt-5">
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-action btn-cancel text-decoration-none">
                            Quay lại
                        </a>
                        <button type="submit" class="btn btn-action btn-save">
                            <i class="bi bi-check2-circle me-2"></i>Lưu thay đổi
                        </button>
                    </div>

                </form>
            </div>
        </div>
    </div>
    
    <footer class="dantri-footer">
        
        <hr class="footer-top-line" />
        
        <div class="container">
            <div class="row">

                <div class="col-lg-5 col-md-12 mb-4">
                    <div class="footer-info">
                        
                        <a href="/" class="footer-logo">DANTRI</a>
                        
                        <div class="info-block-hn">
                            <p>Cơ quan của Bộ Nội vụ</p>
                            <p>Tổng biên tập: Phạm Tuấn Anh</p>
                            <p>Giấy phép hoạt động báo điện tử Dân trí số 15/GP-BTTTĐL Hà Nội, ngày 14-4-2025</p>
                            <p>Địa chỉ tòa soạn: Số 48 ngõ 2 phố Giảng Võ, phường Giảng Võ, thành phố Hà Nội</p>
                            <p>Điện thoại: 024-3736-6491. Hotline HN: 0973-567-567</p>
                        </div>
                        
                        <div class="info-block-hcm">
                            <p>Văn phòng đại diện miền Nam: Số 51-53 Võ Văn Tần, phường Xuân Hòa, thành phố Hồ Chí Minh</p>
                            <p>Hotline TPHCM: 0974-567-567</p>
                            <p>Email: info@dantri.com.vn</p>
                        </div>

                        <p class="copyright">
                            © 2005-2025 Bản quyền thuộc về Báo điện tử Dân trí. Cấm sao chép dưới mọi hình thức nếu không có sự chấp thuận bằng văn bản.
                        </p>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <ul class="footer-links">
                        <li><a href="#">RSS</a></li>
                        <li><a href="#">Liên hệ toà soạn</a></li>
                        <li><a href="#">Liên hệ quảng cáo: 0945.54.03.03</a></li>
                        <li><a href="#">Email: quangcao@dantri.com.vn</a></li>
                        <li><a href="#">Chính sách bảo mật dữ liệu cá nhân</a></li>
                       <c:if test="${sessionScope.user != null && sessionScope.user.role == 1}">
    <a href="${pageContext.request.contextPath}/role-request" class="btn-editor-outline">
        <span class="icon-box"><i class="bi bi-person-up"></i></span>
        <span class="text">Trở thành Editor</span>
    </a>
</c:if>
                    </ul>
                </div>

                <div class="col-lg-4 col-md-6 mb-4">
                    
                    <div class="footer-apps">
                        <p class="footer-title">Đọc báo Dân trí trên mobile:</p>
                        <div class="app-buttons">
                            <a href="#" target="_blank">
                                <img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download on the App Store">
                            </a>
                            <a href="#" target="_blank">
                                <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Google_Play_Store_badge_EN.svg/2560px-Google_Play_Store_badge_EN.svg.png" alt="Get it on Google Play">
                            </a>
                        </div>
                    </div>

                    <div class="social-icons">
                        <p class="footer-title">Theo dõi Dân trí trên:</p>
                        <a href="#" target="_blank" title="Facebook"><i class="bi bi-facebook"></i></a>
                        <a href="#" target="_blank" title="YouTube"><i class="bi bi-youtube"></i></a>
                        <a href="#" target="_blank" title="TikTok"><i class="bi bi-tiktok"></i></a>
                    </div>

                </div>

            </div> 
            </div> 
            </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>