package edu.example.bughunters.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class MatchingAnswerDTO {
    private Long matchingAnswerId;
    private String quizAnswer;
    private Long matchingQuizId;
    private String answerWeight;
}