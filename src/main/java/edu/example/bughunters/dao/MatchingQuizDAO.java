package edu.example.bughunters.dao;

import edu.example.bughunters.domain.MatchingQuizDTO;
import edu.example.bughunters.domain.MatchingAnswerDTO;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;


@Mapper   
public interface MatchingQuizDAO {
    MatchingQuizDTO selectRandomQuiz(@Param("quizCategory") String quizCategory);
    List<MatchingAnswerDTO> selectAnswersByQuizIds(@Param("quizIds") List<Long> quizIds);
}



