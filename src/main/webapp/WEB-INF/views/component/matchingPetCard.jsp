<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

</style>
<div class="card pet-card shadow-sm">
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

</script>
