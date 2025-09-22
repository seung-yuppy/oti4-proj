<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>운명의 발바닥</title>
	<link href="/bughunters/resources/css/common.css" rel="stylesheet">
	<link href="/bughunters/resources/css/bootstrap.min.css" rel="stylesheet">
	<style>
		.bg-brown-custom {
            background-color: #a75d00;
        }
        
        .text-brown-custom {
            color: #a75d00;
        }
        
        .btn-secondary-brown-custom  {
        	text-decoration: none;
            background-color: #c07a22;
            color: white;
            border-radius: 9999px;
            padding: 0.75rem 2rem;
            transition: all 0.3s ease;
            
            &:hover {
	            background-color: #99611a;
	            transform: translateY(-2px);
	            color: white;
	            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
        }
        
		.card-emoji {
		    animation: bounce 2s infinite;
		}
		
		@keyframes bounce {
		    0%, 100% {
		        transform: translateY(0);
		    }
		    50% {
		        transform: translateY(-10px);
		    }
		}
	</style>
</head>
<body>
	<!-- 헤더 영역 -->
	<%@ include file="/WEB-INF/views/component/header.jsp"%> 
    <!-- 히어로 섹션 - 사이트 미션 및 소개 -->
    <section class="bg-brown-custom text-white py-5 px-3">
        <div class="container text-center">
            <div class="fade-in">
                <h1 class="fw-bold mb-3 text-large">
                    “유기동물 파양을 줄이고, <br />반려인과 강아지가 더 행복해지도록”
                </h1>
                <p class="fw-light mb-4 text-medium">
		                    입양 순간의 설렘과 달리, 현실에서 마주하는 다양한 갈등과 부담은 결국 반려동물의 버려짐으로 이어지고 있습니다.<br>
		                    우리는 이 문제를 해결하고자 ‘운명의 발바닥’ 플랫폼을 만들었습니다. <br>
		                    반려인과 강아지 모두가 “함께 행복한 삶”을 살아갈 수 있도록 돕는 올인원 플랫폼입니다.
                </p>
                <div class="d-flex flex-column flex-sm-row justify-content-center gap-3">
 					<a href="/bughunters/matchingQuiz" class="btn-secondary-brown-custom me-sm-3 mb-2 mb-sm-0 fw-bold shadow">운명의 동물 퀴즈</a>
                	<a href="/bughunters/matchingQuiz/result_after" class="btn-secondary-brown-custom fw-bold shadow">운명의 동물 보기</a>
                </div>
            </div>
        </div>
    </section>

    <!-- 사이트 기능 설명 섹션 -->
    <section class="py-5 px-3">
        <div class="container text-center">
            <h2 class="display-5 fw-bold mb-4 text-brown-custom fade-in">우리의 특별한 서비스</h2>
            <p class="lead mb-5 text-muted fade-in">입양 → 양육 → 교류 → 정보 공유까지, 한 곳에서 해결하세요.</p>
            <div class="row g-4">
                <!-- 기능 카드 1: 운명의 동물 퀴즈 -->
                <div class="col-md-4">
                    <div class="card h-100 border-0 rounded-4 shadow-sm p-4 card-shadow-hover scale-in">
                        <div class="fs-1 mb-3 text-brown-custom card-emoji">🐾</div>
                        <h3 class="fs-4 fw-bold mb-2">유기동물 둘러보기</h3>
                        <p class="text-muted">새로운 가족을 기다리는 <br /> 사랑스러운 동물들을 만나보세요.</p>
                        <a href="<c:url value='/abandonedpet?page=1'/>" class="mt-auto d-block text-brown-custom fw-medium text-decoration-none">자세히보기 &rarr;</a>
                    </div>
                </div>
                <!-- 기능 카드 2: 산책 메이트 -->
                <div class="col-md-4">
                    <div class="card h-100 border-0 rounded-4 shadow-sm p-4 card-shadow-hover scale-in">
                        <div class="fs-1 mb-3 text-brown-custom card-emoji">🚶‍♀️</div>
                        <h3 class="fs-4 fw-bold mb-2">산책 메이트 찾기</h3>
                        <p class="text-muted">우리 동네의 다른 보호자들과 함께 <br/> 즐거운 산책 시간을 만들어보세요.</p>
                        <a href="<c:url value='/pet'/>" class="mt-auto d-block text-brown-custom fw-medium text-decoration-none">자세히보기 &rarr;</a>
                    </div>
                </div>
                <!-- 기능 카드 3: 커뮤니티 -->
                <div class="col-md-4">
                    <div class="card h-100 border-0 rounded-4 shadow-sm p-4 card-shadow-hover scale-in">
                        <div class="fs-1 mb-3 text-brown-custom card-emoji">🗣️</div>
                        <h3 class="fs-4 fw-bold mb-2">다양한 커뮤니티</h3>
                        <p class="text-muted">육아 팁, 자랑, 실종 신고 등 다양한 주제의 <br/> 커뮤니티에서 정보를 공유하고 소통하세요.</p>
                        <a href="<c:url value='/community'/>" class="mt-auto d-block text-brown-custom fw-medium text-decoration-none">자세히보기 &rarr;</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- '우리의 약속' 섹션 -->
    <section class="bg-white py-5 px-3">
        <div class="container text-center">
            <h2 class="display-5 fw-bold mb-4 text-brown-custom fade-in">우리의 약속</h2>
            <p class="lead mb-5 text-muted fade-in">우리는 파양 없는 행복한 반려생활을 위해 노력합니다.</p>
            <div class="row g-4 align-items-center">
                <div class="col-md-6 order-md-1">
                    <img src="/bughunters/resources/image/img_appoint1.jpg" class="img-fluid rounded-3 shadow-sm fade-in" alt="강아지와 함께하는 사람">
                </div>
                <div class="col-md-6 order-md-2 text-md-start fade-in">
                    <h3 class="fs-4 fw-bold mb-3">함께하는 삶을 위한 동반자</h3>
                    <p class="text-muted">‘운명의 발바닥’은 단순한 입양 중개를 넘어, 입양 이후의 모든 과정을 함께하는 동반자가 되고자 합니다. 파양 없는 세상을 만들기 위해, 반려인과 강아지 모두가 만족할 수 있는 지속 가능한 관계를 맺도록 돕습니다.</p>
                </div>
            </div>
            <div class="row g-4 align-items-center mt-5">
                <div class="col-md-6 order-md-2">
                    <img src="/bughunters/resources/image/img_appoint2.jpg" class="img-fluid rounded-3 shadow-sm fade-in" alt="편안히 누워있는 강아지">
                </div>
                <div class="col-md-6 order-md-1 text-md-end fade-in">
                    <h3 class="fs-4 fw-bold mb-3">모든 강아지의 행복을 위해</h3>
                    <p class="text-muted">모든 유기동물은 두 번째 기회를 가질 자격이 있습니다. 우리는 이 아이들이 새로운 가족의 품에서 안전하고 행복한 삶을 살 수 있도록 최선을 다하고 있습니다.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- 사용자 후기 섹션 -->
    <section class="py-5 px-3">
        <div class="container text-center">
            <h2 class="display-5 fw-bold mb-4 text-brown-custom fade-in">따뜻한 이야기들</h2>
            <p class="lead mb-5 text-muted fade-in">운명의 발바닥을 통해 새로운 가족을 만난 반려인들의 이야기</p>
            <div class="row g-4">
                <!-- 후기 카드 1 -->
                <div class="col-md-4">
                    <div class="card h-100 border-0 rounded-4 shadow-sm p-4 review-card scale-in">
                        <p class="card-text">"운명의 발바닥 덕분에 제 평생의 동반자인 '초코'를 만났습니다. 퀴즈가 제 성향을 정확히 파악해서 놀랐어요. 지금은 둘도 없는 가족입니다!"</p>
                        <div class="mt-auto pt-3 text-end">
                            <small class="text-muted">- 김민지님, 초코 보호자</small>
                        </div>
                    </div>
                </div>
                <!-- 후기 카드 2 -->
                <div class="col-md-4">
                    <div class="card h-100 border-0 rounded-4 shadow-sm p-4 review-card scale-in" style="transition-delay: 0.1s;">
                        <p class="card-text">"커뮤니티에서 많은 도움을 받았습니다. 강아지 훈련 팁부터 병원 정보까지, 다른 반려인들과 소통하며 혼자가 아니라는 것을 느꼈어요."</p>
                        <div class="mt-auto pt-3 text-end">
                            <small class="text-muted">- 박서준님, 뽀삐 보호자</small>
                        </div>
                    </div>
                </div>
                <!-- 후기 카드 3 -->
                <div class="col-md-4">
                    <div class="card h-100 border-0 rounded-4 shadow-sm p-4 review-card scale-in" style="transition-delay: 0.2s;">
                        <p class="card-text">"산책 메이트 기능을 통해 저희 강아지가 새로운 친구들을 사귈 수 있게 되었어요. 덕분에 산책이 더 즐거워졌습니다!"</p>
                        <div class="mt-auto pt-3 text-end">
                            <small class="text-muted">- 이지은님, 콩이 보호자</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- 마지막 CTA 섹션 -->
    <section class="bg-brown-custom text-white text-center py-5 px-3 mt-5">
        <div class="container fade-in">
            <h2 class="display-5 fw-bold mb-3">"지금 바로 운명의 발바닥과 함께하세요!"</h2>
            <div class="d-flex flex-column flex-sm-row justify-content-center gap-3">
 					<a href="/bughunters/auth/signup" class="btn-secondary-brown-custom me-sm-3 mb-2 mb-sm-0 fw-bold shadow">회원가입</a>
            </div>
        </div>
    </section>

	<!-- footer 영역 -->
	<%@ include file="/WEB-INF/views/component/footer.jsp"%>

	<!-- script 영역 -->
	<script src="/bughunters/resources/js/bootstrap.bundle.min.js"></script>

	<c:if test="${signedUp or openLogin}">
		<script>
			(function() {
				if (window.__loginModalOnce)
					return;
				window.__loginModalOnce = true;

				var msg = '<c:out value="${msg}" />';
				if (msg && msg.trim().length)
					alert(msg.trim());

				function openModal() {
					var el = document.getElementById('loginModal');
					if (el && window.bootstrap)
						new bootstrap.Modal(el).show();
				}
				if (document.readyState === 'loading') {
					document.addEventListener('DOMContentLoaded', openModal);
				} else {
					openModal();
				}
			})();
		</script>
	</c:if>
</body>
</html>
