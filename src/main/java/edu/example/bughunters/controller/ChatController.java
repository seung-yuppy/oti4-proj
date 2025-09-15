package edu.example.bughunters.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import edu.example.bughunters.dao.ChatDAO;
import edu.example.bughunters.domain.ChatMessageDTO;
import edu.example.bughunters.domain.ChatRoomDTO;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {
	private final ChatDAO chatDAO;

    private int currentPetId(HttpSession session){
        Object v = session.getAttribute("PET_ID");
        if (v == null) throw new ResponseStatusException(HttpStatus.UNAUTHORIZED);
        return (int) v;
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
        if (chatDAO.countMember(roomId, petId) <= 0) throw new ResponseStatusException(HttpStatus.FORBIDDEN);
        return chatDAO.selectMessages(roomId, cursor, size);
    }
}
