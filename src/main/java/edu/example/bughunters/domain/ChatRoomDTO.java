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

	// ✅ 나감 시각 필드 추가
    private Timestamp pet1LeftAt;
    private Timestamp pet2LeftAt;
}
