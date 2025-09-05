<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="/miniproj/resource/css/bootstrap.min.css" rel="stylesheet">
<link href="/miniproj/resource/css/common.css" rel="stylesheet">
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

/* ===== 상세 공통(추가) ===== */
.text-muted-700 {
	color: #4b5563;
}

.badge-role {
	background: #f3f4f6;
	color: #6b7280;
	border: 1px solid #e5e7eb;
}

.btn-outline-gray {
	border-color: #e5e7eb;
	color: #374151;
	background: #fff;
}

.btn-outline-gray:hover {
	background: #f9fafb;
	border-color: #d1d5db;
	color: #111827;
}

.btn-brown {
	background: #B9761A;
	color: #fff;
	border: 1px solid #B9761A;
}

.btn-brown:hover {
	filter: brightness(0.95);
	color: #fff;
}

.icon-16 {
	width: 16px;
	height: 16px;
}

.rounded-12 {
	border-radius: 12px;
}

.post-body p {
	margin-bottom: 1rem;
}

.count-dot::before {
	content: "•";
	margin: 0 .5rem;
	color: #9ca3af;
}

.post-cover {
	width: 100%;
	height: auto;
	border: 1px solid #e6e8eb;
	border-radius: 12px;
}

.divider {
	height: 1px;
	background: #e5e7eb;
}

.avatar-40 {
	width: 40px;
	height: 40px;
	border-radius: 50%;
	object-fit: cover;
}
</style>
<body>
	<!-- 헤더 영역 -->
	<%@ include file="/WEB-INF/views/component/header.jsp"%>
	<div class="container my-5" style="max-width: 980px;">
		<!-- Title -->
		<h1 class="fw-bold fs-1 mb-4">커뮤니티</h1>

		<!-- Searchbar -->
		<div class="d-flex align-items-center gap-2 mb-3 flex-wrap">
			<div class="position-relative flex-grow-1">
				<input type="text" class="form-control ps-5"
					placeholder="제목 또는 닉네임으로 검색">
				<svg
					class="position-absolute top-50 start-0 translate-middle-y ms-3 opacity-50"
					width="18" height="18" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="2">
        <circle cx="11" cy="11" r="7"></circle>
        <path d="m20 20-3.5-3.5"></path>
      </svg>
			</div>
			<button class="btn btn-outline-secondary">검색</button>
		</div>

		<!-- Tabs & Actions -->
		<div
			class="d-flex flex-wrap align-items-center justify-content-between mb-4 gap-2">
			<nav class="nav nav-pills gap-2">
				<a href="#" class="nav-link rounded-pill tab">내 반려동물을 자랑하는 게시판</a> <a
					href="#" class="nav-link rounded-pill tab">펫 관련 알바 구하기 게시판</a> <a
					href="#" class="nav-link rounded-pill tab">반려동물 키우는 팁 게시판</a> <a
					href="#" class="nav-link rounded-pill tab">실종 동물을 찾아주세요 게시판</a>
			</nav>
			<div class="d-flex gap-2 ms-auto">
				<a class="btn btn-outline-secondary"
					href="${pageContext.request.contextPath}/page/community/communityMain.jsp">전체보기</a>
				<a class="btn btn-brown"
					href="${pageContext.request.contextPath}/page/community/communityCreate.jsp">새글
					작성</a>
			</div>
		</div>

		<!-- ===== 상세 컨텐츠 START ===== -->
		<!-- Detail Card -->
		<article class="card shadow-sm border-0 mb-4">
			<div class="card-body">
				<!-- Author -->
				<div class="d-flex justify-content-between align-items-start mb-3">
					<div class="d-flex align-items-center gap-3">
						<div class="rounded-circle overflow-hidden"
							style="width: 40px; height: 40px;">
							<img src="https://picsum.photos/80/80?grayscale" alt=""
								class="img-fluid">
						</div>
						<div>
							<div class="d-flex align-items-center gap-2">
								<span class="fw-bold">김하나</span>
							</div>
							<small class="text-muted">2시간 전</small>
						</div>
					</div>
					<div class="d-flex gap-2">
						<a class="btn btn-outline-gray btn-sm" href="${pageContext.request.contextPath}/page/community/communityUpdate.jsp">수정하기</a>						
						<form method="post" action="/community/${post.id}/delete"
							class="m-0">
							<button type="submit" class="btn btn-outline-gray btn-sm">삭제하기</button>
						</form>
					</div>
				</div>

				<!-- Title -->
				<h2 class="fs-3 fw-bold mb-3">강아지 산책 시 주의할 점!</h2>

				<!-- Thumbnail -->
				<div class="rounded overflow-hidden border mb-3"
					style="height: 300px; background: url('https://images.unsplash.com/photo-1534361960057-19889db9621e?q=80&amp;w=1200&amp;auto=format&amp;fit=crop') center/cover no-repeat;">
				</div>

				<!-- Content -->
				<p class="text-secondary lh-lg mb-3">요즘 날씨가 너무 좋아서 강아지 산책하기 딱
					좋은데요! 산책할 때 꼭 챙겨야 할 준비물과 주의할 점들을 공유합니다. 배변 봉투, 물, 그리고 목줄은 필수겠죠? 혹시
					놓치기 쉬운 점이 있을까요?</p>

				<hr>

				<!-- Stats -->
				<div class="d-flex gap-4 text-muted">
					<div class="d-flex align-items-center gap-1">
						<img src="/miniproj/image/ico_like.png" alt="좋아요" width="18"
							height="18"> <span>1,234</span>
					</div>
					<div class="d-flex align-items-center gap-1">
						<img src="/miniproj/image/ico_comment.png" alt="댓글" width="18"
							height="18"> <span>45</span>
					</div>
					<div class="d-flex align-items-center gap-1">
						<img src="/miniproj/image/ico_watch.png" alt="조회수" width="18"
							height="18"> <span>210</span>
					</div>
				</div>
			</div>
		</article>
		<!-- ===== 상세 컨텐츠 END ===== -->

		<!-- 댓글 -->
    <section class="bg-white rounded-12 border p-3 p-sm-4">
      <h3 class="fs-5 mb-3">댓글 <span class="text-muted">(<span id="cmtCnt">${post.commentCount}</span>)</span></h3>

      <!-- 댓글 작성 (표시 여부 JS로 제어) -->
      <div id="commentWrite" data-auth="${isAuthenticated}">
        <form class="mb-4" method="post" action="${pageContext.request.contextPath}/community/${post.id}/comments">
          <textarea name="content" class="form-control mb-2" rows="3" placeholder="댓글을 남겨보세요"></textarea>
          <div class="text-end">
            <button type="submit" class="btn btn-brown btn-sm">댓글 등록</button>
          </div>
        </form>
      </div>

      <!-- 댓글 리스트 (서버 렌더링을 못 쓰는 경우, JS로 주입 가능) -->
      <div class="list-group list-group-flush" id="commentList">
        <!-- 서버에서 직접 그려 넣을 수 있으면 여기 정적 HTML로 넣으세요 -->
        <!-- 예: 반복문 없이 백엔드에서 이미 문자열로 만들어 전달했다면 ${commentsHtml} 출력 -->
      </div>

      <div id="noComment" class="text-center text-muted py-4">첫 댓글을 남겨보세요.</div>
    </section>
		<!-- ===== 댓글 영역 END ===== -->

    <!-- 목록/이전다음 -->
    <div class="d-flex justify-content-between align-items-center mt-4">
      <a href="${pageContext.request.contextPath}/community" class="btn btn-outline-secondary">목록으로</a>
      <div class="d-flex gap-2">
        <!-- 이전/다음 링크는 존재 여부를 JS로 토글 -->
        <a id="prevBtn" class="btn btn-outline-secondary"
           href="${pageContext.request.contextPath}/community/${prevPost.id}"
           data-exists="${prevPost != null}">이전 글</a>
        <a id="nextBtn" class="btn btn-outline-secondary"
           href="${pageContext.request.contextPath}/community/${nextPost.id}"
           data-exists="${nextPost != null}">다음 글</a>
      </div>
    </div>
  </div>

    
	<!-- footer 영역 -->
	<%@ include file="/WEB-INF/views/component/footer.jsp"%>
</body>
</html>