package com.pulseengage.backend.api.dto;

import java.time.LocalDate;
import java.util.UUID;

import com.pulseengage.backend.domain.model.Challenge;

public record ChallengeDto(
        UUID id,
        String title,
        String description,
        String type,
        String frequency,
        String status,
        int targetValue,
        String unit,
        int pointsReward,
        LocalDate startDate,
        LocalDate endDate
) {
    public static ChallengeDto from(Challenge c) {
        return new ChallengeDto(
                c.getId(),
                c.getTitle(),
                c.getDescription(),
                c.getType().name(),
                c.getFrequency().name(),
                c.getStatus().name(),
                c.getTargetValue(),
                c.getUnit(),
                c.getPointsReward(),
                c.getStartDate(),
                c.getEndDate()
        );
    }
}
