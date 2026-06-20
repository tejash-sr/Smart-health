# Changelog

All notable changes to **Pulse Engage** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] — 2026-06-16

Second production release. Brings the V5 backend, V6 hardware sensors and
V7 admin console online, plus a fully wired data layer and continuous
integration.

### Added

#### V5 — Backend services
- Production-grade **Spring Boot 3.3.5** service on **Java 21 (Temurin)**
  with Gradle 8.10.2 wrapper.
- **PostgreSQL 15** via Spring Data JPA + Hibernate, with HikariCP
  connection pool tuned for the ~100-employee deployment (10 max / 2 min).
- **Keycloak 23** OAuth2 / OIDC resource server with stateless JWT sessions
  and a custom `KeycloakRealmRolesConverter` that lifts `realm_access.roles`
  into Spring Security `ROLE_*` authorities (so both URL rules and
  `@PreAuthorize` work).
- Env-driven configuration with dev / prod profiles, `PULSE_*` env vars
  for every connection string, issuer URI, and CORS origin.
- Hardened `User` entity (unique indices on keycloak_id + email, Jakarta
  validation, `trustScore` field).
- New `Challenge` aggregate (Type / Frequency / Status enums stored as
  STRING, composite index on `(status, end_date)`) with custom JPQL
  `findActiveOrderByEndDate`.
- DTO layer as **Java 21 records** (`UserDto`, `ChallengeDto`,
  `CreateChallengeRequest`) — JPA entities never reach the wire.
- Centralised `@RestControllerAdvice` with a consistent error envelope
  `{timestamp, status, error, message, fieldErrors?}`.
- Endpoints: `GET /api/users/me`, `GET /api/users`, `GET /api/challenges`,
  `GET /api/challenges/{id}`, `POST /api/admin/challenges` (201 + Location),
  `DELETE /api/admin/challenges/{id}` (204) — admin verbs locked to
  `hasRole('ADMIN')` at both URL and method level.
- `ChallengeService` with class-level `@Transactional(readOnly = true)` and
  explicit write boundaries.
- **Multi-stage Dockerfile** on Temurin 21 with a non-root `pulse` user,
  container-aware JVM flags, and a `HEALTHCHECK` on `/actuator/health`.
- **docker-compose** stack (PostgreSQL + Keycloak + backend) with
  `pg_isready` and Keycloak `/health/ready` healthchecks and `depends_on`
  conditions.
- Actuator exposes `health`, `info`, `metrics`, `prometheus` (Micrometer).
- `@WebMvcTest` slice for `ChallengeController` (anonymous → 401,
  authenticated → 200) and a smoke test that no longer requires a live DB.

#### V6 — Hardware sensors
- New `core/sensors/step_sensor.dart` `StepSensorService` wrapping
  `pedometer 4.2.0`, hardened to be web-safe (Android-only guard) and
  strict-cast clean.
- `permission_handler 12.0.3` runtime permission flow for
  `ACTIVITY_RECOGNITION` on API 29+.
- Anti-cheat `trustScore` propagated through the User entity and dashboard.

#### V7 — Admin console
- New `lib/screens/admin/admin_dashboard_screen.dart` with three tabs:
  - **Overview** — 6-card engagement grid (employees, active today, steps,
    points awarded, challenges running, average trust score) and a top-5
    departments table sorted by points.
  - **Challenges** — tile list with delete + confirmation dialog.
  - **Rewards** — inventory list with per-row stock stepper.
- Role-gated entry tile in Profile, visible only to `UserRole.admin` and
  `UserRole.superAdmin`.
- New `AdminRepository` contract + `MockAdminRepository` returning realistic
  analytics (department breakdown, points totals, avg trust score).
- All admin actions route through the `Result<T>` pattern with proper
  error envelopes.

#### Data layer
- `data/repositories/` — `UserRepository`, `ChallengeRepository`,
  `SocialRepository`, `AdminRepository` contracts.
- Matching `Mock*Repository` implementations seeded from `MockData`.
- `core/network/api_client.dart` hardened with timeouts and typed
  responses; `core/network/result.dart` sealed `Success` / `Failure` pattern.
- `core/error/exceptions.dart` — `ServerException`, `CacheException`,
  `UnauthorizedException`.
- `core/storage/local_storage.dart` — SharedPreferences wrapper with
  token storage.
- `core/di/injection_container.dart` — `ServiceLocator` (global `sl`) with
  `kUseMockRepositories` switch for V5 backend cutover.
- `AppProvider` now hydrates every collection through the configured
  repositories (`sl.userRepository`, `sl.challengeRepository`,
  `sl.socialRepository`). Synchronous mock seed keeps the first frame
  instant; async hydration runs in parallel; errors are non-fatal.
- Optimistic-update + automatic-rollback on `toggleLike`.
- New `joinChallenge` action with optimistic participant-count bump.

#### CI / DX
- New `.github/workflows/ci.yml` GitHub Actions workflow:
  - Flutter job: pinned 3.35.4, `dart format` (advisory), `flutter analyze
    --fatal-infos --fatal-warnings`, `flutter test --coverage`, web release
    build, uploads `lcov.info` + web bundle as artifacts.
  - Backend job: Temurin 21, Gradle cache, `clean test` + `bootJar`,
    Docker Buildx image smoke build, uploads the boot jar.
  - Concurrency group cancels stale runs per branch.
- Atomic per-file commits with conventional-commit prefixes
  (`feat`, `fix`, `chore`, `docs`, `test`, `merge`, `release`).

### Changed

- `UserController` now returns `UserDto` and throws `NotFoundException`
  (was leaking the JPA entity, including `keycloakId`).
- `pubspec.yaml` adds `pedometer 4.2.0` and `permission_handler 12.0.3`.
- `AndroidManifest.xml` declares `INTERNET` (V5 backend) and
  `ACTIVITY_RECOGNITION` (V6 step sensor).

### Fixed

- Three `MockRepository` getter bugs (`MockData.challenges` →
  `getChallenges()`, etc.).
- `ApiClient` dynamic-cast bug and unused import.
- `StepSensorService` untyped error params and missing web platform guard.
- Latent `_showSettings` bug in `ProfileScreen` (referenced the outer
  `context` from a closure that only had `c` in scope).
- Broken FAB widget tree in `SocialScreen` introduced by the `fixes`
  branch merge.
- Backend `build.gradle` was referencing fake starter names
  (`spring-boot-starter-webmvc`); switched to the real Spring Boot 3.3.5
  starter coordinates.
- Gradle wrapper pinned from non-existent `9.5.1` to `8.10.2`.

### Quality

- `flutter analyze` — 0 issues with strict-casts.
- `flutter test` — all passing.
- `flutter build web --release` — succeeds.
- All branches kept (`main`, `develop`, every `feature/*`, `fix/*`,
  `chore/*`) — none deleted.
- `--no-ff` merges throughout to preserve branch topology.

## [1.0.0] — 2026-06-08

First public production release.

### Added

#### Wellness loop (V1)
- Step tracking screen with circular progress, 7-day bar chart,
  trust-score breakdown, and anti-cheat info modal.
- Hydration tracking with animated water bottle, quick-add buttons,
  daily log, and streak card.
- Individual + team challenges with weekly / monthly cadence,
  participant counts, and category filters.
- Department & team leaderboards with podium top-3 and rank deltas.
- Points economy + redemption store with category filter, stock
  management, monthly redemption caps, and confetti celebrations.

#### Community (V2)
- Social wall with achievement / recognition / milestone post cards,
  like / comment / share, and composer sheet.
- Internal events (workshops, hackathons, sports, wellness, social)
  with capacity tracking and registration toggle.

#### Knowledge (V3)
- Ask-a-Doubt internal Q&A board with tags, upvotes, and accepted answers.
- Share-Ideas innovation board with status workflow
  (Submitted → Under Review → Approved → Shipped).

#### Connection (V4)
- Coffee Roulette random pairing for cross-team networking
  with opt-in toggle and weekly match history.
- Personal goals with daily streak tracking.

#### Platform & polish
- Splash screen with animated brand-gradient logo.
- 4-slide onboarding with smooth page indicator.
- Email / password + SSO login screen.
- Custom gradient bottom navigation (5 tabs).
- Profile screen with hero header, achievements carousel,
  menu tiles, and theme toggle.
- Points history with full transaction log.
- Notifications hub with read / unread state.
- Light + dark Material 3 themes with vibrant brand gradient
  (Indigo #6366F1 → Pink #EC4899 → Amber #F59E0B).
- 12 seed users, 5 challenges, 8 rewards, 6 social posts,
  5 events, 5 doubts, 5 ideas, 3 coffee matches, 4 goals,
  6 points transactions, 4 notifications.

#### Platforms
- **Android** (API 21+) — production-ready
- **iOS** (13.0+) — production-ready, bundle `com.pulseengage.engage`,
  full Info.plist with motion / health / location / camera / photo /
  calendar / contacts / Bluetooth usage descriptions
- **Web** (Chrome, Safari, Firefox, Edge) — production-ready,
  31 MB optimized release bundle

### Quality

- `flutter analyze` — 0 issues with production-grade lint config
  (strict-casts, avoid_print, cancel_subscriptions, etc.).
- `flutter test` — 1 smoke test passing.
- `flutter build web --release` — succeeds (31 MB).
- Conventional-commit history with atomic per-file commits.
- GitFlow branching: `main` ← `develop` ← `feature/*` / `fix/*` / `chore/*`,
  all merged with `--no-ff` to preserve branch history.

### Roadmap (not in 1.0.0)

- **V5** — Backend services (Spring Boot + PostgreSQL + Keycloak SSO)
- **V6** — Hardware sensor integration (Android pedometer / iOS HealthKit + CoreMotion)
- **V7** — Admin dashboard (challenge & reward management, analytics)
