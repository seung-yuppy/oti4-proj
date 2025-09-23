package edu.example.bughunters.service;

import java.io.File;
import java.io.IOException;
import java.util.Base64;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import edu.example.bughunters.dao.PetDAO;
import edu.example.bughunters.domain.PetDTO;
import edu.example.bughunters.domain.PetVO;
import edu.example.bughunters.domain.WalkingVO;

@Service
public class PetService {
	@Autowired
	PetDAO dao;
	
	public void processPetData(PetVO vo) {
		// 성별
		if (vo.getGender() != null) {
			if (vo.getGender().equals("M"))
				vo.setGender("수컷");
			else
				vo.setGender("암컷");
		}
	}
	
	public void processWalkingData(WalkingVO vo) {
		// 성별
		if (vo.getGender() != null) {
			if (vo.getGender().equals("M"))
				vo.setGender("수컷");
			else
				vo.setGender("암컷");
		}
	}

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
		boolean changeIsPet = dao.changeIsPet(dto.getUserId());

		if (result && changeIsPet) {
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

	public PetVO getPet(int userId) {
		PetVO vo = dao.getMyPet(userId);
		if (vo != null && vo.getProfileImage() != null) {
			// 1. byte[]를 Base64 문자열로 인코딩
			String base64Image = Base64.getEncoder().encodeToString(vo.getProfileImage());

			// 2. PetVO에 인코딩된 문자열을 저장할 필드 추가
			vo.setProfileImage(null); // 바이트 배열은 필요 없으니 null로 설정
			vo.setBase64ProfileImage(base64Image);
			
			processPetData(vo);
		}
		return vo;
	}
	
	public boolean registerWalking(int petId, String location) {
		try {
			dao.registerWalking(petId, location);
			return true;
		} catch(Exception e) {
			return false;
		}
	}
	
	public List<WalkingVO> walkingList() {
		List<WalkingVO> list = dao.getWalkingList();
		
		for (WalkingVO vo : list) {
			if (vo != null && vo.getProfileImage() != null) {
				// 1. byte[]를 Base64 문자열로 인코딩
				String base64Image = Base64.getEncoder().encodeToString(vo.getProfileImage());

				// 2. PetVO에 인코딩된 문자열을 저장할 필드 추가
				vo.setProfileImage(null); // 바이트 배열은 필요 없으니 null로 설정
				vo.setBase64ProfileImage(base64Image);
				
				processWalkingData(vo);
			}
		}
		
		return list;
	}
	
	public boolean isWalking(int petId) {
		int counting = dao.isRegisterWalking(petId);
		if (counting >= 1)
			return false;
		else
			return true;
	}
	
	public boolean isUserGetPet(int userId) {
		int isPet = dao.isUserPet(userId);
		if(isPet == 1) 
			return true;
		else
			return false;
	}

	public boolean updatePet(PetDTO dto, MultipartFile file) {
	    byte[] fileBytes = null;

	    if (file != null && !file.isEmpty()) {
	        try {
	            fileBytes = file.getBytes();
	        } catch (IOException e) {
	            e.printStackTrace();
	            System.out.println("새 파일 변환 오류 발생.");
	            return false;
	        }
	    } else {
	        PetVO existingPet = dao.selectPetById(dto.getPetId());
	        System.out.println("현재 내 펫 : " + existingPet);

	        if (existingPet != null) {
	            fileBytes = existingPet.getProfileImage();
	            System.out.println("프로필 이미지 : " + fileBytes);
	        }
	    }

	    boolean result = dao.updatingPet(dto, fileBytes);
	    
		if (result) {
			if (!file.isEmpty()) {
				try {
					String originalFilename = file.getOriginalFilename();
					File saveDir = new File("C:/uploadtest/");
					if (!saveDir.exists())
						saveDir.mkdirs();

					String fileNameWithoutExt = originalFilename.substring(0, originalFilename.lastIndexOf("."));
					String fileExt = originalFilename.substring(originalFilename.lastIndexOf("."));
					String newFileName = fileNameWithoutExt + "_" + System.currentTimeMillis() + fileExt;

					File saveFile = new File(saveDir, newFileName);
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
	
	// 내 반려동물 삭제
	public boolean removePet(int userId) {
		if (dao.removeMyPet(userId)) {
			dao.updateUserPet(userId);
			return true;
		}
		else
			return false;
	}
}