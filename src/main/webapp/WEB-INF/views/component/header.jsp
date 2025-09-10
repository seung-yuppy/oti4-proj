<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="login_modal.jsp" %>
<nav class="navbar navbar-expand-lg navbar-light bg-header">
	<div class="container">
		<img src="/bughunters/resources/image/pawIcon.png" class="gnb-logo" alt="logo" /> 
		<a class="nav-link gnb-title" href="/bughunters/home">운명의 발바닥</a>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
			<span class="navbar-toggler-icon"></span>
		</button>
		
		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav ms-auto header-list">
				<li class="nav-item">
					<a class="nav-link gnb-item" href="/bughunters/abandonedPet?page=1">
						인간과 펫
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link gnb-item" href="/bughunters/pet">
						펫과 펫
					</a>
				</li>
				<li class="nav-item">
					<a class="nav-link gnb-item" href="/bughunters/communityMain">
						커뮤니티
					</a>
				</li>
			</ul>
			<ul class="navbar-nav ms-auto header-list">
				<li class="nav-item">
					<a class="nav-link btn btn-brown" href="/bughunters/mypage">
						마이페이지
					</a>
				</li>
				<li class="nav-item">
					<button type="button" class="nav-link btn btn-secondary-brown" id="border-btn" data-bs-toggle="modal" data-bs-target="#loginModal">
						로그인
					</button>
				</li>
				<li class="nav-item">
					<a class="nav-link btn btn-brown" href="/bughunters/signUp">
						회원가입
					</a>
				</li>
			</ul>
		</div>
			
	</div>
</nav>