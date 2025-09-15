<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.List, java.util.ArrayList"%>
<%@ include file="../../component/passwordConfirm_modal.jsp"%>
<%
	// 예시용 하드코딩 데이터
	String email = "min44@naver.com";
	String address = "서울특별시 강남구 테헤란로 123";
	String nickname = "민민";
	boolean hasPet = true;

	//예시용 카드데이터(나중에 다른정보 추가해야함)
	class Animal {
		String name;
		String type;
		String image;

		Animal(String name, String type, String image) {
			this.name = name;
			this.type = type;
			this.image = image;
		}
	}

	List<Animal> animals = new ArrayList<>();
	animals.add(new Animal("럭키", "골든 리트리버",
			"http://openapi.animal.go.kr/openapi/service/rest/fileDownloadSrvc/files/shelter/2025/08/202508130908844.jpeg"));
	animals.add(new Animal("나비", "코리안 숏헤어",
			"http://openapi.animal.go.kr/openapi/service/rest/fileDownloadSrvc/files/shelter/2025/08/202508130908358.jpeg"));
	animals.add(new Animal("뽀삐", "푸들",
			"http://openapi.animal.go.kr/openapi/service/rest/fileDownloadSrvc/files/shelter/2025/08/202508130908635.jpeg"));
	animals.add(new Animal("두부", "시바견",
			"http://openapi.animal.go.kr/openapi/service/rest/fileDownloadSrvc/files/shelter/2025/08/202508130908273.jpeg"));
	animals.add(new Animal("초코", "말티즈",
			"http://openapi.animal.go.kr/openapi/service/rest/fileDownloadSrvc/files/shelter/2025/08/202508130808662.jpg"));
	animals.add(new Animal("콩이", "진돗개",
			"http://openapi.animal.go.kr/openapi/service/rest/fileDownloadSrvc/files/shelter/2025/08/202508131108540.jpg"));

	request.setAttribute("email", email);
	request.setAttribute("nickname", nickname);

	//예시용 게시글&댓글 데이터(나중에 다른정보 추가해야함)
	class Post {
		String author;
		String content;
		String time;
		int likes;
		int comments;
		int views;

		Post(String author, String content, String time, int likes, int comments, int views) {
			this.author = author;
			this.content = content;
			this.time = time;
			this.likes = likes;
			this.comments = comments;
			this.views = views;
		}
	}

	class Comment {
		String author;
		String targetAuthor;
		String content;
		String time;

		Comment(String author, String targetAuthor, String content, String time) {
			this.author = author;
			this.targetAuthor = targetAuthor;
			this.content = content;
			this.time = time;
		}
	}

	List<Post> posts = new ArrayList<>();
	posts.add(new Post("이서연", "새로운 입양 가이드라인에 대한 의견을 나누고 싶습니다. 최근 변경된 부분이 있는데, 공유해주신 분 계신가요?", "2시간 전", 1234, 45,
			210));
	posts.add(new Post("박지훈", "저희 집 고양이 뿌잉이가 새로운 장난감을 너무 좋아하네요! 고양이 장난감 추천 좀 해주세요.", "1분 전", 1234, 45, 210));

	List<Comment> comments = new ArrayList<>();
	comments.add(new Comment("김민준", "이서연", "저도 같은 의견입니다. 새로운 기준 좋네요.", "30분 전"));
	comments.add(new Comment("김민준", "정하윤", "다음 봉사활동도 같이 가요!", "1일 전"));
%>

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
}

.flex-item-left, .flex-item-right {
	flex: 50%;
}

/* --------------------
   Swiper 영역
-------------------- */
.swiper-container {
	position: relative;
}

.swiper-slide .card {
	width: 50% !important;
	margin: auto;
}

/* Swiper 버튼 스타일 */
.swiper-button-next, .swiper-button-prev {
	background-size: 50% auto;
	background-position: center;
	background-repeat: no-repeat;
}

.swiper-button-next {
	background-image: url(/bughunters/resources/image/ico_next.png);
}

.swiper-button-prev {
	background-image: url(/bughunters/resources/image/ico_prev.png);
}

/* Swiper 기본 버튼 숨기기 (기본 화살표 제거) */
.swiper-button-next::after, .swiper-button-prev::after {
	display: none;
}

.swiper-container-wrapper {
	position: relative;
	width: 100%;
	height: 550px;
	overflow: hidden;
}

/* 카드가 작게 나오는 경우 대비 */
.swiper-slide {
	display: flex;
	justify-content: center;
}

/* --------------------
   기타
-------------------- */
.search-card {
	width: 1020px;
	margin: 0 auto;
	height: 410px;
}
</style>
<!-- Bootstrap 5 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="/bughunters/resources/css/common.css" rel="stylesheet">
<link href="/bughunters/resources/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

</head>
<body>
	<%@ include file="/WEB-INF/views/component/header.jsp"%>
	<div class="container my-5">
		<!-- 프로필 정보 -->
		<div class="flex-container">
			<div class="section flex-item-left">
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

				<!-- 수정 버튼 -->
				<button type="button" class="btn btn-brown" data-bs-toggle="modal"
					data-bs-target="#passwordComfirmModal">프로필 수정</button>
			</div>
			<!-- 오른쪽화면(펫 프로필 확인) -->
			<div class="flex-item-right d-grid" style="margin-top: -60px;">
				<!-- ✅ 추가된 wrapper: 여기서 그라데이션 효과 넣을 거야 -->
				<div class="swiper-container-wrapper"
					style="width: 100%; height: 550px;">

					<div class="swiper swiper-container"
						style="width: 100%; height: 100%;">
						<div class="swiper-wrapper">
							<div class="swiper-slide">
								<jsp:include page="/WEB-INF/views/component/myPetCard.jsp" />
							</div>
						</div>

						<!-- 화살표 -->
						<div class="swiper-button-next"></div>
						<div class="swiper-button-prev"></div>
					</div>

				</div>

				<div class="text-center mt-3">
					<a class="btn btn-brown" href="/bughunters/pet/signup"> 내 반려동물
						등록하기 </a>
				</div>
			</div>

			<!-- Swiper 라이브러리 불러오기 -->
			<script
				src="https://cdn.jsdelivr.net/npm/swiper@9/swiper-bundle.min.js"></script>

			<!-- Swiper 초기화 코드 실행 (DOMContentLoaded 후) -->
			<script>
  document.addEventListener("DOMContentLoaded", function () {
    const swiper = new Swiper(".swiper-container", {
      slidesPerView: 1,
      spaceBetween: 20,
      centeredSlides: true,
      loop: true,
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev",
      },
    });
  });
  
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

	</div>

	<!-- 관심 유기 동물 -->
	<div class="container my-5 section">
		<h3>내가 관심 있는 유기동물</h3>
		<div class="row row-cols-1 row-cols-md-4 g-4 mt-3" id="animal-list">
			<%
				for (int i = 0; i < animals.size(); i++) {
					Animal a = animals.get(i);
					boolean isHidden = i >= 4;
			%>
			<div class="col animal-card <%=isHidden ? "more-card" : ""%>"
				style="<%=isHidden ? "display: none;" : ""%>">
				<div class="card h-100">
					<img src="<%=a.image%>" class="card-img-top" alt="<%=a.name%>">
					<div class="card-body">
						<h5 class="card-title"><%=a.name%></h5>
						<p class="card-text"><%=a.type%></p>
						<a href="#" class="btn btn-outline-secondary btn-sm">자세히 보기</a>
					</div>
				</div>
			</div>
			<%
				}
			%>
		</div>
	</div>
	<div class="container my-5 text-center mt-3">
		<button class="btn btn-outline-secondary" id="toggle-btn">더보기</button>
	</div>

	<script>
    document.getElementById("toggle-btn").addEventListener("click", function () {
        const hiddenCards = document.querySelectorAll(".more-card");
        const isHidden = hiddenCards[0].style.display === "none";

        hiddenCards.forEach(card => {
            card.style.display = isHidden ? "block" : "none";
        });

        this.textContent = isHidden ? "접기" : "더보기";
    });
</script>


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
				<%
					for (Post p : posts) {
				%>
				<div class="mb-3">
					<strong><%=p.author%></strong> <small class="text-muted">·
						<%=p.time%></small>
					<p><%=p.content%></p>
					<div class="d-flex align-items-center gap-3 mt-2">
						<div class="d-flex align-items-center gap-1">
							<img src="/bughunters/resources/image/ico_like.png" alt="좋아요"
								width="18" height="18"> <span><%=p.likes%></span>
						</div>
						<div class="d-flex align-items-center gap-1">
							<img src="/bughunters/resources/image/ico_comment.png" alt="댓글"
								width="18" height="18"> <span><%=p.comments%></span>
						</div>
						<div class="d-flex align-items-center gap-1">
							<img src="/bughunters/resources/image/ico_watch.png" alt="조회수"
								width="18" height="18"> <span><%=p.views%></span>
						</div>
					</div>
				</div>
				<%
					}
				%>
			</div>

			<!-- 댓글 -->
			<div class="tab-pane fade" id="comments" role="tabpanel">
				<%
					for (Comment c : comments) {
				%>
				<div class="mb-3">
					<strong><%=c.author%></strong> <small class="text-muted">·
						<%=c.time%></small>
					<p>
						<%=c.targetAuthor%>님의 글에 댓글:
						<%=c.content%></p>
				</div>
				<%
					}
				%>
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
					<a href="#" class="btn btn-gray d-block">산책 게시판 등록하기</a>
				</div>		
			`; 
		 });
	</script>
</body>
</html>
