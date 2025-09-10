package edu.example.bughunters.domain;

import lombok.Data;

@Data
public class PetWeightDTO {
    private Long abandonedPetId;
    private Double activityWeight;
    private Double sociabilityWeight;
    private Double dependencyWeight;
    private Double trainabilityWeight;
    private Double aggressionWeight;
    private String description; 
}
