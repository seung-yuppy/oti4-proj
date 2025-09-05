<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운명의 발바닥 결과</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/miniproj/resource/css/common.css" rel="stylesheet">
<link href="/miniproj/resource/css/bootstrap.min.css" rel="stylesheet">
<style>

	

	@keyframes heartbeat {
    	0%, 100% {
    		transform: scale(1);
      }
	  50% {
 	 	 transform: scale(1.2);
	  }
	}

	#loading-overlay p {
		 font-size: 1.5rem;
 		 animation: heartbeat 1.5s ease-in-out infinite;
	}
	
	/* 로딩 화면 스타일 */
	#loading-overlay {
		position: fixed;
		top: 0; left: 0;
		width: 100%;
		height: 100%;
		background-color: #f8f4f0;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		z-index: 9999;
	}

	.spinner-border {
	   width: 7rem !important;
 	   height: 7rem !important;
 	   color: #c68c53;
  	   margin-bottom: 1rem !important;
  	   border-width: 1rem !important; 
	}
	.fade-out {
		animation: fadeOut 1s forwards;
	}

	@keyframes fadeOut {
		0% { opacity: 1; }
		100% { opacity: 0; display: none; }
	}

	/* 카드 애니메이션 */
	.card.card-animate {
	animation: spinIn 0.6s ease;
	width: 100%; /* Bootstrap col이 처리함 */
	max-width: 100%;
	height: auto !important;
	min-height: unset !important;
	}


	@keyframes spinIn {
		from {
			transform: rotateY(90deg);
			opacity: 0;
		}
		to {
			transform: rotateY(0deg);
			opacity: 1;
		}
	}

	/* 폭죽 (간단한 confetti 느낌) */
	.confetti {
		position: fixed;
		top: -10px;
		width: 10px;
		height: 10px;
		background-color: red;
		animation: confettiFall 2s linear forwards;
		z-index: 9998;
	}
	@keyframes confettiFall {
		100% {
			transform: translateY(100vh) rotate(360deg);
			opacity: 0;
		}
	}
    h1.text-center.fw-bold {
   	 color: #a75d00; 
  	 margin: 30px 0; 
 	 font-size: 3rem;
    }
</style>
</head>
<body>
<!-- 로딩 오버레이 -->
	<div id="loading-overlay">
		<div class="spinner-border" role="status"></div>
		<p class="fs-5 mt-3">당신의 운명의 동물을 찾는 중입니다...</p>
	</div>

	<!-- 페이지 본문 -->
	<%@ include file="../../component/header.jsp"%>
	<h1 class="text-center fw-bold">당신의 운명의 발바닥</h1>
	<div class="container my-5" id="result-section" style="display: none;">
		<div class="row g-4">
			<%
		for (int i = 0; i < 4; i++) {
	%>
			<div class="col-6 col-md-3 d-flex justify-content-center">
				<div class="card card-animate">
					<jsp:include page="/WEB-INF/views/component/matchingPetCard.jsp"></jsp:include>
				</div>
			</div>
			<%
		}
	%>
		</div>
	</div>

	<%@ include file="../../component/footer.jsp"%>
	<script src="/miniproj/resource/js/bootstrap.bundle.min.js"></script>
	<script>
	// 로딩 후 2.5초 뒤 본문 보여주기
	window.addEventListener("load", function () {
		setTimeout(() => {
			// 로딩 화면 사라지고 본문 보이기
			const overlay = document.getElementById("loading-overlay");
			overlay.classList.add("fade-out");
			document.getElementById("result-section").style.display = "block";

			// 폭죽 만들기
			for (let i = 0; i < 30; i++) {
				createConfetti();
			}
		}, 3000);
	});

	function createConfetti() {
		const confetti = document.createElement("div");
		confetti.className = "confetti";
		confetti.style.left = Math.random() * 100 + "vw";
		confetti.style.backgroundColor = getRandomColor();
		document.body.appendChild(confetti);

		// 3초 후 제거
		setTimeout(() => confetti.remove(), 5000);
	}

	function getRandomColor() {
		const colors = ["#f44336", "#e91e63", "#ff9800", "#4caf50", "#3f51b5", "#9c27b0"];
		return colors[Math.floor(Math.random() * colors.length)];
	}
</script>
</body>
</html>
