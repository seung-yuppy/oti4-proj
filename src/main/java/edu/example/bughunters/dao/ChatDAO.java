package edu.example.bughunters.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import edu.example.bughunters.domain.ChatMessageDTO;
import edu.example.bughunters.domain.ChatRoomDTO;

@Mapper
public interface ChatDAO {
	int countMember(@Param("roomId") int roomId, @Param("petId") int petId);

	int insertMessageDTO(ChatMessageDTO dto);

	ChatMessageDTO findMessageById(@Param("msgId") long msgId);

	List<ChatRoomDTO> selectRoomsByPet(@Param("petId") int petId);

	List<ChatMessageDTO> selectMessages(@Param("roomId") int roomId, @Param("cursor") Long cursor,
			@Param("size") int size, @Param("me") int mePetId);

	Integer findRoomIdByPair(@Param("a") int a, @Param("b") int b);

	int insertRoom(@Param("a") int a, @Param("b") int b);

	// ✅ 추가
	int markLeft(@Param("roomId") int roomId, @Param("petId") int petId);

	ChatRoomDTO getRoomStatus(@Param("roomId") int roomId);

	int deleteMessagesByRoomId(@Param("roomId") int roomId);

	int deleteRoomById(@Param("roomId") int roomId);

	int unmarkLeft(@Param("roomId") int roomId, @Param("petId") int petId);
}
