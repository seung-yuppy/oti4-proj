package edu.example.bughunters.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import edu.example.bughunters.domain.PetDTO;
import edu.example.bughunters.domain.PetVO;

@Mapper
public interface PetDAO {
	
	// 반려동물 등록
	public boolean signUpPet(@Param("pet") PetDTO dto, @Param("image") byte[] imageBytes);
	
	// 내 반려동물 가져오기
	public PetVO getMyPet(@Param("userId") int userId);
}
