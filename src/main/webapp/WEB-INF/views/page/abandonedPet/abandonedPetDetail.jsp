<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>인간과 펫(유기동물 상세 정보)</title>
	<link href="/miniproj/resource/css/common.css" rel="stylesheet">
	<link href="/miniproj/resource/css/bootstrap.min.css" rel="stylesheet">
	<style>
		body {
			background-color: #f8f9fa;
		}
		
		.logo {
			font-weight: 700;
			color: #ff6600; /* 로고 색상은 임의로 지정 */
		}
		
		.main-container {
			max-width: 800px;
			margin-top: 2rem;
			margin-bottom: 2rem;
		}
		
		.card {
			border: 1px solid #e9ecef;
			border-radius: 0.5rem;
		}
		
		.card-body {
			padding: 2rem;
		}
		
		.profile-icon-group .icon-item {
			display: flex;
			flex-direction: column;
			align-items: center;
			font-size: 0.9rem;
			color: #495057;
		}
		
		.profile-icon-group .icon-item i {
			font-size: 1.5rem;
			margin-bottom: 0.5rem;
		}
		
		.section-title {
			font-weight: 700;
			font-size: 1.25rem;
			margin-bottom: 1rem;
		}
		
		.check-item {
			color: #28a745;
			font-weight: 500;
		}
		
		.fail-item {
			color: crimson;
			font-weight: 500;
		}
		
		.contact-info p {
			margin-bottom: 0.75rem;
			color: #495057;
		}
		.d-flex {
			display: flex !important;
			gap: 50px !important;
		}
	</style>
</head>
<body>
	<!-- 헤더 영역 -->
	<%@ include file="/WEB-INF/views/component/header.jsp"%>
	<main class="container main-container">
		<div class="card shadow-sm">
			<div class="card-body">
				<div class="row g-4">
					<div class="col-md-5">
						<img
							src="https://www.animal.go.kr/front/fileMng/imageView.do?f=/files/shelter/2025/08/202508121308544.jpg"
							class="img-fluid rounded" 
							alt="크림과 츄세이" 
						/>
					</div>

					<div class="col-md-7">
						<h2 class="fw-bold mb-3">믹스견</h2>
						<div
							class="d-flex justify-content-around text-center py-3 my-4 bg-light rounded profile-icon-group">
							<div class="icon-item">
								<div class="icon-container">
									<img src="/miniproj/image/ico_age.png" class="card-icon" /> 
									<span class="icon-caption">나이 : </span>
									<span>1세</span>
								</div>
							</div>
							<div class="icon-item">
								<div class="icon-container">
									<img src="/miniproj/image/ico_gender.png" class="card-icon" /> 
									<span class="icon-caption">성별 : </span>
									<span>수컷</span>
								</div>								
							</div>
							<div class="icon-item">
								<div class="icon-container">
									<img src="/miniproj/image/ico_size.png" class="card-icon" /> 
									<span class="icon-caption">몸무게 : </span>
									<span>4.9kg</span>
								</div>								

							</div>
						</div>

						<div class="mb-4">
							<h3 class="section-title">세부 정보</h3>
							<p class="text-secondary">이 강아지는 첫 만남에는 조금 낯을 가리지만, 마음을 열면 세상에서 가장 든든한 동반자가 됩니다. 당신의
								세심함과 이 아이의 순수함이 만나면 평생의 인연이 될 거예요.</p>
						</div>

						<div class="mb-4">
							<h3 class="section-title">건강 및 행동 특성</h3>
							<div class="d-flex">
								<div>
									<div class="check-item">
										<img src="/miniproj/image/ico_success.png" class="card-icon" /> 예방 접종 완료
									</div>
								</div>
								<div>
									<div class="fail-item">
										<img src="/miniproj/image/ico_fail.png" class="card-icon" /> 기본 건강 검진 완료
									</div>
								</div>
								<div>
									<div class="check-item">
										<img src="/miniproj/image/ico_success.png" class="card-icon" /> 중성화 수술 완료
									</div>
								</div>
							</div>
						</div>

						<div class="mb-4">
							<h3 class="section-title">위치 및 연락처</h3>
							<p class="fw-bold">발견 정보</p>
							<p>
								<img src="/miniproj/image/ico_location.png" class="card-icon" /> 서울시 강남구 논현동
							</p>
							<p>
								<img src="/miniproj/image/ico_calendar.png" class="card-icon" /> 2024년 5월 15일
							</p>

							<p class="fw-bold mt-4">입양 문의</p>
							<p>
								<img src="/miniproj/image/ico_homelocation.png" class="card-icon" /> 생명 존중 동물 보호소
							</p>
							<p>
								<img src="/miniproj/image/ico_tel.png" class="card-icon" /> 02-1234-5678
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>
	<!-- footer 영역 -->
	<%@ include file="/WEB-INF/views/component/header.jsp"%>

	<!-- script 영역 -->
	<script src="/miniproj/resource/js/bootstrap.bundle.min.js"></script>
</body>
</html>