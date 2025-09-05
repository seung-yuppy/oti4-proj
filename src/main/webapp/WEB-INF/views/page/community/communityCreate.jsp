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
			<a class></a>
				<a class="btn btn-outline-secondary" href="/bughunters/communityMain">전체보기</a>
<a class="btn btn-brown" href="${pageContext.request.contextPath}/page/community/communityCreate.jsp">새글 작성</a>
			</div>
		</div>

		<!-- ===== 게시글 작성 (communityCreate) START ===== -->
		<section class="card shadow-sm border-0 mb-5">
			<div class="card-header bg-white">
				<h2 class="fs-5 fw-bold mb-0">새 글 작성</h2>
			</div>

			<div class="card-body">
				<!-- 파일 업로드가 있으므로 multipart 필수 -->
				<form method="post" action="/community/create"
					enctype="multipart/form-data" class="row g-4">

					<!-- 제목 -->
					<div class="col-12">
						<label class="form-label fw-semibold">제목</label> <input
							type="text" name="title" class="form-control"
							placeholder="제목을 입력하세요" required>
					</div>
					<!-- 본문 -->
					<div class="col-12">
						<label class="form-label fw-semibold">본문 내용</label>
						<textarea name="content" class="form-control" rows="12"
							placeholder="본문을 입력하세요" required></textarea>
						<div class="form-text">줄바꿈은 그대로 저장됩니다. (Shift+Enter로 줄바꿈)</div>
					</div>

					<div class="col-12">
						<label class="form-label fw-semibold">대표 이미지 (선택)</label> <input
							type="file" name="coverFile" id="coverFile" class="form-control"
							accept="image/*">
						<div class="form-text">JPG/PNG 권장, 5MB 이하</div>

						<!-- 미리보기: 업로드 아래에 배치 -->
						<div class="mt-3">
							<label class="form-label fw-semibold">미리보기</label>
							<div class="col-6 col-md-4 col-lg-3">
								<div class="card h-100">
									<img id="coverPreview"
										src="https://images.unsplash.com/photo-1534361960057-19889db9621e?q=80&amp;w=1200&amp;auto=format&amp;fit=crop"
										class="card-img-top" alt="대표 이미지 미리보기"
										style="height: 160px; object-fit: cover;">
									<div class="card-body p-2">
										<div class="small text-muted">대표 이미지</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- 하단 버튼 -->
					<div class="col-12 d-flex justify-content-end gap-2">
						<a class="btn btn-outline-secondary" href="/bughunters/communityMain">취소</a>
						<button type="submit" class="btn btn-primary">등록</button>
					</div>
				</form>
			</div>
		</section>
		<!-- ===== 게시글 작성 END ===== -->
		<!-- footer 영역 -->
		<%@ include file="/WEB-INF/views/component/footer.jsp"%>


		<script>
  // 간단한 미리보기 & 용량 체크
  (function () {
    const input = document.getElementById('coverFile');
    const img = document.getElementById('coverPreview');
    const btn = document.getElementById('btnPreview');
    const PLACEHOLDER = 'https://images.unsplash.com/photo-1534361960057-19889db9621e?q=80&w=1200&auto=format&fit=crop';

    function updatePreview() {
      const file = input && input.files && input.files[0];
      if (!file) { img.src = PLACEHOLDER; return; }
      if (file.size > 5 * 1024 * 1024) {
        alert('이미지 용량은 5MB 이하만 업로드할 수 있습니다.');
        input.value = '';
        img.src = PLACEHOLDER;
        return;
      }
      const reader = new FileReader();
      reader.onload = e => { img.src = e.target.result; };
      reader.readAsDataURL(file);
    }

    if (input) input.addEventListener('change', updatePreview);
    if (btn) btn.addEventListener('click', updatePreview);
  })();
</script>
</body>
</html>