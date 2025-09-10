package edu.example.bughunters.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class PetDTO {
	private int petId;
	private String name;
	private String kind;
	private int age;
	private String gender;
	private double weight;
	private String color;
	private int meetingTemperature;
	private String intro;
    private int userId; // 외래키로 사용할 사용자 ID
}
