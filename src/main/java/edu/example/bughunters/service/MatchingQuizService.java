package edu.example.bughunters.service;

import edu.example.bughunters.dao.MatchingQuizDAO;
import edu.example.bughunters.dao.MatchingResultDAO;
import edu.example.bughunters.domain.AbandonedPetDTO;
import edu.example.bughunters.domain.MatchingAnswerDTO;
import edu.example.bughunters.domain.MatchingQuizDTO;
import edu.example.bughunters.domain.MatchingResultDTO;
import edu.example.bughunters.domain.PetWeightDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MatchingQuizService {

    private final MatchingQuizDAO quizDAO;
    private final MatchingResultDAO resultDao;

    private static final List<String> CATEGORIES = Arrays.asList("ACT", "SOC", "DEP", "TRN", "AGG");

    @Transactional(readOnly = true)
    public List<MatchingQuizDTO> getRandomEach() {
        List<MatchingQuizDTO> quizzes = new ArrayList<>();
        for (String cat : CATEGORIES) {
            MatchingQuizDTO q = quizDAO.selectRandomQuiz(cat);
            if (q != null) quizzes.add(q);
        }
        
        List<Long> quizIds = new ArrayList<>();

        for (MatchingQuizDTO q : quizzes) {
            Long id = q.getMatchingQuizId();
            if (id != null) {
                quizIds.add(id);
            }
        }
        /*List<Long> quizIds = quizzes.stream()
                .map(MatchingQuizDTO::getMatchingQuizId)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());*/

        List<MatchingAnswerDTO> answers = quizDAO.selectAnswersByQuizIds(quizIds);

        /*Map<Long, List<MatchingAnswerDTO>> answersByQuizId =
                answers.stream().collect(Collectors.groupingBy(MatchingAnswerDTO::getMatchingQuizId));*/
        
        Map<Long, List<MatchingAnswerDTO>> answersByQuizId = new HashMap<>();
        for (MatchingAnswerDTO ans : answers) {
            Long quizId = ans.getMatchingQuizId();
            if (answersByQuizId.containsKey(quizId)) {
                answersByQuizId.get(quizId).add(ans);
            } else {
                List<MatchingAnswerDTO> list = new ArrayList<>();
                list.add(ans);
                answersByQuizId.put(quizId, list);
            }
        }
        for (MatchingQuizDTO q : quizzes) {
        	q.setAnswers(answersByQuizId.get(q.getMatchingQuizId()));
        }
        
        return quizzes;
    }

    /*매칭 퀴즈 결과 저장*/
    @Transactional
    public void saveQuizResult(MatchingResultDTO curr) {
    	
        Integer isQuiz = resultDao.selectIsQuizByUserId(curr.getUserId());

        MatchingResultDTO prev = resultDao.selectResultByUserId(curr.getUserId());
        
        if (prev == null) {
            curr.setCountNum(1);
            resultDao.insertResult(curr);
            if (isQuiz == 0) {
                resultDao.setIsQuizTrue(curr.getUserId());
            }
            return;
        }

        MatchingResultDTO avg = averageResults(prev, curr);
        resultDao.updateResultByUserId(avg);
    }
   

    /** 이전 결과와 현재 결과를 평균으로 합산 */
    public MatchingResultDTO averageResults(MatchingResultDTO prev, MatchingResultDTO curr) {
        MatchingResultDTO r = new MatchingResultDTO();
        r.setUserId(curr.getUserId());
        int n = prev.getCountNum();
        
        double pA = nz(prev.getActivityScore()),     cA = nz(curr.getActivityScore());
        double pS = nz(prev.getSociabilityScore()),  cS = nz(curr.getSociabilityScore());
        double pD = nz(prev.getDependencyScore()),   cD = nz(curr.getDependencyScore());
        double pT = nz(prev.getTrainabilityScore()), cT = nz(curr.getTrainabilityScore());
        double pG = nz(prev.getAggressionScore()),   cG = nz(curr.getAggressionScore());

        r.setActivityScore(     ((pA*n)+cA)/(n+1));
        r.setSociabilityScore(  ((pS*n)+cS)/(n+1));
        r.setDependencyScore(   ((pD*n)+cD)/(n+1));
        r.setTrainabilityScore( ((pT*n)+cT)/(n+1));
        r.setAggressionScore(   ((pG*n)+cG)/(n+1));
        
        r.setCountNum(n + 1);
        return r;
    }
    
    
    /*매칭결과계산(+상위4마리저장)*/
    @Transactional
    public List<Long> matchAndSaveTop4(Long userId) {
        MatchingResultDTO u = resultDao.selectResultByUserId(userId);
        if (u == null) throw new IllegalStateException("유저 결과가 없습니다.");

        List<PetWeightDTO> rows = resultDao.selectAllPetWeights();

        class PS { Long id; double s; PS(Long i,double sc){id=i;s=sc;} }
        List<PS> scores = new ArrayList<>(rows.size());

        for (PetWeightDTO p : rows) {
            double dAct = nz(p.getActivityWeight())    - nz(u.getActivityScore());
            double dSoc = nz(p.getSociabilityWeight()) - nz(u.getSociabilityScore());
            double dDep = nz(p.getDependencyWeight())  - nz(u.getDependencyScore());
            double dTrn = nz(p.getTrainabilityWeight())- nz(u.getTrainabilityScore());
            double dAgg = nz(p.getAggressionWeight())  - nz(u.getAggressionScore());

            double base = Math.sqrt(
                dAct*dAct + dSoc*dSoc + dDep*dDep
            );
            double penTrn = Math.pow(Math.max(0.0, -dTrn), 2);
            double penAgg = Math.pow(Math.max(0.0,  dAgg), 2);

            scores.add(new PS(p.getAbandonedPetId(), base + penTrn + penAgg));
        }

        // 점수 오름차순, 동점이면 ID 오름차순
        scores.sort(Comparator.<PS>comparingDouble(ps -> ps.s).thenComparingLong(ps -> ps.id));

        List<Long> topIds = scores.stream()
                .limit(4)
                .map(ps -> ps.id)
                .collect(Collectors.toList());

        // 기존 TOP-4 삭제 후 새로 저장
        resultDao.deleteTopMatchesByUserId(userId);
        for (int i = 0; i < topIds.size(); i++) {
            resultDao.insertTopMatch(userId, i + 1, topIds.get(i));
        }
        return topIds;
    }
    
    //퀴즈 완료 여부 
    @Transactional(readOnly = true)
    public boolean hasFinishedQuiz(Long userId) {
        Integer v = resultDao.selectIsQuizByUserId(userId);
        return v != null && v == 1;
    }

    //카드 데이터 로드
    @Transactional(readOnly = true)
    public List<AbandonedPetDTO> loadTop4Cards(Long userId) {
        List<AbandonedPetDTO> list = resultDao.selectTop4PetsForCard(userId);
        if (list == null) return Collections.emptyList();
        list.forEach(this::processAbandonedPetData);
        return list;
    }
    
    public void processAbandonedPetData(AbandonedPetDTO dto) {
        // 견종
        if (dto.getKind() != null && dto.getKind().contains("빠삐용")) {
            dto.setKind("빠삐용");
        }
        // 성별
        if (dto.getGender() != null) {
            if ("M".equals(dto.getGender())) dto.setGender("수컷");
            else if ("F".equals(dto.getGender())) dto.setGender("암컷");
            else dto.setGender("미상");
        }
        // 위치
        if (dto.getAddress() != null && dto.getAddress().contains("전북")) {
            dto.setAddress("전라북도");
        }
    }

    /** null이면 0.0 */
    private static double nz(Double v){ return v==null?0.0:v.doubleValue(); }
}
