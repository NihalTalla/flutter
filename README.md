# GameHub

**Casual & Competitive Gaming**

A complete Flutter gaming hub featuring 3 fully-playable games with scoring, XP progression, leaderboard, and player profiles — all persisted locally.

---

## Description

GameHub is a polished Flutter mobile application built as a lab project demonstrating core Flutter concepts including StatefulWidgets, animations, local persistence, game logic, and responsive UI design using Material 3.

---

## Features

- **3 Playable Games** — Memory Match, Rock Paper Scissors, Tic-Tac-Toe
- **Casual & Competitive separation** — clear category badges and scoring rules
- **XP & Level System** — earn XP, level up with a visible progress bar
- **Match History** — last 50 matches stored locally
- **Local Leaderboard** — demo rankings with the player highlighted
- **Player Profile** — editable name, avatar, full stats
- **Settings** — sound toggle, reset data, about
- **Dark Gaming UI** — Material 3 dark theme with gradients and animations
- **Fully Offline** — no internet required

---

## Technologies Used

- **Flutter** (Material 3)
- **Dart** (null-safe)
- **shared_preferences** — local data persistence
- **No external state management** — StatefulWidgets + singletons

---

## Flutter Requirements

- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android SDK (min API 21 / Android 5.0)

---

## Installation

```bash
# 1. Navigate to project
cd gamehub

# 2. Install dependencies
flutter pub get

# 3. Run on connected device or emulator
flutter run
```

---

## Project Structure

```
lib/
├── main.dart              # Entry point
├── app.dart               # App widget + routes + bottom nav shell
├── theme/app_theme.dart   # Material 3 dark gaming theme
├── utils/
│   ├── constants.dart     # App-wide constants & scoring values
│   └── helpers.dart       # XP calculations, date formatting
├── models/
│   ├── player.dart        # Player data model
│   ├── game.dart          # GameInfo & GameCategory
│   └── game_result.dart   # Match result model
├── services/
│   ├── storage_service.dart  # SharedPreferences wrapper (singleton)
│   ├── player_service.dart   # Player stats management (singleton)
│   └── game_service.dart     # Score/XP calculations, leaderboard data
├── widgets/
│   ├── game_card.dart        # Reusable game card widget
│   ├── stat_card.dart        # Stats display widget
│   ├── leaderboard_tile.dart # Leaderboard entry
│   ├── xp_progress.dart      # XP progress bar
│   └── section_header.dart   # Section header with badge
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── games_screen.dart
│   ├── leaderboard_screen.dart
│   ├── profile_screen.dart
│   ├── settings_screen.dart
│   └── game_history_screen.dart
└── games/
    ├── memory_match/memory_match_screen.dart
    ├── rock_paper_scissors/rock_paper_scissors_screen.dart
    └── tic_tac_toe/tic_tac_toe_screen.dart
```

---

## Games

### Memory Match (Casual)
- Flip cards to find matching pairs
- Easy (4×2), Medium (4×4), Hard (6×4)
- Timer, move counter, score formula
- Card flip animations

### Rock Paper Scissors (Casual)
- Player vs Computer
- Tracks wins, losses, draws, streak
- Animated reveal

### Tic-Tac-Toe (Competitive)
- Player vs AI
- Easy (random), Medium (strategic), Hard (minimax)
- Full scoring system with difficulty bonus
- Win/loss/draw stats tracked

---

## Scoring System

| Event           | Points  | XP  |
|-----------------|---------|-----|
| Win             | +100    | +50 |
| Draw            | +25     | +15 |
| Loss            | +10     | +5  |
| Medium Diff     | +25 bonus |   |
| Hard Diff       | +50 bonus |   |
| Win Streak      | ×streak bonus |  |

---

## Architecture

- **Singleton Services** — `StorageService`, `PlayerService` initialized at startup
- **Route-based Navigation** — named routes via `MaterialApp.routes`
- **Stateful Game Screens** — each game is self-contained
- **Shared Widgets** — `GameCard`, `StatCard`, `XpProgressWidget` used across screens

---

## Future Enhancements

- Online multiplayer via Firebase
- More games (Snake, 2048, Sudoku)
- Achievements system
- Sound effects
- Animated onboarding
