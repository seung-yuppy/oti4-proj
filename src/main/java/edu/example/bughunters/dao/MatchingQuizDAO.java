package edu.example.bughunters.dao;

import edu.example.bughunters.domain.MatchingQuizDTO;
import edu.example.bughunters.domain.MatchingAnswerDTO;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;


@Mapper   // ← 중요 (또는 아래 2)에서 MapperScan을 쓰면 @Mapper 생략 가능)
public interface MatchingQuizDAO {
    MatchingQuizDTO selectRandomQuiz(@Param("quizCategory") String quizCategory);
    List<MatchingAnswerDTO> selectAnswersByQuizIds(@Param("quizIds") List<Long> quizIds);
}



