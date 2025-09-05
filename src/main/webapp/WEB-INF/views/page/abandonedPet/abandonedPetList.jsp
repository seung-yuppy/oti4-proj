<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>인간과 펫(유기동물 리스트)</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="/miniproj/resource/css/common.css" rel="stylesheet">
	<link href="/miniproj/resource/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<!-- 헤더 영역 -->
	<%@ include file="../../component/header.jsp"%>
	<div class="container my-5">
		<div class="row g-4">
			<!-- 필터 선택 영역 -->
			<aside class="col-lg-3 bg-filter">
				<div class="filter-card p-3 card-border">
					<h5 class="fw-bold mb-3 text-brown">필터</h5>
					<form method="GET">
						<div class="mb-3">
							<label for="location" class="form-label text-brown">보호소 위치</label> 
							<select class="form-control" name="location">
								<option value="all" selected>전체</option>
								<option value="seoul">서울특별시</option>
								<option value="gyeonggi">경기도</option>
								<option value="gangwon">강원도</option>
								<option value="gyeongnam">경상남도</option>
								<option value="gyeongbuk">경상북도</option>
							</select>
						</div>
						<div class="mb-3">
							<label for="gender" class="form-label text-brown" id="main-text">성별</label> 
							<select class="form-control" name="gender">
								<option value="all" selected>전체</option>
								<option value="male">남자</option>
								<option value="female">여자</option>
							</select>
						</div>
						<div class="mb-3">
							<label for="size" class="form-label text-brown">사이즈</label> 
							<select class="form-control" name="size">
								<option value="all" selected>전체</option>
								<option value="small">소</option>
								<option value="medium">중</option>
								<option value="large">대</option>
							</select>
						</div>
						<div class="mb-3">
							<label for="age" class="form-label text-brown">나이</label> 
							<select class="form-control" name="age">
								<option value="all" selected>전체</option>
								<option value="0-3">0~3세</option>
								<option value="4-7">4~7세</option>
								<option value="8+">8세 이상</option>
							</select>
						</div>
						<hr class="hr-line">
						<div class="btn-container">
							<button type="reset" class="btn btn-secondary-brown d-block">필터 초기화</button>
							<button type="submit" class="btn btn-brown d-block">검색하기</button>
						</div>
					</form>
				</div>
			</aside>
			<!-- 유기동물 리스트 영역 -->
			<div class="col-lg-9">
				<h3 class="mb-4 fw-bold">입양 가능 펫 목록</h3>
				<div class="row g-3">
				<% 
					for (int i = 0; i < 6; i++) {
				%>
						<jsp:include page="/WEB-INF/views/component/abandonedPetCard.jsp"></jsp:include>
				<%
					}
				%>
				</div>
			</div>
		</div>
	</div>
	<!-- footer 영역 -->
	<%@ include file="../../component/footer.jsp"%>
	<!-- script 영역 -->
	<script src="/miniproj/resource/js/bootstrap.bundle.min.js"></script>
</body>
</html>