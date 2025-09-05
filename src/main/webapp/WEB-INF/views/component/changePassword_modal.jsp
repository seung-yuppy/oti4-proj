<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="/miniproj/resource/css/common.css" rel="stylesheet">
<link href="/miniproj/resource/css/bootstrap.min.css" rel="stylesheet">
<script src="/miniproj/resource/js/bootstrap.bundle.min.js"></script>
<style>
.modal-header {
	display: flex !important;
	flex-direction: column;
	color: #a75d00;
}

.modal-body {
	color: #a75d00;
}

.modal-footer {
	display: flex !important;
	flex-direction: column;
}

.modal-backdrop.show {
	background-color: rgba(0, 0, 0, 0.2) !important;
}
</style>
<!-- 비밀번호 불일치시 alert -->
<script>
function validatePasswords() {
	const pw1 = document.getElementById("newPassword").value;
	const pw2 = document.getElementById("confirmPassword").value;

	if (pw1 !== pw2) {
		alert("비밀번호가 일치하지 않습니다.");
		return false; // 제출 막기
	}
	return true; // 통과
}
</script>

</head>
<body>
	<!-- The Modal -->
	<form action="signupProcessServlet.java" method="post" onsubmit="return validatePasswords()">
		<div class="modal fade" id="changePasswordModal">
			<div class="modal-dialog">
				<div class="modal-content">

					<!-- Modal Header -->
					<div class="modal-header">
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
						<h4 class="modal-title">비밀번호 변경</h4>
					</div>

					<!-- Modal body -->
					<div class="modal-body">
						<div class="mb-3">
							<label class="form-label">새로운 비밀번호</label> <input type="password"
								id="newPassword" name="password" class="form-control"
								placeholder="비밀번호를 입력하세요" required>
						</div>
						<div class="mb-3">
							<label class="form-label">비밀번호 확인</label> <input type="password"
								id="confirmPassword" class="form-control"
								placeholder="비밀번호를 다시 한번 입력하세요" required>
						</div>
					</div>

					<!-- Modal footer -->
					<div class="modal-footer">
						<button type="submit" class="btn btn-brown" id="signUp">비밀번호
							변경</button>
					</div>
				</div>
			</div>
		</div>
	</form>

</body>
</html>
