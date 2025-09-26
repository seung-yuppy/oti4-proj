package edu.example.bughunters.dao;

import edu.example.bughunters.domain.CommunityDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface CommunityDAO {
    CommunityDTO selectById(@Param("communityId") int communityId);
    List<CommunityDTO> selectList(Map<String, Object> params);
    int increaseViewcount(@Param("communityId") int communityId);

    int insertCommunity(CommunityDTO dto);
    int updateCommunity(CommunityDTO dto);
    int deleteCommunity(@Param("communityId") int communityId,
                        @Param("userId") int userId);
    int countList(Map<String, Object> params);
    int clearImage(@Param("communityId") int communityId,
            @Param("userId") int userId);

    //마이페이지 넣기용
    int countPostsByUser(@Param("userId") int userId);

    List<CommunityDTO> selectPostsByUser(@Param("userId") int userId,
                                         @Param("offset") int offset,
                                         @Param("size") int size);
}
