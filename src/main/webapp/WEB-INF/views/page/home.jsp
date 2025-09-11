<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운명의 발바닥</title>
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>
	<!-- 헤더 영역 -->
	<%@ include file="/WEB-INF/views/component/header.jsp"%>
	<!-- 매칭 유기동물 영역 -->
	<div class="container my-5">
		<div class="hero-section">
			<h2 class="fw-bold">당신의 완벽한 펫 동반자를 찾아보세요</h2>
			<p class="text-muted">숨은 입양 가능 강아지와 고양이를 검색해 보세요. 모두가 행복한 연결을 위해
				함께 합니다.</p>
			<div class="mt-4 btn-container">
				<a href="/bughunters/matchingQuiz" class="btn btn-secondary-brown">
					운명의 동물 퀴즈 
				</a> 
				<a href="/bughunters/matchingQuiz/result_after" class="btn btn-brown"> 
					운명의 동물 보기 
				</a>
			</div>
		</div>
	</div>
	<!-- 유기동물 리스트 영역 -->
	<div class="container my-5">
		<h4 class="section-title">귀여운 유기동물들</h4>
		<div class="row g-4">
			<%
				for (int i = 0; i < 4; i++) {
			%>
			<jsp:include page="/WEB-INF/views/component/abandonedPetCard.jsp"></jsp:include>
			<%
				}
			%>
		</div>
	</div>
	<!-- 커뮤니티 영역 -->
	<div class="container my-5">
		<h4 class="section-title">커뮤니티 둘러보기</h4>
		<div class="row g-4">
			<div class="col-md-4">
				<div class="card shadow-sm card-border">
					<img src="/bughunters/resources/image/img_community1.png"
						class="card-img-top community-image" alt="반려동물 봉사활동" />
					<div class="card-body community-card">
						<h5 class="card-title">반려동물 키우는 팁</h5>
						<p class="card-text text-muted">반려동물 키우는 팁을 공유해요~</p>
						<a href="#" class="btn btn-brown d-block"> 커뮤니티 참여하기 </a>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="card shadow-sm card-border">
					<img src="/bughunters/resources/image/img_community2.png"
						class="card-img-top community-image" alt="반려동물 건강 상담" />
					<div class="card-body community-card">
						<h5 class="card-title">내 반려동물 자랑</h5>
						<p class="card-text text-muted">예쁘고 귀여운 내 반려동물을 공유해요~</p>
						<a href="#" class="btn btn-brown d-block"> 커뮤니티 참여하기 </a>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="card shadow-sm card-border">
					<img src="/bughunters/resources/image/img_community3.png"
						class="card-img-top community-image" alt="산책 메이트" />
					<div class="card-body community-card">
						<h5 class="card-title">실종 반려동물 찾아주세요</h5>
						<p class="card-text text-muted">내 반려동물 좀 찾아주세요...</p>
						<a href="#" class="btn btn-brown d-block"> 커뮤니티 참여하기 </a>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- footer 영역 -->
	<%@ include file="/WEB-INF/views/component/footer.jsp"%>

	<!-- script 영역 -->
	<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>

	<c:if test="${signedUp or openLogin}">
		<script>
			(function() {
				if (window.__loginModalOnce)
					return;
				window.__loginModalOnce = true;

				var msg = '<c:out value="${msg}" />';
				if (msg && msg.trim().length)
					alert(msg.trim());

				function openModal() {
					var el = document.getElementById('loginModal');
					if (el && window.bootstrap)
						new bootstrap.Modal(el).show();
				}
				if (document.readyState === 'loading') {
					document.addEventListener('DOMContentLoaded', openModal);
				} else {
					openModal();
				}
			})();
		</script>
	</c:if>
</body>
</html>
