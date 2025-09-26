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
	<script>const CTX='${pageContext.request.contextPath}';</script>
	<script type="text/javascript">
	
	const $ = (sel) => document.querySelector(sel);

	const emailInput = document.querySelector('input[name="username"]');
	const codeInput  = document.querySelector('input[name="code"]');
	const sendBtn    = document.getElementById('certificate_mail');
	const verifyBtn  = document.getElementById('certificate');

	// 1) 인증 메일 보내기
	sendBtn.addEventListener('click', async () => {
	  const email = (emailInput.value || '').trim();
	  if (!email) { alert('이메일을 입력해 주세요.'); return; }

	  const res = await fetch('/bughunters/auth/email/send-code', {
	    method: 'POST',
	    headers: {'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},
	    body: new URLSearchParams({email})
	  });
	  const data = await res.json().catch(()=>({ok:false,msg:'요청 실패'}));
	  alert(data.msg || (data.ok ? '전송 성공' : '전송 실패'));
	});

	// 2) 인증 코드 검증
	verifyBtn.addEventListener('click', async () => {
	  const email = (emailInput.value || '').trim();
	  const code  = (codeInput.value || '').trim();
	  if (!email || !code) { alert('이메일과 코드를 입력해 주세요.'); return; }

	  const res = await fetch('/bughunters/auth/email/verify', {
	    method: 'POST',
	    headers: {'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},
	    body: new URLSearchParams({email, code})
	  });
	  const data = await res.json().catch(()=>({ok:false,msg:'요청 실패'}));
	  alert(data.msg || (data.ok ? '인증 성공' : '인증 실패'));
	  if (data.ok) {
	    // 인증 성공 시 비밀번호 변경 모달 버튼 활성화
	    document.querySelector('[data-bs-target="#changePasswordModal"]').disabled = false;
	  }
	});

	// 3) 모달 내부: 새 비밀번호 전송
	document.addEventListener('click', async (e) => {
	  if (e.target && e.target.id === 'btn-change-password') {
	    const email = (emailInput.value || '').trim();
	    const newPw = (document.querySelector('#newPassword')?.value || '').trim();
	    const newPw2= (document.querySelector('#confirmPassword')?.value || '').trim();
	    if (newPw !== newPw2) { alert('비밀번호가 일치하지 않습니다.'); return; }

	    const res = await fetch('/bughunters/auth/password/reset', {
	      method: 'POST',
	      headers: {'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},
	      body: new URLSearchParams({email, newPassword:newPw})
	    });
	    const data = await res.json().catch(()=>({ok:false,msg:'요청 실패'}));
	    alert(data.msg || (data.ok ? '변경 성공' : '변경 실패'));
	    if (data.ok) {
	    	const ctx = '${pageContext.request.contextPath}';
	    	  window.location.href = ctx + '/home';
	    }
	  }
	});
	</script>
</body>
</html>