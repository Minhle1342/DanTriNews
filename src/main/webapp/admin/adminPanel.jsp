<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dân Trí Admin Dashboard</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --primary-color: #059669;       /* Xanh lục chính (Emerald 600) */
            --primary-hover: #047857;       /* Xanh lục đậm hơn khi hover */
            --secondary-color: #34d399;     /* Xanh bạc hà */
            --bg-dark: #064e3b;             /* Sidebar BG (Emerald 900) */
            --bg-light: #f3f4f6;            /* Nền nội dung chính */
            --text-dark: #1f2937;
            --text-light: #f9fafb;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --transition-speed: 0.3s;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
            overflow-x: hidden;
        }

        /* --- Sidebar Styling --- */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, var(--bg-dark) 0%, #022c22 100%);
            min-height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
            transition: all var(--transition-speed);
            box-shadow: 4px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar-brand {
            height: 70px;
            display: flex;
            align-items: center;
            padding: 0 24px;
            font-size: 1.5rem;
            font-weight: 700;
            color: white;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        
        .sidebar-brand i {
            color: var(--secondary-color);
            margin-right: 10px;
        }
        
        


/* --- Admin Video Card Style --- */
.admin-card {
    background: #fff;
    border: none;
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
    transition: all 0.3s ease;
    overflow: hidden;
    height: 100%;
}

.admin-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 30px rgba(0, 104, 55, 0.15); /* Bóng đổ xanh lục */
}

/* Ảnh bìa */
.admin-thumb-wrapper {
    position: relative;
    padding-top: 56.25%; /* 16:9 ratio */
    overflow: hidden;
}

.admin-thumb-wrapper img {
    position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.admin-card:hover .admin-thumb-wrapper img {
    transform: scale(1.1);
}

/* Badge trạng thái */
.status-label {
    position: absolute;
    top: 12px; right: 12px;
    padding: 6px 14px;
    border-radius: 30px;
    font-size: 0.75rem;
    font-weight: 700;
    color: white;
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    backdrop-filter: blur(4px);
    z-index: 2;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.st-pending { background: linear-gradient(135deg, #f59e0b, #fbbf24); } /* Vàng */
.st-active  { background: linear-gradient(135deg, #006837, #10b981); } /* Xanh lục */
.st-hidden  { background: linear-gradient(135deg, #ef4444, #f87171); } /* Đỏ */

/* Nội dung card */
.admin-card-body {
    padding: 1.25rem;
    display: flex;
    flex-direction: column;
    height: calc(100% - 56.25%); /* Trừ đi phần ảnh */
}

.card-meta {
    font-size: 0.8rem;
    color: #6c757d;
    margin-bottom: 0.5rem;
    display: flex;
    align-items: center;
    gap: 10px;
}

.admin-card-title {
    font-size: 1rem;
    font-weight: 700;
    color: #2c3e50;
    line-height: 1.4;
    margin-bottom: 0.5rem;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

/* Nút bấm hành động */
.action-btn-group {
    margin-top: auto;
    padding-top: 1rem;
    border-top: 1px solid #f1f5f9;
    display: flex;
    gap: 8px;
}

.btn-admin-action {
    flex: 1;
    border: none;
    padding: 8px;
    border-radius: 8px;
    font-size: 0.85rem;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
    text-decoration: none;
}

.btn-approve {
    background-color: #ecfdf5;
    color: #059669;
}
.btn-approve:hover { background-color: #059669; color: white; }

.btn-reject {
    background-color: #fef2f2;
    color: #dc2626;
}
.btn-reject:hover { background-color: #dc2626; color: white; }

.btn-detail {
    background-color: #f1f5f9;
    color: #475569;
}
.btn-detail:hover { background-color: #cbd5e1; color: #1e293b; }
        .sidebar .nav-link {
            color: #d1d5db;
            padding: 12px 24px;
            font-weight: 500;
            border-radius: 0;
            border-left: 4px solid transparent;
            transition: all var(--transition-speed);
            display: flex;
            align-items: center;
        }

        .sidebar .nav-link i {
            margin-right: 12px;
            font-size: 1.1rem;
            width: 24px;
            text-align: center;
        }

        .sidebar .nav-link:hover {
            background-color: rgba(255, 255, 255, 0.05);
            color: white;
            padding-left: 28px; /* Hiệu ứng đẩy nhẹ sang phải */
        }

        .sidebar .nav-link.active {
            background: linear-gradient(90deg, rgba(5, 150, 105, 0.2) 0%, transparent 100%);
            color: var(--secondary-color);
            border-left-color: var(--secondary-color);
        }

        /* --- Main Content Area --- */
        .main-content {
            margin-left: 260px;
            width: calc(100% - 260px);
            transition: all var(--transition-speed);
        }

        /* --- Header --- */
        .top-header {
            background-color: white;
            height: 70px;
            padding: 0 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            position: sticky;
            top: 0;
            z-index: 999;
        }

        /* --- Cards & Panels --- */
        .content-body {
            padding: 30px;
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            background: white;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        .card-img-top {
            height: 180px;
            object-fit: cover;
        }

        /* --- Buttons --- */
        .btn {
            border-radius: 8px;
            padding: 8px 16px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-success {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-success:hover {
            background-color: var(--primary-hover);
            border-color: var(--primary-hover);
            box-shadow: 0 4px 12px rgba(5, 150, 105, 0.3);
        }

        .btn-primary {
            background-color: #3b82f6;
            border-color: #3b82f6;
        }

        /* --- Tables --- */
        .table-responsive {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
        }

        .table thead {
            background-color: var(--bg-dark);
            color: white;
        }
        
        .table th {
            font-weight: 600;
            padding: 15px;
            border: none;
        }

        .table td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid #f3f4f6;
        }

        .table tbody tr:hover {
            background-color: #f0fdf4; /* Xanh nhạt khi hover row */
        }

        /* --- Status Badge --- */
        .badge-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .status-active { background-color: #d1fae5; color: #065f46; }
        .status-inactive { background-color: #fee2e2; color: #991b1b; }

        /* --- Forms --- */
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #e5e7eb;
            padding: 10px 15px;
        }
        
        /* Gradient Cards */
    .finance-card {
        border-radius: 20px;
        padding: 25px;
        color: white;
        position: relative;
        overflow: hidden;
        box-shadow: 0 10px 20px rgba(0, 104, 55, 0.15);
        transition: transform 0.3s ease;
        border: none;
    }
    .finance-card:hover { transform: translateY(-5px); }
    
    .bg-gradient-green { background: linear-gradient(135deg, #006837 0%, #38ef7d 100%); }
    .bg-gradient-orange { background: linear-gradient(135deg, #FF9966 0%, #FF5E62 100%); }
    .bg-gradient-blue { background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); }

    .finance-icon {
        font-size: 3rem;
        opacity: 0.3;
        position: absolute;
        right: 20px;
        bottom: 10px;
    }

    .finance-value { font-size: 2rem; font-weight: 800; }
    .finance-label { font-size: 0.9rem; text-transform: uppercase; letter-spacing: 1px; opacity: 0.9; }

    /* Config Box */
    .config-box {
        background: #fff;
        border-radius: 16px;
        padding: 30px;
        box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        border-left: 5px solid #006837;
    }

    /* Modern Table */
    .table-finance thead th {
        background-color: #f8f9fa;
        color: #006837;
        font-weight: 700;
        text-transform: uppercase;
        font-size: 0.8rem;
        border: none;
    }
    .table-finance tbody td {
        vertical-align: middle;
        font-weight: 500;
    }
    .avatar-sm { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; }
    
    .status-badge {
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 0.75rem;
        font-weight: 600;
    }
    .bg-soft-green { background-color: #dcfce7; color: #166534; }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.1);
        }

        /* --- Footer --- */
        footer {
            background-color: white;
            color: #6b7280;
            border-top: 1px solid #e5e7eb;
            padding: 20px;
            font-size: 0.9rem;
        }

        /* --- Animation --- */
        .fade-in-up {
            animation: fadeInUp 0.5s ease-out;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; width: 100%; }
        }
    </style>
</head>
<body>

    <div class="sidebar p-2 d-flex flex-column" style="height: 100vh;"> <div class="sidebar-brand">
        <i class="bi bi-flower1"></i>
        <span>Hello Admin!</span>
    </div>

    <div class="nav flex-column nav-pills mt-3" id="v-pills-tab" role="tablist" aria-orientation="vertical">
        <button class="nav-link active" id="tab-dashboard" data-bs-toggle="pill" data-bs-target="#content-dashboard" type="button" role="tab">
            <i class="bi bi-speedometer2"></i> Dashboard
        </button>
        <button class="nav-link" id="tab-post" data-bs-toggle="pill" data-bs-target="#content-post" type="button" role="tab">
            <i class="bi bi-collection-play"></i> Quản lý bài đăng
        </button>
        <button class="nav-link" id="tab-user" data-bs-toggle="pill" data-bs-target="#content-user" type="button" role="tab">
            <i class="bi bi-people"></i> Quản lý người dùng
        </button>
        <button class="nav-link" id="tab-category" data-bs-toggle="pill" data-bs-target="#content-category" type="button" role="tab">
            <i class="bi bi-tags"></i> Quản lý danh mục
        </button>
        <button class="nav-link" id="tab-role" data-bs-toggle="pill" data-bs-target="#content-role" type="button" role="tab">
            <i class="bi bi-shield-check"></i> Phân quyền
        </button>
        <button class="nav-link" id="tab-banner" data-bs-toggle="pill" data-bs-target="#content-banner" type="button" role="tab">
            <i class="bi bi-badge-ad"></i>
 Quản lý banner
        </button>
        <button class="nav-link" id="tab-password" data-bs-toggle="pill" data-bs-target="#content-password" type="button" role="tab">
            <i class="bi bi-key"></i> Đổi mật khẩu
        </button>
    </div>

    <div class="mt-auto p-2 border-top border-secondary border-opacity-25">
        <a href="javascript:void(0);" onclick="confirmLogout()" 
           class="nav-link text-danger fw-bold d-flex align-items-center">
            <i class="bi bi-box-arrow-left me-2"></i> Đăng xuất
        </a>
    </div>

</div>

    <div class="main-content">
        
      <header class="top-header d-flex justify-content-between align-items-center py-3 px-4 bg-white shadow-sm border-bottom">
    
    <div class="d-flex align-items-center">
        <h5 class="m-0 fw-bold text-success">
            <i class="bi bi-grid-fill me-2"></i>Dan Tri Admin
        </h5>
    </div>

    <div class="d-none d-md-block text-center">
        <div class="d-inline-flex align-items-center px-3 py-2 rounded-pill bg-light border">
            <i class="bi bi-calendar-event text-success me-2"></i>
            <span id="realtime-date" class="fw-semibold text-secondary me-3" style="font-size: 0.9rem;">--/--/----</span>
            
            <div style="width: 1px; height: 15px; background: #ccc;" class="me-3"></div> 
            
            <i class="bi bi-clock text-success me-2"></i>
            <span id="realtime-clock" class="fw-bold text-dark" style="font-family: monospace; font-size: 1rem;">--:--:--</span>
        </div>
    </div>

    <div class="d-flex align-items-center">
        
        <a href="${pageContext.request.contextPath}/" 
           class="btn btn-light text-success rounded-circle me-3 shadow-sm d-flex align-items-center justify-content-center border"
           style="width: 40px; height: 40px; transition: all 0.2s;"
           data-bs-toggle="tooltip" 
           data-bs-placement="bottom" 
           title="Về trang chủ (Xem trang web)">
            <i class="bi bi-house-door-fill fs-5"></i>
        </a>

        <div class="dropdown">
            <a href="#" class="d-flex align-items-center text-decoration-none text-dark dropdown-toggle p-1 rounded hover-bg-light transition-all" id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
                <img src="https://ui-avatars.com/api/?name=${sessionScope.user.username}&background=10b981&color=fff&size=128" 
                     alt="avatar" width="38" height="38" class="rounded-circle me-2 border border-2 border-white shadow-sm">
                
                <div class="d-none d-lg-block text-start me-2">
                    <div class="fw-bold small">${sessionScope.user.username}</div>
                    <div class="text-muted" style="font-size: 11px;">Administrator</div>
                </div>
            </a>
            <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 mt-2 rounded-3" aria-labelledby="dropdownUser1">
                <li><a class="dropdown-item py-2" href="#"><i class="bi bi-person me-2 text-primary"></i>Hồ sơ cá nhân</a></li>
                <li><a class="dropdown-item py-2" href="#"><i class="bi bi-gear me-2 text-secondary"></i>Cài đặt</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item py-2 text-danger fw-semibold" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
            </ul>
        </div>
    </div>
</header>

<script>
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    })
</script>

        <div class="content-body">
            <div class="tab-content" id="v-pills-tabContent">

                <div class="tab-pane fade show active fade-in-up" id="content-dashboard" role="tabpanel">
    <h3 class="mb-4 fw-bold text-success">Tổng quan hệ thống</h3>
    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card p-3 border-0 shadow-sm bg-white h-100">
                <div class="d-flex align-items-center">
                    <div class="rounded-circle bg-success bg-opacity-10 p-3 text-success">
                        <i class="bi bi-play-btn fs-3"></i>
                    </div>
                    <div class="ms-3">
                        <p class="mb-0 text-muted small">Tổng Video</p>
                        <h3 class="mb-0 fw-bold text-dark">${fn:length(videos)}</h3>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 border-0 shadow-sm bg-white h-100">
                <div class="d-flex align-items-center">
                    <div class="rounded-circle bg-primary bg-opacity-10 p-3 text-primary">
                        <i class="bi bi-people fs-3"></i>
                    </div>
                    <div class="ms-3">
                        <p class="mb-0 text-muted small">Tổng Người dùng</p>
                        <h3 class="mb-0 fw-bold text-dark">${fn:length(users)}</h3>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 border-0 shadow-sm bg-white h-100">
                <div class="d-flex align-items-center">
                    <div class="rounded-circle bg-warning bg-opacity-10 p-3 text-warning">
                        <i class="bi bi-tags fs-3"></i>
                    </div>
                    <div class="ms-3">
                        <p class="mb-0 text-muted small">Danh mục</p>
                        <h3 class="mb-0 fw-bold text-dark">${fn:length(categories)}</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm p-4 h-100">
                <h5 class="fw-bold text-secondary mb-4">
                    <i class="bi bi-bar-chart-line-fill me-2 text-primary"></i>Top Video Xem Nhiều Nhất
                </h5>
                <div style="height: 300px;">
                    <canvas id="viewChart"></canvas>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card border-0 shadow-sm p-4 h-100">
                <h5 class="fw-bold text-secondary mb-4">
                    <i class="bi bi-heart-fill me-2 text-danger"></i>Top Yêu Thích
                </h5>
                <div style="height: 250px; display: flex; justify-content: center;">
                    <canvas id="likeChart"></canvas>
                </div>
                <div class="mt-3 text-center small text-muted">
                    Phân bổ lượt thích giữa các video hot nhất
                </div>
            </div>
        </div>
    </div>
    
    <div class="container-fluid py-4">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-success"><i class="bi bi-wallet2 me-2"></i>Quản lý Dòng tiền</h3>
        <a href="${pageContext.request.contextPath}/admin/exportRevenue" class="btn btn-outline-success rounded-pill" onclick="window.print()">
            <i class="bi bi-printer me-2"></i>Xuất báo cáo
        </a>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="finance-card bg-gradient-green">
                <div class="finance-label">Tổng Doanh Thu (VNPay)</div>
                <div class="finance-value">
                    <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/>
                </div>
                <i class="bi bi-graph-up-arrow finance-icon"></i>
                <div class="mt-2 small"><i class="bi bi-arrow-up-circle me-1"></i>+100% từ người dùng</div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="finance-card bg-gradient-orange">
                <div class="finance-label">Phải trả Editor (KPI)</div>
                <div class="finance-value">
                    <fmt:formatNumber value="${totalExpense}" type="currency" currencySymbol="₫"/>
                </div>
                <i class="bi bi-people-fill finance-icon"></i>
                <div class="mt-2 small opacity-75">Dựa trên tổng lượt xem</div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="finance-card bg-gradient-blue">
                <div class="finance-label">Lợi Nhuận Ròng</div>
                <div class="finance-value">
                    <fmt:formatNumber value="${netProfit}" type="currency" currencySymbol="₫"/>
                </div>
                <i class="bi bi-pie-chart-fill finance-icon"></i>
                <div class="mt-2 small">Doanh thu - Chi phí</div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-4">
            <div class="config-box h-100">
                <h5 class="fw-bold mb-3 text-success">
                    <i class="bi bi-sliders me-2"></i>Thiết lập Đơn giá
                </h5>
                <p class="text-muted small">Cài đặt số tiền Editor nhận được cho mỗi lượt xem video.</p>
                
                <form action="${pageContext.request.contextPath}/admin/updateRate" method="post">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Đơn giá (VNĐ / 1 View)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-success text-white border-success">VNĐ</span>
                            <input type="number" name="viewRate" class="form-control border-success text-success fw-bold" 
                                   value="${viewRate}" min="1" step="1">
                        </div>
                    </div>
                    
                    <div class="alert alert-warning d-flex align-items-center small p-2" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <div>Thay đổi này sẽ áp dụng cho tất cả lượt xem chưa thanh toán.</div>
                    </div>

                    <button type="submit" class="btn btn-success w-100 fw-bold py-2">
                        <i class="bi bi-save me-2"></i>Cập nhật Đơn giá
                    </button>
                </form>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 h-100">
                <div class="card-header bg-white border-0 py-3 d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold m-0 text-success"><i class="bi bi-cash-stack me-2"></i>Bảng lương Editor</h5>
                    <button class="btn btn-sm btn-light text-muted">Tháng này <i class="bi bi-chevron-down"></i></button>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-finance mb-0 align-middle">
                            <thead>
                                <tr>
                                    <th class="ps-4">Editor</th>
                                    <th class="text-center">Tổng Views</th>
                                    <th class="text-end">Thu nhập ước tính</th>
                                    <th class="text-center">Trạng thái</th>
                                    <th class="text-end pe-4">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="row" items="${editorStats}">
                                    <c:set var="editor" value="${row[0]}"/>
                                    <c:set var="views" value="${row[1]}"/>
                                    <c:set var="earnings" value="${row[2]}"/>
                                    
                                    <tr>
                                        <td class="ps-4">
                                            <div class="d-flex align-items-center">
                                                <img src="https://ui-avatars.com/api/?name=${editor.name}&background=random" class="avatar-sm me-3">
                                                <div>
                                                    <div class="fw-bold text-dark">${editor.name}</div>
                                                    <div class="small text-muted">${editor.email}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-light text-dark border">
                                                <i class="bi bi-eye-fill me-1"></i>${views}
                                            </span>
                                        </td>
                                        <td class="text-end fw-bold text-success">
                                            <fmt:formatNumber value="${earnings}" type="currency" currencySymbol="₫"/>
                                        </td>
                                        <td class="text-center">
                                            <span class="status-badge bg-soft-green">Chờ thanh toán</span>
                                        </td>
                                        <td class="text-end pe-4">
                                           <button class="btn btn-sm btn-outline-success" 
        onclick="openPayoutModal(
            '${editor.id}', 
            '${editor.name}', 
            '${earnings}', 
            '${editor.bankName}',      <%-- Thêm --%>
            '${editor.bankAccount}',   <%-- Thêm --%>
            '${editor.bankAccountName}' <%-- Thêm --%>
        )">
    <i class="bi bi-qr-code"></i> Chuyển khoản
</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    
                    <c:if test="${empty editorStats}">
                        <div class="text-center py-5 text-muted">
                            <i class="bi bi-people fs-1 opacity-25"></i>
                            <p class="mt-2">Chưa có dữ liệu Editor.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
    
</div>

                <div class="tab-pane fade fade-in-up" id="content-post" role="tabpanel">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold m-0">Quản lý bài đăng</h3>
                        <button class="btn btn-success shadow-sm" data-bs-toggle="modal" data-bs-target="#modalAddPost">
                            <i class="bi bi-plus-lg me-1"></i> Tạo mới
                        </button>
                    </div>

                    <div class="modal fade" id="modalAddPost" tabindex="-1">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <div class="modal-content border-0 shadow">
                                <c:if test="${not empty sessionScope.success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${sessionScope.success}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("success"); %>
</c:if>

<c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${sessionScope.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("error"); %>
</c:if>

<form action="${pageContext.request.contextPath}/admin/addVideo" method="post" enctype="multipart/form-data">
    <div class="modal-header bg-success text-white">
        <h5 class="modal-title fw-bold">Tạo bài đăng mới (Admin)</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
    </div>
    <div class="modal-body p-4">
        <div class="row g-3">
            <div class="col-12">
                <label class="form-label fw-bold text-muted small">Tiêu đề</label>
                <input type="text" name="title" class="form-control" placeholder="Nhập tiêu đề video..." required>
            </div>
            <div class="col-12">
                <label class="form-label fw-bold text-muted small">Mô tả</label>
                <textarea name="desc" class="form-control" rows="3" placeholder="Mô tả ngắn gọn..." required></textarea>
            </div>
            <div class="col-md-6">
                <label class="form-label fw-bold text-muted small">Link Youtube / Video URL</label>
                <div class="input-group">
                    <span class="input-group-text bg-white"><i class="bi bi-link"></i></span>
                    <input type="text" name="url" class="form-control" placeholder="https://..." required>
                </div>
            </div>
           <div class="col-md-6">
                <label class="form-label fw-bold text-muted small">Danh mục</label>
                
                <select name="catId" class="form-select" required>
                    <option value="" disabled selected>-- Chọn danh mục --</option>
                    
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}">${c.name}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="col-md-6"> 
                <div class="form-check pt-4">
                    <input class="form-check-input" type="checkbox" name="isPremium" id="isPremiumCheck" value="true">
                    <label class="form-check-label fw-bold text-danger" for="isPremiumCheck">
                        <i class="bi bi-star-fill me-1 text-warning"></i> Đánh dấu bài viết Premium (Chỉ VIP xem)
                    </label>
                </div>
            </div>
            <div class="col-md-6">
                <label class="form-label fw-bold text-muted small">Poster (Ảnh thumbnail)</label>
                <input type="file" class="form-control" name="poster" accept="image/*">
            </div>
            
            <input type="hidden" name="userId" value="${sessionScope.user.id}">
        </div>
    </div>
    <div class="modal-footer bg-light">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
        <button class="btn btn-success px-4" type="submit">Đăng ngay</button>
    </div>
</form>
                            </div>
                        </div>
                    </div>

                   <div class="row g-4">
    <div class="card p-3 mb-4 shadow-sm border-0">
        <form action="${pageContext.request.contextPath}/admin/adminPanel" method="get" class="row g-3 align-items-center">
            <input type="hidden" name="tab" value="post">
            <div class="col-md-4">
                <label class="form-label small text-muted">Lọc theo Trạng thái</label>
                <select name="status" class="form-select">
                    <option value="" ${param.status == null || param.status == '' ? 'selected' : ''}>— Tất cả Trạng thái —</option>
                    <option value="1" ${param.status == '1' ? 'selected' : ''}>1. Chờ duyệt</option>
                    <option value="2" ${param.status == '2' ? 'selected' : ''}>2. Đã duyệt (Hiển thị)</option>
                    <option value="0" ${param.status == '0' ? 'selected' : ''}>0. Đã ẩn/Từ chối</option>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label small text-muted">Tìm kiếm Tiêu đề / Tác giả</label>
                <input type="text" name="keyword" class="form-control" placeholder="Nhập từ khóa tìm kiếm..." value="${param.keyword}">
            </div>
            <div class="col-md-2 d-flex align-self-end">
                <button type="submit" class="btn btn-primary w-100 me-2">
                    <i class="bi bi-funnel"></i> Lọc
                </button>
                <a href="${pageContext.request.contextPath}/admin/adminPanel?tab=post" class="btn btn-light" title="Reset Lọc">
                    <i class="bi bi-arrow-clockwise"></i>
                </a>
            </div>
        </form>
    </div>
    


<div class="card border-0 shadow-sm">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0 align-middle">
                <thead>
                    <tr>
                        <th width="50" class="ps-3">ID</th>
                        <th>Tiêu đề & Ảnh</th>
                        <th width="120">Danh mục</th>
                        <th width="100">Loại tin</th> 
                        <th width="120">Lượt xem</th>
                        <th width="120">Trạng thái</th>
                        <th width="220" class="text-end pe-3">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="v" items="${videos}">
                        <tr>
                            <td class="ps-3 fw-bold">${v.id}</td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <img src="${v.poster}" alt="Thumbnail" style="width: 60px; height: 40px; object-fit: cover; border-radius: 4px;" class="me-3 shadow-sm">
                                    <div>
                                        <div class="fw-bold" title="${v.title}">${fn:substring(v.title, 0, 40)}...</div>
                                        <small class="text-muted">Đăng bởi: <strong>${v.user.name}</strong></small>
                                    </div>
                                </div>
                            </td>
                            <td><span class="badge bg-light text-secondary border">${v.category.name}</span></td>
                            
                            <td>
                                <c:choose>
                                    <c:when test="${v.premium}">
                                        <span class="badge bg-danger text-white px-2 py-1 fw-bold">
                                            <i class="bi bi-star-fill me-1"></i> PREMIUM
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary bg-opacity-10 text-dark px-2 py-1 fw-normal">
                                            Tin thường
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            
                            <td><i class="bi bi-eye me-1 text-primary"></i> ${v.viewCount}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${v.status == 1}">
                                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill fw-bold" style="font-size: 0.75rem;">
                                            <i class="bi bi-hourglass-split me-1"></i> Chờ duyệt
                                        </span>
                                    </c:when>
                                    <c:when test="${v.status == 2}">
                                        <span class="badge bg-success text-white px-3 py-2 rounded-pill fw-bold" style="font-size: 0.75rem;">
                                            <i class="bi bi-check2-circle me-1"></i> Hiển thị
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary text-white px-3 py-2 rounded-pill fw-bold" style="font-size: 0.75rem;">
                                            <i class="bi bi-eye-slash-fill me-1"></i> Đã ẩn
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-end pe-3">
                                <%-- Nút Xem Chi tiết (Luôn hiển thị) --%>
                                <a href="${pageContext.request.contextPath}/admin/videoDetail?id=${v.id}" 
                                   class="btn btn-sm btn-outline-primary me-1" title="Xem chi tiết">
                                    <i class="bi bi-eye-fill"></i>
                                </a>

                                <c:choose>
                                    <%-- Nếu đang CHỜ DUYỆT (1) -> Hiện nút Duyệt VÀ nút TỪ CHỐI --%>
                                    <c:when test="${v.status == 1}">
                                        <a href="${pageContext.request.contextPath}/admin/updateStatus?id=${v.id}&status=2" 
                                           class="btn btn-sm btn-success me-1" title="Duyệt bài"
                                           onclick="return confirm('Xác nhận DUYỆT bài viết này hiển thị lên trang chủ?')">
                                            <i class="bi bi-check-lg"></i>
                                        </a>
                                        
                                        <%-- ✅ NÚT MỚI: TỪ CHỐI (Chuyển sang status 0) --%>
                                        <a href="${pageContext.request.contextPath}/admin/updateStatus?id=${v.id}&status=0" 
                                           class="btn btn-sm btn-danger me-1" title="Từ chối/Ẩn bài"
                                           onclick="return confirm('Xác nhận TỪ CHỐI DUYỆT bài viết này? Bài viết sẽ chuyển sang trạng thái ẨN.')">
                                            <i class="bi bi-x-lg"></i>
                                        </a>
                                    </c:when>

                                    <%-- Nếu đang HIỆN (2) -> Hiện nút Ẩn (Chuyển sang status 0) --%>
                                    <c:when test="${v.status == 2}">
                                        <a href="${pageContext.request.contextPath}/admin/updateStatus?id=${v.id}&status=0" 
                                           class="btn btn-sm btn-warning me-1" title="Gỡ bài/Ẩn"
                                           onclick="return confirm('Bạn muốn gỡ bài viết này xuống?')">
                                            <i class="bi bi-lock-fill"></i>
                                        </a>
                                    </c:when>

                                    <%-- Nếu đang ẨN (0) -> Hiện nút Khôi phục (Chuyển sang status 2) --%>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/admin/updateStatus?id=${v.id}&status=2" 
                                           class="btn btn-sm btn-info me-1" title="Khôi phục"
                                           onclick="return confirm('Khôi phục bài viết này?')">
                                            <i class="bi bi-arrow-counterclockwise"></i>
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                                
                                <c:if test="${v.user.role == 3}">
                                    
                                    <%-- Nút Chỉnh sửa --%>
                                    <a href="${pageContext.request.contextPath}/admin/editVideo?id=${v.id}" 
                                       class="btn btn-sm btn-outline-info me-1" title="Chỉnh sửa bài viết">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>

                                    <%-- Nút Xóa --%>
                                    <a href="${pageContext.request.contextPath}/admin/deleteVideo?id=${v.id}" 
                                       class="btn btn-sm btn-outline-danger" title="Xóa vĩnh viễn"
                                       onclick="return confirm('CẢNH BÁO! Xác nhận XÓA VĨNH VIỄN bài viết: ${v.title}?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty videos}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                <i class="bi bi-search fs-4 d-block mb-2"></i>
                                Không tìm thấy bài viết nào phù hợp với bộ lọc.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>


</div>
                </div>

                <div class="tab-pane fade fade-in-up" id="content-user" role="tabpanel">
<h3 class="mb-4 fw-bold">Quản lý người dùng</h3>

    <div class="card p-3 mb-4 border-0 shadow-sm bg-light">
        <form action="${pageContext.request.contextPath}/admin/adminPanel" method="get" class="row g-3 align-items-end">
            
            <input type="hidden" name="tab" value="user"> 
            
            <div class="col-md-5">
                <label for="keyword" class="form-label small fw-bold text-muted">Tìm kiếm (Username/Tên)</label>
                <div class="input-group">
                    <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                    <input type="text" name="keyword" id="keyword" class="form-control" 
                           placeholder="Nhập tên hoặc username..." value="${param.keyword != null ? param.keyword : ''}">
                </div>
            </div>
            
            <div class="col-md-4">
                <label for="role" class="form-label small fw-bold text-muted">Lọc theo Vai trò</label>
                <select name="roleId" id="role" class="form-select">
                    <option value="0" ${param.roleId == '0' || empty param.roleId ? 'selected' : ''}>-- Tất cả Vai trò --</option>
                    <option value="1" ${param.roleId == '1' ? 'selected' : ''}>User (Thành viên)</option>
                    <option value="2" ${param.roleId == '2' ? 'selected' : ''}>Editor (Người đăng bài)</option>
                    </select>
            </div>
            
            <div class="col-md-3">
                <button type="submit" class="btn btn-success w-100 fw-bold">
                    <i class="bi bi-funnel-fill me-1"></i> Áp dụng Lọc
                </button>
            </div>
        </form>
    </div>
                        <div class="card border-0 shadow-sm">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tài khoản</th>
                                            <th>Vai trò</th>
                                            <th>Thông tin</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="u" items="${users}">
                                            <tr>
                                                <td class="fw-bold">#${u.id}</td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="bg-light rounded-circle p-2 me-2 text-center" style="width:40px;height:40px;">
                                                            <i class="bi bi-person text-secondary"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-bold">${u.username}</div>
                                                            <small class="text-muted">${u.email}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                               <td>
                                                    <c:choose>
                                                        <c:when test="${u.role == 3}">
                                                            <span class="badge bg-danger text-white px-2 py-1 fw-bold">
                                                                <i class="bi bi-shield-fill me-1"></i> ADMIN
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${u.role == 2}">
                                                            <span class="badge bg-info text-dark px-2 py-1 fw-bold">
                                                                <i class="bi bi-pencil-square me-1"></i> EDITOR
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary text-white px-2 py-1 fw-bold">
                                                                <i class="bi bi-person me-1"></i> USER
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                
                                                <td>
                                                    <div>${u.name}</div>
                                                    <small class="text-muted"><i class="bi bi-telephone"></i> ${u.phone}</small>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${u.status}">
                                                            <span class="badge-status status-active">Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge-status status-inactive">Đã khóa</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <c:if test="${u.role != 3}">
                                                        <a href="adminPanel?action=toggle&id=${u.id}" class="btn btn-sm btn-light text-warning mx-1" title="Khóa/Mở">
                                                            <i class="bi bi-shield-lock-fill"></i>
                                                        </a>
                                                    </c:if>
                                                    <a href="adminPanel?action=view&id=${u.id}" class="btn btn-sm btn-light text-primary" title="Xem chi tiết">
                                                        <i class="bi bi-eye-fill"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade fade-in-up" id="content-category" role="tabpanel">
                    <div class="row">
                        <div class="col-md-8">
                            <h3 class="mb-4 fw-bold">Danh mục tin tức</h3>
                            <div class="card border-0 shadow-sm mb-4">
                                <div class="card-body p-0">
                                    <c:if test="${not empty successCategory}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle me-2"></i> ${successCategory}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<c:if test="${not empty errCategory}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle me-2"></i> ${errCategory}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</c:if>

<table class="table table-hover mb-0">
    <thead>
        <tr>
            <th width="100">ID</th>
            <th>Tên danh mục</th>
            <th class="text-end">Hành động</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="c" items="${categories}">
            <tr>
                <td>${c.id}</td>
                <td class="fw-bold text-success">${c.name}</td>
                <td class="text-end">
                    <button class="btn btn-sm btn-outline-secondary me-1">
                        <i class="bi bi-pencil"></i>
                    </button>
                    
                    <a href="${pageContext.request.contextPath}/admin/adminPanel?action=deleteCategory&id=${c.id}" 
                       class="btn btn-sm btn-outline-danger"
                       onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục: ${c.name}?');">
                        <i class="bi bi-trash"></i>
                    </a>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm bg-success text-white">
                                <div class="card-body">
                                    <h5 class="card-title fw-bold mb-3"><i class="bi bi-plus-circle"></i> Thêm mới</h5>
                                    <form action="${pageContext.request.contextPath}/admin/adminPanel?action=addCategory" method="post">
                                        <div class="mb-3">
                                            <label class="form-label opacity-75">Tên danh mục</label>
                                            <input type="text" name="name" class="form-control border-0 text-dark" placeholder="Nhập tên..." required />
                                        </div>
                                        <button type="submit" class="btn btn-light w-100 fw-bold text-success">Lưu danh mục</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade fade-in-up" id="content-role" role="tabpanel">
                    <h3 class="mb-4 fw-bold">Phân quyền</h3>
                    <jsp:include page="roleRequestList.jsp"/>
                </div>

                <div class="tab-pane fade fade-in-up" id="content-password" role="tabpanel">
                    <h3 class="mb-4 fw-bold">Đổi mật khẩu</h3>
                    <div class="row justify-content-center">
                        <div class="col-md-6">
                            <div class="card border-0 shadow-sm p-4">
                                <div class="text-center mb-4">
                                    <div class="bg-success bg-opacity-10 d-inline-block p-3 rounded-circle text-success mb-2">
                                        <i class="bi bi-shield-lock fs-1"></i>
                                    </div>
                                    <h5 class="fw-bold">Bảo mật tài khoản</h5>
                                    <p class="text-muted small">Vui lòng nhập mật khẩu cũ và mới để thay đổi.</p>
                                </div>

                                <c:if test="${not empty err}">
                                    <div class="alert alert-danger border-0 bg-danger bg-opacity-10 text-danger mb-3">
                                        <i class="bi bi-exclamation-circle me-2"></i>${err}
                                    </div>
                                </c:if>

                                <c:if test="${not empty success}">
                                    <div class="alert alert-success border-0 bg-success bg-opacity-10 text-success mb-3">
                                        <i class="bi bi-check-circle me-2"></i>${success}
                                    </div>
                                </c:if>

                                <form method="post" action="${pageContext.request.contextPath}/admin/changePassword">
                                    <div class="mb-3">
                                        <label class="form-label fw-bold small text-muted">Mật khẩu hiện tại</label>
                                        <div class="input-group">
                                            <span class="input-group-text bg-white"><i class="bi bi-key"></i></span>
                                            <input type="password" name="currentPassword" class="form-control" required>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label fw-bold small text-muted">Mật khẩu mới</label>
                                        <input type="password" name="newPassword" class="form-control" required>
                                    </div>
                                    <div class="mb-4">
                                        <label class="form-label fw-bold small text-muted">Xác nhận mật khẩu mới</label>
                                        <input type="password" name="confirmPassword" class="form-control" required>
                                    </div>
                                    <button class="btn btn-success w-100 py-2 fw-bold">Cập nhật mật khẩu</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                  <div class="tab-pane fade fade-in-up" id="content-banner" role="tabpanel">
                  <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold m-0 text-success">
            <i class="bi bi-megaphone-fill me-2"></i>Quản lý Banner Quảng cáo
        </h3>
        <button class="btn btn-success shadow-sm" data-bs-toggle="modal" data-bs-target="#modalAddAd">
            <i class="bi bi-plus-lg me-1"></i> Thêm Banner mới
        </button>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white border-bottom py-3">
            <h5 class="mb-0 fw-bold text-secondary">Banner đang hoạt động (${fn:length(ads)})</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="bg-light">
                        <tr>
                            <th width="50" class="ps-3">ID</th>
                            <th>Banner & Tiêu đề</th>
                            <th width="120">Đối tượng</th>
                            <th width="150">Vị trí</th>
                            <th width="100">Trạng thái</th>
                            <th width="100">Clicks/Views</th>
                            <th width="180" class="text-center pe-3">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ad" items="${ads}">
                            <tr>
                                <td class="ps-3 fw-bold">${ad.id}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${ad.imageUrl}" alt="${ad.title}" 
                                             style="width: 80px; height: 50px; object-fit: cover; border-radius: 4px;" 
                                             class="me-3 shadow-sm">
                                        <div>
                                            <div class="fw-bold text-dark" title="${ad.title}">${fn:substring(ad.title, 0, 30)}...</div>
                                            <small class="text-muted"><i class="bi bi-link"></i> ${fn:substring(ad.targetUrl, 0, 25)}...</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge ${ad.targetAudience == 'VIP' ? 'bg-info' : ad.targetAudience == 'FREE' ? 'bg-primary' : 'bg-secondary'} px-2 py-1">
                                        ${ad.targetAudience}
                                    </span>
                                </td>
                                <td>
                                    <span class="badge bg-success bg-opacity-10 text-success border border-success">
                                        ${ad.position}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${ad.isActive}">
                                            <span class="badge bg-success text-white">Đang chạy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger text-white">Đã ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <small class="d-block text-primary">${ad.clicksCount} Clicks</small>
                                    <small class="d-block text-muted">${ad.viewsCount} Views</small>
                                </td>
                          <td class="text-center pe-3">
                                    <%-- Nút Sửa (Gọi hàm JS để mở Modal) --%>
                                    <button class="btn btn-sm btn-outline-warning me-1" title="Chỉnh sửa"
                                            data-bs-toggle="modal" data-bs-target="#modalEditAd" 
                                            onclick="openEditAdModal(
                                                '${ad.id}', 
                                                '${ad.title}', 
                                                '${ad.imageUrl}', 
                                                '${ad.targetUrl}', 
                                                '${ad.position}', 
                                                '${ad.targetAudience}', 
                                                '${ad.isActive}', 
                                                '${ad.startDate}', 
                                                '${ad.endDate}')">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                    
                                    <%-- Nút Bật/Tắt (Gọi ToggleAdStatusController) --%>
                                    <a href="${pageContext.request.contextPath}/admin/toggleAdStatus?id=${ad.id}&isActive=${ad.isActive ? '0' : '1'}" 
                                       class="btn btn-sm ${ad.isActive ? 'btn-outline-danger' : 'btn-outline-success'} me-1" 
                                       title="${ad.isActive ? 'Tắt banner này' : 'Bật banner này'}">
                                        <i class="bi ${ad.isActive ? 'bi-power' : 'bi-check-circle'}"></i>
                                    </a>

                                    <%-- Nút Xóa (Gọi DeleteAdController) --%>
                                    <a href="${pageContext.request.contextPath}/admin/deleteAd?id=${ad.id}" 
                                       class="btn btn-sm btn-outline-secondary" title="Xóa vĩnh viễn"
                                       onclick="return confirm('Xác nhận XÓA VĨNH VIỄN Banner: ${ad.title}?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty ads}">
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">
                                    <i class="bi bi-cloud-slash fs-4 d-block mb-2"></i>
                                    Hiện chưa có banner nào được tạo.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
   
    
    
    <%-- ==========================================================
         MODAL THÊM BANNER MỚI (CREATE)
         ========================================================== --%>
    <div class="modal fade" id="modalAddAd" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin/createAd" method="post">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title fw-bold"><i class="bi bi-plus-lg me-2"></i>Thêm Banner Quảng cáo</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label fw-bold small">Tiêu đề Banner</label>
                                <input type="text" name="title" class="form-control" placeholder="Tên nội bộ (ví dụ: Ad-Sidebar-Tiki)..." required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Link Hình ảnh (Image URL)</label>
                                <input type="url" name="imageUrl" class="form-control" placeholder="https://..." required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Link đích (Target URL)</label>
                                <input type="url" name="targetUrl" class="form-control" placeholder="https://..." required>
                            </div>
                            
                            <div class="col-md-4">
                                <label class="form-label fw-bold small">Vị trí hiển thị</label>
                                <select name="position" class="form-select" required>
                                    <option value="SIDEBAR_TOP">SIDEBAR_TOP (Trên cùng cột phải)</option>
                                    <option value="IN_CONTENT_1">IN_CONTENT_1 (Giữa bài viết)</option>
                                    <option value="SIDEBAR_BOTTOM">SIDEBAR_BOTTOM (Dưới cùng cột phải)</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold small">Đối tượng xem</label>
                                <select name="targetAudience" class="form-select" required>
                                    <option value="FREE">FREE (Chỉ User thường)</option>
                                    <option value="VIP">VIP (Chỉ User Premium)</option>
                                    <option value="ALL">ALL (Tất cả User)</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold small">Ngày kết thúc (Tùy chọn)</label>
                                <input type="date" name="endDate" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button class="btn btn-success px-4" type="submit">Lưu & Bật Banner</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <%-- ==========================================================
         MODAL CHỈNH SỬA BANNER (UPDATE)
         (Chỉnh sửa dùng JavaScript để điền dữ liệu)
         ========================================================== --%>
    <div class="modal fade" id="modalEditAd" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin/updateAd" method="post">
                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Chỉnh sửa Banner</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="id" id="editAdId">
                        <div class="row g-3">
                             <div class="col-12">
                                <label class="form-label fw-bold small">Tiêu đề Banner</label>
                                <input type="text" name="title" id="editAdTitle" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Link Hình ảnh (Image URL)</label>
                                <input type="url" name="imageUrl" id="editAdImageUrl" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold small">Link đích (Target URL)</label>
                                <input type="url" name="targetUrl" id="editAdTargetUrl" class="form-control" required>
                            </div>
                            
                            <div class="col-md-4">
                                <label class="form-label fw-bold small">Vị trí hiển thị</label>
                                <select name="position" id="editAdPosition" class="form-select" required>
                                    <option value="SIDEBAR_TOP">SIDEBAR_TOP (Trên cùng)</option>
                                    <option value="IN_CONTENT_1">IN_CONTENT_1 (Giữa bài viết)</option>
                                    <option value="SIDEBAR_BOTTOM">SIDEBAR_BOTTOM (Dưới cùng)</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold small">Đối tượng xem</label>
                                <select name="targetAudience" id="editAdTargetAudience" class="form-select" required>
                                    <option value="FREE">FREE (Chỉ User thường)</option>
                                    <option value="VIP">VIP (Chỉ User Premium)</option>
                                    <option value="ALL">ALL (Tất cả User)</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold small">Ngày kết thúc</label>
                                <input type="date" name="endDate" id="editAdEndDate" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button class="btn btn-warning px-4" type="submit">Cập nhật Banner</button>
                    </div>
                </form>
            </div>
        </div>
                </div>
                
           

            </div> </div> <footer class="text-center">
            <p class="m-0">&copy; 2025 Dan Tri Admin Panel. Designed for performance.</p>
        </footer>
    </div>
    
    <div class="modal fade" id="payoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header bg-success text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-cash-coin me-2"></i>Thanh toán cho Editor</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="payoutForm" action="${pageContext.request.contextPath}/admin/confirmPayout" method="post">
                    <input type="hidden" name="editorId" id="payoutEditorId">
                    <input type="hidden" name="amount" id="payoutAmountInput">
                    
                    <div class="mb-3 text-center">
                        <p class="text-muted mb-1">Người nhận</p>
                        <h4 class="fw-bold text-success" id="payoutEditorName">User Name</h4>
                        <div class="fs-4 fw-bold text-dark" id="payoutAmountDisplay">0 ₫</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">Ngân hàng thụ hưởng</label>
                        <select class="form-select" id="bankSelect" name="bankName" required onchange="generateQR()">
                            <option value="MB">MB Bank</option>
                            <option value="VCB">Vietcombank</option>
                            <option value="ACB">ACB</option>
                            <option value="BIDV">BIDV</option>
                            <option value="CTG">VietinBank</option>
                            <option value="TCB">Techcombank</option>
                            <option value="VPB">VPBank</option>
                            <option value="TPB">TPBank</option>
                            </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold small text-muted">Số tài khoản nhận</label>
                        <input type="text" class="form-control" id="bankAccount" name="bankAccount" 
                               placeholder="Nhập số tài khoản Editor" required oninput="generateQR()">
                    </div>

                    <div class="text-center mt-4 p-3 bg-light rounded" id="qrContainer" style="display:none;">
                        <p class="small text-muted mb-2">Quét mã để thanh toán ngay</p>
                        <img id="qrImage" src="" class="img-fluid rounded shadow-sm" style="max-height: 250px;">
                        <p class="small text-danger mt-2 fst-italic">*Admin vui lòng kiểm tra kỹ tên chủ tài khoản trên App ngân hàng trước khi chuyển.</p>
                    </div>

                    <div class="modal-footer border-0 px-0 pb-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success fw-bold">
                            <i class="bi 3bi-check-circle-fill me-2"></i>Xác nhận đã chuyển
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>    
    
    <c:if test="${not empty errCategory}">
        <script>
            Swal.fire({
                icon: 'error',
                title: 'Thất bại',
                text: '${errCategory}',
                confirmButtonColor: '#059669'
            });
        </script>
    </c:if>

    <c:if test="${not empty successCategory}">
        <script>
            Swal.fire({
                icon: 'success',
                title: 'Thành công',
                text: '${successCategory}',
                confirmButtonColor: '#059669'
            });
        </script>
    </c:if>
<script>

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
})
    // ---------------------------------------------------------
    // 1. Cấu hình Biểu đồ Cột (View Count)
    // ---------------------------------------------------------
    
    // Lấy dữ liệu từ JSTL (Server) -> JS Array
    const viewLabels = [
        <c:forEach var="v" items="${topViewed}" varStatus="loop">
            "${v.title}"${!loop.last ? ',' : ''}
        </c:forEach>
    ];
    
    const viewData = [
        <c:forEach var="v" items="${topViewed}" varStatus="loop">
            ${v.viewCount}${!loop.last ? ',' : ''}
        </c:forEach>
    ];
    
    

    // Vẽ biểu đồ
    const ctxView = document.getElementById('viewChart').getContext('2d');
    new Chart(ctxView, {
        type: 'bar',
        data: {
            labels: viewLabels,
            datasets: [{
                label: 'Lượt xem',
                data: viewData,
                backgroundColor: 'rgba(16, 185, 129, 0.6)', // Màu xanh Emerald (nhạt)
                borderColor: 'rgba(16, 185, 129, 1)',       // Màu xanh Emerald (đậm)
                borderWidth: 1,
                borderRadius: 5
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false } // Ẩn chú thích vì chỉ có 1 cột
            },
            scales: {
                y: { beginAtZero: true, grid: { color: '#f3f4f6' } },
                x: { grid: { display: false }, ticks: { autoSkip: false, maxRotation: 45, minRotation: 45 } } // Xoay nhãn nếu dài
            }
        }
    });

    // ---------------------------------------------------------
    // 2. Cấu hình Biểu đồ Tròn (Like Count)
    // ---------------------------------------------------------
    
    const likeLabels = [
        <c:forEach var="title" items="${likedTitles}" varStatus="loop">
            "${title}"${!loop.last ? ',' : ''}
        </c:forEach>
    ];

    const likeData = [
        <c:forEach var="count" items="${likedCounts}" varStatus="loop">
            ${count}${!loop.last ? ',' : ''}
        </c:forEach>
    ];
    
 // 1. Hàm tiện ích xóa dấu Tiếng Việt (BẮT BUỘC PHẢI CÓ ĐỂ TẠO LINK QR)
    function removeVietnameseTones(str) {
        if (!str) return "";
        str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, "a");
        str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, "e");
        str = str.replace(/ì|í|ị|ỉ|ĩ/g, "i");
        str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, "o");
        str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, "u");
        str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, "y");
        str = str.replace(/đ/g, "d");
        str = str.replace(/À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ/g, "A");
        str = str.replace(/È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ/g, "E");
        str = str.replace(/Ì|Í|Ị|Ỉ|Ĩ/g, "I");
        str = str.replace(/Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ/g, "O");
        str = str.replace(/Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ/g, "U");
        str = str.replace(/Ỳ|Ý|Ỵ|Ỷ|Ỹ/g, "Y");
        str = str.replace(/Đ/g, "D");
        return str;
    }

    // 2. Hàm mở Modal (Logic chính)
    function openPayoutModal(id, name, amount, bankCode, bankAcc, bankName) {
        // Reset form để tránh lưu cache cũ
        document.getElementById('payoutForm').reset();
        document.getElementById('qrContainer').style.display = 'none';

        // Điền dữ liệu cơ bản
        document.getElementById('payoutEditorId').value = id;
        document.getElementById('payoutEditorName').innerText = name;
        document.getElementById('payoutAmountInput').value = amount;

        // Format tiền tệ hiển thị
        let formattedAmount = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
        document.getElementById('payoutAmountDisplay').innerText = formattedAmount;

        // CHECK WORKFLOW:
        // Kiểm tra xem Editor có đủ thông tin ngân hàng không (BankCode và Số TK không được rỗng hoặc null)
        if (bankCode && bankCode.trim() !== "" && bankAcc && bankAcc.trim() !== "") {
            
            // Gán giá trị vào form
            let bankSelect = document.getElementById('bankSelect');
            bankSelect.value = bankCode;
            document.getElementById('bankAccount').value = bankAcc;

            // FIX LỖI SELECT: Nếu gán bankCode vào mà Select vẫn rỗng (do bankCode trong DB không khớp value trong option)
            // Ví dụ: DB lưu "MB Bank" nhưng option value là "MB"
            if (bankSelect.value === "") {
                console.warn("Mã ngân hàng không khớp, đang thử tìm kiếm gần đúng...");
                // Thử tìm option nào chứa text tương tự
                for (let i = 0; i < bankSelect.options.length; i++) {
                    if (bankSelect.options[i].text.includes(bankCode) || bankCode.includes(bankSelect.options[i].value)) {
                        bankSelect.selectedIndex = i;
                        break;
                    }
                }
            }

            // Gọi hàm tạo QR NGAY LẬP TỨC với dữ liệu đã có
            // (Truyền tham số trực tiếp để đảm bảo không bị lỗi đọc DOM chậm)
            generateQR(bankSelect.value, bankAcc, amount, name);
            
        } else {
            // Nếu chưa có thông tin -> Reset form để Admin nhập tay
            document.getElementById('bankSelect').value = "";
            document.getElementById('bankAccount').value = "";
            console.log("Editor chưa có thông tin ngân hàng đầy đủ.");
        }

        // Hiển thị Modal
        var myModal = new bootstrap.Modal(document.getElementById('payoutModal'));
        myModal.show();
    }

    // 3. Hàm tạo QR Code (Đã nâng cấp để nhận tham số hoặc tự đọc DOM)
    function generateQR(argBank, argAcc, argAmount, argName) {
        // Ưu tiên lấy từ tham số truyền vào, nếu không có thì đọc từ DOM (trường hợp Admin nhập tay và onchange)
        let bank = argBank || document.getElementById('bankSelect').value;
        let account = argAcc || document.getElementById('bankAccount').value;
        let amount = argAmount || document.getElementById('payoutAmountInput').value;
        let name = argName || document.getElementById('payoutEditorName').innerText;

        // Validate dữ liệu trước khi gọi API
        if (bank && account && account.length > 3) {
            // Xử lý nội dung chuyển khoản: "Luong UserABC"
            let cleanName = removeVietnameseTones(name).replace(/[^a-zA-Z0-9 ]/g, ""); // Chỉ giữ lại chữ và số
            let desc = "Luong " + cleanName;
            desc = desc.replace(/\s+/g, '%20'); // Encode URL space

            // API VietQR Quick Link
let qrUrl = `https://img.vietqr.io/image/\${bank}-\${account}-compact.png?amount=\${amount}&addInfo=\${desc}`;


            console.log("Generating QR: " + qrUrl); // Debug log

            let img = document.getElementById('qrImage');
            
            // Thêm timestamp để tránh cache ảnh cũ
            img.src = qrUrl;
            
            // Hiển thị khung QR
            document.getElementById('qrContainer').style.display = 'block';
        } else {
            console.log("Thiếu thông tin để tạo QR");
            document.getElementById('qrContainer').style.display = 'none';
        }
    }

    const ctxLike = document.getElementById('likeChart').getContext('2d');
    new Chart(ctxLike, {
        type: 'doughnut',
        data: {
            labels: likeLabels,
            datasets: [{
                data: likeData,
                backgroundColor: [
                    '#10b981', // Xanh chủ đạo
                    '#3b82f6', // Xanh dương
                    '#f59e0b', // Vàng
                    '#ef4444', // Đỏ
                    '#8b5cf6'  // Tím
                ],
                borderWidth: 0,
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: { boxWidth: 12, font: { size: 11 } }
                }
            },
            cutout: '70%' // Độ rỗng giữa biểu đồ
        }
    });
    
    function confirmLogout() {
        Swal.fire({
            title: 'Đăng xuất?',
            text: "Bạn có chắc chắn muốn thoát khỏi hệ thống không?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33', // Màu đỏ cho nút đăng xuất
            cancelButtonColor: '#3085d6', // Màu xanh cho nút hủy
            confirmButtonText: 'Đăng xuất ngay',
            cancelButtonText: 'Hủy bỏ'
        }).then((result) => {
            if (result.isConfirmed) {
                // Chuyển hướng đến Servlet xử lý đăng xuất
                window.location.href = '${pageContext.request.contextPath}/logout';
            }
        });
    }
    
    const video = document.getElementById('markerVideo');
    const display = document.getElementById('currentTimeDisplay');
    const startInput = document.getElementById('startTimeInput');
    const endInput = document.getElementById('endTimeInput');

    // Hiển thị thời gian video theo thời gian thực (real-time)
    video.ontimeupdate = function() {
        const time = Math.floor(video.currentTime);
        display.innerText = time;
    };

    // Chốt giây bắt đầu
    function markStart() {
        startInput.value = Math.floor(video.currentTime);
        // Hiệu ứng nhấp nháy xanh để báo hiệu đã chốt
        startInput.classList.add('is-valid');
    }

    // Chốt giây kết thúc
    function markEnd() {
        endInput.value = Math.floor(video.currentTime);
        // Hiệu ứng nhấp nháy đỏ để báo hiệu đã chốt
        endInput.classList.add('is-invalid');
    }
    
 // Hàm mở modal chỉnh sửa và điền dữ liệu cũ (Dùng cho Modal Edit)
    function openEditAdModal(id, title, imageUrl, targetUrl, position, targetAudience, isActive, startDate, endDate) {
        document.getElementById('editAdId').value = id;
        document.getElementById('editAdTitle').value = title;
        document.getElementById('editAdImageUrl').value = imageUrl;
        document.getElementById('editAdTargetUrl').value = targetUrl;
        document.getElementById('editAdPosition').value = position;
        document.getElementById('editAdTargetAudience').value = targetAudience;
        
        // Chuyển đổi Date (cần xử lý định dạng yyyy-MM-dd cho input type="date")
        
        // Lưu ý: JavaScript cần format Date lại. Giả sử startDate/endDate là chuỗi ISO 8601 từ Java.
        const formatDate = (dateString) => {
            if (!dateString || dateString === 'null') return '';
            
            // Giả định dateString là Date object toString() từ Java: "Dec 14, 2025 12:00:00 AM"
            // Cách đơn giản nhất là chuyển đổi sang format yyyy-MM-dd nếu bạn dùng Java String
            try {
                const date = new Date(dateString);
                const yyyy = date.getFullYear();
                const mm = String(date.getMonth() + 1).padStart(2, '0'); // Tháng tính từ 0
                const dd = String(date.getDate()).padStart(2, '0');
                return `${yyyy}-${mm}-${dd}`;
            } catch (e) {
                console.error("Lỗi format ngày:", e);
                return '';
            }
        };

        document.getElementById('editAdEndDate').value = formatDate(endDate);
    }
 
    function editProduct(id, name, start, end, url, price) {
        // Thay đổi tiêu đề form và hành động để Admin biết đang sửa
        document.querySelector('.card-header.bg-success').innerText = "Cập nhật sản phẩm (ID: " + id + ")";
        
        // Điền dữ liệu vào các ô input
        document.getElementsByName('productName')[0].value = name;
        document.getElementById('startTimeInput').value = start;
        document.getElementById('endTimeInput').value = end;
        document.getElementsByName('affiliateUrl')[0].value = url;
        document.getElementsByName('priceDisplay')[0].value = price;
        
        // Thêm một input ẩn để lưu ID khi submit
        let idInput = document.getElementById('editProductId');
        if(!idInput) {
            idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'productId';
            idInput.id = 'editProductId';
            document.querySelector('form').appendChild(idInput);
        }
        idInput.value = id;

        // Cuộn lên form
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
    
    function updateClock() {
        const now = new Date();

        // 1. Xử lý Ngày tháng
        const day = String(now.getDate()).padStart(2, '0');
        const month = String(now.getMonth() + 1).padStart(2, '0'); // Tháng bắt đầu từ 0
        const year = now.getFullYear();
        const dateString = day + '/' + month + '/' + year;

        // 2. Xử lý Giờ phút giây
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const seconds = String(now.getSeconds()).padStart(2, '0');
        const timeString = hours + ':' + minutes + ':' + seconds;

        // 3. Gán vào HTML
        const dateEl = document.getElementById('realtime-date');
        const clockEl = document.getElementById('realtime-clock');
        
        if(dateEl) dateEl.innerText = dateString;
        if(clockEl) clockEl.innerText = timeString;
    }

    // Gọi hàm ngay lập tức để không bị delay 1 giây đầu tiên
    updateClock();
    // Cập nhật mỗi 1000ms (1 giây)
    setInterval(updateClock, 1000);
</script>


</body>
</html>