package edu.example.bughunters.controller;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Pattern;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import edu.example.bughunters.service.EmailVerificationService;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/auth/email")
@RequiredArgsConstructor
public class EmailVerificationController {

	private final EmailVerificationService mail;

    // 코드 + 만료시간(5분)
    private static class Token {
        final String code;
        final long expiresAt; // epoch millis
        Token(String code, long expiresAt) { this.code = code; this.expiresAt = expiresAt; }
    }

    private final Map<String, Token> store = new ConcurrentHashMap<>();
    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    @PostMapping(value = "/send-code", produces = "application/json;charset=UTF-8")
    public String send(@RequestParam String email, HttpSession session) {
        String e = email == null ? "" : email.trim();
        if (!EMAIL.matcher(e).matches()) {
            return "{\"ok\":false,\"msg\":\"이메일 형식이 올바르지 않습니다.\"}";
        }
        try {
            String code = mail.generateCode();
            long expires = System.currentTimeMillis() + (5 * 60 * 1000L); // 5분
            store.put(e, new Token(code, expires));
            mail.sendCode(e, code);
            session.removeAttribute("VERIFIED_EMAIL");
            return "{\"ok\":true,\"msg\":\"인증코드를 발송했습니다. (5분 이내 유효)\"}";
        } catch (Exception ex) {
            ex.printStackTrace();
            String msg = ex.getClass().getSimpleName() + ": " + String.valueOf(ex.getMessage()).replace("\"","'");
            return "{\"ok\":false,\"msg\":\"메일 발송 실패 - " + msg + "\"}";
        }
    }

    @PostMapping(value = "/verify", produces = "application/json;charset=UTF-8")
    public String verify(@RequestParam String email, @RequestParam String code, HttpSession session) {
        String key = email == null ? "" : email.trim();
        Token t = store.get(key);
        if (t != null && t.code.equals(code == null ? "" : code.trim())) {
            if (System.currentTimeMillis() <= t.expiresAt) {
                session.setAttribute("VERIFIED_EMAIL", key);
                store.remove(key);
                return "{\"ok\":true,\"msg\":\"인증 완료\"}";
            } else {
                store.remove(key);
                return "{\"ok\":false,\"msg\":\"코드가 만료되었습니다. 다시 발송해 주세요.\"}";
            }
        }
        return "{\"ok\":false,\"msg\":\"코드가 올바르지 않거나 만료되었습니다.\"}";
    }
}