package com.pulseengage.backend.api.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import com.pulseengage.backend.domain.model.User;

/**
 * External-facing user representation. Excludes {@code keycloakId} so we don't
 * leak the IdP linkage over the wire.
 */
public record UserDto(
        UUID id,
        String email,
        String name,
        String department,
        String team,
        Integer totalPoints,
        Integer level,
        Integer trustScore,
        LocalDateTime joinedAt
) {
    public static UserDto from(User u) {
        return new UserDto(
                u.getId(),
                u.getEmail(),
                u.getName(),
                u.getDepartment(),
                u.getTeam(),
                u.getTotalPoints(),
                u.getLevel(),
                u.getTrustScore(),
                u.getJoinedAt()
        );
    }
}
