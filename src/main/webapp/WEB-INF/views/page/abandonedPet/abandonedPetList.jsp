<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>인간과 펫(유기동물 리스트)</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="/bughunters/resources/css/common.css" rel="stylesheet">
	<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<!-- 헤더 영역 -->
	<%@ include file="/WEB-INF/views/component/header.jsp"%>
	<div class="container my-5">
		<div class="row g-4">
			<!-- 필터 선택 영역 -->
			<aside class="col-lg-3">
				<div class="filter-card p-3 card-border bg-filter">
					<h5 class="fw-bold mb-3 text-brown">필터</h5>
					<form method="GET" action="/bughunters/abandonedPet/search">
						<div class="mb-3">
							<label for="location" class="form-label text-brown">보호소 위치</label> 
							<select class="form-control" name="location">
								<option value="all" selected>전체</option>
								<option value="seoul">서울</option>
								<option value="gyeonggi">경기</option>
								<option value="incheon">인천</option>
								<option value="ulsan">울산</option>
								<option value="busan">부산</option>
								<option value="sejong">세종</option>
								<option value="daejeon">대전</option>
								<option value="daegu">대구</option>
								<option value="gwangju">광주</option>
								<option value="jeju">제주</option>
								<option value="gangwon">강원</option>
								<option value="gyeongnam">경상남도</option>
								<option value="gyeongbuk">경상북도</option>
								<option value="chungnam">충청남도</option>
								<option value="chungbuk">충청북도</option>
								<option value="jeonnam">전라남도</option>
								<option value="jeonbuk">전라북도</option>
							</select>
						</div>
						<div class="mb-3">
							<label for="gender" class="form-label text-brown" id="main-text">성별</label> 
							<select class="form-control" name="gender">
								<option value="all" selected>전체</option>
								<option value="M">수컷</option>
								<option value="F">암컷</option>
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
								<option value="0-1">0~1세</option>
								<option value="2-4">2~4세</option>
								<option value="5-7">5~7세</option>
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
			        <c:forEach var="pet" items="${list}">
			            <jsp:include page="/WEB-INF/views/component/abandonedPetCard.jsp">
			                <jsp:param name="petId" value="${pet.abandonedPetId}" />
			                <jsp:param name="kind" value="${pet.kind}" />
			                <jsp:param name="profileImage" value="${pet.profileImage}" />
			                <jsp:param name="weight" value="${pet.weight}" />
			                <jsp:param name="gender" value="${pet.gender}" />
			                <jsp:param name="age" value="${pet.age}" />
			                <jsp:param name="address" value="${pet.address}" />
			            </jsp:include>
			        </c:forEach>
				</div>
			</div>
			<!-- 페이징 버튼 -->
			<nav aria-label="Page navigation">
			    <ul class="pagination justify-content-center pagination-brown">
			        <li class="page-item <c:if test='${currentPage == 1}'>disabled</c:if>">
			            <a class="page-link text-brown" href="?page=${currentPage - 1}">이전</a>
			        </li>
			
					<c:set var="pageGroupSize" value="5" />
					<c:set var="halfPageGroupSize" value="${(pageGroupSize - 1) / 2}" />
					
					<c:set var="startPage" value="${currentPage - halfPageGroupSize}" />
					
					<c:if test="${startPage < 1}">
					    <c:set var="startPage" value="1" />
					</c:if>
					
					<c:set var="endPage" value="${startPage + pageGroupSize - 1}" />
					
					<c:if test="${endPage > totalPages}">
					    <c:set var="endPage" value="${totalPages}" />
					    <c:set var="startPage" value="${totalPages - pageGroupSize + 1}" />
					    <c:if test="${startPage < 1}">
					        <c:set var="startPage" value="1" />
					    </c:if>
					</c:if>
			        <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
			            <li class="page-item <c:if test='${pageNum == currentPage}'>active</c:if> text-brown">
			                <a class="page-link" href="?page=${pageNum}">${pageNum}</a>
			            </li>
			        </c:forEach>

			        <li class="page-item <c:if test='${currentPage == totalPages}'>disabled</c:if>">
			            <a class="page-link text-brown" href="?page=${currentPage + 1}">다음</a>
			        </li>
			    </ul>
			</nav>
		</div>
	</div>
	<!-- footer 영역 -->
	<%@ include file="/WEB-INF/views/component/footer.jsp" %>
	<!-- script 영역 -->
	<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>