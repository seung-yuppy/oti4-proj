package edu.example.bughunters.domain;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserDTO {
	private int userId;
	private String userName;
	private String password;
	private String nickName;
	private String address;
	private Timestamp date;
	private String role;
	private int isQuiz;
	private int isPet;
}
