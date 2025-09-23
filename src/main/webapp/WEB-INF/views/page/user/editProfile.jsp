<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../component/deleteAccount_modal.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String emailValue = (String) request.getAttribute("email");
	if (emailValue == null) {
		emailValue = "";
	}

	String nicknameValue = (String) request.getAttribute("nickname");
	if (nicknameValue == null) {
		nicknameValue = "";
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	padding: 20px;
	color: #a75d00;
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

#layer {
	position: fixed;
	z-index: 2050;
	display: none;
	overflow: hidden;
	-webkit-overflow-scrolling: touch;
	background: white;
	border: 2px solid #8B5E3C;
	border-radius: 8px;
}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/views/component/header.jsp"%>
	<form action="<c:url value='/user/profile/update'/>" method="post">
		<div class="d-grid form-container">
			<h2 class="mb-4 fw-bold">회원정보 수정</h2>

			<div class="mb-3">
				<label class="form-label">비밀번호</label> <input type="password"
					name="password" class="form-control" placeholder="비밀번호를 입력하세요"
					required autocomplete="new-password">
			</div>

			<div class="mb-3">
				<label class="form-label">닉네임</label> <input type="text"
					name="nickname" class="form-control" value="<%=nicknameValue%>"
					placeholder="사용할 닉네임을 입력하세요" required>
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
					class="form-control mb-2" placeholder="주소" readonly
					value="${address != null ? address : ''}"> <input
					type="text" id="sample2_detailAddress" name="detailAddress"
					class="form-control mb-2" placeholder="상세주소"> <input
					type="text" id="sample2_extraAddress" name="extraAddress"
					class="form-control" placeholder="참고항목" readonly>
			</div>

			<div class="d-grid">
				<button type="submit" class="btn btn-brown" id="signUp">회원정보
					수정</button>
			</div>
		</div>
	</form>
	<div class="text-center mt-4">
		<a href="javascript:void(0);" id="deleteAccountLink"
			style="color: #a75d00; text-decoration: underline; cursor: pointer;">
			회원탈퇴하기 </a>
	</div>
	<!-- 다음 주소 API 관련 요소 -->
	<div id="layer">
		<img src="//t1.daumcdn.net/postcode/resource/images/close.png"
			id="btnCloseLayer" onclick="closeDaumPostcode()" alt="닫기 버튼">
	</div>

	<!-- Scripts -->
	<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>
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

		var popoverTriggerList = [].slice.call(document
				.querySelectorAll('[data-bs-toggle="popover"]'))
		var popoverList = popoverTriggerList.map(function(popoverTriggerEl) {
			return new bootstrap.Popover(popoverTriggerEl)
		});

		document.getElementById("deleteAccountLink").addEventListener(
				"click",
				function() {
					var deleteModal = new bootstrap.Modal(document
							.getElementById('deleteAccountModal'));
					deleteModal.show();
				});
	</script>
	<%@ include file="/WEB-INF/views/component/footer.jsp"%>
</body>
</html>
