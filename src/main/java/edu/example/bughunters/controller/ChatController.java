package edu.example.bughunters.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
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

@RestController
@RequestMapping("/api/chat")
public class ChatController {
	@Autowired
    private ChatDAO chatDAO; // 롬복 대신 간단히 필드 주입

    private int currentPetId(HttpSession session){
        Object v = session.getAttribute("PET_ID");
        if (v == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        return (Integer) v;
    }

    @GetMapping("/rooms")
    public List<ChatRoomDTO> myRooms(HttpSession session){
        int petId = currentPetId(session);
        return chatDAO.selectRoomsByPet(petId);
    }

    @GetMapping("/rooms/{roomId}/messages")
    public List<ChatMessageDTO> messages(@PathVariable int roomId,
                                         @RequestParam(required=false) Long cursor,
                                         @RequestParam(defaultValue="20") int size,
                                         HttpSession session){
        int petId = currentPetId(session);
        if (chatDAO.countMember(roomId, petId) <= 0)
            throw new ResponseStatusException(HttpStatus.FORBIDDEN);
        return chatDAO.selectMessages(roomId, cursor, size);
    }

    /** 1:1 채팅방 생성/조회 */
    @PostMapping("/rooms/direct")
    public Map<String,Integer> direct(@RequestParam int toPetId, HttpSession session){
        int myPetId = currentPetId(session);
        if (toPetId == myPetId)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "same pet");

        Integer roomId = chatDAO.findRoomIdByPair(myPetId, toPetId);
        if (roomId == null) {
            chatDAO.insertRoom(myPetId, toPetId);     // 시퀀스로 PK 생성
            roomId = chatDAO.findRoomIdByPair(myPetId, toPetId);
            if (roomId == null)
                throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "create failed");
        }
        Map<String,Integer> resp = new HashMap<>();
        resp.put("roomId", roomId);
        return resp;
    }
}
