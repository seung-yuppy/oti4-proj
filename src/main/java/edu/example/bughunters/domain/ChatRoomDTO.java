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
public class ChatRoomDTO {
	private int chatRoomId;
	private Timestamp createdAt;
	private int petId1;
	private int petId2;

}
