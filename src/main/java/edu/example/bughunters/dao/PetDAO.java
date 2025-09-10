package edu.example.bughunters.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import edu.example.bughunters.domain.PetDTO;

@Mapper
public interface PetDAO {
	
	// 반려동물 등록
	public boolean signUpPet(@Param("pet") PetDTO dto, @Param("image") byte[] imageBytes);
}
