# Pulse — an employee engagement app people open every day

> Pulse uses something people already care about, **their own steps and water**, as the daily reason to open the app. Team challenges, rewards, recognition, Q&A, ideas and events sit one tap away, so engagement grows from habit instead of reminders.

**My own product, built solo** · Flutter (Android, iOS, web) + Spring Boot + Keycloak · **tested by 10+ colleagues at my office** on release APKs

---

## The problem

My workplace already had an engagement tool, but it wasn't efficient. Engagement tools tend to fail the same way: they are a separate place employees have to *remember* to visit, so they get opened for one announcement and then forgotten. The things that make a workplace feel connected (recognition, cross-team friendships, sharing knowledge, healthy competition) need **daily** contact, not a monthly survey.

## The idea

Give people a selfish, healthy reason to open the app every day, then put the community features right next to it:

| Daily hook | What keeps them there |
|---|---|
| 🏃 **Steps** from the phone's step sensor, no manual entry on Android | 🏆 **Challenges:** individual, team and department vs department, weekly or monthly |
| 💧 **Water** goal with streaks and quick logging | 🎁 **Rewards store:** points for vouchers, merchandise, time off and experiences, with stock and monthly caps |
| 🎯 **Personal goals** with streaks | 🌟 **Social wall and recognition:** public shoutouts that earn points |
| | ☕ **Coffee roulette:** random cross-team pairings |
| | 💡 **Ask a doubt** (an internal Q&A) and **share ideas** with voting |
| | 📅 **Events** with registration, capacity and attendance points |

Admins get a dashboard to manage challenges and rewards and see analytics.

## Why it's worth paying for

- **Engagement that compounds.** A daily habit (steps, water) brings people back; every visit is a chance to see a shoutout, answer a question or join a challenge.
- **Cross-team connection by design.** Department challenges and coffee roulette create contact that org charts don't.
- **Knowledge stays inside the company.** Doubts and ideas become a searchable, upvoted record instead of lost chat messages.
- **One codebase, every device.** Android, iOS and web from a single Flutter app.

## Tested with real users

I built release APKs and had **10+ colleagues at my office** install and use Pulse on their own phones.

## Key design decisions

| Decision | Why |
|---|---|
| **Wellness as the hook, community as the value** | People won't open an "engagement app" daily, but they will check their steps |
| **Hardware step counting, not manual entry** (Android pedometer) | Typed-in steps make challenges meaningless; sensor data keeps competition fair |
| **Offline-first storage** (Hive) with a compile-time switch between in-memory and live API repositories | The app is fast and fully demoable without a server; the same screens run against the real backend with one build flag |
| **Keycloak for identity** (OAuth2/OIDC, roles mapped into Spring Security) | Companies already run single sign-on; Pulse plugs into it instead of storing passwords |
| **Feature-first modules and GitFlow** (every feature on its own branch, merged through `develop`) | 14 feature areas built quickly without stepping on each other; history stays traceable |

## Status

| Area | State |
|---|---|
| App: 14 feature areas (steps, water, challenges, leaderboard, rewards, social wall, events, Q&A, ideas, coffee roulette, goals, profile, admin, auth) | ✅ Built (1.1.0) |
| Step counting | ✅ Android hardware sensor · iOS and web fall back to manual or demo data |
| Backend: Spring Boot 3.3.5, PostgreSQL 15, Keycloak 23 (users, challenges and admin challenge endpoints) | ✅ Built (1.1.0) |
| App on live backend for every feature (most screens use in-memory demo data today) | 🚧 Next |
| Anti-cheat trust score (cadence checks, location consistency, device integrity) | 🚧 Planned; the `trustScore` field exists in the data model |
| Flyway migrations, Testcontainers tests, OpenAPI docs, audit log | 🚧 Planned |
| Real-time notifications (WebSocket / FCM) | 🚧 Planned |

## Tech stack

| Layer | Choice |
|---|---|
| App | Flutter 3.35, Provider, Hive + SharedPreferences, Material 3, fl_chart, flutter_animate, pedometer |
| Backend | Spring Boot 3.3.5 on Java 21, Spring Data JPA, PostgreSQL 15, HikariCP |
| Identity | Keycloak 23 (OAuth2 / OIDC resource server, stateless JWT) |
| Delivery | Multi-stage Docker build (non-root runtime), Docker Compose for the full stack |

## Run it

**App**

```bash
flutter pub get
flutter run -d chrome                 # web preview with demo data
flutter build apk --release           # Android APK
flutter build ios --release --no-codesign   # iOS (macOS only)
```

Point the app at a live backend with `--dart-define=PULSE_API_BASE_URL=<your API URL>`.

**Backend**

```bash
cd backend
docker compose up -d --build
```

- `http://localhost:8080`: Pulse API (`/api/...`, `/actuator/*`)
- `http://localhost:8081`: Keycloak admin (admin / admin, development only)
- `localhost:5432`: PostgreSQL 15

The environment variables, API and error format are documented in [`backend/README.md`](backend/README.md).

## Project layout

```
lib/
  core/          dependency injection, networking, sensors, storage, theme, shared widgets
  data/          repositories (live API and in-memory demo implementations)
  models/        domain models
  providers/     app state
  screens/       one folder per feature area
backend/
  src/main/java/com/pulseengage/backend/
    api/         controllers and DTO records
    config/      security and Keycloak role mapping
    domain/      JPA entities and repositories
    exception/   global error handling
    service/     business logic with explicit transactions
```

Release notes are in [`CHANGELOG.md`](CHANGELOG.md).

## License

Proprietary. © 2026 Pulse Engage. All rights reserved. See [`LICENSE`](LICENSE).
