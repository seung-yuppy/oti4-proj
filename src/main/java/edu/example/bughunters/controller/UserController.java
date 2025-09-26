package edu.example.bughunters.controller;

import java.util.Collections;
import java.util.Map;

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
import edu.example.bughunters.service.UserService;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserController {
	private final UserService userService;

	@GetMapping("/auth/signup")
	public String signUpForm() {
		return "user/signUp"; // /WEB-INF/views/user/SignUp.jsp
	}

	private String rootMsg(Throwable t) {
		Throwable c = t;
		while (c.getCause() != null)
			c = c.getCause();
		return c.getClass().getSimpleName() + ": " + String.valueOf(c.getMessage());
	}

	@PostMapping("/auth/signup")
	public String signUp(HttpSession session, @RequestParam("username") String email,
			@RequestParam("password") String password,
			@RequestParam(value = "nickname", required = false) String nickName,

			// ▼ SignUp.jsp의 name들과 정확히 맞춰서 받습니다
			@RequestParam(value = "address", required = false) String address,
			@RequestParam(value = "detailAddress", required = false) String detailAddress,
			@RequestParam(value = "extraAddress", required = false) String extraAddress,

			@RequestParam(value = "hasPet", required = false, defaultValue = "no") String hasPet,
			@RequestParam(value = "emailVerified", required = false, defaultValue = "N") String emailVerified,
			Model model, RedirectAttributes rttr // ★ Flash Attribute
	) {
		// 세션에 기록된 인증 이메일과 제출 이메일이 같아야 최종 통과
		Object verified = session.getAttribute("VERIFIED_EMAIL");
		if (!"Y".equalsIgnoreCase(emailVerified) || verified == null || !email.equals(verified.toString())) {
			model.addAttribute("error", "이메일 인증을 먼저 완료해 주세요.");
			return "user/signUp";
		}

		try {
			userService.signUp(email, password, nickName, address, detailAddress, extraAddress, hasPet);
			session.removeAttribute("VERIFIED_EMAIL"); // 성공 후 정리

			// ★ URL 안 더럽히지 않고 1회성 메시지 전달
			rttr.addFlashAttribute("signedUp", true);
			rttr.addFlashAttribute("openLogin", true);
			rttr.addFlashAttribute("msg", "회원가입이 완료되었습니다. 로그인해 주세요.");

			return "redirect:/home"; // 홈으로 리다이렉트

		} catch (IllegalArgumentException dup) {
			model.addAttribute("error", dup.getMessage());
			return "user/signUp";
		} catch (Exception e) {
			e.printStackTrace(); // 서버 콘솔에도 원인 출력
			model.addAttribute("error", "회원가입 처리 중 오류가 발생했습니다.");
			return "user/signUp";
		}
	}

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
	
	// 프로필 수정하기
	@RequestMapping(value = "/user/me", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public UserDTO me(HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return new UserDTO(); // 비로그인 시 빈 객체
        }
        return userService.getProfileByUserId(userId);
    }
	
	// 프로필 수정 비밀번호 검증
	@PostMapping(value = "/api/login-check", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public Map<String, Object> loginCheck(@RequestParam("username") String email,
	                                      @RequestParam("password") String password) {
	    boolean ok = userService.verify(email, password);
	    return Collections.singletonMap("ok", ok);
	}
	
	
	// 화면 열기
	@GetMapping("/user/editProfile")
	public String editProfileForm(HttpSession session, Model model) {
		Integer userId = (Integer) session.getAttribute("userId");
		if (userId != null) {
	        UserDTO me = userService.getProfileByUserId(userId);
	        if (me != null) {
	            model.addAttribute("address", me.getAddress()); // DB의 전체 주소 문자열
	            model.addAttribute("hasPet", me.getIsPet());    // 1 or 0
	        }
	    }
	    return "user/editProfile";
	}

	// 저장 처리
	@PostMapping("/user/profile/update")
	public String updateProfile(
	        @RequestParam String password,
	        @RequestParam String nickname,
	        @RequestParam(required=false) String postcode,
	        @RequestParam(required=false) String address,
	        @RequestParam(required=false) String detailAddress,
	        @RequestParam(required=false) String extraAddress,
	        @RequestParam String hasPet,
	        HttpSession session,
	        RedirectAttributes rttr) {

	    Integer userId = (Integer) session.getAttribute("userId");
	    if (userId == null) {
	        rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
	        return "redirect:/home";
	    }

	    boolean ok = userService.updateProfile(
	            userId, password, nickname,
	            address, detailAddress, extraAddress,
	            hasPet
	    );

	    rttr.addFlashAttribute("msg", ok ? "회원정보가 수정되었습니다." : "수정에 실패했습니다.");
	    return "redirect:/mypage";
	}
}
