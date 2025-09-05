<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>myPetCard</title>
	<link href="/miniproj/resource/css/common.css" rel="stylesheet">
	<link href="/miniproj/resource/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
		<div class="card">
			<img 
				src="https://www.animal.go.kr/front/fileMng/imageView.do?f=/files/shelter/2025/08/202508181108334.jpg"
				class="card-img-top card-image"
				alt="크림과 츄세이" 
			>
			<div class="card-body">
				<h5 class="card-title fw-bold margin-t">초코</h5>
				<p class="card-text text-muted text-small">
					장난기 많고 사람을 좋아하는 골든 리트리버 보리입니다. 산책과 공놀이를 정말 좋아해요.
				</p>
				<ul class="mypet-card-list">
					<li class="card-item">
						<img src="/miniproj/image/ico_individual.png" class="card-icon" />
						<span>믹스견</span>
					</li>	
					<li class="card-item">
						<img src="/miniproj/image/ico_gender.png" class="card-icon" />
						<span>암컷</span>
					</li>	
					<li class="card-item">
						<img src="/miniproj/image/ico_age.png" class="card-icon" />
						<span>2세</span>
					</li>	
					<li class="card-item">
						<img src="/miniproj/image/ico_size.png" class="card-icon" />
						<span>1kg</span>
					</li>	
					<li class="card-item">
						<img src="/miniproj/image/ico_color.png" class="card-icon" />
						<span>크림색</span>
					</li>	
					<li class="card-item">
						<img src="/miniproj/image/ico_temperature.png" class="card-icon" />
						<span>38°C</span>
					</li>	

				</ul>
				<a href="#" class="btn btn-gray d-block">산책 게시판 등록하기</a>
			</div>
		</div>
	<!-- script 영역 -->
	<script src="/miniproj/resource/js/bootstrap.bundle.min.js"></script>
</body>
</html>