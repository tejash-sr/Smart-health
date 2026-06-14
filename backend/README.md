# Pulse Engage — Backend

Production-grade Spring Boot 3 service powering the Pulse Engage employee
engagement & wellness platform.

## Stack

| Layer          | Choice                                        |
| -------------- | --------------------------------------------- |
| Language       | Java 21 (Temurin)                             |
| Framework      | Spring Boot 3.3.5                             |
| Build          | Gradle 8.10.2 (wrapper)                       |
| Persistence    | PostgreSQL 15 + Spring Data JPA / Hibernate   |
| Identity       | Keycloak 23 (OAuth2 / OIDC, realm roles)      |
| Connection pool| HikariCP                                      |
| Validation     | Jakarta Bean Validation                       |
| Observability  | Spring Boot Actuator + Micrometer (Prometheus)|
| Container      | Multi-stage Dockerfile (JDK 21 → JRE 21)      |
| Orchestration  | docker compose (postgres + keycloak + app)    |

## Quickstart (Docker)

```bash
# from repo root
cd backend
docker compose up -d --build
```

Services exposed:

| Service   | URL                                  | Notes                            |
| --------- | ------------------------------------ | -------------------------------- |
| Backend   | http://localhost:8080                | API + actuator                   |
| Keycloak  | http://localhost:8081                | admin / admin (change in prod)   |
| Postgres  | localhost:5432                       | `pulse_user` / `pulse_password`  |

Health endpoints:

```bash
curl http://localhost:8080/actuator/health
curl http://localhost:8080/actuator/info
curl http://localhost:8080/actuator/prometheus
```

## Quickstart (local JVM)

```bash
cd backend
./gradlew bootRun
```

The app expects a Postgres on `localhost:5432` and a Keycloak realm called
`pulse` reachable at `http://localhost:8081`. Override via env vars (see
[Configuration](#configuration)).

## Configuration

All knobs are env-driven. Defaults are dev-safe; **override in production**.

| Env var                          | Default                                                       | Purpose                                  |
| -------------------------------- | ------------------------------------------------------------- | ---------------------------------------- |
| `SPRING_PROFILES_ACTIVE`         | `dev`                                                         | `dev` enables SQL logging                |
| `PULSE_DB_URL`                   | `jdbc:postgresql://localhost:5432/pulse_db`                   | JDBC URL                                 |
| `PULSE_DB_USERNAME`              | `pulse_user`                                                  | DB user                                  |
| `PULSE_DB_PASSWORD`              | `pulse_password`                                              | DB password                              |
| `PULSE_KEYCLOAK_ISSUER_URI`      | `http://localhost:8081/realms/pulse`                          | OAuth2 issuer                            |
| `PULSE_KEYCLOAK_JWK_SET_URI`     | `http://localhost:8081/realms/pulse/protocol/openid-connect/certs` | JWK URI                              |
| `PULSE_CORS_ALLOWED_ORIGINS`     | `http://localhost:3000,http://localhost:5060`                 | Comma-separated CORS origins             |
| `JAVA_OPTS`                      | `-XX:MaxRAMPercentage=75 -XX:+ExitOnOutOfMemoryError ...`     | JVM flags (container)                    |

## API surface (v1)

All endpoints require a valid bearer token issued by Keycloak.

| Method | Path                              | Role     | Description                  |
| ------ | --------------------------------- | -------- | ---------------------------- |
| GET    | `/api/users/me`                   | any auth | Current user profile         |
| GET    | `/api/users`                      | any auth | Directory (will be paged)    |
| GET    | `/api/challenges`                 | any auth | List active challenges       |
| GET    | `/api/challenges/{id}`            | any auth | Challenge detail             |
| POST   | `/api/admin/challenges`           | `ADMIN`  | Create challenge (201)       |
| DELETE | `/api/admin/challenges/{id}`      | `ADMIN`  | Delete challenge (204)       |

### Error envelope

All errors return a consistent JSON body:

```json
{
  "timestamp": "2025-01-01T00:00:00Z",
  "status": 400,
  "error": "Bad Request",
  "message": "Validation failed",
  "fieldErrors": { "title": "must not be blank" }
}
```

## Security

* OAuth2 resource server with JWT (Keycloak issuer).
* Stateless sessions (`SessionCreationPolicy.STATELESS`).
* `KeycloakRealmRolesConverter` lifts realm roles into `ROLE_*` authorities so
  `hasRole('ADMIN')` works in both URL rules and `@PreAuthorize`.
* CSRF disabled (token-based API, no cookies).
* CORS origins explicit and env-driven.
* Actuator endpoints limited to `health`, `info`, `metrics`, `prometheus`.

## Testing

```bash
./gradlew test
```

* Application smoke test (no DB) — `PulseBackendApplicationTests`.
* Web-MVC slice — `ChallengeControllerTest`.
* Testcontainers integration coverage is planned for V6.

## Roadmap (post-v1.1.0)

- [ ] Flyway migrations replacing `ddl-auto: update`
- [ ] Testcontainers-driven integration suite in CI
- [ ] OpenAPI 3 contract via springdoc
- [ ] Audit log table + Hibernate Envers
- [ ] Rate-limiting filter (Bucket4j)
- [ ] Distributed tracing (OpenTelemetry → OTLP)
