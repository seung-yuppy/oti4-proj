<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	// 내 펫 ID (좌/우 말풍선 구분용)
	Integer __MY_PET_ID__ = (Integer) session.getAttribute("PET_ID");
	if (__MY_PET_ID__ == null) {
		__MY_PET_ID__ = -1;
	}
	String ctx = request.getContextPath(); // /bughunters
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내 주변 펫 찾기</title>
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<link href="/bughunters/resources/css/chatStyle.css" rel="stylesheet">
<style>
	body {
		background-color: #f8f9fa;
	}
	
	.search-card {
		max-width: 1320px;
		margin: 0 auto;
		height: 410px;
	}
	
	.rounded {
		width: 100%;
		height: 410px;
	}
	.petlist-alert {
		color: crimson;
		font-size: 28px;
		text-align: center;
	}

</style>
</head>
<body>
	<!-- 헤더 영역 -->
	<%@ include file="/WEB-INF/views/component/header.jsp"%>
	<!-- 지도 영역 -->
	<div class="container my-5 p-relative">
		<section class="search-card">
			<div class="card p-4 shadow-sm card-border">
				<h3 class="text-center mb-4 fw-bold">내 주변 펫 찾기 🗺️</h3>
					<c:if test="${empty msg}">
						<div class="d-flex">
							<div id="map" class="rounded map"></div>
							<div class="swiper swiper-container">
								<div class="swiper-wrapper">
									<div class="swiper-slide">
										<jsp:include page="/WEB-INF/views/component/myPetCard.jsp"></jsp:include>
									</div>
								</div>
							</div>
						</div>
					</c:if>
					<c:if test="${!empty msg}">
						<p class="petlist-alert">${msg}</p>
					</c:if>
			</div>
		</section>
		<!-- 펫 리스트 영역 -->
		<section class="mt-10 pt-4">
			<ul class="wrapper-like-pet" id="pet-list-wrapper">

			</ul>
		</section>

		<button type="button" class="card-like-btn p-absolute"
			id="chatToggleBtn">
			<img src="/bughunters/resources/image/ico_chatting.png"
				class="chat-btn">
		</button>

		<!-- 채팅 목록 패널 -->
		<div class="chat-list" id="chatList">
			<div class="chat-list-header">
				<span class="chat-list-spacer" aria-hidden="true"></span> <span
					class="chat-title">채팅 목록</span>
				<button class="chat-close-btn" id="chatCloseBtn">×</button>
			</div>
			<!-- 동적 렌더 영역 -->
			<div id="chatListBody"></div>
		</div>

		<!-- 채팅 상세 패널 -->
		<div class="chat-detail" id="chatDetail">
			<div class="chat-detail-header">
				<button class="chat-nav-btn" id="chatBackBtn">←</button>
				<span id="chatRoomTitle" class="chat-title">채팅</span>
				<button class="chat-close-btn" id="chatDetailCloseBtn">×</button>
			</div>
			<div class="chat-messages" id="chatMessages"></div>
			<div class="chat-input">
				<input id="chatInput" type="text" placeholder="메시지를 입력하세요...">
				<button id="chatSendBtn">➤</button>
			</div>
		</div>
	</div>
	<!-- 헤더 영역 -->
	<%@ include file="/WEB-INF/views/component/footer.jsp"%>
	<!-- script 영역 -->
	<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>
	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c54be34b2a7cdb69fed5bbd7c59a90bb"></script>
	<script>	
	window.CTX = '<%= request.getContextPath() %>'; // 보통 '/bughunters'
	  window.MY_PET_ID = <%= (session.getAttribute("PET_ID") == null ? -1 : (Integer) session.getAttribute("PET_ID")) %>;
	</script>

	<!-- 외부 스크립트 로드 (경로는 프로젝트에 맞게) -->
	<%-- <script src="<%= request.getContextPath() %>/resources/js/pet_chat.js"></script> --%>
	<script src="<%= ctx %>/resources/js/pet_chat.js?v=2025-09-18-01"></script>
	<script>
	
	// mypet 정보 가져오기
	const cardbox = document.querySelector("#mypet-card");
	
	 document.addEventListener("DOMContentLoaded", async (event) => {
		const res = await fetch(BASE + '/pet/mypet', {method: "GET", credentials: 'include', headers:{'Accept':'application/json'} });
		const data = await res.json();

		if (!cardbox) return; // 엘리먼트 없으면 패스
		
		if (!data || data.petId === 0 || data.mypet === null) {
			cardbox.innerHTML = '<h2>반려동물을 등록해주세요.</h2>';
		} else {
			cardbox.innerHTML = 
				'<img src="data:image/jpeg;base64,' + (data.mypet.base64ProfileImage || '') + '" class="card-img-top card-image" alt="반려동물 사진없음">' +
			      '<div class="card-body">' +
			        '<h5 class="card-title fw-bold margin-t">' + (data.mypet.name || '') + '</h5>' +
			        '<p class="card-text text-muted text-small">' + (data.mypet.intro || '') + '</p>' +
			        '<ul class="mypet-card-list">' +
			          '<li class="card-item"><img src="' + CTX + '/resources/image/ico_individual.png" class="card-icon"><span>' + (data.mypet.kind || '') + '</span></li>' +
			          '<li class="card-item"><img src="' + CTX + '/resources/image/ico_gender.png" class="card-icon"><span>' + (data.mypet.gender || '') + '</span></li>' +
			          '<li class="card-item"><img src="' + CTX + '/resources/image/ico_age.png" class="card-icon"><span>' + (data.mypet.age || '') + '년생</span></li>' +
			          '<li class="card-item"><img src="' + CTX + '/resources/image/ico_size.png" class="card-icon"><span>' + (data.mypet.weight || '') + 'kg</span></li>' +
			          '<li class="card-item"><img src="' + CTX + '/resources/image/ico_color.png" class="card-icon"><span>' + (data.mypet.color || '') + '</span></li>' +
			          '<li class="card-item"><img src="' + CTX + '/resources/image/ico_temperature.png" class="card-icon"><span>' + (data.mypet.meetingTemperature || '') + '°C</span></li>' +
			        '</ul>' +
			        '<button type="button" class="btn btn-gray d-block" id="walking-register-btn" data-pet-id="' + data.mypet.petId + '">산책 게시판 등록하기</button>' +
			      '</div>';
			
			// mypetCard가 로드된 후에 버튼에 이벤트 리스너 추가
			navigator.geolocation.getCurrentPosition(
	        function (position) {
	            var lat = position.coords.latitude; // 위도
	            var lon = position.coords.longitude; // 경도
				const walkingBtn = document.querySelector("#walking-register-btn");
				if (walkingBtn) {
					walkingBtn.addEventListener("click", async (event) => { 
					const petId = event.currentTarget.dataset.petId;
					const postData = { location: lat + ',' + lon, petId: petId };
							
					const res = await fetch(BASE + '/pet/walking/register', {
						method: "POST",
						headers: {
							'Content-Type': 'application/json',
						},
						body: JSON.stringify(postData), // JSON.stringify로 수정
					});
					const data = await res.json();
					if (data.msg === "산책 게시판에 등록하였습니다.") {
						alert(data.msg);
						window.location.reload();
					}
					else 
						alert(data.msg);
					});
					
				}	
	        },
	        function (error) {
	            // 위치 정보 얻기 실패 처리 (사용자가 거부 등)
	            console.error("Geolocation error: ", error);
	            // 실패 시 기본 위치에 마커 표시
	            var marker = new kakao.maps.Marker({
	                map: map,
	                position: defaultPosition,
	            });
	        }
	    	);
		}
	 });
	 
	/* 카카오 맵 */
	var mapContainer = document.getElementById('map'); // 지도를 표시할 div
	var defaultPosition = new kakao.maps.LatLng(37.566826, 126.9786567); // 기본 위치 (서울시청)

	var mapOption = {
	    center: defaultPosition, // 지도의 기본 중심좌표
	    level: 3,
	};

	// 지도를 생성합니다
	var map = new kakao.maps.Map(mapContainer, mapOption);

	// HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
	if (navigator.geolocation) {
	    // GeoLocation을 이용해서 접속 위치를 얻어옵니다
	    navigator.geolocation.getCurrentPosition(
	        function (position) {
	            var lat = position.coords.latitude; // 위도
	            var lon = position.coords.longitude; // 경도

	            var locPosition = new kakao.maps.LatLng(lat, lon); // 현재 위치 LatLng 객체 생성

	            // 지도 중심을 현재 위치로 이동
	            map.setCenter(locPosition);
	        },
 	        function (error) {
	            // 위치 정보 얻기 실패 처리 (사용자가 거부 등)
	            console.error("Geolocation error: ", error);
	            // 실패 시 기본 위치에 마커 표시
	            var marker = new kakao.maps.Marker({
	                map: map,
	                position: defaultPosition,
	            });
	        } 
	    );
	} else {
	    // HTML5의 GeoLocation 사용 불가 시 fallback 처리
	    console.log("geolocation을 사용할 수 없어요..");
	    // 기본 위치에 마커 표시
	    var marker = new kakao.maps.Marker({
	        map: map,
	        position: defaultPosition,
	    });
	}
	
	/* 산책 게시판 리스트 */
	const listBox = document.querySelector("#pet-list-wrapper");
	document.addEventListener("DOMContentLoaded", async() =>{
		const res = await fetch(BASE + '/pet/walking/list', {
			method: "GET",
			credentials:'include', 
			headers:{'Accept':'application/json'}
		});
		
		const data = await res.json();
		const pets = (data && data.data) || [];
		
			// 종현 추가: 채팅방 이미지 빠구기, 전역 캐시
			window.PET_IMG  = window.PET_IMG  || {};
			window.PET_NAME = window.PET_NAME || {};
			pets.forEach(p => {
			  if (!p?.petId) return;
			  if (p.base64ProfileImage) window.PET_IMG[p.petId] = 'data:image/jpeg;base64,' + p.base64ProfileImage;
			  if (p.name)               window.PET_NAME[p.petId] = p.name;
			});
			
		if (Array.isArray(pets) && pets.length > 0) {
			listBox.innerHTML = pets.map(function(pet) {
				 return ''
				  	+ '<li class="like-pet-item shadow-sm">'
			        +   '<img src="data:image/jpeg;base64,' + (pet.base64ProfileImage || '') + '" class="card-img-top card-image" alt="반려 동물 사진">'
			        +   '<div class="card-body">'
			        +     '<h5 class="card-title fw-bold chat-name">' + (pet.name || '') + '</h5>'
			        +     '<p class="card-text text-muted text-small">' + (pet.intro || '') + '</p>'
			        +     '<ul class="card-list">'
			        +       '<li class="card-item"><img src="' + CTX + '/resources/image/ico_individual.png" class="card-icon"><span>' + (pet.kind || '') + '</span></li>'
			        +       '<li class="card-item"><img src="' + CTX + '/resources/image/ico_gender.png" class="card-icon"><span>' + (pet.gender || '') + '</span></li>'
			        +       '<li class="card-item"><img src="' + CTX + '/resources/image/ico_age.png" class="card-icon"><span>' + (pet.age || '') + '년생</span></li>'
			        +       '<li class="card-item"><img src="' + CTX + '/resources/image/ico_temperature.png" class="card-icon"><span>' + (pet.meetingTemperature || '') + '</span></li>'
			        +     '</ul>'
			        +     '<div>'
			        +       '<button type="button" class="btn btn-gray w-100" data-chat-with="' + pet.petId + '">1대1 채팅</button>'
			        +     '</div>'
			        +   '</div>'
			        + '</li>';
			 }).join('');
			
			// 지도 마커
		    pets.forEach(function(pet){
		      const coords = (pet.location || '').split(',');
		      if (coords.length === 2) {
		        const lat = parseFloat(coords[0]);
		        const lon = parseFloat(coords[1]);
		        if (!isNaN(lat) && !isNaN(lon)) {
		          new kakao.maps.Marker({
		            map: map,
		            position: new kakao.maps.LatLng(lat, lon),
		            title: pet.name
		          });
		        }
		      }
		    });
		}
	});
	</script>
</body>
</html>