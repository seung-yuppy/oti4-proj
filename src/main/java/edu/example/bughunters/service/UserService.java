package edu.example.bughunters.service;

import java.sql.Timestamp;

import javax.servlet.http.HttpSession;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import edu.example.bughunters.dao.UserDAO;
import edu.example.bughunters.domain.UserDTO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
	private final UserDAO userDAO;
    private final BCryptPasswordEncoder encoder;

    @Transactional
    public void signUp(String email, String rawPassword, String nickName,
                       String baseAddr, String detailAddr, String extraAddr,
                       String hasPet /* yes/no */) {

        if (userDAO.existsByUserName(email)) {
            throw new IllegalArgumentException("이미 가입된 이메일입니다.");
        }

        StringBuilder addr = new StringBuilder();
        if (StringUtils.hasText(baseAddr)) addr.append(baseAddr);
        if (StringUtils.hasText(detailAddr)) addr.append(" ").append(detailAddr);
        if (StringUtils.hasText(extraAddr)) addr.append(" ").append(extraAddr);

        int isPet = ("yes".equalsIgnoreCase(hasPet) || "1".equals(hasPet)) ? 1 : 0;

        UserDTO dto = new UserDTO();
        dto.setUserName(email);
      //dto.setPassword(encoder.encode(rawPassword)); 암호화저장
        dto.setPassword(rawPassword);  				//평문저장
        dto.setNickName(nickName);
        dto.setAddress(addr.toString().trim());
        dto.setDate(new Timestamp(System.currentTimeMillis()));
        dto.setRole("USER");
        dto.setIsQuiz(0);
        dto.setIsPet(isPet);

        int n = userDAO.insertUser(dto);
        if (n != 1) throw new IllegalStateException("회원가입 저장에 실패했습니다.");
    }
    
    // 회원가입 처리 & 로그인 모달 처리
    @Transactional(readOnly = true)
    public boolean login(String email, String rawPassword, HttpSession session) {
        UserDTO user = userDAO.findByUserName(email);
        if (user == null) return false;
        //if (!encoder.matches(rawPassword, user.getPassword())) return false; // BCrypt 암호 저장
        if (!rawPassword.equals(user.getPassword())) return false; // 평문 저장

        session.setAttribute("LOGIN_USER", user.getUserName()); // 필요한 값 넣기
        return true;
    }
}
