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
<link href="/miniproj/resource/css/common.css" rel="stylesheet">
<link href="/miniproj/resource/css/bootstrap.min.css" rel="stylesheet">
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
</style>
</head>
<body>

	<%@ include file="../../component/header.jsp"%>
	<h1 class="text-center fw-bold">당신의 운명의 발바닥</h1>
	<div class="container my-5" id="result-section" >
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


	<%@ include file="../../component/footer.jsp"%>
</body>
</html>
