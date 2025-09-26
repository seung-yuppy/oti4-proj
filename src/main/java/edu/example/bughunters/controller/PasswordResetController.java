package edu.example.bughunters.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import edu.example.bughunters.service.UserService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class PasswordResetController {
	private final UserService userService;

	@PostMapping(value = "/auth/password/reset", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public Map<String,Object> reset(String email, String newPassword, HttpSession session, RedirectAttributes rttr) {
		Map<String,Object> result = new HashMap<>();
	    Object verified = session.getAttribute("VERIFIED_EMAIL");

	    if (verified == null || email == null || !email.trim().equals(verified.toString())) {
	        result.put("ok", false);
	        result.put("msg", "이메일 인증이 필요합니다.");
	        return result;
	    }
	    boolean ok = userService.resetPassword(email.trim(), newPassword.trim());
	    if (ok) {
	        session.removeAttribute("VERIFIED_EMAIL");
	        result.put("ok", true);
	        result.put("msg", "비밀번호가 변경되었습니다. 로그인해 주세요.");
	    } else {
	        result.put("ok", false);
	        result.put("msg", "비밀번호 변경에 실패했습니다.");
	    }
	    return result;
	}
}
