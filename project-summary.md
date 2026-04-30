# Project Summary — Báo Dân Trí (News Website)

> Ngày phân tích: 2026-04-24
> Phân tích bởi: Senior Engineer — Quét toàn bộ source code

---

## 1. Tên dự án

**ASM1_NguyenLeMinh_PC10524** — Hệ thống trang báo điện tử "Dân Trí" (clone)

- **GroupId / ArtifactId**: `ASM1_NguyenLeMinh_PC10524`
- **Persistence Unit**: `NewsWebsiteDB`
- **Suy ra từ**: `pom.xml`, CSS variable `--dantri-green`, branding trong JSP, URL `/ASM1_NguyenLeMinh_PC10524/`

---

## 2. Kiến trúc tổng thể

### 2.1. Pattern kiến trúc

- **Kiến trúc**: MVC thuần (Controller → Service → Entity → JSP)
- **Không dùng** Front Controller Pattern tập trung — mỗi Servlet đảm nhiệm 1 URL mapping riêng
- **ORM**: Hibernate 6.6.0 (JPA) thay vì JDBC thuần
- **Service Layer**: Các class trong package `Services/` chứa business logic + truy vấn JPA (đóng vai trò DAO)
- **Bean Layer**: Package `Beans/` chứa các Form Bean (DTO) dùng cho validation form trước khi xử lý nghiệp vụ

### 2.2. Cấu trúc thư mục

```
src/main/java/
├── Beans/         → Form Bean / DTO (LoginBean, RegisterBean, EditorPostBean, ...)
├── Config/        → Filter (AuthFilter)
├── Controller/    → 50 Servlet controllers
├── Entities/      → 21 JPA Entity classes
├── Services/      → 14 Service classes (business logic + data access)
└── Utils/         → Tiện ích (JpaUtil, EmailUtil, GoogleUtils, VNPayConfig, ...)

src/main/webapp/
├── WEB-INF/web.xml
├── admin/         → 6 trang JSP cho Admin
├── editor/        → 1 trang JSP cho Editor
├── views/auth/    → 3 trang JSP cho quên mật khẩu
├── assets/        → avatars, uploads (file upload)
└── *.jsp          → 13 trang JSP public (home, login, register, search, ...)
```

### 2.3. Filter

| Filter | URL Pattern | Mục đích |
|--------|-------------|----------|
| `AuthFilter` | `/admin/*`, `/editor/*` | Kiểm tra Cookie `user_id` và `role`, phân quyền theo role (2 = Editor, 3 = Admin). Chặn truy cập nếu chưa đăng nhập hoặc sai quyền |

### 2.4. Listener

| Listener | Mục đích |
|----------|----------|
| `AppLifecycleListener` (`@WebListener`) | Đóng `EntityManagerFactory` khi ứng dụng shutdown (context destroyed) |

---

## 3. Servlet URL Mapping (toàn bộ — annotation-based)

### 3.1. Public (Người dùng chung)

| Servlet | URL | Chức năng |
|---------|-----|-----------|
| `HomeController` | `/` | Trang chủ — hiển thị video mới nhất, lọc theo danh mục, VIP zone |
| `LoginController` | `/login` | Đăng nhập (username/email + password) |
| `LoginGoogleServlet` | `/login-google` | Đăng nhập bằng Google OAuth |
| `LogoutController` | `/logout` | Đăng xuất, xóa cookie |
| `RegisterController` | `/register` | Đăng ký tài khoản |
| `ForgotPasswordServlet` | `/forgot-password`, `/verify-code`, `/reset-password` | Quên mật khẩu (OTP qua email) |
| `PostDetailController` | `/postdetail` | Xem chi tiết bài viết/video |
| `SearchController` | `/search` | Tìm kiếm nâng cao (keyword, category, time filter) |
| `UserProfileController` | `/profile` | Xem profile cá nhân |
| `EditProfileServlet` | `/editProfile` | Chỉnh sửa thông tin cá nhân |
| `FavouriteController` | `/favourite` | Yêu thích / bỏ yêu thích video |
| `UserFavouriteServlet` | `/user/favourites` | Danh sách video yêu thích |
| `HistoryController` | `/history` | Lịch sử xem video |
| `HistoryAPIController` | `/api/history-save` | API lưu lịch sử xem (AJAX) |
| `PremiumZoneController` | `/premium-zone` | Khu vực nội dung VIP |
| `RoleRequestController` | `/role-request` | Yêu cầu nâng cấp vai trò (User → Editor) |
| `CategoryController` | `/category` | Xem theo danh mục |
| `ExplainerBotController` | `/explainer-bot` | Chatbot AI giải thích bài báo (Gemini API) |
| `AvatarController` | `/api/avatar` | API quản lý avatar |

### 3.2. Comment System

| Servlet | URL | Chức năng |
|---------|-----|-----------|
| `CommentAddController` | `/comment/add` | Thêm bình luận (hỗ trợ reply lồng nhau) |
| `CommentLikeController` | `/comment/like` | Like bình luận |
| `CommentLoadMoreController` | `/comment/load` | Tải thêm bình luận (AJAX) |

### 3.3. Notification

| Servlet | URL | Chức năng |
|---------|-----|-----------|
| `NotificationReadController` | `/notification/read` | Đánh dấu thông báo đã đọc |

### 3.4. Payment (VNPay)

| Servlet | URL | Chức năng |
|---------|-----|-----------|
| `PaymentCreateController` | `/payment/create` | Tạo giao dịch thanh toán VNPay |
| `PaymentReturnController` | `/payment/return` | Xử lý callback từ VNPay, kích hoạt VIP |
| `PaymentController` | `/payment/create_test_old` | (bản test cũ) |

### 3.5. Editor (Role = 2)

| Servlet | URL | Chức năng |
|---------|-----|-----------|
| `EditorWorkSpace` | `/editor/workspace` | Dashboard editor — đăng bài, thống kê, lịch sử |
| `EditorUpdateVideo` | `/editor/update` | Cập nhật video đã đăng |
| `EditorDeleteVideo` | `/editor/delete` | Xóa video của editor |
| `EditorBankController` | `/editor/updateBank` | Cập nhật thông tin ngân hàng |

### 3.6. Admin (Role = 3)

| Servlet | URL | Chức năng |
|---------|-----|-----------|
| `AdminPanelController` | `/admin/adminPanel` | Dashboard admin — thống kê, quản lý user/video/danh mục/quảng cáo |
| `AdminUpdateStatusController` | `/admin/updateStatus` | Duyệt/từ chối bài viết |
| `AdminRoleRequestListController` | `/admin/role-request` | Danh sách yêu cầu nâng cấp vai trò |
| `AdminRoleRequestDetailController` | `/admin/role-request-detail` | Chi tiết yêu cầu nâng cấp |
| `AdminRoleRequestActionController` | `/admin/role-request-action` | Duyệt/từ chối yêu cầu nâng cấp |
| `AdminPayoutController` | `/admin/confirmPayout` | Xác nhận thanh toán lương cho Editor |
| `AddVideoController` | `/admin/addVideo` | Admin thêm video |
| `EditVideoController` | `/admin/editVideo` | Admin sửa video |
| `DeleteVideoController` | `/admin/deleteVideo` | Admin xóa video |
| `VideoDetailServlet` | `/admin/videoDetail` | Xem chi tiết video (admin) |
| `ToggleVideoStatusController` | `/admin/toggleVideoStatus` | Bật/tắt trạng thái video |
| `ChangePasswordController` | `/admin/changePassword` | Đổi mật khẩu user (admin) |
| `UpdateRateController` | `/admin/updateRate` | Cập nhật đơn giá view (VNĐ/view) |
| `ExportRevenueController` | `/admin/exportRevenue` | Xuất báo cáo doanh thu Excel |
| `CreateAdController` | `/admin/createAd` | Tạo banner quảng cáo |
| `UpdateAdController` | `/admin/updateAd` | Sửa banner quảng cáo |
| `DeleteAdController` | `/admin/deleteAd` | Xóa banner quảng cáo |
| `ToggleAdStatusController` | `/admin/toggleAdStatus` | Bật/tắt trạng thái quảng cáo |
| `AddProductToVideoController` | `/admin/addProductToVideo` | Gắn sản phẩm affiliate vào video |
| `DeleteVideoProductController` | `/admin/deleteVideoProduct` | Xóa sản phẩm khỏi video |

---

## 4. Các module / tính năng chính

### 4.1. Quản lý người dùng (User Management)
- Đăng ký / Đăng nhập (username/email + password)
- Đăng nhập Google OAuth 2.0
- Quên mật khẩu (OTP 6 số gửi qua email, hết hạn sau 5 phút)
- Chỉnh sửa profile (tên, số điện thoại, đổi mật khẩu)
- Quản lý avatar
- Hệ thống vai trò: User (1), Editor (2), Admin (3)
- Admin: khóa/mở khóa tài khoản, xem chi tiết, lọc theo vai trò & từ khóa

### 4.2. Quản lý nội dung (Content Management)
- Editor: đăng bài viết/video (tiêu đề, nội dung, link YouTube, ảnh poster, danh mục)
- Hệ thống duyệt bài: Editor đăng → status = 1 (chờ duyệt) → Admin duyệt → status = 2 (công khai)
- Admin: CRUD toàn bộ video, danh mục
- Hỗ trợ YouTube embed (youtube.com/watch, youtu.be, youtube.com/shorts)
- Video Premium (chỉ VIP xem được)
- Video Chapters (phân đoạn video)
- AI Summary (tóm tắt video bằng AI)

### 4.3. Hệ thống bình luận (Comment System)
- Bình luận nhiều cấp (reply lồng nhau với `parent_id`)
- Like bình luận
- Upload ảnh kèm bình luận
- Tải thêm bình luận (AJAX)
- Thông báo khi bị reply hoặc like

### 4.4. Tìm kiếm nâng cao (Search)
- Tìm kiếm theo từ khóa + danh mục + khoảng thời gian
- Editor: tìm kiếm trong danh sách bài viết đã đăng

### 4.5. Thanh toán VNPay & VIP
- Tích hợp cổng thanh toán VNPay (sandbox)
- Nâng cấp VIP: ≥500k → 365 ngày, <500k → 30 ngày
- Cộng dồn ngày VIP nếu còn hạn
- Lưu lịch sử giao dịch (Transaction)

### 4.6. Hệ thống doanh thu (Revenue)
- Tính doanh thu Editor theo lượt xem × đơn giá (view_rate từ `SystemConfig`)
- Admin điều chỉnh đơn giá (VNĐ/view)
- Thống kê tổng doanh thu VNPay, tổng chi phí, lợi nhuận ròng
- Xuất báo cáo Excel (.xlsx) bằng Apache POI
- Thanh toán lương Editor (`Payout` entity)

### 4.7. Quảng cáo (Ad Banner)
- CRUD banner quảng cáo
- Vị trí: SIDEBAR_TOP, IN_CONTENT, SIDEBAR_BOTTOM
- Đối tượng: FREE, VIP, ALL
- Đếm lượt xem / lượt click
- Bật/tắt banner

### 4.8. Yêu cầu nâng cấp vai trò (Role Upgrade)
- User gửi yêu cầu nâng cấp lên Editor (lý do, kinh nghiệm, portfolio)
- Admin duyệt/từ chối

### 4.9. Hệ thống thông báo (Notification)
- Thông báo realtime: Reply (type 1), Like (type 2)
- Đánh dấu đã đọc

### 4.10. Lịch sử xem (Watch History)
- Lưu tiến độ xem video (watchTime, lastWatchAt)
- "Tiếp tục xem" trên trang chủ
- Thanh progress bar hiển thị phần đã xem

### 4.11. Yêu thích (Favourite)
- Lưu / bỏ lưu video yêu thích
- Danh sách video yêu thích

### 4.12. AI Chatbot (Explainer Bot)
- Tích hợp Google Gemini API (`gemini-flash-latest`)
- Giải thích thuật ngữ, tóm tắt bài báo, phân tích sự kiện
- Tự động tạo video chapters từ nội dung bài báo
- Trả lời bằng tiếng Việt, format HTML

### 4.13. Sản phẩm Affiliate (Video Product)
- Gắn sản phẩm vào video (tên, ảnh, link affiliate, giá, thời gian hiển thị)
- Hiển thị sản phẩm theo mốc thời gian trong video

### 4.14. Skin / Avatar System
- Hệ thống skin avatar (mua bằng điểm)
- Skin có thể là sponsored

---

## 5. Kỹ thuật nổi bật (Key Highlights)

| Kỹ thuật | Mô tả |
|----------|-------|
| **Google OAuth 2.0** | Đăng nhập bằng Google thông qua Apache HttpClient Fluent API, lấy user info từ Google API |
| **VNPay Payment Gateway** | Tích hợp sandbox VNPay với HmacSHA512 checksum, tạo URL thanh toán, xác thực callback |
| **Google Gemini AI** | Chatbot AI sử dụng Gemini API để tóm tắt nội dung, giải thích thuật ngữ, tự động tạo video chapters |
| **Cookie-based Authentication** | Quản lý session đăng nhập bằng Cookie (`user_id`, `role`) với thời hạn 3 ngày + HttpSession |
| **Role-based Authorization** | Filter phân quyền theo URL pattern (`/admin/*` cho role 3, `/editor/*` cho role 2) |
| **Revenue Export (Excel)** | Xuất báo cáo tài chính Excel (.xlsx) bằng Apache POI, định dạng tiền tệ VNĐ, merge cells, styled headers |
| **OTP Password Recovery** | Quên mật khẩu qua email OTP 6 số, hết hạn 5 phút, sử dụng JavaMail (Gmail SMTP) |
| **VIP Subscription System** | Hệ thống VIP với thời hạn, cộng dồn ngày, phân quyền nội dung premium |
| **Nested Comment + Like** | Bình luận nhiều cấp (self-referencing `parent_id`) kèm like system và thông báo |
| **Video Watch Progress** | Lưu tiến độ xem video, hiển thị "Tiếp tục xem" trên trang chủ + progress bar |
| **File Upload** | Sử dụng Servlet 3.0 `@MultipartConfig` + `Part` API để upload ảnh poster và ảnh bình luận |
| **Dark Mode** | Chế độ tối/sáng toàn trang, lưu trạng thái bằng `data-theme` attribute + JavaScript |
| **Affiliate Product** | Hiển thị sản phẩm affiliate theo mốc thời gian trong video (start_time/end_time) |
| **Scroll Reveal Animation** | Hiệu ứng scroll reveal khi cuộn trang (CSS + JavaScript) |
| **JPA Transaction Management** | Quản lý transaction thủ công (`em.getTransaction().begin/commit/rollback`) trong từng Service method |

---

## 6. Database

### 6.1. Loại database
- **Microsoft SQL Server** (JDBC driver: `mssql-jdbc:12.4.2.jre11`)
- **Database name**: `NewsWebsiteDB`
- **Connection**: `jdbc:sqlserver://localhost:1433;databaseName=NewsWebsiteDB`
- **User**: `sa`

### 6.2. Cách quản lý connection
- **Hibernate JPA** (`EntityManagerFactory` Singleton) — quản lý qua `JpaUtil`
- Mỗi request tạo `EntityManager` mới → sử dụng → `close()` trong `finally`
- **Không dùng** Connection Pool riêng (DBCP, HikariCP) — dùng pool mặc định của Hibernate
- `AppLifecycleListener` đóng `EntityManagerFactory` khi server shutdown

### 6.3. Các bảng chính (suy ra từ Entity classes)

| Bảng | Entity | Mô tả |
|------|--------|-------|
| `users` | `User` | Người dùng (id, username, password, name, email, phone, role, points, status, balance, vip_expire_date, bank info) |
| `videos` | `Video` | Bài viết/Video (id, title, description, url, poster, view_count, status, duration, is_premium, user_id, cat_id) |
| `categories` | `Category` | Danh mục bài viết |
| `comments` | `Comment` | Bình luận (hỗ trợ reply qua parent_id) |
| `comment_likes` | `CommentLike` | Like bình luận |
| `favourites` | `Favourite` | Video yêu thích |
| `history` | `History` | Lịch sử xem video (user_id, video_id, viewed_at) |
| `video_watch_history` | `VideoWatchHistory` | Tiến độ xem (watchTime, lastWatchAt) — composite key |
| `transactions` | `Transaction` | Giao dịch VNPay (amount, order_info, vnp_txn_ref, status) |
| `Payouts` | `Payout` | Thanh toán lương Editor (admin_id, editor_id, amount, bank info) |
| `RoleUpgradeRequest` | `RoleUpgradeRequest` | Yêu cầu nâng cấp vai trò |
| `notifications` | `Notification` | Thông báo (user, trigger_user, video, type, is_read) |
| `AdBanners` | `AdBanner` | Banner quảng cáo (position, targetAudience, views/clicks count) |
| `video_products` | `VideoProduct` | Sản phẩm affiliate gắn vào video (start_time, end_time, affiliate_url) |
| `video_ai_summary` | `VideoAISummary` | Tóm tắt AI cho video |
| `video_chapters` | `VideoChapter` | Phân đoạn video (start_time, title, is_premium) |
| `skins` | `Skin` | Skin avatar (name, base_url, price, is_sponsored) |
| `user_avatars` | `UserAvatar` | Avatar người dùng |
| `SystemConfig` | `SystemConfig` | Cấu hình hệ thống (key-value, VD: view_rate) |
| `admin_audit_log` | `AdminAuditLog` | Log hành động admin |

---

## 7. Frontend (JSP / HTML)

### 7.1. Các trang JSP chính

**Public (13 trang):**
- `home.jsp` — Trang chủ (bài mới nhất, video grid, premium zone, tiếp tục xem, dark mode)
- `navbar.jsp` — Thanh điều hướng (include vào tất cả trang)
- `login.jsp` — Đăng nhập
- `register.jsp` — Đăng ký
- `postDetail.jsp` — Chi tiết bài viết/video (embed YouTube, comment, AI bot)
- `search.jsp` — Tìm kiếm nâng cao
- `profile.jsp` — Trang cá nhân
- `editProfile.jsp` — Chỉnh sửa profile
- `premiumZone.jsp` — Khu vực nội dung VIP
- `upgradeVip.jsp` — Nâng cấp VIP (thanh toán)
- `payment_result.jsp` — Kết quả thanh toán
- `role_request.jsp` — Gửi yêu cầu nâng cấp vai trò
- `videos.jsp` — Danh sách video

**Auth (3 trang):**
- `views/auth/forgot-password.jsp`
- `views/auth/verify-code.jsp`
- `views/auth/reset-password.jsp`

**Admin (6 trang):**
- `admin/adminPanel.jsp` — Dashboard admin (94KB, trang lớn nhất — multi-tab: thống kê, user, video, danh mục, quảng cáo, doanh thu)
- `admin/userDetail.jsp` — Chi tiết user
- `admin/editVideo.jsp` — Sửa video
- `admin/video-detail.jsp` — Chi tiết video
- `admin/roleRequestList.jsp` — Danh sách yêu cầu nâng cấp
- `admin/role_request_detail.jsp` — Chi tiết yêu cầu nâng cấp

**Editor (1 trang):**
- `editor/editorWorkSpace.jsp` — Dashboard editor (58KB — đăng bài, quản lý video, thống kê, ngân hàng)

### 7.2. Frontend library & pattern

| Loại | Chi tiết |
|------|----------|
| **CSS Framework** | Bootstrap 5.3.3 (CDN) |
| **Icon** | Bootstrap Icons 1.11.3 (CDN) |
| **JSTL** | Có — `<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>` và `<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>` |
| **EL Expression** | Có — sử dụng rộng rãi (`${v.title}`, `${user.isVip()}`, ...) |
| **jQuery** | Không tìm thấy |
| **JavaScript** | Vanilla JS inline (dark mode toggle, scroll reveal, AJAX fetch API) |
| **Responsive** | Sử dụng Bootstrap grid system (`col-12 col-sm-6 col-lg-3`) |
| **Dark Mode** | Có — toggle button cố định, lưu theme qua `data-theme` attribute |
| **Micro-animation** | Hover effects, scroll reveal, card hover transform, image zoom |

---

## 8. Tech Stack đầy đủ

### Backend
- **Java 21** (maven-compiler-plugin release 21)
- **Servlet API 4.0.1** (`javax.servlet-api`)
- **Hibernate ORM 6.6.0** (JPA implementation)
- **Lombok 1.18.30** (annotation processor — `@Data`, `@AllArgsConstructor`, `@NoArgsConstructor`)
- **Gson 2.10.1** (JSON parsing — Google OAuth, AI response)
- **Apache HttpClient 4.5.14** + Fluent HC (Google OAuth HTTP requests)
- **Apache POI 5.2.5** (Export Excel .xlsx)
- **JavaMail 1.6.2** (`com.sun.mail:javax.mail` — gửi email OTP qua Gmail SMTP)
- **Commons BeanUtils 1.11.0** (auto-populate Form Bean từ request params)

### Frontend (JSP/View)
- **JSP** + **JSTL 1.2** + **EL Expression**
- **Bootstrap 5.3.3** (CDN)
- **Bootstrap Icons 1.11.3** (CDN)
- **Vanilla JavaScript** (inline)
- **CSS custom** (inline trong JSP)

### Database
- **Microsoft SQL Server** (mssql-jdbc 12.4.2.jre11)
- **Database**: `NewsWebsiteDB`

### External Service
- **Google OAuth 2.0** (đăng nhập Google)
- **Google Gemini AI** (`gemini-flash-latest` — chatbot giải thích bài báo)
- **VNPay Sandbox** (cổng thanh toán)
- **Gmail SMTP** (gửi email OTP)

### Server / Tools
- **Apache Tomcat** (phiên bản cụ thể không xác định từ code — web-app version 3.1 trong web.xml, dùng `javax.servlet` → gợi ý Tomcat 9.x)
- **Maven** (packaging: WAR)
- **Eclipse IDE** (suy ra từ `.project`, `.classpath`, `.settings/`)

---

## 9. Cấu hình & Deployment

### 9.1. File cấu hình

| File | Mục đích |
|------|----------|
| `pom.xml` | Maven dependencies, compiler Java 21, WAR packaging |
| `src/main/resources/META-INF/persistence.xml` | JPA config — JDBC driver, connection URL, entity classes |
| `src/main/webapp/WEB-INF/web.xml` | Chỉ mapping thư mục `/assets/*` cho default servlet (static files). Tất cả servlet mapping dùng annotation `@WebServlet` |

### 9.2. Dependency đáng chú ý (pom.xml)

| Dependency | Version | Mục đích |
|------------|---------|----------|
| `jstl` | 1.2 | JSP Standard Tag Library |
| `httpclient` + `fluent-hc` | 4.5.14 | Google OAuth HTTP requests |
| `poi` + `poi-ooxml` | 5.2.5 | Xuất file Excel (.xlsx) |
| `javax.mail` | 1.6.2 | Gửi email (JavaMail) |
| `commons-beanutils` | 1.11.0 | Auto-populate Bean từ HTTP parameters |
| `lombok` | 1.18.30 | Code generation (getter/setter/constructor) |
| `mssql-jdbc` | 12.4.2.jre11 | JDBC driver cho SQL Server |
| `hibernate-core` | 6.6.0.Final | JPA / ORM |
| `javax.servlet-api` | 4.0.1 | Servlet API (provided scope) |
| `gson` | 2.10.1 | JSON parsing |

### 9.3. Lưu ý kỹ thuật

- ⚠️ **Mật khẩu lưu dạng plain text** — không sử dụng BCrypt/MD5 (comment trong code ghi nhận vấn đề này)
- ⚠️ **API key Google Gemini hardcode** trong source code (`ExplainerBotController`)
- ⚠️ **VNPay credentials hardcode** trong `VNPayConfig` (sandbox)
- ⚠️ **Google OAuth credentials hardcode** trong `GoogleUtils`
- ⚠️ **Email credentials hardcode** trong `EmailUtil`
- ⚠️ **Cookie-based auth** không dùng HttpOnly / Secure flag — dễ bị XSS
- ⚠️ **Không có CSRF protection**
- ℹ️ Hỗn hợp `javax.servlet` (Controller/Filter) và `jakarta.persistence` (Entity/JPA) — Hibernate 6 dùng Jakarta nhưng Servlet vẫn dùng Javax (Tomcat 9)
