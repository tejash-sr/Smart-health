package com.pulseengage.backend.api.controller;

import static org.mockito.BDDMockito.given;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.jwt;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.pulseengage.backend.config.SecurityConfig;
import com.pulseengage.backend.domain.model.Challenge;
import com.pulseengage.backend.service.ChallengeService;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;

/** Slice tests for {@link ChallengeController}. */
@WebMvcTest(ChallengeController.class)
@Import(SecurityConfig.class)
class ChallengeControllerTest {

    @Autowired private MockMvc mockMvc;

    @MockBean private ChallengeService challengeService;

    @Test
    void list_anonymous_returns401() throws Exception {
        mockMvc.perform(get("/api/challenges")).andExpect(status().isUnauthorized());
    }

    @Test
    void list_authenticated_returnsActiveChallenges() throws Exception {
        final Challenge c = new Challenge();
        c.setId(UUID.randomUUID());
        c.setTitle("10k Steps Sprint");
        c.setDescription("Walk 10,000 steps every day this week.");
        c.setType(Challenge.Type.STEPS);
        c.setFrequency(Challenge.Frequency.DAILY);
        c.setTargetValue(10_000);
        c.setPointsReward(50);
        c.setStartDate(LocalDate.now());
        c.setEndDate(LocalDate.now().plusDays(7));
        c.setStatus(Challenge.Status.ACTIVE);

        given(challengeService.findAllActive()).willReturn(List.of(c));

        mockMvc.perform(get("/api/challenges").with(jwt()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].title").value("10k Steps Sprint"))
                .andExpect(jsonPath("$[0].type").value("STEPS"));
    }
}
