package com.pulseengage.backend.api.controller;

import com.pulseengage.backend.api.dto.UserDto;
import com.pulseengage.backend.domain.repository.UserRepository;
import com.pulseengage.backend.exception.NotFoundException;
import java.util.List;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** Read-only user endpoints. Mutations go through Keycloak / admin tooling. */
@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /** Returns the profile of the currently authenticated user. */
    @GetMapping("/me")
    public UserDto getCurrentUser(@AuthenticationPrincipal Jwt jwt) {
        final String keycloakId = jwt.getSubject();
        return userRepository
                .findByKeycloakId(keycloakId)
                .map(UserDto::from)
                .orElseThrow(() -> new NotFoundException("User not found for subject: " + keycloakId));
    }

    /** Returns the full directory (paged endpoint to follow in V6). */
    @GetMapping
    public List<UserDto> getAllUsers() {
        return userRepository.findAll().stream().map(UserDto::from).toList();
    }
}
