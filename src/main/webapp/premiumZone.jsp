<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    /* 1. HIỆU ỨNG GRADIENT ĐỘNG CHO HEADER */
    @keyframes animatedGradient {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
    }

    .premium-header-text {
        background: linear-gradient(-45deg, #bf953f, #fcf6ba, #b38728, #fbf5b7, #aa771c);
        background-size: 400% 400%;
        animation: animatedGradient 5s ease infinite;
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        font-weight: 900;
        letter-spacing: 1px;
        text-transform: uppercase;
    }

    /* 2. BỐ CỤC KHU VỰC PREMIUM */
    .premium-section-wrapper {
        background: radial-gradient(circle at top left, #2a2a2a, #121212);
        border-radius: 20px;
        padding: 40px;
        margin: 40px 0;
        position: relative;
        border: 1px solid rgba(191, 149, 63, 0.3);
        box-shadow: 0 20px 40px rgba(0,0,0,0.5);
    }

    /* 3. THẺ VIP CARD HIỆN ĐẠI */
    .vip-card {
        background: #1e1e1e;
        border-radius: 15px;
        overflow: hidden;
        transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        position: relative;
        height: 100%;
        border: 1px solid rgba(255,255,255,0.05);
        display: flex;
        flex-direction: column;
    }

    .vip-card:hover {
        transform: scale(1.05);
        box-shadow: 0 0 25px rgba(191, 149, 63, 0.4);
        border-color: rgba(191, 149, 63, 0.6);
        z-index: 10;
    }

    /* 4. BADGE PREMIUM VỚI HIỆU ỨNG ÁNH SÁNG QUÉT (SHINE) */
    .vip-badge {
        position: absolute;
        top: 12px;
        left: 12px;
        background: linear-gradient(45deg, #bf953f, #fcf6ba);
        color: #000;
        font-weight: 800;
        font-size: 11px;
        padding: 5px 12px;
        border-radius: 50px;
        z-index: 5;
        box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        overflow: hidden;
    }

    .vip-badge::after {
        content: '';
        position: absolute;
        top: -50%;
        left: -50%;
        width: 200%;
        height: 200%;
        background: rgba(255,255,255,0.4);
        transform: rotate(45deg);
        transition: 0.5s;
        animation: shineEffect 3s infinite;
    }

    @keyframes shineEffect {
        0% { left: -100%; }
        20% { left: 100%; }
        100% { left: 100%; }
    }

    /* 5. POSTER VÀ OVERLAY TÒ MÒ */
    .poster-wrapper {
        position: relative;
        padding-top: 56.25%;
        overflow: hidden;
    }

    .poster-img {
        position: absolute;
        top: 0; left: 0; width: 100%; height: 100%;
        object-fit: cover;
        transition: transform 0.6s ease, filter 0.6s ease;
    }

    .vip-card:hover .poster-img {
        transform: scale(1.15);
    }

    /* Blur poster cho người chưa có VIP */
    .locked-poster {
        filter: blur(8px) grayscale(0.5);
    }

    .locked-overlay {
        position: absolute; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0,0,0,0.6);
        display: flex; flex-direction: column;
        align-items: center; justify-content: center;
        color: #fcf6ba;
        transition: all 0.3s ease;
        z-index: 3;
    }

    .locked-overlay i {
        font-size: 2.5rem;
        text-shadow: 0 0 15px rgba(252, 246, 186, 0.8);
        margin-bottom: 10px;
        animation: pulseLock 2s infinite;
    }

    @keyframes pulseLock {
        0% { transform: scale(1); opacity: 0.8; }
        50% { transform: scale(1.1); opacity: 1; }
        100% { transform: scale(1); opacity: 0.8; }
    }

    .locked-text {
        font-size: 12px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    /* 6. TYPOGRAPHY */
    .vip-title {
        color: #fff;
        font-size: 16px;
        font-weight: 700;
        text-decoration: none;
        display: block;
        padding: 15px;
        transition: color 0.3s ease;
        flex-grow: 1;
    }

    .vip-card:hover .vip-title {
        color: #fcf6ba;
        text-shadow: 0 0 5px rgba(191, 149, 63, 0.5);
    }

    /* 7. NÚT NÂNG CẤP PULSATING */
    .btn-upgrade-vip {
        background: linear-gradient(45deg, #bf953f, #aa771c);
        border: none;
        color: black !important;
        animation: pulseButton 2s infinite;
        box-shadow: 0 0 15px rgba(191, 149, 63, 0.5);
        transition: all 0.3s ease;
    }

    @keyframes pulseButton {
        0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(191, 149, 63, 0.7); }
        70% { transform: scale(1.05); box-shadow: 0 0 0 10px rgba(191, 149, 63, 0); }
        100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(191, 149, 63, 0); }
    }

    /* 8. RESPONSIVE CAROUSEL CHO MOBILE */
    @media (max-width: 768px) {
        .premium-row {
            display: flex;
            overflow-x: auto;
            scroll-snap-type: x mandatory;
            gap: 15px;
            padding-bottom: 20px;
        }
        .premium-col {
            flex: 0 0 75%;
            scroll-snap-align: start;
        }
        .premium-section-wrapper { padding: 20px; }
    }
</style>

<div class="premium-section-wrapper">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="premium-header-text mb-1"><i class="bi bi-diamond-fill me-2"></i>DANTRI PREMIUM</h2>
            <p class="text-white-50 mb-0 small"><i class="bi bi-stars"></i> Mở khóa kho kiến thức và đặc quyền vô tận</p>
        </div>
        <c:if test="${!isVip}">
            <a href="${pageContext.request.contextPath}/upgradeVip.jsp" class="btn btn-upgrade-vip btn-sm fw-bold rounded-pill px-4 py-2">
                <i class="bi bi-crown-fill me-2"></i>NÂNG CẤP VIP
            </a>
        </c:if>
    </div>

    <div class="row g-4 premium-row">
        <c:forEach var="v" items="${vipVideos}">
            <div class="col-6 col-md-3 premium-col">
                <div class="vip-card h-100">
                    <div class="vip-badge">PREMIUM</div>
                    
                    <div class="poster-wrapper">
                        <img src="${v.poster}" 
                             class="poster-img ${!isVip ? 'locked-poster' : ''}" 
                             loading="lazy"
                             alt="${v.title}">
                        
                        <c:if test="${!isVip}">
                            <div class="locked-overlay">
                                <i class="bi bi-lock-fill"></i>
                                <span class="locked-text">Nội dung bí mật</span>
                            </div>
                        </c:if>
                    </div>
                    
                    <a href="${isVip ? pageContext.request.contextPath.concat('/postdetail?id=').concat(String.valueOf(v.id)) : pageContext.request.contextPath.concat('/upgradeVip.jsp')}" 
                       class="vip-title" 
                       title="${v.desc}"
                        id="Vipupdate">
                        <div class="text-truncate-2">${v.title}</div>
                    </a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    // Khởi tạo Bootstrap Tooltip nếu bạn dùng Bootstrap 5
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl)
    })
</script>