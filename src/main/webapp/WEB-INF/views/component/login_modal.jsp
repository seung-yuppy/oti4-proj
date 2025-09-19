<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">
<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>
<style>
.modal-header {
	display: flex !important;
	flex-direction: column;
	color: #a75d00;
}

.modal-body {
	color: #a75d00;
}
</style>

</head>
<body>
	<!-- The Modal -->
	<form action="${pageContext.request.contextPath}/auth/login"
		method="post">
		<div class="modal fade" id="loginModal">
			<div class="modal-dialog">
				<div class="modal-content">

					<!-- Modal Header -->
					<div class="modal-header">
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
						<h2 class="modal-title fw-bold">로그인</h2>
						<a class="btn w-100">운명의 발바닥에 오신 것을 환영합니다!</a>
					</div>

					<!-- Modal body -->
					<div class="modal-body">
						<div class="mb-3">
							<div class="input-group">
								<span class="input-group-text icon-input"> <img
									src="/bughunters/resources/image/ico_userID.png" alt="아이콘"
									class="input-icon" width="16" height="18"> <!-- Bootstrap Icons 사용 -->
								</span> <input type="email" name="username" class="form-control"
									placeholder="사용자 이메일" required>
							</div>
						</div>

						<div class="mb-3">
							<div class="input-group">
								<span class="input-group-text icon-input"> <img
									src="/bughunters/resources/image/ico_password.png" alt="아이콘"
									class="input-icon" width="16" height="18">
								</span> <input type="password" name="password" class="form-control"
									placeholder="비밀번호" required>
							</div>
						</div>
					</div>

					<!-- Modal footer -->
					<div class="modal-footer">
						<button type="submit" class="btn btn-brown" id="loginBtn">로그인</button>
						<a href="/bughunters/views/page/user/forgotPassword.jsp" class="btn w-100">비밀번호를
							잊어버렸나요?</a>
					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>
