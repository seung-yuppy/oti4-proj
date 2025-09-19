<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티</title>
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css"
	rel="stylesheet">
<!-- test -->
</head>
<style>
.nav-pills {
	display: flex;
	flex-wrap: nowrap; /* 줄바꿈 방지 (필요시 wrap으로 변경 가능) */
	width: 100%;
}

.nav-pills .tab {
	flex: 1 1 0; /* 균등 분배 */
	text-align: center;
	font-size: 14px;
	color: #374151;
	padding: 10px 16px;
	border-radius: 999px;
	border: 1px solid transparent;
	transition: .15s;
	background: transparent; /* 기본 배경 없음 (원본과 동일 느낌) */
}

/* Hover: 원본과 동일 */
.nav-pills .tab:hover, .nav-pills .tab.active:hover {
	background: #de9c48; /* 호버 배경색 */
	border-color: #de9c48; /* 호버 테두리색 */
	color: white; /* 호버 글자색 */
}

/* Bootstrap의 기본 active(파란 배경) 제거 → 원본과 같은 '평상시' 스타일 유지 */
.nav-pills .tab.active {
	background: #cb7100 !important;
	color: white !important;
	border-color: transparent !important;
}

/* 접근성: 포커스 링은 유지하되 형태만 살짝 정리 */
.nav-pills .tab:focus {
	outline: none;
	box-shadow: 0 0 0 0.2rem rgba(185, 118, 26, 0.15);
}

.btn-secondary-brown:hover {
	background: #b1a08b !important;
	color: white !important;
}

.btn-secondary-brown.active {
	background: #6e5d47 !important;
	color: white !important;
}

.btn-fixed-width {
  width: 150px;
}

.pagination-brown {
	bs-pagination-active-bg: #B9761A !important; 
	bs-pagination-active-border-color: #B9761A !important; 
	bs-pagination-hover-color: #B9761A !important;
}

.post-card-img {
  height: 100px; !important;     
  object-fit: contain; !important; 
  border-radius: 8px; !important; 
}

.post-item { border: 0; border-bottom: 1px solid #e5e7eb; border-radius: 0; }
.post-thumb-wrap { width: 120px; height: 120px; flex: 0 0 120px; }
.post-thumb { width: 100%; height: 100%; object-fit: cover; border-radius: 8px;}
.post-title { font-weight: 700; font-size: 1.5rem; margin: 0; }
.post-meta { color:#6b7280; font-size: .875rem; }
.post-stats img { vertical-align: -2px; }
.post-link { text-decoration: none; color: inherit; display:block; }
</style>
<!-- Bootstrap -->
<body>
<%@ include file="/WEB-INF/views/component/header.jsp"%>

	<div class="container my-5" style="max-width: 980px;">
		<h1 class="fw-bold fs-1 mb-4">커뮤니티</h1>


		<!-- Search -->
		<form class="d-flex align-items-center gap-2 mb-3 flex-wrap"
			method="get" action="<c:url value='/community'/>">
			<input type="hidden" name="category" value="${category}">
			<div class="position-relative flex-grow-1">
				<input type="text" name="q" value="${q}" class="form-control ps-5"
					placeholder="제목 또는 닉네임으로 검색">
			</div>
			<button class="btn btn-outline-secondary">검색</button>
		</form>

		<!-- Tabs -->
		<nav class="nav nav-pills gap-2" id="categoryTabs">
			<a href="#"
				class="nav-link rounded-pill tab ${category == 'PRIDE' ? 'active' : ''}"
				data-category="PRIDE"> 내 반려동물 자랑 게시판</a> <a href="#"
				class="nav-link rounded-pill tab ${category == 'JOB' ? 'active' : ''}"
				data-category="JOB">펫 관련 알바 구하기 게시판</a> <a href="#"
				class="nav-link rounded-pill tab ${category == 'TIPS' ? 'active' : ''}"
				data-category="TIPS">반려동물 키우는 팁 게시판</a> <a href="#"
				class="nav-link rounded-pill tab ${category == 'MISSING' ? 'active' : ''}"
				data-category="MISSING">실종 동물 찾기 게시판</a>
		</nav>
		<div class="d-flex justify-content-between align-items-center mt-2">
			<button type="button"
				class="btn btn-secondary-brown btn-fixed-width ${category == null ? 'active' : ''}	"
				id="btnAll">전체보기</button>
				<c:if test="${!empty userId }">
					<a class="btn btn-brown btn-fixed-width" id="btnNewPost" href="<c:url value='/community/new'/>">
						새 글 작성
					</a>
				</c:if>

		</div>
	</div>

	<!-- Posts -->
<div id="postContainer" class="container" style="max-width: 980px;">
  <c:choose>
    <c:when test="${empty list}">
      <div class="text-center text-muted py-5">게시글이 없습니다.</div>
    </c:when>

    <c:otherwise>
      <c:forEach var="p" items="${list}">
        <a class="post-link" href="<c:url value='/community/${p.communityId}'/>">
          <article class="card post-item py-3">
            <div class="card-body py-0">
              <div class="d-flex gap-3">
                
                <!-- 썸네일 -->
                <div class="post-thumb-wrap">
                  <c:choose>
                    <c:when test="${p.image != null}">
                      <img class="post-thumb"
                           src="<c:url value='/community/${p.communityId}/image'/>?v=${p.viewcount}"
                           alt="썸네일">
                    </c:when>
                    <c:otherwise>
                      <img class="post-thumb"
                           src="<c:url value='/resources/image/img_noImg.png'/>"
                           alt="썸네일 없음">
                    </c:otherwise>
                  </c:choose>
                </div>

                <!-- 우측 내용 -->
                <div class="flex-grow-1 d-flex flex-column justify-content-between">
                  
                  <!-- 닉네임  날짜 -->
                  <div class="d-flex justify-content-between post-meta-top">
                    <span class="fw-semibold"><c:out value="${p.nickname}"/></span>
                    <small>
                      <fmt:formatDate value="${p.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </small>
                  </div>
                  
                  <!-- 제목 -->
                  <h3 class="post-title">
                    <c:out value="${p.title}"/>
                  </h3>

                  <!-- 조회수/댓글 -->
                  <div class="d-flex gap-3 text-muted post-stats">
                    <span>
                      <img src="<c:url value='/resources/image/ico_watch.png'/>" width="16" height="16" alt="조회수">
                      <c:out value="${p.viewcount}"/>
                    </span>
                    <span>
                      <img src="<c:url value='/resources/image/ico_comment.png'/>" width="16" height="16" alt="댓글">
                      <c:out value="${p.commentCount}"/>
                    </span>
                  </div>

                </div>
              </div>
            </div>
          </article>
        </a>
      </c:forEach>
    </c:otherwise>
  </c:choose>
</div>


	<!-- Pagination (SSR) -->
	<div class="container" style="max-width: 980px;">
		<c:if test="${totalPages > 1}">
			<ul class="pagination justify-content-center pagination-brown">
				<!-- Prev -->
				<c:url var="prevUrl" value="/community">
					<c:if test="${not empty category}">
						<c:param name="category" value="${category}" />
					</c:if>
					<c:if test="${not empty q}">
						<c:param name="q" value="${q}" />
					</c:if>
					<c:param name="page" value="${page > 1 ? page-1 : 1}" />
				</c:url>
				<li class="page-item ${page == 1 ? 'disabled' : ''}"><a
					class="page-link" href="${prevUrl}">&laquo; Previous</a></li>

				<!-- Pages -->
				<c:forEach var="i" begin="1" end="${totalPages}">
					<c:url var="pUrl" value="/community">
						<c:if test="${not empty category}">
							<c:param name="category" value="${category}" />
						</c:if>
						<c:if test="${not empty q}">
							<c:param name="q" value="${q}" />
						</c:if>
						<c:param name="page" value="${i}" />
					</c:url>
					<li class="page-item ${page == i ? 'active' : ''}"><a
						class="page-link" href="${pUrl}">${i}</a></li>
				</c:forEach>

				<!-- Next -->
				<c:url var="nextUrl" value="/community">
					<c:if test="${not empty category}">
						<c:param name="category" value="${category}" />
					</c:if>
					<c:if test="${not empty q}">
						<c:param name="q" value="${q}" />
					</c:if>
					<c:param name="page"
						value="${page < totalPages ? page+1 : totalPages}" />
				</c:url>
				<li class="page-item ${page == totalPages ? 'disabled' : ''}">
					<a class="page-link" href="${nextUrl}">Next &raquo;</a>
				</li>
			</ul>
		</c:if>
	</div>

	<%@ include file="/WEB-INF/views/component/footer.jsp"%>

<!--탭/전체보기만 서버 이동 -->
<script>

  (function() {
    const tabs = document.querySelectorAll('#categoryTabs .tab');
    const btnAll = document.getElementById('btnAll');
    function go(params) {
      const url = new URL('<c:url value="/community"/>', location.origin);
      if (params.category) url.searchParams.set('category', params.category);
      if (params.q)        url.searchParams.set('q', params.q);
      if (params.page)     url.searchParams.set('page', params.page);
      location.href = url.toString();
    }
    tabs.forEach(tab => {
      tab.addEventListener('click', (e) => {
        e.preventDefault();
        go({ category: tab.dataset.category, page: 1, q: new URL(location.href).searchParams.get('q') || '' });
      });
    });
    if (btnAll) btnAll.addEventListener('click', () => go({}));
  })();
  
  
</script>

</body>
</html>