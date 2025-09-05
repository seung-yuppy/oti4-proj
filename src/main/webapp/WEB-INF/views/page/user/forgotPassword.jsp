<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ include file="../../component/changePassword_modal.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 찾기</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
<style>
.form-container {
	width: 450px;
	margin: 50px auto;
	background-color: #fff9f5;
	padding: 30px;
	border-radius: 12px;
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/component/header.jsp"%>
	<div class="form-container">
		<h2 class="mb-4">비밀번호 찾기</h2>
		<div class="d-grid ">
			<label class="form-label">사용자 이메일</label> <input type="email"
				name="username" class="form-control mb-2"
				placeholder="사용자 이메일을 입력하세요" required>
			<button type="button" class="btn btn-brown mb-2"
				id="certificate_mail" data-bs-toggle="popover" title="인증메일 전송완료"
				data-bs-content="메일함을 확인해주세요! 도착하지 않았다면 주소를 다시 한번 확인해 주세요.">인증메일
				보내기</button>
			<input type="text" name="code" class="form-control mb-2"
				placeholder="이메일로 도착한 코드를 입력하세요" required>
			<button type="button" class="btn btn-brown mb-3" id="certificate">인증</button>
			
			<div class="mb-3 text-center">
				<button type="button" class="btn btn-brown" data-bs-toggle="modal"
					data-bs-target="#changePasswordModal">비밀번호 바꾸기</button>
			</div>

		</div>
	</div>
	<h3></h3>
	<%@ include file="/WEB-INF/views/component/footer.jsp" %>
	<script type="text/javascript">
		var popoverTriggerList = [].slice.call(document
				.querySelectorAll('[data-bs-toggle="popover"]'))
		var popoverList = popoverTriggerList.map(function(popoverTriggerEl) {
			return new bootstrap.Popover(popoverTriggerEl)
		})
	</script>
</body>
</html>