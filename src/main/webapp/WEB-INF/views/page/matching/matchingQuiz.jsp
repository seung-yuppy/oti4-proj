<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>운명의 발바닥 테스트</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="/miniproj/resource/css/common.css" rel="stylesheet">
<link href="/miniproj/resource/css/bootstrap.min.css" rel="stylesheet">
<style>
.option {
	border: 1px solid #ccc;
	padding: 15px;
	border-radius: 8px;
	margin-bottom: 10px;
	cursor: pointer;
}

.option:hover {
	background-color: #f2f2f2;
}

.option.selected {
	background-color: #a75d00;
	border-color: #6a5acd;
	color: white;
}

.progress-bar {
	background-color: #c68c53 !important;
	height: 30px;
	transition: width 0.4s ease-in-out;
}
</style>
</head>
<body>
	<%@ include file="../../component/header.jsp"%>
	<div class="container my-5">
		<h5 class="text-end">
			문제 <span id="currentIndex">1</span>/5
		</h5>

		<!-- 진행 바 -->
		<div class="progress mb-4">
			<div class="progress-bar" id="progressBar" role="progressbar"
				style="width: 0%;" aria-valuenow="0" aria-valuemin="0"
				aria-valuemax="100"></div>
		</div>

		<!-- 질문 -->
		<div class="card">
			<div class="card-body">
				<h5 class="card-title" id="questionText">질문을 불러오는 중...</h5>
				<div id="optionsContainer"></div>
			</div>
		</div>

		<!-- 버튼 -->
		<div class="mt-4 d-flex justify-content-between">
			<button class="btn btn-secondary-brown" onclick="prevQuestion()"
				id="prevBtn" disabled>이전</button>
			<button class="btn btn-brown" onclick="nextQuestion()" id="nextBtn"
				disabled>다음</button>
		</div>
	</div>

	<script>
  const questions = ${questionsJson};

  let current = 0;
  const answers = []; // { type: quizCategory, value: answerWeight } 형태로 저장

  function renderQuestion() {
    if (!questions || questions.length === 0) {
      document.getElementById("questionText").textContent = "문항이 없습니다.";
      document.getElementById("nextBtn").disabled = true;
      document.getElementById("prevBtn").disabled = true;
      return;
    }

    const q = questions[current]; // MatchingQuizDTO
    document.getElementById("questionText").textContent = q.quizQuestion;

    const optionsContainer = document.getElementById("optionsContainer");
    optionsContainer.innerHTML = "";
    document.getElementById("nextBtn").disabled = true;

    (q.answers || []).forEach((ans) => {
      const div = document.createElement("div");
      div.className = "option";
      div.textContent = ans.quizAnswer;

      // 이전 선택 복원
      if (answers[current] && answers[current].value === ans.answerWeight) {
        div.classList.add("selected");
        document.getElementById("nextBtn").disabled = false;
      }

      div.onclick = () => {
        document.querySelectorAll(".option").forEach(o => o.classList.remove("selected"));
        div.classList.add("selected");
        // type: 카테고리, value: 가중치(또는 태그)
        answers[current] = { type: q.quizCategory, value: ans.answerWeight };
        document.getElementById("nextBtn").disabled = false;
      };

      optionsContainer.appendChild(div);
    });

    // 진행 바 & 버튼 상태
    const progress = Math.round(((current + 1) / questions.length) * 100);
    const pb = document.getElementById("progressBar");
    pb.style.width = progress + "%";
    pb.setAttribute("aria-valuenow", progress);

    document.getElementById("currentIndex").textContent = current + 1;
    document.getElementById("prevBtn").disabled = current === 0;

    const nextBtn = document.getElementById("nextBtn");
    nextBtn.textContent = (current === questions.length - 1) ? "제출" : "다음";
  }

  function nextQuestion() {
    if (current < questions.length - 1) {
      current++;
      renderQuestion();
    } else {
      // 최종 제출
      const form = document.createElement("form");
      form.method = "POST";
      form.action = "/bughunters/matchingQuiz/result";

      const input = document.createElement("input");
      input.type = "hidden";
      input.name = "answers";
      input.value = JSON.stringify(answers);

      form.appendChild(input);
      document.body.appendChild(form);
      form.submit();
    }
  }

  function prevQuestion() {
    if (current > 0) {
      current--;
      renderQuestion();
    }
  }

  renderQuestion();
</script>


	<%@ include file="../../component/footer.jsp"%>
	<script src="/miniproj/resource/js/bootstrap.bundle.min.js"></script>
</body>
</html>
