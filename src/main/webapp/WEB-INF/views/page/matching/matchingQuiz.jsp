<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>운명의 발바닥 테스트</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
<%@ include file="../../component/header.jsp" %>
	<div class="container my-5">
		<h5 class="text-end">
			문제 <span id="currentIndex">1</span>/9
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
  const questions = [
    {
      question: "처음 간 친구 집에서 강아지가 다가온다. 당신은?",
      options: [
        { text: "조심스럽게 손을 내밀고 먼저 냄새를 맡게 해준다.", value: "i" },
        { text: "바로 '귀여워!' 하며 쓰다듬고 놀아준다.", value: "e" }
      ],
      type: "mbti"
    },
    {
      question: "오랜만에 준비한 데이트가 갑자기 취소됐다. 당신은?",
      options: [
        { text: "기껏 준비했는데... 허탈하고 괜히 짜증이 난다.", value: "j" },
        { text: "오히려 잘 됐다! 미뤄뒀던 할 일을 정리해본다.", value: "p" }
      ],
      type: "mbti"
    },
    {
      question: "감정 표현이 서툰 친구가 “고마워” 한 마디를 했을 때, 당신은?",
      options: [
        { text: "속마음은 알겠지만 표현이 부족해 섭섭하다.", value: "t" },
        { text: "그 한 마디에 오히려 더 큰 감동을 느낀다.", value: "f" }
      ],
      type: "mbti"
    },
    {
      question: "꿈속에서 당신은?",
      options: [
        { text: "드래곤을 타고 하늘을 날며 싸운다.", value: "n" },
        { text: "실제 가고 싶은 여행지에서 평화롭게 걷고 있다", value: "s" }
      ],
      type: "mbti"
    },
    {
      question: "친구가 갑자기 놀러 온다! 그런데 집은 난장판. 당신은?",
      options: [
        { text: "청소? 그냥 논 다음 한꺼번에 치우지 뭐~", value: "free" },
        { text: "얼른 치우고 향초라도 피워놓는다.", value: "organized" }
      ],
      type: "kind"
    },
    {
        question: "라면을 끓일 때 가장 먼저 생각나는 건?",
        options: [
          { text: "면발의 익힘 정도", value: "age" },
          { text: "스프를 넣는 순서", value: "kind" },
          { text: "계란을 넣을지 말지 고민", value: "age" },
          { text: "먹고 난 후 설거지", value: "kind" }
        ],
        type: "kind"
      },
      {
          question: "당신은 택배를 받았는데 보낸 사람 이름도, 내용도 없다. 어떻게 할까?",
          options: [
            { text: "바로 열어본다.", value: "free" },
            { text: "인터넷으로 송장번호를 조회해본다.", value: "organized" },
            { text: "경비실에 맡긴다.", value: "free" },
            { text: "경찰에 신고한다.", value: "organized" }
          ],
          type: "kind"
        },
        {
            question: "당신이 키우고 싶은 반려동물의 이미지에 가까운 것은?",
            options: [
              { text: "귀엽고 가벼워서 안고 잘 수 있는 친구", value: "free" },
              { text: "묵직하고 듬직한 존재감 있는 친구", value: "organized" }
            ],
            type: "kind"
          },
          {
              question: "당신의 인스타 피드 분위기는 어떤가요?",
              options: [
                { text: "밝고 따뜻한 톤의 일상 사진이 많다", value: "free" },
                { text: "강렬하고 개성 있는 색감이 눈에 띈다.", value: "organized" }
              ],
              type: "kind"
            }
  ];

  let current = 0;
  const answers = [];

  function renderQuestion() {
	  const q = questions[current];
	  const questionIndex = current;  
	  document.getElementById("questionText").textContent = q.question;

	  const optionsContainer = document.getElementById("optionsContainer");
	  optionsContainer.innerHTML = "";
	  document.getElementById("nextBtn").disabled = true;

	  q.options.forEach((opt, index) => {
	    const div = document.createElement("div");
	    div.className = "option";
	    div.textContent = opt.text;

	    //이전에 선택한 값이면 표시
	    if (answers[questionIndex] && answers[questionIndex].value === opt.value) {
	      div.classList.add("selected");
	      document.getElementById("nextBtn").disabled = false;
	    }

	    div.onclick = () => {
	      document.querySelectorAll(".option").forEach(o => o.classList.remove("selected"));
	      div.classList.add("selected");
	      answers[current] = { type: q.type, value: opt.value };
	      document.getElementById("nextBtn").disabled = false;
	    };

	    optionsContainer.appendChild(div);
	  });

	  // 진행 바 업데이트
	  const progress = Math.round(((current + 1) / questions.length) * 100);
	  document.getElementById("progressBar").style.width = progress + "%";
	  document.getElementById("progressBar").setAttribute("aria-valuenow", progress);
	  
	  console.log("Progress bar width44:", progress);
	  console.log("Progress bar width:", `${progress}%`);


	  // 현재 인덱스 및 버튼 상태 업데이트
	  document.getElementById("currentIndex").textContent = current + 1;
	  document.getElementById("prevBtn").disabled = current === 0;
  
	  
	  const nextBtn = document.getElementById("nextBtn");
	  if (current === questions.length - 1) {
	    nextBtn.textContent = "제출";
	  } else {
	    nextBtn.textContent = "다음";
	  }
	}
  

  function nextQuestion() {
    if (current < questions.length - 1) {
      current++;
      renderQuestion();
    } else {
      // 최종 결과 전송
      const form = document.createElement("form");
      form.method = "POST";
      form.action = "/miniproj/page/matching/matchingResult.jsp"; 

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
<%@ include file="../../component/footer.jsp" %>
<script src="/miniproj/resource/js/bootstrap.bundle.min.js"></script>
</body>
</html>
