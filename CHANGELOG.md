# Changelog

All notable changes to **Pulse Engage** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
