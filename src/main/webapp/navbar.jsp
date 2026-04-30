<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="Utils.Utils" %>
<%@ page import="Entities.User" %>
<%@ page import="Entities.Notification" %>
<%@ page import="Services.UserServices" %>
<%@ page import="Services.NotificationServices" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dân Trí - Navbar</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">

    <style>
        /* GIỮ NGUYÊN CSS CŨ CỦA BẠN (Root, Navbar Styles, Search Bar...) */
        :root {
            --primary-color: #006837;
            --primary-hover: #004d29;
            --text-color: #333;
            --light-bg: #f8f9fa;
            --border-color: #e9ecef;
        }

        body {
            font-family: 'Roboto', sans-serif;
            padding-top: 130px; 
        }

        .navbar-custom {
            background-color: #ffffff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            padding: 12px 0;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        /* --- CSS MỚI CHO KHỐI THỜI TIẾT --- */
        .weather-widget {
            display: flex;
            align-items: center;
            font-size: 14px;
            color: #666;
            margin-right: auto; /* Đẩy search sang phải */
            margin-left: 20px;
            padding-left: 20px;
            border-left: 1px solid #ddd; /* Đường gạch dọc ngăn cách */
            height: 40px;
            line-height: 1.2;
        }

        .weather-location {
            color: #2a7da3; /* Màu xanh giống hình mẫu */
            font-weight: 500;
            display: block;
        }

        .weather-date {
            color: #666;
            font-size: 13px;
        }

        .weather-temp {
            font-size: 24px;
            font-weight: 400;
            color: #333;
            margin-left: 15px;
            padding-left: 15px;
            border-left: 1px solid #ddd;
            display: flex;
            align-items: center;
        }
        
        @media (max-width: 991px) {
            .weather-widget { display: none; } /* Ẩn trên mobile */
            .navbar-brand { margin-right: 0; }
        }

        /* --- GIỮ NGUYÊN CÁC CSS KHÁC (Search, Notification, Category...) --- */
        .navbar-brand {
            font-size: 32px;
            font-weight: 800;
            color: var(--primary-color) !important;
            letter-spacing: -1px;
            margin-right: 10px; /* Giảm margin để nhường chỗ cho weather */
        }
        
        .search-container {
            position: relative;
            width: 100%;
            max-width: 400px; /* Giảm width search một chút */
        }
        
        /* ... Paste lại toàn bộ CSS cũ của bạn ở đây ... */
        .search-input { border-radius: 50px; border: 1px solid var(--border-color); padding: 10px 20px 10px 45px; background-color: var(--light-bg); transition: all 0.3s ease; font-size: 15px; }
        .search-input:focus { background-color: #fff; border-color: var(--primary-color); box-shadow: 0 0 0 3px rgba(0, 104, 55, 0.1); }
        .search-icon { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #999; pointer-events: none; }
        .btn-notification { position: relative; border: none; background: transparent; color: var(--text-color); font-size: 1.4rem; padding: 5px 10px; transition: color 0.3s; }
        .btn-notification:hover { color: var(--primary-color); }
        .notification-badge { position: absolute; top: 0; right: 0; background-color: #dc3545; color: white; font-size: 0.65rem; font-weight: bold; padding: 2px 5px; border-radius: 10px; border: 2px solid white; }
        .noti-item { display: flex; align-items: start; padding: 15px; border-bottom: 1px solid #f1f1f1; transition: background 0.2s; text-decoration: none; color: inherit; }
        .noti-item:hover { background-color: #f8f9fa; }
        .noti-item.unread { background-color: #e8f5e9; }
        .noti-avatar { width: 40px; height: 40px; border-radius: 50%; object-fit: cover; margin-right: 12px; }
        .noti-content p { margin: 0; font-size: 14px; line-height: 1.4; }
        .noti-time { font-size: 11px; color: #888; margin-top: 4px; display: block; }
        .noti-icon-type { font-size: 12px; margin-right: 5px; }
        .action-btn { padding: 8px 20px; border-radius: 50px; font-weight: 500; text-decoration: none; transition: all 0.3s ease; font-size: 15px; display: inline-flex; align-items: center; gap: 8px; }
        .btn-outline-green { color: var(--primary-color); border: 2px solid var(--primary-color); background: transparent; }
        .btn-outline-green:hover { background-color: var(--primary-color); color: white; }
        .btn-green-fill { background-color: var(--primary-color); color: white; border: 2px solid var(--primary-color); box-shadow: 0 4px 6px rgba(0, 104, 55, 0.2); }
        .btn-green-fill:hover { background-color: var(--primary-hover); border-color: var(--primary-hover); transform: translateY(-1px); }
        .user-profile-link { color: var(--text-color); font-weight: 600; text-decoration: none; display: flex; align-items: center; gap: 8px; padding: 5px 10px; border-radius: 8px; transition: background 0.2s; }
        .user-profile-link:hover { background-color: var(--light-bg); color: var(--primary-color); }
        .category-wrapper { background-color: #fff; border-bottom: 2px solid #f0f0f0; position: sticky; top: 74px; z-index: 990; width: 100%; }
        .category-container { display: flex; align-items: center; height: 50px; max-width: 1320px; margin: 0 auto; }
        .category-scroll-view { display: flex; align-items: center; overflow-x: auto; overflow-y: hidden; white-space: nowrap; flex-grow: 1; height: 100%; scrollbar-width: none; -ms-overflow-style: none; padding-right: 15px; }
        .category-scroll-view::-webkit-scrollbar { display: none; }
        .cat-link { color: #444; font-weight: 600; font-size: 14px; text-transform: uppercase; text-decoration: none; padding: 0 15px; height: 50px; line-height: 50px; position: relative; transition: color 0.2s; display: inline-block; flex-shrink: 0; }
        .cat-link:hover, .cat-link.active { color: var(--primary-color); }
        .cat-link::after { content: ''; position: absolute; bottom: -2px; left: 50%; width: 0; height: 3px; background-color: var(--primary-color); transition: all 0.3s ease; transform: translateX(-50%); }
        .cat-link:hover::after, .cat-link.active::after { width: 100%; }
        .home-icon-wrapper { border-right: 1px solid #eee; margin-right: 5px; padding-right: 15px; display: flex; align-items: center; height: 30px; flex-shrink: 0; }
        .btn-all-cats { border: none; background: #fff; color: #444; font-weight: 700; text-transform: uppercase; font-size: 14px; height: 50px; padding: 0 20px; border-left: 1px solid #eee; transition: all 0.3s; display: flex; align-items: center; cursor: pointer; }
        .btn-all-cats:hover { color: var(--primary-color); background-color: #f8f9fa; }
        .cat-modal-item { display: block; padding: 12px 15px; background-color: #f8f9fa; border-radius: 8px; color: #333; text-decoration: none; font-weight: 500; transition: all 0.2s ease; border: 1px solid transparent; text-align: center; }
        .cat-modal-item:hover { background-color: #fff; color: var(--primary-color); border-color: var(--primary-color); box-shadow: 0 4px 10px rgba(0, 104, 55, 0.1); transform: translateY(-2px); }
        .cat-modal-item.active { background-color: var(--primary-color); color: #fff; }
        @media (max-width: 991px) { .category-wrapper { top: 0; position: relative; } .btn-all-cats { padding: 0 10px; font-size: 13px; } .btn-all-cats-wrapper { display: none; } }
    </style>
</head>
<body>

<%
    // Logic Session User giữ nguyên
    User currentUser = (User) session.getAttribute("user");
    List<Notification> notifications = null;
    int unreadCount = 0;
    if (currentUser != null) {
        try {
            notifications = NotificationServices.getTopNotifications(currentUser.getId());
            if(notifications != null) {
                for(Notification n : notifications) {
                    if(!n.isRead()) unreadCount++;
                }
            }
        } catch(Exception e) { e.printStackTrace(); }
    }
%>

<nav class="navbar navbar-expand-lg navbar-custom">
    <div class="container-xxl d-flex align-items-center">
        
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">DÂN TRÍ</a>

        <div class="weather-widget d-none d-lg-flex" id="weatherWidget">
            <div class="text-start">
                <span class="weather-location" id="userLocation">Đang tải...</span>
                <span class="weather-date" id="currentDate">...</span>
            </div>
            <div class="weather-temp" id="weatherTemp">--°C</div>
        </div>

        <button class="navbar-toggler ms-auto" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse justify-content-end" id="navbarContent">
            
            <form class="search-container mx-3 my-2 my-lg-0" 
                  action="${pageContext.request.contextPath}/search" 
                  method="get">
                <i class="bi bi-search search-icon"></i>
                <input class="form-control search-input" 
                       type="search" 
                       name="q" 
                       placeholder="Tìm kiếm tin tức..." 
                       aria-label="Search">
            </form>

            <div class="d-flex align-items-center gap-3 mt-3 mt-lg-0">
                <%-- Phần nút thông báo và đăng nhập giữ nguyên --%>
                <% if (currentUser != null) { %>
                    <button class="btn-notification" data-bs-toggle="modal" data-bs-target="#notificationModal">
                        <i class="bi bi-bell"></i>
                        <% if(unreadCount > 0) { %>
                            <span class="notification-badge"><%= unreadCount > 9 ? "9+" : unreadCount %></span>
                        <% } %>
                    </button>
                <% } %>
                
                <% if (currentUser != null && currentUser.getRole() == 3) { %>
                    <a href="${pageContext.request.contextPath}/admin/adminPanel" class="action-btn btn-green-fill">
                        <i class="bi bi-speedometer2"></i> Quản trị
                    </a>
                <% } %>

                <% if (currentUser != null && currentUser.getRole() == 2) { %>
                    <a href="${pageContext.request.contextPath}/editor/workspace" class="action-btn btn-outline-green">
                        <i class="bi bi-pencil-square"></i> Đăng tin
                    </a>
                <% } %>

                <% if (currentUser == null) { %>
                    <a href="${pageContext.request.contextPath}/login" class="action-btn btn-green-fill">
                        <i class="bi bi-person-circle"></i> Đăng nhập
                    </a>
                <% } else { %>
                    <div class="dropdown">
                        <a href="#" class="user-profile-link dropdown-toggle" role="button" data-bs-toggle="dropdown">
                            <div class="rounded-circle bg-light d-flex justify-content-center align-items-center text-success border border-success" 
                                 style="width: 40px; height: 40px;">
                                <i class="bi bi-person-fill fs-5"></i>
                            </div>
                            <span class="d-none d-md-inline"><%= currentUser.getName() %></span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person me-2"></i>Hồ sơ</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li>
                                <button class="dropdown-item py-2 text-danger" data-bs-toggle="modal" data-bs-target="#logoutModal">
                                    <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                </button>
                            </li>
                        </ul>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<div class="category-wrapper">
    <div class="container-xxl">
        <div class="category-container">
            <div class="category-scroll-view">
                <div class="home-icon-wrapper">
                    <a href="${pageContext.request.contextPath}/" class="cat-link px-0 text-success">
                        <i class="bi bi-house-door-fill fs-5"></i>
                    </a>
                </div>
                <c:forEach var="c" items="${categories}" varStatus="s" end="9">
                    <a class="cat-link ${param.cat == c.id ? 'active' : ''}" href="?cat=${c.id}">${c.name}</a>
                </c:forEach>
                <c:if test="${fn:length(categories) > 10}">
                    <c:forEach var="c" items="${categories}" begin="10">
                        <a class="cat-link d-lg-none ${param.cat == c.id ? 'active' : ''}" href="?cat=${c.id}">${c.name}</a>
                    </c:forEach>
                </c:if>
            </div>
            <c:if test="${fn:length(categories) > 10}">
                <div class="btn-all-cats-wrapper d-none d-lg-block">
                    <button class="btn-all-cats" data-bs-toggle="modal" data-bs-target="#categoryModal">
                        <i class="bi bi-grid-3x3-gap-fill me-2"></i> Tất cả
                    </button>
                </div>
            </c:if>
        </div>
    </div>
</div>

<div class="modal fade" id="categoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content border-0 shadow-lg">
            <div class="modal-header border-bottom-0 pb-0">
                <h5 class="modal-title fw-bold text-success text-uppercase"><i class="bi bi-list-columns-reverse me-2"></i>Tất cả chuyên mục</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body pt-4">
                <div class="row g-3">
                    <div class="col-6 col-md-4 col-lg-3"><a href="${pageContext.request.contextPath}/" class="cat-modal-item"><i class="bi bi-house-door-fill me-1"></i> Trang chủ</a></div>
                    <c:forEach var="c" items="${categories}">
                        <div class="col-6 col-md-4 col-lg-3"><a href="?cat=${c.id}" class="cat-modal-item ${param.cat == c.id ? 'active' : ''}">${c.name}</a></div>
                    </c:forEach>
                </div>
            </div>
            <div class="modal-footer border-top-0 pt-0"><button type="button" class="btn btn-light btn-sm w-100 text-muted" data-bs-dismiss="modal">Đóng</button></div>
        </div>
    </div>
</div>

<div class="modal fade" id="notificationModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content border-0 shadow">
            <div class="modal-header border-0 pb-0"><h5 class="modal-title fw-bold text-success">Thông báo</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
            <div class="modal-body p-0 mt-2">
                <% if (notifications == null || notifications.isEmpty()) { %>
                    <div class="text-center py-5 text-muted"><i class="bi bi-bell-slash fs-1 d-block mb-2 opacity-50"></i><p>Bạn chưa có thông báo nào.</p></div>
                <% } else { %>
                    <div class="list-group list-group-flush">
                        <% for(Notification n : notifications) { %>
                           <a href="${pageContext.request.contextPath}/notification/read?id=<%= n.getId() %>" class="noti-item <%= !n.isRead() ? "unread" : "" %>">
                                <img src="https://ui-avatars.com/api/?name=<%= n.getTriggerUser().getName() %>&background=random&color=fff" class="noti-avatar">
                                <div class="noti-content"><p><strong class="text-dark"><%= n.getTriggerUser().getName() %></strong> <%= n.getContent() %></p><span class="noti-time"><% if(n.getType() == 1) { %><i class="bi bi-chat-dots-fill text-primary noti-icon-type"></i><% } else { %><i class="bi bi-heart-fill text-danger noti-icon-type"></i><% } %><%= Utils.DateUtils.timeAgo(n.getCreateAt()) %></span></div>
                                <% if(!n.isRead()) { %><span class="ms-auto bg-primary rounded-circle" style="width: 8px; height: 8px; display: inline-block;"></span><% } %>
                            </a>
                        <% } %>
                    </div>
                <% } %>
            </div>
            <div class="modal-footer border-0 pt-0"><a href="#" class="btn btn-sm btn-link text-success text-decoration-none w-100">Xem tất cả</a></div>
        </div>
    </div>
</div>

<div class="modal fade" id="logoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content border-0 shadow">
            <div class="modal-body text-center p-4">
                <div class="mb-3 text-warning"><i class="bi bi-exclamation-circle display-4"></i></div>
                <h5 class="mb-3">Đăng xuất?</h5>
                <p class="text-muted mb-4">Bạn có chắc chắn muốn đăng xuất?</p>
                <div class="d-flex justify-content-center gap-2"><button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">Hủy</button><a href="${pageContext.request.contextPath}/logout" class="btn btn-danger px-4">Đồng ý</a></div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        // 1. Hiển thị ngày giờ (Luôn chạy)
        const dateEl = document.getElementById("currentDate");
        const now = new Date();
        const days = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
        const dateStr = days[now.getDay()] + ", " + now.getDate() + "/" + (now.getMonth() + 1) + "/" + now.getFullYear();
        if(dateEl) dateEl.textContent = dateStr;

        // 2. Định nghĩa hàm lấy thời tiết
        const locationEl = document.getElementById("userLocation");
        const tempEl = document.getElementById("weatherTemp");
        const widget = document.getElementById("weatherWidget");

        // Hàm hiển thị mặc định nếu lỗi
        function showDefault() {
            console.warn("Đang hiển thị thời tiết mặc định do không lấy được vị trí.");
            locationEl.textContent = "Hà Nội";
            getWeather(21.0285, 105.8542); // Tọa độ Hà Nội
        }

        // Hàm gọi API
        function getWeather(lat, lon) {
            // Key dự phòng (Backup Key) nếu key cũ lỗi
            const apiKey = "e83b3c4c08285bf87b99f9bbc0abe3f0"; 
            const url = `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${apiKey}&units=metric&lang=vi`;

            fetch(url)
                .then(response => {
                    if (!response.ok) throw new Error("API Error: " + response.status);
                    return response.json();
                })
                .then(data => {
                    if(data.name) {
                        let city = data.name.replace("Tỉnh ", "").replace("Thành phố ", "");
                        locationEl.textContent = city;
                        tempEl.textContent = Math.round(data.main.temp) + "°C";
                        // Đảm bảo widget hiện lên (nếu lỡ bị ẩn)
                        widget.style.display = "flex"; 
                    }
                })
                .catch(err => {
                    console.error("Lỗi gọi API thời tiết:", err);
                    // Nếu gọi API lỗi thì set cứng luôn để giao diện không trống
                    locationEl.textContent = "Việt Nam";
                    tempEl.textContent = "28°C";
                });
        }

        // 3. Xin quyền vị trí
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(
                (position) => {
                    console.log("Đã lấy được tọa độ user.");
                    getWeather(position.coords.latitude, position.coords.longitude);
                },
                (error) => {
                    console.error("User từ chối vị trí hoặc lỗi trình duyệt:", error.message);
                    showDefault(); // User chặn thì hiện mặc định
                }
            );
        } else {
            console.error("Trình duyệt không hỗ trợ Geolocation.");
            showDefault();
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>