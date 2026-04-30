<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
   <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
   
    <%@ page import="Services.RevenueService" %> <%-- Nhớ import Service --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
     <!-- ✅ Bootstrap 5 CSS (qua CDN) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" 
          rel="stylesheet">
 <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- ✅ Optional: Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
</head>
<style>
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
        
        :root {
            --dantri-green: #006837; 
        }
        
        /* Card chứa form */
    .editor-card {
        background: #ffffff;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        padding: 30px;
        border: 1px solid rgba(0,0,0,0.05);
    }

    .editor-title {
        font-weight: 800;
        text-transform: uppercase;
        letter-spacing: 1px;
        /* Gradient Text */
        background: linear-gradient(90deg, #006837 0%, #34d399 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        margin-bottom: 1.5rem;
    }

    /* Input focus effect */
    .form-control:focus, .form-select:focus {
        border-color: #34d399;
        box-shadow: 0 0 0 0.25rem rgba(52, 211, 153, 0.25);
    }

    /* Gradient Button - Shine Effect */
    .btn-gradient {
        background: linear-gradient(45deg, #006837, #10b981);
        border: none;
        color: white;
        position: relative;
        overflow: hidden;
        transition: all 0.3s ease;
        font-weight: 600;
        letter-spacing: 0.5px;
        border-radius: 8px;
        padding: 10px 30px;
    }

    .btn-gradient:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(16, 185, 129, 0.4);
    }

    /* Hiệu ứng vệt sáng lướt qua */
    .btn-gradient::after {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        transition: 0.5s;
    }

    .btn-gradient:hover::after {
        left: 100%;
    }
    
    /* Video Card Item */
    .video-item-card {
        border: none;
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        height: 100%;
        background: #fff;
    }

    .video-item-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0, 104, 55, 0.15);
    }

    .video-thumb-wrapper {
        position: relative;
        padding-top: 56.25%; /* 16:9 Aspect Ratio */
        overflow: hidden;
    }

    .video-thumb-wrapper img {
        position: absolute;
        top: 0; left: 0;
        width: 100%; height: 100%;
        object-fit: cover;
        transition: transform 0.5s ease;
    }

    .video-item-card:hover .video-thumb-wrapper img {
        transform: scale(1.1);
    }


/* --- Style cho Card bài viết trẻ trung --- */
.card-hover-effect {
    text-decoration: none; /* Bỏ gạch chân link */
    color: inherit; /* Giữ màu chữ gốc */
    display: block;
    height: 100%;
    transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
}

.card-hover-effect .card {
    border: none;
    border-radius: 16px; /* Bo góc tròn trịa hơn */
    background: #fff;
    box-shadow: 0 4px 15px rgba(0,0,0,0.03);
    overflow: hidden;
    height: 100%;
    transition: all 0.3s ease;
}

/* Hiệu ứng khi di chuột vào card */
.card-hover-effect:hover .card {
    transform: translateY(-5px); /* Nổi lên */
    box-shadow: 0 12px 30px rgba(0, 104, 55, 0.15); /* Đổ bóng xanh nhẹ */
}

/* Xử lý ảnh */
.card-img-wrapper {
    position: relative;
    padding-top: 56.25%; /* Tỷ lệ 16:9 */
    overflow: hidden;
}

.card-img-wrapper img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.card-hover-effect:hover .card-img-wrapper img {
    transform: scale(1.05); /* Phóng to ảnh nhẹ khi hover */
}

/* Icon Play phủ lên ảnh (Optional - tạo cảm giác video) */
.play-overlay {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%) scale(0.8);
    width: 40px;
    height: 40px;
    background: rgba(255,255,255,0.9);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--dantri-green);
    opacity: 0;
    transition: all 0.3s ease;
}

.card-hover-effect:hover .play-overlay {
    opacity: 1;
    transform: translate(-50%, -50%) scale(1);
}

/* --- FAVORITE CARD MODERN STYLE --- */
.fav-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 24px;
}

.fav-card {
    position: relative;
    background: #fff;
    border-radius: 20px;
    overflow: hidden;
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    border: 1px solid rgba(0,0,0,0.03);
    height: 100%;
}

.fav-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 15px 35px rgba(0, 104, 55, 0.15); /* Bóng đổ xanh nhẹ */
}

/* Phần ảnh bìa */
.fav-img-wrapper {
    position: relative;
    width: 100%;
    padding-top: 60%; /* Tỷ lệ khung hình đẹp */
    overflow: hidden;
}

.fav-img-wrapper img {
    position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    object-fit: cover;
    transition: transform 0.6s ease;
}

.fav-card:hover .fav-img-wrapper img {
    transform: scale(1.1); /* Zoom ảnh nhẹ */
}

/* Lớp phủ đen mờ & Nút Play */
.fav-overlay {
    position: absolute;
    inset: 0;
    background: rgba(0,0,0,0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: all 0.3s ease;
    backdrop-filter: blur(2px);
}

.fav-card:hover .fav-overlay {
    opacity: 1;
}

.btn-play-pulse {
    width: 50px; height: 50px;
    background: white;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--dantri-green, #006837);
    font-size: 24px;
    box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.7);
    animation: pulse-white 2s infinite;
}

@keyframes pulse-white {
    0% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.7); }
    70% { box-shadow: 0 0 0 15px rgba(255, 255, 255, 0); }
    100% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0); }
}

/* Nút Xóa yêu thích (Trái tim vỡ) */
.btn-unlike {
    position: absolute;
    top: 10px; right: 10px;
    width: 35px; height: 35px;
    background: rgba(255,255,255,0.9);
    border-radius: 10px;
    border: none;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #ef4444; /* Đỏ */
    z-index: 10;
    cursor: pointer;
    transition: all 0.2s;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}

.btn-unlike:hover {
    background: #ef4444;
    color: white;
    transform: scale(1.1);
}

/* Nội dung card */
.fav-body {
    padding: 18px;
}

.fav-title {
    font-size: 16px;
    font-weight: 700;
    color: #1f2937;
    margin-bottom: 8px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    line-height: 1.4;
}

.fav-desc {
    font-size: 13px;
    color: #6b7280;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    margin-bottom: 0;
}

.fav-meta {
    margin-top: 12px;
    padding-top: 12px;
    border-top: 1px solid #f3f4f6;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 12px;
    color: #9ca3af;
    font-weight: 500;
}

/* Empty State */
.empty-state-box {
    text-align: center;
    padding: 60px 20px;
    background: #f9fafb;
    border-radius: 20px;
    border: 2px dashed #e5e7eb;
}

/* Typography */
.card-title-custom {
    font-size: 1rem;
    font-weight: 700;
    line-height: 1.4;
    margin-bottom: 0.5rem;
    display: -webkit-box;
    -webkit-line-clamp: 2; /* Giới hạn 2 dòng */
    -webkit-box-orient: vertical;
    overflow: hidden;
    color: #333;
}

.card-desc-custom {
    font-size: 0.85rem;
    color: #6c757d;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    margin-bottom: 0.5rem;
}

.card-meta-custom {
    font-size: 0.75rem;
    color: #999;
    font-weight: 500;
}
    .status-badge {
        position: absolute;
        top: 10px;
        right: 10px;
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 700;
        color: white;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        z-index: 2;
    }

    .status-pending { background: #f59e0b; } /* Vàng - Chờ duyệt */
    .status-approved { background: #10b981; } /* Xanh - Đã duyệt */
    .status-rejected { background: #ef4444; } /* Đỏ - Từ chối */

    .card-actions .btn {
        border-radius: 8px;
        padding: 6px 12px;
    }

    .btn-refresh {
        background: #f3f4f6;
        color: #4b5563;
        border: 1px solid #e5e7eb;
        font-weight: 600;
        border-radius: 8px;
        padding: 10px 30px;
        transition: all 0.2s;
    }
    .btn-refresh:hover {
        background: #e5e7eb;
        color: #1f2937;
    }

        .navbar-nav .nav-link {
            font-weight: 500;
            color: #333 !important;
            margin: 0 10px;
            position: relative;
            transition: all 0.3s ease;
        }

        /* Hiệu ứng hover */
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

        /* Thanh menu danh mục */
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
         .post-form {
      background: #fff;
      padding: 30px;
      border-radius: 15px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
      margin-top: 40px;
    }
    .form-label {
      font-weight: 600;
    }
    .form-control:focus, .form-select:focus {
      border-color: forestgreen;
      box-shadow: 0 0 5px forestgreen;
    }
    button {
      transition: all 0.3s ease;
    }
    button:hover {
      transform: translateY(-2px);
    }
    .card {
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .post-form {
      background: #fff;
      padding: 25px;
      border-radius: 15px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }
    /* Màu nền và chữ khi hover */
.nav-pills .nav-link:hover {
  background-color: #d4edda !important; /* xanh lá nhạt */
  color: forestgreen !important; /* chữ xanh lá đậm */
  transition: 0.3s;
}

/* Màu khi được chọn (active) */
.nav-pills .nav-link.active {
  background-color: forestgreen !important; /* xanh lá đậm */
  color: #fff !important;
  font-weight: 600;
  box-shadow: 0 2px 6px rgba(0,0,0,0.15);
}

/* Màu chữ mặc định */
.nav-pills .nav-link {
  color: #333;
  border-radius: 8px;
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
        
        .search-bar input {
    border-radius: 20px;
    padding: 8px 15px;
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

/* Stats Box Styles */
.stats-container {
    background: #fff;
    border-radius: 12px;
    padding: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.03);
    border: 1px solid rgba(0,0,0,0.04);
}

.stat-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 12px 10px;
    margin-bottom: 8px;
    border-radius: 10px;
    transition: all 0.2s;
    background: #f8f9fa;
    border-left: 4px solid transparent;
}

.stat-row:hover {
    background: #fff;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    transform: translateX(5px);
}

.stat-info {
    display: flex;
    align-items: center;
    gap: 12px;
}

.stat-icon {
    width: 36px;
    height: 36px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
}

.stat-label {
    font-weight: 600;
    font-size: 14px;
    color: #4b5563;
}

.stat-value {
    font-weight: 800;
    font-size: 16px;
}

/* Color variations */
.stat-total { border-color: #6366f1; }
.stat-total .stat-icon { background: #eef2ff; color: #6366f1; }
.stat-total .stat-value { color: #6366f1; }

.stat-approved { border-color: #10b981; }
.stat-approved .stat-icon { background: #d1fae5; color: #10b981; }
.stat-approved .stat-value { color: #10b981; }

.stat-pending { border-color: #f59e0b; }
.stat-pending .stat-icon { background: #fef3c7; color: #f59e0b; }
.stat-pending .stat-value { color: #f59e0b; }

.stat-rejected { border-color: #ef4444; }
.stat-rejected .stat-icon { background: #fee2e2; color: #ef4444; }
.stat-rejected .stat-value { color: #ef4444; }
.news-description {
  word-break: break-word;
  overflow-wrap: break-word;
  white-space: normal;
}
</style>

<body>


    
<jsp:include page="/navbar.jsp"/>

<br>

<main class="container mt-4">
  <div class="row">
    <!-- Sidebar -->
    <div class="col-md-3">
      <div class="card p-3 shadow-sm">
        <h5 class="fw-bold">
          <i class="bi bi-person-circle"></i>
          <span class="text-success">Nguyễn Lê Minh</span>
        </h5>

       <div class="stats-container my-3">
    <div class="stat-row stat-total">
        <div class="stat-info">
            <div class="stat-icon"><i class="bi bi-collection-play-fill"></i></div>
            <span class="stat-label">Tổng bài viết</span>
        </div>
        <span class="stat-value">${stats.total}</span>
    </div>

    <div class="stat-row stat-approved">
        <div class="stat-info">
            <div class="stat-icon"><i class="bi bi-check-circle-fill"></i></div>
            <span class="stat-label">Đã được duyệt</span>
        </div>
        <span class="stat-value">${stats.approved}</span>
    </div>

    <div class="stat-row stat-pending">
        <div class="stat-info">
            <div class="stat-icon"><i class="bi bi-hourglass-split"></i></div>
            <span class="stat-label">Đang chờ duyệt</span>
        </div>
        <span class="stat-value">${stats.pending}</span>
    </div>
    
     <c:if test="${stats.rejected > 0}">
        <div class="stat-row stat-rejected">
            <div class="stat-info">
                <div class="stat-icon"><i class="bi bi-x-circle-fill"></i></div>
                <span class="stat-label">Bị từ chối/Ẩn</span>
            </div>
            <span class="stat-value">${stats.rejected}</span>
        </div>
    </c:if>
    <hr/>
 <%
    // 1. Lấy object totalViews từ Controller
    Object viewObj = request.getAttribute("totalViews");
    
    // 2. Chuyển đổi an toàn số lượt xem
    long totalViews = 0;
    String debugMsg = ""; 

    if (viewObj != null) {
        try {
            totalViews = Long.parseLong(String.valueOf(viewObj));
            debugMsg = "Views: " + totalViews;
        } catch (Exception e) {
            totalViews = 0;
            debugMsg = "Lỗi parse views: " + e.getMessage();
        }
    } else {
        debugMsg = "Chưa có attribute totalViews";
    }

    // 3. Lấy ĐƠN GIÁ từ Database (Thay vì fix cứng * 10)
    int viewRate = RevenueService.getViewRate(); // Gọi Service lấy từ bảng SystemConfig

    // 4. Tính tiền: Tổng View * Đơn giá DB
    long estimatedEarnings = totalViews * viewRate; 
    
    // 5. Format tiền tệ
    java.text.NumberFormat currencyFormat = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
    String formattedMoney = currencyFormat.format(estimatedEarnings);
%>

<div class="card bg-success text-white mb-2 shadow-sm border-0">
    <div class="card-body">
        <h5 class="card-title fw-bold"><i class="bi bi-cash-coin me-2"></i>Thu nhập ước tính</h5>
        <h2 class="fw-bold my-2"><%= formattedMoney %> VNĐ</h2>
        <p class="small mb-0 opacity-75">
            Được tính dựa trên <strong><%= totalViews %></strong> lượt xem tích lũy.
        </p>
        
    </div>
    
</div>
<br>
<button class="btn btn-outline-success mb-3" data-bs-toggle="modal" data-bs-target="#bankInfoModal">
    <i class="bi bi-credit-card-2-front-fill me-2"></i>Cài đặt tài khoản nhận tiền
</button>

<div class="modal fade" id="bankInfoModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title fw-bold">Thông tin nhận nhuận bút</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            
            <form action="${pageContext.request.contextPath}/editor/updateBank" method="post">
                <div class="modal-body">
                    <div class="alert alert-info small">
                        <i class="bi bi-info-circle-fill me-2"></i>
                        Thông tin này sẽ được dùng để Admin chuyển khoản lương cho bạn. Vui lòng nhập chính xác.
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">Ngân hàng</label>
                        <select class="form-select" name="bankName" required>
                            <option value="" disabled selected>-- Chọn ngân hàng --</option>
                            <option value="MB" ${sessionScope.user.bankName == 'MB' ? 'selected' : ''}>MB Bank</option>
                            <option value="VCB" ${sessionScope.user.bankName == 'VCB' ? 'selected' : ''}>Vietcombank</option>
                            <option value="TCB" ${sessionScope.user.bankName == 'TCB' ? 'selected' : ''}>Techcombank</option>
                            <option value="ACB" ${sessionScope.user.bankName == 'ACB' ? 'selected' : ''}>ACB</option>
                            <option value="VPB" ${sessionScope.user.bankName == 'VPB' ? 'selected' : ''}>VPBank</option>
                            <option value="TPB" ${sessionScope.user.bankName == 'TPB' ? 'selected' : ''}>TPBank</option>
                            <option value="BIDV" ${sessionScope.user.bankName == 'BIDV' ? 'selected' : ''}>BIDV</option>
                            <option value="CTG" ${sessionScope.user.bankName == 'CTG' ? 'selected' : ''}>VietinBank</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">Số tài khoản</label>
                        <input type="text" class="form-control" name="bankAccount" 
                               value="${sessionScope.user.bankAccount}" 
                               placeholder="Ví dụ: 0987654321" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">Tên chủ tài khoản (Không dấu)</label>
                        <input type="text" class="form-control text-uppercase" name="bankAccountName" 
                               value="${sessionScope.user.bankAccountName}" 
                               placeholder="NGUYEN VAN A" required>
                    </div>
                </div>
                
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-success fw-bold">
                        <i class="bi bi-save me-2"></i>Lưu thông tin
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

</div>

        <hr>
        <p class="fw-bold ps-2 mb-2">Quản lý tin đăng</p>
        <div class="nav flex-column nav-pills" id="v-pills-tab" role="tablist">
          <button class="nav-link active text-start" id="v-pills-home-tab" data-bs-toggle="pill"
            data-bs-target="#v-pills-home" type="button" role="tab">&gt; Đăng tin mới</button>
          <button class="nav-link text-start" id="v-pills-profile-tab" data-bs-toggle="pill"
            data-bs-target="#v-pills-profile" type="button" role="tab">&gt; Danh sách tin</button>
            <hr>
                    <p class="fw-bold ps-2 mb-2">Tin đã tương tác</p>

          <button class="nav-link text-start" id="v-pills-disabled-tab" data-bs-toggle="pill"
            data-bs-target="#v-pills-disabled" type="button" role="tab">&gt; Tin đã lưu</button>
          <button class="nav-link text-start" id="v-pills-messages-tab" data-bs-toggle="pill"
            data-bs-target="#v-pills-messages" type="button" role="tab">&gt; Tin đã xem</button>
        </div>
      </div>
    </div>

    <!-- Main content -->
    <div class="col-md-9">
        <div class="tab-content" id="v-pills-tabContent">
          <div class="tab-pane fade show active" id="v-pills-home" role="tabpanel">
      <div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            
            <div class="editor-card">
                <h4 class="editor-title">
                    <i class="bi bi-pencil-square me-2" style="-webkit-text-fill-color: #006837;"></i>
                    Đăng tin tức mới
                </h4>

                <%-- Hiển thị thông báo (nếu có) --%>
                <c:if test="${not empty success}">
                    <div class="alert alert-success d-flex align-items-center" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        <div>${success}</div>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <div>${error}</div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/editor/workspace" method="post" enctype="multipart/form-data">
                    
                    <div class="row mb-4">
                        <div class="col-md-7">
                            <label for="tieuDe" class="form-label fw-bold text-secondary small">TIÊU ĐỀ BÀI VIẾT (*)</label>
                            <input type="text" class="form-control" id="tieuDe" name="tieuDe"
                                   value="${bean.tieuDe}" placeholder="Nhập tiêu đề hấp dẫn...">
                            <small class="text-danger fst-italic">${bean.errors.errTieuDe}</small>
                        </div>

                        <div class="col-md-5">
                            <label class="form-label fw-bold text-secondary small">DANH MỤC (*)</label>
                            <select name="category" class="form-select">
                                <option value="0">-- Chọn danh mục --</option>
                                <c:forEach items="${categories}" var="item">
                                    <option value="${item.id}" ${bean.category == item.id ? "selected" : ""}>
                                        ${item.name}
                                    </option>
                                </c:forEach>
                            </select>
                            <small class="text-danger fst-italic">${bean.errors.errCategory}</small>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="noiDung" class="form-label fw-bold text-secondary small">NỘI DUNG CHI TIẾT (*)</label>
                        <textarea class="form-control" id="noiDung" name="noiDung" rows="6"
                                  placeholder="Viết nội dung bài báo tại đây...">${bean.noiDung}</textarea>
                        <small class="text-danger fst-italic">${bean.errors.errNoiDung}</small>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-6">
                            <label for="anhBaiDang" class="form-label fw-bold text-secondary small">ẢNH BÌA (Poster)</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-image"></i></span>
                                <input type="file" class="form-control" id="anhBaiDang" name="anhBaiDang" accept="image/*">
                            </div>
                            <small class="text-danger fst-italic">${bean.errors.errAnh}</small>
                        </div>

                        <div class="col-md-6">
                            <label for="videoBaiDang" class="form-label fw-bold text-secondary small">LINK VIDEO</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-link-45deg"></i></span>
                                <input type="text" class="form-control" id="videoBaiDang" 
                                       name="videoBaiDang" value="${bean.videoBaiDang}"
                                       placeholder="VD: https://youtube.com/...">
                            </div>
                            <small class="text-danger fst-italic">${bean.errors.errVideo}</small>
                        </div>
                    </div>
                    
                    <div class="form-check mb-3">
    <input class="form-check-input" type="checkbox" name="isPremium" id="premiumCheck" value="true">
    <label class="form-check-label text-warning fw-bold" for="premiumCheck">
        <i class="bi bi-star-fill"></i> Đặt làm tin Premium (Chỉ VIP xem được)
    </label>
</div>
                    
                    <div class="alert alert-light border-0 bg-light text-muted small mb-4">
                        <i class="bi bi-info-circle me-1"></i> 
                        Bài viết sau khi đăng sẽ ở trạng thái <strong>Chờ duyệt</strong>. Admin sẽ kiểm tra trước khi hiển thị.
                    </div>

                    <div class="d-flex justify-content-end gap-2">
                        <button type="reset" class="btn btn-refresh">
                            <i class="bi bi-arrow-counterclockwise me-1"></i> Làm mới
                        </button>
                        <button type="submit" class="btn btn-gradient">
                            <i class="bi bi-send-fill me-2"></i> GỬI BÀI DUYỆT
                        </button>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>


          </div>
          <div class="tab-pane fade" id="v-pills-profile" role="tabpanel">
           <div class=" p-4 shadow-sm rounded-3">
  <div class="d-flex justify-content-between align-items-center flex-wrap">
    <form action="${pageContext.request.contextPath}/editor/workspace" method="get">
    <input type="hidden" name="action" value="search"> <div class="d-flex justify-content-between align-items-center flex-wrap">
        <div class="d-flex flex-wrap align-items-center gap-2">
            
            <select class="form-select" name="catId" style="width: 200px;" onchange="this.form.submit()">
                <option value="0">Tất cả danh mục</option>
                <c:forEach items="${categories}" var="c">
                    <option value="${c.id}" ${searchCatId == c.id ? 'selected' : ''}>
                        ${c.name}
                    </option>
                </c:forEach>
            </select>

            <div class="input-group" style="width: 250px;">
                <input type="text" class="form-control" name="keyword" 
                       value="${searchKeyword}" 
                       placeholder="Tìm tin đã duyệt..." aria-label="Tìm kiếm">
                <button class="btn btn-outline-success" type="submit">
                    <i class="bi bi-search"></i>
                </button>
            </div>
            
            <a href="${pageContext.request.contextPath}/editor/workspace" class="btn btn-light border" title="Xem tất cả">
                <i class="bi bi-arrow-counterclockwise"></i>
            </a>

        </div>
        
        <c:if test="${not empty videos}">
            <div class="text-muted small fst-italic">
                Tìm thấy ${fn:length(videos)} bài viết
            </div>
        </c:if>
    </div>
</form>

<c:if test="${isSearching}">
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Tìm nút tab "Danh sách tin"
            var profileTabBtn = document.querySelector('#v-pills-profile-tab');
            if(profileTabBtn) {
                // Kích hoạt tab này bằng Bootstrap API
                var tab = new bootstrap.Tab(profileTabBtn);
                tab.show();
            }
        });
    </script>
</c:if>
    

        </div>
        
      <div class="editor-card">
    <h4 class="editor-title">
        <i class="bi bi-list-check me-2" style="-webkit-text-fill-color: #006837;"></i>
        Danh sách bài đăng của bạn
    </h4>

    <c:if test="${empty videos}">
        <div class="text-center py-5 text-muted">
            <i class="bi bi-inbox fs-1 d-block mb-2"></i>
            <p>Bạn chưa đăng bài viết nào.</p>
        </div>
    </c:if>

    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:forEach items="${videos}" var="v">
    <div class="col">
        <div class="card video-item-card">
            <div class="video-thumb-wrapper position-relative"> <img src="${v.poster}" alt="${v.title}">
                
                <%-- ✅ CẬP NHẬT MỚI: Hiển thị nhãn Premium góc trái --%>
                <c:if test="${v.premium}">
                    <span class="badge bg-warning text-white position-absolute top-0 start-0 m-2 shadow-sm" 
                          style="z-index: 10; font-size: 0.75rem;">
                        <i class="bi bi-crown-fill me-1"></i>PREMIUM
                    </span>
                </c:if>
                <%-- ✅ KẾT THÚC CẬP NHẬT --%>

                <c:choose>
                    <c:when test="${v.status == 1}">
                        <span class="status-badge status-pending">
                            <i class="bi bi-hourglass-split me-1"></i>Chờ duyệt
                        </span>
                    </c:when>
                    <c:when test="${v.status == 2}">
                        <span class="status-badge status-approved">
                            <i class="bi bi-check-circle me-1"></i>Đã duyệt
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge status-rejected">
                            <i class="bi bi-x-circle me-1"></i>Bị từ chối/Ẩn
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card-body d-flex flex-column">
                <h6 class="card-title fw-bold text-truncate" title="${v.title}">${v.title}</h6>
                <p class="card-text text-muted small text-truncate mb-3">${v.desc}</p>
                
                <div class="mt-auto d-flex justify-content-between align-items-center card-actions">
                    <small class="text-muted" style="font-size: 0.8rem;">
                        <i class="bi bi-eye me-1"></i>${v.viewCount}
                    </small>
                    
                    <div class="btn-group">
                        <button type="button" class="btn btn-sm btn-light text-primary" 
                                data-bs-toggle="modal" data-bs-target="#viewModal${v.id}" title="Xem chi tiết">
                            <i class="bi bi-eye-fill"></i>
                        </button>
                        
                        <button type="button" class="btn btn-sm btn-light text-warning" 
                                data-bs-toggle="modal" data-bs-target="#editModal${v.id}" title="Chỉnh sửa">
                            <i class="bi bi-pencil-square"></i>
                        </button>

                        <form action="${pageContext.request.contextPath}/editor/delete" method="post" class="d-inline">
                            <input type="hidden" name="videoId" value="${v.id}">
                            <button type="submit" class="btn btn-sm btn-light text-danger"
                                    onclick="return confirm('Bạn có chắc muốn xóa bài viết này không? Hành động này không thể hoàn tác.')" title="Xóa">
                                <i class="bi bi-trash-fill"></i>
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="viewModal${v.id}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title fw-bold text-success">${v.title}</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="ratio ratio-16x9 mb-3 bg-dark rounded overflow-hidden">
                        <c:choose>
                            <c:when test="${fn:contains(v.url, 'youtube.com') || fn:contains(v.url, 'youtu.be')}">
                                <iframe src="${v.embedUrl}" allowfullscreen></iframe>
                            </c:when>
                            <c:otherwise>
                                <video controls autoplay muted>
                                    <source src="${v.url}" type="video/mp4">
                                </video>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="d-flex align-items-center mb-3">
                        <span class="badge bg-light text-dark border me-2">
                            <i class="bi bi-folder2-open me-1"></i>${v.category.name}
                        </span>
                        <span class="text-muted small"><i class="bi bi-clock me-1"></i>${v.createAt}</span>
                    </div>

                    <p class="text-secondary news-description">${v.desc}</p>
                    
                    <hr>
                    <p class="small text-muted mb-0">
                        <strong>Link gốc:</strong> <a href="${v.url}" target="_blank" class="text-decoration-none text-truncate d-inline-block align-bottom" style="max-width: 300px;">${v.url}</a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal${v.id}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow">
                <form action="${pageContext.request.contextPath}/editor/update" method="post" enctype="multipart/form-data">
                    
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold text-success">
                            <i class="bi bi-pencil-square me-2"></i>Chỉnh sửa bài đăng
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body p-4">
                        <input type="hidden" name="videoId" value="${v.id}">

                        <div class="alert alert-warning d-flex align-items-center p-2 mb-3 small">
                            <i class="bi bi-info-circle-fill me-2"></i>
                            <div>Việc chỉnh sửa nội dung có thể khiến bài viết phải chờ duyệt lại.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold small text-secondary">TIÊU ĐỀ</label>
                            <input type="text" class="form-control" name="tieuDe" value="${v.title}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold small text-secondary">DANH MỤC</label>
                            <select class="form-select" name="category">
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.id}" ${c.id == v.category.id ? 'selected' : ''}>
                                        ${c.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold small text-secondary">NỘI DUNG</label>
                            <textarea class="form-control" name="noiDung" rows="4" required>${v.desc}</textarea>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">ĐỔI ẢNH BÌA (Tùy chọn)</label>
                                <input type="file" class="form-control" name="anhBaiDang" accept="image/*">
                                <div class="mt-2">
                                    <small class="text-muted">Ảnh hiện tại:</small>
                                    <img src="${v.poster}" class="rounded ms-2 border" style="height: 40px; object-fit: cover;">
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold small text-secondary">LINK VIDEO</label>
                                <input type="text" class="form-control" name="videoBaiDang" value="${v.url}" required>
                            </div>
                        </div>

                        </div>

                    <div class="modal-footer border-top-0">
                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success px-4 fw-bold">Lưu thay đổi</button>
                    </div>

                </form>
            </div>
        </div>
    </div>
</c:forEach>
    </div>
</div>
              </div>
              
          
              
                </div>
                
                
        
        <div class="tab-pane fade" id="v-pills-disabled" role="tabpanel">
    <div class="editor-card">
        <h4 class="editor-title mb-4">
            <i class="bi bi-heart-fill me-2 text-danger"></i>Tin đã yêu thích
        </h4>

        <c:if test="${empty favourites}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-heartbreak display-1 opacity-25"></i>
                <p class="mt-3">Bạn chưa yêu thích video nào.</p>
            </div>
        </c:if>

        <div class="row g-4">
            <c:forEach var="video" items="${favourites}">
                <div class="col-md-6 col-lg-4">
                    <a href="${pageContext.request.contextPath}/postdetail?id=${video.id}" class="card-hover-effect">
                        <div class="card">
                            <div class="card-img-wrapper">
                                <img src="${video.poster}" alt="${video.title}">
                                <div class="play-overlay">
                                    <i class="bi bi-play-fill fs-4 ps-1"></i>
                                </div>
                            </div>
                            <div class="card-body">
                                <h6 class="card-title-custom news-description" title="${video.title}">
                                    ${video.title}
                                </h6>
                                <p class="card-desc-custom">
                                    ${video.desc}
                                </p>
                                <div class="card-meta-custom d-flex align-items-center gap-2">
                                    <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-10">
                                        <i class="bi bi-heart-fill me-1"></i>Đã thích
                                    </span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<div class="tab-pane fade" id="v-pills-messages" role="tabpanel">
    <div class="editor-card">
        <h4 class="editor-title mb-4">
            <i class="bi bi-clock-history me-2 text-primary"></i>Lịch sử xem
        </h4>

        <c:if test="${empty historyList}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-clock display-1 opacity-25"></i>
                <p class="mt-3">Bạn chưa xem bài viết nào.</p>
            </div>
        </c:if>

        <div class="row g-4">
            <c:forEach var="h" items="${historyList}">
                <div class="col-md-6 col-lg-4">
                    <a href="${pageContext.request.contextPath}/postdetail?id=${h.video.id}" class="card-hover-effect">
                        <div class="card">
                            <div class="card-img-wrapper">
                                <img src="${h.video.poster}" alt="${h.video.title}">
                                <div class="play-overlay">
                                    <i class="bi bi-play-fill fs-4 ps-1"></i>
                                </div>
                            </div>
                            <div class="card-body">
                                <h6 class="card-title-custom" title="${h.video.title}">
                                    ${h.video.title}
                                </h6>
                                <p class="card-desc-custom news-description">
                                    ${h.video.desc}
                                </p>
                                <div class="card-meta-custom d-flex justify-content-between align-items-center pt-2 border-top mt-2">
                                    <span>
                                        <i class="bi bi-calendar3 me-1"></i>
                                        ${h.viewedAt}
                                    </span>
                                    <span class="text-primary">
                                        Xem lại <i class="bi bi-arrow-right-short"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
        <div class="tab-pane fade" id="v-pills-disabled" role="tabpanel">
    <div class="editor-card border-0 shadow-none bg-transparent p-0">
        
        <div class="d-flex align-items-center mb-4">
            <div class="bg-danger bg-opacity-10 text-danger p-3 rounded-circle me-3">
                <i class="bi bi-heart-fill fs-4"></i>
            </div>
            <div>
                <h4 class="fw-bold mb-0 text-dark">Bộ sưu tập yêu thích</h4>
                <small class="text-muted">Danh sách các bài viết bạn đã lưu lại</small>
            </div>
        </div>

        <c:if test="${empty favourites}">
            <div class="empty-state-box">
                <img src="https://cdn-icons-png.flaticon.com/512/7486/7486747.png" 
                     width="120" class="mb-3 opacity-50" alt="Empty">
                <h5 class="fw-bold text-secondary">Chưa có bài viết yêu thích</h5>
                <p class="text-muted small">Hãy khám phá và thả tim cho những bài viết bạn tâm đắc nhé!</p>
                <a href="${pageContext.request.contextPath}/" class="btn btn-gradient mt-2">
                    Khám phá ngay
                </a>
            </div>
        </c:if>

        <div class="fav-grid">
            <c:forEach var="v" items="${favourites}">
                <div class="position-relative">
                    
                    <form action="${pageContext.request.contextPath}/video/favourite" method="post" class="position-absolute" style="z-index: 20; right: 10px; top: 10px;">
                        <input type="hidden" name="videoId" value="${v.id}">
                        <input type="hidden" name="action" value="unlike"> <button type="submit" class="btn-unlike" data-bs-toggle="tooltip" title="Bỏ yêu thích"
                                onclick="return confirm('Bạn muốn xóa bài này khỏi danh sách yêu thích?')">
                            <i class="bi bi-heart-break-fill"></i>
                        </button>
                    </form>

                    <a href="${pageContext.request.contextPath}/postdetail?id=${v.id}" class="text-decoration-none">
                        <div class="fav-card">
                            <div class="fav-img-wrapper">
                                <img src="${v.poster}" alt="${v.title}">
                                <div class="fav-overlay">
                                    <div class="btn-play-pulse">
                                        <i class="bi bi-play-fill ms-1"></i>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="fav-body">
                                <div class="fav-title">${v.title}</div>
                                <div class="fav-desc">${v.desc}</div>
                                
                                <div class="fav-meta">
                                    <span><i class="bi bi-folder2-open me-1"></i>${v.category.name}</span>
                                    <span><i class="bi bi-eye me-1"></i>${v.viewCount} lượt xem</span>
                                </div>
                            </div>
                        </div>
                    </a>

                </div>
            </c:forEach>
        </div>
    </div>
</div>
         <div class="tab-pane fade" id="v-pills-reports" role="tabpanel">
          <h2>TIN ĐĂNG BÁO XẤU</h2>
           <div class="input-group" style="width: 250px;">
        <input type="text" class="form-control" placeholder="Nhập tên hoặc mã tin">
        <button class="btn btn-outline-secondary" type="button">
          <i class="bi bi-search"></i>
        </button>
      </div>
        </div>
    </div>
  </div>
  </div>
</main>
<br/>
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

            </div> </div> 
            </footer>
<c:if test="${not empty success}">
    <script>
        Swal.fire({
            icon: 'success',
            title: 'Thành công!',
            text: '${success}',
            confirmButtonText: 'OK'
        });
    </script>
</c:if>


<c:if test="${not empty editModalId}">
<script>
    var myModal = new bootstrap.Modal(document.getElementById("${editModalId}"));
    myModal.show();
</script>
</c:if>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


</body>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"></script>
</html>