package edu.example.bughunters.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import edu.example.bughunters.dao.ChatDAO;
import edu.example.bughunters.domain.ChatMessageDTO;
import edu.example.bughunters.domain.ChatRoomDTO;
import edu.example.bughunters.domain.PetVO;
import edu.example.bughunters.service.PetService;

@RestController
@RequestMapping("/api/chat")
public class ChatController {
	@Autowired
	private ChatDAO chatDAO;
	@Autowired
	private PetService petService;

	private int currentPetId(HttpSession session) {
		Integer pet = (Integer) session.getAttribute("PET_ID");
		if (pet != null)
			return pet;

		// 여기서부터 fallback: 로그인 여부 확인 → 대표 펫 조회 → 세션에 세팅
		Integer userId = (Integer) session.getAttribute("userId");
		if (userId == null) {
			throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "LOGIN_REQUIRED");
		}

		PetVO my = petService.getPet(userId); // ★ 서비스 호출만
		if (my == null || my.getPetId() == 0) {
			// 펫이 아직 없는 사용자라면 422로 명확히 안내
			throw new ResponseStatusException(HttpStatus.UNPROCESSABLE_ENTITY, "NO_PET");
		}

		session.setAttribute("PET_ID", my.getPetId()); // ★ 한번 세팅하면 이후 OK
		return my.getPetId();
	}

	@GetMapping("/rooms")
	public List<ChatRoomDTO> myRooms(HttpSession session) {
		int petId = currentPetId(session);
		return chatDAO.selectRoomsByPet(petId);
	}

	@GetMapping("/rooms/{roomId}/messages")
	public List<ChatMessageDTO> messages(@PathVariable("roomId") int roomId,
			@RequestParam(name = "cursor", required = false) Long cursor,
			@RequestParam(name = "size", defaultValue = "20") int size, HttpSession session) {
		int petId = currentPetId(session);
		if (chatDAO.countMember(roomId, petId) <= 0)
			throw new ResponseStatusException(HttpStatus.FORBIDDEN);
		return chatDAO.selectMessages(roomId, cursor, size, petId);
	}

	/** 1:1 채팅방 생성/조회 */
	@PostMapping("/rooms/direct")
	public Map<String, Integer> direct(@RequestParam("toPetId") int toPetId, HttpSession session) {
		int myPetId = currentPetId(session);
		if (toPetId == myPetId)
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "same pet");

		Integer roomId = chatDAO.findRoomIdByPair(myPetId, toPetId);
		if (roomId == null) {
			chatDAO.insertRoom(myPetId, toPetId); // 시퀀스로 PK 생성
			roomId = chatDAO.findRoomIdByPair(myPetId, toPetId);
			if (roomId == null)
				throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "create failed");
		}else {
			chatDAO.unmarkLeft(roomId, myPetId); // 내가 재오픈하면 내 나감표시 제거
		}
		Map<String, Integer> resp = new HashMap<>();
		resp.put("roomId", roomId);
		return resp;
	}

	/** 채팅방 나가기(=실제 삭제). 방 멤버만 가능 */
	@Transactional
	@DeleteMapping("/rooms/{roomId}")
	public ResponseEntity<Map<String, Object>> leave(@PathVariable("roomId") int roomId, HttpSession session) {
		int petId = currentPetId(session);
		if (chatDAO.countMember(roomId, petId) <= 0) throw new ResponseStatusException(HttpStatus.FORBIDDEN);

		  chatDAO.markLeft(roomId, petId);

		  ChatRoomDTO st = chatDAO.getRoomStatus(roomId);
		  boolean p1Left = st.getPet1LeftAt() != null;
		  boolean p2Left = st.getPet2LeftAt() != null;
		  if (p1Left && p2Left) {
		    chatDAO.deleteMessagesByRoomId(roomId);
		    chatDAO.deleteRoomById(roomId);
		  }

		  Map<String,Object> body = new HashMap<>();
		  body.put("roomId", roomId);
		  body.put("left", true);
		  return ResponseEntity.ok(body);
	}

	// 방 상태 확인(클라이언트가 입장 시 사용)
	@GetMapping("/rooms/{roomId}/status")
	public ChatRoomDTO status(@PathVariable("roomId") int roomId, HttpSession session){
		int petId = currentPetId(session);
		  if (chatDAO.countMember(roomId, petId) <= 0) throw new ResponseStatusException(HttpStatus.FORBIDDEN);
		  return chatDAO.getRoomStatus(roomId);
	}
}
