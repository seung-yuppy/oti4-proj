<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="login_modal.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<nav class="navbar navbar-expand-lg navbar-light bg-header">
	<div class="container">
		<img src="/bughunters/resources/image/pawIcon.png" class="gnb-logo"
			alt="logo" /> <a class="nav-link gnb-title" href="/bughunters/home">운명의
			발바닥</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
			data-bs-target="#navbarNav">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav ms-auto header-list">
				<li class="nav-item"><a class="nav-link gnb-item"
					href="<c:url value='/abandonedpet?page=1'/>"> 인간과 펫 </a></li>
				<li class="nav-item"><a class="nav-link gnb-item"
					href="<c:url value='/pet'/>"> 펫과 펫 </a></li>
				<li class="nav-item"><a class="nav-link gnb-item"
					href="<c:url value='/community'/>"> 커뮤니티 </a></li>
			</ul>
			<ul class="navbar-nav ms-auto header-list">
				<c:choose>
					<%-- 로그인 상태: 세션에 LOGIN_USER가 있으면 --%>
					<c:when test="${not empty sessionScope.LOGIN_USER}">
						<li class="nav-item">
							<form method="post" action="<c:url value='/auth/logout'/>"
								class="d-inline">
								<button type="submit" class="nav-link btn btn-secondary-brown"
									id="border-btn">로그아웃</button>
							</form>
						</li>
						<li class="nav-item"><a class="nav-link btn btn-brown"
							href="<c:url value='/mypage'/>">마이페이지</a></li>
					</c:when>

					<%-- 비로그인 상태 --%>
					<c:otherwise>
						<li class="nav-item">
							<button type="button" class="nav-link btn btn-secondary-brown"
								id="border-btn" data-bs-toggle="modal"
								data-bs-target="#loginModal">로그인</button>
						</li>

						<li class="nav-item"><a class="nav-link btn btn-brown"
							href="<c:url value='/auth/signup'/>">회원가입</a></li>
					</c:otherwise>
				</c:choose>
			</ul>
		</div>
		<!-- 로그인 세션 확인 코드 -->
		<div style="display: none">LOGIN_USER=${sessionScope.LOGIN_USER}</div>

	</div>
</nav>