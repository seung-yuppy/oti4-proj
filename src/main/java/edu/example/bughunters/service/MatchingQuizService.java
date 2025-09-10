package edu.example.bughunters.service;

import edu.example.bughunters.dao.MatchingQuizDAO;
import edu.example.bughunters.dao.MatchingResultDAO;
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
        if (quizzes.isEmpty()) return quizzes;

        List<Long> quizIds = quizzes.stream()
                .map(MatchingQuizDTO::getMatchingQuizId)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        List<MatchingAnswerDTO> answers = Optional.ofNullable(quizDAO.selectAnswersByQuizIds(quizIds))
                                                  .orElse(Collections.emptyList());

        Map<Long, List<MatchingAnswerDTO>> answersByQuizId =
                answers.stream().collect(Collectors.groupingBy(MatchingAnswerDTO::getMatchingQuizId));

        for (MatchingQuizDTO q : quizzes) {
            q.setAnswers(answersByQuizId.getOrDefault(q.getMatchingQuizId(), Collections.emptyList()));
        }

        quizzes.sort((a, b) ->
                Integer.compare(CATEGORIES.indexOf(a.getQuizCategory()), CATEGORIES.indexOf(b.getQuizCategory())));
        return quizzes;
    }

    @Transactional
    public void saveQuizResult(MatchingResultDTO curr) {
        if (curr.getUserId() == null) curr.setUserId(1L);

        Integer isQuiz = resultDao.selectIsQuizByUserId(curr.getUserId());
        if (isQuiz == null) throw new IllegalStateException("유저 없음");

        if (isQuiz == 0) {
            resultDao.insertResult(curr);
            resultDao.setIsQuizTrue(curr.getUserId());
        } else {
            MatchingResultDTO prev = resultDao.selectResultByUserId(curr.getUserId());
            if (prev == null) {
                resultDao.insertResult(curr);
            } else {
                MatchingResultDTO avg = averageResults(prev, curr); 
                resultDao.updateResultByUserId(avg);
            }
        }
    }

    /** 이전 결과와 현재 결과를 0.5/0.5 평균으로 합산 */
    public MatchingResultDTO averageResults(MatchingResultDTO prev, MatchingResultDTO curr) {
        MatchingResultDTO r = new MatchingResultDTO();
        r.setUserId(curr.getUserId());

        double pA = nz(prev.getActivityScore()),     cA = nz(curr.getActivityScore());
        double pS = nz(prev.getSociabilityScore()),  cS = nz(curr.getSociabilityScore());
        double pD = nz(prev.getDependencyScore()),   cD = nz(curr.getDependencyScore());
        double pT = nz(prev.getTrainabilityScore()), cT = nz(curr.getTrainabilityScore());
        double pG = nz(prev.getAggressionScore()),   cG = nz(curr.getAggressionScore());

        r.setActivityScore(     (pA*0.5) + (cA*0.5));
        r.setSociabilityScore(  (pS*0.5) + (cS*0.5));
        r.setDependencyScore(   (pD*0.5) + (cD*0.5));
        r.setTrainabilityScore( (pT*0.5) + (cT*0.5));
        r.setAggressionScore(   (pG*0.5) + (cG*0.5));
        return r;
    }

    @Transactional
    public List<Long> matchAndSaveTop4(Long userId) {
        MatchingResultDTO u = resultDao.selectResultByUserId(userId);
        if (u == null) throw new IllegalStateException("유저 결과가 없습니다.");

        List<PetWeightDTO> rows = resultDao.selectAllPetWeights();
        if (rows == null || rows.isEmpty()) return Collections.emptyList();

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

    /** null이면 0.0 */
    private static double nz(Double v){ return v==null?0.0:v.doubleValue(); }
}
