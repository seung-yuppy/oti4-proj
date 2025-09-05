<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>abandonedPetCard</title>
	<link href="/miniproj/resource/css/common.css" rel="stylesheet">
	<link href="/miniproj/resource/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="col-lg-3">
		<div class="card pet-card shadow-sm" >
			<img 
				src="https://www.animal.go.kr/front/fileMng/imageView.do?f=/files/shelter/2025/08/202508121308544.jpg"
				class="card-img-top card-image"
				alt="크림과 츄세이" 
			>
			<div class="card-body">
				<div class="d-flex-space">
					<h5 class="card-title fw-bold">믹스견</h5>
					<button type="button" class="card-like-btn"><img src="/miniproj/image/ico_mbti.png" class="card-icon" ></button>
				</div>
				<ul class="card-list">
					<li class="card-item">
						<img src="/miniproj/image/ico_size.png" class="card-icon" />
						<span>중형</span>
					</li>	
					<li class="card-item">
						<img src="/miniproj/image/ico_gender.png" class="card-icon" />
						<span>수컷</span>
					</li>	
					<li class="card-item">
						<img src="/miniproj/image/ico_age.png" class="card-icon" />
						<span>1세</span>
					</li>	
					<li class="card-item">
						<img src="/miniproj/image/ico_location.png" class="card-icon" />
						<span>경상남도</span>
					</li>	

				</ul>
				<a href="/miniproj/page/abandonedPet/abandonedPetDetail.jsp" class="btn btn-gray d-block">자세히 보기</a>
			</div>
		</div>
	</div>
	<!-- script 영역 -->
	<script>
		document.addEventListener("DOMContentLoaded", () => {
			const cardTexts = document.querySelectorAll("#card-description");
			cardTexts.forEach((cardText) => {
				if(cardText.innerText.length > 30) 
					cardText.textContent = cardText.innerText.substring(0, 30) + "....";
			});
		});
	</script>
	<script src="/miniproj/resource/js/bootstrap.bundle.min.js"></script>
</body>
</html>