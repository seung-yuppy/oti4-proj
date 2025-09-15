package edu.example.bughunters.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import edu.example.bughunters.domain.PetDTO;
import edu.example.bughunters.domain.PetVO;
import edu.example.bughunters.domain.WalkingDTO;
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
	
	@GetMapping(value = "/pet/mypet", produces = "application/json; charset=utf-8")
	@ResponseBody 
	public PetVO p5(HttpSession session) {
		PetVO vo = new PetVO();
		Integer userId = (Integer) session.getAttribute("userId");
		if(userId == null) {
			return vo;
		} else {
			vo.setUserId(userId);
			return service.getPet(userId);
		}
	}
	
	// 반려동물 산책 게시판에 등록하기
	@PostMapping(value = "/pet/walking/register", produces = "application/json; charset=utf-8")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> p6(@RequestBody WalkingDTO dto) {
		boolean result = service.registerWalking(dto.getPetId(), dto.getLocation());
		Map<String, Object> response = new HashMap<>();
		if (result) 
			response.put("msg", "산책 게시판에 등록하였습니다.");
		else 
			response.put("msg", "산책 게시판 등록에 실패하였습니다.");
		
		return ResponseEntity.ok(response);
	}
	
	// 산책 게시판 반려동물 리스트 보여주기
	@GetMapping(value = "/pet/walking/list", produces = "application/json; charset=utf-8")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> p7() {
		Map<String, Object> response = new HashMap<>();
		response.put("data", service.walkingList());
		return ResponseEntity.ok(response);
	}
}
