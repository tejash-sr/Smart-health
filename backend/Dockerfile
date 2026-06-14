# syntax=docker/dockerfile:1.7
# ──────────────────────────────────────────────────────────────────────────────
# Pulse Engage backend — multi-stage build (Temurin 21)
# ──────────────────────────────────────────────────────────────────────────────

# ─── Build stage ──────────────────────────────────────────────────────────────
FROM eclipse-temurin:21-jdk-jammy AS build

WORKDIR /workspace

# Copy wrapper + build metadata first to leverage Docker layer cache
COPY gradle gradle
COPY gradlew gradlew
COPY build.gradle settings.gradle ./
RUN chmod +x gradlew && ./gradlew --no-daemon dependencies > /dev/null 2>&1 || true

# Now copy sources and build
COPY src src
RUN ./gradlew --no-daemon clean bootJar -x test

# ─── Runtime stage ────────────────────────────────────────────────────────────
FROM eclipse-temurin:21-jre-jammy AS runtime

# Non-root user
RUN groupadd --system pulse && useradd --system --gid pulse --shell /bin/false pulse

WORKDIR /app

# Bring the fat jar over with a stable name
COPY --from=build /workspace/build/libs/pulse-backend.jar /app/app.jar
RUN chown -R pulse:pulse /app

USER pulse

EXPOSE 8080

# Container-aware JVM defaults; can be overridden via JAVA_OPTS env var.
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75 -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom"

HEALTHCHECK --interval=30s --timeout=5s --start-period=45s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health | grep -q '"status":"UP"' || exit 1

ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -jar /app/app.jar"]
