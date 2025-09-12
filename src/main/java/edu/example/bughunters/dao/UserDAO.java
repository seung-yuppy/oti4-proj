package edu.example.bughunters.dao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import edu.example.bughunters.domain.UserDTO;
import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class UserDAO {
	private final SqlSessionTemplate session;
    private static final String NS = "edu.example.bughunters.dao.UserDAO.";

    public UserDTO findByUserName(String userName) {
        return session.selectOne(NS + "findByUserName", userName);
    }

    public boolean existsByUserName(String userName) {
        Integer cnt = session.selectOne(NS + "existsByUserName", userName);
        return cnt != null && cnt > 0;
    }

    public int insertUser(UserDTO dto) {
        return session.insert(NS + "insertUser", dto);
    }
    
    public UserDTO findByUserId(int userId) {
        return session.selectOne(NS + "findByUserId", userId);
    }
    
    public int updateUserProfile(UserDTO dto) {
        return session.update(NS + "updateUserProfile", dto);
    }
}
