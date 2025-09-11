<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Chiron+GoRound+TC:wght@200..900&display=swap" rel="stylesheet">
<style>
.round_font {
	font-family: "Chiron GoRound TC", sans-serif;
	font-optical-sizing: auto;
	font-weight: <weight>;
	font-style: normal;
}
</style>
<div class="card pet-card shadow-sm round_font">
	<img src="${param.profileImage}" class="card-img-top card-image"
		alt="${empty param.kind ? '사진 없음' : param.kind}" />

	<div class="card-body">
		<div class="d-flex-space">
			<h5 class="card-title fw-bold text-medium">
				<c:out value="${empty param.kind ? '품종 미상' : param.kind}" />
			</h5>
			<button type="button" class="card-like-btn"
				data-pet-id="${param.petId}"></button>
		</div>

		<p class="card-text text-muted text-small card-description">
			<c:out value="${param.description}" />
		</p>

		<ul class="card-list">
			<li class="card-item"><img
				src="/bughunters/resources/image/ico_size.png" class="card-icon" />
				<span><c:out value="${param.weight}" />kg</span></li>
			<li class="card-item"><img
				src="/bughunters/resources/image/ico_gender.png" class="card-icon" />
				<span><c:out value="${param.gender}" /></span></li>
			<li class="card-item"><img
				src="/bughunters/resources/image/ico_age.png" class="card-icon" />
				<span><c:out value="${param.age}" />년생</span></li>
			<li class="card-item"><img
				src="/bughunters/resources/image/ico_location.png" class="card-icon" />
				<span><c:out value="${param.address}" /></span></li>
		</ul>

		<a href="/bughunters/abandonedpet/${param.petId}"
			class="btn btn-gray d-block">자세히 보기</a>
	</div>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".card-description").forEach(el => {
    const t = el.textContent.trim();
    if (t.length > 22) el.textContent = t.substring(0, 22) + "…";
  });
});

async function renderHeartButton(button) {
    const id = button.dataset.petId;
    try {
        const res = await fetch(`/bughunters/abandonedpet/islike/\${id}`, {
            method: "GET"
        });
        const data = await res.json();

        if (data.isLike) {
            button.innerHTML = `<img src="/bughunters/resources/image/ico_fullheart.png" class="heart card-icon">`;
        } else {
            button.innerHTML = `<img src="/bughunters/resources/image/ico_mbti.png" class="card-icon">`;
        }
    } catch (error) {
        console.error('Failed to fetch like status:', error);
    }
}

document.addEventListener("DOMContentLoaded", () => {
	document.querySelectorAll(".card-like-btn").forEach(async(button) => { 
		await renderHeartButton(button);
		button.addEventListener("click", async (event) => {
			const petId = event.currentTarget.dataset.petId;
			const res = await fetch(`/bughunters/abandonedpet/like/\${petId}`, {
				method: "POST"
			});
            if (res.ok) {
                await renderHeartButton(button);
            } else {
                console.error('Failed to toggle like status.');
            }
		});
	});
});
</script>
