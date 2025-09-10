package edu.example.bughunters.controller;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import edu.example.bughunters.dao.PetDAO;
import edu.example.bughunters.domain.PetDTO;

@Controller
public class PetController {
	@Autowired
	PetDAO dao;

	@GetMapping("/pet")
	public String p1() {
		return "pet/petList";
	}

	@GetMapping("/mypage")
	public String p2() {
		return "user/myPage";
	}

	@GetMapping("/pet/signup")
	public String p3() {
		return "pet/petSignUp";
	}

	@PostMapping("/pet/register")
	public String p4(@ModelAttribute PetDTO dto, @RequestParam("profileImage") MultipartFile file) {

		System.out.println("컨트롤러 메서드 진입! DTO 이름: " + dto.getName());

		// 1. DTO에 userId를 설정
		dto.setUserId(1);

		byte[] fileBytes = null;
		if (!file.isEmpty()) {
			try {
				fileBytes = file.getBytes();
			} catch (IOException e) {
				e.printStackTrace();
				System.out.println("파일 변환 오류 발생.");
				// 오류 페이지로 리다이렉트
				return "redirect:/error";
			}
		}

		// 2. DAO에 DTO와 파일 바이트 배열을 함께 전달
		boolean result = dao.signUpPet(dto, fileBytes);

		if (result) {
			if (!file.isEmpty()) {
				try {
					String originalFilename = file.getOriginalFilename();
					// 저장할 디렉토리가 없으면 생성
					File saveDir = new File("C:/TEMP/");
					if (!saveDir.exists()) {
						saveDir.mkdirs();
					}

					// 파일명 중복을 피하기 위해 타임스탬프 추가
					String fileNameWithoutExt = originalFilename.substring(0, originalFilename.lastIndexOf("."));
					String fileExt = originalFilename.substring(originalFilename.lastIndexOf("."));
					String newFileName = fileNameWithoutExt + "_" + System.currentTimeMillis() + fileExt;

					File saveFile = new File(saveDir, newFileName);

					// 파일을 지정된 경로에 저장
					file.transferTo(saveFile);

					System.out.println("이미지가 C:\\TEMP 폴더에 성공적으로 저장되었습니다.");
				} catch (IOException e) {
					e.printStackTrace();
					System.out.println("로컬 파일 저장 중 오류 발생.");
				}
			}
		} else {
			System.out.println("DB 삽입 실패.");
		}

		return "redirect:/mypage";
	}
}
