package edu.example.bughunters.domain;

import lombok.Data;

@Data
public class MatchingResultDTO {
    private double activityScore;
    private double sociabilityScore;
    private double dependencyScore;
    private double trainabilityScore;
    private double aggressionScore;
    private Long   userId;

}

