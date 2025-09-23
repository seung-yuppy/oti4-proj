package edu.example.bughunters.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import edu.example.bughunters.domain.PetDTO;
import edu.example.bughunters.domain.PetVO;
import edu.example.bughunters.domain.WalkingVO;

@Mapper
public interface PetDAO {
	
	// 반려동물 등록
	public boolean signUpPet(@Param("pet") PetDTO dto, @Param("image") byte[] imageBytes);
	
	// 내 반려동물 가져오기
	public PetVO getMyPet(@Param("userId") int userId);
	
	// 내 반려동물 산책 게시판 등록하기 
	public boolean registerWalking(@Param("petId") int petId, @Param("location") String location);
	
	// 산책 게시판 리스트 가져오기
	public List<WalkingVO> getWalkingList();
	
	// 산책 게시판 중복 등록 방지
	public int isRegisterWalking(@Param("petId") int petId);
	
	// 유저 테이블 isPet 바꾸기
	public boolean changeIsPet(@Param("userId") int userId);

	// 마이페이지에서 반려동물 존재여부 확인하기
	public int isUserPet(@Param("userId") int userId);

	public boolean updatingPet(@Param("pet") PetDTO dto, @Param("image") byte[] imageBytes);
	
	public PetVO selectPetById(@Param("petId") int petId);

	public boolean removeMyPet(int userId);

	public boolean updateUserPet(int userId);
}
