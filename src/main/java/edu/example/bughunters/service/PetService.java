package edu.example.bughunters.service;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import edu.example.bughunters.dao.PetDAO;
import edu.example.bughunters.domain.PetDTO;

@Service
public class PetService {
	@Autowired
	PetDAO dao;
	
	public boolean registerPet(PetDTO dto, MultipartFile file) {
		// 1. file을 바이트 배열 타입으로 변환
		byte[] fileBytes = null;
		if (!file.isEmpty()) {
			try {
				fileBytes = file.getBytes();
			} catch (IOException e) {
				e.printStackTrace();
				System.out.println("파일 변환 오류 발생.");
			}
		}

		// 2. DAO에 DTO와 파일 바이트 배열을 함께 전달
		boolean result = dao.signUpPet(dto, fileBytes);

		if (result) {
			if (!file.isEmpty()) {
				try {
					String originalFilename = file.getOriginalFilename();
					// 저장할 디렉토리가 없으면 생성
					File saveDir = new File("C:/uploadtest/");
					if (!saveDir.exists()) 
						saveDir.mkdirs();
		
					// 파일명 중복을 피하기 위해 타임스탬프 추가
					String fileNameWithoutExt = originalFilename.substring(0, originalFilename.lastIndexOf("."));
					String fileExt = originalFilename.substring(originalFilename.lastIndexOf("."));
					String newFileName = fileNameWithoutExt + "_" + System.currentTimeMillis() + fileExt;

					File saveFile = new File(saveDir, newFileName);

					// 파일을 지정된 경로에 저장
					file.transferTo(saveFile);

				} catch (IOException e) {
					e.printStackTrace();
					System.out.println("로컬 파일 저장 중 오류 발생.");
				}
			}
		} else {
			System.out.println("DB 삽입 실패.");
		}
		
		return result;
	}
	
	public PetDTO getPet(int userId) {
		PetDTO dto = dao.getMyPet(userId);
		return dto;
	}
}
