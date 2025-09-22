/**
 * 
 */

/* ===== 채팅 스크립트 (원본 유지, 필수 최소 수정만) ===== */
const ORIGIN = window.location?.origin || (location.protocol + '//' + location.host);
const CTX    = (typeof window.CTX === 'string' && window.CTX) ? window.CTX : '/bughunters';
const BASE   = (typeof window.BASE === 'string' && window.BASE) ? window.BASE : (ORIGIN + CTX);
window.CTX = CTX;  // 전역 노출
window.BASE = BASE;

// ▼ 여기만 바뀜: JSP <%= ... %> 대신 전역에서 주입받음
// const MY_PET_ID = (typeof window.MY_PET_ID === 'number' ? window.MY_PET_ID :
// -1);
let MY_PET_ID = (() => {
	  const raw = (window.MY_PET_ID ?? window.__MY_PET_ID ?? null);
	  const n = Number(raw);
	  return Number.isFinite(n) ? n : -1;
	})();
	window.MY_PET_ID = MY_PET_ID; // 다른 스크립트에서도 동일한 숫자 쓰도록 동기화

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
function openList(){ show(chatList,'block'); show(chatDetail,'none'); lockListLayout();}
function openDetail(){ show(chatDetail,'flex'); show(chatList,'none'); }
function closeAll(){ show(chatList,'none'); show(chatDetail,'none'); }

chatBtn && chatBtn.addEventListener('click', () => {
  if (isShown(chatDetail)) openList();
  else isShown(chatList) ? closeAll() : openList();
});
chatCloseBtn && chatCloseBtn.addEventListener('click', closeAll);
chatDetailCloseBtn && chatDetailCloseBtn.addEventListener('click', closeAll);
chatBackBtn && chatBackBtn.addEventListener('click', openList);

/* ===== 방 목록/메시지/웹소켓 ===== */
let currentRoomId = null;
let joinedRoomId = null;
let ws = null;

async function loadRooms(){
  try{
    const res = await fetch(BASE + '/api/chat/rooms', {
      method:'GET', 
      credentials:'include',
      headers: { 'Accept': 'application/json' }
    });
    
    if (res.status === 401) {
      console.warn('401 from /api/chat/rooms (아직 인증으로 안보임)');
      return; // 일단 리디렉트 금지
    }
    if (!res.ok) throw new Error('HTTP ' + res.status);

    const ct = (res.headers.get('content-type') || '');
    if (!ct.includes('application/json')) throw new Error('Non-JSON response');

    const rooms = await res.json();
    renderRoomList(rooms);
  }catch(e){
    console.error('loadRooms failed', e);
  }
}

function renderRoomList(rooms){
	chatListBody.innerHTML = '';
	  if (!rooms || rooms.length === 0){
	    const empty = document.createElement('div');
	    empty.className = 'p-3 text-muted';
	    empty.textContent = '채팅방이 없습니다.';
	    chatListBody.appendChild(empty);
	    lockListLayout();
	    return;
	  }

	  rooms.forEach(r=>{
	    const item = document.createElement('div');
	    item.className = 'chat-item';
	    item.dataset.roomId = r.chatRoomId;

	    const img = document.createElement('img');
	    img.className = 'chat-avatar';

	    const info = document.createElement('div');
	    info.className = 'chat-info';

	    const name = document.createElement('div');
	    name.className = 'chat-name';
	    name.textContent = '';

	    const time = document.createElement('span');
	    time.className = 'chat-time';
	    time.textContent = '';
	    name.appendChild(document.createTextNode(' '));
	    name.appendChild(time);

	    const last = document.createElement('div');
	    last.className = 'chat-msg';
	    last.textContent = '';

	    info.appendChild(name);
	    info.appendChild(last);

	    const leaveBtn = document.createElement('button');
	    leaveBtn.type = 'button';
	    leaveBtn.className = 'chat-leave';
	    leaveBtn.textContent = '나가기';
	    leaveBtn.dataset.roomId = r.chatRoomId;

	    item.appendChild(img);
	    item.appendChild(info);
	    item.appendChild(leaveBtn);
	    chatListBody.appendChild(item);

	    // ✅ 상대 petId 계산
	    const p1 = Number(r.petId1), p2 = Number(r.petId2), me = Number(MY_PET_ID);
	    const peerId = (p1 === me) ? p2 : p1;
	    if (Number.isFinite(peerId)) {
	      item.dataset.peerId = String(peerId);

	      // 1차: 캐시에 있으면 즉시 반영
	      applyPeerMetaToItem(item, peerId);

	      // 2차: 캐시에 없으면 서버에서 이미지/이름 불러와서 다시 반영
	      if (!window.PET_IMG?.[peerId] || !window.PET_NAME?.[peerId]) {
	        fetchPetImage(peerId).then(()=> {
	          applyPeerMetaToItem(item, peerId);
	        });
	      }
	    }
	  });

	  lockListLayout();
	}
window.addEventListener('resize', lockListLayout);

// 메시지 로딩
async function loadMessages(roomId, cursor){
  // ▼ 여기만 let으로 (cursor 쓰는 순간 const 재할당 에러 방지)
  let url = BASE + '/api/chat/rooms/' + roomId + '/messages';
  if (cursor) url += '?cursor=' + encodeURIComponent(cursor);

  const res = await fetch(url, { credentials: 'include', headers: { 'Accept':'application/json' } });
  if (!res.ok) throw new Error('HTTP ' + res.status);
  const ct = (res.headers.get('content-type') || '');
  if (!ct.includes('application/json')) throw new Error('Non-JSON response');
  const list = await res.json();
  const msgs = (Array.isArray(list) ? list : []).map(normalizeMessage).reverse();
  chatMessages.innerHTML = '';
  msgs.forEach(appendMessage);
  chatMessages.scrollTop = chatMessages.scrollHeight;
}

// 1:1 생성
async function openDirect(toPetId) {
	  const qs  = new URLSearchParams({ toPetId: String(toPetId) });
	  const res = await fetch(`${BASE}/api/chat/rooms/direct?${qs}`, {
	    method: 'POST',
	    credentials: 'include',
	    headers: { 'Accept': 'application/json' }
	  });
	  if (!res.ok) {
	    const txt = await res.text().catch(()=> '');
	    alert(txt || '채팅방 생성에 실패했습니다.');
	    return;
	  }
	  const data = await res.json();
	  const roomId = data.roomId ?? data.chatRoomId;

	  // ✅ 캐시에 있으면 즉시 제목 반영 (리스트에서 이미 캐시됨)
	  const nm = window.PET_NAME?.[toPetId];
	  if (nm && chatRoomTitle) chatRoomTitle.textContent = nm;

	  // ✅ roomId → toPetId 매핑 캐싱
	  window.ROOM_PEER_MAP = window.ROOM_PEER_MAP || {};
	  window.ROOM_PEER_MAP[roomId] = toPetId;

	  await openRoom(roomId);

	  // 목록은 뒤에서 최신화 + 해당 item에도 peerId 명시
	  loadRooms().then(()=>{
	    const item = chatListBody.querySelector(`[data-room-id="${roomId}"]`);
	    if (item) {
	      item.dataset.peerId = String(toPetId);
	      applyPeerMetaToItem(item, toPetId);
	    }
	  }).catch(()=>{});
	}

function appendMessage(m){
	const from = Number(m.petId);
	  const me   = Number(MY_PET_ID);
	  const side = (from === me) ? 'right' : 'left';
	  // 빠른 디버깅용
	  console.debug('[MSG]', {from, me, side, text: m.chatMessage});

	  const wrap = document.createElement('div');
	  wrap.className = 'message ' + side;
	  const text = document.createElement('div');
	  text.className = 'text';
	  text.textContent = m.chatMessage || '';
	  wrap.appendChild(text);
	  chatMessages.appendChild(wrap);
}

// 대기 헬퍼
function waitWsOpen(timeoutMs = 3000){
  return new Promise((resolve, reject)=>{
    if (ws && ws.readyState === WebSocket.OPEN) return resolve();
    const start = Date.now();
    (function tick(){
      if (ws && ws.readyState === WebSocket.OPEN) return resolve();
      if (Date.now() - start > timeoutMs) return reject(new Error('WS open timeout'));
      setTimeout(tick, 50);
    })();
  });
}

// 소켓 열기(이벤트 핸들러 포함)
function ensureWs(){
  if (ws && (ws.readyState === WebSocket.OPEN || ws.readyState === WebSocket.CONNECTING)) return;

  const scheme = (location.protocol === 'https:') ? 'wss://' : 'ws://';
  const wsUrl  = scheme + location.host + CTX + '/ws/chat';
  ws = new WebSocket(wsUrl);

  ws.onopen = () => {
    console.log('[WS] open');
    if (currentRoomId != null) {
      ws.send(JSON.stringify({ type:'JOIN', roomId: currentRoomId }));
      joinedRoomId = currentRoomId;
      if (chatSendBtn) chatSendBtn.disabled = false;
    }
  };
  ws.onclose = () => {
    console.log('[WS] close');
    joinedRoomId = null;
    if (chatSendBtn) chatSendBtn.disabled = true;
  };
  ws.onerror = (e) => console.error('[WS] error', e);
  ws.onmessage = (evt) => {
	  try {
		    const data = JSON.parse(evt.data);

		    if (data.type === 'MESSAGE' && data.roomId === currentRoomId) {
		      appendMessage(normalizeMessage({ body: data.body, senderPetId: data.senderPetId }));
		      chatMessages.scrollTop = chatMessages.scrollHeight;
		    }

		    // ✅ 상대방 나감 이벤트 감지
		    if (data.type === 'LEFT' && data.roomId === currentRoomId) {
		      peerHasLeft = true;
		      showSystem('상대가 채팅방을 나가셨습니다.');
		      disableChatInput('상대가 나가서 채팅을 보낼 수 없습니다.');
		    }
		  } catch(e){ console.error(e); }
  };
}

// 방 열기: OPEN 대기 후 JOIN

// 상대 나감 여부 전역 변수
let peerHasLeft = false;

async function openRoom(roomId){
	currentRoomId = roomId;
	  peerHasLeft = false; // 방 열 때 초기화
	  if (chatSendBtn) chatSendBtn.disabled = true;

	  openDetail();
	  await loadMessages(roomId);
	  
	  try {
	    const res = await fetch(`${BASE}/api/chat/rooms/${roomId}/status`, {
	      credentials: 'include',
	      headers: {'Accept':'application/json'}
	    });
	    if (res.ok) {
	      const st = await res.json();
	      const p1 = Number(st.pet_id1 ?? st.PET_ID1 ?? st.petId1);
	      const p2 = Number(st.pet_id2 ?? st.PET_ID2 ?? st.petId2);
	      const me = Number(MY_PET_ID);
	      const peerId = (p1 === me) ? p2 : p1;

	      const peerLeft = ( (p1===peerId) ? st.pet1_left_at ?? st.PET1_LEFT_AT
	                                        : st.pet2_left_at ?? st.PET2_LEFT_AT );
	      if (peerLeft) {
	        peerHasLeft = true; // 상대방 나감 기록
	        showSystem('상대가 채팅방을 나가셨습니다.');
	        disableChatInput('상대가 나가서 채팅을 보낼 수 없습니다.');
	      }
	    }
	  } catch (e) {/* noop */}
	  
	  const item = chatListBody && chatListBody.querySelector(`[data-room-id="${roomId}"]`);
	  await hydrateChatItemByRoomId(roomId, item || document);

	  ensureWs(); 
	  try{
	    await waitWsOpen();
	    ws.send(JSON.stringify({ type:'JOIN', roomId }));
	    joinedRoomId = roomId;
	    if (chatSendBtn && !peerHasLeft) chatSendBtn.disabled = false;
	  }catch(err){
	    console.error('JOIN failed:', err);
	    alert('채팅 연결에 문제가 있습니다. 잠시 후 다시 시도해 주세요.');
	  }
}

// 메시지 전송
async function send(){
	const text = (chatInput.value || '').trim();
	  if (!text) return;

	  // 상대가 나갔는지 서버에서 확인
	  if (!peerHasLeft) {
	    try {
	      const res = await fetch(`${BASE}/api/chat/rooms/${currentRoomId}/status`, {
	        credentials: 'include',
	        headers: {'Accept':'application/json'}
	      });
	      if (res.ok) {
	        const st = await res.json();
	        const p1 = Number(st.pet_id1 ?? st.PET_ID1 ?? st.petId1);
	        const p2 = Number(st.pet_id2 ?? st.PET_ID2 ?? st.petId2);
	        const me = Number(MY_PET_ID);
	        const peerId = (p1 === me) ? p2 : p1;
	        const peerLeft = ( (p1===peerId) ? st.pet1_left_at ?? st.PET1_LEFT_AT
	                                          : st.pet2_left_at ?? st.PET2_LEFT_AT );
	        if (peerLeft) {
	          peerHasLeft = true;
	          alert('상대가 채팅방을 나가셨습니다.');
	          disableChatInput('상대가 나가서 채팅을 보낼 수 없습니다.');
	          return;
	        }
	      }
	    } catch(e) { console.error(e); }
	  }

	  // ✅ 여기 도달했을 때만 실제 전송
	  if (!ws || ws.readyState !== WebSocket.OPEN || currentRoomId == null) return;
	  if (joinedRoomId !== currentRoomId) return;

	  ws.send(JSON.stringify({ type:'SEND', roomId: currentRoomId, body: text }));
	  chatInput.value = '';
}

chatSendBtn && chatSendBtn.addEventListener('click', send);
chatInput && chatInput.addEventListener('keydown', (e)=>{ if(e.key === 'Enter' && !e.shiftKey){ e.preventDefault(); send(); }});

document.addEventListener('click', async (e)=>{
  const btn = e.target.closest('[data-chat-room-id], [data-chat-with]');
  if(!btn) return;
  
  if (btn.dataset.chatRoomId){
    const roomId = parseInt(btn.dataset.chatRoomId, 10);
    if (!isNaN(roomId)) {
      openDetail();
      await openRoom(roomId);
    }
    return;
  }

  if (btn.dataset.chatWith){
    const toPetId = parseInt(btn.dataset.chatWith, 10);
    if (!isNaN(toPetId)) {
    	 // ✅ 본인에게는 1:1 불가
    	    if (Number(toPetId) === Number(MY_PET_ID)) {
    	       alert('나와의 채팅은 불가능합니다.');
    	       return;
    	     }
    	await openDirect(toPetId);
    }
  }
});

document.addEventListener('DOMContentLoaded', async () => {
	try {
	    // 내 펫 정보 조회해서 MY_PET_ID 보정
	    const meRes = await fetch(BASE + '/pet/mypet', { credentials: 'include', headers: { 'Accept':'application/json' } });
	    if (meRes.ok && (meRes.headers.get('content-type') || '').includes('application/json')) {
	      const me = await meRes.json();
	      const cand = me.petId ?? me.myPetId ?? me.id ?? me.PET_ID ?? me?.pet?.id;
	      const n = Number(cand);
	      if (Number.isFinite(n)) {
	        MY_PET_ID = n;
	        window.MY_PET_ID = n;
	        console.debug('[ME] MY_PET_ID set to', n);
	      }
	    }

	    await loadRooms();
	  } catch(e) {
	    console.error(e);
	  }
});

// === [추가 1] 채팅방 아바타/타이틀 채우기 ===
async function hydrateChatItemByRoomId(roomId, itemEl) {
	 try {
		    const el = itemEl || chatListBody.querySelector(`[data-room-id="${roomId}"]`);

		    // ✅ 먼저 ROOM_PEER_MAP에서 찾기
		    let peerId = window.ROOM_PEER_MAP?.[roomId] ?? null;

		    if (!peerId) {
		      const dsPeer = el?.dataset?.peerId ? Number(el.dataset.peerId) : null;
		      peerId = Number.isFinite(dsPeer) ? dsPeer : await fetchPeerPetId(roomId);
		    }

		    if (!peerId) return;

		    applyPeerMetaToItem(el || document, peerId);

		    // 헤더 제목도 갱신
		    if (chatRoomTitle && currentRoomId === roomId) {
		      const nm = window.PET_NAME?.[peerId];
		      if (nm) chatRoomTitle.textContent = nm;
		    }
		  } catch(e) { /* noop */ }
}

async function fetchPeerPetId(roomId) {
	try {
	    const r = await fetch(`${BASE}/api/chat/rooms/${roomId}/messages?limit=30`, {
	      credentials: 'include', headers: { 'Accept': 'application/json' }
	    });
	    if (!r.ok) return null;
	    const raw = await r.json();
	    const list = Array.isArray(raw) ? raw.map(normalizeMessage) : [];
	    const other = list.find(m => m.petId != null && Number(m.petId) !== Number(MY_PET_ID));
	    return other ? Number(other.petId) : null;
	  } catch {
	    return null;
	  }
}

	async function fetchPetImage(petId) {
	// 개별 프로필 조회(백엔드에 있으면 사용, 없으면 자동 스킵)
	try {
	    const r = await fetch(`${BASE}/pet/${petId}/profile`, {
	      credentials: 'include', headers: { 'Accept': 'application/json' }
	    });
	    if (!r.ok) return null;       // 404면 그냥 조용히 null
	    const d = await r.json();

	    let src = null;
	    if (d.base64ProfileImage) src = 'data:image/jpeg;base64,' + d.base64ProfileImage;
	    else if (d.imageUrl)      src = d.imageUrl;

	    if (src) (window.PET_IMG  ||= {})[petId] = src;
	    if (d.name) (window.PET_NAME ||= {})[petId] = d.name;
	    return src;
	  } catch {
	    return null; 
	  }
}

// ✅ 서버 응답 키 통합: 어떤 형태로 와도 { petId:number, chatMessage:string }로 맞춤
function normalizeMessage(m) {
  const petIdRaw =
    m.petId ??
    m.senderPetId ??   // 흔한 이름 1
    m.fromPetId ??     // 흔한 이름 2
    m.authorPetId;     // 흔한 이름 3

  const chatMessage =
    m.chatMessage ??   // 우리 기본
    m.body ??          // WS payload 용어일 때
    m.message ??       // 다른 구현
    m.text ??          // 혹시 모를 변형
    '';

  return {
    petId: petIdRaw != null ? Number(petIdRaw) : null,
    chatMessage
  };
}

// 채팅방 UI 수정( 채팅창 크기 키우고 스크롤 추가하기 )
const CHAT_LIST_W = 290;   // px
const CHAT_LIST_H = 400;   // px

function lockListLayout() {
  if (!chatList) return;

  // 목록 패널 자체는 고정 크기, 스크롤은 내부 body로만
  chatList.style.width     = CHAT_LIST_W + 'px';
  chatList.style.height    = CHAT_LIST_H + 'px';
  chatList.style.maxHeight = CHAT_LIST_H + 'px';
  chatList.style.overflowY = 'hidden';

  // 헤더 높이를 빼고 body 영역만 스크롤 되게
  const headerEl = chatList.querySelector('.chat-list-header');
  const headerH  = headerEl ? headerEl.offsetHeight : 56; // 대략값(헤더가 없으면 56)
  const bodyH    = Math.max(0, CHAT_LIST_H - headerH);

  if (chatListBody) {
    chatListBody.style.height    = bodyH + 'px';
    chatListBody.style.maxHeight = bodyH + 'px';
    chatListBody.style.overflowY = 'auto';
  }
}

// 채팅방 나가기
async function leaveRoom(roomId) {
  const ok = window.confirm('채팅방을 나가시겠습니까?');
  if (!ok) return;

  const res = await fetch(`${BASE}/api/chat/rooms/${roomId}`, {
    method: 'DELETE',
    credentials: 'include',
    headers: { 'Accept': 'application/json' }
  });

  if (res.status === 401) { alert('로그인이 필요합니다.'); return; }
  if (res.status === 403) { alert('권한이 없습니다.'); return; }
  if (!res.ok) {
    const txt = await res.text().catch(()=> '');
    alert(txt || '채팅방 삭제에 실패했습니다.');
    return;
  }

  // 성공: 현재 방 보고 있으면 닫기
  if (currentRoomId === roomId) {
    try { ws && ws.close(); } catch(e) {}
    currentRoomId = null;
    joinedRoomId = null;
    closeAll();
  }

  // 목록에서 제거 + 서버 기준으로 재동기화
  const row = chatListBody.querySelector(`[data-room-id="${roomId}"]`);
  row?.remove();
  await loadRooms();
  lockListLayout();
}

// ▼ 목록 클릭 핸들러 내 '나가기' 분기에서 호출로 교체
chatListBody.addEventListener('click', async (e)=>{
  const leave = e.target.closest('.chat-leave');
  if (leave) {
    e.stopPropagation();
    e.preventDefault();
    const rid = Number(leave.dataset.roomId);
    await leaveRoom(rid);   // ← 여기!
    return;
  }

  const item = e.target.closest('.chat-item');
  if(!item) return;
  const roomId = +item.dataset.roomId;
  await openRoom(roomId);
});

// 채팅방 이미지와 이름 바뀌지 않게
function applyPeerMetaToItem(itemEl, peerId) {
	const imgEl  = itemEl?.querySelector?.('img.chat-avatar');
	  const nameEl = itemEl?.querySelector?.('.chat-name');

	  const cachedImg  = window.PET_IMG?.[peerId];
	  const cachedName = window.PET_NAME?.[peerId];

	  if (cachedImg && imgEl)  imgEl.src = cachedImg;
	  if (cachedName && nameEl) nameEl.textContent = cachedName;

	 
	}

// 상대 나감 시 입력 막기 + 안내 메시지
function disableChatInput(reasonText){
	  if (chatInput) {
	    chatInput.disabled = true;
	    chatInput.placeholder = reasonText || '상대가 나가서 채팅을 보낼 수 없습니다.';
	  }
	  if (chatSendBtn) chatSendBtn.disabled = true;
	}

	function showSystem(text){
	  const wrap = document.createElement('div');
	  wrap.className = 'message left'; // 회색 말풍선 재활용
	  const t = document.createElement('div');
	  t.className = 'text';
	  t.textContent = text;
	  wrap.appendChild(t);
	  chatMessages.appendChild(wrap);
	  chatMessages.scrollTop = chatMessages.scrollHeight;
	}

console.log('origin=', window.location.origin, 'CTX=', CTX, 'BASE=', BASE, 'len(BASE)=', (BASE || '').length);
console.log('MY_PET_ID=', MY_PET_ID);