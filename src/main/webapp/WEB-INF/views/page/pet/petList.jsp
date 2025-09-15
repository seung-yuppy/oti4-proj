<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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

.swiper-button-next {
	background: url(/bughunters/resources/image/ico_next.png) no-repeat;
	background-size: 50% auto;
	background-position: center;
	&::
	after
	{
	display
	:
	none;
}

}
.swiper-button-prev {
	background: url(/bughunters/resources/image/ico_prev.png) no-repeat;
	background-size: 50% auto;
	background-position: center;
	&::
	after
	{
	display
	:
	none;
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
							<div class="swiper-slide">
								<jsp:include page="/WEB-INF/views/component/myPetCard.jsp"></jsp:include>
							</div>
						</div>
						<!-- 						<div class="swiper-button-next"></div>
						<div class="swiper-button-prev"></div> -->
					</div>
				</div>
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
	<script
		src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
	<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>
	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c54be34b2a7cdb69fed5bbd7c59a90bb"></script>
	<script>	
		/* 채팅 스크립트 */
		 const CTX = '<%=request.getContextPath()%>';
		 const BASE = `${location.origin}${CTX}`;
		 console.log('CTX=', CTX, 'BASE=', BASE);
					 
  const MY_PET_ID = <%=(session.getAttribute("PET_ID") == null ? -1 : (Integer) session.getAttribute("PET_ID"))%>;

  /* ===== 토글/패널 ===== */
  const chatBtn = document.getElementById('chatToggleBtn');
  const chatList = document.getElementById('chatList');
  const chatListBody = document.getElementById('chatListBody') || (function(){ const d=document.createElement('div'); d.id='chatListBody'; chatList.appendChild(d); return d; })();
  const chatCloseBtn = document.getElementById('chatCloseBtn');

  const chatDetail = document.getElementById('chatDetail');
  const chatBackBtn = document.getElementById('chatBackBtn');
  const chatDetailCloseBtn = document.getElementById('chatDetailCloseBtn');
  const chatRoomTitle = document.getElementById('chatRoomTitle');
  const chatMessages = document.getElementById('chatMessages') || document.querySelector('.chat-messages');
  const chatInput = document.getElementById('chatInput') || document.querySelector('.chat-input input');
  const chatSendBtn = document.getElementById('chatSendBtn') || document.querySelector('.chat-input button');

  const show = (el,v)=> el && (el.style.display = v);
  const isShown = (el)=> el && window.getComputedStyle(el).display !== 'none';
  function openList(){ show(chatList,'block'); show(chatDetail,'none'); }
  function openDetail(){ show(chatDetail,'flex'); show(chatList,'none'); }
  function closeAll(){ show(chatList,'none'); show(chatDetail,'none'); }

  // 버튼이 혹시 없으면 조용히 패스
  chatBtn && chatBtn.addEventListener('click', () => {
    if (isShown(chatDetail)) openList();
    else isShown(chatList) ? closeAll() : openList();
  });
  chatCloseBtn && chatCloseBtn.addEventListener('click', closeAll);
  chatDetailCloseBtn && chatDetailCloseBtn.addEventListener('click', closeAll);
  chatBackBtn && chatBackBtn.addEventListener('click', openList);

  /* ===== 방 목록/메시지/웹소켓 ===== */
  let currentRoomId = null;
  let ws = null;

  async function loadRooms(){
    try{
      const res = await fetch(`${CTX}/api/chat/rooms`);
      const rooms = await res.json();
      renderRoomList(rooms);
    }catch(e){ console.error('loadRooms failed', e); }
  }

  function renderRoomList(rooms){
    chatListBody.innerHTML = '';
    if (!rooms || rooms.length === 0){
      const empty = document.createElement('div');
      empty.className = 'p-3 text-muted';
      empty.textContent = '채팅방이 없습니다.';
      chatListBody.appendChild(empty);
      return;
    }
    rooms.forEach(r=>{
      const item = document.createElement('div');
      item.className = 'chat-item';
      item.dataset.roomId = r.chatRoomId;

      const img = document.createElement('img');
      img.className = 'chat-avatar';
      img.src = `${CTX}/resources/image/petDummy1.jpg`;

      const info = document.createElement('div');
      info.className = 'chat-info';
      const name = document.createElement('div');
      name.className = 'chat-name';
      name.textContent = `Room #${r.chatRoomId}`;
      const time = document.createElement('span');
      time.className = 'chat-time'; time.textContent = '';
      name.appendChild(document.createTextNode(' '));
      name.appendChild(time);

      const last = document.createElement('div');
      last.className = 'chat-msg'; last.textContent = '';

      info.appendChild(name); info.appendChild(last);
      item.appendChild(img); item.appendChild(info);
      chatListBody.appendChild(item);
    });
  }

  // 목록에서 방 클릭하여 열기
  chatListBody.addEventListener('click', async (e)=>{
    const item = e.target.closest('.chat-item');
    if(!item) return;
    const roomId = +item.dataset.roomId;
    await openRoom(roomId);
  });

  async function loadMessages(roomId, cursor){
    const url = new URL(`${location.origin}${CTX}/api/chat/rooms/${roomId}/messages`);
    if (cursor) url.searchParams.set('cursor', cursor);
    const res = await fetch(url.toString());
    const list = await res.json();
    chatMessages.innerHTML = '';
    list.slice().reverse().forEach(m => appendMessage(m));
    chatMessages.scrollTop = chatMessages.scrollHeight;
  }

  function appendMessage(m){
    const side = (m.petId === MY_PET_ID) ? 'right' : 'left';
    const wrap = document.createElement('div');
    wrap.className = `message ${side}`;
    const text = document.createElement('div');
    text.className = 'text';
    text.textContent = m.chatMessage || '';
    wrap.appendChild(text);
    chatMessages.appendChild(wrap);
  }

  function ensureWs(){
    if (ws && ws.readyState === WebSocket.OPEN) return;
    const scheme = (location.protocol === 'https:') ? 'wss' : 'ws';
    ws = new WebSocket(`${scheme}://${location.host}${CTX}/ws/chat`);
    ws.onmessage = (evt)=>{
      try{
        const data = JSON.parse(evt.data);
        if (data.type === 'MESSAGE' && data.roomId === currentRoomId){
          appendMessage({ chatMessage: data.body, petId: data.senderPetId });
          chatMessages.scrollTop = chatMessages.scrollHeight;
        }
      }catch(e){ console.error(e); }
    };
  }

  async function openRoom(roomId){
    currentRoomId = roomId;
    chatRoomTitle && (chatRoomTitle.textContent = `Room #${roomId}`);
    openDetail();
    await loadMessages(roomId);
    ensureWs();
    ws && ws.send(JSON.stringify({ type:'JOIN', roomId }));
  }

  function send(){
    const text = (chatInput.value || '').trim();
    if(!text || !ws || ws.readyState !== WebSocket.OPEN || currentRoomId == null) return;
    ws.send(JSON.stringify({ type:'SEND', roomId: currentRoomId, body: text }));
    chatInput.value = '';
  }
  chatSendBtn && chatSendBtn.addEventListener('click', send);
  chatInput && chatInput.addEventListener('keydown', (e)=>{ if(e.key === 'Enter' && !e.shiftKey){ e.preventDefault(); send(); }});

  // 1:1 채팅 버튼(카드/상세 등)에 대한 이벤트 위임
  document.addEventListener('click', async (e)=>{
    const btn = e.target.closest('[data-chat-room-id], [data-chat-with]');
    if(!btn) return;

    // 1) 이미 roomId가 있으면 바로 열기
    if (btn.dataset.chatRoomId){
      const roomId = parseInt(btn.dataset.chatRoomId, 10);
      if (!isNaN(roomId)) {
        openDetail();
        await openRoom(roomId);
      }
      return;
    }

    // 2) 상대 petId로 방 생성/조회 후 열기
    if (btn.dataset.chatWith){
      const toPetId = parseInt(btn.dataset.chatWith, 10);
      if (isNaN(toPetId)) return;
      try{
        const res = await fetch(`${CTX}/api/chat/rooms/direct?toPetId=${toPetId}`, { method:'POST' });
        if (!res.ok) throw new Error('direct create failed');
        const data = await res.json(); // {roomId: number}
        openList(); // 목록 배경 열려 있으면 자연스럽게 전환
        await openRoom(data.roomId);
      }catch(err){ console.error(err); alert('채팅방 생성에 실패했습니다.'); }
    }
  });

  // 초기: 목록 로드(버튼을 누르면 보이지만, 데이터는 미리 준비)
  document.addEventListener('DOMContentLoaded', loadRooms);
	</script>
	
	<script>
	/* 스와이퍼 */
/* 	const swiper = new Swiper('.swiper-container', {
	    // 옵션
	    loop: true, // 무한 루프

	    // 네비게이션 버튼
	    navigation: {
	        nextEl: '.swiper-button-next',
	        prevEl: '.swiper-button-prev',
	    },
	}); */
	
	// mypet 정보 가져오기
	const cardbox = document.querySelector("#mypet-card");
	
	 document.addEventListener("DOMContentLoaded", async (event) => {
		const res = await fetch(`/bughunters/pet/mypet`, {
			method: "GET",
		});
		const data = await res.json();
		if (data.petId === 0) {
			cardbox.innerHTML = `
				<h2>반려동물을 등록해주세요.</h2>
			`;
		} else {
			cardbox.innerHTML = `
				<img 
					src="data:image/jpeg;base64,\${data.base64ProfileImage}"
					class="card-img-top card-image"
					alt="반려동물 사진없음" 
				>
				<div class="card-body">
					<h5 class="card-title fw-bold margin-t">\${data.name}</h5>
					<p class="card-text text-muted text-small">
						\${data.intro}
					</p>
					<ul class="mypet-card-list">
						<li class="card-item">
							<img src="/bughunters/resources/image/ico_individual.png" class="card-icon" />
							<span>\${data.kind}</span>
						</li>	
						<li class="card-item">
							<img src="/bughunters/resources/image/ico_gender.png" class="card-icon" />
							<span>\${data.gender}</span>
						</li>	
						<li class="card-item">
							<img src="/bughunters/resources/image/ico_age.png" class="card-icon" />
							<span>\${data.age}년생</span>
						</li>	
						<li class="card-item">
							<img src="/bughunters/resources/image/ico_size.png" class="card-icon" />
							<span>\${data.weight}kg</span>
						</li>	
						<li class="card-item">
							<img src="/bughunters/resources/image/ico_color.png" class="card-icon" />
							<span>\${data.color}</span>
						</li>	
						<li class="card-item">
							<img src="/bughunters/resources/image/ico_temperature.png" class="card-icon" />
							<span>\${data.meetingTemperature}°C</span>
						</li>
					</ul>
					<button type="button" class="btn btn-gray d-block" id="walking-register-btn" data-pet-id="\${data.petId}">산책 게시판 등록하기</button>
				</div>		
			`;
			
			// mypetCard가 로드된 후에 버튼에 이벤트 리스너 추가
			navigator.geolocation.getCurrentPosition(
	        function (position) {
	            var lat = position.coords.latitude; // 위도
	            var lon = position.coords.longitude; // 경도
				const walkingBtn = document.querySelector("#walking-register-btn");
				if (walkingBtn) {
					walkingBtn.addEventListener("click", async (event) => { 
					const petId = event.currentTarget.dataset.petId;
					const postData = {
						location: `\${lat},\${lon}`,
						petId: petId
					};
							
					const res = await fetch(`/bughunters/pet/walking/register`, {
						method: "POST",
						headers: {
							'Content-Type': 'application/json',
						},
						body: JSON.stringify(postData), // JSON.stringify로 수정
					});
					const data = await res.json();
					console.log(data);
					if (data.msg === "산책 게시판에 등록하였습니다.") 
						alert(data.msg);
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
	document.addEventListener("DOMContentLoaded", async(event) =>{
		const res = await fetch(`/bughunters/pet/walking/list`, {
			method: "GET",
		});
		const data = await res.json();
		const pets = data.data;
		if (Array.isArray(pets) && pets.length > 0) {
			listBox.innerHTML = pets.map((pet) => `	
			<li class="like-pet-item">
				<img 
					src="data:image/jpeg;base64,\${pet.base64ProfileImage}"
					class="card-img-top card-image"
					alt="반려 동물 사진" 
				>
				<div class="card-body">
					<h5 class="card-title fw-bold chat-name">\${pet.name}</h5>
					<p class="card-text text-muted text-small">
						\${pet.intro}
					</p>
					<ul class="card-list">
						<li class="card-item">
							<img src="/bughunters/resources/image/ico_individual.png" class="card-icon" />
							<span>\${pet.kind}</span>
						</li>	
						<li class="card-item">
							<img src="/bughunters/resources/image/ico_gender.png" class="card-icon" />
							<span>\${pet.gender}</span>
						</li>
						<li class="card-item">
							<img src="/bughunters/resources/image/ico_age.png" class="card-icon" />
							<span>\${pet.age}년생</span>
						</li>	
						<li class="card-item">
							<img src="/bughunters/resources/image/ico_temperature.png" class="card-icon" />
							<span>\${pet.meetingTemperature}</span>
						</li>
					</ul>
					<div>
						<button type="button" class="btn btn-gray w-100 chat-name">1대1 채팅</button>
					</div>
				</div>
			</li>
			`).join('');
			pets.forEach((pet) => {
                // Split the location string into lat and lon
                const coords = pet.location.split(',');
                if (coords.length === 2) {
                    const lat = parseFloat(coords[0]);
                    const lon = parseFloat(coords[1]);

                    // Check if coordinates are valid numbers
                    if (!isNaN(lat) && !isNaN(lon)) {
                        const petPosition = new kakao.maps.LatLng(lat, lon);
                        new kakao.maps.Marker({
                            map: map,
                            position: petPosition,
                            title: pet.name,
                        });
                    }
                }
            });
		}
	});
	</script>
</body>
</html>