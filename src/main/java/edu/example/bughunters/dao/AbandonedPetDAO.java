package edu.example.bughunters.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import edu.example.bughunters.domain.AbandonedPetDTO;

@Mapper
public interface AbandonedPetDAO {
	// 페이징을 위한 유기동물 갯수
	public int countAll();
	
	// 유기동물 모든 리스트
	public List<AbandonedPetDTO> listAll(@Param("start") int start, @Param("end") int end);
	
	// 유기동물 아이디로 상세 페이지
	public AbandonedPetDTO listOne(int id);
}
