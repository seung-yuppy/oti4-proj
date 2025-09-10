package edu.example.bughunters.controller;

import java.security.SecureRandom;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Pattern;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.GetMapping;
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
    private final Map<String, String> store = new ConcurrentHashMap<>();
    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    @PostMapping(value = "/send-code", produces = "application/json;charset=UTF-8")
    public String send(@RequestParam String email, HttpSession session) {
        String e = email == null ? "" : email.trim();
        if (!EMAIL.matcher(e).matches()) {
            return "{\"ok\":false,\"msg\":\"이메일 형식이 올바르지 않습니다.\"}";
        }
        try {
            String code = mail.generateCode();
            store.put(e, code);
            mail.sendCode(e, code);                       // ★ 실제 발송
            session.removeAttribute("VERIFIED_EMAIL");     // 새 코드 발송 시 초기화
            return "{\"ok\":true,\"msg\":\"인증코드를 발송했습니다.\"}";
        } catch (Exception ex) {
            ex.printStackTrace();
            String msg = ex.getClass().getSimpleName() + ": " + String.valueOf(ex.getMessage()).replace("\"","'");
            return "{\"ok\":false,\"msg\":\"메일 발송 실패 - " + msg + "\"}";
        }
    }

    @PostMapping(value = "/verify", produces = "application/json;charset=UTF-8")
    public String verify(@RequestParam String email, @RequestParam String code, HttpSession session) {
        String saved = store.get(email == null ? "" : email.trim());
        if (saved != null && saved.equals(code == null ? "" : code.trim())) {
            session.setAttribute("VERIFIED_EMAIL", email.trim());
            store.remove(email.trim());
            return "{\"ok\":true,\"msg\":\"인증 완료\"}";
        }
        return "{\"ok\":false,\"msg\":\"코드가 올바르지 않거나 만료되었습니다.\"}";
    }
}