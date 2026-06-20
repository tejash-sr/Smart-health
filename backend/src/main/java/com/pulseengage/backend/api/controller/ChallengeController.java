package com.pulseengage.backend.api.controller;

import com.pulseengage.backend.api.dto.ChallengeDto;
import com.pulseengage.backend.service.ChallengeService;
import java.util.List;
import java.util.UUID;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** Read-only challenge endpoints exposed to all authenticated users. */
@RestController
@RequestMapping("/api/challenges")
public class ChallengeController {

    private final ChallengeService challengeService;

    public ChallengeController(ChallengeService challengeService) {
        this.challengeService = challengeService;
    }

    @GetMapping
    public List<ChallengeDto> list() {
        return challengeService.findAllActive().stream().map(ChallengeDto::from).toList();
    }

    @GetMapping("/{id}")
    public ChallengeDto get(@PathVariable UUID id) {
        return ChallengeDto.from(challengeService.findById(id));
    }
}
