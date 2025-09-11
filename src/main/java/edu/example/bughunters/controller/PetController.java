package edu.example.bughunters.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import edu.example.bughunters.domain.PetDTO;
import edu.example.bughunters.service.PetService;

@Controller
public class PetController {
	@Autowired
	PetService service;

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
	public String p4(
			@ModelAttribute PetDTO dto, 
			@RequestParam("profileImage") MultipartFile file,
			HttpSession session) {
		// 1. DTO에 userId를 설정
		Integer userId = (Integer) session.getAttribute("userId");
		
		if (userId == null) {
			System.out.println("반려동물 등록이 불가합니다.");
			return "redirect:/pet/signup";
		} else {
			dto.setUserId(userId);
		}
		
		// 2. Service에서 반려동물 등록
		boolean result = service.registerPet(dto, file);
		if (result)
			return "redirect:/mypage";
		else
			return "redirect:/pet/signup";
	}
	
	@RequestMapping(value = "/pet/myPet", produces = "application/json; charset=utf-8")
	@ResponseBody 
	public PetDTO p5(HttpSession session) {
		PetDTO dto = new PetDTO();
		Integer userId = (Integer) session.getAttribute("userId");
		if(userId == null) {
			System.out.println("로그인을 해주세요.");
			return dto;
		} else {
			dto.setUserId(userId);
			System.out.println(service.getPet(userId));
			return service.getPet(userId);
		}
	}
}
