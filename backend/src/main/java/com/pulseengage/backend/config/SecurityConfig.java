package com.pulseengage.backend.config;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Stream;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.convert.converter.Converter;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

/**
 * Pulse Engage HTTP security policy.
 *
 * <p>This is a stateless OAuth2 resource server (JWT) — every request must
 * carry a Bearer token issued by Keycloak. CSRF is disabled because there are
 * no session cookies; clients use Authorization headers exclusively.
 *
 * <p>Authorisation rules:
 * <ul>
 *   <li>{@code /actuator/health}, {@code /actuator/info} &mdash; anonymous (load-balancer probes)</li>
 *   <li>{@code /actuator/prometheus} &mdash; anonymous (scrape target; restrict via network policy in prod)</li>
 *   <li>{@code /api/public/**} &mdash; anonymous (public reads only; never mutating)</li>
 *   <li>{@code /api/admin/**} &mdash; ROLE_ADMIN required</li>
 *   <li>Everything else &mdash; authenticated user required</li>
 * </ul>
 *
 * <p>JWT &rarr; authorities mapping is performed by
 * {@link KeycloakRealmRolesConverter} which pulls the {@code realm_access.roles}
 * claim out of the Keycloak token (the default Spring converter only reads
 * {@code scope}). Realm roles are exposed as Spring {@code ROLE_*} authorities so
 * {@link org.springframework.security.access.prepost.PreAuthorize @PreAuthorize("hasRole('ADMIN')")}
 * works out of the box.
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    @Value("${pulse.cors.allowed-origins:http://localhost:3000,http://localhost:5060}")
    private String allowedOriginsCsv;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers(HttpMethod.GET, "/actuator/health", "/actuator/health/**",
                        "/actuator/info", "/actuator/prometheus").permitAll()
                .requestMatchers("/api/public/**").permitAll()
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .anyRequest().authenticated()
            )
            .oauth2ResourceServer(oauth2 -> oauth2.jwt(jwt ->
                jwt.jwtAuthenticationConverter(jwtAuthenticationConverter())
            ));

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        final var configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(parseAllowedOrigins(allowedOriginsCsv));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("Authorization", "Content-Type", "Accept", "X-Request-Id"));
        configuration.setExposedHeaders(List.of("Location", "X-Request-Id"));
        configuration.setAllowCredentials(false); // We use Bearer tokens, never cookies.
        configuration.setMaxAge(3600L);

        final var source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    private List<String> parseAllowedOrigins(String csv) {
        if (csv == null || csv.isBlank()) {
            return List.of();
        }
        return Stream.of(csv.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toList();
    }

    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverter() {
        final var scopesConverter = new JwtGrantedAuthoritiesConverter();
        final var realmRolesConverter = new KeycloakRealmRolesConverter();

        final var converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(jwt -> {
            final var all = new ArrayList<GrantedAuthority>();
            all.addAll(scopesConverter.convert(jwt));
            all.addAll(realmRolesConverter.convert(jwt));
            return all;
        });
        return converter;
    }

    /**
     * Extracts realm roles from a Keycloak access token's {@code realm_access.roles}
     * claim and re-emits them as Spring {@code ROLE_*} authorities.
     *
     * <p>The default {@link JwtGrantedAuthoritiesConverter} only knows about
     * the {@code scope} / {@code scp} claim — Keycloak realm roles live elsewhere.
     */
    static class KeycloakRealmRolesConverter
            implements Converter<Jwt, Collection<GrantedAuthority>> {

        @Override
        public Collection<GrantedAuthority> convert(Jwt jwt) {
            final var realmAccess = jwt.getClaim("realm_access");
            if (!(realmAccess instanceof Map<?, ?> map)) {
                return List.of();
            }
            final var roles = map.get("roles");
            if (!(roles instanceof Collection<?> collection)) {
                return List.of();
            }
            return collection.stream()
                    .filter(String.class::isInstance)
                    .map(String.class::cast)
                    .map(role -> (GrantedAuthority) new SimpleGrantedAuthority("ROLE_" + role.toUpperCase()))
                    .toList();
        }
    }

    /**
     * Marker type used by tests via {@link AbstractAuthenticationToken} mocks.
     * Not strictly required at runtime; kept for documentation purposes.
     */
    @SuppressWarnings("unused")
    private static final Class<?> AUTH_TOKEN_TYPE = AbstractAuthenticationToken.class;
}
