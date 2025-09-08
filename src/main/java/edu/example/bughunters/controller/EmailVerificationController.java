package edu.example.bughunters.controller;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Pattern;

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

    private final EmailVerificationService mail; // 네가 만든 서비스 사용(메일 발송/코드 생성)
    private final Map<String, String> store = new ConcurrentHashMap<>();
    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    @GetMapping("/ping")
    public String ping() { return "ok"; }

    @PostMapping(value = "/send-code", produces = "application/json;charset=UTF-8")
    public String send(@RequestParam String email) {
        String e = email == null ? "" : email.trim();
        if (!EMAIL.matcher(e).matches()) {
            return "{\"ok\":false,\"msg\":\"이메일 형식이 올바르지 않습니다.\"}";
        }
        String code = mail.generateCode();
        store.put(e, code);
        mail.sendCode(e, code); // devMode=true면 실제 발송 대신 콘솔에 코드 출력
        return "{\"ok\":true,\"msg\":\"인증코드를 발송했습니다.\"}";
    }

    @PostMapping(value = "/verify", produces = "application/json;charset=UTF-8")
    public String verify(@RequestParam String email, @RequestParam String code) {
        String saved = store.get(email == null ? "" : email.trim());
        if (saved != null && saved.equals(code == null ? "" : code.trim())) {
            store.remove(email);
            return "{\"ok\":true}";
        }
        return "{\"ok\":false,\"msg\":\"코드가 올바르지 않거나 만료되었습니다.\"}";
    }
}