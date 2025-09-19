<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background-color: #f8f4f0;
}

.form-container {
	width: 700px;
	margin: 20px auto;
	background-color: #fff9f5;
	padding: 30px;
	border-radius: 12px;
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}

.form-label, .form-check-label {
	color: #a75d00;
}

h2 {
	color: #a75d00;
	text-align: center;
	margin-bottom: 30px;
}

.form-control:focus {
	border-color: #8B5E3C;
	box-shadow: 0 0 0 0.2rem rgba(139, 94, 60, 0.25);
}

#signUp {
	background-color: #a75d00;
	color: white;
}

#signUp:hover {
	background-color: #cc7000;
	color: white;
}

#layer {
	display: none;
	position: fixed;
	overflow: hidden;
	z-index: 1000;
	-webkit-overflow-scrolling: touch;
	background: white;
	border: 2px solid #8B5E3C;
	border-radius: 8px;
}

#btnCloseLayer {
	cursor: pointer;
	position: absolute;
	right: -3px;
	top: -3px;
	z-index: 1;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/component/header.jsp"%>
	<div class="form-container">
		<h2>회원가입</h2>

		<!-- ★ 서버 에러 표시 (회원가입 실패 시) -->
		<c:if test="${not empty error}">
			<div class="alert alert-danger mb-3">${error}</div>
		</c:if>

		<form action="${pageContext.request.contextPath}/auth/signup"
			method="post" onsubmit="return validatePasswords()">

			<div class="d-grid" id="emailVerifyBox">
				<label class="form-label">사용자 이메일</label>
				<!-- 이메일 -->
				<input type="email" id="email" name="username"
					class="form-control mb-2" placeholder="사용자 이메일을 입력하세요" required>
					
				<button type="button" class="btn btn-brown mb-2"
					id="certificate_mail" data-bs-toggle="popover" title="인증메일 전송완료"
					data-bs-content="메일함을 확인해주세요! 도착하지 않았다면 주소를 다시 한번 확인해 주세요.">인증메일
					보내기</button>
					
				<!-- 인증코드 -->
				<input type="text" id="code" name="code" class="form-control mb-2"
					placeholder="이메일로 도착한 코드를 입력하세요" required>
					
				<button type="button" class="btn btn-brown mb-3" id="certificate">인증</button>
				
				<!-- 이메일 인증 완료 여부 (서버 제출용) -->
				<input type="hidden" id="emailVerified" name="emailVerified"
					value="N">
			</div>

			<!-- ✅ 인증 성공 시 보여줄 영역 (초기엔 숨김) -->
			<div id="emailDone" class="alert alert-success d-none mt-2">
				이메일 인증이 완료되었습니다. 다음 단계로 진행해 주세요. ✅</div>

			<div class="mb-3">
				<label class="form-label">비밀번호</label> <input type="password"
					id="newPassword" name="password" class="form-control"
					placeholder="비밀번호를 입력하세요" required>
			</div>
			<div class="mb-3">
				<label class="form-label">비밀번호 확인</label> <input type="password"
					id="confirmPassword" name="confirmPassword" class="form-control"
					placeholder="비밀번호를 다시 한번 입력하세요" required>
			</div>

			<div class="mb-3">
				<label class="form-label">닉네임</label> <input type="text"
					name="nickname" class="form-control" placeholder="사용할 닉네임을 입력하세요"
					required>
			</div>

			<div class="mb-3">
				<label class="form-label">주소</label>
				<div class="input-group mb-2">
					<input type="text" id="sample2_postcode" name="postcode"
						class="form-control" placeholder="우편번호" readonly>
					<button type="button" class="btn btn-outline-secondary"
						onclick="sample2_execDaumPostcode()">우편번호 찾기</button>
				</div>
				<input type="text" id="sample2_address" name="address"
					class="form-control mb-2" placeholder="주소" readonly> 
					
				<input type="text" id="sample2_detailAddress" name="detailAddress"
					class="form-control mb-2" placeholder="상세주소"> 
					
				<input type="text" id="sample2_extraAddress" name="extraAddress"
					class="form-control" placeholder="참고항목" readonly>
			</div>

			<div class="d-grid">
				<button type="submit" class="btn btn-brown" id="signUp">회원가입</button>
			</div>
		</form>
	</div>
	<%@ include file="/WEB-INF/views/component/footer.jsp"%>

	<!-- 다음 주소 API 관련 요소 -->
	<div id="layer">
		<img src="//t1.daumcdn.net/postcode/resource/images/close.png"
			id="btnCloseLayer" onclick="closeDaumPostcode()" alt="닫기 버튼">
	</div>


	<!-- 이메일 인증 -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
  const base = '${pageContext.request.contextPath}';

  const $email   = document.getElementById('email');
  const $code    = document.getElementById('code');
  const $sendBtn = document.getElementById('certificate_mail');
  const $verBtn  = document.getElementById('certificate');
  const $flag    = document.getElementById('emailVerified');

  // Popover 인스턴스 준비(수동 표시)
  const pop = bootstrap.Popover.getOrCreateInstance($sendBtn, { trigger: 'manual', placement: 'right' });

  function emailValid(v){ return /^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(v); }

  function setSending(on){
	  if (on) {
	    $sendBtn.disabled = true;
	    $sendBtn.dataset.label = $sendBtn.textContent; // 기존 라벨 저장
	    $sendBtn.textContent = '전송 중…';
	  } else {
	    $sendBtn.disabled = false;
	    $sendBtn.textContent = $sendBtn.dataset.label || '인증메일 보내기';
	  }
	}
  	$sendBtn.addEventListener('click', async () => {
	  const email = $email.value.trim();
	  if (!emailValid(email)) { alert('이메일 형식이 올바르지 않습니다.'); $email.focus(); return; }

	setSending(true); // ← 클릭 즉시 '전송 중…' 표시

	  try {
	    const res  = await fetch(base + '/auth/email/send-code', {
	      method: 'POST',
	      headers: {'Content-Type':'application/x-www-form-urlencoded'},
	      body: new URLSearchParams({ email })
	    });
	    const json = await res.json();

	    if (json.ok) {
	
	     // 성공: 팝오버만 잠깐 보여주고 버튼 라벨은 원상복구
	     pop.show();
	     setTimeout(() => { try { pop.hide(); } catch(e){} }, 2500);
	     $flag.value = 'N'; // 새 코드 보냈으니 미인증 상태로 유지
	    } else {
	      alert(json.msg || '인증코드 발송에 실패했습니다.');
	    }
	  } catch (e) {
	    alert('네트워크 오류: ' + e.message);
	  } finally {
	   setSending(false); // ← 응답이 오면 '인증메일 보내기'로 복귀 + 버튼 활성화
	  }
	});

  // ② 인증코드 검증
  $verBtn.addEventListener('click', async () => {
    const email = $email.value.trim();
    const code  = $code.value.trim();

    if (!emailValid(email)) { alert('먼저 이메일을 입력하세요.'); $email.focus(); return; }
    if (!code) { alert('인증코드를 입력하세요.'); $code.focus(); return; }

    try {
      const res  = await fetch(base + '/auth/email/verify', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: new URLSearchParams({ email, code })
      });
      const json = await res.json();

      if (json.ok) {
        $flag.value = 'Y';
        $email.readOnly = true;
        $code.readOnly  = true;
        $verBtn.disabled = true;
        $sendBtn.disabled = true;
     
        // ✅ 추가: 팝오버 닫기 + 인증 영역 숨기기 + 성공 메시지 보이기 + 비번 입력으로 포커스
        pop.hide();
        document.getElementById('emailVerifyBox').classList.add('d-none');
        document.getElementById('emailDone').classList.remove('d-none');
        document.getElementById('newPassword').focus();
        
      } else {
        alert(json.msg || '코드가 올바르지 않거나 만료되었습니다.');
      }
    } catch (e) {
      alert('네트워크 오류: ' + e.message);
    }
  });

  // ③ 최종 제출 전 체크(비번 + 이메일 인증)
  function validatePasswords() {
    const pw1 = document.getElementById("newPassword").value;
    const pw2 = document.getElementById("confirmPassword").value;
    if (pw1 !== pw2) { alert("비밀번호가 일치하지 않습니다."); return false; }
    if ($flag.value !== 'Y') { alert('이메일 인증을 완료해 주세요.'); return false; }
    return true;
  }
  // 기존 onsubmit에서 validatePasswords()를 이미 호출 중이라면 이 함수가 덮어써짐
</script>

	<!-- 다음 주소 API -->
	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		var element_layer = document.getElementById('layer');

		function closeDaumPostcode() {
			element_layer.style.display = 'none';
		}

		function sample2_execDaumPostcode() {
			new daum.Postcode(
					{
						oncomplete : function(data) {
							var addr = '';
							var extraAddr = '';

							if (data.userSelectedType === 'R') {
								addr = data.roadAddress;
							} else {
								addr = data.jibunAddress;
							}

							if (data.userSelectedType === 'R') {
								if (data.bname !== ''
										&& /[동|로|가]$/g.test(data.bname)) {
									extraAddr += data.bname;
								}
								if (data.buildingName !== ''
										&& data.apartment === 'Y') {
									extraAddr += (extraAddr !== '' ? ', '
											+ data.buildingName
											: data.buildingName);
								}
								if (extraAddr !== '') {
									extraAddr = ' (' + extraAddr + ')';
								}
								document.getElementById("sample2_extraAddress").value = extraAddr;
							} else {
								document.getElementById("sample2_extraAddress").value = '';
							}

							document.getElementById('sample2_postcode').value = data.zonecode;
							document.getElementById("sample2_address").value = addr;
							document.getElementById("sample2_detailAddress")
									.focus();

							element_layer.style.display = 'none';
						},
						width : '100%',
						height : '100%',
						maxSuggestItems : 5
					}).embed(element_layer);

			element_layer.style.display = 'block';
			initLayerPosition();
		}

		function initLayerPosition() {
			var width = 350;
			var height = 400;
			var borderWidth = 5;

			element_layer.style.width = width + 'px';
			element_layer.style.height = height + 'px';
			element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width) / 2 - borderWidth)
					+ 'px';
			element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height) / 2 - borderWidth)
					+ 'px';
		}
		
	</script>
</body>
</html>
