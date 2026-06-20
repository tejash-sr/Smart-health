package com.pulseengage.backend.domain.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** A wellness / engagement challenge created by an admin. */
@Entity
@Table(
        name = "challenges",
        indexes = {
                @Index(name = "idx_challenges_status_end_date", columnList = "status, end_date")
        }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Challenge {

    public enum Type { INDIVIDUAL, TEAM, DEPARTMENT }
    public enum Frequency { DAILY, WEEKLY, MONTHLY }
    public enum Status { DRAFT, ACTIVE, COMPLETED, ARCHIVED }

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 120)
    @NotBlank
    @Size(max = 120)
    private String title;

    @Column(length = 1000)
    @Size(max = 1000)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    @NotNull
    private Type type;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    @NotNull
    private Frequency frequency;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    @Builder.Default
    private Status status = Status.DRAFT;

    @Column(name = "target_value", nullable = false)
    @Min(1)
    private int targetValue;

    @Column(length = 32)
    @Size(max = 32)
    private String unit;

    @Column(name = "points_reward", nullable = false)
    @Min(0)
    private int pointsReward;

    @Column(name = "start_date", nullable = false)
    @NotNull
    private LocalDate startDate;

    @Column(name = "end_date", nullable = false)
    @NotNull
    private LocalDate endDate;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    void onCreate() {
        final var now = LocalDateTime.now();
        createdAt = now;
        updatedAt = now;
    }

    @PreUpdate
    void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
