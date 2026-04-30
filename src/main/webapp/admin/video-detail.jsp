<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Marker Pro | Admin Video Commerce</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        :root { --primary-emerald: #059669; --bg-light: #f8fafc; }
        body { background-color: var(--bg-light); font-family: 'Inter', sans-serif; padding-bottom: 50px; }
        .detail-card { border: none; border-radius: 15px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); background: white; }
        .section-title { border-left: 4px solid var(--primary-emerald); padding-left: 15px; margin-bottom: 20px; font-weight: 700; color: #1e293b; }
        .video-container { background: #000; border-radius: 12px; overflow: hidden; min-height: 400px; position: relative; }
        .sticky-form { position: sticky; top: 20px; }
        #currentTimeDisplay { font-family: 'Courier New', Courier, monospace; font-size: 1.2rem; }
    </style>
</head>
<body>

<div class="container py-4">
    <div class="row g-4">
        <div class="col-lg-7">
            <div class="detail-card p-4 mb-4">
                <h5 class="section-title">Trình phát đánh dấu (Auto-Source)</h5>
                
                <div class="video-container shadow-sm mb-3">
                    <c:choose>
                        <%-- TRƯỜNG HỢP 1: YOUTUBE SOURCE --%>
                        <c:when test="${not empty video.getEmbedUrl()}">
                            <div id="ytPlayer"></div> <%-- YouTube API sẽ thay thế thẻ này --%>
                            <input type="hidden" id="videoType" value="YOUTUBE">
                            <input type="hidden" id="ytVideoId" value="${video.url}"> <%-- Link gốc để JS xử lý --%>
                        </c:when>
                        
                        <%-- TRƯỜNG HỢP 2: DIRECT MP4 SOURCE --%>
                        <c:otherwise>
                            <video id="markerVideo" class="w-100" height="400" controls>
                                <source src="${video.url}" type="video/mp4">
                            </video>
                            <input type="hidden" id="videoType" value="MP4">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="d-flex justify-content-between align-items-center bg-dark text-white p-3 rounded shadow-inner">
                    <div class="fw-bold">
                        <i class="bi bi-clock-history me-2 text-warning"></i>
                        THỜI GIAN: <span id="currentTimeDisplay" class="text-warning">0</span>s
                    </div>
                    <div class="btn-group">
                        <button class="btn btn-primary fw-bold" onclick="markStart()">
                            <i class="bi bi-play-fill"></i> BẮT ĐẦU
                        </button>
                        <button class="btn btn-danger fw-bold" onclick="markEnd()">
                            <i class="bi bi-stop-fill"></i> KẾT THÚC
                        </button>
                    </div>
                </div>
            </div>

            <%-- Bảng danh sách sản phẩm (Giữ nguyên như bản cũ của bạn) --%>
            <div class="detail-card p-4">
                <h5 class="section-title">Sản phẩm đã gán (${vProducts.size()})</h5>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Mốc (s)</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="p" items="${vProducts}">
                                <tr>
                                    <td class="small fw-bold">${p.productName}</td>
                                    <td><span class="badge bg-info text-dark">${p.startTime}s - ${p.endTime}s</span></td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-outline-warning" onclick="editProduct('${p.id}', '${p.productName}', ${p.startTime}, ${p.endTime}, '${p.affiliateUrl}', '${p.priceDisplay}')">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <a href="deleteVideoProduct?id=${p.id}&videoId=${video.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa?')"><i class="bi bi-trash"></i></a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="detail-card p-4 sticky-form">
                <h5 class="section-title" id="formTitle">Thêm sản phẩm mới</h5>
                <form action="addProductToVideo" method="post" id="productForm">
                    <input type="hidden" name="videoId" value="${video.id}">
                    <input type="hidden" name="productId" id="productId">
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Tên sản phẩm</label>
                        <input type="text" name="productName" id="productName" class="form-control" required>
                    </div>
                    <div class="row mb-3">
                        <div class="col-6">
                            <label class="form-label small fw-bold text-primary">Giây bắt đầu</label>
                            <input type="number" name="startTime" id="startTimeInput" class="form-control bg-light" readonly>
                        </div>
                        <div class="col-6">
                            <label class="form-label small fw-bold text-danger">Giây kết thúc</label>
                            <input type="number" name="endTime" id="endTimeInput" class="form-control bg-light" readonly>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Link mua hàng</label>
                        <input type="url" name="affiliateUrl" id="affiliateUrl" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold">Giá hiển thị</label>
                        <input type="text" name="priceDisplay" id="priceDisplay" class="form-control">
                    </div>
                    <button type="submit" class="btn btn-success w-100 fw-bold">LƯU VÀO HỆ THỐNG</button>
                    <button type="button" class="btn btn-link w-100 mt-2 text-muted" onclick="resetForm()">Làm mới form</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://www.youtube.com/iframe_api"></script>

<script>
    let player; // Biến cho YouTube Player
    const videoType = document.getElementById('videoType').value;
    const display = document.getElementById('currentTimeDisplay');
    const startInput = document.getElementById('startTimeInput');
    const endInput = document.getElementById('endTimeInput');

    // 1. KHỞI TẠO TRÌNH PHÁT
    function onYouTubeIframeAPIReady() {
        if (videoType === 'YOUTUBE') {
            // Hàm lấy ID từ URL (giống logic Java của bạn)
            const videoUrl = "${video.url}";
            let videoId = "";
            if(videoUrl.includes('v=')) videoId = videoUrl.split('v=')[1].split('&')[0];
            else if(videoUrl.includes('youtu.be/')) videoId = videoUrl.split('/').pop().split('?')[0];
            else if(videoUrl.includes('shorts/')) videoId = videoUrl.split('shorts/')[1].split('?')[0];

            player = new YT.Player('ytPlayer', {
                height: '400',
                width: '100%',
                videoId: videoId,
                events: { 'onReady': onPlayerReady }
            });
        }
    }

    // 2. LOGIC LẤY THỜI GIAN THỰC
    function onPlayerReady(event) {
        setInterval(() => {
            if (player && player.getCurrentTime) {
                display.innerText = Math.floor(player.getCurrentTime());
            }
        }, 500);
    }

    // Đối với video MP4
    const htmlVideo = document.getElementById('markerVideo');
    if (htmlVideo) {
        htmlVideo.ontimeupdate = () => {
            display.innerText = Math.floor(htmlVideo.currentTime);
        };
    }

    // 3. HÀM CHỐT GIÂY (Dùng chung cho cả 2 loại)
    function getCurrentTime() {
        if (videoType === 'YOUTUBE' && player) {
            return Math.floor(player.getCurrentTime());
        } else if (htmlVideo) {
            return Math.floor(htmlVideo.currentTime);
        }
        return 0;
    }

    function markStart() { startInput.value = getCurrentTime(); }
    function markEnd() { endInput.value = getCurrentTime(); }

    // 4. CRUD LOGIC (Giữ nguyên hàm edit và reset của bạn)
    function editProduct(id, name, start, end, url, price) {
        document.getElementById('formTitle').innerText = "Cập nhật sản phẩm #" + id;
        document.getElementById('productId').value = id;
        document.getElementById('productName').value = name;
        document.getElementById('startTimeInput').value = start;
        document.getElementById('endTimeInput').value = end;
        document.getElementById('affiliateUrl').value = url;
        document.getElementById('priceDisplay').value = price;
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function resetForm() {
        document.getElementById('formTitle').innerText = "Thêm sản phẩm mới";
        document.getElementById('productForm').reset();
        document.getElementById('productId').value = "";
    }
</script>
</body>
</html>