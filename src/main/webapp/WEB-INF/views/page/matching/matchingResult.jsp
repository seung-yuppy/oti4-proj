<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운명의 발바닥 결과</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Chiron+GoRound+TC:wght@200..900&display=swap" rel="stylesheet">
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
	width: 100%; 
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
   
   .round_font {
	 font-family: "Chiron GoRound TC", sans-serif;
	 font-optical-sizing: auto;
 	 font-weight: <weight>;
 	 font-style: normal;
	}
   
</style>
</head>
<body>
<!-- 로딩 오버레이 -->
	<div id="loading-overlay">
		<div class="spinner-border" role="status"></div>
		<p class="fs-5 mt-3 round_font">당신의 운명의 동물을 찾는 중입니다...</p>
	</div>

	<!-- 페이지 본문 -->
	<%@ include file="../../component/header.jsp"%>
	<h1 class="text-center fw-bold round_font">당신의 운명의 발바닥</h1>
	<p class="text-center fw-bold text-muted">퀴즈를 여러번 진행할수록 결과는 더욱 더 정교해집니다 !</p>
	<br>
	<div class="container my-5" id="result-section" style="display: none;">
		<c:choose>
			<c:when test="${finishedQuiz}">
				<div class="row g-4">
					<c:forEach var="p" items="${topPets}">
						<div class="col-6 col-md-3 d-flex justify-content-center">
							<div class="card card-animate">
								<jsp:include page="/WEB-INF/views/component/matchingPetCard.jsp">
									<jsp:param name="profileImage" value="${p.profileImage}" />
									<jsp:param name="kind" value="${p.kind}" />
									<jsp:param name="weight" value="${p.weight}" />
									<jsp:param name="gender" value="${p.gender}" />
									<jsp:param name="age" value="${p.age}" />
									<jsp:param name="address" value="${p.address}" />
									<jsp:param name="description" value="${p.description}" />
									<jsp:param name="petId" value="${p.abandonedPetId}" />
								</jsp:include>
							</div>
						</div>
					</c:forEach>
				</div>
			</c:when>

			<c:otherwise>
				<div class="alert alert-warning text-center my-5">
					운명의 동물을 찾기 전에 <strong>매칭 테스트</strong>를 완료해주세요!<br /> <a
						class="btn btn-primary mt-3" href="/matchingQuiz">테스트 시작하기</a>
				</div>
			</c:otherwise>
		</c:choose>
	</div>
	<a href="/bughunters/matchingQuiz"
		class="d-block h5 text-center fw-bold text-muted  gnb-item round_font"
		style="text-decoration: none;"> 퀴즈 다시 풀러가기 </a>


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
	
	async function renderHeartButton(button) {
	    const id = button.dataset.petId;
	    try {
	        const res = await fetch(`/bughunters/abandonedpet/islike/\${id}`, {
	            method: "GET"
	        });
	        const data = await res.json();

	        if (data.isLike) {
	            button.innerHTML = `<img src="/bughunters/resources/image/ico_fullheart.png" class="heart card-icon">`;
	        } else {
	            button.innerHTML = `<img src="/bughunters/resources/image/ico_mbti.png" class="card-icon">`;
	        }
	    } catch (error) {
	        console.error('Failed to fetch like status:', error);
	    }
	}

	document.addEventListener("DOMContentLoaded", () => {
		document.querySelectorAll(".card-like-btn").forEach(async(button) => { 
			await renderHeartButton(button);
			button.addEventListener("click", async (event) => {
				const petId = event.currentTarget.dataset.petId;
				const res = await fetch(`/bughunters/abandonedpet/like/\${petId}`, {
					method: "POST"
				});
	            if (res.ok) {
	                await renderHeartButton(button);
	            } else {
	                console.error('Failed to toggle like status.');
	            }
			});
		});
	});
</script>
</body>
</html>
