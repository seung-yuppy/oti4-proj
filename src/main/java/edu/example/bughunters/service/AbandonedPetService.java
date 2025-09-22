package edu.example.bughunters.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import edu.example.bughunters.dao.AbandonedPetDAO;
import edu.example.bughunters.domain.AbandonedPetDTO;
import edu.example.bughunters.domain.PetWeightDTO;

@Service
public class AbandonedPetService {
	@Autowired
	AbandonedPetDAO dao;

	// abandonedPet card에서 데이터 보여주기
	public void processAbandonedPetData(AbandonedPetDTO dto) {
		// 견종
		if (dto.getKind() != null && dto.getKind().contains("빠삐용"))
			dto.setKind("빠삐용");

		// 성별
		if (dto.getGender() != null) {
			if (dto.getGender().equals("M"))
				dto.setGender("수컷");
			else
				dto.setGender("암컷");
		}

		// 위치
		if (dto.getAddress() != null && dto.getAddress().contains("전북"))
			dto.setAddress("전라북도");
	}
	
	//목록 데이터를 가공
	public List<AbandonedPetDTO> processAbandonedPetList(List<AbandonedPetDTO> list) {
		if (list != null) {
			for (AbandonedPetDTO dto : list)
				processAbandonedPetData(dto);
		}
		return list;
	}
	
    // 페이징 처리된 목록을 가져오는 메서드
    public List<AbandonedPetDTO> getPagedList(int page) {
        int pageSize = 12;
        int start = (page - 1) * pageSize + 1;
        int end = start + pageSize - 1;
        List<AbandonedPetDTO> list = dao.listAll(start, end);
        return processAbandonedPetList(list); // 가공 로직을 호출해서 처리된 리스트를 반환
    }

    // 총 페이지 수를 계산하는 메서드
    public int getTotalPages() {
        int pageSize = 12;
        int totalItems = dao.countAll();
        return (int) Math.ceil((double) totalItems / pageSize);
    }
    
    // 특정 펫의 상세 정보를 가져오는 메서드
    public AbandonedPetDTO getAbandonedPetById(int id) {
        AbandonedPetDTO dto = dao.listOne(id);
        
        if (dto != null) 
            processAbandonedPetData(dto); // 상세 정보도 가공 로직 적용
    
        return dto;
    }
    
    // Abandoned Pet의 상세정보
    public PetWeightDTO getDetail(int id) {
    	PetWeightDTO dto = dao.detailAbandonedPet(id);
    	return dto;
    }
    
    // 백신 상태를 판단하는 로직을 분리
    public Map<String, Boolean> getVaccinationStatus(AbandonedPetDTO dto) {
        boolean isRabies = false;
        boolean isHealthy = false;
        if (dto.getVaccin() != null && !dto.getVaccin().equals("없음")) {
            String[] strArr = dto.getVaccin().split(",");
            for (String s : strArr) {
                String trimmedStr = s.trim();
                if (trimmedStr.equals("광견병")) 
                    isRabies = true;
                else if (trimmedStr.equals("종합백신") || trimmedStr.equals("호흡기") || trimmedStr.equals("코로나"))
                    isHealthy = true;
            }
        }
        Map<String, Boolean> vaccinStatus = new HashMap<>();
        vaccinStatus.put("isRabies", isRabies);
        vaccinStatus.put("isHealthy", isHealthy);
        return vaccinStatus;
    }
    
    // 검색 결과의 총 페이지 수를 계산하는 메서드
    public int getTotalSearchPages(String location, String gender, String size, String age) {
        int pageSize = 12;
        int totalItems = dao.countSearch(location, gender, size, age);
        return (int) Math.ceil((double) totalItems / pageSize);
    }
    
    // 페이징 처리된 검색 결과를 가져오는 메서드
    public List<AbandonedPetDTO> getPagedSearchList(String location, String gender, String size, String age, int page) {
        int pageSize = 12;
        int start = (page - 1) * pageSize + 1;
        int end = start + pageSize - 1;
        List<AbandonedPetDTO> list = dao.listSearch(location, gender, size, age, start, end);
        return processAbandonedPetList(list);
    }
    
    // 버튼 누르면 좋아요 -> 좋아요 취소 / 좋아요 취소 -> 좋아요
    public Map<String, Object> toggleLike(int userId, int abandonedPetId) {
        Map<String, Object> response = new HashMap<>();
        boolean isCurrentlyLiked = dao.isLikePet(userId, abandonedPetId) > 0;

        if (isCurrentlyLiked) {
            boolean result = dao.likeCancel(userId, abandonedPetId);
            response.put("isLiked", !result);
        } else {
            boolean result = dao.likePet(userId, abandonedPetId);
            response.put("isLiked", result);
        }
        return response;
    }
    
    // 유기동물 좋아요 체크
    public boolean isLikePet(int userId, int abandonedPetId) {
    	int result = dao.isLikePet(userId, abandonedPetId);
    	if (result == 0)
    		return false;
    	else
    		return true;
    }
    
    // 유기동물 리스트
    public Map<String, Object> likePetList(int userId) {
    	Map<String, Object> response = new HashMap<>();
    	List<AbandonedPetDTO> likeList = dao.likeList(userId);
    	if (likeList.isEmpty()) 
    		response.put("msg", "좋아하는 유기동물이 없습니다.");
    	else {
			for (AbandonedPetDTO dto : likeList)
				processAbandonedPetData(dto);
			response.put("data", likeList);
    	}
    	return response;
    }
}
