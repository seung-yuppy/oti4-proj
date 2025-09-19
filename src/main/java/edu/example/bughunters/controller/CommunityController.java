package edu.example.bughunters.controller;

import edu.example.bughunters.domain.CommunityDTO;
import edu.example.bughunters.domain.CommentDTO;
import edu.example.bughunters.service.CommunityService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/community")
public class CommunityController {

    private final CommunityService communityService;
    
    private static boolean hasText(String s) {
        return s != null && !s.trim().isEmpty();
    }
    
    //메인 커뮤니티
    @GetMapping
    public String list(@RequestParam(required = false) String q,
                       @RequestParam(required = false) String category,
                       @RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int size,
                       Model model) {

        Map<String,Object> filters = new HashMap<>();
        if (hasText(q))        filters.put("q", q.trim());
        if (hasText(category)) filters.put("category", category.trim());

        List<CommunityDTO> items = communityService.getList(filters, page, size);
        int total = communityService.countList(filters);
        int totalPages = (int)Math.ceil((double) total / Math.max(1, size));

        model.addAttribute("list", items);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("page", page);
        model.addAttribute("size", size);
        model.addAttribute("q", q);
        model.addAttribute("category", category);
        return "community/communityMain";
    }

    // 상세 (조회수 +1)
    @GetMapping("/{id:\\d+}")
    public String detail(@PathVariable("id") int id,
            @RequestParam(defaultValue = "1") int cpage,
            @RequestParam(defaultValue = "20") int csize,
            HttpSession session,
            Model model) {
        CommunityDTO post = communityService.getDetailAndIncreaseView(id);
        if (post == null) return "redirect:/community";

        List<CommentDTO> comments = communityService.getComments(id, cpage, csize);
        int commentCount = communityService.getCommentCount(id);

        Integer loginUserId = toInt(session.getAttribute("userId"));

        boolean isAuthenticated = (loginUserId != null);
        boolean isOwner = isAuthenticated && (loginUserId == post.getUserId());

        model.addAttribute("post", post);
        model.addAttribute("comments", comments);
        model.addAttribute("commentCount", commentCount);
        model.addAttribute("cpage", cpage);
        model.addAttribute("csize", csize);
        model.addAttribute("isAuthenticated", isAuthenticated);
        model.addAttribute("isOwner", isOwner);

        return "community/communityDetail";
    }


    // 이미지 바이트 서빙
    @GetMapping("/{id}/image")
    public ResponseEntity<byte[]> image(@PathVariable("id") int id) {
        CommunityDTO post = communityService.getById(id);
        if (post == null || post.getImage() == null || post.getImage().length == 0) {
            return ResponseEntity.notFound().build();
        }
        byte[] bytes = post.getImage();
        MediaType mt = sniff(bytes); 
        return ResponseEntity.ok()
                .contentType(mt)
                .header(HttpHeaders.CACHE_CONTROL, "public, max-age=604800") 
                .body(bytes);
    }

    private MediaType sniff(byte[] b){
        if (b == null || b.length < 10) return MediaType.APPLICATION_OCTET_STREAM;
        // JPEG
        if ((b[0] & 0xFF) == 0xFF && (b[1] & 0xFF) == 0xD8) return MediaType.IMAGE_JPEG;
        // PNG
        if (b[0]==(byte)0x89 && b[1]==0x50 && b[2]==0x4E && b[3]==0x47) return MediaType.IMAGE_PNG;
        // GIF
        if (b[0]==0x47 && b[1]==0x49 && b[2]==0x46) return MediaType.IMAGE_GIF;
        return MediaType.APPLICATION_OCTET_STREAM;
    }

    // ======= 새 글 작성 =======

    // 작성 폼
    @GetMapping("/new")
    public String newForm(Model model, HttpSession session, RedirectAttributes rttr) {
        if (toInt(session.getAttribute("userId")) == null) {
            rttr.addFlashAttribute("msg", "로그인 후 이용해주세요.");
            rttr.addFlashAttribute("openLogin", true);
            return "redirect:/community"; // 홈이나 로그인 페이지로 리다이렉트
        }
        if (!model.containsAttribute("form")) {
            model.addAttribute("form", new CommunityDTO()); 
        }
        return "community/communityCreate";
    }

    // 작성 저장

    
    @PostMapping
    public String create(@ModelAttribute("form") CommunityDTO form,
                         @RequestParam(required = false) MultipartFile imageFile,
                         HttpSession session,
                         RedirectAttributes rttr,
                         Model model) throws IOException {
        Integer loginUserId = toInt(session.getAttribute("userId"));
        if (loginUserId == null) {
            rttr.addFlashAttribute("msg", "로그인 후 이용해주세요.");
            rttr.addFlashAttribute("openLogin", true);
            return "redirect:/community";
        }

        boolean noImage = (imageFile == null || imageFile.isEmpty());
        if ("PRIDE".equals(form.getCategory()) && noImage) {
            model.addAttribute("error", "내 반려동물을 자랑하는 게시판은 이미지를 반드시 업로드해야 합니다.");
            return "community/communityCreate";
        }

        form.setUserId(loginUserId);
        if (!noImage) {
            form.setImage(imageFile.getBytes());
        }

        int newId = communityService.createPost(form);
        return "redirect:/community/" + newId;
        
    }

    // ======= 글 수정 =======

    // 수정 폼
    @GetMapping("/{id:\\d+}/edit")
    public String editForm(@PathVariable("id") int id, Model model) {
        CommunityDTO post = communityService.getById(id);
        if (post == null) return "redirect:/community";
        boolean hasImage = post.getImage() != null && post.getImage().length > 0;
        model.addAttribute("post", post);
        model.addAttribute("hasImage", hasImage);
        if (!model.containsAttribute("form")) {
            model.addAttribute("form", post); 
        }
        return "community/communityUpdate";
    }

    // 수정 저장
    @PostMapping("/{id:\\d+}/edit")
    public String update(@PathVariable("id") int id,
                         @ModelAttribute("form") CommunityDTO form,
                         @RequestParam(required = false) MultipartFile imageFile,
                         @RequestParam(name = "imgAction", defaultValue = "keep") String imgAction,
                         HttpSession session, Model model) throws IOException {

        Integer loginUserId = toInt(session.getAttribute("userId"));
        if (loginUserId == null) return "redirect:/login";

        CommunityDTO current = communityService.getById(id);
        if (current == null) return "redirect:/community";

        boolean hasExisting = current.getImage() != null && current.getImage().length > 0;
        boolean isPride = "PRIDE".equals(form.getCategory());

        // PRIDE에서 삭제 금지
        if ("delete".equals(imgAction) && isPride) {
            model.addAttribute("error", "PRIDE 게시판은 이미지를 삭제할 수 없습니다.");
            model.addAttribute("post", current);
            return "community/communityUpdate";
        }

        form.setCommunityId(id);
        form.setUserId(loginUserId);

        // 교체
        if ("replace".equals(imgAction) && imageFile != null && !imageFile.isEmpty()) {
            form.setImage(imageFile.getBytes());
        }
        // keep이면 form.image 건드리지 않음

        // PRIDE 강제 검증(유지/교체 후에도 이미지가 없으면 막기)
        boolean willHaveImage = !"delete".equals(imgAction) && (
                (form.getImage() != null && form.getImage().length > 0) || hasExisting
        );
        if (isPride && !willHaveImage) {
            model.addAttribute("error", "내 반려동물을 자랑하는 게시판은 이미지를 반드시 업로드해야 합니다.");
            model.addAttribute("post", current);
            return "community/communityUpdate";
        }

        // 제목/본문(+이미지 교체시 이미지) 업데이트
        boolean ok = communityService.updatePost(form);
        if (!ok) {
            model.addAttribute("error", "수정 권한이 없거나 변경할 내용이 없습니다.");
            model.addAttribute("post", current);
            return "community/communityUpdate";
        }

        // 삭제 선택 시 실제로 NULL 처리
        if ("delete".equals(imgAction)) {
            communityService.clearPostImage(id, loginUserId);
        }

        return "redirect:/community/" + id;
    }

    // 글 삭제
    @PostMapping("/{id}/delete")
    public String delete(@PathVariable("id") int id, HttpSession session) {
        Integer loginUserId = toInt(session.getAttribute("userId"));
        if (loginUserId == null) return "redirect:/login";
        communityService.deletePost(id, loginUserId);
        return "redirect:/community";
    }

    // ---- helpers ----
    private Integer toInt(Object o) {
        if (o == null) return null;
        if (o instanceof Integer) return (Integer) o;
        if (o instanceof Long) return ((Long) o).intValue();
        try { return Integer.parseInt(String.valueOf(o)); } catch (Exception e) { return null; }
    }
    
    @PostMapping("/{id}/comments")
    public String addComment(@PathVariable("id") int id,
                             @RequestParam("content") String content,
                             HttpSession session,
                             RedirectAttributes rttr) {

        Object uid = session.getAttribute("userId");
        if (uid == null) uid = session.getAttribute("user_id");
        Integer loginUserId = null;
        if (uid instanceof Integer) loginUserId = (Integer) uid;
        else if (uid instanceof Long) loginUserId = ((Long) uid).intValue();
        else if (uid != null) { try { loginUserId = Integer.parseInt(String.valueOf(uid)); } catch (Exception ignore) {} }

        if (loginUserId == null) {
            rttr.addFlashAttribute("msg", "로그인 후 이용해주세요.");
            rttr.addFlashAttribute("openLogin", true);
            return "redirect:/home";
        }

        CommentDTO dto = new CommentDTO();
        dto.setCommunityId(id);
        dto.setUserId(loginUserId);
        dto.setContent(content);
        communityService.addComment(dto);

        return "redirect:/community/" + id;
    }
    
    //댓글삭제
    @PostMapping("/{id:\\d+}/comments/{commentId:\\d+}/delete")
    public String deleteComment(@PathVariable("id") int communityId,
                                @PathVariable("commentId") int commentId,
                                @RequestParam(defaultValue = "1") int cpage,
                                @RequestParam(defaultValue = "20") int csize,
                                HttpSession session,
                                RedirectAttributes rttr) {
        Integer loginUserId = toInt(session.getAttribute("userId"));
        if (loginUserId == null) return "redirect:/login";

        boolean ok = communityService.deleteComment(commentId, loginUserId);
        if (!ok) {
            rttr.addFlashAttribute("msg", "삭제 권한이 없거나 이미 삭제되었습니다.");
        }
        // 댓글 목록 페이지 유지
        return "redirect:/community/" + communityId + "?cpage=" + cpage + "&csize=" + csize;
    }
    
    @GetMapping(value = "/my/posts")
    @ResponseBody
    public Map<String, Object> myPosts(@RequestParam(defaultValue = "1") int page,
                                       @RequestParam(defaultValue = "5") int size,
                                       HttpSession session) {
        Integer uid = toInt(session.getAttribute("userId"));
        if (uid == null) {
            // 401을 내려주고 싶으면 ResponseEntity로 바꿔도 됨
            Map<String,Object> err = new LinkedHashMap<>();
            err.put("error", "UNAUTHORIZED");
            return err;
        }
        int total = communityService.countPostsByUser(uid);
        List<CommunityDTO> items = communityService.findPostsByUser(uid, page, size);

        Map<String,Object> res = new LinkedHashMap<>();
        res.put("items", items);
        res.put("page", page);
        res.put("size", size);
        res.put("total", total);
        res.put("hasNext", page * size < total);
        return res;
    }

    @GetMapping(value = "/my/comments")
    @ResponseBody
    public Map<String, Object> myComments(@RequestParam(defaultValue = "1") int page,
                                          @RequestParam(defaultValue = "5") int size,
                                          HttpSession session) {
        Integer uid = toInt(session.getAttribute("userId"));
        if (uid == null) {
            Map<String,Object> err = new LinkedHashMap<>();
            err.put("error", "UNAUTHORIZED");
            return err;
        }
        int total = communityService.countCommentsByUser(uid);
        List<CommentDTO> items = communityService.findCommentsByUser(uid, page, size);

        Map<String,Object> res = new LinkedHashMap<>();
        res.put("items", items);
        res.put("page", page);
        res.put("size", size);
        res.put("total", total);
        res.put("hasNext", page * size < total);
        return res;
    }


}
