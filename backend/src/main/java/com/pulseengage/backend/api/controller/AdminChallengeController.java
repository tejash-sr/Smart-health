package com.pulseengage.backend.api.controller;

import com.pulseengage.backend.api.dto.ChallengeDto;
import com.pulseengage.backend.api.dto.CreateChallengeRequest;
import com.pulseengage.backend.domain.model.Challenge;
import com.pulseengage.backend.service.ChallengeService;
import jakarta.validation.Valid;
import java.net.URI;
import java.util.UUID;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** Write-side challenge endpoints. Restricted to realm role {@code ADMIN}. */
@RestController
@RequestMapping("/api/admin/challenges")
@PreAuthorize("hasRole('ADMIN')")
public class AdminChallengeController {

    private final ChallengeService challengeService;

    public AdminChallengeController(ChallengeService challengeService) {
        this.challengeService = challengeService;
    }

    @PostMapping
    public ResponseEntity<ChallengeDto> create(@Valid @RequestBody CreateChallengeRequest req) {
        final Challenge created = challengeService.create(req);
        final URI location = URI.create("/api/challenges/" + created.getId());
        return ResponseEntity.created(location).body(ChallengeDto.from(created));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable UUID id) {
        challengeService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
