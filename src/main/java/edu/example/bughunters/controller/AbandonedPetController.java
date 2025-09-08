package edu.example.bughunters.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import edu.example.bughunters.dao.AbandonedPetDAO;
import edu.example.bughunters.domain.AbandonedPetDTO;

@Controller
public class AbandonedPetController {
	@Autowired
	AbandonedPetDAO dao;

	@GetMapping("/abandonedPet")
	public String a1(Model model, @RequestParam(defaultValue = "1") int page) {
		int pageSize = 20;
		int totalItems = dao.countAll(); // 전체 데이터 개수
		int totalPages = (int) Math.ceil((double) totalItems / pageSize);
		int start = (page - 1) * pageSize + 1;
		int end = start + pageSize - 1;
		List<AbandonedPetDTO> list = dao.listAll(start, end);

		// 견종 
		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getKind().contains("빠삐용"))
				list.get(i).setKind("빠삐용");
		}
		
		// 성별 
		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getGender() != null) {
				if (list.get(i).getGender().equals("M"))
					list.get(i).setGender("수컷");
				else
					list.get(i).setGender("암컷");
			}
		}
		
		// 위치
		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getAddress() != null) {
				if (list.get(i).getAddress().contains("전북")) {
					list.get(i).setAddress("전라북도");
				}
			}
		}

		model.addAttribute("list", list);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);

		return "abandonedPet/abandonedPetList";
	}

	@GetMapping("/abandonedPet/{id}")
	public String a2(Model model, @PathVariable("id") int id) {
		AbandonedPetDTO dto = dao.listOne(id);
		
		if (dto.getGender() != null) {
			if (dto.getGender().equals("M"))
				dto.setGender("수컷");
			else
				dto.setGender("암컷");
		} 
		
		boolean isRabies = false;
		boolean isHealthy = false;
		if (dto.getVaccin() != null && !dto.getVaccin().equals("없음")) {	
			String[] strArr = dto.getVaccin().split(",");
			
			for (String s : strArr) {
				if (s.trim().equals("광견병"))
					isRabies = true;
				else if (s.trim().equals("종합백신") || s.trim().equals("호흡기") || s.trim().equals("코로나"))
					isHealthy = true;
			}
		}
		
		model.addAttribute("pet", dto);
		model.addAttribute("isRabies", isRabies);
		model.addAttribute("isHealthy", isHealthy);
		
		return "abandonedPet/abandonedPetDetail";
	}
	
	@GetMapping("/abandonedPet/search")
	public String a3(
			Model model, 
			@RequestParam(defaultValue = "all") String location,
			@RequestParam(defaultValue = "all") String gender,
			@RequestParam(defaultValue = "all") String size,
			@RequestParam(defaultValue = "all") String age) {
		List<AbandonedPetDTO> list = dao.searchList(location, gender, size, age);

		// 견종 
		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getKind().contains("빠삐용"))
				list.get(i).setKind("빠삐용");
		}
		
		// 성별 
		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getGender() != null) {
				if (list.get(i).getGender().equals("M"))
					list.get(i).setGender("수컷");
				else
					list.get(i).setGender("암컷");
			}
		}
		
		// 위치
		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getAddress() != null) {
				if (list.get(i).getAddress().contains("전북")) {
					list.get(i).setAddress("전라북도");
				}
			}
		}

		model.addAttribute("list", list);	
		
		return "abandonedPet/abandonedPetList";
	}
}
