<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết người dùng | Admin Panel</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <style>
        :root {
            --primary-color: #10b981;       /* Emerald 500 */
            --primary-dark: #047857;        /* Emerald 700 */
            --primary-light: #d1fae5;       /* Emerald 100 */
            --bg-body: #f3f4f6;             /* Gray 100 */
            --text-dark: #1f2937;           /* Gray 800 */
            --text-gray: #6b7280;           /* Gray 500 */
            --white: #ffffff;
            --shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-body);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .profile-card {
            background: var(--white);
            border-radius: 16px;
            box-shadow: var(--shadow);
            max-width: 700px;
            width: 100%;
            overflow: hidden;
            border: none;
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            padding: 30px;
            text-align: center;
            color: var(--white);
            position: relative;
        }

        .avatar-circle {
            width: 100px;
            height: 100px;
            background-color: var(--white);
            color: var(--primary-dark);
            border-radius: 50%;
            font-size: 2.5rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            border: 4px solid rgba(255,255,255,0.3);
            text-transform: uppercase;
        }

        .user-role-badge {
            background-color: rgba(255, 255, 255, 0.2);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
            backdrop-filter: blur(5px);
        }

        .card-body-custom {
            padding: 40px;
        }

        .info-group {
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-group:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }

        .info-label {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-gray);
            margin-bottom: 5px;
            font-weight: 600;
        }

        .info-value {
            font-size: 1.1rem;
            font-weight: 500;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .status-active {
            color: var(--primary-color);
            background: var(--primary-light);
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .status-inactive {
            color: #dc2626;
            background: #fee2e2;
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 25px;
            background-color: transparent;
            color: var(--text-gray);
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            margin-top: 20px;
        }

        .btn-back:hover {
            background-color: var(--white);
            border-color: var(--primary-color);
            color: var(--primary-color);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

    <div class="profile-card">
        <div class="card-header-custom">
            <div class="avatar-circle">
                ${fn:substring(userDetail.name, 0, 1)}
            </div>
            <h3 class="m-0 fw-bold">${userDetail.name}</h3>
            <div class="mt-2">
    <c:choose>
        <%-- ROLE 3: QUẢN TRỊ VIÊN (ADMIN) --%>
        <c:when test="${userDetail.role == 3}">
            <span class="user-role-badge">
                <i class="bi bi-shield-fill-check me-1"></i>
                Quản trị viên (Admin)
            </span>
        </c:when>

        <%-- ROLE 2: CỘNG TÁC VIÊN (EDITOR) --%>
        <c:when test="${userDetail.role == 2}">
            <span class="user-role-badge">
                <i class="bi bi-pencil-square me-1"></i>
                Cộng tác viên (Editor)
            </span>
        </c:when>

        <%-- ROLE 1 (HOẶC KHÁC): NGƯỜI DÙNG (USER) --%>
        <c:otherwise>
            <span class="user-role-badge">
                <i class="bi bi-person-circle me-1"></i>
                Người dùng (User)
            </span>
        </c:otherwise>
    </c:choose>
</div>
        </div>

        <div class="card-body-custom">
            <div class="row">
                <div class="col-md-6">
                    <div class="info-group">
                        <div class="info-label"><i class="bi bi-hash me-1"></i> ID Tài khoản</div>
                        <div class="info-value">#${userDetail.id}</div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-label"><i class="bi bi-person-badge me-1"></i> Tên đăng nhập</div>
                        <div class="info-value text-primary">${userDetail.username}</div>
                    </div>

                    <div class="info-group">
                        <div class="info-label"><i class="bi bi-envelope me-1"></i> Email</div>
                        <div class="info-value">${userDetail.email}</div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="info-group">
                        <div class="info-label"><i class="bi bi-telephone me-1"></i> Số điện thoại</div>
                        <div class="info-value">${userDetail.phone != null ? userDetail.phone : '<span class="text-muted fst-italic">Chưa cập nhật</span>'}</div>
                    </div>

                    <div class="info-group">
                        <div class="info-label"><i class="bi bi-activity me-1"></i> Trạng thái</div>
                        <div class="info-value mt-1">
                            <c:choose>
                                <c:when test="${userDetail.status}">
                                    <span class="status-active"><i class="bi bi-check-circle-fill me-1"></i> Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-inactive"><i class="bi bi-slash-circle-fill me-1"></i> Đã khóa</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-center">
                <a href="${pageContext.request.contextPath}/admin/adminPanel" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>