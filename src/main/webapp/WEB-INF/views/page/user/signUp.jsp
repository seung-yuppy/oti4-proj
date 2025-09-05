<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
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
		<form action="signupProcess.jsp" method="post" onsubmit="return validatePasswords()">

			<div class="d-grid">
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
			</div>

			<div class="mb-3">
				<label class="form-label">비밀번호</label> <input type="password" id="newPassword"
					name="password" class="form-control" placeholder="비밀번호를 입력하세요"
					required>
			</div>
			<div class="mb-3">
				<label class="form-label">비밀번호 확인</label> <input type="password" id="confirmPassword"
					name="password" class="form-control" 
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
					class="form-control mb-2" placeholder="주소" readonly> <input
					type="text" id="sample2_detailAddress" name="detailAddress"
					class="form-control mb-2" placeholder="상세주소"> <input
					type="text" id="sample2_extraAddress" name="extraAddress"
					class="form-control" placeholder="참고항목" readonly>
			</div>

			<div class="mb-3">
				<label class="form-label d-block">반려동물 소유 여부</label>
				<div class="form-check form-check-inline">
					<input class="form-check-input" type="radio" name="hasPet" id="yes"
						value="yes" required> <label class="form-check-label"
						for="yes">예</label>
				</div>
				<div class="form-check form-check-inline">
					<input class="form-check-input" type="radio" name="hasPet" id="no"
						value="no"> <label class="form-check-label" for="no">아니오</label>
				</div>
			</div>

			<div class="d-grid">
				<button type="submit" class="btn btn-brown" id="signUp">회원가입</button>
			</div>
		</form>
	</div>
	<%@ include file="/WEB-INF/views/component/footer.jsp" %>

	<!-- 다음 주소 API 관련 요소 -->
	<div id="layer">
		<img src="/bughunters/resources/image/close.png"
			id="btnCloseLayer" onclick="closeDaumPostcode()" alt="닫기 버튼">
	</div>

	<!-- 다음 주소 API -->
	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
    var element_layer = document.getElementById('layer');

    function closeDaumPostcode() {
        element_layer.style.display = 'none';
    }

    function sample2_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = '';
                var extraAddr = '';

                if (data.userSelectedType === 'R') {
                    addr = data.roadAddress;
                } else {
                    addr = data.jibunAddress;
                }

                if(data.userSelectedType === 'R'){
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    document.getElementById("sample2_extraAddress").value = extraAddr;
                } else {
                    document.getElementById("sample2_extraAddress").value = '';
                }

                document.getElementById('sample2_postcode').value = data.zonecode;
                document.getElementById("sample2_address").value = addr;
                document.getElementById("sample2_detailAddress").focus();

                element_layer.style.display = 'none';
            },
            width : '100%',
            height : '100%',
            maxSuggestItems : 5
        }).embed(element_layer);

        element_layer.style.display = 'block';
        initLayerPosition();
    }

    function initLayerPosition(){
        var width = 350;
        var height = 400;
        var borderWidth = 5;

        element_layer.style.width = width + 'px';
        element_layer.style.height = height + 'px';
        element_layer.style.left = (((window.innerWidth || document.documentElement.clientWidth) - width)/2 - borderWidth) + 'px';
        element_layer.style.top = (((window.innerHeight || document.documentElement.clientHeight) - height)/2 - borderWidth) + 'px';
    }
    

		var popoverTriggerList = [].slice.call(document
				.querySelectorAll('[data-bs-toggle="popover"]'))
		var popoverList = popoverTriggerList.map(function(popoverTriggerEl) {
			return new bootstrap.Popover(popoverTriggerEl)
		})

		//비밀번호 불일치시 alert
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
	<script src="/miniproj/resource/js/bootstrap.bundle.min.js"></script>
</body>
</html>
