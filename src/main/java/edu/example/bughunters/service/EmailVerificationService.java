package edu.example.bughunters.service;

import java.security.SecureRandom;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EmailVerificationService {
	private final JavaMailSender mailSender;
	@Value("${mail.devMode:false}")
	private boolean devMode;
	@Value("${mail.username}")
	private String fromAddress;

	private final SecureRandom random = new SecureRandom();

	public String generateCode() {
		return String.format("%06d", random.nextInt(1_000_000)); // 6자리
	}

	public void sendCode(String toEmail, String code) {
		if (devMode) {
			System.out.println("[DEV] Email to " + toEmail + " / CODE = " + code);
			return;
		}
		try {
			MimeMessage mime = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(mime, "UTF-8");

			String html = "<div style='font-family:Arial,sans-serif'>" + "<p>아래 코드를 입력해 주세요. 유효기간 5분</p>"
					+ "<div style='font-size:28px;letter-spacing:4px;font-weight:bold'>" + code + "</div>" + "</div>";

			helper.setFrom(fromAddress, "운명의 발바닥");
			helper.setTo(toEmail);
			helper.setSubject("[인증코드] 회원가입 확인");
			helper.setText(html, true);
			mailSender.send(mime);
		} catch (Exception e) {
			throw new RuntimeException("메일 발송 실패: " + e.getMessage(), e);
		}
	}
}
