<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết bài đăng - Dân Trí</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <style>
        :root {
            --dantri-green: #006837;
            --bg-light: #f1f1f1;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: var(--bg-light);
            color: #333;
        }

        a { text-decoration: none; color: inherit; }
        
        /* Layout & Container */
        .container-custom {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }
        
        /* Thêm vào thẻ <style> */
.reply-form-container {
    display: none; 
    margin-left: 55px; /* Căn thẳng hàng với nội dung comment */
    margin-top: 5px;
    margin-bottom: 15px;
}

.custom-switch { width: 3rem !important; height: 1.5rem !important; cursor: pointer; }
    .podcast-icon-wrapper { position: relative; }
    .pulse-ring {
        position: absolute; width: 100%; height: 100%; border: 2px solid #ffc107;
        border-radius: 50%; animation: pulse 2s infinite; display: none;
    }
    @keyframes pulse { 0% { transform: scale(0.8); opacity: 1; } 100% { transform: scale(1.5); opacity: 0; } }

        .main-wrapper { display: flex; gap: 30px; }
        .main-content { flex: 2; min-width: 0; }
        .sidebar { flex: 1; min-width: 300px; }

        /* Video Player */
        .video-player { background: #000; margin-bottom: 20px; }
        .video-details h1 { font-size: 26px; font-weight: bold; line-height: 1.3; margin-top: 15px; }
        .news-description { font-size: 16px; line-height: 1.6; color: #444; margin-bottom: 15px; }

        /* --- STYLE CHO BÌNH LUẬN (QUAN TRỌNG) --- */
        .comment-avatar {
            width: 45px; height: 45px; object-fit: cover; border-radius: 50%;
        }
        .comment-bubble {
            background-color: #f0f2f5;
            border-radius: 18px;
            padding: 10px 15px;
            display: inline-block;
            min-width: 180px;
        }
        .comment-info { margin-bottom: 2px; }
        .comment-name { font-weight: bold; font-size: 14px; color: #050505; }
        .comment-time { font-size: 11px; color: #65676b; margin-left: 5px; }
        .comment-content { font-size: 14px; color: #050505; line-height: 1.4; margin: 0; }
        
        /* Action Links (Like, Reply) */
        .action-links a {
            font-size: 12px; font-weight: bold; color: #65676b; 
            margin-right: 15px; cursor: pointer; text-decoration: none;
        }
        .action-links a:hover { text-decoration: underline; color: var(--dantri-green); }

        /* Form trả lời ẩn */
     

        /* Bình luận con (Nested) */
        .nested-comments {
            margin-left: 55px; /* Thụt lề */
            margin-top: 10px;
            padding-left: 10px;
            border-left: 2px solid #e4e6eb; /* Đường kẻ dọc */
        }
        
        /* Sidebar & Related */
        .sidebar h3 {
            font-size: 18px; text-transform: uppercase; color: var(--dantri-green);
            border-bottom: 2px solid var(--dantri-green); padding-bottom: 8px; margin-bottom: 20px;
        }
        .video-item { display: flex; gap: 10px; margin-bottom: 15px; }
        .video-item img { width: 120px; height: 68px; object-fit: cover; border-radius: 4px; }
        .video-item a { font-size: 14px; font-weight: bold; color: #333; line-height: 1.4; }
        .video-item a:hover { color: var(--dantri-green); }

        /* Footer */
        .dantri-footer { background: #fff; padding: 30px 0; border-top: 3px solid var(--dantri-green); font-size: 14px; }
        .footer-logo { font-size: 32px; font-weight: 900; color: var(--dantri-green); display: block; margin-bottom: 15px; }
        
        /* Utilities */
        .text-dantri { color: var(--dantri-green) !important; }
        .btn-outline-dantri { color: var(--dantri-green); border-color: var(--dantri-green); }
        .btn-outline-dantri:hover { background-color: var(--dantri-green); color: #fff; }
         .news-description {
  word-break: break-word;
  overflow-wrap: break-word;
  white-space: normal;
}

.custom-scrollbar::-webkit-scrollbar {
    height: 6px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
    background: #ccc;
    border-radius: 10px;
}
.transition-all:hover {
    transform: translateY(-3px);
    border-color: var(--dantri-green) !important;
    background-color: #f0fdf4 !important;
}

/* CSS cho hiệu ứng nhấp nháy (Animation) */
    @keyframes pulse-light {
        0% { box-shadow: 0 0 0 0 rgba(0, 104, 55, 0.7); }
        70% { box-shadow: 0 0 0 10px rgba(0, 104, 55, 0); }
        100% { box-shadow: 0 0 0 0 rgba(0, 104, 55, 0); }
    }
    
    .chatbot-toggler-new {
        /* Dùng tên class mới để không xung đột CSS cũ */
        position: fixed;
        bottom: 30px;
        right: 35px;
        height: 60px;
        width: 60px;
        border-radius: 50%;
        background: #006837; /* Màu Dân trí */
        color: #fff;
        cursor: pointer;
        z-index: 9999;
        display: flex;
        align-items: center;
        justify-content: center;
        border: none;
        outline: none;
        box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        animation: pulse-light 2s infinite; /* Thêm hiệu ứng nhấp nháy */
    }
    
   /* Style Avatar Overlay - Cố định ở góc trái dưới video */
.avatar-overlay {
    position: absolute;
    bottom: 60px; /* Cao hơn thanh điều khiển 1 chút */
    left: 20px;   /* Căn trái */
    z-index: 999;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    pointer-events: none; /* Cho phép click xuyên qua vùng trống */
}

/* Bong bóng thoại */
.avatar-bubble {
    background: white;
    padding: 8px 12px;
    border-radius: 15px 15px 15px 0; /* Bo tròn, nhọn góc trái dưới */
    font-size: 12px;
    font-weight: bold;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    max-width: 150px;
    animation: fadeInUp 0.5s;
    pointer-events: auto;
}

/* Ảnh Avatar */
.avatar-overlay img {
    width: 100px; /* Kích thước cố định */
    height: auto;
    filter: drop-shadow(0 4px 6px rgba(0,0,0,0.3));
    pointer-events: auto; /* Bật lại click cho ảnh */
    cursor: pointer;
    transition: transform 0.2s;
}
.avatar-overlay img:hover { transform: scale(1.1); }

/* Nút điều khiển ẩn */
.avatar-controls {
    position: absolute;
    left: 110px; /* Hiện nút bên phải avatar */
    bottom: 10px;
    display: none; /* Mặc định ẩn */
    flex-direction: column;
    gap: 5px;
    pointer-events: auto;
}
.avatar-controls.active { display: flex; }

    .chatbot-tooltip {
        position: fixed;
        right: 100px;
        bottom: 45px;
        background: #006837;
        color: white;
        padding: 8px 15px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: bold;
        z-index: 9998;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        opacity: 0.9;
        pointer-events: none;
        transition: opacity 0.3s;
    }

    .chat-window-new {
        position: fixed;
        right: 35px;
        bottom: 100px;
        width: 350px;
        height: 480px; /* Tăng chiều cao một chút */
        background: #fff;
        border-radius: 15px;
        overflow: hidden;
        box-shadow: 0 0 20px rgba(0,0,0,0.3);
        flex-direction: column;
        display: none;
        z-index: 10000;
    }
    
    /* Hiển thị rõ ràng cho user biết đây là chức năng giải thích */
    .chat-header-new {
        background: #006837;
        color: white;
        padding: 15px 20px;
        font-weight: bold;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 3px solid #ffc107; /* Thêm đường viền vàng nổi bật */
    }
    
    .chat-content-new {
        flex: 1;
        padding: 15px;
        overflow-y: auto;
        background: #f8f9fa;
        font-size: 14px;
    }

    .chat-input-new {
        padding: 10px 15px;
        border-top: 1px solid #eee;
        background: white;
        display: flex;
        gap: 5px;
    }
.commerce-popup {
    position: absolute;
    bottom: 80px; /* Cách thanh điều khiển video một khoảng */
    right: 20px;
    background: rgba(255, 255, 255, 0.95);
    padding: 12px;
    border-radius: 12px;
    width: 320px;
    z-index: 1000;
    border: 1px solid #e0e0e0;
    backdrop-filter: blur(5px); /* Làm mờ nhẹ nền phía sau popup cho sang trọng */
}
.commerce-popup:hover {
    transform: translateY(-5px);
    transition: 0.3s ease;
}
    </style>
</head>

<body>

    <jsp:include page="navbar.jsp" />

    <div class="container container-custom">
        <nav aria-label="breadcrumb" class="mb-4 pb-2 border-bottom">
            <a href="home.jsp" class="text-success fw-bold">Trang chủ</a> 
            <c:if test="${category != null}">
                <i class="bi bi-chevron-right mx-1 text-muted" style="font-size: 12px;"></i>
                <a href="#" class="text-success fw-bold">${category.name}</a>
            </c:if>
        </nav>

        <div class="main-wrapper">
            <main class="main-content">
                
<%-- Bọc toàn bộ trình phát vào container để làm mốc tọa độ --%>
<div class="video-player position-relative" id="videoContainer">
    
    <%-- 1. TRÌNH PHÁT VIDEO (GIỮ NGUYÊN) --%>
    <c:choose>
        <c:when test="${not empty video.getEmbedUrl()}">
            <iframe id="ytPlayer" width="100%" height="450" 
                    src="${video.getEmbedUrl()}?enablejsapi=1" 
                    frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
            <input type="hidden" id="videoType" value="YOUTUBE">
        </c:when>
        <c:otherwise>
            <video id="mainVideo" class="w-100" height="450" controls autoplay muted>
                <source src="${video.url}" type="video/mp4" />
            </video>
            <input type="hidden" id="videoType" value="MP4">
        </c:otherwise>
    </c:choose>

    <%-- 2. COMMERCE POPUP (GIỮ NGUYÊN - GÓC PHẢI) --%>
    <div id="commerce-popup" class="commerce-popup shadow-lg animate__animated" 
         style="display: none; position: absolute; bottom: 80px; right: 20px; z-index: 1000; background: white; padding: 10px; border-radius: 12px; width: 300px;">
        <div class="d-flex align-items-center">
            <img id="pop-img" src="" class="rounded me-2" style="width: 60px; height: 60px; object-fit: cover;">
            <div class="flex-grow-1">
                <h6 id="pop-name" class="mb-0 fw-bold small text-truncate"></h6>
                <div id="pop-price" class="text-danger small fw-bold"></div>
                <a id="pop-link" href="#" target="_blank" class="btn btn-success btn-sm mt-1 py-0">Mua ngay</a>
            </div>
        </div>
    </div>

    <%-- 3. PERSONALIZED AVATAR (MỚI - GÓC TRÁI) --%>
    <div id="news-avatar-wrapper" class="avatar-overlay animate__animated" style="display: none;">
        <div id="avatar-bubble" class="avatar-bubble mb-2">Xin chào! 👋</div>
        
        <img id="avatar-img" src="assets/avatars/default_neutral.png" 
             alt="News Avatar" class="img-fluid" style="height: 120px;"
             onclick="toggleAvatarControls()">
        
        <div id="avatar-controls" class="avatar-controls">
            <button class="btn btn-sm btn-light rounded-circle shadow mb-1 text-danger" title="Tắt Avatar" onclick="toggleAvatarVisibility()">
                <i class="bi bi-eye-slash-fill"></i>
            </button>
            <button class="btn btn-sm btn-warning rounded-circle shadow text-dark" title="Đổi Skin" onclick="openSkinShop()">
                <i class="bi bi-shop"></i>
            </button>
        </div>
    </div>
</div>

<%-- 4. MODAL CỬA HÀNG SKIN (Đặt ngoài videoContainer) --%>
<div class="modal fade" id="skinShopModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-warning text-dark">
                <h5 class="modal-title fw-bold"><i class="bi bi-palette-fill me-2"></i>Tủ đồ Avatar</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-4">
                        <div class="card h-100 border-primary cursor-pointer" onclick="changeSkin('default_')">
                            <img src="assets/avatars/default_neutral.png" class="card-img-top p-2">
                            <div class="card-body p-1 text-center bg-primary text-white">
                                <small class="fw-bold">Cơ bản</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="card h-100 cursor-pointer" onclick="changeSkin('robot_')">
                            <img src="assets/avatars/robot_neutral.png" class="card-img-top p-2">
                            <div class="card-body p-1 text-center bg-light">
                                <small class="fw-bold">Robot</small> <br>
                                <span class="badge bg-warning text-dark">50 Xu</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="card h-100 cursor-pointer" onclick="changeSkin('nike_')">
                            <img src="assets/avatars/nike_neutral.png" class="card-img-top p-2">
                            <div class="card-body p-1 text-center bg-light">
                                <small class="fw-bold">Nike</small> <br>
                                <span class="badge bg-success">FREE</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
                <article class="video-details">
                    <h1>${video.title}</h1>
                    <div class="d-flex align-items-center text-muted small mb-3">
                        <i class="bi bi-clock me-1"></i> ${video.createAt}
                        <span class="mx-2">|</span>
                        <i class="bi bi-heart-fill text-danger me-1"></i> ${favouriteCount} yêu thích
                    </div>
                    <p class="news-description ">${video.desc}</p>
                </article>
                
              
                
                <div class="card border-0 shadow-sm rounded-4 mb-4 overflow-hidden" 
     style="background: linear-gradient(135deg, #006837 0%, #00a859 100%); color: white;">
    <div class="card-body p-4">
        <div class="d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center">
                <div class="podcast-icon-wrapper me-3">
                    <div class="pulse-ring"></div>
                    <i class="bi bi-mic-fill fs-2 text-warning"></i>
                </div>
                <div>
                    <h6 class="mb-0 fw-bold">Chế độ Audio Podcast</h6>
                    <small class="opacity-75">Nghe tin tức tiết kiệm dữ liệu</small>
                </div>
            </div>
            
            <c:choose>
                <c:when test="${sessionScope.user.vip}">
                    <div class="form-check form-switch">
                        <input class="form-check-input custom-switch" type="checkbox" id="audioModeToggle" onchange="toggleAudioMode()">
                        <label class="form-check-label fw-bold" for="audioModeToggle">KÍCH HOẠT</label>
                    </div>
                </c:when>
                <c:otherwise>
                    <button class="btn btn-warning btn-sm fw-bold rounded-pill" onclick="showVipRequired()">
                        <i class="bi bi-crown-fill me-1"></i> VIP ONLY
                    </button>
                </c:otherwise>
            </c:choose>
        </div>

        <div id="audio-player-ui" class="mt-3 py-2 border-top border-white border-opacity-25" style="display: none;">
            <div class="d-flex justify-content-center align-items-center gap-4">
                <button class="btn text-white p-0" onclick="skipAudio(-15)"><i class="bi bi-rewind-15 fs-3"></i></button>
                <button class="btn text-white p-0" id="audioPlayBtn" onclick="togglePlayback()">
                    <i class="bi bi-play-circle-fill" style="font-size: 3rem;"></i>
                </button>
                <button class="btn text-white p-0" onclick="skipAudio(15)"><i class="bi bi-fast-forward-15 fs-3"></i></button>
            </div>
            <div class="progress mt-3" style="height: 5px; background: rgba(255,255,255,0.2);">
                <div id="audioProgressBar" class="progress-bar bg-warning" style="width: 0%"></div>
            </div>
        </div>
    </div>
</div>
                
                <%-- =========================================================
     PHẦN NÂNG CẤP: INTERACTIVE TIMELINE (CHAPTERS)
     ========================================================= --%>
<%-- =========================================================
     PHẦN NÂNG CẤP: QUẢN LÝ INTERACTIVE TIMELINE (CHAPTERS)
     ========================================================= --%>
<%-- =========================================================
     KHU VỰC: AI NEWS SUMMARY & INTERACTIVE TIMELINE
     ========================================================= --%>
<div class="row g-4 mb-4">
    <div class="col-md-12">
        <div class="card border-0 shadow-sm rounded-4" style="background: #f8f9fa; border-left: 4px solid var(--dantri-green) !important;">
            <div class="card-header bg-transparent border-0 pt-3 pb-0">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h6 class="fw-bold text-dantri mb-0">
                        <i class="bi bi-layers-half me-2"></i>MỤC LỤC VIDEO (CHAPTERS)
                    </h6>
                    <%-- Công cụ AI dành cho tất cả mọi người --%>
                    <button type="button" class="btn btn-outline-success btn-sm fw-bold rounded-pill" onclick="generateAIChapters()">
                        <i class="bi bi-magic me-1"></i> AI SINH PHÂN ĐOẠN
                    </button>
                </div>

                <%-- Thanh trượt Chapters để nhảy giây video --%>
                <div class="d-flex flex-nowrap overflow-auto gap-2 pb-3 custom-scrollbar" id="chapter-nav">
                    <c:forEach var="chap" items="${chapters}">
                        <button type="button" 
                                class="btn btn-white border shadow-sm btn-sm d-flex align-items-center gap-2 px-3 py-2 rounded-pill transition-all" 
                                onclick="seekToChapter(${chap.startTime}, ${chap.isPremium})"
                                style="white-space: nowrap; min-width: fit-content; background: white;">
                            <span class="badge bg-success bg-opacity-10 text-success rounded-circle p-1" style="width: 24px; height: 24px; display: flex; align-items: center; justify-content: center;">
                                <i class="bi bi-play-fill"></i>
                            </span>
                            <div class="text-start">
                                <div class="fw-bold text-dark" style="font-size: 13px;">${chap.chapterTitle}</div>
                                <small class="text-muted" style="font-size: 11px;">Mốc: ${chap.startTime}s</small>
                            </div>
                        </button>
                    </c:forEach>
                    <c:if test="${empty chapters}">
                        <small class="text-muted fst-italic ms-2">Video này chưa được chia phân đoạn.</small>
                    </c:if>
                </div>
            </div>
            
            <%-- Bảng quản lý danh sách Chapters (Hiển thị chi tiết) --%>
            <div class="card-body border-top">
                <h6 class="small fw-bold text-secondary mb-3 text-uppercase">Danh sách chi tiết</h6>
                <div class="table-responsive">
                    <table class="table table-sm table-hover align-middle mb-0" style="font-size: 14px;">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 80px;">Thời gian</th>
                                <th>Nội dung phân đoạn</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="chap" items="${chapters}">
                                <tr>
                                    <td><span class="badge bg-secondary rounded-pill px-2">${chap.startTime}s</span></td>
                                    <td class="fw-medium">${chap.chapterTitle}</td>
                                    <td class="text-end">
                                        <%-- Nhấn để điền nhanh vào Form nhập liệu phía dưới (dành cho Admin hoặc User có quyền) --%>
                                        <button class="btn btn-sm btn-link text-primary p-0" 
                                                onclick="applyToForm('${chap.startTime}', '${fn:escapeXml(chap.chapterTitle)}')"
                                                title="Điền nhanh vào form">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>



                <form action="${pageContext.request.contextPath}/favourite" method="post" class="mb-4">
                    <input type="hidden" name="videoId" value="${video.id}" />
                    <button type="submit" class="btn ${isFavourited ? 'btn-danger' : 'btn-outline-danger'} px-4 rounded-pill">
                        <i class="bi ${isFavourited ? 'bi-heart-fill' : 'bi-heart'} me-1"></i>
                        ${isFavourited ? 'Đã yêu thích' : 'Yêu thích'}
                    </button>
                </form>
                
                

                <hr class="text-muted opacity-25">

<%-- VỊ TRÍ 2: GIỮA NỘI DUNG (IN_CONTENT_1) --%>
<c:if test="${not empty inContentBanner}">
    <c:set var="ad" value="${inContentBanner[0]}"/>
    <div class="card p-3 mb-4 border-0" style="background-color: #e6f7ff; border-left: 5px solid #007bff; border-radius: 8px;">
        <a href="${ad.targetUrl}" target="_blank" title="${ad.title}" style="text-decoration: none;">
            <div class="d-flex align-items-start">
                <i class="bi bi-lightbulb-fill text-primary fs-4 me-3 flex-shrink-0"></i>
                <div class="flex-grow-1">
                    <p class="mb-1 fw-bold text-primary small text-uppercase">GỢI Ý THAM KHẢO</p>
                    <h5 class="fw-bold text-dark mb-1">${ad.title}</h5>
                    <small class="text-muted d-block">${fn:substring(ad.targetUrl, 0, 50)}...</small>
                </div>
                <img src="${ad.imageUrl}" alt="Banner" style="width: 80px; height: 50px; object-fit: cover; border-radius: 4px;" class="ms-3">
            </div>
        </a>
    </div>
</c:if>

                <div id="comments-section" class="mt-4">
                    <h4 class="fw-bold text-dantri mb-4">
                        <i class="bi bi-chat-dots me-2"></i>Bình luận (${fn:length(comments)})
                    </h4>

                    <div class="d-flex gap-3 mb-5">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.user.name != null ? sessionScope.user.name : 'Khach'}&background=random&color=fff" 
                             class="comment-avatar shadow-sm">
                        <div class="w-100">
                            <form action="${pageContext.request.contextPath}/comment/add" method="post">
                                <input type="hidden" name="videoId" value="${video.id}">
                                <div class="form-floating mb-2">
                                    <textarea class="form-control" placeholder="Viết bình luận..." id="mainComment" 
                                              name="content" style="height: 100px; border-radius: 15px;" required></textarea>
                                    <label for="mainComment" class="text-muted">Chia sẻ ý kiến của bạn...</label>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <small class="text-muted fst-italic">Vui lòng sử dụng tiếng Việt có dấu.</small>
                                    <button type="submit" class="btn btn-success px-4 rounded-pill fw-bold">Gửi</button>
                                </div>
                            </form>
                        </div>
                    </div>

               <c:set var="currentUserId" value="${sessionScope.user.id}" />

<c:choose>
        <c:when test="${empty comments}">
            <div class="text-center py-5 bg-light rounded-3">
                <i class="bi bi-chat-square-text text-muted fs-1 mb-2"></i>
                <p class="text-muted">Chưa có bình luận nào. Hãy là người đầu tiên!</p>
            </div>
        </c:when>

        <c:otherwise>
            <c:forEach var="c" items="${comments}">
                
                <%-- =========================================================
                     1. HIỂN THỊ BÌNH LUẬN CHA (Parent Comment)
                     (Phần này bị thiếu trong code cũ của bạn)
                     ========================================================= --%>
                <div class="d-flex gap-3 mb-3">
                    <%-- Avatar User Cha --%>
                    <img src="https://ui-avatars.com/api/?name=${c.user.name}&background=random&color=fff" 
                         class="rounded-circle shadow-sm" style="width: 40px; height: 40px;">
                    
                    <div class="w-100">
                        <%-- Bubble Chat Cha --%>
                        <div class="comment-bubble p-3 rounded-3" 
                             style="background-color: ${c.user.vip ? '#fff3cd' : '#f0f2f5'}; 
                                    border: ${c.user.vip ? '1px solid #ffe69c' : 'none'};">
                            
                            
                            <div class="d-flex align-items-center gap-2 mb-1">
    <%-- 1. Tên người dùng --%>
    <span class="fw-bold text-dark" style="font-size: 14px;">
                                    ${c.user.name}
    </span>

    <%-- 2. Huy hiệu VIP (Dùng icon ngôi sao cho gọn + text nhỏ) --%>
    <c:if test="${c.user.vip}">
        <span class="badge bg-warning text-dark border border-warning rounded-pill d-flex align-items-center px-2" 
              style="font-size: 9px; height: 18px;">
            <i class="bi bi-star-fill me-1"></i> VIP
        </span>
    </c:if>

    <%-- 3. Dấu chấm ngăn cách và Thời gian --%>
    <span class="text-muted" style="font-size: 11px;">
        &bull; ${c.createAt}
    </span>
</div>
                            
                            <p class="mb-0 text-secondary">${c.content}</p>
                        </div>

                        <%-- Action Links Cha --%>
                        <div class="d-flex align-items-center gap-3 mt-1 ms-2">
                            <a href="${pageContext.request.contextPath}/comment/like?id=${c.id}" 
                               class="text-decoration-none small ${c.isLikedByUser(currentUserId) ? 'text-primary fw-bold' : 'text-muted'}">
                               ${c.isLikedByUser(currentUserId) ? 'Đã thích' : 'Thích'}
                            </a>
                            
                            <c:if test="${fn:length(c.likes) > 0}">
                                <span class="small text-muted">
                                    <i class="bi bi-hand-thumbs-up-fill text-primary"></i> ${fn:length(c.likes)}
                                </span>
                            </c:if>

                            <a onclick="toggleReplyForm('${c.id}')" class="text-decoration-none small text-muted" style="cursor: pointer;">Trả lời</a>
                        </div>
                        
                        <%-- Form Trả lời cho Cha (Ẩn mặc định) --%>
                        <div id="reply-form-${c.id}" class="mt-2" style="display: none;">
                             <form action="${pageContext.request.contextPath}/comment/add" method="post">
                                <input type="hidden" name="videoId" value="${video.id}">
                                <input type="hidden" name="parentId" value="${c.id}">
                                <input type="hidden" name="replyToUserId" value="${c.user.id}">
                                <div class="input-group">
                                    <input type="text" name="content" class="form-control form-control-sm" placeholder="Viết câu trả lời...">
                                    <button class="btn btn-primary btn-sm" type="submit"><i class="bi bi-send"></i></button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <%-- =========================================================
                     2. HIỂN THỊ CÁC CÂU TRẢ LỜI (Replies)
                     (Phần này bạn đã làm đúng, chỉ cần giữ nguyên)
                     ========================================================= --%>
                <c:if test="${not empty c.replies}">
                    <div class="nested-comments ms-5 ps-3 border-start">
                        <c:forEach var="reply" items="${c.replies}">
                            <div class="d-flex gap-3 mb-3">
                                <img src="https://ui-avatars.com/api/?name=${reply.user.name}&background=random&color=fff" 
                                     class="rounded-circle shadow-sm" style="width: 30px; height: 30px;">
                                
                                <div class="w-100">
                                    <div class="comment-bubble p-2 rounded-3" 
                                         style="background-color: ${reply.user.vip ? '#fff3cd' : '#f7f7f7'}; 
                                                border: ${reply.user.vip ? '1px solid #ffe69c' : 'none'};">
                                        <div class="d-flex align-items-center gap-2 mb-1">
    <%-- 1. Tên người dùng --%>
    <span class="fw-bold text-dark" style="font-size: 14px;">
        ${reply.user.name}
    </span>

    <%-- 2. Huy hiệu VIP (Dùng icon ngôi sao cho gọn + text nhỏ) --%>
    <c:if test="${reply.user.vip}">
        <span class="badge bg-warning text-dark border border-warning rounded-pill d-flex align-items-center px-2" 
              style="font-size: 9px; height: 18px;">
            <i class="bi bi-star-fill me-1"></i> VIP
        </span>
    </c:if>

    <%-- 3. Dấu chấm ngăn cách và Thời gian --%>
    <span class="text-muted" style="font-size: 11px;">
        &bull; ${reply.createAt}
    </span>
</div>
                                        <p class="mb-0 small text-secondary">${reply.content}</p>
                                    </div>

                                    <div class="action-links mt-1 ms-1 d-flex gap-3">
                                        <a href="${pageContext.request.contextPath}/comment/like?id=${reply.id}" 
                                           class="text-decoration-none small ${reply.isLikedByUser(currentUserId) ? 'text-primary fw-bold' : 'text-muted'}" 
                                           style="font-size: 10px;">
                                           ${reply.isLikedByUser(currentUserId) ? 'Đã thích' : 'Thích'}
                                        </a>
                                        
                                         <a onclick="toggleReplyForm('${c.id}', '@${reply.user.name} ')" 
                                            class="text-decoration-none small text-muted" 
                                            style="cursor: pointer; font-size: 10px;">Trả lời</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:if>
            </c:forEach>
        </c:otherwise>
    </c:choose>
                </div>
            </main>

            <aside class="sidebar">
            
<%-- VỊ TRÍ 1: SIDEBAR_TOP --%>
<c:if test="${not empty sidebarBanner}">
    <c:set var="ad" value="${sidebarBanner[0]}"/>
    <div class="card mb-4" style="border-radius: 12px; overflow: hidden;">
        <div class="p-2 bg-success text-white text-center fw-bold small" style="letter-spacing: 0.5px;">
            <i class="bi bi-fire me-1"></i> ƯU ĐÃI ĐỘC QUYỀN <i class="bi bi-fire ms-1"></i>
        </div>
        <div class="card-body p-3 text-center">
            <a href="${ad.targetUrl}" target="_blank" title="${ad.title}" style="text-decoration: none; color: inherit;">
                <img src="${ad.imageUrl}" alt="${ad.title}" class="img-fluid rounded mb-2" style="max-height: 120px; width: 100%; object-fit: cover; border: 1px solid #eee;">
                <h6 class="fw-bold text-dark mb-1">${ad.title}</h6>
                <p class="small text-muted mb-2">Quảng cáo dành cho ${ad.targetAudience == 'VIP' ? 'Đối tác Cao cấp' : 'Khách vãng lai'}</p>
                <button class="btn btn-sm btn-outline-success w-100 fw-bold rounded-pill">
                    XEM CHI TIẾT <i class="bi bi-arrow-right"></i>
                </button>
            </a>
        </div>
    </div>
</c:if>
                <h3>Video cùng chuyên mục</h3>
                <div class="related-videos">
                    <c:forEach var="v" items="${relatedVideos}">
                        <div class="video-item">
                            <div class="flex-shrink-0">
                                <a href="postdetail?id=${v.id}">
                                    <img src="${v.poster}" alt="${v.title}">
                                </a>
                            </div>
                            <div>
                                <a href="postdetail?id=${v.id}">${v.title}</a>
                                <div class="text-muted small mt-1"><i class="bi bi-eye"></i> ${v.viewCount} lượt xem</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <div class="mt-4 text-center">
   <%-- VỊ TRÍ 3: SIDEBAR_BOTTOM --%>
<c:if test="${not empty bottomBanner}">
    <c:set var="ad" value="${bottomBanner[0]}"/>
    <div class="card border-0 shadow-lg text-center mt-5" style="border-radius: 10px;">
        <div class="card-body p-0">
            <a href="${ad.targetUrl}" target="_blank" title="${ad.title}">
                <img src="${ad.imageUrl}" alt="${ad.title}" class="img-fluid" style="border-radius: 10px;">
            </a>
        </div>
        <div class="p-2 bg-light">
            <small class="text-secondary fw-bold">QUẢNG CÁO TỪ ĐỐI TÁC</small>
        </div>
    </div>
</c:if>
<c:if test="${empty bottomBanner}">
    <img src="https://via.placeholder.com/300x450.png?text=Quang+Cao+300x450" alt="Quảng cáo" class="img-fluid">
</c:if>
    <c:if test="${empty bottomBanner}">
        <img src="https://via.placeholder.com/300x450.png?text=Quang+Cao+300x450" alt="Quảng cáo" class="img-fluid">
    </c:if>
</div>
            </aside>
        </div>
    </div>

    <footer class="dantri-footer mt-5">
        <div class="container">
            <div class="row">
                <div class="col-lg-5 mb-4">
                    <a href="/" class="footer-logo">DANTRI</a>
                    <p><strong>Cơ quan của Bộ Lao động - Thương binh và Xã hội</strong></p>
                    <p>Tổng biên tập: Phạm Tuấn Anh</p>
                    <p class="text-muted small">© 2005-2025 Bản quyền thuộc về Báo điện tử Dân trí.</p>
                </div>
                <div class="col-lg-3 mb-4">
                    <h6 class="fw-bold mb-3">Liên hệ</h6>
                    <ul class="list-unstyled">
                        <li class="mb-2"><a href="#">Giới thiệu</a></li>
                        <li class="mb-2"><a href="#">Liên hệ quảng cáo</a></li>
                    </ul>
                </div>
                <div class="col-lg-4 mb-4">
                    <h6 class="fw-bold mb-3">Theo dõi chúng tôi</h6>
                    <div class="fs-4 d-flex gap-3">
                        <a href="#"><i class="bi bi-facebook text-primary"></i></a>
                        <a href="#"><i class="bi bi-youtube text-danger"></i></a>
                        <a href="#"><i class="bi bi-tiktok text-dark"></i></a>
                    </div>
                </div>
            </div>
        </div>
        <div id="explainer-bot-widget">
    
    <div id="chatbot-tooltip" class="chatbot-tooltip">
        💡 Trợ lý AI: Hỏi thuật ngữ khó hiểu trong bài!
    </div>
    
    <button id="chatbot-toggler-btn" class="chatbot-toggler-new" onclick="toggleChat()">
        <i class="bi bi-lightbulb-fill" style="font-size: 28px;"></i>
    </button>

    <div id="chat-window" class="chat-window-new">
        
        <div class="chat-header-new">
            <span><i class="bi bi-stars me-2"></i>TRỢ LÝ GIẢI THÍCH NỘI DUNG</span>
            <span onclick="toggleChat()" style="cursor: pointer; font-size: 1.5rem;">&times;</span>
        </div>

        <div id="chat-content" class="chat-content-new">
            <div class="mb-3">
                <div style="background: #e9ecef; padding: 12px; border-radius: 15px 15px 15px 0; display: inline-block;">
                    <p class="mb-0 fw-bold text-success">Xin chào!</p>
                    <small>Tôi là trợ lý AI của Dân Trí. Hãy gõ ngay từ khóa hoặc câu hỏi bạn thắc mắc để tôi giải thích nhanh chóng! (VD: **CPI là gì?**)</small>
                </div>
            </div>
        </div>

        <div class="chat-input-new">
            <input type="text" id="user-input" placeholder="Nhập từ khóa hoặc câu hỏi..." 
                   style="flex: 1; border: 1px solid #ddd; padding: 10px; border-radius: 20px; outline: none;"
                   onkeypress="if(event.key === 'Enter') sendMessage()">
            <button onclick="sendMessage()" style="border: none; background: #006837; color: white; border-radius: 50%; width: 40px; height: 40px; font-size: 1.1rem;">
                <i class="bi bi-send-fill"></i>
            </button>
        </div>
    </div>
</div>
    </footer>
<script src="https://www.youtube.com/iframe_api"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Hàm ẩn/hiện form trả lời
        function toggleReplyForm(commentId) {
            var form = document.getElementById('reply-form-' + commentId);
            
            // Nếu form đang mở -> đóng lại
            if (form.style.display === "block") {
                form.style.display = "none";
            } else {
                // Đóng tất cả form khác trước khi mở form này
                var allForms = document.querySelectorAll('.reply-form-container');
                allForms.forEach(function(el) {
                    el.style.display = 'none';
                });
                
                // Mở form hiện tại
                form.style.display = "block";
                form.querySelector('textarea').focus();
            }
        }
     // Hàm ẩn/hiện chat window (Đã sửa để ẩn tooltip khi mở chat)
        function toggleChat() {
            const win = document.getElementById('chat-window');
            const tooltip = document.getElementById('chatbot-tooltip');
            
            // Chuyển đổi trạng thái hiển thị
            win.style.display = (win.style.display === 'none' || win.style.display === '') ? 'flex' : 'none';
            
            // Ẩn/hiện tooltip
            tooltip.style.display = win.style.display === 'flex' ? 'none' : 'block';

            if (win.style.display === 'flex') {
                document.getElementById('user-input').focus();
            }
        }
        
        // Ẩn tooltip ban đầu sau 5 giây để không gây phiền
        setTimeout(() => {
            const tooltip = document.getElementById('chatbot-tooltip');
            if (tooltip && document.getElementById('chat-window').style.display !== 'flex') {
                tooltip.style.opacity = 0;
                setTimeout(() => tooltip.style.display = 'none', 300);
            }
        }, 5000);
        
        const WatchHistory = {
        	    // ... code cũ ...
        	    
        	    getProgress: function(videoId) {
        	        // Ưu tiên check biến global server trả về (User Login)
        	        if (window.serverWatchHistory && window.serverWatchHistory[videoId]) {
        	            // ✅ ĐÃ SỬA: Server trả về JSON key là 'watchTime'
        	            return window.serverWatchHistory[videoId].watchTime; 
        	        }
        	        // Check LocalStorage (Guest) -> Guest lưu JSON vẫn là 'currentTime' (hoặc bạn đổi luôn cũng được)
        	        const history = this.getGuestHistory();
        	        const item = history.find(i => i.videoId == videoId);
        	        // Guest dùng currentTime cho đồng bộ với HTML5 Video API
        	        return item ? item.currentTime : 0; 
        	    },
        	    
        	    // ...
        	}

        function sendMessage() {
            const input = document.getElementById('user-input');
            // Lấy tin nhắn và xóa khoảng trắng thừa
            const msg = input.value.trim();
            
            // Nếu rỗng thì không làm gì cả
            if (!msg) return;

            const contentDiv = document.getElementById('chat-content');

            // ---------------------------------------------------------
            // 1. HIỆN TIN NHẮN CỦA USER
            // ---------------------------------------------------------
            // Dùng \${msg} để JSP không hiểu lầm đây là biến server
            const userHtml = `
                <div class="mb-3 text-end">
                    <div style="background: #006837; color: white; padding: 10px; border-radius: 10px; display: inline-block; text-align: left; max-width: 80%; word-wrap: break-word;">
                        \${msg.replace(/</g, "&lt;").replace(/>/g, "&gt;")}
                    </div>
                </div>`;
            
            // insertAdjacentHTML giúp thêm vào cuối mà không render lại toàn bộ khung chat (nhanh hơn)
            contentDiv.insertAdjacentHTML('beforeend', userHtml);
            
            // Reset ô nhập và cuộn xuống
            input.value = '';
            contentDiv.scrollTop = contentDiv.scrollHeight;

            // ---------------------------------------------------------
            // 2. HIỆN HIỆU ỨNG "ĐANG TRA CỨU..."
            // ---------------------------------------------------------
            const loadingId = 'loading-' + Date.now();
            const loadingHtml = `
                <div class="mb-3" id="\${loadingId}">
                    <div style="background: #e9ecef; padding: 10px; border-radius: 10px; display: inline-block;">
                        <div class="spinner-grow spinner-grow-sm text-secondary" role="status"></div>
                        <span class="ms-2 small text-muted">Đang phân tích...</span>
                    </div>
                </div>`;
            
            contentDiv.insertAdjacentHTML('beforeend', loadingHtml);
            contentDiv.scrollTop = contentDiv.scrollHeight;

            // ---------------------------------------------------------
            // 3. GỌI AJAX LÊN SERVER
            // ---------------------------------------------------------
            fetch('${pageContext.request.contextPath}/explainer-bot', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                },
                body: 'message=' + encodeURIComponent(msg)
            })
            .then(response => response.text())
            .then(data => {
                // --- XỬ LÝ KẾT QUẢ ---

                // A. XÓA Loading NGAY LẬP TỨC
                const loadingEl = document.getElementById(loadingId);
                if (loadingEl) {
                    loadingEl.remove();
                }

                // B. Kiểm tra dữ liệu rỗng
                if (!data || data.trim() === "") {
                    data = "Hệ thống không phản hồi, vui lòng thử lại.";
                }

                // C. Hiển thị câu trả lời của Bot
                // Lưu ý: \${data} là biến JS chứa nội dung HTML từ Server (đã có <br>, <b>...)
                const botHtml = `
                    <div class="mb-3">
                        <div style="background: #e9ecef; color: #333; padding: 12px; border-radius: 10px; display: inline-block; max-width: 90%; line-height: 1.5;">
                            <i class="bi bi-stars text-warning me-1"></i> 
                            <span>\${data}</span>
                        </div>
                    </div>`;
                
                contentDiv.insertAdjacentHTML('beforeend', botHtml);
                
                // D. Cuộn xuống cuối cùng
                contentDiv.scrollTop = contentDiv.scrollHeight;
            })
            .catch(err => {
                console.error("Lỗi Fetch:", err);
                
                // Xóa loading nếu có lỗi
                const loadingEl = document.getElementById(loadingId);
                if (loadingEl) loadingEl.remove();
                
                // Hiện thông báo lỗi đẹp trong khung chat
                const errorHtml = `
                    <div class="mb-3">
                        <div style="background: #f8d7da; color: #721c24; padding: 10px; border-radius: 10px; display: inline-block;">
                            <i class="bi bi-exclamation-circle-fill me-1"></i> Lỗi kết nối: Không thể liên lạc với Server.
                        </div>
                    </div>`;
                contentDiv.insertAdjacentHTML('beforeend', errorHtml);
                contentDiv.scrollTop = contentDiv.scrollHeight;
            });
        }
        
        
        
        const productData = [
            <c:forEach var="p" items="${vProducts}" varStatus="status">
                {
                    name: "${p.productName}",
                    img: "${p.productImage}",
                    url: "${p.affiliateUrl}",
                    price: "${p.priceDisplay}",
                    start: ${p.startTime},
                    end: ${p.endTime}
                }${not status.last ? ',' : ''}
            </c:forEach>
        ];

        let ytPlayer;
        const vType = document.getElementById('videoType').value;

        // Khởi tạo YouTube API
        function onYouTubeIframeAPIReady() {
            if (vType === 'YOUTUBE') {
                ytPlayer = new YT.Player('ytPlayer', {
                    events: { 'onStateChange': (e) => { if(e.data == 1) setInterval(checkTime, 1000); } }
                });
            }
        }

        // Lắng nghe thẻ Video MP4
        if (vType === 'MP4') {
            document.getElementById('mainVideo').ontimeupdate = checkTime;
        }

        function checkTime() {
            let now = 0;
            if (vType === 'YOUTUBE' && ytPlayer && ytPlayer.getCurrentTime) {
                now = Math.floor(ytPlayer.getCurrentTime());
            } else {
                now = Math.floor(document.getElementById('mainVideo').currentTime);
            }

            const active = productData.find(p => now >= p.start && now <= p.end);
            const pop = document.getElementById('commerce-popup');
            
            if (active) {
                document.getElementById('pop-name').innerText = active.name;
                document.getElementById('pop-price').innerText = active.price;
                document.getElementById('pop-img').src = active.img;
                document.getElementById('pop-link').href = active.url;
                pop.style.display = 'block';
            } else {
                pop.style.display = 'none';
            }
        }
        
        
        function generateAIChapters() {
            const newsContent = document.querySelector('.news-description').innerText.trim();
            
            // Lấy thời lượng video thực tế (tính bằng giây)
            let duration = 0;
            const videoElement = document.getElementById('mainVideo');
            if (videoElement) {
                duration = Math.floor(videoElement.duration);
            } else if (typeof ytPlayer !== 'undefined' && ytPlayer.getDuration) {
                duration = Math.floor(ytPlayer.getDuration());
            }
            
            // Nếu chưa load được thời gian, để mặc định hoặc thông báo
            if (!duration || duration <= 0) duration = 64; 

            Swal.fire({
                title: 'Đang kết nối AI',
                html: `Hệ thống chia phân đoạn cho video dài ${duration}s...`,
                allowOutsideClick: false,
                didOpen: () => { Swal.showLoading(); }
            });

            fetch('${pageContext.request.contextPath}/explainer-bot', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                // Gửi thêm tham số duration ở đây
                body: 'message=' + encodeURIComponent("Tạo chapter cho nội dung này: " + newsContent) 
                      + '&duration=' + duration
            })
            .then(res => res.text())
            .then(data => {
                Swal.close();
                parseAndSuggestChapters(data);
            })
            .catch(err => {
                Swal.close();
                Swal.fire("Lỗi", "Không thể kết nối Server!", "error");
            });
        }

        function parseAndSuggestChapters(aiText) {
            const rawLines = aiText.split(/<br>|\n/);
            let htmlContent = '<div class="text-start mt-2"><div class="list-group shadow-sm">';
            let count = 0;

            rawLines.forEach(line => {
                let cleanLine = line.replace(/<\/?[^>]+(>|$)/g, "").replace(/^[•*\-\s]+/, "").trim();
                
                if (cleanLine.includes('|')) {
                    const parts = cleanLine.split('|');
                    const seconds = parts[0].trim();
                    const title = parts[1].trim();
                    
                    if (!isNaN(seconds) && seconds !== "") {
                        count++;
                        // ✅ SỬA LỖI: Thêm dấu \ trước tất cả các dấu $ 
                        // để JSP không can thiệp vào Template Literal của JavaScript
                        htmlContent += `
                            <button type="button" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center py-3" 
                                    onclick="applyToForm('\${seconds}', '\${title.replace(/'/g, "\\'")}')">
                                <div class="d-flex align-items-center">
                                    <span class="badge bg-success rounded-pill px-3 me-3">\${seconds}s</span>
                                    <span class="fw-bold text-dark" style="font-size: 14px;">\${title}</span>
                                </div>
                                <i class="bi bi-plus-circle text-primary fs-5"></i>
                            </button>`;
                    }
                }
            });

            htmlContent += '</div><p class="mt-3 small text-muted text-center italic">Nhấn vào một phân đoạn để điền nhanh vào Form bên dưới.</p></div>';

            if (count === 0) {
                Swal.fire("Thông báo", "AI trả về dữ liệu không đúng định dạng giây|tiêu đề.", "info");
            } else {
                Swal.fire({
                    title: 'Gợi ý phân đoạn từ AI',
                    html: htmlContent,
                    showConfirmButton: false,
                    showCloseButton: true,
                    width: '500px'
                });
            }
        }

        /**
         * Hàm điền nhanh dữ liệu vào Form quản trị
         * @param {string} seconds - Số giây của phân đoạn
         * @param {string} title - Tiêu đề của phân đoạn
         */
         /**
          * Chức năng 1: Nhảy giây video (Dành cho người xem)
          */
         function seekToChapter(seconds, isPremium) {
             const vType = document.getElementById('videoType').value;
             if (vType === 'YOUTUBE' && typeof ytPlayer !== 'undefined') {
                 ytPlayer.seekTo(seconds, true);
                 ytPlayer.playVideo();
             } else {
                 const mainVideo = document.getElementById('mainVideo');
                 if (mainVideo) {
                     mainVideo.currentTime = seconds;
                     mainVideo.play();
                 }
             }
         }

         /**
          * Chức năng 2: Điền nhanh vào Form (Dành cho quản lý)
          */
         function applyToForm(seconds, title) {
             const startInput = document.getElementById('startTimeInput'); 
             const nameInput = document.getElementById('productName');     

             if (startInput) {
                 startInput.value = seconds;
                 startInput.classList.add('is-valid'); 
                 setTimeout(() => startInput.classList.remove('is-valid'), 2000);
             }
             
             if (nameInput) {
                 nameInput.value = title;
                 nameInput.classList.add('is-valid');
                 setTimeout(() => nameInput.classList.remove('is-valid'), 2000);
             }

             Swal.fire({
                 toast: true,
                 position: 'top-end',
                 icon: 'success',
                 title: 'Đã lấy mốc: ' + seconds + 's',
                 showConfirmButton: false,
                 timer: 1500
             });
         }
         
         let isAudioMode = false;

         function toggleAudioMode() {
             isAudioMode = document.getElementById('audioModeToggle').checked;
             const videoContainer = document.getElementById('videoContainer');
             const audioUI = document.getElementById('audio-player-ui');
             const pulseRing = document.querySelector('.pulse-ring');

             if (isAudioMode) {
                 // 1. Tắt luồng hình ảnh (Dùng Filter để tiết kiệm render nhưng vẫn giữ âm thanh)
                 videoContainer.style.opacity = "0.05"; 
                 videoContainer.style.height = "1px"; // Thu nhỏ vùng nhìn
                 videoContainer.style.pointerEvents = "none";
                 
                 audioUI.style.display = "block";
                 pulseRing.style.display = "block";
                 
                 Swal.fire({
                     toast: true, position: 'top', icon: 'info',
                     title: 'Đã chuyển sang Audio Mode (Tiết kiệm 80% băng thông)',
                     showConfirmButton: false, timer: 3000
                 });
             } else {
                 // 2. Hiện lại Video
                 videoContainer.style.opacity = "1";
                 videoContainer.style.height = "450px";
                 videoContainer.style.pointerEvents = "auto";
                 audioUI.style.display = "none";
                 pulseRing.style.display = "none";
             }
         }

         // Điều khiển Play/Pause đồng bộ với Video gốc
         function togglePlayback() {
             const vType = document.getElementById('videoType').value;
             const playIcon = document.querySelector('#audioPlayBtn i');

             if (vType === 'YOUTUBE') {
                 if (ytPlayer.getPlayerState() === 1) {
                     ytPlayer.pauseVideo();
                     playIcon.className = "bi bi-play-circle-fill";
                 } else {
                     ytPlayer.playVideo();
                     playIcon.className = "bi bi-pause-circle-fill";
                 }
             } else {
                 const mv = document.getElementById('mainVideo');
                 if (mv.paused) {
                     mv.play();
                     playIcon.className = "bi bi-pause-circle-fill";
                 } else {
                     mv.pause();
                     playIcon.className = "bi bi-play-circle-fill";
                 }
             }
         }

         // Hàm cập nhật Progress Bar cho Audio
         function updateAudioProgress(current, total) {
             if (isAudioMode) {
                 const percent = (current / total) * 100;
                 document.getElementById('audioProgressBar').style.width = percent + "%";
             }
         }

         function showVipRequired() {
             Swal.fire({
                 title: 'Tính năng VIP',
                 text: 'Vui lòng nâng cấp tài khoản để sử dụng chế độ Audio Podcast chạy nền!',
                 icon: 'crown',
                 confirmButtonText: 'Nâng cấp ngay'
             });
         }
         // --- 1. BIẾN TOÀN CỤC ---
         let currentSkinBase = "${pageContext.request.contextPath}/assets/avatars/default_"; // Mặc định
         let isAvatarActive = true;
         let lastSentiment = "NEUTRAL";

         // --- 2. KHỞI TẠO KHI LOAD TRANG ---
         document.addEventListener("DOMContentLoaded", () => {
             // Kiểm tra xem người dùng có tắt avatar trước đó không
             if (localStorage.getItem('hideAvatar') === 'true') {
                 document.getElementById('news-avatar-wrapper').style.display = 'none';
             } else {
                 // Hiển thị ngay lập tức với trạng thái mặc định
                 document.getElementById('news-avatar-wrapper').style.display = 'flex';
                 
                 // (Nâng cao) Gọi API lấy skin thật của user nếu có
                 // fetchUserSkin(); 
             }
         });

         // --- 3. HÀM CẬP NHẬT CẢM XÚC (Gọi từ checkTime) ---
         function updateAvatarEmotion(sentiment, title) {
             if (sentiment === lastSentiment) return; 
             lastSentiment = sentiment;

             const imgEl = document.getElementById('avatar-img');
             const bubbleEl = document.getElementById('avatar-bubble');

             // Đổi ảnh dựa trên cảm xúc (HAPPY, SAD, SHOCK, NEUTRAL)
             // Lưu ý: Cần có file ảnh tương ứng trong thư mục assets/avatars/
             imgEl.src = currentSkinBase + sentiment + ".png";
             
             // Đổi lời thoại
             if(sentiment === 'HAPPY') bubbleEl.innerText = "Tin vui nè! 😍";
             else if(sentiment === 'SAD') bubbleEl.innerText = "Buồn quá... 😢";
             else if(sentiment === 'SHOCK') bubbleEl.innerText = "Bất ngờ chưa! 😱";
             else bubbleEl.innerText = "Xin chào! 👋"; 
         }

         // --- 4. CÁC HÀM ĐIỀU KHIỂN ---
         function toggleAvatarControls() {
             document.getElementById('avatar-controls').classList.toggle('active');
         }

         function toggleAvatarVisibility() {
             document.getElementById('news-avatar-wrapper').style.display = 'none';
             localStorage.setItem('hideAvatar', 'true'); // Lưu trạng thái tắt
             
             // Hiện nút bật lại (Cần thêm nút này vào giao diện)
             // document.getElementById('btnShowAvatar').style.display = 'block';
         }

         function openSkinShop() {
             var myModal = new bootstrap.Modal(document.getElementById('skinShopModal'));
             myModal.show();
         }

         function changeSkin(skinName) {
             // Cập nhật đường dẫn skin mới
             currentSkinBase = "${pageContext.request.contextPath}/assets/avatars/" + skinName;
             
             // Reset ảnh về trạng thái bình thường
             updateAvatarEmotion('NEUTRAL', '');
             
             // Đóng modal
             const modalEl = document.getElementById('skinShopModal');
             const modal = bootstrap.Modal.getInstance(modalEl);
             modal.hide();
             
             alert("Đã đổi giao diện thành công!");
         }
         
      // 1. LOG NGAY LẬP TỨC ĐỂ KIỂM TRA SCRIPT CÓ CHẠY KHÔNG
         console.log("%c🔥 SCRIPT START: Bắt đầu khởi tạo logic lưu lịch sử...", "color: yellow; font-size: 14px; background: red; padding: 4px;");

         // Lấy các biến từ JSP
         var videoId = ${video.id}; 
         var isUserLoggedIn = ${sessionScope.user != null};
         var videoTypeInput = document.getElementById('videoType');
         var videoType = videoTypeInput ? videoTypeInput.value : 'UNKNOWN';

         console.log("DEBUG INFO:", {
             videoId: videoId,
             isUserLoggedIn: isUserLoggedIn,
             videoType: videoType
         });

         // Hàm gửi API (Dùng chung)
         function saveWatchProgress(currentTime, duration) {
             if (!isUserLoggedIn) {
                 console.log(">> Khách vãng lai -> Bỏ qua lưu DB");
                 return;
             }

             console.log(">> Đang gửi API save... Time:", Math.floor(currentTime));

             const params = new URLSearchParams();
             params.append('videoId', videoId);
             params.append('currentTime', Math.floor(currentTime));
             params.append('duration', Math.floor(duration || 0));

             fetch('${pageContext.request.contextPath}/api/history-save', {
                 method: 'POST',
                 headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                 body: params,
                 keepalive: true
             })
             .then(res => {
                 if(res.ok) console.log(">> ✅ Server đã lưu thành công!");
                 else console.error(">> ❌ Server trả lỗi:", res.status);
             })
             .catch(err => console.error(">> ❌ Lỗi kết nối:", err));
         }

         // --- LOGIC YOUTUBE ---
         if (videoType === 'YOUTUBE') {
             var player;
             var saveInterval;

             // Hàm này được YouTube gọi tự động khi thư viện tải xong
             window.onYouTubeIframeAPIReady = function() {
                 console.log(">> YouTube API đã sẵn sàng. Đang kết nối vào iframe...");
                 player = new YT.Player('ytPlayer', {
                     events: {
                         'onReady': onPlayerReady,
                         'onStateChange': onPlayerStateChange
                     }
                 });
             };

             function onPlayerReady(event) {
                 console.log(">> YouTube Player đã kết nối thành công!");
             }

             function onPlayerStateChange(event) {
                 // 1 = PLAYING
                 if (event.data == YT.PlayerState.PLAYING) {
                     console.log(">> Video đang phát -> Bật chế độ lưu tự động");
                     if (!saveInterval) {
                         saveInterval = setInterval(function() {
                             if(player && player.getCurrentTime) {
                                 saveWatchProgress(player.getCurrentTime(), player.getDuration());
                             }
                         }, 5000); // Lưu mỗi 5s
                     }
                 } 
                 // 2 = PAUSED, 0 = ENDED
                 else if (event.data == YT.PlayerState.PAUSED || event.data == YT.PlayerState.ENDED) {
                     console.log(">> Video tạm dừng/kết thúc -> Lưu ngay lập tức");
                     if (saveInterval) {
                         clearInterval(saveInterval);
                         saveInterval = null;
                     }
                     if(player && player.getCurrentTime) {
                         saveWatchProgress(player.getCurrentTime(), player.getDuration());
                     }
                 }
             }
         } 
         // --- LOGIC MP4 (Video thường) ---
         else {
             var mainVideo = document.getElementById('mainVideo');
             if (mainVideo) {
                 console.log(">> Phát hiện Video MP4 -> Đang gắn sự kiện...");
                 var lastSave = 0;
                 
                 mainVideo.addEventListener('timeupdate', function() {
                     var now = Date.now();
                     if (now - lastSave > 5000) {
                         saveWatchProgress(mainVideo.currentTime, mainVideo.duration);
                         lastSave = now;
                     }
                 });

                 mainVideo.addEventListener('pause', function() {
                     console.log(">> MP4 Paused -> Lưu ngay");
                     saveWatchProgress(mainVideo.currentTime, mainVideo.duration);
                 });
             } else {
                 console.error(">> LỖI: Không tìm thấy thẻ video nào (cả YouTube lẫn MP4)");
             }
         }
    </script>
</body>
</html>