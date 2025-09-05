<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운명의 발바닥 결과</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/miniproj/resource/css/common.css" rel="stylesheet">
<link href="/miniproj/resource/css/bootstrap.min.css" rel="stylesheet">
</head>
<style>
  h1.text-center.fw-bold {
    color: #a75d00; /* 연한 갈색 */
    margin: 30px 0; /* 위아래 30px 마진 */
    font-size: 3rem;
  }
</style>
<body>

	<%@ include file="../../component/header.jsp"%>
	<h1 class="text-center fw-bold">당신의 운명의 발바닥</h1>
	<div class="container my-5" id="result-section">
		<div class="row g-4">
			<%
				for (int i = 0; i < 4; i++) {
			%>
			<div class="col-6 col-md-3 d-flex justify-content-center">
				<div class="card">
					<jsp:include page="/WEB-INF/views/component/matchingPetCard.jsp"></jsp:include>
				</div>
			</div>
			<%
				}
			%>
		</div>
	</div>

	<%@ include file="../../component/footer.jsp"%>
</body>
</html>
