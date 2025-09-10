<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
	<link href="/bughunters/resources/css/common.css" rel="stylesheet">
	<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
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

</head>
<body>
	<!-- The Modal -->
	<form action="signupProcessServlet.java" method="post">
		<div class="modal fade" id="passwordComfirmModal">
			<div class="modal-dialog">
				<div class="modal-content">

					<!-- Modal Header -->
					<div class="modal-header">
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
						<h4 class="modal-title">비밀번호 확인</h4>
					</div>

					<!-- Modal body -->
					<div class="modal-body">
						<div class="mb-3">
							<label class="form-label">비밀번호</label> <input type="password" id="password"
								name="password" class="form-control" placeholder="비밀번호를 입력하세요"
								required>
						</div>
					</div>

					<!-- Modal footer -->
					<div class="modal-footer">
						<button type="button" class="btn btn-brown" id="editProfile" >회원정보
							수정하기</button>
					</div>
				</div>
			</div>
		</div>
	</form>

	<script>
	(function () {
		  const btn = document.getElementById("editProfile");
		  const pwdInput = document.getElementById("password");

		  // 로그인한 사용자의 이메일(세션) — 없으면 검증 못 함
		  const email = '<c:out value="${sessionScope.LOGIN_USER}" default=""/>';
		  const VERIFY_URL = '<c:url value="/api/login-check"/>';
		  // 이동할 페이지 (컨트롤러 매핑이 있다면 그 URL로 바꿔도 됩니다)
		  const EDIT_URL = '<c:url value="/user/editProfile"/>'; 

		  if (!email) {
		    // 비로그인 상태면 버튼 비활성화
		    btn.disabled = true;
		    btn.title = "로그인 후 이용 가능합니다.";
		  }

		  async function verifyAndGo() {
		    const password = pwdInput.value;
		    if (!password) {
		      alert("비밀번호를 입력하세요.");
		      pwdInput.focus();
		      return;
		    }
		    btn.disabled = true;

		    try {
		      const res = await fetch(VERIFY_URL, {
		        method: 'POST',
		        headers: {
		          'Accept': 'application/json',
		          'Content-Type': 'application/x-www-form-urlencoded'
		        },
		        body: new URLSearchParams({ username: email, password })
		      });

		      if (!res.ok) throw new Error('HTTP ' + res.status);
		      const data = await res.json();

		      if (data && (data.ok === true || data.ok === 'true' || data.ok === 1)) {
		        // 검증 성공 → 수정 페이지로 이동
		        window.location.href = EDIT_URL;
		      } else {
		        alert("비밀번호가 일치하지 않습니다.");
		        pwdInput.focus();
		      }
		    } catch (e) {
		      console.error(e);
		      alert("검증 중 오류가 발생했습니다.");
		    } finally {
		      btn.disabled = false;
		    }
		  }

		  // 버튼 클릭
		  btn.addEventListener("click", verifyAndGo);

		  // Enter로도 동작
		  pwdInput.addEventListener("keydown", function (e) {
		    if (e.key === "Enter") {
		      e.preventDefault();
		      verifyAndGo();
		    }
		  });
		})();
</script>
</body>
</html>