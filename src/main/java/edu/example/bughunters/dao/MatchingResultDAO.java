package edu.example.bughunters.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import edu.example.bughunters.domain.MatchingResultDTO;
import edu.example.bughunters.domain.PetWeightDTO;

@Mapper
public interface MatchingResultDAO {
 // 유저의 is_quiz 조회
 Integer selectIsQuizByUserId(Long userId);

 // 결과 조회
 MatchingResultDTO selectResultByUserId(Long userId);

 // 첫 저장
 int insertResult(MatchingResultDTO dto);

 // 평균 계산된 최신 값으로 업데이트
 int updateResultByUserId(MatchingResultDTO dto);

 // is_quiz = 1로 변경
 int setIsQuizTrue(Long userId);
 
 List<PetWeightDTO> selectAllPetWeights();
 int updateMatchedPetId(@Param("userId") Long userId, @Param("petId") Long petId);
 
 // TOP-4 갱신용
 int deleteTopMatchesByUserId(Long userId);
 int insertTopMatch(@Param("userId") Long userId,
                    @Param("rankNo") Integer rankNo,
                    @Param("petId") Long petId);

 // 조회용(뷰에서 쓰기)
 List<Long> selectTopPetIdsByUserId(Long userId);
}

