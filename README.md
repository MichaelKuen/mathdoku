# Mathdoku

A fun, child-friendly **Mathdoku** math puzzle game built with Flutter.

Mathdoku (also known as KenKen or CalcuDoku) challenges players to fill a grid with digits
so that every row and column contains each digit exactly once — and every highlighted cage
of cells satisfies its arithmetic clue. Play on a 4×4 grid (Easy/Medium) or tackle the
tougher 6×6 grid on Hard.

**Published by [App Verse Games](https://appversegames.com)**

---

## Features

- **Three difficulty levels**
  - **Easy** — 4×4 grid; addition and multiplication only; single-cell cages are pre-filled as hints
  - **Medium** — 4×4 grid; all four operations (+, −, ×, ÷); larger cages, no pre-fills
  - **Hard** — 6×6 grid; all four operations; cages up to 6 cells; digits 1–6
- **Pencil / notes mode** — tap ✏️ Notes to toggle pencil mode; write candidate digits into cells as a 2×2 mini-grid without committing to an answer
- **Unlimited hints** — tap 💡 Hint at any time; auto-selects the first empty cell if none is chosen
- **Gentle error feedback** — wrong answers shake and turn red; no game-over penalty
- **Mandatory 10-minute screen breaks** — a full-screen break reminder appears after every
  10 minutes of play and cannot be skipped with the back button
- **Zero advertisements** — no AdMob, no ad SDK, no third-party tracking of any kind
- **Child-safe visuals** — bright pastel colours, large tap targets, rounded shapes,
  encouraging language, Google Fonts Nunito typeface
- **Responsive layout** — adapts for mobile (portrait stacked) and wide screens such as
  Windows and Chrome (grid + controls side-by-side, filling available space); action
  buttons auto-scale their labels to always fit regardless of screen width
- **Confetti win celebration** with animated trophy dialog

---

## How to Play

1. Each cage (coloured group of cells) shows a **clue** in its top-left corner — a target
   number and an arithmetic operation (e.g. `6+`, `12×`, `2−`, `2÷`).
2. Fill every cell with a digit (1–4 on Easy/Medium, 1–6 on Hard) so that:
   - Each **row** contains each digit exactly once.
   - Each **column** contains each digit exactly once.
   - The digits in each **cage** satisfy its arithmetic clue.
3. Tap a cell to select it, then tap a digit on the number pad to enter it.
4. Use **✏️ Notes** to toggle pencil mode — digit buttons write small candidate numbers
   into the cell instead of committing an answer. Tap a digit again to remove it.
5. Use **💡 Hint** to reveal any cell and **🧹 Erase** to clear an entry.
   - First erase press removes a placed digit (revealing any notes underneath).
   - Second press clears the notes.

### Keyboard Controls (Windows & Chrome)

| Key | Action |
|---|---|
| `←` `↑` `→` `↓` | Move cell selection (hold to repeat) |
| `1`–`4` (or `1`–`6` on Hard) | Enter a digit (main keyboard or numpad) |
| `Delete` / `Backspace` | Erase the selected cell |
| `H` | Hint |
| `P` | Toggle pencil / notes mode |

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter / Dart 3.5+ |
| State management | flutter_riverpod + riverpod_annotation (code generation) |
| Immutable models | freezed + freezed_annotation |
| Font | Google Fonts — Nunito |
| Animations | flutter_animate |
| Win celebration | confetti |

---

## Project Structure

```
lib/
  core/
    theme/              app_theme.dart          — colours, kidsTheme
  features/
    game/
      data/
        repositories/   puzzle_repository_impl.dart
      domain/
        logic/          mathdoku_engine.dart    — row/column/cage validation
                        mathdoku_generator.dart — Latin-square + cage generation
        models/         board.dart  cage.dart  cell.dart  game_state.dart
        repositories/   puzzle_repository.dart
      presentation/
        pages/          game_page.dart  break_page.dart
        providers/      game_provider.dart
        widgets/        mathdoku_grid.dart  number_pad.dart
    home/
      presentation/
        pages/          home_page.dart  privacy_policy_page.dart
  main.dart
```

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.5
- Dart SDK ≥ 3.5

### Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Analyze

```bash
flutter analyze
```

---

## Privacy

Mathdoku collects no personal data, requires no internet connection, and contains no
advertisements. See the in-app Privacy Policy for full details.

**Developer contact:** play@appversegames.com
**Website:** https://appversegames.com
