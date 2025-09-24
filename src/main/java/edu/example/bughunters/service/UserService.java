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
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(12);

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
        dto.setPassword(encoder.encode(rawPassword)); // 암호화저장
        //dto.setPassword(rawPassword);  				//평문저장
        dto.setNickName(nickName);
        dto.setAddress(addr.toString().trim());
        dto.setDate(new Timestamp(System.currentTimeMillis()));
        dto.setRole("USER");
        dto.setIsQuiz(0);
        dto.setIsPet(0);

        int n = userDAO.insertUser(dto);
        if (n != 1) throw new IllegalStateException("회원가입 저장에 실패했습니다.");
    }
    
    // 회원가입 처리 & 로그인 모달 처리
    @Transactional(readOnly = true)
    public boolean login(String email, String rawPassword, HttpSession session) {
        UserDTO user = userDAO.findByUserName(email);
        if (user == null) return false;
        //if (!encoder.matches(rawPassword, user.getPassword())) return false; // BCrypt 암호 저장
        //if (!rawPassword.equals(user.getPassword())) return false; // 평문 저장
        
        String stored = user.getPassword();
        boolean isHash = stored != null && (stored.startsWith("$2a$") || stored.startsWith("$2b$") || stored.startsWith("$2y$"));
        boolean ok = isHash ? encoder.matches(rawPassword, stored) : rawPassword.equals(stored);
        if (!ok) return false;

        session.setAttribute("LOGIN_USER", user.getUserName()); // 필요한 값 넣기
        session.setAttribute("userId", user.getUserId());
        return true;
    }
    
    // 펫과펫 페이지 프로필 불러오기
    @Transactional(readOnly = true)
    public UserDTO getProfileByUserId(Integer userId) {
        if (userId == null) return null;
        return userDAO.findByUserId(userId);
    }
    
    @Transactional(readOnly = true)
    public boolean verify(String email, String rawPassword) {
        UserDTO user = userDAO.findByUserName(email);
        if (user == null) return false;

        // 지금은 평문 저장이라 문자열 비교
        //return rawPassword.equals(user.getPassword());

        // 나중에 해시 저장으로 바꾸면 ↓ 한 줄로 변경
         return encoder.matches(rawPassword, user.getPassword());
    }
    
    @Transactional
    public boolean updateProfile(Integer userId,
                                 String newPassword,
                                 String nickName,
                                 String baseAddr, String detailAddr, String extraAddr,
                                 String hasPet) {

        if (userId == null) return false;

        StringBuilder addr = new StringBuilder();
        if (StringUtils.hasText(baseAddr))    addr.append(baseAddr);
        if (StringUtils.hasText(detailAddr))  addr.append(" ").append(detailAddr);
        if (StringUtils.hasText(extraAddr))   addr.append(" ").append(extraAddr);

        Integer isPet = ("yes".equalsIgnoreCase(hasPet) || "1".equals(hasPet)) ? 1 : 0;

        UserDTO dto = new UserDTO();
        dto.setUserId(userId);
        if (StringUtils.hasText(newPassword)) {
            // 현재 평문저장:
        	// dto.setPassword(newPassword);
        	dto.setPassword(encoder.encode(newPassword));
            // 해시로 바꾸면: dto.setPassword(encoder.encode(newPassword));
        }
        dto.setNickName(nickName);
        dto.setAddress(addr.toString().trim());
        dto.setIsPet(isPet);

        int n = userDAO.updateUserProfile(dto);
        return n == 1;
    }
}
