<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm: ${keyword} - Dân trí</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #006837; /* Màu xanh Dân trí */
            --bg-light: #f4f6f8;
            --text-dark: #1f2937;
            --text-gray: #6b7280;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #fff;
            color: var(--text-dark);
        }

        /* --- SEARCH HEADER --- */
        .search-header-section {
            background-color: var(--bg-light);
            padding: 3rem 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .search-keyword {
            color: var(--primary-color);
            position: relative;
            display: inline-block;
        }
        
        .search-keyword::after {
            content: '';
            position: absolute;
            bottom: 2px;
            left: 0;
            width: 100%;
            height: 8px;
            background-color: rgba(0, 104, 55, 0.1);
            z-index: -1;
        }

        /* --- FILTERS --- */
        .filter-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            position: sticky;
            top: 20px;
        }
        
        .form-select-custom {
            border-radius: 8px;
            border-color: #d1d5db;
            padding: 0.6rem 1rem;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .form-select-custom:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(0, 104, 55, 0.1);
        }
        
        .form-label {
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-gray);
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        /* --- RESULT ITEM --- */
        .result-item {
            display: flex;
            gap: 1.5rem;
            padding: 1.5rem 0;
            border-bottom: 1px solid #f3f4f6;
            transition: transform 0.2s ease;
        }
        
        .result-item:hover .result-title a {
            color: var(--primary-color);
        }

        .result-thumb {
            flex-shrink: 0;
            width: 260px;
            position: relative;
            border-radius: 12px;
            overflow: hidden;
            aspect-ratio: 16/9;
        }
        
        .result-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .result-item:hover .result-thumb img {
            transform: scale(1.05);
        }

        .result-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .result-category {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--primary-color);
            text-transform: uppercase;
            margin-bottom: 0.5rem;
            display: inline-block;
        }

        .result-title {
            font-size: 1.25rem;
            font-weight: 700;
            line-height: 1.4;
            margin-bottom: 0.75rem;
        }
        
        .result-title a {
            text-decoration: none;
            color: var(--text-dark);
            transition: color 0.2s;
        }

        .result-desc {
            color: var(--text-gray);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        /* Class làm mờ ảnh */
.blur-premium {
    filter: blur(6px); /* Độ mờ */
    pointer-events: none; /* Không cho click/kéo ảnh */
    transition: all 0.3s ease;
}

/* Icon ổ khóa nằm đè lên ảnh */
.lock-overlay {
    position: absolute;
    top: 50%; 
    left: 50%;
    transform: translate(-50%, -50%); /* Căn giữa tuyệt đối cho đẹp mắt trên nền mờ */
    font-size: 3rem;
    color: white;
    z-index: 10;
    text-shadow: 0 4px 10px rgba(0,0,0,0.6);
}

/* Nếu bạn nhất quyết muốn ổ khóa ở GÓC TRÁI thay vì ở giữa, dùng class này: */
/*
.lock-overlay-left {
    position: absolute;
    top: 10px;
    left: 10px;
    font-size: 2rem;
    color: white;
    z-index: 10;
    background: rgba(0,0,0,0.5);
    padding: 5px;
    border-radius: 50%;
}

        .result-meta {
            margin-top: auto;
            display: flex;
            align-items: center;
            gap: 1.5rem;
            font-size: 0.85rem;
            color: #9ca3af;
        }
        
        :root {
            --dantri-green: #006837; 
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        
        /* Highlight từ khóa */
        .highlight {
            background-color: #fff3cd;
            color: #212529;
            padding: 0 2px;
            border-radius: 2px;
            font-weight: inherit;
        }
        
        .news-description {
  word-break: break-word;
  overflow-wrap: break-word;
  white-space: normal;
}

        /* --- RESPONSIVE --- */
        @media (max-width: 768px) {
            .result-item {
                flex-direction: column;
            }
            .result-thumb {
                width: 100%;
                aspect-ratio: 16/9;
            }
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

    <jsp:include page="navbar.jsp"/>

    <section class="search-header-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <p class="text-muted mb-2 small text-uppercase fw-bold ls-1">Kết quả tìm kiếm</p>
                    <h2 class="display-6 fw-bold mb-0">
                        Từ khóa: <span class="search-keyword">"${keyword}"</span>
                    </h2>
                </div>
                <div class="col-md-4 text-md-end mt-3 mt-md-0">
                    <div class="d-inline-block bg-white px-4 py-2 rounded-pill shadow-sm border">
                        <span class="fw-bold text-success fs-5">${fn:length(results)}</span>
                        <span class="text-muted small">kết quả được tìm thấy</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="container py-5">
        <div class="row g-5">
            
            <div class="col-lg-8">
                
                <c:if test="${empty results}">
                    <div class="text-center py-5">
                        <img src="https://cdn-icons-png.flaticon.com/512/6134/6134065.png" alt="Not found" style="width: 120px; opacity: 0.5;">
                        <h4 class="mt-4 text-muted fw-bold">Không tìm thấy kết quả nào</h4>
                        <p class="text-secondary">Hãy thử tìm kiếm với từ khóa khác ngắn gọn hơn.</p>
                    </div>
                </c:if>

                <div class="list-results">
    <c:forEach var="v" items="${results}">
        
        <%-- LOGIC KIỂM TRA KHÓA BÀI VIẾT --%>
        <%-- Bị khóa khi: Bài là Premium VÀ (Chưa đăng nhập HOẶC Chưa mua VIP) --%>
        <c:set var="isLocked" value="${v.premium && (empty sessionScope.user || !sessionScope.user.vip)}" />

        <article class="result-item">
            <div class="result-thumb position-relative overflow-hidden">
                <a href="${pageContext.request.contextPath}/postdetail?id=${v.id}">
                    <%-- Nếu bị khóa thì thêm class 'blur-premium' --%>
                    <img src="${v.poster}" alt="${v.title}" class="${isLocked ? 'blur-premium' : ''}">
                </a>
                
                <%-- HIỂN THỊ ICON Ổ KHÓA NẾU BỊ KHÓA --%>
                <c:if test="${isLocked}">
                    <div class="lock-overlay">
                        <i class="bi bi-lock-fill"></i>
                    </div>
                </c:if>

                <%-- Badge Premium (Giữ nguyên) --%>
                <c:if test="${v.premium}">
                    <span class="badge bg-warning text-dark position-absolute top-0 start-0 m-2 shadow-sm" style="z-index: 11;">
                        <i class="bi bi-star-fill me-1"></i>PREMIUM
                    </span>
                </c:if>
            </div>

            <div class="result-content">
                <div>
                    <span class="result-category">
                        <i class="bi bi-hash"></i>${v.category.name}
                    </span>
                    <h3 class="result-title">
                        <a href="${pageContext.request.contextPath}/postdetail?id=${v.id}">
                            ${v.title}
                        </a>
                    </h3>
                    <p class="result-desc news-description">
                        ${v.desc}
                    </p>
                </div>

                <div class="result-meta">
                    <div class="meta-item" title="Ngày đăng">
                        <i class="bi bi-calendar3"></i>
                        <fmt:formatDate value="${v.createAt}" pattern="dd/MM/yyyy"/>
                    </div>
                    <div class="meta-item" title="Lượt xem">
                        <i class="bi bi-eye"></i> ${v.viewCount}
                    </div>
                    <div class="meta-item ms-auto text-success fw-bold">
                        <a href="${pageContext.request.contextPath}/postdetail?id=${v.id}" class="text-decoration-none text-success small">
                            <%-- Đổi chữ nếu bị khóa --%>
                            <c:choose>
                                <c:when test="${isLocked}">
                                    <span class="text-secondary"><i class="bi bi-lock-fill"></i> Mở khóa VIP</span>
                                </c:when>
                                <c:otherwise>
                                    Đọc tiếp <i class="bi bi-arrow-right ms-1"></i>
                                </c:otherwise>
                            </c:choose>
                        </a>
                    </div>
                </div>
            </div>
        </article>
    </c:forEach>
</div>

                </div>

            <div class="col-lg-4">
                <form action="${pageContext.request.contextPath}/search" method="get">
                    <input type="hidden" name="q" value="${keyword}">
                    
                    <div class="filter-card">
                        <h5 class="fw-bold mb-4 border-bottom pb-2">
                            <i class="bi bi-sliders me-2 text-success"></i>Bộ lọc tìm kiếm
                        </h5>

                        <div class="mb-4">
                            <label class="form-label">Khoảng thời gian</label>
                            <select class="form-select form-select-custom" name="time" onchange="this.form.submit()">
                                <option value="all" ${selectedTime == 'all' ? 'selected' : ''}>Tất cả</option>
                                <option value="1"   ${selectedTime == '1' ? 'selected' : ''}>24 giờ qua</option>
                                <option value="2"   ${selectedTime == '2' ? 'selected' : ''}>Tuần này</option>
                                <option value="3"   ${selectedTime == '3' ? 'selected' : ''}>Tháng này</option>
                                <option value="4"   ${selectedTime == '4' ? 'selected' : ''}>Năm nay</option>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Chuyên mục</label>
                            <select class="form-select form-select-custom" name="catId" onchange="this.form.submit()">
                                <option value="0">Tất cả chuyên mục</option>
                                <c:forEach items="${categories}" var="c">
                                    <option value="${c.id}" ${selectedCat == c.id ? 'selected' : ''}>
                                        ${c.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="d-grid">
                            <a href="${pageContext.request.contextPath}/search?q=${keyword}" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-arrow-counterclockwise me-1"></i>Đặt lại bộ lọc
                            </a>
                        </div>
                    </div>
                </form>
                
                <div class="mt-4 sticky-top" style="top: 20px; z-index: 1;">
                    <a href="#" class="d-block rounded overflow-hidden shadow-sm">
                        <img src="https://tpc.googlesyndication.com/simgad/16280455799059798485" class="img-fluid w-100" alt="Ads">
                    </a>
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

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            let keyword = "${keyword}";
            if (keyword && keyword.trim() !== "") {
                let titles = document.querySelectorAll(".result-title a");
                let regex = new RegExp("(" + keyword + ")", "gi");
                
                titles.forEach(function(el) {
                    let originalText = el.textContent;
                    // Thay thế từ khóa bằng thẻ span có class highlight
                    let newText = originalText.replace(regex, "<span class='highlight'>$1</span>");
                    el.innerHTML = newText;
                });
            }
        });
    </script>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>