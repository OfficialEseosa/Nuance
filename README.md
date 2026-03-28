# Nuance

Nuance is a gamified media-literacy app concept: Ground News-style perspective comparison wrapped in a Duolingo-style progression loop.

## What This Skeleton Includes

- multi-screen starter architecture
- shared design system based on the imported React/Figma design (`History Learning App`)
- dark mode by default with light mode toggle in Settings
- mock data for missions, perspectives, challenges, and badges
- live RSS news ingestion (multi-source) with automatic fallback if feeds fail
- event clustering so `Compare` opens the same topic across multiple outlets
- separate feature folders so work can be split by screen
- UI sound effects for taps/success events (`assets/sfx`)
- global `Sound Effects` toggle in Settings (persisted across launches)
- persistent game progress (completed modules, comparisons, challenge accuracy, badges, streak)

## Current Screens

- `Home` (`features/path`)  
  Gamified dashboard with streak, level progress, trending story, and learning path.
- `News` (`features/lens`)  
  Live multi-source feed with category filters, refresh, and compare flow.
- `Story Comparison` (`features/lens/story_compare_screen.dart`)  
  Multi-source event breakdown with dynamic challenge variants (`Shuffle`).
- `Learn` (`features/arena`)  
  Lesson progression cards with playable mini-quiz modules.
- `Profile` (`features/profile`)  
  Level identity, performance metrics, badges, and streak tracker.

## Suggested Team Split

Use this to minimize overlap and merge pain:

- Person A ownership:
  - `lib/features/path/**`
  - `lib/features/arena/**`
- Person B ownership:
  - `lib/features/lens/**`
  - `lib/features/profile/**`
- Shared files (coordinate before edits):
  - `lib/core/theme/nuance_theme.dart`
  - `lib/core/widgets/**`
  - `lib/app/nuance_shell.dart`
  - `lib/core/data/mock_content.dart`

## Local Design Source

- `History Learning App/` is intentionally ignored via `.gitignore` so it will not be committed.

## Sound Effects

- Source: Kenney "UI Audio" (CC0), downloaded into `assets/sfx/`.

## Run

```bash
flutter pub get
flutter run
```

## Next Technical Milestones

- replace mock data with real story ingestion pipeline
- define challenge scoring logic and XP economy
- add persistent progress state
- add onboarding + account bootstrap flow
