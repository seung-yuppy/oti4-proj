package edu.example.bughunters.dao;

import edu.example.bughunters.domain.CommentDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface CommentDAO {
    List<CommentDTO> selectComments(@Param("communityId") int communityId);
    List<CommentDTO> selectCommentsPaged(
            @Param("communityId") int communityId,
            @Param("offset") int offset,
            @Param("limit") int limit
        );
    int countComments(@Param("communityId") int communityId);

    int insertComment(CommentDTO dto);
    int updateComment(CommentDTO dto);
    int deleteComment(@Param("commentId") int commentId,
                      @Param("userId") int userId);

    int deleteCommentsByCommunity(@Param("communityId") int communityId);
    
    //마이페이지 넣기용
    int countCommentsByUser(@Param("userId") int userId);

    List<CommentDTO> selectCommentsByUser(@Param("userId") int userId,
                                          @Param("offset") int offset,
                                          @Param("size") int size);
}
