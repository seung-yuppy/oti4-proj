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
public class ChatMessageDTO {

	private int chatMessageId;
	private String chatMessage;
	private Timestamp createdAt;
	private int chatRoomId;
	private int petId;
}
