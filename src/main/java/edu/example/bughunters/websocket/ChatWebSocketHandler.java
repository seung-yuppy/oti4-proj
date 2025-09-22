package edu.example.bughunters.websocket;

import java.sql.Timestamp;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import edu.example.bughunters.dao.ChatDAO;
import edu.example.bughunters.domain.ChatMessageDTO;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class ChatWebSocketHandler extends TextWebSocketHandler{
	
	private final ChatDAO chatDAO;

    private final Map<Integer, Set<WebSocketSession>> roomSessions = new ConcurrentHashMap<>();
    private final ObjectMapper om = new ObjectMapper();

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        // JDK8 호환: 람다 대신 for-each
        for (Set<WebSocketSession> set : roomSessions.values()) {
            set.remove(session);
        }
        super.afterConnectionClosed(session, status);
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        JsonNode in = om.readTree(message.getPayload());
        String type = in.path("type").asText();
        int roomId = in.path("roomId").asInt();

        Integer myPetIdObj = (Integer) session.getAttributes().get("PET_ID");
        String nick = (String) session.getAttributes().getOrDefault("NICK", "익명");
        if (myPetIdObj == null) {
            session.close(CloseStatus.NOT_ACCEPTABLE.withReason("unauthorized"));
            return;
        }
        int myPetId = myPetIdObj.intValue();

        // --- JOIN ---
        if ("JOIN".equals(type)) {
            if (chatDAO.countMember(roomId, myPetId) <= 0) {
                session.close(CloseStatus.NOT_ACCEPTABLE.withReason("not a member"));
                return;
            }
            roomSessions.computeIfAbsent(roomId, k -> ConcurrentHashMap.newKeySet()).add(session);

            ObjectNode joined = om.createObjectNode();
            joined.put("type", "JOINED");
            joined.put("roomId", roomId);
            session.sendMessage(new TextMessage(joined.toString()));
            return;
        }

        // --- SEND ---
        if ("SEND".equals(type)) {
            if (chatDAO.countMember(roomId, myPetId) <= 0) return;

            String body = in.path("body").asText("");
            if (body == null || body.trim().isEmpty()) return; // JDK8/11 호환

            ChatMessageDTO dto = new ChatMessageDTO();
            dto.setChatRoomId(roomId); // (필드명 오타 유지 중이면 XML alias로 매핑)
            dto.setPetId(myPetId);
            dto.setChatMessage(body);
            dto.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            chatDAO.insertMessageDTO(dto); // selectKey로 chatMessageId 채워짐

            ObjectNode out = om.createObjectNode();
            out.put("type", "MESSAGE");
            out.put("roomId", roomId);
            out.put("msgId", dto.getChatMessageId());
            out.put("senderPetId", myPetId);
            out.put("senderName", nick);
            out.put("body", dto.getChatMessage());
            out.put("createdAt", dto.getCreatedAt().toInstant().toString());

            Set<WebSocketSession> sessions = roomSessions.getOrDefault(roomId, Collections.emptySet()); // JDK8
            for (WebSocketSession s : sessions) {
                if (s.isOpen()) {
                    try {
                        s.sendMessage(new TextMessage(out.toString()));
                    } catch (Exception ignore) {}
                }
            }
        }
    }
    
    public void broadcastLeft(int roomId, int leaverPetId) {
        ObjectNode out = om.createObjectNode();
        out.put("type", "LEFT");
        out.put("roomId", roomId);
        out.put("leaverPetId", leaverPetId);

        Set<WebSocketSession> sessions = roomSessions.getOrDefault(roomId, Collections.emptySet());
        for (WebSocketSession s : sessions) {
            if (s.isOpen()) {
                try {
                    s.sendMessage(new TextMessage(out.toString()));
                } catch (Exception ignore) {}
            }
        }
    }
	
}
