<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Chi tiết yêu cầu</title>

  <!-- Font -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

  <style>
    :root{
      --primary: #16a34a;
      --primary-light: #22c55e;
      --primary-dark:  #15803d;
      --neutral: #f3f4f6;
      --muted: #6b7280;
      --text: #111827;
      --pending: #f59e0b;
      --approved: #22c55e;
      --rejected: #ef4444;
      --card-radius: 14px;
      --space: 16px;
      --shadow-soft: 0 6px 20px rgba(16,24,40,0.06);
      --shadow-strong: 0 10px 30px rgba(2,6,23,0.08);
      --transition: 220ms cubic-bezier(.2,.8,.2,1);
    }

    html,body{
      height:100%;
      margin:0;
      font-family: "Inter", system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
      background: linear-gradient(180deg,#f8fafc 0%, #ffffff 100%);
      color:var(--text);
      -webkit-font-smoothing:antialiased;
      -moz-osx-font-smoothing:grayscale;
      padding: 28px;
      box-sizing: border-box;
    }

    .container {
      width:100%;
      max-width: 920px;
      margin: 0 auto;
    }

    /* Header */
    .header {
      display:flex;
      gap:12px;
      align-items:center;
      justify-content:space-between;
      margin-bottom:18px;
    }
    .title {
      font-size:20px;
      font-weight:600;
      display:flex;
      gap:12px;
      align-items:center;
    }

    .badge {
      display:inline-flex;
      align-items:center;
      gap:8px;
      padding:6px 10px;
      border-radius:999px;
      font-size:13px;
      font-weight:600;
      color:#fff;
      box-shadow: var(--shadow-soft);
    }
    .badge svg { opacity:0.95; width:16px; height:16px; }

    /* Card */
    .card {
      background: #fff;
      border-radius: var(--card-radius);
      padding: 20px;
      box-shadow: var(--shadow-soft);
      animation: fadeUp .28s var(--transition) both;
      transition: transform var(--transition), box-shadow var(--transition);
    }
    .card:hover { transform: translateY(-2px); box-shadow: var(--shadow-strong); }

    @keyframes fadeUp {
      from { opacity:0; transform: translateY(8px); }
      to { opacity:1; transform: translateY(0); }
    }

    .grid {
      display:grid;
      grid-template-columns: 1fr 1fr;
      gap:16px;
    }

    .field {
      display:flex;
      gap:12px;
      align-items:flex-start;
    }

    .icon-box {
      min-width:34px;
      height:34px;
      border-radius:8px;
      background:linear-gradient(180deg, rgba(22,163,74,0.08), rgba(22,163,74,0.02));
      display:flex;
      align-items:center;
      justify-content:center;
      color:var(--primary);
    }

    .meta-label { font-weight:600; font-size:13px; color:var(--muted); display:block; margin-bottom:4px; }
    .meta-value { font-size:15px; color:var(--text); word-break:break-word; }

    .full-row { grid-column: 1 / -1; }

    /* Portfolio link */
    .btn-link {
      display:inline-flex;
      gap:8px;
      align-items:center;
      padding:8px 12px;
      border-radius:10px;
      background: linear-gradient(90deg,var(--primary) 0%, var(--primary-light) 100%);
      color:white;
      text-decoration:none;
      font-weight:600;
      box-shadow: 0 6px 18px rgba(34,197,94,0.16);
      transition: transform var(--transition), filter var(--transition);
    }
    .btn-link:hover { transform: scale(1.02); filter:brightness(1.03); }
    .btn-link:focus { outline:3px solid rgba(34,197,94,0.18); }

    /* Actions */
    .actions { display:flex; gap:12px; margin-top:18px; align-items:center; }
    .btn {
      -webkit-tap-highlight-color: transparent;
      padding:10px 16px;
      border-radius:10px;
      border:0;
      cursor:pointer;
      font-weight:600;
      font-size:14px;
      transition: transform var(--transition), box-shadow var(--transition), opacity var(--transition);
      display:inline-flex;
      gap:10px;
      align-items:center;
      justify-content:center;
    }
    .btn:focus { outline:3px solid rgba(16,185,129,0.14); }

    .btn-approve {
      background: linear-gradient(90deg, var(--primary) 0%, var(--primary-light) 100%);
      color:#fff;
      box-shadow: 0 8px 24px rgba(16,163,85,0.14);
    }
    .btn-approve:hover { transform: scale(1.02); }
    .btn-reject {
      background: linear-gradient(90deg, #ef4444 0%, #f97316 100%);
      color:#fff;
      box-shadow: 0 8px 24px rgba(239,68,68,0.10);
    }
    .btn-reject:hover { transform: scale(1.02); }

    .btn[disabled] { opacity:0.7; cursor:not-allowed; transform:none; box-shadow:none; }

    /* Spinner */
    .spinner {
      width:16px; height:16px; border-radius:50%;
      border:2px solid rgba(255,255,255,0.3);
      border-top-color: white;
      animation: spin 700ms linear infinite;
    }
    @keyframes spin { to { transform: rotate(360deg); } }

    /* Tooltip */
    .tooltip {
      position:relative;
      display:inline-block;
    }
    .tooltip .tip {
      position:absolute;
      bottom:100%;
      left:50%;
      transform:translateX(-50%) translateY(-10px);
      background: rgba(17,24,39,0.95);
      color: #fff;
      padding:6px 8px;
      border-radius:8px;
      font-size:13px;
      white-space:nowrap;
      opacity:0; pointer-events:none;
      transition: opacity var(--transition), transform var(--transition);
    }
    .tooltip:focus-within .tip,
    .tooltip:hover .tip { opacity:1; transform:translateX(-50%) translateY(-14px); }

    /* Responsive */
    @media (max-width:720px){
      .grid { grid-template-columns: 1fr; }
      .header { align-items:flex-start; gap:8px; flex-direction:column; }
    }

    /* accessible hidden for sr-only */
    .sr-only{ position: absolute !important; width:1px; height:1px; padding:0; margin:-1px; overflow:hidden; clip:rect(0,0,0,0); white-space:nowrap; border:0; }
  </style>
</head>
<body>
  <main class="container" role="main">

    <!-- Header -->
    <header class="header" aria-labelledby="pageTitle">
      <div class="title" id="pageTitle">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" aria-hidden="true">
          <path d="M12 2L3 7v7c0 5 4 9 9 9s9-4 9-9V7l-9-5z" fill="currentColor" style="opacity:.15"></path>
          <path d="M12 2v19" stroke="var(--primary)" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        Chi tiết yêu cầu
      </div>

      <!-- Status badge: uses data-status for JS fallback and visual -->
      <div id="statusBadge" class="badge" role="status"
           data-status="${reqRole.status}">
        <!-- icon + text filled later by JS -->
      </div>
    </header>

    <!-- Card -->
    <section class="card" aria-labelledby="detailTitle">
      <h2 id="detailTitle" class="sr-only">Chi tiết yêu cầu nâng cấp</h2>

      <div class="grid" role="region" aria-label="Thông tin yêu cầu">

        <!-- User -->
        <div class="field">
          <div class="icon-box" aria-hidden="true">
            <!-- user icon -->
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none">
              <path d="M12 12a4 4 0 100-8 4 4 0 000 8z" fill="currentColor" />
              <path d="M3 21a9 9 0 0118 0" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
            </svg>
          </div>
          <div>
            <span class="meta-label">User</span>
            <span class="meta-value">${reqRole.user.name}</span>
          </div>
        </div>

        <!-- Email -->
        <div class="field">
          <div class="icon-box" aria-hidden="true">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
              <path d="M3 8.5l9 6 9-6" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
              <rect x="3" y="5" width="18" height="14" rx="2" stroke="currentColor" stroke-width="1.2" fill="none"/>
            </svg>
          </div>
          <div>
            <span class="meta-label">Email</span>
            <span class="meta-value">${reqRole.user.email}</span>
          </div>
        </div>

        <!-- Reason (full row) -->
        <div class="full-row">
          <div class="field" style="align-items:flex-start;">
            <div class="icon-box" aria-hidden="true">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
                <path d="M4 7h16M4 12h16M4 17h10" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <div style="flex:1">
              <span class="meta-label">Lý do</span>
              <div class="meta-value">${reqRole.reason}</div>
            </div>
          </div>
        </div>

        <!-- Experience (full row) -->
        <div class="full-row">
          <div class="field" style="align-items:flex-start;">
            <div class="icon-box" aria-hidden="true">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
                <path d="M12 6v6l4 2" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
                <rect x="3" y="4" width="18" height="16" rx="2" stroke="currentColor" stroke-width="1.2" fill="none"/>
              </svg>
            </div>
            <div style="flex:1">
              <span class="meta-label">Kinh nghiệm viết bài</span>
              <div class="meta-value">${reqRole.experience}</div>
            </div>
          </div>
        </div>

        <!-- Portfolio + Status -->
        <div class="field">
          <div class="icon-box" aria-hidden="true">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
              <path d="M10 14l6-6" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M20 13v6a2 2 0 01-2 2H6a2 2 0 01-2-2V5a2 2 0 012-2h7" stroke="currentColor" stroke-width="1.2" fill="none"/>
            </svg>
          </div>
          <div>
            <span class="meta-label">Portfolio</span>
            <div class="meta-value" style="display:flex;gap:10px;align-items:center;">
              <span style="color:var(--muted); max-width:320px; overflow:hidden; text-overflow:ellipsis;">
                <c:choose>
                  <c:when test="${not empty reqRole.portfolio}">
                    ${reqRole.portfolio}
                  </c:when>
                  <c:otherwise>
                    (Chưa cung cấp)
                  </c:otherwise>
                </c:choose>
              </span>

              <c:if test="${not empty reqRole.portfolio}">
                <a class="btn-link" href="${reqRole.portfolio}" target="_blank" rel="noopener" aria-label="Xem portfolio">
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" aria-hidden="true">
                    <path d="M14 3h7v7" stroke="white" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M10 14L21 3" stroke="white" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M21 21H3V3" stroke="rgba(255,255,255,0.18)" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                  Xem
                </a>
              </c:if>
            </div>
          </div>
        </div>

        <!-- Status display (right column) -->
        <div class="field">
          <div class="icon-box" aria-hidden="true">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
              <circle cx="12" cy="12" r="9" stroke="currentColor" stroke-width="1.2" fill="none"/>
            </svg>
          </div>
          <div>
            <span class="meta-label">Trạng thái</span>
            <div class="meta-value" style="display:flex;gap:8px;align-items:center;">
              <span id="statusText" style="font-weight:700;"></span>
              <span class="tooltip" tabindex="0" aria-label="Thông tin trạng thái">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" style="opacity:.7">
                  <path d="M12 2a10 10 0 100 20 10 10 0 000-20zM11 10h2v6h-2v-6zm0-4h2v2h-2V6z" fill="currentColor"/>
                </svg>
                <span class="tip" role="tooltip">Pending: chờ admin xét duyệt. Approved: đã cấp quyền. Rejected: bị từ chối.</span>
              </span>
            </div>
          </div>
        </div>

      </div> <!-- end grid -->

      <!-- Actions (only when pending) -->
      <c:if test="${reqRole.status == 0}">
        <div class="actions" aria-live="polite">
          <form id="actionForm" action="${pageContext.request.contextPath}/admin/role-request-action" method="post" style="display:inline;">
            <input type="hidden" name="id" value="${reqRole.id}" />
            <input type="hidden" name="action" id="actionInput" value="" />
            <button type="button" id="approveBtn" class="btn btn-approve" aria-label="Phê duyệt yêu cầu">
              <span id="approveText">Phê duyệt</span>
              <span id="approveSpinner" style="display:none;margin-left:6px;"><span class="spinner" aria-hidden="true"></span></span>
            </button>

            <button type="button" id="rejectBtn" class="btn btn-reject" aria-label="Từ chối yêu cầu">
              <span id="rejectText">Từ chối</span>
              <span id="rejectSpinner" style="display:none;margin-left:6px;"><span class="spinner" aria-hidden="true"></span></span>
            </button>
          </form>
        </div>
      </c:if>

    </section>

    <!-- Modal Confirm -->
    <div id="confirmModal" aria-hidden="true" role="dialog" aria-modal="true" aria-labelledby="confirmTitle" class="sr-only">
      <div class="modal-backdrop" style="position:fixed;inset:0;background:rgba(2,6,23,0.45);"></div>
      <div class="modal-panel" style="position:fixed;left:50%;top:50%;transform:translate(-50%,-50%);width:min(520px,92%);background:#fff;border-radius:12px;padding:20px;box-shadow:var(--shadow-strong);">
        <h3 id="confirmTitle" style="margin:0 0 10px;font-weight:700;font-size:18px;color:var(--text)">Xác nhận hành động</h3>
        <p id="confirmMessage" style="color:var(--muted);margin:0 0 18px;">Bạn có chắc muốn thực hiện hành động này?</p>

        <div style="display:flex;gap:12px;justify-content:flex-end;">
          <button id="cancelModal" class="btn" style="background:#f3f4f6;border-radius:10px;">Hủy</button>
          <button id="confirmModalBtn" class="btn btn-approve" aria-label="Xác nhận">
            <span id="confirmBtnText">Xác nhận</span>
            <span id="confirmSpinner" style="display:none;margin-left:8px;"><span class="spinner" aria-hidden="true"></span></span>
          </button>
        </div>
      </div>
    </div>

  </main>

  <script>
    // Read status from data attribute (server rendered)
    (function(){
      const badge = document.getElementById('statusBadge');
      const status = badge.dataset.status ? badge.dataset.status.trim() : "${reqRole.status}";
      const statusText = document.getElementById('statusText');

      // map
      const map = {
        "0": { text: "Pending", color: "var(--pending)", tip: "Yêu cầu đang chờ xét duyệt" },
        "1": { text: "Approved", color: "var(--approved)", tip: "Yêu cầu đã được phê duyệt" },
        "2": { text: "Rejected", color: "var(--rejected)", tip: "Yêu cầu bị từ chối" }
      };

      const s = map[String(status)] || map["0"];

      // fill badge
      badge.style.background = s.color;
      badge.innerHTML = `<svg viewBox="0 0 24 24" fill="none" aria-hidden="true">
        <path d="M12 2L3 7v7c0 5 4 9 9 9s9-4 9-9V7l-9-5z" fill="rgba(255,255,255,0.12)"></path>
        <path d="M9 12l2 2 4-4" stroke="#fff" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" style="display:${status==1? 'inline':'none'}"></path>
        <path d="M12 6v6" stroke="#fff" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" style="display:${status==0? 'inline':'none'}"></path>
      </svg><span style="text-transform:capitalize;"> ${s.text}</span>`;

      // fill status text
      statusText.textContent = s.text;
      // tooltip message (already set static in DOM). Optionally update.

    })();

    // Modal + action handling
    (function(){
      const approveBtn = document.getElementById('approveBtn');
      const rejectBtn = document.getElementById('rejectBtn');
      const modal = document.getElementById('confirmModal');
      const confirmBtn = document.getElementById('confirmModalBtn');
      const cancelBtn = document.getElementById('cancelModal');
      const actionInput = document.getElementById('actionInput');
      const actionForm = document.getElementById('actionForm');

      // focus trap variables
      let lastFocused = null;

      function openModal(message, actionValue, confirmLabel){
        lastFocused = document.activeElement;
        modal.classList.remove('sr-only');
        modal.setAttribute('aria-hidden','false');
        document.body.style.overflow = 'hidden';
        document.getElementById('confirmMessage').textContent = message;
        document.getElementById('confirmBtnText').textContent = confirmLabel || 'Xác nhận';
        actionInput.value = actionValue;
        // focus to confirm button
        confirmBtn.focus();
        // trap focus
        trapFocus(modal);
      }

      function closeModal(){
        modal.classList.add('sr-only');
        modal.setAttribute('aria-hidden','true');
        document.body.style.overflow = '';
        if(lastFocused) lastFocused.focus();
        releaseFocusTrap();
      }

      approveBtn && approveBtn.addEventListener('click', function(){
        openModal('Bạn chắc chắn muốn phê duyệt yêu cầu này? Người dùng sẽ được nâng role thành Editor.', 'approve', 'Phê duyệt');
      });

      rejectBtn && rejectBtn.addEventListener('click', function(){
        openModal('Bạn chắc chắn muốn từ chối yêu cầu này? Người dùng sẽ giữ nguyên role.', 'reject', 'Từ chối');
      });

      cancelBtn && cancelBtn.addEventListener('click', function(e){
        e.preventDefault();
        closeModal();
      });

   // Confirm button logic
      confirmBtn && confirmBtn.addEventListener('click', function(e){
        e.preventDefault();
        
        // 1. Disable nút
        confirmBtn.setAttribute('disabled','true');
        document.getElementById('confirmSpinner').style.display = '';

        // 2. Lấy dữ liệu thủ công (An toàn hơn FormData)
        const idValue = document.querySelector('input[name="id"]').value;
        const actionValue = document.getElementById('actionInput').value;

        // 3. Tạo params chuẩn
        const params = new URLSearchParams();
        params.append('id', idValue);
        params.append('action', actionValue);

        // 4. Gửi request
        fetch("${pageContext.request.contextPath}/admin/role-request-action", {
          method: 'POST',
          body: params,
          headers: { 
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
          }
        }).then(res => {
          if (res.ok) {
             return res.text();
          }
          // Nếu server trả về lỗi (ví dụ 500), ném lỗi xuống catch
          throw new Error('Server returned ' + res.status);
        }).then(txt => {
          // Thành công -> Reload
        	window.location.href = "${pageContext.request.contextPath}/admin/adminPanel";
        }).catch(err => {
          console.error("Lỗi chi tiết:", err); // Xem lỗi trong F12 Console
          alert('Có lỗi xảy ra: ' + err.message);
          
          // Reset lại nút
          confirmBtn.removeAttribute('disabled');
          document.getElementById('confirmSpinner').style.display = 'none';
          closeModal();
        });
      });

      /* Focus trap for modal - simple implementation */
      let trap = null;
      function trapFocus(container){
        const focusable = container.querySelectorAll('button,a,input,select,textarea,[tabindex]:not([tabindex="-1"])');
        const first = focusable[0];
        const last = focusable[focusable.length - 1];
        trap = function(e){
          if(e.key === 'Tab'){
            if(e.shiftKey && document.activeElement === first){
              e.preventDefault();
              last.focus();
            } else if(!e.shiftKey && document.activeElement === last){
              e.preventDefault();
              first.focus();
            }
          } else if(e.key === 'Escape'){
            closeModal();
          }
        };
        document.addEventListener('keydown', trap);
      }
      function releaseFocusTrap(){
        if(trap) document.removeEventListener('keydown', trap);
        trap = null;
      }

    })();

    // small accessibility helpers: allow action buttons to be triggered by Enter
    (function(){
      ['approveBtn','rejectBtn'].forEach(id=>{
        const el = document.getElementById(id);
        if(!el) return;
        el.addEventListener('keydown', function(e){
          if(e.key === 'Enter' || e.key === ' '){
            e.preventDefault();
            el.click();
          }
        });
      });
    })();
  </script>
</body>
</html>
