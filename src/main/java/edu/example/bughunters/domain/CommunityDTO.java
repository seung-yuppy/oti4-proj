package edu.example.bughunters.domain;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CommunityDTO {
    private int communityId;  
    private String title;
    private String content;
    private byte[] image;
    private String category;
    private Date createdAt;
    private int viewcount;
    private int userId;
    private String nickname;
    private int commentCount;
}
