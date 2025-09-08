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

	@GetMapping("/abandonedPetList")
	public String a1(Model model, @RequestParam(defaultValue = "1") int page) {
		int pageSize = 12;
		int totalItems = dao.countAll(); // 전체 데이터 개수
		int totalPages = (int) Math.ceil((double) totalItems / pageSize);
		int start = (page - 1) * pageSize + 1;
		int end = start + pageSize - 1;
		List<AbandonedPetDTO> list = dao.listAll(start, end);

		for (int i = 0; i < list.size(); i++) {
			if (list.get(i).getGender() != null) {
				if (list.get(i).getGender().equals("M"))
					list.get(i).setGender("수컷");
				else
					list.get(i).setGender("암컷");
			}
		}

		model.addAttribute("list", list);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPages", totalPages);

		return "abandonedPet/abandonedPetList";
	}

	@GetMapping("/abandonedPetDetail/{id}")
	public String a2(Model model, @PathVariable("id") int id) {
		AbandonedPetDTO dto = dao.listOne(id);
		
		if (dto != null) {
			if (dto.getGender().equals("M"))
				dto.setGender("수컷");
			else
				dto.setGender("암컷");
		}
		
		model.addAttribute("pet", dto);
		return "abandonedPet/abandonedPetDetail";
	}

}
