package edu.example.bughunters.service;

import java.util.List;

import edu.example.bughunters.domain.ChatMessageDTO;
import edu.example.bughunters.domain.ChatRoomDTO;

public interface ChatService {
	/** 확장 대비용 계약(지금은 구현 만들지 않음) */
	    boolean isMember(int roomId, int petId);
	    ChatMessageDTO saveMessage(int roomId, int petId, String body);
	    List<ChatRoomDTO> listRoomsByPet(int petId);
	    List<ChatMessageDTO> listMessages(int roomId, Long cursor, int size);
	    
	    
}
