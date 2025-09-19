package edu.example.bughunters.domain;

import java.util.Date;
import lombok.*;

@Getter 
@Setter
@NoArgsConstructor 
@AllArgsConstructor 
@Builder
public class CommentDTO {
    private int commentId;
    private String content;
    private Date createdAt;
    private int userId; 
    private int communityId; 
    private String nickname;
    
    private String  title;
}

