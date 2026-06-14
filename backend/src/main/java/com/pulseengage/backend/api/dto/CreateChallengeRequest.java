package com.pulseengage.backend.api.dto;

import java.time.LocalDate;

import com.pulseengage.backend.domain.model.Challenge;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/** Admin-only payload for creating a new challenge. */
public record CreateChallengeRequest(
        @NotBlank @Size(max = 120) String title,
        @Size(max = 1000) String description,
        @NotNull Challenge.Type type,
        @NotNull Challenge.Frequency frequency,
        @Min(1) int targetValue,
        @Min(0) int pointsReward,
        @Size(max = 32) String unit,
        @NotNull LocalDate startDate,
        @NotNull LocalDate endDate
) {}
