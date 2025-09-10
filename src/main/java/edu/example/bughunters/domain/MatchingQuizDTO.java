package edu.example.bughunters.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MatchingQuizDTO {
    private Long matchingQuizId;
    private String quizQuestion;
    private String quizCategory;
    private List<MatchingAnswerDTO> answers;

}

