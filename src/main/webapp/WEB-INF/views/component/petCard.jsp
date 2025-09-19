<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>petCard</title>
	<link href="/bughunters/resources/css/common.css" rel="stylesheet">
	<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="col-lg-3">
		<div class="card pet-card" >
			<img 
				src="https://www.animal.go.kr/front/fileMng/imageView.do?f=/files/shelter/2025/08/202508121308544.jpg"
				class="card-img-top card-image"
				alt="크림과 츄세이" 
			>
			<div class="card-body">
				<h5 class="card-title fw-bold chat-name">초코</h5>
				<p class="card-text text-muted text-small">
					장난기 많고 사람을 좋아하는 골든 리트리버 보리입니다. 산책과 공놀이를 정말 좋아해요.
				</p>
				<ul class="card-list">
					<li class="card-item">
						<img src="/bughunters/resources/image/ico_individual.png" class="card-icon" />
						<span>믹스견</span>
					</li>	
					<li class="card-item">
						<img src="/bughunters/resources/image/ico_gender.png" class="card-icon" />
						<span>수컷</span>
					</li>
					<li class="card-item">
						<img src="/bughunters/resources/image/ico_age.png" class="card-icon" />
						<span>1세</span>
					</li>	
					<li class="card-item">
						<img src="/bughunters/resources/image/ico_location.png" class="card-icon" />
						<span>경상남도</span>
					</li>	

				</ul>
				<div>
					<button type="button" class="btn btn-gray w-100" >1대1 채팅</button>
				</div>
			</div>
		</div>
	</div>
	<!-- script 영역 -->
	<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>