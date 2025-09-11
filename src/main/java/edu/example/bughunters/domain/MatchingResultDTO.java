package edu.example.bughunters.domain;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class MatchingResultDTO {
    private double activityScore;
    private double sociabilityScore;
    private double dependencyScore;
    private double trainabilityScore;
    private double aggressionScore;
    private int countNum;
    private Long   userId;

}

