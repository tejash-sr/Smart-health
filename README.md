# Pulse — Employee Engagement & Wellness Platform

> **Engage. Grow. Together.**

A state-of-the-art employee engagement platform for modern workplaces (100-500 employees). Pulse uses wellness as the daily hook to drive community, knowledge sharing, and connection across teams.

Built with Flutter, designed for production.

---

## ✨ Features

### 🏃 Wellness
- **Step Tracking** — Automatic, hardware-sensor based. No manual entry. No cheating.
- **Hydration Tracking** — Daily water goal with streaks & quick-log
- **Trust Score System** — Multi-signal anti-cheat with hardware verification, cadence checks, GPS consistency, device integrity

### 🏆 Challenges
- Individual & Team challenges (weekly, monthly)
- Department vs Department competitions
- Live progress tracking with participant counts

### 🎁 Rewards Economy
- Points-based redemption store
- Vouchers, merchandise, time-off, experiences, food
- Stock management, monthly redemption caps
- Confetti celebrations 🎉

### 🌟 Community
- **Social Wall** — Achievements, recognition, milestones
- **Coffee Roulette** — Random pairings for cross-team networking
- **Recognition** — Public shoutouts that earn points

### 💡 Knowledge
- **Ask a Doubt** — Internal Stack Overflow for the company
- **Share Ideas** — Innovation pipeline with voting & status tracking
- Tags, upvotes, accepted answers

### 📅 Events
- Workshops, hackathons, sports, wellness, social
- Registration with capacity tracking
- Point rewards for attendance

### 🎯 Personal
- Personal goals with streak tracking
- Profile with achievements & analytics
- Notifications hub

---

## 🛠 Tech Stack

| Layer | Choice | Why |
|-------|--------|-----|
| Framework | Flutter 3.35 | One codebase, native performance |
| State | Provider | Simple, testable, scales to V2 |
| Storage | Hive + SharedPreferences | Offline-first, blazing fast |
| Theme | Material 3 + Google Fonts (Inter) | Modern, accessible |
| Charts | fl_chart | Smooth, customizable |
| Animations | flutter_animate | Declarative, performant |

---

## 📂 Architecture

Feature-first modular structure:

```
flutter_app/
├── lib/
│   ├── core/
│   │   ├── di/            # ServiceLocator (sl) — single source of truth for repos
│   │   ├── error/         # Typed exceptions (Server, Cache, Unauthorized)
│   │   ├── network/       # ApiClient + Result<T> (sealed Success/Failure)
│   │   ├── sensors/       # V6 StepSensorService (Android pedometer, web-safe)
│   │   ├── storage/       # LocalStorage (SharedPreferences) wrapper
│   │   ├── theme/         # Colors, typography, light + dark Material 3 themes
│   │   ├── widgets/       # Shared UI primitives (GlassCard, AvatarCircle…)
│   │   └── utils/         # Date / number formatters
│   ├── data/
│   │   └── repositories/  # Repository contracts + Mock* impls (V5 cutover ready)
│   ├── models/            # Plain Dart entities
│   ├── services/          # MockData seed + service helpers
│   ├── providers/         # AppProvider (wired through sl.* repositories)
│   └── screens/
│       ├── admin/         # V7 admin console (analytics, challenges, rewards)
│       ├── auth/          # Splash, onboarding, login
│       ├── home/          # Dashboard, notifications, main shell
│       ├── steps/         # Step tracking & trust score
│       ├── water/         # Hydration
│       ├── challenges/    # Challenges feed
│       ├── leaderboard/   # Rankings
│       ├── rewards/       # Store & redemption
│       ├── social/        # Community wall
│       ├── events/        # Event registration
│       ├── doubts/        # Q&A
│       ├── ideas/         # Idea board
│       ├── coffee/        # Coffee roulette
│       ├── goals/         # Personal goals
│       └── profile/       # User profile (+ admin entry tile)
└── backend/               # V5 Spring Boot 3.3.5 / Java 21 / Postgres / Keycloak
    ├── src/main/java/com/pulseengage/backend/
    │   ├── api/            # Controllers + DTO records
    │   ├── config/         # SecurityConfig + KeycloakRealmRolesConverter
    │   ├── domain/         # JPA entities + repositories
    │   ├── exception/      # Global @RestControllerAdvice
    │   └── service/        # ChallengeService (explicit @Transactional)
    ├── Dockerfile          # Multi-stage Temurin 21 build, non-root runtime
    └── docker-compose.yml  # Postgres 15 + Keycloak 23 + backend
```

---

## 🌿 Branching Strategy (GitFlow)

```
main             ← production-ready releases (tagged)
  └── develop    ← integration branch for all features
        ├── feature/auth
        ├── feature/home-dashboard
        ├── feature/steps-tracking
        ├── feature/water-tracking
        ├── feature/challenges
        ├── feature/leaderboard
        ├── feature/rewards
        ├── feature/social-wall
        ├── feature/events
        ├── feature/doubts-qa
        ├── feature/ideas-board
        ├── feature/coffee-roulette
        ├── feature/personal-goals
        └── feature/profile
```

Every feature ships through `feature/*` → `develop` → `main`. Branches are preserved for traceability.

---

## 🚀 Getting Started

### Frontend (Flutter)

```bash
# Install dependencies
flutter pub get

# Run on web (preview)
flutter run -d chrome

# Build release APK
flutter build apk --release

# Build release Web bundle
flutter build web --release

# Build iOS (release, on macOS only)
flutter build ios --release --no-codesign
```

### Backend (Spring Boot)

```bash
cd backend
docker compose up -d --build
```

Stack comes up on:
- `http://localhost:8080` — Pulse backend (`/api/...`, `/actuator/*`)
- `http://localhost:8081` — Keycloak admin (admin / admin in dev only)
- `localhost:5432`         — PostgreSQL 15

Full env-var matrix, API surface and error envelope documented in
[`backend/README.md`](backend/README.md).

### 📱 Supported Platforms

| Platform | Min Version | Status |
|----------|-------------|--------|
| Android  | API 21 (5.0 Lollipop) | ✅ Production-ready |
| iOS      | 13.0+ | ✅ Production-ready |
| Web      | Chrome / Safari / Firefox / Edge (latest) | ✅ Production-ready |

Bundle identifier is consistent across stores: `com.pulseengage.engage`.

---

## 🗺 Roadmap

| Phase | Status |
|-------|--------|
| V1 — Wellness loop (steps, water, challenges, leaderboard, rewards) | ✅ Complete (1.0.0) |
| V2 — Community (social wall, events, recognition) | ✅ Complete (1.0.0) |
| V3 — Knowledge (doubts, ideas) | ✅ Complete (1.0.0) |
| V4 — Connection (coffee roulette, goals) | ✅ Complete (1.0.0) |
| V5 — Backend (Spring Boot 3.3.5 + PostgreSQL 15 + Keycloak 23) | ✅ Complete (1.1.0) |
| V6 — Hardware sensor integration (Android pedometer, web-safe) | ✅ Complete (1.1.0) |
| V7 — Admin dashboard (challenge / reward management, analytics) | ✅ Complete (1.1.0) |
| V8 — Flyway migrations, Testcontainers, OpenAPI, audit log | 🚧 Planned |
| V9 — Real-time notifications (WebSocket / FCM) | 🚧 Planned |

---

## 📄 License

Proprietary — built for production deployment in workplace settings.
