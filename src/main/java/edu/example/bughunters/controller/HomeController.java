package edu.example.bughunters.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
	
	@GetMapping("/home")
	public String home() {
		return "home";
	}
	
	@GetMapping("/matchingQuiz")
	public String matchingQuiz() {
		return "matching/matchingQuiz"; 
	}
	
	@GetMapping("/matchingResult")
	public String matchingResult() {
		return "matching/matchingResult_after";
	}
	
	@GetMapping("/communityMain")
	public String communityMain() {
		return "community/communityMain";
	}
	
	@GetMapping("/communityCreate")
	public String communityCreate() {
		return "community/communityCreate";
	}
	
	@GetMapping("/communityDetail")
	public String communityDetail() {
		return "community/communityDetail";
	}
	
	@GetMapping("/communityUpdate")
	public String communityUpdate() {
		return "community/communityUpdate";
	}
	
//	@GetMapping("/abandonedPetList")
//	public String abandonedPetList() {
//		return "abandonedPet/abandonedPetList";
//	}
	
//	@GetMapping("/abandonedPetDetail")
//	public String abandonedPetDetail() {
//		return "abandonedPet/abandonedPetDetail";
//	}
	
	@GetMapping("/signUp")
	public String signUp() {
		return "user/signUp";
	}
}
