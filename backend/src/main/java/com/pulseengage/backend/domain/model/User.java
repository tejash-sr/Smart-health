package com.pulseengage.backend.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * Pulse Engage user. Linked 1:1 with a Keycloak identity by {@code keycloakId}
 * (the {@code sub} claim of the access token).
 */
@Entity
@Table(
        name = "users",
        indexes = {
                @Index(name = "idx_users_keycloak_id", columnList = "keycloakId", unique = true),
                @Index(name = "idx_users_email", columnList = "email", unique = true),
                @Index(name = "idx_users_department", columnList = "department")
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString(exclude = {"keycloakId"})
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(unique = true, nullable = false, length = 64)
    @NotBlank
    @Size(max = 64)
    private String keycloakId;

    @Column(unique = true, nullable = false, length = 254)
    @NotBlank
    @Email
    @Size(max = 254)
    private String email;

    @Column(nullable = false, length = 120)
    @NotBlank
    @Size(max = 120)
    private String name;

    @Column(length = 64)
    @Size(max = 64)
    private String department;

    @Column(length = 64)
    @Size(max = 64)
    private String team;

    @Column(nullable = false)
    @Builder.Default
    @Min(0)
    private Integer totalPoints = 0;

    @Column(nullable = false)
    @Builder.Default
    @Min(1)
    private Integer level = 1;

    /**
     * Trust score [0-100] from the multi-signal anti-cheat pipeline.
     * Higher means more confidence that step counts are genuine.
     */
    @Column(nullable = false)
    @Builder.Default
    @Min(0)
    private Integer trustScore = 100;

    @Column(name = "joined_at", updatable = false)
    private LocalDateTime joinedAt;

    @PrePersist
    void onCreate() {
        if (joinedAt == null) {
            joinedAt = LocalDateTime.now();
        }
    }
}
