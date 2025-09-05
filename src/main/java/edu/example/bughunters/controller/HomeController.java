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
}
