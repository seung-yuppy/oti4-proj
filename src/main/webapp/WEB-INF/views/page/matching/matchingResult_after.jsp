<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운명의 발바닥 결과</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Chiron+GoRound+TC:wght@200..900&display=swap" rel="stylesheet">
<style>
h1.text-center.fw-bold {
	color: #a75d00;
	margin: 30px 0;
	font-size: 3rem;
}

.card {
	width: 100%;
	max-width: 100%;
	height: auto !important;
	min-height: unset !important;
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

	<%@ include file="../../component/header.jsp"%>
	<h1 class="text-center fw-bold round_font">당신의 운명의 발바닥</h1>
	<p class="text-center fw-bold text-muted round_font">퀴즈를 여러번 진행할수록 결과는 더욱 더 정교해집니다 !</p>
	<br>

	<div class="container my-5" id="result-section">
		<c:choose>
			<c:when test="${finishedQuiz}">
				<div class="row g-4">
					<c:forEach var="p" items="${topPets}">
						<div class="col-6 col-md-3 d-flex justify-content-center">
							<div class="card">
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

	<script>
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
