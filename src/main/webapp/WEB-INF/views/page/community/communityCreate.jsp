<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새 글 작성</title>
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css"
	rel="stylesheet">
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
	<jsp:include page="/WEB-INF/views/component/header.jsp" />

	<div class="container my-5" style="max-width: 980px;">
		<h1 class="fw-bold fs-1 mb-4">새 글 작성</h1>

		<c:if test="${not empty error}">
			<div class="alert alert-danger">${error}</div>
		</c:if>

		<section class="card shadow-sm border-0">
			<div class="card-body">
				<form method="post" action="<c:url value='/community'/>"
					enctype="multipart/form-data" class="row g-4">

					<!-- 카테고리 -->
					<div class="col-12 col-md-6">
						<label class="form-label fw-semibold">카테고리</label> <select
							name="category" class="form-select" required id="category">
							<option value="" disabled
								<c:if test="${empty form.category}">selected</c:if>>선택하세요</option>
							<option value="PRIDE"
								<c:if test="${form.category == 'PRIDE'}">selected</c:if>>내
								반려동물을 자랑하는 게시판</option>
							<option value="JOB"
								<c:if test="${form.category == 'JOB'}">selected</c:if>>펫
								관련 알바 구하기 게시판</option>
							<option value="TIPS"
								<c:if test="${form.category == 'TIPS'}">selected</c:if>>반려동물
								키우는 팁 게시판</option>
							<option value="MISSING"
								<c:if test="${form.category == 'MISSING'}">selected</c:if>>실종
								동물을 찾아주세요 게시판</option>
						</select>
					</div>

					<!-- 제목 -->
					<div class="col-12">
						<label class="form-label fw-semibold">제목</label> <input
							type="text" name="title" class="form-control"
							placeholder="제목을 입력하세요" value="${form.title}" required>
					</div>

					<!-- 본문 -->
					<div class="col-12">
						<label class="form-label fw-semibold">본문 내용</label>
						<textarea name="content" class="form-control" rows="12"
							placeholder="본문을 입력하세요" required>${form.content}</textarea>
					</div>

					<!-- 이미지 한 장  -->
					<div class="col-12">
						<label class="form-label fw-semibold"> 대표 이미지 <span
							id="imageRequiredMark" class="badge text-bg-danger"
							style="display: none;">PRIDE: 필수</span>
						</label> <input type="file" name="imageFile" id="imageFile"
							class="form-control" accept="image/*">
						<div class="form-text">JPG/PNG 권장, 5MB 이하</div>

						<!-- 미리보기 -->
						<div class="mt-3">
							<div class="col-6 col-md-4 col-lg-3">
								<div class="card h-100">
									<img id="imagePreview" class="card-img-top" alt="대표 이미지 미리보기"
										style="height: 160px; object-fit: cover; display: none;">
								</div>
							</div>
						</div>

					</div>

					<!-- 버튼 -->
					<div class="col-12 d-flex justify-content-end gap-2">
						<a class="btn btn-outline-secondary"
							href="<c:url value='/community'/>">취소</a>
						<button type="submit" class="btn btn-brown" id="submitBtn">등록</button>
					</div>
				</form>
			</div>
		</section>
	</div>

	<jsp:include page="/WEB-INF/views/component/footer.jsp" />

	<script>
	(function () {
		  var categorySel = document.getElementById('category');
		  var imageInput  = document.getElementById('imageFile');
		  var mark        = document.getElementById('imageRequiredMark');
		  var previewImg  = document.getElementById('imagePreview');

		  function syncRequired(){
		    var required = (categorySel && categorySel.value === 'PRIDE');
		    if (imageInput) imageInput.required = required;
		    if (mark) mark.style.display = required ? 'inline-block' : 'none';
		  }

		  function updatePreview() {
		    if (!imageInput || !previewImg) return;
		    var file = imageInput.files && imageInput.files[0];
		    if (!file) { 
		      previewImg.removeAttribute('src');
		      previewImg.style.display = 'none';
		      return;
		    }
		    if (file.size > 5 * 1024 * 1024) {
		      alert('이미지 용량은 5MB 이하만 업로드할 수 있습니다.');
		      imageInput.value = '';
		      previewImg.removeAttribute('src');
		      previewImg.style.display = 'none';
		      return;
		    }
		    var reader = new FileReader();
		    reader.onload = function(e){
		      previewImg.src = e.target.result;
		      previewImg.style.display = 'block';  
		    };
		    reader.readAsDataURL(file);
		  }

		  function beforeSubmit(e){
		    if (categorySel && categorySel.value === 'PRIDE') {
		      if (!imageInput || !imageInput.files || imageInput.files.length === 0) {
		        e.preventDefault();
		        alert('PRIDE 카테고리는 이미지를 반드시 업로드해야 합니다.');
		        return false;
		      }
		    }
		  }

		  if (categorySel) categorySel.addEventListener('change', syncRequired);
		  if (imageInput)  imageInput.addEventListener('change', updatePreview);
		  document.getElementById('submitBtn').addEventListener('click', beforeSubmit);

		  syncRequired();
		})();

  </script>
</body>
</html>