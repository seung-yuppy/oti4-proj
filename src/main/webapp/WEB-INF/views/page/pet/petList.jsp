<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>내 주변 펫 찾기</title>
	<link href="/bughunters/resources/css/common.css" rel="stylesheet">
	<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
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
	
	.swiper-button-next {
		background: url(/bughunters/resources/image/ico_next.png) no-repeat;
		background-size: 50% auto;
		background-position: center;
		
		&::after{
			display:none;
		}
	}
	
	.swiper-button-prev {
		background: url(/bughunters/resources/image/ico_prev.png) no-repeat;
		background-size: 50% auto;
		background-position: center;
		
		&::after {
			display:none;
		}
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
				<div class="d-flex">
					<div id="map" class="rounded map"></div>
					<div class="swiper swiper-container">
						<div class="swiper-wrapper">
							<%
							for (int i = 0; i < 3; i++) {
							%>
							<div class="swiper-slide">
								<jsp:include page="/WEB-INF/views/component/myPetCard.jsp"></jsp:include>
							</div>
							<%
							}
							%>
						</div>
						<div class="swiper-button-next"></div>
						<div class="swiper-button-prev"></div>
					</div>
				</div>
			</div>
		</section>
		<!-- 펫 리스트 영역 -->
		<section class="mt-10 pt-4">
			<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
				<%
				for (int i = 0; i < 5; i++) {
				%>
				<jsp:include page="/WEB-INF/views/component/petCard.jsp"></jsp:include>
				<%
				}
				%>
			</div>
		</section>
		<button type="button" class="card-like-btn p-absolute" id="chatToggleBtn">
			<img src="/bughunters/resources/image/ico_chatting.png" class="chat-btn">
		</button>

		<!-- 채팅 리스트 -->
		<div class="chat-list" id="chatList">
			<div class="chat-list-header">
			<span class="chat-list-spacer" aria-hidden="true"></span>
				<span class="chat-title">채팅 목록</span>
				<button class="chat-close-btn" id="chatCloseBtn">×</button>
			</div>

			<div class="chat-item">
				<img src="${pageContext.request.contextPath}/resources/image/petDummy1.jpg" class="chat-avatar" >
				<div class="chat-info">
					<div class="chat-name">
						보리 <span class="chat-time">10분 전</span>
					</div>
					<div class="chat-msg">보리 산책 예약 문의드립니다.</div>
				</div>
			</div>

			<div class="chat-item">
				<img src="${pageContext.request.contextPath}/resources/image/petDummy2.jpg" class="chat-avatar" >
				<div class="chat-info">
					<div class="chat-name">
						나비 <span class="chat-time">어제</span>
					</div>
					<div class="chat-msg">나비 간식 추천해주세요.</div>
				</div>
			</div>

			<div class="chat-item">
				<img src="${pageContext.request.contextPath}/resources/image/petDummy3.jpg" class="chat-avatar" >
				<div class="chat-info">
					<div class="chat-name">
						토토 <span class="chat-time">2일 전</span>
					</div>
					<div class="chat-msg">토토와 함께 놀아줄 친구 찾아요.</div>
				</div>
			</div>

			<div class="chat-item">
				<img src="${pageContext.request.contextPath}/resources/image/petDummy4.jpg" class="chat-avatar" >
				<div class="chat-info">
					<div class="chat-name">
						초코 <span class="chat-time">방금 전</span>
					</div>
					<div class="chat-msg">초코 산책 예약 문의드립니다.</div>
				</div>
			</div>

			<div class="chat-item">
				<img src="${pageContext.request.contextPath}/resources/image/petDummy5.jpg" class="chat-avatar" >
				<div class="chat-info">
					<div class="chat-name">
						구름이 <span class="chat-time">하루 전</span>
					</div>
					<div class="chat-msg">구름이 산책 예약 문의드립니다.</div>
				</div>
			</div>
		</div>

		<!-- 채팅 상세창 -->
		<div class="chat-detail" id="chatDetail">
			<div class="chat-detail-header">
			<button class="chat-nav-btn" id="chatBackBtn">←</button>
				<span id="chatRoomTitle" class="chat-title">보리 (Bori)</span>
				<button class="chat-close-btn" id="chatDetailCloseBtn">×</button>
			</div>
			<div class="chat-messages">
				<div class="message left">
					<div class="text">안녕하세요! 보리예요. 무엇을 도와드릴까요?</div>
				</div>
				<div class="message right">
					<div class="text">안녕하세요! 보리와 함께 산책하고 싶어요.</div>
				</div>
				<div class="message left">
					<div class="text">정말 좋네요! 보리는 공원 산책을 가장 좋아해요.</div>
				</div>
				<div class="message right">
					<div class="text">그럼 이번 주말에 만날 수 있을까요?</div>
				</div>
				<div class="message left">
					<div class="text">네, 좋아요! 토요일 오후는 어떠신가요?</div>
				</div>
				<div class="message right">
					<div class="text">완벽해요! 장소와 시간을 정해주세요.</div>
				</div>
			</div>
			<div class="chat-input">
				<input type="text" placeholder="메시지를 입력하세요...">
				<button>➤</button>
			</div>
		</div>
	</div>
	<!-- 헤더 영역 -->
	<%@ include file="/WEB-INF/views/component/footer.jsp"%>
	<!-- script 영역 -->
	<script
		src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
	<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>
	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c54be34b2a7cdb69fed5bbd7c59a90bb"></script>
	<script>
		/* 스와이퍼 */
		const swiper = new Swiper('.swiper-container', {
		    // 옵션
		    loop: true, // 무한 루프
	
		    // 네비게이션 버튼
		    navigation: {
		        nextEl: '.swiper-button-next',
		        prevEl: '.swiper-button-prev',
		    },
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
	
		            // 현재 위치에 마커 생성
		            var marker = new kakao.maps.Marker({
		                map: map,
		                position: locPosition,
		            });
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
	
		/* 채팅 스크립트 */
		const chatBtn = document.getElementById("chatToggleBtn");
		const chatList = document.getElementById("chatList");
		const chatCloseBtn = document.getElementById("chatCloseBtn");
		const chatDetailEl = document.getElementById("chatDetail");
		const chatDetailCloseBtn = document.getElementById("chatDetailCloseBtn");
		const chatRoomTitle = document.getElementById("chatRoomTitle");
	
		const show = (el, v) => (el.style.display = v);
		const isShown = (el) => window.getComputedStyle(el).display !== "none";
	
		function openList() {
		    show(chatList, "block");
		    show(chatDetailEl, "none");
		}
		function openDetail() {
		    show(chatDetailEl, "flex");
		    show(chatList, "none");
		}
		function closeAll() {
		    show(chatList, "none");
		    show(chatDetailEl, "none");
		}
	
		// chat 버튼: 상세 열려있으면 리스트로, 아니면 토글
		chatBtn.addEventListener("click", () => {
		    if (isShown(chatDetailEl)) openList();
		    else isShown(chatList) ? closeAll() : openList();
		});
	
		// 리스트 X 버튼
		chatCloseBtn.addEventListener("click", closeAll);
	
		// 상세 X 버튼
		chatDetailCloseBtn.addEventListener("click", closeAll);
	
		const chatBackBtn = document.getElementById("chatBackBtn");
		chatBackBtn.addEventListener("click", openList); // 상세 닫고 리스트 열기
	
		// 리스트 항목 클릭 → 상세 열기 (보리만 연결 예시)
		document.querySelectorAll(".chat-item").forEach((item) => {
		    item.addEventListener("click", () => {
		        const nameText = item.querySelector(".chat-name")?.textContent || "";
		        if (nameText.includes("보리")) {
		            if (chatRoomTitle) chatRoomTitle.textContent = "보리 (Bori)";
		            openDetail(); // 리스트 닫고 상세 열기
		        }
		    });
		});
	
		document.querySelectorAll(".card-body").forEach((item) => {
		    item.addEventListener("click", () => {
		        const nameText = item.querySelector(".chat-name")?.textContent || "";
		        if (nameText.includes("초코")) {
		            if (chatRoomTitle) chatRoomTitle.textContent = "보리 (Bori)";
		            openDetail();
		        }
		    });
		});
	</script>
</body>
</html>