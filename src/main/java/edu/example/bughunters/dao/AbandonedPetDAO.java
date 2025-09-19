package edu.example.bughunters.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import edu.example.bughunters.domain.AbandonedPetDTO;
import edu.example.bughunters.domain.PetWeightDTO;

@Mapper
public interface AbandonedPetDAO {
	// 유기동물 모든 리스트를 위한 페이징 유기동물 갯수
	public int countAll();
	
	// 유기동물 모든 리스트
	public List<AbandonedPetDTO> listAll(@Param("start") int start, @Param("end") int end);
	
	// 유기동물 아이디로 상세 페이지
	public AbandonedPetDTO listOne(int id);
	
	// 유기동물 검색 리스트를 위한 페이징 유기동물 갯수
	public int countSearch(
			@Param("location") String location,
			@Param("gender") String gender,
			@Param("size") String size,
			@Param("age") String age
			);
	
	// 유기동물 검색 리스트 
	public List<AbandonedPetDTO> listSearch(
			@Param("location") String location,
			@Param("gender") String gender,
			@Param("size") String size,
			@Param("age") String age,
			@Param("start") int start, 
			@Param("end") int end
			);
	
	// 유기동물 좋아요
	public boolean likePet(@Param("userId") int userId, @Param("abandonedPetId") int abandonedPetId);
	
	// 유기동물 좋아요 취소
	public boolean likeCancel(@Param("userId") int userId, @Param("abandonedPetId") int abandonedPetId);
	
	// 유기동물-회원 좋아요 확인
	public int isLikePet(@Param("userId") int userId, @Param("abandonedPetId") int abandonedPetId);
	
	// 유기동물-회원 좋아요 리스트
	public List<AbandonedPetDTO> likeList(@Param("userId") int userId);
	
	// 유기동물 상세 정보 보여주기
	public  PetWeightDTO detailAbandonedPet(@Param("abandonedPetId") int abandonedPetId);
}
