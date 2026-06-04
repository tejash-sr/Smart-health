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
lib/
├── core/
│   ├── theme/        # Colors, typography, themes (light + dark)
│   ├── widgets/      # Shared UI primitives (GlassCard, AvatarCircle…)
│   └── utils/        # Date/number formatters
├── models/           # Plain Dart entities
├── services/         # Mock + future API/repository layer
├── providers/        # State management (Provider)
└── screens/
    ├── auth/         # Splash, onboarding, login
    ├── home/         # Dashboard, notifications
    ├── steps/        # Step tracking & trust score
    ├── water/        # Hydration
    ├── challenges/   # Challenges feed
    ├── leaderboard/  # Rankings
    ├── rewards/      # Store & redemption
    ├── social/       # Community wall
    ├── events/       # Event registration
    ├── doubts/       # Q&A
    ├── ideas/        # Idea board
    ├── coffee/       # Coffee roulette
    ├── goals/        # Personal goals
    └── profile/      # User profile
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

```bash
# Install dependencies
flutter pub get

# Run on web (preview)
flutter run -d chrome

# Build release APK
flutter build apk --release
```

---

## 🗺 Roadmap

| Phase | Status |
|-------|--------|
| V1 — Wellness loop (steps, water, challenges, leaderboard, rewards) | ✅ Complete |
| V2 — Community (social wall, events, recognition) | ✅ Complete |
| V3 — Knowledge (doubts, ideas) | ✅ Complete |
| V4 — Connection (coffee roulette, goals) | ✅ Complete |
| V5 — Backend (Spring Boot + PostgreSQL + Keycloak) | 🚧 Planned |
| V6 — Hardware sensor integration (Android pedometer) | 🚧 Planned |
| V7 — Admin dashboard (challenge/reward management) | 🚧 Planned |

---

## 📄 License

Proprietary — built for production deployment in workplace settings.
