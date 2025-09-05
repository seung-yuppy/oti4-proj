<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
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
.pagination-brown { /* 원하는 페이지에서만 사용 */
  --bs-pagination-active-bg: #B9761A !important;
  --bs-pagination-active-border-color: #B9761A !important;
  --bs-pagination-hover-color: #B9761A !important;
}
</style>
<!-- Bootstrap -->
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
				<button class="btn btn-outline-secondary">전체보기</button>
				<a class="btn btn-brown"
					href="/bughunters/communityCreate">새
					글 작성</a>
			</div>
		</div>

		<!-- Card -->
		<a class="text-decoration-none text-dark"
			href="/bughunters/communityDetail">
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
						<span class="text-muted fs-4" role="button">⋯</span>
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
							<img src="/bughunters/resources/image/ico_like.png" alt="좋아요" width="18"
								height="18"> <span>1,234</span>
						</div>
						<div class="d-flex align-items-center gap-1">
							<img src="/bughunters/resources/image/ico_comment.png" alt="댓글" width="18"
								height="18"> <span>45</span>
						</div>
						<div class="d-flex align-items-center gap-1">
							<img src="/bughunters/resources/image/ico_watch.png" alt="조회수" width="18"
								height="18"> <span>210</span>
						</div>
					</div>
				</div>
			</article>
		</a>

		<!-- Pagination -->
		<nav>
			<ul class="pagination justify-content-center pagination-brown">
				<li class="page-item"><a class="page-link" href="#"><span
						aria-hidden="true">&laquo;</span> Previous</a></li>
				<li class="page-item active"><span class="page-link">1</span></li>
				<li class="page-item"><a class="page-link" href="#">2</a></li>
				<li class="page-item"><a class="page-link" href="#">3</a></li>
				<li class="page-item"><a class="page-link" href="#">4</a></li>
				<li class="page-item"><a class="page-link" href="#">5</a></li>
				<li class="page-item"><a class="page-link" href="#">Next <span
						aria-hidden="true">&raquo;</span></a></li>
			</ul>
		</nav>
	</div>

	<script>
  document.addEventListener('DOMContentLoaded', function() {
    // 페이지 링크 요소들 가져오기
    var pageLinks = document.querySelectorAll('.pagination.pagination-brown .page-item a.page-link');
    
    // 각 링크에 이벤트 리스너 추가
    for(var i = 0; i < pageLinks.length; i++) {
      pageLinks[i].addEventListener('click', function(e) {
        // 기본 링크 동작 방지
        e.preventDefault();
        
        // 현재 active 클래스 제거
        var currentActive = document.querySelector('.pagination.pagination-brown .page-item.active');
        if(currentActive) {
          currentActive.classList.remove('active');
        }
        
        // 클릭된 링크의 부모 요소에 active 클래스 추가
        this.parentNode.classList.add('active');
        
        // 페이지 번호 가져오기
        var pageNum = this.innerText;
        if(pageNum.includes('Previous')) {
          // 이전 페이지 처리
          pageNum = '이전';
        } else if(pageNum.includes('Next')) {
          // 다음 페이지 처리
          pageNum = '다음';
        }
        
        console.log('페이지 ' + pageNum + '(으)로 이동');
        
        // 여기에 페이지 이동 로직 추가
        // location.href = '현재페이지URL?page=' + pageNum;
      });
    }
  });
</script>
	<!-- footer 영역 -->
	<%@ include file="/WEB-INF/views/component/footer.jsp"%>
</body>
</html>