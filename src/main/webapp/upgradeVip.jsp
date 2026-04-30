<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">

<style>
    :root {
        --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --gold-gradient: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
        --card-bg: #ffffff;
        --text-dark: #1e293b;
        --text-light: #64748b;
    }

    body {
        font-family: 'Plus Jakarta Sans', sans-serif;
        background-color: #f8fafc; /* Màu nền xám xanh nhạt hiện đại */
    }

    /* Header Section */
    .vip-header {
        text-align: center;
        margin-bottom: 3rem;
        position: relative;
    }

    .vip-badge {
        background: var(--gold-gradient);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        font-weight: 900;
        text-transform: uppercase;
        letter-spacing: 2px;
    }

    /* Pricing Cards Container */
    .pricing-container {
        display: flex;
        justify-content: center;
        gap: 2rem;
        flex-wrap: wrap;
        align-items: center; /* Để căn giữa gói nổi bật */
    }

    /* Card Base Style */
    .pricing-card {
        background: var(--card-bg);
        border-radius: 24px;
        padding: 2.5rem;
        width: 350px;
        position: relative;
        transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        border: 1px solid rgba(0,0,0,0.05);
        box-shadow: 0 10px 30px -10px rgba(0,0,0,0.05);
    }

    .pricing-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 20px 40px -10px rgba(0,0,0,0.1);
    }

    /* Featured Card (Gói 1 năm) */
    .pricing-card.popular {
        border: 2px solid #fda085;
        transform: scale(1.05); /* To hơn một chút */
        box-shadow: 0 20px 50px -10px rgba(253, 160, 133, 0.3);
        z-index: 10;
    }

    .pricing-card.popular:hover {
        transform: scale(1.05) translateY(-10px);
    }

    /* Ribbon "Khuyên dùng" */
    .popular-tag {
        position: absolute;
        top: -15px;
        left: 50%;
        transform: translateX(-50%);
        background: var(--gold-gradient);
        color: #fff;
        padding: 8px 20px;
        border-radius: 50px;
        font-weight: 700;
        font-size: 0.85rem;
        box-shadow: 0 5px 15px rgba(253, 160, 133, 0.4);
    }

    /* Typography inside Card */
    .plan-name {
        font-size: 1.1rem;
        font-weight: 600;
        color: var(--text-light);
        margin-bottom: 0.5rem;
    }

    .plan-price {
        font-size: 2.5rem;
        font-weight: 800;
        color: var(--text-dark);
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .plan-price span {
        font-size: 1rem;
        font-weight: 500;
        color: var(--text-light);
    }

    .plan-discount {
        background-color: #dcfce7;
        color: #166534;
        font-size: 0.8rem;
        font-weight: 700;
        padding: 4px 10px;
        border-radius: 6px;
        display: inline-block;
        margin-bottom: 1.5rem;
    }

    /* Feature List */
    .feature-list {
        list-style: none;
        padding: 0;
        margin: 2rem 0;
        text-align: left;
    }

    .feature-list li {
        margin-bottom: 1rem;
        display: flex;
        align-items: center;
        color: var(--text-dark);
        font-size: 0.95rem;
    }

    .feature-list li i {
        color: #10b981; /* Màu xanh lá checkmark */
        margin-right: 12px;
        font-size: 1.2rem;
    }

    .feature-list li.disabled {
        color: #cbd5e1;
        text-decoration: line-through;
    }
    
    .feature-list li.disabled i {
        color: #cbd5e1;
    }

    /* Buttons */
    .btn-plan {
        display: block;
        width: 100%;
        padding: 14px;
        border-radius: 12px;
        font-weight: 700;
        text-align: center;
        text-decoration: none;
        transition: all 0.3s ease;
    }

    .btn-outline {
        border: 2px solid #e2e8f0;
        color: var(--text-dark);
        background: transparent;
    }

    .btn-outline:hover {
        border-color: #667eea;
        color: #667eea;
        background: #f8fafc;
    }

    .btn-gradient {
        background: var(--gold-gradient);
        color: #fff;
        border: none;
        box-shadow: 0 10px 20px -5px rgba(253, 160, 133, 0.4);
    }

    .btn-gradient:hover {
        filter: brightness(1.1);
        transform: translateY(-2px);
        color: #fff;
    }

    /* Footer Trust */
    .trust-section {
        margin-top: 3rem;
        text-align: center;
        color: var(--text-light);
        font-size: 0.9rem;
    }
    
    .trust-icons img {
        height: 30px;
        margin: 0 10px;
        opacity: 0.7;
        filter: grayscale(100%);
        transition: all 0.3s;
    }
    
    .trust-icons img:hover {
        filter: grayscale(0%);
        opacity: 1;
    }
</style>

<div class="container py-5">
    <div class="vip-header">
        <h5 class="text-uppercase text-muted fw-bold mb-2">Membership</h5>
        <h1 class="display-5 fw-bold mb-3">Nâng cấp <span class="vip-badge">V.I.P Member</span></h1>
        <p class="text-muted fs-5">Mở khóa toàn bộ kho nội dung Premium và trải nghiệm không quảng cáo.</p>
    </div>

    <div class="pricing-container">
        
        <div class="pricing-card">
            <div class="plan-name">Trải nghiệm</div>
            <div class="plan-price">50.000đ <span>/tháng</span></div>
            <p class="text-muted small mt-2 mb-4">Dành cho người mới bắt đầu.</p>
            
            <a href="${pageContext.request.contextPath}/payment/create?amount=50000" class="btn-plan btn-outline">
                Đăng ký Gói Tháng
            </a>

            <ul class="feature-list">
                <li><i class="bi bi-check-circle-fill"></i> Truy cập video Premium</li>
                <li><i class="bi bi-check-circle-fill"></i> Loại bỏ 100% quảng cáo</li>
                <li><i class="bi bi-check-circle-fill"></i> Chất lượng Full HD 1080p</li>
                <li class="disabled"><i class="bi bi-x-circle-fill"></i> Huy hiệu VIP Vàng</li>
                <li class="disabled"><i class="bi bi-x-circle-fill"></i> Tiết kiệm chi phí</li>
            </ul>
        </div>

        <div class="pricing-card popular">
            <div class="popular-tag">
                <i class="bi bi-star-fill me-1"></i> KHUYÊN DÙNG
            </div>
            <div class="plan-name">Chuyên nghiệp</div>
            <div class="plan-price">500.000đ <span>/năm</span></div>
            <div class="plan-discount">
                <i class="bi bi-lightning-charge-fill"></i> Tiết kiệm 17% (100k)
            </div>

            <a href="${pageContext.request.contextPath}/payment/create?amount=500000" name="500k" class="btn-plan btn-gradient">
                Nâng cấp VIP ngay
            </a>

            <ul class="feature-list">
                <li><i class="bi bi-check-circle-fill"></i> <strong>Tất cả quyền lợi gói Tháng</strong></li>
                <li><i class="bi bi-check-circle-fill"></i> Huy hiệu <span class="text-warning fw-bold">VIP Gold</span> nổi bật</li>
                <li><i class="bi bi-check-circle-fill"></i> Chất lượng <strong>4K Ultra HD</strong></li>
                <li><i class="bi bi-check-circle-fill"></i> Ưu tiên hỗ trợ 24/7</li>
                <li><i class="bi bi-check-circle-fill"></i> Tham gia sự kiện độc quyền</li>
            </ul>
        </div>

    </div>

    <div class="trust-section">
        <p class="mb-3"><i class="bi bi-shield-lock-fill text-success"></i> Thanh toán bảo mật 100% qua cổng VNPay</p>
        <div class="trust-icons d-flex justify-content-center align-items-center">
            <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-VNPAY-QR-1.png" alt="VNPay">
            <img src="https://upload.wikimedia.org/wikipedia/commons/2/25/Visa_Inc._logo.svg" alt="Visa">
            <img src="https://upload.wikimedia.org/wikipedia/commons/b/b7/MasterCard_Logo.svg" alt="Mastercard">
            <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Logo_Vietcombank.svg/2560px-Logo_Vietcombank.svg.png" alt="Vietcombank">
        </div>
        <p class="mt-4 small text-muted">
            Cần hỗ trợ? Gọi ngay <a href="#" class="text-decoration-none fw-bold">1900 xxxx</a> hoặc gửi email về support@dantri.com
        </p>
    </div>
</div>