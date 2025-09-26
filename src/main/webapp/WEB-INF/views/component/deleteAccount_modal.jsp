<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<meta charset="UTF-8">
<style>
.modal-header {
	display: flex !important;
	flex-direction: column;
	color: #a75d00;
}

.modal-body {
	color: #a75d00;
	text-align: center;
}

.modal-footer {
	display: flex !important;
	flex-direction: column;
}

.modal-backdrop.show {
	background-color: rgba(0, 0, 0, 0.2) !important;
}

input.form-control {
	height: 55px;
	font-size: 1rem;
}
</style>

<body>
	<!-- 탈퇴 확인 모달 -->
	<div class="modal fade" id="deleteAccountModal">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h2 class="modal-title">회원탈퇴</h2>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="닫기"></button>
				</div>
				<div class="modal-body ">
					<h5>
						정말 회원탈퇴하시겠습니까?<br> 이 작업은 되돌릴 수 없습니다.
					</h5>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-brown" data-bs-dismiss="modal">돌아가기</button>
					<form action="${pageContext.request.contextPath}/user/delete" method="post">
						<button type="submit" class="btn btn-secondary">진짜 회원탈퇴하기</button>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>