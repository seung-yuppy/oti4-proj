package edu.example.bughunters.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class WalkingDTO {
	private int walkingId;
	private String location;
	private String createdAt;
	private int isWalking;
	private int petId;
}
