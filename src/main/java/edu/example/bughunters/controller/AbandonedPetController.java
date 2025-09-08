package edu.example.bughunters.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import edu.example.bughunters.domain.AbandonedPetDTO;
import edu.example.bughunters.service.AbandonedPetService;

@Controller
public class AbandonedPetController {
	@Autowired
	AbandonedPetService service;

	// 유기동물 전체 리스트
	@GetMapping("/abandonedPet")
	public String a1(Model model, @RequestParam(defaultValue = "1") int page) {
		List<AbandonedPetDTO> list = service.getPagedList(page);
		int totalPages = service.getTotalPages();
		
		model.addAttribute("list", list);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);

		return "abandonedPet/abandonedPetList";
	}

	// 유기동물 상세 정보
	@GetMapping("/abandonedPet/{id}")
	public String a2(Model model, @PathVariable("id") int id) {
		AbandonedPetDTO dto = service.getAbandonedPetById(id);
		Map<String, Boolean> vaccinStatus = service.getVaccinationStatus(dto);
		
		model.addAttribute("pet", dto);
		model.addAttribute("isRabies", vaccinStatus.get("isRabies"));
		model.addAttribute("isHealthy", vaccinStatus.get("isHealthy"));
		
		return "abandonedPet/abandonedPetDetail";
	}
	
	// 유기동물 검색 리스트
	@GetMapping("/abandonedPet/search")
	public String a3(
			Model model, 
			@RequestParam(defaultValue = "all") String location,
			@RequestParam(defaultValue = "all") String gender,
			@RequestParam(defaultValue = "all") String size,
			@RequestParam(defaultValue = "all") String age,
			@RequestParam(defaultValue = "1") int page) {
		List<AbandonedPetDTO> list = service.getPagedSearchList(location, gender, size, age, page);
		int totalPages = service.getTotalSearchPages(location, gender, size, age);
		
		model.addAttribute("list", list);
		model.addAttribute("searchCurrentPage", page);
		model.addAttribute("searchTotalPages", totalPages);
		
		return "abandonedPet/abandonedPetList";
	}
}
