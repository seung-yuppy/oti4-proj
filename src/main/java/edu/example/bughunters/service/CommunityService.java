package edu.example.bughunters.service;

import edu.example.bughunters.dao.CommunityDAO;
import edu.example.bughunters.domain.CommunityDTO;
import edu.example.bughunters.domain.CommentDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
public class CommunityService {

    private final CommunityDAO communityDAO;

    // ===== Community =====

    /** 단건 조회 */
    @Transactional(readOnly = true)
    public CommunityDTO getById(int communityId) {
        return communityDAO.selectById(communityId);
    }

    /** 상세 진입: 조회수 +1 후 조회 */
    @Transactional
    public CommunityDTO getDetailAndIncreaseView(int communityId) {
        communityDAO.increaseViewcount(communityId);
        return communityDAO.selectById(communityId);
    }

    @Transactional(readOnly = true)
    public List<CommunityDTO> getList(Map<String, Object> filters, Integer page, Integer size) {
        Map<String,Object> params = new HashMap<>();
        if (filters != null) params.putAll(filters);
        if (page != null && size != null) {
            int p = Math.max(1, page), s = Math.max(1, size);
            params.put("offset", (p - 1) * s);
            params.put("limit", s);
        }
        return communityDAO.selectList(params);
    }
    
    @Transactional(readOnly = true)
    public int countList(Map<String, Object> filters) {
        Map<String,Object> params = new HashMap<>();
        if (filters != null) params.putAll(filters);
        return communityDAO.countList(params);
    }

    /** insert */
    @Transactional
    public int createPost(CommunityDTO dto) {
        communityDAO.insertCommunity(dto);       
        return dto.getCommunityId(); 
    }

    @Transactional
    public boolean updatePost(CommunityDTO dto) {
        return communityDAO.updateCommunity(dto) > 0;
    }

    @Transactional
    public boolean deletePost(int communityId, int userId) {
        communityDAO.deleteCommentsByCommunity(communityId);
        return communityDAO.deleteCommunity(communityId, userId) > 0;
    }

    // ===== Comment =====

    @Transactional(readOnly = true)
    public List<CommentDTO> getComments(int communityId, Integer page, Integer size) {
    	if (page != null && size != null) {
    	    int offset = Math.max(0, (page - 1) * size);
    	    int limit = Math.max(1, size);
    	    return communityDAO.selectCommentsPaged(communityId, offset, limit);
    	}

        return communityDAO.selectComments(communityId);
    }

    @Transactional(readOnly = true)
    public int getCommentCount(int communityId) {
        return communityDAO.countComments(communityId);
    }

    @Transactional
    public int addComment(CommentDTO dto) {
        communityDAO.insertComment(dto);
        return dto.getCommentId();
    }

    @Transactional
    public boolean updateComment(CommentDTO dto) {
        return communityDAO.updateComment(dto) > 0;
    }

    @Transactional
    public boolean deleteComment(int commentId, int userId) {
        return communityDAO.deleteComment(commentId, userId) > 0;
    }
    
    @Transactional
    public boolean clearPostImage(int communityId, int userId) {
        return communityDAO.clearImage(communityId, userId) > 0;
    }
    
    @Transactional(readOnly = true)
    public int countPostsByUser(int userId) {
        return communityDAO.countPostsByUser(userId);
    }

    @Transactional(readOnly = true)
    public List<CommunityDTO> findPostsByUser(int userId, int page, int size) {
        int offset = (page - 1) * size;
        return communityDAO.selectPostsByUser(userId, offset, size);
    }

    @Transactional(readOnly = true)
    public int countCommentsByUser(int userId) {
        return communityDAO.countCommentsByUser(userId);
    }

    @Transactional(readOnly = true)
    public List<CommentDTO> findCommentsByUser(int userId, int page, int size) {
        int offset = (page - 1) * size;
        return communityDAO.selectCommentsByUser(userId, offset, size);
    }
}
