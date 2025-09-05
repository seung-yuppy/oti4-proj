<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>새로운 반려동물 등록</title>
	<link href="/miniproj/resource/css/common.css" rel="stylesheet">
	<link href="/miniproj/resource/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #fdfaf6;
        }
        .form-container {
        		margin: 20px auto;
        		width: 700px !important;
        }
        .card {
            border: 1px solid #e0d8ce;
            border-radius: 0.75rem;
        }
        .card-body {
            background-color: #fff9f5;
        }
        .section-icon {
            color: #8B4513;
            font-size: 1.5rem;
        }
        .btn-custom-brown {
            background-color: #8B4513;
            border-color: #8B4513;
            color: white;
        }
        .btn-custom-brown:hover {
            background-color: #A0522D;
            border-color: #A0522D;
            color: white;
        }
        .form-check-input:checked {
            background-color: #8B4513;
            border-color: #8B4513;
        }
        .file-upload-wrapper {
            border: 2px dashed #a75d00;
            border-radius: 0.5rem;
            padding: 2rem;
            text-align: center;
            background-color: #f8f5f1;
            cursor: pointer;
        }
        .file-upload-wrapper:hover {
            background-color: #f1e9e0;
        }
        .file-upload-wrapper .upload-icon {
            font-size: 3rem;
            color: #b0a191;
        }
        .file-upload-wrapper p {
            color: #8a7a6a;
        }
    </style>
</head>
<body>
	<!-- 헤더 영역 -->
	<%@ include file="/WEB-INF/views/component/header.jsp" %> 
    <div class="form-container">
        <h2 class="text-center mb-5 fw-bold text-brown">새로운 반려동물 등록</h2>
        <form action="#" method="post">
            <div class="card shadow-sm mb-4">
            
                <div class="card-body p-4">
                    <div class="d-flex align-items-center mb-3 text-brown">
                        <h5 class="card-title mb-0 fw-bold">반려동물 정보</h5>
                    </div>
                    <p class="card-subtitle mb-4 text-muted">반려동물의 기본 정보를 입력해주세요.</p>
                    
                    <div class="mb-3">
                        <label for="petName" class="form-label">반려동물 이름</label>
                        <input type="text" class="form-control" id="petName" name="petName" placeholder="반려동물의 이름을 입력하세요" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">종류</label>
                        <div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="species" id="speciesDog" value="dog">
                                <label class="form-check-label" for="speciesDog">강아지</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="species" id="speciesCat" value="cat">
                                <label class="form-check-label" for="speciesCat">고양이</label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="petBreedSelect" class="form-label">품종</label>
                        <select class="form-select" id="petBreedSelect" name="petBreedSelect">
                            <option selected>품종을 선택하세요</option>
                            <option value="리트리버">리트리버</option>
                            <option value="푸들">푸들</option>
                            <option value="말티즈">말티즈</option>
                            <option value="시츄">시츄</option>
                            <option value="other">직접 입력</option>
                        </select>
                    </div>

                    <div class="mb-3 d-none" id="customBreedWrapper">
                        <label for="customPetBreed" class="form-label">사용자 지정 품종</label>
                        <input type="text" class="form-control" id="customPetBreed" name="customPetBreed" placeholder="없는 품종인 경우 직접 입력하세요">
                    </div>

                    <div class="mb-3">
                        <label for="petColor" class="form-label">털 색상</label>
                        <select class="form-select" id="petColor" name="petColor">
                            <option selected>털 색상을 선택하세요</option>
                            <option value="흰색">흰색</option>
                            <option value="갈색">갈색</option>
                            <option value="검은색">검은색</option>
                            <option value="믹스색">믹스색</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">성별</label>
                        <div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" id="genderMale" value="male">
                                <label class="form-check-label" for="genderMale">수컷</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="gender" id="genderFemale" value="female">
                                <label class="form-check-label" for="genderFemale">암컷</label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="petWeight" class="form-label">체중 (kg)</label>
                        <input type="number" class="form-control" id="petWeight" name="petWeight" placeholder="예: 5.2" step="0.1" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="petWeight" class="form-label">자기 소개</label>
                        <input type="text" class="form-control" id="petIntro" name="petIntro" placeholder="동물을 한 줄로 소개해주세요." required>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <div class="d-flex align-items-center mb-3">
                        <h5 class="card-title mb-0 fw-bold text-brown">반려동물 사진</h5>
                    </div>
                    <p class="card-subtitle mb-4 text-muted">반려동물의 귀여운 사진을 업로드해주세요.</p>
					
					<input type="file" id="fileInput" name="petPhoto" accept="image/*" class="d-none">

					<div id="dropbox" class="file-upload-wrapper">
						<div id="initial-message">
							<p class="mt-2 mb-0">사진 파일을 끌어다 놓거나 아래 버튼을 클릭하여 업로드하세요</p>
						</div>
					</div>

					<div class="d-grid mt-3">
						<button type="button" id="fileSelectBtn" class="btn btn-secondary-brown">
							사진 선택
						</button>
					</div>
                </div>
            </div>

            <div class="d-flex justify-content-end mt-4">
                <button type="button" class="btn btn-secondary-brown me-2">취소</button>
                <button type="submit" class="btn btn-brown">반려동물 등록</button>
            </div>
        </form>
    </div>

  	<!-- footer 영역 -->
	<%@ include file="/WEB-INF/views/component/footer.jsp" %>
	
	<!-- script 영역 -->
	<script src="/miniproj/resource/js/bootstrap.bundle.min.js"></script>
    <script>
    		// 견종 사용자 지정 시 input text 보여주기
	    document.querySelector('#petBreedSelect').addEventListener('change', function() {
	        var customBreedWrapper = document.getElementById('customBreedWrapper');
	        // 'other' 옵션을 선택하면 d-none 클래스를 제거하여 보이게 하고, 아니면 다시 추가하여 숨김
	        if (this.value === 'other') {
	            customBreedWrapper.classList.remove('d-none');
	        } else {
	            customBreedWrapper.classList.add('d-none');
	        }
	    });
    
    		// drag & drop 파일 영역
	    const dropbox = document.querySelector('#dropbox');
		const fileInput = document.querySelector('#fileInput');
		const fileSelectBtn = document.querySelector('#fileSelectBtn');
	
		// '사진 선택' 버튼 클릭 시 숨겨진 file input 클릭
		fileSelectBtn.addEventListener('click', () => {
			fileInput.click();
		});
	
		// file input에 파일이 선택되었을 때(파일 탐색기)
		fileInput.addEventListener('change', (e) => {
			const files = e.target.files;
			if (files.length > 0) {
				handleFiles(files);
			}
		});
	
		// 드래그 이벤트 처리
		dropbox.addEventListener('dragover', (e) => {
			e.preventDefault(); // 필수: preventDefault가 없으면 drop 이벤트가 발생하지 않음
			dropbox.style.borderColor = '#8B4513'; // 드래그 중일 때 테두리 색 변경
		});
	
		dropbox.addEventListener('dragleave', (e) => {
			e.preventDefault();
			dropbox.style.borderColor = '#a75d00'; // 드래그가 영역을 벗어날 때 원래 색으로 복원
		});
		
		dropbox.addEventListener('drop', (e) => {
			e.preventDefault();
			dropbox.style.borderColor = '#a75d00'; // 드롭 후 원래 색으로 복원
	
			const files = e.dataTransfer.files;
			if (files.length > 0) {
				fileInput.files = files; // 중요: 드롭된 파일을 file input의 파일 목록으로 설정
				handleFiles(files);
			}
		});
		
		// 파일 처리 및 미리보기 생성 함수
		function handleFiles(files) {
			// 여러 파일이 드롭되더라도 첫 번째 파일만 처리
			const file = files[0];
	
			// 파일이 이미지인지 확인
			if (!file.type.startsWith('image/')) {
				alert('이미지 파일만 업로드할 수 있습니다.');
				return;
			}
			
			// 기존 메시지 삭제
			dropbox.innerHTML = '';
			
			const reader = new FileReader();
			
			// 파일 읽기가 완료되면 실행될 콜백 함수
			reader.onload = function(e) {
				const preview = document.createElement('img');
				preview.src = e.target.result;
				preview.style.maxWidth = '100%';
				preview.style.maxHeight = '250px'; // 미리보기 이미지 최대 높이 지정
				preview.style.objectFit = 'contain';
				
				dropbox.appendChild(preview);
			}
			
			// 파일 읽기 시작
			reader.readAsDataURL(file);
		}
    </script>
</body>
</html>