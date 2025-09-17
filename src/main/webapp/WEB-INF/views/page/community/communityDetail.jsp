<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티 게시글 상세보기</title>
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

.post-detail-img {
  width: 100%; !important; 
  height: auto; !important;      
  /* object-fit: contain; !important;  */
}
</style>
<body>

	<%@ include file="/WEB-INF/views/component/header.jsp"%>

	<div class="container my-5" style="max-width: 980px;">

		<!-- ===== 상세 카드 ===== -->
		<article class="card shadow-sm border-0 mb-4">
			<div class="card-body">
				<!-- 작성자/시간 -->
				<div class="d-flex justify-content-between align-items-start mb-3">
					<div class="d-flex align-items-center gap-3">
						<div>
							<div class="d-flex align-items-center gap-2">
								<span class="fw-bold"><c:out value="${post.nickname}" /></span>
							</div>
							<small class="text-muted"> <fmt:formatDate
									value="${post.createdAt}" pattern="yyyy-MM-dd HH:mm" />
							</small>
						</div>
					</div>

					<c:if test="${isOwner}">
						<div class="d-flex gap-2">
							<a class="btn btn-outline-gray btn-sm"
								href="${pageContext.request.contextPath}/community/${post.communityId}/edit">수정하기</a>
							<form method="post"
								action="${pageContext.request.contextPath}/community/${post.communityId}/delete"
								class="m-0" onsubmit="return confirm('게시글을 삭제하시겠습니까?');">
								<c:if test="${not empty _csrf}">
									<input type="hidden" name="${_csrf.parameterName}"
										value="${_csrf.token}" />
								</c:if>
								<button type="submit" class="btn btn-outline-gray btn-sm">삭제하기</button>
							</form>
						</div>
					</c:if>
				</div>

				<!-- 제목 -->
				<h2 class="fs-3 fw-bold mb-3">
					<c:out value="${post.title}" />
				</h2>

				<!-- 썸네일: 이미지 있을 때만 표시 -->
				<c:if test="${post.image != null}">
					<div class="mb-3">
						<img class="mb-2 post-detail-img"
							src="<c:url value='/community/${post.communityId}/image'/>?v=${post.viewcount}"
							alt="현재 이미지" style="display: none"
							onload="this.style.display='';"
							onerror="this.style.display='none'">
					</div>
				</c:if>

				<!-- 본문 (개행 유지) -->
				<div class="text-secondary lh-lg mb-3"
					style="white-space: pre-line;">
					<c:out value="${post.content}" />
				</div>

				<hr>

				<!-- 조회수 -->
				<div class="d-flex gap-4 text-muted">
					<div class="d-flex align-items-center gap-1">
						<img
							src="${pageContext.request.contextPath}/resources/image/ico_watch.png"
							alt="조회수" width="18" height="18"> <span><c:out
								value="${post.viewcount}" /></span>
					</div>
				</div>
			</div>
		</article>

		<!-- ===== 댓글 ===== -->
		<section class="bg-white rounded-12 border p-3 p-sm-4">
			<h3 class="fs-5 mb-3">
				댓글 <span class="text-muted">(<span id="cmtCnt"><c:out
							value="${commentCount}" /></span>)
				</span>
			</h3>

			<!-- 댓글 작성 -->
			<form class="mb-4" method="post"
				action="${pageContext.request.contextPath}/community/${post.communityId}/comments"
				onsubmit="return checkCommentLength();">
				<textarea id="commentContent" name="content" class="form-control mb-2" rows="3"  placeholder="댓글을 남겨보세요" required></textarea>
				<!-- maxlength는 빼고 JS에서 바이트 기준 체크 -->
				<div class="d-flex justify-content-between">
					<small id="charCount" class="text-muted">255 바이트까지 가능합니다</small>
					<!-- ✅ 카운터 -->
					<button type="submit" class="btn btn-brown btn-sm">댓글 등록</button>
				</div>
			</form>
			<hr>

			<!-- 댓글 리스트 -->
			<c:choose>
				<c:when test="${empty comments}">
					<div id="noComment" class="text-center text-muted py-4">첫 댓글을
						남겨보세요.</div>
				</c:when>
				<c:otherwise>
					<div class="list-group list-group-flush" id="commentList">
						<c:forEach var="c" items="${comments}">
							<div class="d-flex align-items-center justify-content-between">
								<div class="comment-meta">
									<span>${c.nickname}</span>
									<span class="text-muted">
										<fmt:formatDate value="${c.createdAt}" pattern="yyyy-MM-dd HH:mm" />
									</span>
								</div>

								<c:if
									test="${isAuthenticated && c.userId == sessionScope.userId}">
									<form method="post"
										action="${pageContext.request.contextPath}/community/${post.communityId}/comments/${c.commentId}/delete"
										onsubmit="return confirm('댓글을 삭제할까요?');" class="m-0">
										<input type="hidden" name="cpage" value="${cpage}"> <input
											type="hidden" name="csize" value="${csize}">
										<c:if test="${not empty _csrf}">
											<input type="hidden" name="${_csrf.parameterName}"
												value="${_csrf.token}">
										</c:if>
										<button type="submit" class="btn btn-outline-gray btn-sm">삭제</button>
									</form>
								</c:if>
							</div>
							<c:out value="${c.content}" />
							<hr>
						</c:forEach>
					</div>
				</c:otherwise>
			</c:choose>
		</section>

		<!-- 목록/이전다음 -->
		<div class="d-flex justify-content-between align-items-center mt-4">
			<a href="${pageContext.request.contextPath}/community"
				class="btn btn-outline-secondary">목록으로</a>
			<div class="d-flex gap-2">
				<c:if test="${not empty prevPost}">
					<a class="btn btn-outline-secondary"
						href="${pageContext.request.contextPath}/community/${prevPost.communityId}">이전
						글</a>
				</c:if>
				<c:if test="${not empty nextPost}">
					<a class="btn btn-outline-secondary"
						href="${pageContext.request.contextPath}/community/${nextPost.communityId}">다음
						글</a>
				</c:if>
			</div>
		</div>

	</div>
	<%@ include file="/WEB-INF/views/component/footer.jsp"%>
<script>
  const MAX_BYTES = 255;

  // 문자열의 바이트 길이 구하기 (UTF-8 기준)
  function byteLength(str) {
    return new TextEncoder().encode(str).length;
  }

  function checkCommentLength() {
    const textarea = document.getElementById('commentContent');
    const bytes = byteLength(textarea.value);
    if (bytes > MAX_BYTES) {
      alert("댓글은 " + MAX_BYTES + "바이트 이내로 입력해야 합니다.");
      return false;
    }
    return true;
  }

  // 입력 시 바이트 수 표시
  document.getElementById('commentContent').addEventListener('input', function() {
    const bytes = byteLength(this.value);
    document.getElementById('charCount').textContent = bytes + " / " + MAX_BYTES + "Bytes";
  });
</script>

</body>
</html>