package edu.example.bughunters.websocket;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.HandshakeInterceptor;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSocket
@RequiredArgsConstructor
public class WebsocketConfig implements WebSocketConfigurer{
	
	private final ChatWebSocketHandler chatWebSocketHandler;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(chatWebSocketHandler, "/ws/chat")
                .addInterceptors(new HttpHandshakeAttrsInterceptor())
                .setAllowedOriginPatterns("*");
    }

    static class HttpHandshakeAttrsInterceptor implements HandshakeInterceptor {
        @Override
        public boolean beforeHandshake(ServerHttpRequest req, ServerHttpResponse res,
                                       WebSocketHandler wsHandler, Map<String, Object> attrs) {
            if (req instanceof ServletServerHttpRequest) {
                ServletServerHttpRequest sshr = (ServletServerHttpRequest) req; // ← 옛 스타일
                HttpSession httpSession = sshr.getServletRequest().getSession(false);
                if (httpSession == null) return false;
                Object petId = httpSession.getAttribute("PET_ID");
                Object nick  = httpSession.getAttribute("NICK");
                if (petId == null) return false;
                attrs.put("PET_ID", petId);
                attrs.put("NICK", nick);
            }
            return true;
        }

        @Override
        public void afterHandshake(ServerHttpRequest req, ServerHttpResponse res,
                                   WebSocketHandler wsHandler, Exception ex) { }
    }
}
