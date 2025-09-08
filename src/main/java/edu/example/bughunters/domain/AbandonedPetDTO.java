package edu.example.bughunters.domain;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class AbandonedPetDTO {
	private int abandonedPetId;
	private String kind;
	private String color;
	private int age;
	private int weight;
	private String address;
	private String description;
	private String profileImage;
	private String gender;
	private Date rescueDate;
	private String careName;
	private String careTel;
	private int isMix;
	private int isNeuter;
	private String vaccin;
}
