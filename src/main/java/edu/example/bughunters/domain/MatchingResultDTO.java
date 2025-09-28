package edu.example.bughunters.domain;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Getter
@Setter
public class MatchingResultDTO {
    private Double activityScore;
    private Double sociabilityScore;
    private Double dependencyScore;
    private Double trainabilityScore;
    private Double aggressionScore;
    private int countNum;
    private Long   userId;

}

