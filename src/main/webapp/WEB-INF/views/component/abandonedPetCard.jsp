<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>abandonedPetCard</title>
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="col-lg-3">
		<div class="card pet-card shadow-sm">
			<img src="${param.profileImage}" class="card-img-top card-image" alt="사진 없음">
			<div class="card-body">
				<div class="d-flex-space">
					<h5 class="card-title fw-bold text-medium">${param.kind}</h5>
					<button type="button" class="card-like-btn" data-pet-id="${param.petId}">
					</button>
				</div>
				<ul class="card-list">
					<li class="card-item">
						<img src="/bughunters/resources/image/ico_size.png" class="card-icon" />	
						<span>${param.weight}kg</span>
					</li>
					<li class="card-item">
						<img src="/bughunters/resources/image/ico_gender.png" class="card-icon" />
						<span>${param.gender}</span>
					</li>
					<li class="card-item">
						<img src="/bughunters/resources/image/ico_age.png" class="card-icon" />
						<span>${param.age}년생</span>
					</li>
					<li class="card-item">
						<img src="/bughunters/resources/image/ico_location.png" class="card-icon" /> 
						<span>${param.address}</span>
					</li>
				</ul>
				<a href="/bughunters/abandonedpet/${param.petId}" class="btn btn-gray d-block">자세히 보기</a>
			</div>
		</div>
	</div>
	<!-- script 영역 -->
	<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>