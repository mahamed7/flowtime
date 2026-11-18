<div align="center">

# ⏱️ FlowTime

**A deep-work focus timer for Android, iOS, web and desktop: Pomodoro sessions, a personalised onboarding flow, and local session history. Built with Flutter.**

[![CI](https://github.com/mahamed7/flowtime/actions/workflows/ci.yml/badge.svg)](https://github.com/mahamed7/flowtime/actions/workflows/ci.yml)
![Flutter](https://img.shields.io/badge/Flutter-3-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.11-0175C2?logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/State-Riverpod-00B4AB)
![Hive](https://img.shields.io/badge/Storage-Hive-FFB300)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

</div>

---

## Overview

FlowTime helps you protect focused work. You set up your focus and break lengths and pick a coaching style once during onboarding. After that, starting a deep-work session takes one tap. Finished sessions are saved on the device, so your history survives restarts with no account or network needed.

## Features

**Working today**

- 🎯 **Focus timer:** start, pause and reset Pomodoro-style sessions (25 minutes by default) with an animated circular progress ring
- 🧭 **Three-step onboarding:** an intro, the "Screen Guardian" opt-in and a choice of coach personality (Zen, Sergeant or Partner)
- 💾 **Offline persistence:** user settings and completed `FocusSession`s are stored in **Hive** (typed adapters, no backend)
- 🔀 **Declarative routing:** `go_router` defines the onboarding → home flow, and a `redirect` sends returning users straight to the timer
- 🎨 **Custom design system:** a central colour palette, theme and a reusable glass-morphism `GlassCard` widget
- ✅ **Tests:** unit tests for the timer state machine and the onboarding settings, plus a widget test that boots the app on a throwaway Hive store

**Planned (in progress)**

- 🛡️ **Screen Guardian:** detect distracting apps during a session. The Dart side of the Android `MethodChannel` (`lib/platform/android/usage_monitoring.dart`) is written. The native Kotlin `UsageStatsManager` side is next.
- 🤖 **AI coach:** motivational nudges in the chosen personality, using the Gemini API
- 📊 **Insights:** charts of focus time and distractions with `fl_chart`
- 🔔 **Reminders** with local notifications

## Architecture

The app follows a **feature-first, layered** structure, so each feature owns its screens, widgets and state:

```
lib/
├── main.dart                     # Hive init, adapter registration, ProviderScope
├── core/
│   ├── navigation/app_router.dart    # go_router config (/onboarding, /home)
│   ├── theme/                         # AppColors + AppTheme
│   └── widgets/glass_card.dart        # shared UI component
├── data/
│   └── models/                    # FocusSession, UserSettings (+ generated Hive adapters)
├── features/
│   ├── onboarding/presentation/   # screen + Riverpod provider
│   └── timer/presentation/        # screen, circular timer widget, TimerNotifier
└── platform/android/              # MethodChannel bridge for usage monitoring
test/                              # timer + onboarding logic tests, widget smoke test
```

**State management:** `TimerNotifier` is a Riverpod `StateNotifier` that holds an immutable `TimerState` (total seconds, remaining seconds, running or not). The UI only reads state and calls `startTimer()`, `pauseTimer()` and `resetTimer()`. When the countdown reaches zero, the notifier writes a `FocusSession` to Hive. Keeping the logic out of the widgets is what makes it easy to unit-test.

## Tech stack

| Concern | Choice |
| :-- | :-- |
| UI | Flutter (Material 3), Google Fonts |
| State | Riverpod (`StateNotifier`) |
| Navigation | go_router |
| Local storage | Hive + `hive_generator` / `build_runner` |
| Testing | `flutter_test` |
| CI | GitHub Actions: `flutter analyze` and `flutter test` on every push |

## Getting started

**Prerequisites:** the [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, Dart 3.11 or later).

```bash
git clone https://github.com/mahamed7/flowtime.git
cd flowtime
flutter pub get
flutter run                 # choose a connected device, emulator or Chrome
```

Useful commands:

```bash
flutter test                                              # run the unit tests
flutter analyze                                           # static analysis
dart run build_runner build --delete-conflicting-outputs  # regenerate Hive adapters after changing a model
```

## What I learned

- Separating **business logic from UI** with Riverpod, which made the timer testable without rendering a widget
- Generating type-safe persistence code with Hive adapters and `build_runner`
- Bridging Flutter and native Android code through a `MethodChannel`

## Author

**Saabir Dahir Mahamud** · [Portfolio](https://mahamed7.github.io/Portfolio/) · [GitHub](https://github.com/mahamed7)

Released under the [MIT License](LICENSE).
