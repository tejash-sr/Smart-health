package com.pulseengage.backend.domain.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.pulseengage.backend.domain.model.Challenge;
import com.pulseengage.backend.domain.model.Challenge.Status;

public interface ChallengeRepository extends JpaRepository<Challenge, UUID> {

    /**
     * Active challenges ordered by end date ascending (the canonical "what's
     * ending soon" listing for the Flutter home screen). Explicit JPQL avoids
     * Hibernate's composite-index quirks on Postgres while still using
     * idx_challenges_status_end_date for the lookup.
     */
    @Query("""
            select c from Challenge c
            where c.status = :status
            order by c.endDate asc
            """)
    List<Challenge> findActiveOrderByEndDate(@Param("status") Status status);
}
