<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký Editor</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary-color: #006837; /* Xanh Dân Trí */
            --primary-light: rgba(0, 104, 55, 0.05);
            --text-dark: #2c3e50;
            --border-color: #e2e8f0;
        }

        body {
            background-color: #f8fafc;
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /* --- Main Card Styling --- */
        .modern-card {
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.04);
            width: 100%;
            max-width: 600px;
            padding: 40px;
            position: relative;
            overflow: hidden;
        }

        /* Trang trí background nhẹ */
        .modern-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 6px;
            background: linear-gradient(90deg, var(--primary-color), #4ade80);
        }

        /* --- Header Icon --- */
        .icon-wrapper {
            width: 60px;
            height: 60px;
            background-color: var(--primary-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: var(--primary-color);
            font-size: 1.8rem;
        }

        /* --- Modern Outline Inputs (Form Floating) --- */
        .form-floating > .form-control {
            border: 1px solid var(--border-color);
            border-radius: 12px;
            background-color: #fff;
            padding-top: 1.625rem;
            padding-bottom: 0.625rem;
            font-size: 0.95rem;
        }

        .form-floating > .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px var(--primary-light);
        }

        .form-floating > label {
            color: #94a3b8;
            padding-left: 1rem;
        }

        .form-control:disabled, .form-control[readonly] {
            background-color: #f1f5f9;
            color: #64748b;
            border-color: transparent;
        }

        /* --- Button Styling --- */
        .btn-modern-outline {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 14px;
            font-weight: 600;
            border-radius: 12px;
            border: 2px solid var(--primary-color);
            background-color: transparent;
            color: var(--primary-color);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            margin-top: 10px;
        }

        .btn-modern-outline:hover {
            background-color: var(--primary-color);
            color: #fff;
            box-shadow: 0 4px 12px rgba(0, 104, 55, 0.25);
            transform: translateY(-1px);
        }

        /* --- Alert Styling --- */
        .status-box {
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
            border: 1px solid transparent;
        }
        .status-pending {
            background-color: #fffbeb;
            color: #b45309;
            border-color: #fcd34d;
        }
        .status-approved {
            background-color: #f0fdf4;
            color: #15803d;
            border-color: #86efac;
        }
        .status-rejected {
            background-color: #fef2f2;
            color: #b91c1c;
            border-color: #fca5a5;
        }

        /* Link quay lại */
        .back-link {
            text-decoration: none;
            color: #64748b;
            font-size: 0.9rem;
            display: inline-flex;
            align-items: center;
            margin-top: 20px;
            transition: color 0.2s;
        }
        .back-link:hover { color: var(--primary-color); }

    </style>
</head>

<body>

<div class="modern-card fade-in-up">
    
    <div class="text-center mb-4">
        <div class="icon-wrapper">
            <i class="bi bi-pencil-square"></i>
        </div>
        <h3 class="fw-bold" style="color: var(--text-dark);">Đăng ký Editor</h3>
        <p class="text-muted small">Trở thành người đóng góp nội dung chuyên nghiệp</p>
    </div>

    <c:choose>
        <%-- TRẠNG THÁI: ĐANG CHỜ (PENDING) --%>
        <c:when test="${requestStatus == 'pending'}">
            <div class="status-box status-pending">
                <i class="bi bi-hourglass-split fs-1 d-block mb-2"></i>
                <h5 class="fw-bold">Đang chờ xét duyệt</h5>
                <p class="mb-0 small">Yêu cầu của bạn đã được gửi đi. Vui lòng chờ quản trị viên phản hồi.</p>
            </div>
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/" class="back-link">
                    <i class="bi bi-arrow-left me-1"></i> Quay về trang chủ
                </a>
            </div>
        </c:when>

        <%-- TRẠNG THÁI: THÀNH CÔNG (APPROVED) --%>
        <c:when test="${requestStatus == 'approved'}">
            <div class="status-box status-approved">
                <i class="bi bi-check-circle-fill fs-1 d-block mb-2"></i>
                <h5 class="fw-bold">Chúc mừng!</h5>
                <p class="mb-0 small">Tài khoản của bạn đã được nâng cấp lên Editor.</p>
            </div>
            <a href="${pageContext.request.contextPath}/editor/workspace" class="btn-modern-outline bg-success text-white border-0">
                Truy cập Workspace
            </a>
        </c:when>

        <%-- TRẠNG THÁI: TỪ CHỐI (REJECTED) --%>
        <c:when test="${requestStatus == 'rejected'}">
            <div class="status-box status-rejected">
                <i class="bi bi-x-circle-fill fs-1 d-block mb-2"></i>
                <h5 class="fw-bold">Yêu cầu bị từ chối</h5>
                <p class="mb-0 small">Hồ sơ chưa đạt yêu cầu. Vui lòng cập nhật và thử lại sau.</p>
            </div>
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/" class="back-link">
                    <i class="bi bi-arrow-left me-1"></i> Quay về trang chủ
                </a>
            </div>
        </c:when>

        <%-- FORM ĐĂNG KÝ --%>
        <c:otherwise>
            <form action="role-request" method="post">
                
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="form-floating">
                            <input type="text" class="form-control" id="floatingName" value="${user.name}" readonly>
                            <label for="floatingName">Họ và tên</label>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="form-floating">
                            <input type="email" class="form-control" id="floatingEmail" value="${user.email}" readonly>
                            <label for="floatingEmail">Email đăng ký</label>
                        </div>
                    </div>

                    <div class="col-12">
                        <div class="form-floating">
                            <input type="text" name="portfolio" class="form-control" id="floatingPortfolio" placeholder="Link Portfolio">
                            <label for="floatingPortfolio"><i class="bi bi-link-45deg me-1"></i>Link Portfolio / Website cá nhân</label>
                        </div>
                    </div>

                    <div class="col-12">
                        <div class="form-floating">
                            <textarea name="experience" class="form-control" id="floatingExp" style="height: 100px" placeholder="Kinh nghiệm"></textarea>
                            <label for="floatingExp">Kinh nghiệm viết bài</label>
                        </div>
                    </div>

                    <div class="col-12">
                        <div class="form-floating">
                            <textarea name="reason" class="form-control" id="floatingReason" style="height: 100px" placeholder="Lý do"></textarea>
                            <label for="floatingReason">Tại sao bạn muốn trở thành Editor?</label>
                        </div>
                    </div>
                </div>

                <button class="btn-modern-outline mt-4" type="submit">
                    <i class="bi bi-send me-2"></i> Gửi hồ sơ đăng ký
                </button>

            </form>
            
            <div class="text-center">
                <a href="${pageContext.request.contextPath}/" class="back-link">
                    <i class="bi bi-arrow-left me-1"></i> Hủy bỏ và quay lại
                </a>
            </div>
        </c:otherwise>

    </c:choose>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>