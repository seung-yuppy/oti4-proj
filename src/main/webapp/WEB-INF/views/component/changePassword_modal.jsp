<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css"
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
	<form id="changePwForm" method="post">
		<div class="modal fade" id="changePasswordModal" tabindex="-1">
			<div class="modal-dialog">
				<div class="modal-content">

					<div class="modal-header">
						<h4 class="modal-title">비밀번호 변경</h4>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>

					<div class="modal-body">
						<div class="mb-3">
							<label class="form-label">새로운 비밀번호</label> <input type="password"
								id="newPassword" name="newPassword" class="form-control"
								placeholder="비밀번호를 입력하세요" required>
						</div>
						<div class="mb-3">
							<label class="form-label">비밀번호 확인</label> <input type="password"
								id="confirmPassword" class="form-control"
								placeholder="비밀번호를 다시 한번 입력하세요" required>
						</div>
					</div>

					<div class="modal-footer">
						<button type="submit" class="btn btn-brown"
							id="btn-change-password">비밀번호 변경</button>
					</div>
				</div>
			</div>
		</div>
	</form>
	<script>
//컨텍스트 경로
const CTX='${pageContext.request.contextPath}';

// 폼 제출 가로채서 Fetch 호출
document.getElementById('changePwForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  if (!validatePasswords()) return;

  // 이메일 입력창은 forgotPassword 페이지 쪽에 name="username"으로 있다고 가정
  const emailInput = document.querySelector('#user-email');
  const email = (emailInput?.value || '').trim();
  const newPassword = document.getElementById('newPassword').value.trim();

  if (!email) { alert('사용자 이메일을 먼저 입력/인증해 주세요.'); return; } 

  try {
    const res = await fetch(CTX + '/auth/password/reset', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},
      body: new URLSearchParams({ email, newPassword })
    });
    const data = await res.json().catch(()=>({ok:false,msg:'요청 실패'}));
    if (data.ok) {
    		alert("비밀번호가 변경되었습니다. 로그인해 주세요.");
    		window.location.href = CTX + '/home';
    	} else {
    		alert("비밀번호 변경에 실패했습니다.");
    	}
  } catch (err) {
    console.error(err);
    alert('요청 중 오류가 발생했습니다.');
  }
});
</script>
</body>
</html>
