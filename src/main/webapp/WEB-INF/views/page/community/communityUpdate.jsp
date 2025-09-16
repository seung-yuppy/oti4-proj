<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
				<button class="btn btn-brown">새 글 작성</button>
			</div>
		</div>

		<!-- ===== 게시글 수정(communityUpdate) START ===== -->
		<section class="card border-0 shadow-sm mb-5">
			<div class="card-body">
				<!-- 수정 폼 -->
				<form method="post"
					action="<c:url value='/community/${post.communityId}/edit'/>"
					enctype="multipart/form-data" class="row g-4">

					<!-- 제목 -->
					<div class="col-12">
						<label class="form-label fw-semibold">제목</label> <input
							type="text" name="title" class="form-control" required
							maxlength="100" placeholder="제목을 입력하세요" value="${post.title}">
					</div>

					<!-- 본문 -->
					<div class="col-12">
						<label class="form-label fw-semibold">본문 내용</label>
						<textarea name="content" id="content" class="form-control"
							rows="12" placeholder="본문을 입력하세요">${post.content}</textarea>
						<div class="form-text">Shift+Enter로 줄바꿈</div>
					</div>

					<!-- 현재 이미지 + 교체/삭제 옵션 -->
					<div class="col-12">
						<label class="form-label fw-semibold d-block mb-2">현재 이미지</label>
						<img class="edit-current-img mb-2"
							src="<c:url value='/community/${post.communityId}/image'/>"
							alt="현재 이미지">

						<div class="d-flex flex-wrap align-items-center gap-3 mt-2">
							<div class="form-check">
								<input class="form-check-input" type="radio" name="imgAction"
									id="imgKeep" value="keep" checked> <label
									class="form-check-label" for="imgKeep">유지</label>
							</div>
							<div class="form-check">
								<input class="form-check-input" type="radio" name="imgAction"
									id="imgReplace" value="replace"> <label
									class="form-check-label" for="imgReplace">교체</label>
							</div>
							<div class="form-check">
								<input class="form-check-input" type="radio"
									name="deleteImage" id="imgDelete" value="1"> <label
									class="form-check-label" for="imgDelete">이미지 삭제</label>
							</div>
						</div>
					</div>

					<!-- 교체 선택 시에만 보일 파일 입력 + 미리보기 -->
					<div class="col-12" id="replaceBlock" style="display: none;">
						<label for="imageFile" class="form-label fw-semibold">새
							이미지 업로드</label> <input type="file" id="imageFile" name="image"
							class="form-control" accept="image/*">
						<div class="form-text">JPG/PNG 권장</div>

						<div class="mt-3">
							<div class="fw-semibold mb-1">미리보기</div>
							<img id="previewImg" class="edit-preview-img" alt="미리보기"
								style="display: none;">
						</div>
					</div>

					<!-- 버튼 -->
					<div class="col-12 d-flex justify-content-end gap-2">
						<a class="btn btn-outline-secondary"
							href="<c:url value='/community'/>">취소</a>
						<button type="submit" class="btn btn-primary">저장</button>
					</div>
				</form>


			</div>
			<!-- footer 영역 -->
			<%@ include file="/WEB-INF/views/component/footer.jsp"%>
		</section>
		<!-- ===== 게시글 수정 END ===== -->

		<script>
/* (function () {
  const fileInput = document.getElementById('imageFiles');
  const previewList = document.getElementById('previewList');

  const DUMMY_SRC = 'https://images.unsplash.com/photo-1534361960057-19889db9621e?q=80&w=1200&auto=format&fit=crop';

  function renderPreviews() {
    // 비우기
    previewList.innerHTML = '';

    const files = Array.from(fileInput.files || []);

    // 파일 없으면 더미 하나
    if (files.length === 0) {
      previewList.appendChild(makeCard(DUMMY_SRC, '더미 이미지', true));
      return;
    }

    // 파일 미리보기
    files.forEach((file, idx) => {
      const objectURL = URL.createObjectURL(file);
      const card = makeCard(objectURL, `파일 ${idx + 1}`);
      card.querySelector('img').addEventListener('load', () => {
        URL.revokeObjectURL(objectURL);
      });
      previewList.appendChild(card);
    });
  }

  function makeCard(src, caption, isDummy = false) {
    const col = document.createElement('div');
    col.className = 'col-6 col-md-4 col-lg-3';
    if (isDummy) col.dataset.dummy = 'true';

    const card = document.createElement('div');
    card.className = 'card h-100';

    const img = document.createElement('img');
    img.className = 'card-img-top';
    img.alt = caption || '이미지';
    img.style.objectFit = 'cover';
    img.style.height = '160px';
    img.src = src;
    img.onerror = function () { this.src = DUMMY_SRC; };

    const body = document.createElement('div');
    body.className = 'card-body p-2';

    const small = document.createElement('div');
    small.className = 'small text-truncate';
    small.title = caption;
    small.textContent = caption;

    body.appendChild(small);
    card.appendChild(img);
    card.appendChild(body);
    col.appendChild(card);

    return col;
  }

  // 파일 변경 시 자동 미리보기
  fileInput.addEventListener('change', renderPreviews);

  // 초기 렌더
  renderPreviews();
})(); */

(function(){
  const keep = document.getElementById('imgKeep');
  const replace = document.getElementById('imgReplace');
  const del = document.getElementById('imgDelete');
  const block = document.getElementById('replaceBlock');
  const input = document.getElementById('imageFile');
  const preview = document.getElementById('previewImg');

  function syncUI(){
    // 삭제 체크 시 교체 비활성화
    if (del.checked){
      replace.checked = false;
      keep.checked = true;
    }
    block.style.display = replace.checked ? '' : 'none';
    if (!replace.checked){
      input.value = '';
      preview.style.display = 'none';
      preview.src = '';
    }
  }

  [keep, replace, del].forEach(el => el.addEventListener('change', syncUI));

  input && input.addEventListener('change', (e)=>{
    const f = e.target.files && e.target.files[0];
    if (!f){ preview.style.display='none'; return; }
    const url = URL.createObjectURL(f);
    preview.src = url;
    preview.style.display = '';
    preview.onload = ()=> URL.revokeObjectURL(url);
  });

  syncUI();
})();

</script>
</body>
</html>