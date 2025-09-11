package edu.example.bughunters.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CommunityDTO {
	private int community_id;
	private String title;
	private String kind;
	private int age;
	private String gender;
	private double weight;
	private String color;
	private int meetingTemperature;
	private String intro;
    private int userId;
}