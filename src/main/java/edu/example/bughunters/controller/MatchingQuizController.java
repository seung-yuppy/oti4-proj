package edu.example.bughunters.controller;

import com.fasterxml.jackson.databind.ObjectMapper;

import edu.example.bughunters.domain.AbandonedPetDTO;
import edu.example.bughunters.domain.MatchingQuizDTO;
import edu.example.bughunters.domain.MatchingResultDTO;
import edu.example.bughunters.service.MatchingQuizService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/matchingQuiz")
public class MatchingQuizController {

    private final MatchingQuizService quizService;

    @GetMapping
    public String getRandomQuizzes(Model model, HttpSession session, RedirectAttributes rttr) throws Exception {
        // 로그인 가드 (세션 키: "userId")
        if (toLong(session.getAttribute("userId")) == null) {
            rttr.addFlashAttribute("msg", "로그인 후 이용해주세요.");
            rttr.addFlashAttribute("openLogin", true);
            return "redirect:/home";
        }

        List<MatchingQuizDTO> quizzes = quizService.getRandomEach();
        ObjectMapper objectMapper = new ObjectMapper();
        String questionsJson = objectMapper.writeValueAsString(quizzes);
        model.addAttribute("questionsJson", questionsJson);
        return "matching/matchingQuiz";
    }
    
    @GetMapping("/result")
    public String showResultPage(Model model, HttpSession session, RedirectAttributes rttr) {
        Long userId = toLong(session.getAttribute("userId"));
        if (userId == null) {
            rttr.addFlashAttribute("msg", "로그인 후 이용해주세요.");
            rttr.addFlashAttribute("openLogin", true);
            return "redirect:/home";
        }

        boolean finished = quizService.hasFinishedQuiz(userId);
        model.addAttribute("finishedQuiz", finished);

        if (finished) {
            List<AbandonedPetDTO> topPets = quizService.loadTop4Cards(userId);
            model.addAttribute("topPets", topPets);
        }
        return "matching/matchingResult";
    }

    @PostMapping("/result")
    public String processResult(@RequestParam("answers") String answersJson,
                                Model model,
                                HttpSession session,
                                RedirectAttributes rttr) throws Exception {

        // 로그인 가드 (세션 키: "userId")
        Long userId = toLong(session.getAttribute("userId"));
        if (userId == null) {
            rttr.addFlashAttribute("msg", "로그인 후 이용해주세요.");
            rttr.addFlashAttribute("openLogin", true);
            return "redirect:/home";
        }

        // JSON 파싱
        ObjectMapper mapper = new ObjectMapper();
        List<AnswerItem> items = mapper.readValue(
                answersJson,
                mapper.getTypeFactory().constructCollectionType(List.class, AnswerItem.class)
        );
        
        //DTO 구성
        MatchingResultDTO dto = new MatchingResultDTO();
        dto.setUserId(userId);

        for (AnswerItem it : items) {
            if (it == null || it.type == null) continue;
            double v = (it.value == null ? 0.0 : it.value); // 기본값

            switch (it.type) {
                case "ACT": dto.setActivityScore(v);     break;
                case "SOC": dto.setSociabilityScore(v);  break;
                case "DEP": dto.setDependencyScore(v);   break;
                case "TRN": dto.setTrainabilityScore(v); break;
                case "AGG": dto.setAggressionScore(v);   break;
            }
        }

        // 저장 + TOP-4 매칭 저장 
        quizService.saveQuizResult(dto);
        quizService.matchAndSaveTop4(userId);

        // 뷰 
        List<AbandonedPetDTO> topPets = quizService.loadTop4Cards(userId);
        model.addAttribute("result", dto);
        model.addAttribute("topPets", topPets);
        model.addAttribute("finishedQuiz", true);

        return "matching/matchingResult";
    }
    
    @GetMapping("/result_after")
    public String showResultPage_after(Model model, HttpSession session, RedirectAttributes rttr) {
        Long userId = toLong(session.getAttribute("userId"));
        if (userId == null) {
            rttr.addFlashAttribute("msg", "로그인 후 이용해주세요.");
            rttr.addFlashAttribute("openLogin", true);
            return "redirect:/home";
        }

        boolean finished = quizService.hasFinishedQuiz(userId);
        model.addAttribute("finishedQuiz", finished);

        if (finished) {
            List<AbandonedPetDTO> topPets = quizService.loadTop4Cards(userId);
            model.addAttribute("topPets", topPets);
        }
        return "matching/matchingResult_after";
    }

    // ----- helpers -----
    public static class AnswerItem {
        public String type;   
        public Double value;  
    }

    /** 세션 값 타입 안전 변환 (Integer/Long/BigDecimal/String 모두 대응) */
    private static Long toLong(Object v) {
        if (v == null) return null;
        if (v instanceof Long) return (Long) v;
        if (v instanceof Integer) return ((Integer) v).longValue();
        if (v instanceof BigDecimal) return ((BigDecimal) v).longValue();
        if (v instanceof String) try { return Long.parseLong((String) v); } catch (Exception ignored) {}
        return null;
    }
    
    
}
