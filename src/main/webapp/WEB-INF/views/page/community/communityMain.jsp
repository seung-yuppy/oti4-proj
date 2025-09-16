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
	background: #B9761A; /* 호버 배경색 */
	border-color: #e6e8eb; /* 호버 테두리색 */
	color: #374151; /* 호버 글자색 */
}

/* Bootstrap의 기본 active(파란 배경) 제거 → 원본과 같은 '평상시' 스타일 유지 */
.nav-pills .tab.active {
	background: transparent !important;
	color: #374151 !important;
	border-color: transparent !important;
}

/* 접근성: 포커스 링은 유지하되 형태만 살짝 정리 */
.nav-pills .tab:focus {
	outline: none;
	box-shadow: 0 0 0 0.2rem rgba(185, 118, 26, 0.15);
}

.pagination-brown {
	bs-pagination-active-bg: #B9761A !important; 
	bs-pagination-active-border-color: #B9761A !important; 
	bs-pagination-hover-color: #B9761A !important;
}

.post-card-img {
  height: 200px; !important;     
  object-fit: contain; !important; 
  border-radius: 8px; !important; 
}
</style>
<!-- Bootstrap -->
<body>
<%@ include file="/WEB-INF/views/component/header.jsp"%>

<div class="container my-5" style="max-width:980px;">
  <h1 class="fw-bold fs-1 mb-4">커뮤니티</h1>
  

  <!-- Search -->
  <form class="d-flex align-items-center gap-2 mb-3 flex-wrap"
        method="get" action="<c:url value='/community'/>">
    <input type="hidden" name="category" value="${category}">
    <div class="position-relative flex-grow-1">
      <input type="text" name="q" value="${q}" class="form-control ps-5" placeholder="제목 또는 닉네임으로 검색">
    </div>
    <button class="btn btn-outline-secondary">검색</button>
  </form>

  <!-- Tabs -->
  <nav class="nav nav-pills gap-2" id="categoryTabs">
    <a href="#" class="nav-link rounded-pill tab ${category == 'PRIDE' ? 'active' : ''}"   data-category="PRIDE">내 반려동물을 자랑하는 게시판</a>
    <a href="#" class="nav-link rounded-pill tab ${category == 'JOB' ? 'active' : ''}"     data-category="JOB">펫 관련 알바 구하기 게시판</a>
    <a href="#" class="nav-link rounded-pill tab ${category == 'TIPS' ? 'active' : ''}"    data-category="TIPS">반려동물 키우는 팁 게시판</a>
    <a href="#" class="nav-link rounded-pill tab ${category == 'MISSING' ? 'active' : ''}" data-category="MISSING">실종 동물을 찾아주세요 게시판</a>
  </nav>
  <div class="d-flex gap-2 ms-auto mt-2">
    <button type="button" class="btn btn-outline-secondary" id="btnAll">전체보기</button>
    <a class="btn btn-brown" href="<c:url value='/community/new'/>">새 글 작성</a>
  </div>
</div>

<!-- Posts (SSR만 사용) -->
	<div id="postContainer" class="container" style="max-width: 980px;">
		<c:choose>
			<c:when test="${empty list}">
				<div class="text-center text-muted py-5">게시글이 없습니다.</div>
			</c:when>
			<c:otherwise>
				<c:forEach var="p" items="${list}">
					<a class="text-decoration-none text-dark"
						href="<c:url value='/community/${p.communityId}'/>">
						<article class="card shadow-sm border-0 mb-4">
							<div class="card-body">
								<!-- Author (아바타 없음) -->
								<div
									class="d-flex justify-content-between align-items-start mb-3">
									<div class="d-flex align-items-center">
										<div>
											<div class="d-flex align-items-center">
												<span class="fw-bold"><c:out value="${p.nickname}" /></span>
											</div>
											<small class="text-muted"> <fmt:formatDate
													value="${p.createdAt}" pattern="yyyy-MM-dd HH:mm" />
											</small>
										</div>
									</div>
									<span class="text-muted fs-4" role="button">⋯</span>
								</div>

								<!-- Title -->
								<h2 class="fs-3 fw-bold mb-3">
									<c:out value="${p.title}" />
								</h2>

								<!-- Thumbnail -->

								<c:if test="${p.image != null}">
										<img src="<c:url value='/community/${p.communityId}/image'/>"
										alt="${p.title}" class="post-card-img"/>
								</c:if>

								<!-- Excerpt -->
								<c:set var="excerpt"
									value="${fn:length(p.content) > 160 ? fn:substring(p.content, 0, 160) : p.content}" />
								<p class="text-secondary lh-lg mb-3">
									<c:out value="${excerpt}" />
									<c:if test="${fn:length(p.content) > 160}">...</c:if>
								</p>

								<hr>

								<!-- Stats -->
								<div class="d-flex gap-4 text-muted">
									<div class="d-flex align-items-center gap-1">
										<img src="<c:url value='/resources/image/ico_watch.png'/>"
											alt="조회수" width="18" height="18"> <span><c:out
												value="${p.viewcount}" /></span>
									</div>
									<div class="d-flex align-items-center gap-1">
										<img src="<c:url value='/resources/image/ico_comment.png'/>"
											alt="댓글" width="18" height="18"> <span><c:out
												value="${p.commentCount}" /></span>
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