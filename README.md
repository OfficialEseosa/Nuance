# Nuance

Nuance is a gamified media-literacy app concept: Ground News-style perspective comparison wrapped in a Duolingo-style progression loop.

## What This Skeleton Includes

- multi-screen starter architecture
- shared design system based on the imported React/Figma design (`History Learning App`)
- dark mode by default with a Duolingo-inspired game UI direction
- mock data for missions, perspectives, challenges, and badges
- separate feature folders so work can be split by screen
- UI sound effects for taps/success events (`assets/sfx`)
- global `Sound Effects` toggle in Settings (persisted across launches)

## Current Screens

- `Home` (`features/path`)  
  Gamified dashboard with streak, level progress, trending story, and learning path.
- `News` (`features/lens`)  
  Story perspective feed with framing signals and source credibility.
- `Story Comparison` (`features/lens/story_compare_screen.dart`)  
  Side-by-side framing breakdown with challenge prompt.
- `Learn` (`features/arena`)  
  Lesson progression cards and challenge modules.
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
