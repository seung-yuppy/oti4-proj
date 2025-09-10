<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>abandonedPetCard</title>
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
<style>
.col-lg-3 {
	width: 100% !important;
}

.pet-card {
	transition: transform 0.3s ease, box-shadow 0.3s ease;
	position: relative;
	overflow: hidden;
}

.pet-card:hover {
	transform: translateY(-10px) scale(1.03);
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.2);
}

.card-image {
	transition: transform 0.4s ease;
}

.pet-card:hover {
	transform: scale(1.1);
}
</style>
</head>
<body>
	<div class="col-lg-3">
		<div class="card pet-card shadow-sm">
			<img
				src="https://www.animal.go.kr/front/fileMng/imageView.do?f=/files/shelter/2025/08/202508121308544.jpg"
				class="card-img-top card-image" alt="크림과 츄세이">
			<div class="card-body">
				<div class="d-flex-space">
					<h5 class="card-title fw-bold">믹스견</h5>
					<button type="button" class="card-like-btn">
						<img src="/miniproj/image/ico_fullheart.png" class="card-icon">
					</button>
				</div>
				<p class="card-text text-muted text-small" id="card-description">
					이 강아지는 첫 만남에는 조금 낯을 가리지만, 마음을 열면 세상에서 가장 든든한 동반자가 됩니다. 당신의 세심함과 이
					아이의 순수함이 만나면 평생의 인연이 될 거예요.</p>
				<ul class="card-list">
					<li class="card-item"><img src="/miniproj/image/ico_size.png"
						class="card-icon" /> <span>중형</span></li>
					<li class="card-item"><img
						src="/miniproj/image/ico_gender.png" class="card-icon" /> <span>수컷</span>
					</li>
					<li class="card-item"><img src="/miniproj/image/ico_age.png"
						class="card-icon" /> <span>1세</span></li>
					<li class="card-item"><img
						src="/miniproj/image/ico_location.png" class="card-icon" /> <span>경상남도</span>
					</li>

				</ul>
				<a href="/miniproj/page/abandonedPet/abandonedPetDetail.jsp"
					class="btn btn-gray d-block">자세히 보기</a>
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
	<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>