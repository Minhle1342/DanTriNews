<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - Dân Trí</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-green: #006837;
            --light-bg: #f3f4f6;
            --card-shadow: 0 10px 30px rgba(0,0,0,0.05);
        }

        body {
            background-color: var(--light-bg);
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #333;
        }

        /* --- LEFT COLUMN: USER CARD --- */
        .user-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            border: none;
            box-shadow: var(--card-shadow);
            position: sticky;
            top: 20px;
        }
        
        :root {
            --dantri-green: #006837; 
        }

        .user-header-bg {
            height: 100px;
            background: linear-gradient(135deg, #006837, #43a047);
        }

        .user-avatar-wrapper {
            margin-top: -50px;
            text-align: center;
        }

        .user-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 4px solid white;
            object-fit: cover;
            background: #fff;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .vip-badge {
            background: linear-gradient(45deg, #FFD700, #DAA520);
            color: #000;
            font-size: 0.7rem;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 20px;
            display: inline-block;
            margin-top: 5px;
        }

        .info-list .list-group-item {
            border: none;
            padding: 12px 0;
            border-bottom: 1px dashed #eee;
            font-size: 0.95rem;
        }

        .info-list .list-group-item:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #666;
            font-weight: 500;
        }

        .info-value {
            float: right;
            font-weight: 600;
            color: #006837;
        }

        /* --- RIGHT COLUMN: TABS & CONTENT --- */
        .nav-pills .nav-link {
            color: #555;
            font-weight: 600;
            border-radius: 10px;
            padding: 10px 20px;
            transition: all 0.3s;
        }

        .nav-pills .nav-link.active {
            background-color: var(--primary-green);
            color: white;
            box-shadow: 0 5px 15px rgba(0, 104, 55, 0.3);
        }

        .content-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            border: none;
            box-shadow: var(--card-shadow);
            min-height: 400px;
        }

        /* Video List Item Styling */
        .video-item {
            display: flex;
            gap: 15px;
            padding: 15px;
            border-radius: 12px;
            transition: 0.2s;
            border: 1px solid transparent;
            text-decoration: none;
            color: inherit;
        }

        .video-item:hover {
            background-color: #f9fafb;
            border-color: #e5e7eb;
        }

        .video-thumb {
            width: 160px;
            height: 90px;
            object-fit: cover;
            border-radius: 8px;
            flex-shrink: 0;
        }

        .video-info h6 {
            font-weight: 700;
            line-height: 1.4;
            margin-bottom: 5px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            color: #333;
        }
        
        .video-item:hover h6 {
            color: var(--primary-green);
        }

        .video-meta {
            font-size: 0.8rem;
            color: #888;
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
    </style>
</head>

<body>

    <jsp:include page="navbar.jsp" /> 

    <div class="container py-5">
        <div class="row g-4">
            
            <div class="col-lg-4">
                <div class="user-card">
                    <div class="user-header-bg"></div>
                    
                    <div class="user-avatar-wrapper">
                        <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" alt="Avatar" class="user-avatar">
                        
                        <h4 class="mt-3 mb-1 fw-bold">${userInfo.name}</h4>
                        <p class="text-muted small mb-1">@${userInfo.username}</p>
                        
                        <c:if test="${userInfo.vip}">
                            <span class="vip-badge"><i class="bi bi-star-fill me-1"></i>VIP MEMBER</span>
                        </c:if>
                    </div>

                    <div class="p-4">
                        <ul class="list-group info-list mb-4">
                            <li class="list-group-item">
                                <span class="info-label"><i class="bi bi-envelope me-2"></i>Email</span>
                                <span class="info-value">${userInfo.email}</span>
                            </li>
                            <li class="list-group-item">
                                <span class="info-label"><i class="bi bi-telephone me-2"></i>SĐT</span>
                                <span class="info-value">${userInfo.phone}</span>
                            </li>
                            <li class="list-group-item">
                                <span class="info-label"><i class="bi bi-wallet2 me-2"></i>Số dư</span>
                                <span class="info-value"><fmt:formatNumber value="${userInfo.balance}" pattern="#,###"/> đ</span>
                            </li>
                        </ul>

                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/editProfile" class="btn btn-outline-success fw-bold rounded-pill">
                                <i class="bi bi-pencil-square me-2"></i>Chỉnh sửa thông tin
                            </a>
                            <c:if test="${!userInfo.vip}">
                                <a href="${pageContext.request.contextPath}/upgradeVip.jsp" class="btn btn-warning fw-bold text-dark rounded-pill">
                                    <i class="bi bi-crown me-2"></i>Nâng cấp VIP
                                </a>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-light text-danger rounded-pill mt-2">
                                <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                
                <div class="content-card">
                    <ul class="nav nav-pills mb-4" id="pills-tab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="pills-history-tab" data-bs-toggle="pill" data-bs-target="#pills-history" type="button" role="tab">
                                <i class="bi bi-clock-history me-2"></i>Lịch sử xem
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="pills-fav-tab" data-bs-toggle="pill" data-bs-target="#pills-fav" type="button" role="tab">
                                <i class="bi bi-heart-fill me-2"></i>Video yêu thích
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="pills-tabContent">
                        
                        <div class="tab-pane fade show active" id="pills-history" role="tabpanel">
                            <c:choose>
                                <c:when test="${empty historyList}">
                                    <div class="text-center py-5 text-muted">
                                        <i class="bi bi-film" style="font-size: 3rem; opacity: 0.5;"></i>
                                        <p class="mt-3">Bạn chưa xem video nào gần đây.</p>
                                        <a href="${pageContext.request.contextPath}/home" class="btn btn-sm btn-success">Khám phá ngay</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="h" items="${historyList}">
                                        <a href="${pageContext.request.contextPath}/postdetail?id=${h.video.id}" class="video-item">
                                            <img src="${h.video.poster}" class="video-thumb" alt="${h.video.title}">
                                            <div class="video-info w-100">
                                                <h6>${h.video.title}</h6>
                                                <div class="video-meta d-flex justify-content-between">
                                                    <span><i class="bi bi-eye me-1"></i>${h.video.viewCount} views</span>
<span class="text-muted small">Đã xem: <fmt:formatDate value="${h.viewedAt}" pattern="dd/MM/yyyy HH:mm"/></span>                                                </div>
                                            </div>
                                        </a>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="tab-pane fade" id="pills-fav" role="tabpanel">
                             <c:choose>
                                <c:when test="${empty favouriteList}">
                                    <div class="text-center py-5 text-muted">
                                        <i class="bi bi-heart-break" style="font-size: 3rem; opacity: 0.5;"></i>
                                        <p class="mt-3">Chưa có video yêu thích nào.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="v" items="${favouriteList}">
                                        <a href="${pageContext.request.contextPath}/postdetail?id=${v.id}" class="video-item">
                                            <img src="${v.poster}" class="video-thumb" alt="${v.title}">
                                            <div class="video-info w-100">
                                                <h6>${v.title}</h6>
                                                <p class="text-muted small mb-1 text-truncate" style="max-width: 400px;">${v.desc}</p>
                                                <div class="video-meta">
                                                    <span class="badge bg-danger bg-opacity-10 text-danger"><i class="bi bi-heart-fill me-1"></i>Đã thích</span>
                                                </div>
                                            </div>
                                        </a>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div>
                </div>

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