<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 수정하기</title>
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
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

.edit-current-img {
  max-width: 100%; !important; 
  height: auto; !important;      
  object-fit: contain; !important; 
  margin: 0 auto; !important;
}
</style>
<body>
	<!-- 헤더 영역 -->
	<%@ include file="/WEB-INF/views/component/header.jsp"%>

	<div class="container my-5" style="max-width: 980px;">
		<h1 class="fw-bold fs-1 mb-4">글 수정</h1>
		<!-- ===== 게시글 수정 ===== -->
		<section class="card border-0 shadow-sm mb-5">
			<div class="card-body">
				<!-- 수정 폼 -->
				<form
					action="${pageContext.request.contextPath}/community/${post.communityId}/edit"
					method="post" enctype="multipart/form-data">

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
					</div>

					<!-- 현재 이미지 + 교체/삭제 옵션 -->
					<div class="col-12">
						<!-- 옵션 라디오 -->
						<div class="d-flex flex-wrap align-items-center gap-3 mt-2">
							<div class="form-check">
								<input type="radio" name="imgAction" id="imgKeep" value="keep"
									checked> <label class="form-check-label" for="imgKeep">유지</label>
							</div>
							<div class="form-check">
								<input type="radio" name="imgAction" id="imgReplace"
									value="replace"> <label class="form-check-label"
									for="imgReplace">교체</label>
							</div>
							<c:if test="${post.category != 'PRIDE'}">
								<div class="form-check">
									<input type="radio" name="imgAction" id="imgDelete"
										value="delete"> <label class="form-check-label"
										for="imgDelete">이미지 삭제</label>
								</div>
							</c:if>
						</div>
					</div>

					<!-- 미리보기: 업로드 블록 바깥으로 분리 -->
					<div class="col-12 mt-3">
					<c:if test="${post.image != null}">
						<div class="fw-semibold mb-1">미리보기</div>
						</c:if>
						<img id="previewImg" class="edit-current-img" alt="미리보기"
        					 src="<c:url value='/community/${post.communityId}/image'/>?v=${post.viewcount}"
							style="<c:choose>
                <c:when test='${post.image != null}'>display:block;</c:when>
                <c:otherwise>display:none;</c:otherwise>
              </c:choose>">
					</div>

					<!-- 교체 선택 시에만 보일 파일 입력 -->
					<div class="col-12" id="replaceBlock" style="display: none;">
						<label for="imageFile" class="form-label fw-semibold">새
							이미지</label> <input type="file" id="imageFile" name="imageFile"
							class="form-control" accept="image/*">
						<div class="form-text">JPG/PNG 권장</div>
					</div>

					<!-- 버튼 -->
					<div class="col-12 d-flex justify-content-end gap-2">
						<a class="btn btn-outline-secondary"
							href="<c:url value='/community'/>">취소</a>
						<button type="submit" class="btn btn-brown">저장</button>
					</div>
				</form>


			</div>
		</section>
	</div>
	<!-- footer 영역 -->
	<%@ include file="/WEB-INF/views/component/footer.jsp"%>
		
		<!-- ===== 게시글 수정 ===== -->

		<script>
 (function(){
	  const keep    = document.getElementById('imgKeep');
	  const replace = document.getElementById('imgReplace');
	  const del     = document.getElementById('imgDelete'); // PRIDE면 null
	  const block   = document.getElementById('replaceBlock');
	  const input   = document.getElementById('imageFile');
	  const preview = document.getElementById('previewImg');

	  // 서버에 기존 이미지가 있는지 여부(초기 표시 상태로 판별)
	  const hadExisting = preview && preview.style.display !== 'none' && preview.getAttribute('src');

	  function resetFileInput(){
	    if (input) input.value = '';
	  }

	  function syncUI(){
	    const isDelete = !!(del && del.checked);

	    if (isDelete){
	      block.style.display = 'none';
	      resetFileInput();
	      return;
	    }
	    // 교체 선택 시에만 파일 입력 보이기
	    block.style.display = (replace && replace.checked) ? '' : 'none';

	    // keep이면: 기존 이미지가 있으면 그대로 표시, 없으면 숨김
	    if (keep && keep.checked){
	      if (hadExisting) {
	        // 그대로 유지
	      } else {
	        preview.style.display = 'none';
	        preview.removeAttribute('src');
	      }
	    }
	  }

	  [keep, replace, del].forEach(el => el && el.addEventListener('change', syncUI));

	  // 파일 선택 시 미리보기 교체
	  input && input.addEventListener('change', (e)=>{
	    const f = e.target.files && e.target.files[0];
	    if (!f){
	      // 파일 해제 시: 기존이 있으면 되돌려 표시, 없으면 숨김
	      if (hadExisting){
	        // 그대로 두기(서버 이미지)
	      } else {
	        preview.style.display = 'none';
	        preview.removeAttribute('src');
	      }
	      return;
	    }
	    if (replace) replace.checked = true;
	    syncUI();
	    const url = URL.createObjectURL(f);
	    preview.src = url;
	    preview.style.display = '';
	    preview.onload = ()=> URL.revokeObjectURL(url);
	  });

	  // 초기 동기화
	  syncUI();
	})();

</script>
</body>
</html>