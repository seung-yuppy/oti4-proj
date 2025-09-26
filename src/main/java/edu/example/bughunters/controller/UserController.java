package edu.example.bughunters.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Pattern;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import edu.example.bughunters.domain.UserDTO;
import edu.example.bughunters.service.EmailVerificationService;
import edu.example.bughunters.service.UserService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final EmailVerificationService mail;

    // --- 회원가입 ---
    @GetMapping("/auth/signup")
    public String signUpForm() {
        return "user/signUp";
    }

    @PostMapping("/auth/signup")
    public String signUp(HttpSession session,
                         @RequestParam("username") String email,
                         @RequestParam("password") String password,
                         @RequestParam(value = "nickname", required = false) String nickName,
                         @RequestParam(value = "address", required = false) String address,
                         @RequestParam(value = "detailAddress", required = false) String detailAddress,
                         @RequestParam(value = "extraAddress", required = false) String extraAddress,
                         @RequestParam(value = "hasPet", required = false, defaultValue = "no") String hasPet,
                         @RequestParam(value = "emailVerified", required = false, defaultValue = "N") String emailVerified,
                         Model model, RedirectAttributes rttr) {

        Object verified = session.getAttribute("VERIFIED_EMAIL");
        if (!"Y".equalsIgnoreCase(emailVerified) || verified == null || !email.equals(verified.toString())) {
            model.addAttribute("error", "이메일 인증을 먼저 완료해 주세요.");
            return "user/signUp";
        }

        try {
            userService.signUp(email, password, nickName, address, detailAddress, extraAddress, hasPet);
            session.removeAttribute("VERIFIED_EMAIL");

            rttr.addFlashAttribute("signedUp", true);
            rttr.addFlashAttribute("openLogin", true);
            rttr.addFlashAttribute("msg", "회원가입이 완료되었습니다. 로그인해 주세요.");
            return "redirect:/home";

        } catch (IllegalArgumentException dup) {
            model.addAttribute("error", dup.getMessage());
            return "user/signUp";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "회원가입 처리 중 오류가 발생했습니다.");
            return "user/signUp";
        }
    }

    // --- 로그인 / 로그아웃 ---
    @PostMapping("/auth/login")
    public String login(HttpSession session,
                        @RequestParam("username") String email,
                        @RequestParam("password") String password,
                        RedirectAttributes rttr) {
        boolean ok = userService.login(email, password, session);
        if (!ok) {
            rttr.addFlashAttribute("msg", "이메일 또는 비밀번호가 올바르지 않습니다.");
            rttr.addFlashAttribute("openLogin", true);
        } else {
            rttr.addFlashAttribute("msg", "로그인되었습니다.");
        }
        return "redirect:/home";
    }

    @PostMapping("/auth/logout")
    public String logout(HttpSession session, RedirectAttributes rttr) {
        session.invalidate();
        rttr.addFlashAttribute("msg", "로그아웃되었습니다.");
        return "redirect:/home";
    }

    // --- 비밀번호 재설정 ---
    @PostMapping(value = "/auth/password/reset", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public Map<String,Object> resetPassword(String email, String newPassword, HttpSession session) {
        Map<String,Object> result = new HashMap<>();
        Object verified = session.getAttribute("VERIFIED_EMAIL");

        if (verified == null || email == null || !email.trim().equals(verified.toString())) {
            result.put("ok", false);
            return result;
        }

        boolean ok = userService.resetPassword(email.trim(), newPassword.trim());
        if (ok) {
            session.removeAttribute("VERIFIED_EMAIL");
            result.put("ok", true);
        } else {
            result.put("ok", false);
        }
        return result;
    }

    // --- 프로필 조회 ---
    @RequestMapping(value = "/user/me", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public UserDTO me(HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return new UserDTO();
        }
        return userService.getProfileByUserId(userId);
    }

    // --- 프로필 수정 비밀번호 검증 ---
    @PostMapping(value = "/api/login-check", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public Map<String, Object> loginCheck(@RequestParam("username") String email,
                                          @RequestParam("password") String password) {
        boolean ok = userService.verify(email, password);
        return Collections.singletonMap("ok", ok);
    }

    // --- 프로필 수정 화면 ---
    @GetMapping("/user/editProfile")
    public String editProfileForm(HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId != null) {
            UserDTO me = userService.getProfileByUserId(userId);
            if (me != null) {
                model.addAttribute("address", me.getAddress());
                model.addAttribute("hasPet", me.getIsPet());
            }
        }
        return "user/editProfile";
    }

    // --- 프로필 수정 저장 ---
    @PostMapping("/user/profile/update")
    public String updateProfile(@RequestParam String password,
                                @RequestParam String nickname,
                                @RequestParam(required = false) String postcode,
                                @RequestParam(required = false) String address,
                                @RequestParam(required = false) String detailAddress,
                                @RequestParam(required = false) String extraAddress,
                                @RequestParam String hasPet,
                                HttpSession session,
                                RedirectAttributes rttr) {

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/home";
        }

        boolean ok = userService.updateProfile(userId, password, nickname, address, detailAddress, extraAddress, hasPet);
        rttr.addFlashAttribute("msg", ok ? "회원정보가 수정되었습니다." : "수정에 실패했습니다.");
        return "redirect:/mypage";
    }

    // --- 비밀번호 찾기 페이지 ---
    @GetMapping("/forgotPassword")
    public String forgotPasswordPage() {
        return "user/forgotPassword";
    }

    // --- 회원 탈퇴 ---
    @PostMapping("/user/delete")
    public String deleteAccount(HttpSession session, RedirectAttributes rttr) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/home";
        }

        boolean ok = userService.deleteUser(userId);
        if (ok) {
            session.invalidate();
            rttr.addFlashAttribute("msg", "회원 탈퇴가 완료되었습니다. 그동안 이용해 주셔서 감사합니다.");
        } else {
            rttr.addFlashAttribute("msg", "회원 탈퇴 처리 중 오류가 발생했습니다.");
        }
        return "redirect:/home";
    }

    // --- 이메일 인증 (추가) ---
    private static class Token {
        final String code;
        final long expiresAt;
        Token(String code, long expiresAt) { this.code = code; this.expiresAt = expiresAt; }
    }
    private final Map<String, Token> store = new ConcurrentHashMap<>();
    private static final Pattern EMAIL = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    @PostMapping(value = "/auth/email/send-code", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String sendCode(@RequestParam String email, HttpSession session) {
        String e = email == null ? "" : email.trim();
        if (!EMAIL.matcher(e).matches()) {
            return "{\"ok\":false,\"msg\":\"이메일 형식이 올바르지 않습니다.\"}";
        }
        try {
            String code = mail.generateCode();
            long expires = System.currentTimeMillis() + (5 * 60 * 1000L);
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

    @PostMapping(value = "/auth/email/verify", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String verifyCode(@RequestParam String email,
                             @RequestParam String code,
                             HttpSession session) {
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
