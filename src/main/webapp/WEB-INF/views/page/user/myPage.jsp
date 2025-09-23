<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.List, java.util.ArrayList"%>
<%@ include file="../../component/passwordConfirm_modal.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<style>
/* --------------------
   전체 스타일 설정
-------------------- */
body {
	font-family: 'Pretendard', sans-serif;
	background-color: #f9f9f9;
}

/* --------------------
   카드 스타일
-------------------- */
.card-body {
	background-color: #fdfaf6;
}

.pet-card {
	height: 300px !important;
}

.card-flex {
	display: flex;
	flex-direction: column;
	gap: 10px;
	padding-inline: 40px;
}

.card-flex-left {
	display: flex;
	flex-direction: column;
	gap: 8.5px;
	padding-inline: 20px;
}

.card-profile-img {
	width: 100%;
	height: 300px;
}

/* --------------------
   탭 스타일 (게시글/댓글)
-------------------- */
.nav-tabs .nav-link {
	background-color: #ffdeb3;
	color: gray;
	border: 1px solid #8B5E3C !important;
}

.nav-tabs .nav-link.active {
	background-color: #a75d00 !important;
	color: white !important;
}

/* --------------------
   레이아웃 (프로필 영역 좌우)
-------------------- */
.flex-container {
	display: flex;
	flex-direction: row;
	text-align: center;
	gap: 10px;
}

.flex-item-left, .flex-item-right {
	flex: 50%;
}

/* --------------------
   기타
-------------------- */
.search-card {
	width: 1020px;
	margin: 0 auto;
	height: 410px;
}

.post-item { border: 0; border-bottom: 1px solid #e5e7eb; border-radius: 0; }
.post-thumb-wrap { width: 90px; height: 90px; flex: 0 0 90px; }
.post-thumb { width: 100%; height: 100%; object-fit: cover; border-radius: 8px;}
.post-title { font-weight: 700; font-size: 1.1rem; margin: 0; }
.post-meta { color:#6b7280; font-size: .875rem; }
.post-stats img { vertical-align: -2px; }
.post-link { text-decoration: none; color: inherit !important; display:block;
  text-decoration: none !important; }

</style>
<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

</head>
<body>
	<%@ include file="/WEB-INF/views/component/header.jsp"%>
	<div class="container my-5">
		<!-- 프로필 정보 -->
		<div class="flex-container">
			<div class="section flex-item-left">
				<div class="card-flex-left">
					<h3>프로필 정보</h3>
					<hr>
					<div class="mb-3">
						<label class="form-label">이메일 주소</label>
						<div class="card">
							<div class="card-body" id="emailVal"></div>
						</div>
					</div>
	
					<div class="mb-3">
						<label class="form-label">주소</label>
						<div class="card">
							<div class="card-body" id="addressVal"></div>
						</div>
					</div>
	
					<div class="mb-3">
						<label class="form-label">닉네임</label>
						<div class="card">
							<div class="card-body" id="nicknameVal"></div>
						</div>
					</div>
	
					<div class="mb-3">
						<label class="form-label d-block">반려동물 소유 여부</label>
						<div class="card">
							<div class="card-body" id="hasPetVal"></div>
						</div>
					</div>
				</div>

				<!-- 수정 버튼 -->
				<button type="button" class="btn btn-brown" data-bs-toggle="modal"
					data-bs-target="#passwordComfirmModal" style="width: 80%;">
					프로필 수정
				</button>
			</div>
			<!-- 오른쪽화면(펫 프로필 확인) -->
			<div class="section flex-item-right">
				<div class="card-flex">
					<h3>내 반려동물 정보</h3>
					<hr>
					<jsp:include page="/WEB-INF/views/component/myPetCard.jsp" />
					<c:if test="${isPet == false}">
						<a class="btn btn-brown" href="/bughunters/pet/signup"> 
							내 반려동물 등록하기 
						</a>
					</c:if>
					<c:if test="${isPet == true}">
						<a class="btn btn-brown" href="/bughunters/pet/edit"> 
							내 반려동물 수정하기 
						</a>
					</c:if>

				</div>
			</div>
				
		</div>

			<!-- Swiper 초기화 코드 실행 (DOMContentLoaded 후) -->
			<script>
			  // 프로필 불러오기
			  (async function () {
				  try {
				    const url = '<c:url value="/user/me"/>';
				    const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
				    if (!res.ok) throw new Error('HTTP ' + res.status);
				    const u = await res.json();
			
				    // 비로그인/빈객체 처리
				    if (!u || (!u.userName && !u.userId)) {
				      console.warn('로그인 필요 또는 사용자 없음');
				      return;
				    }
			
				    document.getElementById('emailVal').textContent    = u.userName ?? '-';
				    document.getElementById('addressVal').textContent  = u.address  ?? '-';
				    document.getElementById('nicknameVal').textContent = u.nickName ?? '-';
				    document.getElementById('hasPetVal').textContent   = (u.isPet === 1 ? '예' : '아니요');
				  } catch (e) {
				    console.error('프로필 로드 실패:', e);
				  }
				})();
			</script>
		</div>
	</div>
	<!-- 관심 유기 동물 -->
	<div class="container my-5 section">
		<h3>내가 관심있는 유기 동물</h3>
		<ul class="wrapper-like-pet">

		</ul>
	</div>


	<!-- 커뮤니티 활동 (탭 전환) -->

	<div class="container my-5 section">
		<h3 class="mb-3">내 커뮤니티 활동</h3>

		<!-- 탭 버튼 -->
		<ul class="nav nav-tabs" id="activityTabs">
			<li class="nav-item">
				<button class="nav-link active" id="posts-tab" data-bs-toggle="tab"
					data-bs-target="#posts" type="button" role="tab">게시글</button>
			</li>
			<li class="nav-item">
				<button class="nav-link" id="comments-tab" data-bs-toggle="tab"
					data-bs-target="#comments" type="button" role="tab">댓글</button>
			</li>
		</ul>

		<!-- 탭 콘텐츠 -->
		<div class="tab-content border border-top-0 p-3"
			id="activityTabsContent">

			<!-- 게시글 -->
			<div class="tab-pane fade show active" id="posts" role="tabpanel">
				<div id="postsList"></div>
				<div class="d-flex gap-2 mt-2">
					<button class="btn btn-outline-secondary" id="postsPrev">이전</button>
					<button class="btn btn-outline-secondary" id="postsNext">다음</button>
				</div>
			</div>

			<!-- 댓글 -->
			<div class="tab-pane fade" id="comments" role="tabpanel">
				<div id="commentsList"></div>
				<div class="d-flex gap-2 mt-2">
					<button class="btn btn-outline-secondary" id="commentsPrev">이전</button>
					<button class="btn btn-outline-secondary" id="commentsNext">다음</button>
				</div>
			</div>

		</div>
	</div>

	<%@ include file="/WEB-INF/views/component/footer.jsp"%>
	<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>
	<script>
		// mypet 정보 가져오기
		const cardbox = document.querySelector("#mypet-card");
		document.addEventListener("DOMContentLoaded", async (event) => {
			const res = await fetch(`/bughunters/pet/mypet`, {
				method: "GET",
			});
			const data = await res.json();
			console.log(data);
			if(data.mypet !== null) {
				cardbox.innerHTML = `
					<img 
						src="data:image/jpeg;base64,\${data.mypet.base64ProfileImage}"
						class="card-profile-img"
						alt="반려동물 사진없음" 
					>
					<div class="">
						<h5 class="card-title fw-bold margin-t">\${data.mypet.name}</h5>
						<p class="card-text text-muted text-small">
							\${data.mypet.intro}
						</p>
						<ul class="mypet-card-list">
							<li class="card-item">
								<img src="/bughunters/resources/image/ico_individual.png" class="card-icon" />
								<span>\${data.mypet.kind}</span>
							</li>	
							<li class="card-item">
								<img src="/bughunters/resources/image/ico_gender.png" class="card-icon" />
								<span>\${data.mypet.gender}</span>
							</li>	
							<li class="card-item">
								<img src="/bughunters/resources/image/ico_age.png" class="card-icon" />
								<span>\${data.mypet.age}년생</span>
							</li>	
							<li class="card-item">
								<img src="/bughunters/resources/image/ico_size.png" class="card-icon" />
								<span>\${data.mypet.weight}kg</span>
							</li>	
							<li class="card-item">
								<img src="/bughunters/resources/image/ico_color.png" class="card-icon" />
								<span>\${data.mypet.color}</span>
							</li>	
							<li class="card-item">
								<img src="/bughunters/resources/image/ico_temperature.png" class="card-icon" />
								<span>\${data.mypet.meetingTemperature}°C</span>
							</li>	
						</ul>
					</div>		
				`; 		
			} else {
				cardbox.innerHTML = `<p style="color: gray">반려동물을 등록해주세요!</p>`;
			}
		 });
		
		// 관심있는 유기동물 리스트 
		const likePetBox = document.querySelector(".wrapper-like-pet");
		
		document.addEventListener("DOMContentLoaded", async(event) => {
		    try {
		        const res = await fetch(`/bughunters/abandonedpet/like/list`, {
		            method: "GET",
		        });
		        const data = await res.json();
		        const pets = data.data;
		
		        if (Array.isArray(pets) && pets.length > 0) { 
		            likePetBox.innerHTML = pets.map((pet) => `
		                <li class="like-pet-item">
			            	<img src="\${pet.profileImage}" class="card-img-top card-image" alt="사진 없음">
			            	<div class="card-body">
			            		<div class="d-flex-space">
			            			<h5 class="card-title fw-bold text-medium">\${pet.kind}</h5>
			            		</div>
			            		<ul class="card-list">
			            			<li class="card-item">
			            				<img src="/bughunters/resources/image/ico_size.png" class="card-icon" />
			            				<span>\${pet.weight}kg</span>
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
							            <img src="/bughunters/resources/image/ico_location.png" class="card-icon" />
							            <span>\${pet.address}</span>
			            			</li>
			            		</ul>
			            		<a href="/bughunters/abandonedpet/\${pet.abandonedPetId}" class="btn btn-gray d-block">자세히 보기</a>
			            	</div>
		                </li>
		            `).join('');
		        } else {
		            likePetBox.innerHTML = '<p style="color: gray;">좋아하는 반려동물이 없습니다!</p>';
		        }
		    } catch (error) {
		        console.error('Failed to fetch liked pets:', error);
		    }
		});
		
		 // 상태
		  let postsPage = 1, commentsPage = 1;
		  const size = 5;

		  // 엘리먼트
		  const postsListEl    = document.querySelector('#postsList');
		  const commentsListEl = document.querySelector('#commentsList');

		  // 게시글 로드
		  
		  async function loadPosts() {
    try {
      const res = await fetch(`/bughunters/community/my/posts?page=\${postsPage}&size=\${size}`, {
        headers: { 'Accept': 'application/json' }
      });
      if (!res.ok) throw new Error('HTTP ' + res.status);
      const data = await res.json();

      if (data.error === 'UNAUTHORIZED') {
        postsListEl.innerHTML = `<p class="text-danger">로그인이 필요합니다.</p>`;
        return;
      }

      const items = data.items || [];
      renderPosts(items);  

      document.getElementById('postsPrev').disabled = postsPage <= 1;
      document.getElementById('postsNext').disabled = !data.hasNext;
    } catch (e) {
      console.error('게시글 로드 실패:', e);
      postsListEl.innerHTML = `<p class="text-danger">게시글을 불러오지 못했습니다.</p>`;
    }
  }
		  
		  // createdAt => "yyyy-MM-dd HH:mm" 비슷하게
const fmtDate = (v) => {
  try {
    const d = new Date(v);
    const pad = n => n.toString().padStart(2,'0');
    return d.getFullYear() + '-' +
           pad(d.getMonth()+1) + '-' +
           pad(d.getDate()) + ' ' +
           pad(d.getHours()) + ':' +
           pad(d.getMinutes());
  } catch { return v ?? ''; }
};

// 커뮤니티 렌더
function renderPosts(items = []) {
  if (!items.length) {
    postsListEl.innerHTML = `<div class="text-center text-muted py-5">작성한 게시글이 없습니다.</div>`;
    return;
  }
  postsListEl.innerHTML = items.map(p => `
    <a class="post-link" href="/bughunters/community/\${p.communityId}">
      <article class="card post-item py-3 mb-3 card-body">
          <div class="d-flex gap-3">

            <!-- 썸네일 (이미지 없으면 onerror로 기본 이미지 대체) -->
            <div class="post-thumb-wrap">
              <img class="post-thumb"
                   src="/bughunters/community/\${p.communityId}/image?v=\${p.viewcount ?? 0}"
                   alt="썸네일"
                   onerror="this.onerror=null;this.src='/bughunters/resources/image/img_noImg.png';">
            </div>

            <!-- 우측 내용 -->
            <div class="flex-grow-1 d-flex flex-column justify-content-between">

              <!-- 닉네임 / 날짜 -->
              <div class="d-flex justify-content-between post-meta-top">
                <span class="fw-semibold">\${p.nickname ?? ''}</span>
                <small>\${fmtDate(p.createdAt)}</small>
              </div>

              <!-- 제목 -->
              <h3 class="post-title">\${p.title ?? '제목 없음'}</h3>

              <!-- 조회수/댓글 -->
              <div class="d-flex gap-3 text-muted post-stats">
                <span>
                  <img src="/bughunters/resources/image/ico_watch.png" width="16" height="16" alt="조회수">
                  \${p.viewcount ?? 0}
                </span>
                <span>
                  <img src="/bughunters/resources/image/ico_comment.png" width="16" height="16" alt="댓글">
                  \${p.commentCount ?? 0}
                </span>
              </div>

            </div>
          </div>
      </article>
    </a>
  `).join('');
}

		  // 댓글 로드
		  async function loadComments() {
		    const res = await fetch(`/bughunters/community/my/comments?page=\${commentsPage}&size=\${size}`, {
		      headers: { 'Accept': 'application/json' }
		    });
		    const data = await res.json();
		    if (data.error === 'UNAUTHORIZED') {
		      commentsListEl.innerHTML = `<p class="text-danger">로그인이 필요합니다.</p>`;
		      return;
		    }
		    const items = data.items || [];
		    if (items.length === 0) {
		      commentsListEl.innerHTML = `<p class="text-muted">작성한 댓글이 없습니다.</p>`;
		    } else {
		      commentsListEl.innerHTML = items.map(c => `
		      <a class="post-link" href="/bughunters/community/\${c.communityId}">
		        <div class="mb-3">
		        <small class="text-muted">\${fmtDate(c.createdAt)}</small>
		          <p class="mb-1">\${c.content ?? ''}</p>
		          <div>
		            <span class="me-2">게시글: <strong>\${c.title ?? '(제목 없음)'}</strong></span>
		          </div>
		        </div>
		        </a>
		        <hr>
		      `).join('');
		    }
		    document.getElementById('commentsPrev').disabled = commentsPage <= 1;
		    document.getElementById('commentsNext').disabled = !data.hasNext;
		  }

		  // 이벤트 바인딩
		  document.addEventListener('DOMContentLoaded', () => {
		    // 게시글 먼저
		    loadPosts();

		    // 탭 전환 시 로딩
		    document.getElementById('posts-tab')?.addEventListener('shown.bs.tab', loadPosts);
		    document.getElementById('comments-tab')?.addEventListener('shown.bs.tab', loadComments);

		    // 페이징
		    document.getElementById('postsPrev')?.addEventListener('click', () => { if (postsPage > 1) { postsPage--; loadPosts(); } });
		    document.getElementById('postsNext')?.addEventListener('click', () => { postsPage++; loadPosts(); });
		    document.getElementById('commentsPrev')?.addEventListener('click', () => { if (commentsPage > 1) { commentsPage--; loadComments(); } });
		    document.getElementById('commentsNext')?.addEventListener('click', () => { commentsPage++; loadComments(); });
		  });
		
	</script>
</body>
</html>
