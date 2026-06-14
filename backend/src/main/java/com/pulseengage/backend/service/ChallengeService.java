package com.pulseengage.backend.service;

import com.pulseengage.backend.api.dto.CreateChallengeRequest;
import com.pulseengage.backend.domain.model.Challenge;
import com.pulseengage.backend.domain.repository.ChallengeRepository;
import com.pulseengage.backend.exception.NotFoundException;
import com.pulseengage.backend.exception.ValidationException;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/** Business logic for {@link Challenge} aggregates. */
@Service
@Transactional(readOnly = true)
public class ChallengeService {

    private final ChallengeRepository challengeRepository;

    public ChallengeService(ChallengeRepository challengeRepository) {
        this.challengeRepository = challengeRepository;
    }

    public List<Challenge> findAllActive() {
        return challengeRepository.findActiveOrderByEndDate(Challenge.Status.ACTIVE);
    }

    public Challenge findById(UUID id) {
        return challengeRepository
                .findById(id)
                .orElseThrow(() -> new NotFoundException("Challenge not found: " + id));
    }

    @Transactional
    public Challenge create(CreateChallengeRequest req) {
        if (!req.endDate().isAfter(req.startDate())) {
            throw new ValidationException("endDate must be after startDate");
        }
        final Challenge c = new Challenge();
        c.setTitle(req.title());
        c.setDescription(req.description());
        c.setType(req.type());
        c.setFrequency(req.frequency());
        c.setTargetValue(req.targetValue());
        c.setPointsReward(req.pointsReward());
        c.setStartDate(req.startDate());
        c.setEndDate(req.endDate());
        c.setStatus(Challenge.Status.ACTIVE);
        return challengeRepository.save(c);
    }

    @Transactional
    public void delete(UUID id) {
        if (!challengeRepository.existsById(id)) {
            throw new NotFoundException("Challenge not found: " + id);
        }
        challengeRepository.deleteById(id);
    }
}
