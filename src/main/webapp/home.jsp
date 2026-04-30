<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi"> <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> <title>Trang chủ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
</head>
<style>
    /* --- GIỮ NGUYÊN CSS CŨ CỦA BẠN TỪ ĐÂY --- */
    /* Thanh navbar chính */
    .navbar-custom {
        background-color: #fff;
        border-bottom: 1px solid #eee;
        padding: 10px 40px;
    }
    .navbar-brand {
        font-weight: bold;
        font-size: 28px;
        color: #00796b !important;
        letter-spacing: 1px;
    }
    .navbar-nav .nav-link {
        font-weight: 500;
        color: #333 !important;
        margin: 0 10px;
        position: relative;
        transition: all 0.3s ease;
    }
    .search-bar input {
        border-radius: 20px;
        padding: 8px 15px;
    }
    .btn-editor-outline {
        display: inline-flex;
        align-items: center;
        padding: 8px 20px 8px 8px;
        border: 2px solid #006837;
        border-radius: 50px;
        color: #006837;
        font-weight: 700;
        text-decoration: none;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        background-color: transparent;
    }
    .btn-editor-outline .icon-box {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
        background-color: #006837;
        color: white;
        border-radius: 50%;
        margin-right: 10px;
        transition: transform 0.3s ease;
    }
    .btn-editor-outline:hover {
        background-color: #006837;
        color: white;
        box-shadow: 0 5px 15px rgba(0, 104, 55, 0.25);
    }
    .btn-editor-outline:hover .icon-box {
        background-color: white;
        color: #006837;
        transform: rotate(360deg);
    }
    .btn-search {
        border-radius: 20px;
        background: #28a745;
        color: white;
        padding: 8px 15px;
        border: none;
        transition: 0.2s;
    }
    .btn-search:hover {
        background: #218838;
    }
    .navbar-nav .nav-link::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        height: 2px;
        width: 0;
        background-color: #00796b;
        transition: all 0.3s ease;
    }
    .navbar-nav .nav-link:hover::after {
        width: 100%;
    }
    .navbar-nav .nav-link:hover {
        color: #00796b !important;
    }
    .login-btn {
        font-weight: 500;
        color: #333;
        text-decoration: none;
        transition: all 0.3s ease;
    }
    .login-btn:hover {
        color: #00796b;
        transform: scale(1.05);
    }
    .category-bar {
        background-color: #fff;
        border-top: 1px solid #eee;
        border-bottom: 1px solid #eee;
        padding: 8px 0;
        text-align: center;
    }
    .category-bar a {
        color: #444;
        font-weight: 500;
        margin: 0 15px;
        text-decoration: none;
        transition: color 0.3s ease;
    }
    .category-bar a:hover {
        color: #00796b;
    }
    body {
        background-color: #f8f9fa;
        font-family: "Segoe UI", sans-serif;
    }
    main {
        margin-top: 20px;
    }
    .news-main {
        position: relative;
        overflow: hidden;
        border-radius: 10px;
    }
    .news-main img {
        width: 100%;
        height: auto;
        border-radius: 10px;
        transition: transform 0.4s ease;
    }
    .news-main:hover img {
        transform: scale(1.03);
    }
    .video-duration {
        position: absolute;
        bottom: 10px;
        left: 10px;
        background-color: rgba(0,0,0,0.7);
        color: #fff;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 14px;
    }
    .ads {
        border-radius: 10px;
        overflow: hidden;
        background-color: #e9f7ff;
        text-align: center;
        padding: 20px;
    }
    .ads img {
        width: 100%;
        height: auto;
    }
    .ads h6 {
        margin-top: 10px;
        font-weight: bold;
        color: #005b8f;
    }
    .ads .price {
        font-size: 24px;
        color: #e53935;
        font-weight: bold;
    }
    .ads a {
        display: inline-block;
        background-color: #005b8f;
        color: #fff;
        border-radius: 20px;
        padding: 8px 18px;
        text-decoration: none;
        margin-top: 8px;
        transition: all 0.3s ease;
    }
    .ads a:hover {
        background-color: #007bff;
        transform: scale(1.05);
    }
    .news-title {
        font-size: 22px;
        font-weight: 600;
        color: #212529;
        margin-top: 15px;
    }
    .news-title:hover {
        color: #00796b;
        cursor: pointer;
    }
    .news-description {
        color: #555;
        font-size: 15px;
    }
    .read-more {
        color: #00796b;
        text-decoration: none;
        font-weight: 500;
    }
    .read-more:hover {
        text-decoration: underline;
    }
    .latest-videos {
        margin-top: 40px;
    }
    .video-card {
        background-color: #fff;
        border-radius: 10px;
        overflow: hidden;
        transition: all 0.4s ease;
        cursor: pointer;
    }
    .video-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
    }
    .video-thumb {
        position: relative;
        overflow: hidden;
    }
    .video-thumb img {
        width: 100%;
        height: auto;
        border-radius: 10px;
        transition: transform 0.5s ease;
    }
    .video-card:hover .video-thumb img {
        transform: scale(1.08);
        filter: brightness(0.9);
    }
    .video-title {
        font-size: 15px;
        font-weight: 600;
        color: #212529;
        line-height: 1.4;
        transition: color 0.3s ease;
    }
    .video-card:hover .video-title {
        color: #00695c;
    }
    :root {
        --dantri-green: #006837; 
    }
    .video-section-title {
        color: var(--dantri-green);
        font-weight: 900;
        text-transform: uppercase;
        border-left: 5px solid var(--dantri-green);
        padding-left: 10px;
    }
    .video-card {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        overflow: hidden;
        transition: box-shadow 0.3s ease;
    }
    .video-card:hover {
        box-shadow: 0 4px 15px rgba(0,0,0,0.15);
    }
    .card-media {
        background-color: var(--dantri-green);
        padding: 12px;
    }
    .card-media-header {
        color: #ffffff;
        font-weight: 700;
        font-size: 20px;
        text-align: center;
        margin-bottom: 12px;
    }
    .image-zoom-wrapper {
        display: block;
        position: relative;
        overflow: hidden;
        border-radius: 5px;
    }
    .image-zoom-wrapper img {
        width: 100%;
        height: auto;
        display: block;
        transition: transform 0.4s ease;
    }
    .video-timestamp {
        position: absolute;
        top: 8px;
        left: 8px;
        background-color: rgba(0, 0, 0, 0.6);
        color: #fff;
        padding: 2px 6px;
        font-size: 12px;
        border-radius: 3px;
    }
    .video-tags {
        position: absolute;
        bottom: 8px;
        left: 8px;
        display: flex;
        gap: 5px;
    }
    .video-tags .badge {
        font-size: 11px;
        font-weight: 600;
    }
    .card-title-section {
        padding: 12px;
    }
    .card-title-link {
        text-decoration: none;
        color: #212529;
        font-size: 16px;
        font-weight: 600;
        line-height: 1.4;
        transition: color 0.3s ease;
    }
    .video-card:hover .image-zoom-wrapper img {
        transform: scale(1.1);
    }
    .video-card:hover .card-title-link {
        color: var(--dantri-green);
    }
    .dantri-footer {
        background-color: #fff;
        color: #333;
        font-family: Arial, sans-serif;
        font-size: 14px;
        line-height: 1.6;
        padding-top: 20px;
        padding-bottom: 20px;
    }
    .footer-top-line {
        border: 0;
        height: 3px;
        background-color: var(--dantri-green);
        opacity: 1;
        margin-top: 0;
        margin-bottom: 25px;
    }
    .footer-info .footer-logo {
        font-size: 32px;
        font-weight: 900;
        color: var(--dantri-green);
        text-decoration: none;
        margin-bottom: 15px;
        display: inline-block;
    }
    .footer-info p {
        margin-bottom: 5px;
    }
    .info-block-hcm {
        margin-top: 15px;
    }
    .copyright {
        margin-top: 20px;
        font-size: 13px;
        color: #555;
    }
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
    .footer-title {
        font-weight: 600;
        margin-bottom: 10px;
    }
    .app-buttons img {
        height: 40px;
        margin-right: 10px;
        margin-bottom: 10px;
    }
    .social-icons {
        margin-top: 15px;
    }
    .social-icons a {
        text-decoration: none;
        margin-right: 15px;
        font-size: 28px;
    }
    .social-icons .bi-facebook { color: #1877F2; }
    .social-icons .bi-youtube { color: #FF0000; }
    .social-icons .bi-tiktok { color: #000000; }
    .news-description {
        word-break: break-word;
        overflow-wrap: break-word;
        white-space: normal;
    }
    .video-card-modern {
        border: none;
        border-radius: 12px;
        background: #fff;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        transition: all 0.3s ease;
        height: 100%;
        overflow: hidden;
    }
    .video-card-modern:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0,0,0,0.12);
    }
    .thumb-wrapper {
        position: relative;
        overflow: hidden;
        padding-top: 56.25%;
    }
    .thumb-img {
        position: absolute;
        top: 0; left: 0;
        width: 100%; height: 100%;
        object-fit: cover;
        transition: transform 0.5s ease;
    }
    .video-card-modern:hover .thumb-img {
        transform: scale(1.1);
    }
    .play-overlay {
        position: absolute;
        top: 50%; left: 50%;
        transform: translate(-50%, -50%);
        width: 50px; height: 50px;
        background: rgba(0,0,0,0.6);
        border-radius: 50%;
        display: flex; align-items: center; justify-content: center;
        color: white;
        font-size: 1.5rem;
        opacity: 0;
        transition: 0.3s;
        backdrop-filter: blur(2px);
    }
    .video-card-modern:hover .play-overlay {
        opacity: 1;
    }
    .badge-tag {
        position: absolute;
        top: 10px; left: 10px;
        font-size: 0.75rem;
        font-weight: 600;
        z-index: 2;
    }
    .card-body-custom {
        padding: 1.25rem;
    }
    .video-title-link {
        text-decoration: none;
        color: #2c3e50;
        font-weight: 700;
        font-size: 1.1rem;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        margin-bottom: 0.5rem;
        transition: color 0.2s;
    }
    .video-title-link:hover {
        color: #006837;
    }
    .video-desc {
        color: #7f8c8d;
        font-size: 0.9rem;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        margin-bottom: 1rem;
    }
    .video-meta {
        font-size: 0.8rem;
        color: #95a5a6;
        border-top: 1px solid #eee;
        padding-top: 0.75rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .scroll-reveal {
        opacity: 0;
        transform: translateY(50px);
        transition: opacity 0.8s ease-out, transform 0.8s ease-out;
        will-change: opacity, transform;
    }
    .scroll-reveal.active {
        opacity: 1;
        transform: translateY(0);
    }
    .video-card:hover { transform: translateY(-3px); transition: transform 0.2s; }
    .hover-opacity-100:hover { opacity: 1 !important; }
    .transition-all { transition: all 0.3s; }
    /* --- HẾT CSS CŨ --- */

    /* ========================================================= */
    /* --- BỔ SUNG CSS CHO DARK MODE (CHẾ ĐỘ TỐI) --- */
    /* ========================================================= */

    /* Định nghĩa biến màu cho chế độ tối */
    :root {
        --bg-color-light: #f8f9fa;
        --bg-color-dark: #121212;
        --text-color-light: #212529;
        --text-color-dark: #e0e0e0;
        --card-bg-light: #ffffff;
        --card-bg-dark: #1e1e1e;
        --border-color-light: #eee;
        --border-color-dark: #333;
        --transition-speed: 0.3s;
    }

    /* Transition mượt cho body và các thành phần chính */
    body, .video-card, .video-card-modern, .navbar-custom, .category-bar, .dantri-footer, .ads, .card-title-link, .news-title, .video-title {
        transition: background-color var(--transition-speed), color var(--transition-speed), border-color var(--transition-speed);
    }

    /* Nút Toggle cố định góc phải */
    #theme-toggle {
        position: fixed;
        top: 100px; /* Điều chỉnh vị trí dọc */
        right: 20px; /* Điều chỉnh vị trí ngang */
        z-index: 9999;
        width: 45px;
        height: 45px;
        border-radius: 50%;
        border: none;
        background-color: var(--dantri-green);
        color: white;
        box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.2rem;
        transition: transform 0.3s ease, background-color 0.3s;
    }

    #theme-toggle:hover {
        transform: scale(1.1);
        background-color: #004d29;
    }

    /* --- CÁC STYLE GHI ĐÈ KHI KÍCH HOẠT DARK MODE --- */
    [data-theme="dark"] body {
        background-color: var(--bg-color-dark);
        color: var(--text-color-dark);
    }

    /* Navbar & Header */
    [data-theme="dark"] .navbar-custom,
    [data-theme="dark"] .category-bar {
        background-color: var(--card-bg-dark);
        border-color: var(--border-color-dark);
    }

    [data-theme="dark"] .navbar-nav .nav-link,
    [data-theme="dark"] .category-bar a {
        color: #d0d0d0 !important;
    }
    
    [data-theme="dark"] .navbar-nav .nav-link:hover,
    [data-theme="dark"] .category-bar a:hover {
        color: #fff !important;
    }

    /* Cards (Video & News) */
    [data-theme="dark"] .video-card,
    [data-theme="dark"] .video-card-modern,
    [data-theme="dark"] .news-main {
        background-color: var(--card-bg-dark);
        color: var(--text-color-dark);
    }

    /* Typography (Titles & Descriptions) */
    [data-theme="dark"] .news-title,
    [data-theme="dark"] .video-title,
    [data-theme="dark"] .video-title-link,
    [data-theme="dark"] .card-title-link {
        color: #ffffff;
    }

    [data-theme="dark"] .news-description,
    [data-theme="dark"] .video-desc,
    [data-theme="dark"] .copyright {
        color: #b0b0b0;
    }

    /* Footer */
    [data-theme="dark"] .dantri-footer {
        background-color: var(--card-bg-dark);
        color: var(--text-color-dark);
    }
    
    [data-theme="dark"] .footer-links a {
        color: #b0b0b0;
    }

    /* Ads & Other Blocks */
    [data-theme="dark"] .ads {
        background-color: #2c2c2c; /* Màu tối hơn cho Ads */
    }
    
    [data-theme="dark"] .ads h6 {
        color: #81d4fa;
    }

    [data-theme="dark"] .video-meta {
        border-top: 1px solid var(--border-color-dark);
        color: #888;
    }
</style>
<body>

<button id="theme-toggle" title="Chuyển đổi giao diện Sáng/Tối">
    <i class="bi bi-moon-fill" id="theme-icon"></i>
</button>

<jsp:include page="navbar.jsp"/>

<main class="container">
<div class="row mt-4">

    <c:if test="${not empty watchHistoryList}">
        <div class="d-flex align-items-center mb-3">
            <h4 class="text-success fw-bold mb-0">
                <i class="bi bi-collection-play-fill me-2"></i>Tiếp tục xem
            </h4>
        </div>

        <div class="row g-3 mb-5">
            <c:forEach var="h" items="${watchHistoryList}">
                <div class="col-12 col-sm-6 col-md-3">
                    <div class="card h-100 shadow-sm border-0 video-card">
                        
                        <div class="position-relative">
                            <a href="postdetail?id=${h.video.id}">
                                <img src="${h.video.poster}" class="card-img-top" alt="${h.video.title}" 
                                     style="height: 160px; object-fit: cover;">
                                
                                <div class="position-absolute top-50 start-50 translate-middle text-white opacity-0 hover-opacity-100 transition-all">
                                    <i class="bi bi-play-circle-fill fs-1"></i>
                                </div>
                            </a>

                            <div class="progress rounded-0 bg-dark" style="height: 4px;">
                                <c:set var="progressPercent" value="${(h.watchTime * 100.0) / (h.video.duration > 0 ? h.video.duration : 1)}" />
                                
                                <div class="progress-bar bg-danger" role="progressbar" 
                                     style="width: ${progressPercent}%" 
                                     aria-valuenow="${progressPercent}" aria-valuemin="0" aria-valuemax="100">
                                </div>
                            </div>
                            
                            <span class="position-absolute bottom-0 end-0 badge bg-dark m-1" style="font-size: 10px;">
                                Còn <fmt:formatNumber value="${(h.video.duration - h.watchTime) / 60}" maxFractionDigits="0"/> phút
                            </span>
                        </div>

                        <div class="card-body p-2">
                            <h6 class="card-title text-truncate mb-1">
                                <a href="postdetail?id=${h.video.id}" class="text-decoration-none text-dark fw-bold">
                                    ${h.video.title}
                                </a>
                            </h6>
                            <small class="text-muted" style="font-size: 11px;">
                                <i class="bi bi-clock-history"></i> Xem lúc: ${h.lastWatchAt}
                            </small>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
    
    </div>

   <div class="row mt-4">
     <div class="d-flex align-items-center mb-3">
            <h4 class="text-success fw-bold mb-0">
                <i class="bi bi-fire"></i>
MỚI NHẤT__________________________________
            </h4>
        </div>
    <div class="col-md-8 scroll-reveal">
        <c:if test="${not empty newestPost && newestPost.status == 2}">
            <a href="${pageContext.request.contextPath}/postdetail?id=${newestPost.id}" 
               style="text-decoration: none; color: inherit;">
                <div class="news-main">
                    <img src="${newestPost.poster}" alt="${newestPost.title}" loading="lazy">
                    <div class="video-duration">
                        <i class="bi bi-play-fill me-1"></i>
                    </div>
                </div>

                <h3 class="news-title mt-3">
                    ${newestPost.title}
                </h3>

                <p class="news-description text-break">
                    ${newestPost.desc}
                </p>
            </a>
        </c:if>
    </div>

    <div class="col-md-4 scroll-reveal">
        <div class="ads">
             <img src="https://tpc.googlesyndication.com/simgad/6761881345098150582?sqp=4sqPyQQ7QjkqNxABHQAAtEIgASgBMAk4A0DwkwlYAWBfcAKAAQGIAQGdAQAAgD-oAQGwAYCt4gS4AV_FAS2ynT4&rs=AOga4qnv7pg7Dp4rT4fagDTfVQq83XALfw" alt="Máy giặt LG hơi nước" loading="lazy">
            <h6>MÁY GIẶT LG HƠI NƯỚC FB1209S6W1</h6>
            <div class="price">5.950.000đ</div>
            <a href="#">XEM NGAY</a>
        </div>
    </div>
</div>

<section class="latest-videos mt-5 mb-5">
    
    <div class="d-flex align-items-center mb-4 border-bottom pb-2">
        <h4 class="fw-bold text-success m-0 text-uppercase border-bottom border-success border-3 d-inline-block pb-2" style="margin-bottom: -3px !important;">
            <i class="bi bi-collection-play me-2"></i>Video Mới Nhất
        </h4>
        <c:if test="${not empty currentCategory}">
            <span class="ms-3 text-muted">/ ${currentCategory.name}</span>
        </c:if>
    </div>

    <div class="row g-4">
        <c:forEach var="v" items="${videos}">
            <%-- 
                ✅ ĐIỀU KIỆN LỌC: 
                1. !v.premium (Tương đương is_premium == 0/false)
                2. v.status == 2 (Đã duyệt)
            --%>
            <c:if test="${!v.premium && v.status == 2}">
                
                <div class="col-12 col-sm-6 col-lg-3">
                    <div class="video-card-modern scroll-reveal">
                        <div class="thumb-wrapper">
                            <a href="${pageContext.request.contextPath}/postdetail?id=${v.id}">
                                <img src="${v.poster}" alt="${v.title}" class="thumb-img" loading="lazy">
                                
                                <div class="play-overlay">
                                    <i class="bi bi-play-fill ps-1"></i>
                                </div>

                                <span class="badge bg-light text-dark badge-tag shadow-sm">
                                    <i class="bi bi-broadcast me-1"></i>Free
                                </span>
                            </a>
                        </div>

                        <div class="card-body-custom">
                            <a href="${pageContext.request.contextPath}/postdetail?id=${v.id}" class="video-title-link">
                                ${v.title}
                            </a>
                            
                            <p class="video-desc">
                                ${v.desc}
                            </p>

                            <div class="video-meta">
                                <span><i class="bi bi-eye-fill me-1"></i>${v.viewCount} lượt xem</span>
                                <span><i class="bi bi-calendar3 me-1"></i>
                                    <%-- Format ngày tháng nếu cần (dùng JSTL fmt) --%>
                                    ${v.createAt}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

            </c:if>
        </c:forEach>
    </div>
</section>

<c:if test="${not empty vipVideos}">
        <jsp:include page="premiumZone.jsp" />
    </c:if>


<div class="container my-5">
        
        <h2 class="video-section-title mb-4">VIDEO NGẮN</h2>

        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-5 g-4">

            <div class="col">
                <div class="video-card scroll-reveal">
                    <div class="card-media">
                        <a href="#" class="image-zoom-wrapper">
                             <img src="https://cdnphoto.dantri.com.vn/bGOhHRIYO6FQQaka69R0tbM33ds=/thumb_w/480/thumb-video/short-video/2025/11/07/tiktok-7569894476643061012-1762503846596/00_00_00.jpg" alt="Video Thumbnail" loading="lazy">
                            
                            <div class="video-timestamp">07/11/2025</div>
                            <div class="video-tags">
                                
                            </div>
                        </a>
                    </div>
                    <div class="card-title-section">
                        <a href="#" class="card-title-link">
                            Cảnh tượng tan hoang, nhà cửa đổ nát khi bão Kalmaegi quét qua miền Trung
                        </a>
                    </div>
                </div>
            </div>

            <div class="col">
                 <div class="video-card scroll-reveal">
                    <div class="card-media">
                        <a href="#" class="image-zoom-wrapper">
                             <img src="https://cdnphoto.dantri.com.vn/ZkBeXUEdPDHlsuqiJveUdi1WFbM=/thumb_w/480/thumb-video/short-video/2025/11/07/tiktok-7569879601980214548-1762500246443/00_00_00.jpg" loading="lazy">
                            <div class="video-timestamp">07/11/2025</div>
                            <div class="video-tags">
                               
                            </div>
                        </a>
                    </div>
                    <div class="card-title-section">
                        <a href="#" class="card-title-link">
                            Khoảnh khắc sóng biển giật sập cổng, ập vào nhà dân do bão số 13
                        </a>
                    </div>
                </div>
            </div>

            <div class="col">
                 <div class="video-card scroll-reveal">
                    <div class="card-media">
                        <a href="#" class="image-zoom-wrapper">
                             <img src="https://cdnphoto.dantri.com.vn/biL5zba7wdGKO3Z1LU1MaCEppLY=/thumb_w/480/thumb-video/short-video/2025/11/07/tiktok-7569833864932199700-1762489444496/00_00_00.jpg" alt="Video Thumbnail" loading="lazy">
                            <div class="video-timestamp">07/11/2025</div>
                            <div class="video-tags">
                                
                            </div>
                        </a>
                    </div>
                    <div class="card-title-section">
                        <a href="#" class="card-title-link">
                            Lũ lớn cuốn trôi ô tô chở 2 người ở Đắk Lắk, người dân kịp thời ứng cứu
                        </a>
                    </div>
                </div>
            </div>

            <div class="col">
                 <div class="video-card scroll-reveal">
                    <div class="card-media">
                        <a href="#" class="image-zoom-wrapper">
                             <img src="https://cdnphoto.dantri.com.vn/W4AfHy1raDdLzntXuw7RX6lG5_0=/thumb_w/480/thumb-video/short-video/2025/11/07/tiktok-7569827106960493844-1762488004428/00_00_00.jpg" alt="Video Thumbnail" loading="lazy">
                            <div class="video-timestamp">07/11/2025</div>
                            <div class="video-tags">
                               
                            </div>
                        </a>
                    </div>
                    <div class="card-title-section">
                        <a href="#" class="card-title-link">
                            Doanh nghiệp đề xuất chi tiền sửa cầu Sông Lô đang bị hư hỏng nặng
                        </a>
                    </div>
                </div>
            </div>

            <div class="col">
                 <div class="video-card scroll-reveal">
                    <div class="card-media">
                        <a href="#" class="image-zoom-wrapper">
                             <img src="https://cdnphoto.dantri.com.vn/vMMPNCItJgzLJSL7PnQr5s22GQk=/thumb_w/480/thumb-video/short-video/2025/11/07/tiktok-7569810664726744340-1762484043950/00_00_00.jpg" alt="Video Thumbnail" loading="lazy">
                            <div class="video-timestamp">07/11/2025</div>
                            <div class="video-tags">
                                <span class="badge bg-light text-dark">NEWS</span>
                                <span class="badge bg-danger">REC</span>
                            </div>
                        </a>
                    </div>
                    <div class="card-title-section">
                        <a href="#" class="card-title-link">
                            Khoảnh khắc tôn bay như lá, sóng biển dội như thác trong bão Kalmaegi
                        </a>
                    </div>
                </div>
            </div>

        </div> </div>
</main>

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
        // --- 1. DARK MODE LOGIC ---
        const themeToggleBtn = document.getElementById("theme-toggle");
        const themeIcon = document.getElementById("theme-icon");
        const htmlElement = document.documentElement;

        // Kiểm tra localStorage khi tải trang
        const savedTheme = localStorage.getItem("theme");
        if (savedTheme === "dark") {
            htmlElement.setAttribute("data-theme", "dark");
            themeIcon.classList.replace("bi-moon-fill", "bi-sun-fill");
        }

        // Sự kiện click nút toggle
        themeToggleBtn.addEventListener("click", function() {
            if (htmlElement.getAttribute("data-theme") === "dark") {
                // Chuyển sang Light Mode
                htmlElement.removeAttribute("data-theme");
                localStorage.setItem("theme", "light");
                themeIcon.classList.replace("bi-sun-fill", "bi-moon-fill");
            } else {
                // Chuyển sang Dark Mode
                htmlElement.setAttribute("data-theme", "dark");
                localStorage.setItem("theme", "dark");
                themeIcon.classList.replace("bi-moon-fill", "bi-sun-fill");
            }
        });

        // --- 2. CÁC SCRIPT CŨ (VALIDATE, OBSERVER...) ---
        
        // Observer cho hiệu ứng cuộn
        const observerOptions = {
            root: null,
            rootMargin: '0px',
            threshold: 0.1
        };

        const observer = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('active');
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        const hiddenElements = document.querySelectorAll('.scroll-reveal');
        hiddenElements.forEach((el) => observer.observe(el));
    });

    function validateSearch() {
        let keyword = document.getElementById("searchInput").value.trim();
        if (keyword === "") {
            alert("Vui lòng nhập từ khóa tìm kiếm");
            return false;
        }
        return true;
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"></script>
</body>
</html>