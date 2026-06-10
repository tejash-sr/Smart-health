package com.pulseengage.backend.domain.model;

import jakarta.persistence.*;
import lombok.*;
import java.util.UUID;
import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    
    @Column(unique = true, nullable = false)
    private String keycloakId;
    
    @Column(unique = true, nullable = false)
    private String email;
    
    private String name;
    private String department;
    private String team;
    
    @Builder.Default
    private Integer totalPoints = 0;
    
    @Builder.Default
    private Integer level = 1;

    @Column(name = "joined_at", updatable = false)
    private LocalDateTime joinedAt;

    @PrePersist
    protected void onCreate() {
        if (joinedAt == null) {
            joinedAt = LocalDateTime.now();
        }
    }
}
