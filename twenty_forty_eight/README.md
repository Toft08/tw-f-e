# 2048 — Flutter

A Flutter implementation of the classic 2048 sliding-tile puzzle game.

## Gameplay

Swipe in any direction to slide all tiles. When two tiles with the same value collide they merge into one with twice the value. A new tile (2 or 4) appears after every move. Reach **2048** to win — or keep going for a higher score. The game ends when the board is full and no merges are possible.

## Features

- **Smooth animations** — tiles slide and merge with animated transitions and a scale-pop effect on merges
- **Score tracking** — current score and best score are displayed live and the best score is persisted between sessions
- **Grid size selector** — switch between 4×4, 5×5, and 6×6 boards; each size keeps its own separate best score
- **Sound effects** — audio feedback on merges and on winning
- **Portrait lock** — the UI is locked to portrait orientation on mobile
- **Responsive board** — the board scales to fit the available screen width, so it looks good on phones and tablets

## Architecture

The project uses the **BLoC** pattern to separate game logic from the UI:

```
lib/
├── main.dart               # App entry point, page layout, score display
└── game/
    ├── bloc/
    │   ├── game_bloc.dart  # Handles all game events, drives state transitions
    │   ├── game_event.dart # Events: swipes, start, restart, grid size change
    │   └── game_state.dart # Immutable state: tiles, score, best score, grid size
    ├── logic/
    │   ├── board_logic.dart   # Pure tile-movement and merge logic
    │   ├── score_storage.dart # Shared preferences persistence (per grid size)
    │   └── sound_service.dart # Audio playback via audioplayers
    ├── models/
    │   └── tile.dart       # Immutable tile model
    └── ui/
        ├── board_widget.dart  # Responsive board with gesture detection
        └── tile_widget.dart   # Animated tile with scale-in and pop effects
```

## Running the app

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install).

```bash
flutter pub get
flutter run
```

## Dependencies

| Package | Purpose |
|---|---|
| `flutter_bloc` | State management |
| `shared_preferences` | Best score persistence |
| `audioplayers` | Sound effects |
