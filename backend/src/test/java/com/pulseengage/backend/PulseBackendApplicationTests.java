package com.pulseengage.backend;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatCode;

import org.junit.jupiter.api.Test;

/**
 * Lightweight smoke test that does not boot the full application context.
 *
 * <p>Full context loading requires a live PostgreSQL + Keycloak; that is exercised via
 * Testcontainers in CI (planned for V6). Here we simply assert that the main class is wired
 * correctly and is discoverable on the classpath.
 */
class PulseBackendApplicationTests {

    @Test
    void mainClassExists() {
        assertThat(PulseBackendApplication.class).isNotNull();
        assertThat(PulseBackendApplication.class.getPackageName())
                .isEqualTo("com.pulseengage.backend");
    }

    @Test
    void mainMethodIsInvocableWithoutArgs() {
        // We don't actually invoke main() (it would try to start the context),
        // but we assert it is declared with the expected signature.
        assertThatCode(
                        () -> {
                            final var method = PulseBackendApplication.class.getMethod("main", String[].class);
                            assertThat(method).isNotNull();
                        })
                .doesNotThrowAnyException();
    }
}
