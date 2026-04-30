<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<meta charset="UTF-8">

<style>
    /* 1. Xóa các style body dư thừa để không ảnh hưởng trang Admin Panel chính */
    #content-role {
        font-family: 'Inter', sans-serif;
    }

    /* 2. Sửa lỗi vỡ khung: Cho phép text xuống dòng và giới hạn chiều rộng cột */
    .custom-table .text-wrap-custom {
        max-width: 250px;
        white-space: normal; /* Cho phép xuống dòng */
        word-wrap: break-word;
        font-size: 14px;
        line-height: 1.5;
    }

    /* 3. Làm gọn bảng */
    .custom-table {
        background: white;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        border: none;
    }

    .custom-table thead {
        background: #f0fdf4 !important; /* Màu xanh dịu hơn */
    }
    
    .custom-table thead th {
        color: #166534;
        font-weight: 700;
        border: none;
        padding: 15px;
    }

    .badge-status {
        padding: 5px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        display: inline-block;
    }
    .badge-pending { background: #fef3c7; color: #92400e; }
    .badge-approved { background: #dcfce7; color: #166534; }
    .badge-rejected { background: #fee2e2; color: #991b1b; }

    .btn-view-custom {
        background: #22c55e;
        color: white !important;
        border-radius: 8px;
        padding: 4px 10px;
        text-decoration: none;
        transition: 0.2s;
    }
    .btn-view-custom:hover { background: #16a34a; transform: scale(1.1); }

    .portfolio-link {
        color: #166534;
        text-decoration: none;
        font-weight: 500;
        font-size: 14px;
    }
</style>

<div class="card p-3 mb-4 border-0 shadow-sm bg-light">
    <form method="get" class="row g-3 align-items-center">
        <input type="hidden" name="tab" value="role"> <div class="col-auto">
            <div class="input-group input-group-sm">
                <span class="input-group-text bg-white"><i class="bi bi-funnel"></i></span>
                <select name="status" class="form-select">
                    <option value="">Tất cả trạng thái</option>
                    <option value="0" ${param.status == '0' ? 'selected' : ''}>Pending</option>
                    <option value="1" ${param.status == '1' ? 'selected' : ''}>Approved</option>
                    <option value="2" ${param.status == '2' ? 'selected' : ''}>Rejected</option>
                </select>
            </div>
        </div>
        <div class="col-auto">
            <button class="btn btn-success btn-sm px-4 fw-bold" type="submit">Lọc</button>
        </div>
    </form>
</div>

<div class="table-responsive">
    <table class="table table-hover align-middle custom-table">
        <thead>
            <tr>
                <th width="5%">ID</th>
                <th width="15%">Người dùng</th>
                <th width="20%">Lý do</th>
                <th width="20%">Kinh nghiệm</th>
                <th width="10%">Portfolio</th>
                <th width="10%">Trạng thái</th>
                <th width="10%">Ngày tạo</th>
                <th width="10%" class="text-center">Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="r" items="${roleRequests}">
                <tr>
                    <td class="fw-bold">#${r.id}</td>
                    <td>
                        <div class="fw-bold">${r.user.name}</div>
                        <small class="text-muted">${r.user.email}</small>
                    </td>
                    <td class="text-wrap-custom">${r.reason}</td>
                    <td class="text-wrap-custom">${r.experience}</td>
                    <td>
                        <a class="portfolio-link" href="${r.portfolio}" target="_blank">
                            <i class="bi bi-link-45deg"></i> Link
                        </a>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${r.status == 0}">
                                <span class="badge-status badge-pending">Pending</span>
                            </c:when>
                            <c:when test="${r.status == 1}">
                                <span class="badge-status badge-approved">Approved</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-status badge-rejected">Rejected</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><small>${r.createAt}</small></td>
                    <td class="text-center">
                        <a href="role-request-detail?id=${r.id}" class="btn-view-custom" title="Xem chi tiết">
                            <i class="bi bi-eye-fill"></i>
                        </a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty roleRequests}">
                <tr>
                    <td colspan="8" class="text-center py-4 text-muted">Không có yêu cầu nào.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>