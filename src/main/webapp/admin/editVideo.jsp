<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa Bài viết - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root { --dantri-green: #006837; }
        .container-custom {
            max-width: 900px;
            margin: 40px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .form-label { font-weight: bold; color: #333; }
        .current-poster {
            max-height: 150px;
            width: auto;
            border-radius: 8px;
            border: 1px solid #ddd;
            object-fit: cover;
        }
    </style>
</head>

<body>
    
    <div class="container container-custom">
        <h2 class="fw-bold mb-4 text-center text-success">
            <i class="bi bi-pencil-square me-2"></i> Chỉnh Sửa Bài Viết
        </h2>
        <h6 class="text-center text-muted mb-4">ID: ${videoToEdit.id} - ${videoToEdit.title}</h6>
        
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/editVideo" method="post" enctype="multipart/form-data">
            
            <input type="hidden" name="id" value="${videoToEdit.id}"> 

            <div class="row g-4">
                <div class="col-12">
                    <label class="form-label">Tiêu đề</label>
                    <input type="text" name="title" class="form-control" 
                           placeholder="Nhập tiêu đề video..." value="${videoToEdit.title}" required>
                </div>
                
                <div class="col-12">
                    <label class="form-label">Mô tả</label>
                    <textarea name="desc" class="form-control" rows="4" 
                              placeholder="Mô tả chi tiết..." required>${videoToEdit.desc}</textarea>
                </div>
                
                <div class="col-md-6">
                    <label class="form-label">Link Youtube / Video URL</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-link"></i></span>
                        <input type="text" name="url" class="form-control" 
                               placeholder="https://..." value="${videoToEdit.url}" required>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <label class="form-label">Danh mục</label>
                    <select name="catId" class="form-select" required>
                        <option value="" disabled>-- Chọn danh mục --</option>
                        
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.id}" ${videoToEdit.category.id == c.id ? 'selected' : ''}>
                                ${c.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="col-md-6">
                    <div class="form-check pt-4">
                        <input class="form-check-input" type="checkbox" name="isPremium" id="isPremiumCheck" value="true" 
                               ${videoToEdit.premium ? 'checked' : ''}>
                        <label class="form-check-label fw-bold text-danger" for="isPremiumCheck">
                            <i class="bi bi-star-fill me-1 text-warning"></i> Đánh dấu bài viết Premium
                        </label>
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Poster Hiện Tại</label>
                    <div>
                        <img src="${videoToEdit.poster}" alt="Poster hiện tại" class="current-poster">
                    </div>
                </div>
                
                <div class="col-12">
                    <label class="form-label">Poster Mới (Nếu muốn thay đổi)</label>
                    <input type="file" class="form-control" name="poster" accept="image/*">
                    <small class="text-muted fst-italic">Nếu không chọn file mới, ảnh cũ sẽ được giữ lại.</small>
                </div>
            </div>
            
            <div class="mt-5 d-flex justify-content-between">
                <a href="${pageContext.request.contextPath}/admin/adminPanel?tab=post" class="btn btn-secondary px-4">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>
                <button type="submit" class="btn btn-warning px-5 fw-bold">
                    <i class="bi bi-upload"></i> Cập Nhật Bài Viết
                </button>
            </div>
        </form>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>