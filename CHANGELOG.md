# Changelog

All notable changes to Mathdoku are documented here.

---

## [Unreleased]

---

## [1.0.0] — Initial Release

### Added
- 4×4 Mathdoku puzzle engine: Latin-square generator with backtracking, BFS cage builder,
  arithmetic operation assignment (+, −, ×, ÷).
- Two difficulty levels:
  - **Easy** — addition and multiplication only; single-cell cages pre-filled as givens.
  - **Medium** — all four operations; larger cages (up to 4 cells); no pre-fills.
- Cage-aware grid rendering: pastel tint per cage, thick borders between cages, thin borders
  within the same cage. Clue label shown in the top-left cell of each cage.
- Number pad with four pastel digit buttons (1–4); completed digits dim and show a ✓.
- Hint button (💡): auto-selects and fills the first empty cell if none is tapped first,
  then highlights the filled cell so the player can see what changed.
- Erase button (🧹): clears the selected cell.
- Row and column duplicate detection with colour feedback (green = complete, orange = error).
- Cage satisfaction detection: cage tints green when its arithmetic clue is met.
- Mandatory 10-minute screen break: `BreakPage` appears after 600 seconds of play and
  cannot be dismissed with the back button.
- Confetti win celebration with animated trophy dialog showing elapsed time.
- Responsive layout: screens wider than 600 px (Windows, Chrome) display the grid and
  controls side by side, with the grid filling available height. Narrow screens stack them.
- Child-safe theme: warm cream background, coral accent (kPrimary), teal accent (kSecondary),
  Google Fonts Nunito, large rounded tap targets.
- Privacy Policy page: no data collected, no ads, fully offline.

### Tech
- Flutter / Dart 3.5+
- flutter_riverpod + riverpod_annotation for state management
- freezed + freezed_annotation for immutable models
- flutter_animate for cell pulse and shake animations
- confetti for win celebration
- google_fonts (Nunito)

---

## Post-release Fixes & Improvements

### Action button text clipping fixed on Windows and Chrome
The three action buttons (Hint, Notes, Erase) were being cut off on wide screens due to
Material 3's default 24px horizontal button padding leaving too little room in narrow
buttons. Fixed by reducing padding to 6px and wrapping each label in
`FittedBox(fit: BoxFit.scaleDown)` so text auto-scales instead of clipping.
"Notes ON" also shortened to "Notes ✓" to reduce its natural width.

### User-entered digit colour changed to green
Correct digits entered by the player now appear in `Colors.green.shade700` instead of
coral (kPrimary), making them clearly distinct from the red error state.

### Thicker, more visible grid lines
- Inner-cage borders: 0.5 px grey → 1.5 px grey.shade500
- Cage-boundary borders: 2.0 px → 3.5 px black87
- Outer grid border: 3 px → 4 px kPrimary

### Larger, bolder clue text
Clue labels (e.g. "6+", "12×") updated from 11 px / w700 / black54 to
15 px / w900 / black87 for much better readability on all screen sizes.

### Pencil / notes mode added
Tap the ✏️ Notes button to toggle pencil mode. In pencil mode, digit buttons write small
candidate numbers (1–4) into empty cells displayed in a 2×2 mini-grid. Tapping the same
digit again removes it. The button turns dark and shows "Notes ON" when active.

Switching back to pen mode and entering a correct digit clears that cell's notes and
auto-removes the placed digit from notes in the same row and column. Erase first removes
a placed digit (revealing notes underneath); a second press clears the notes. Hint clears
notes on the cell it fills. Keyboard keys 1–4 respect pencil mode automatically. Press `P` to toggle pencil mode from the keyboard.

### Hint button fixed — now always works
Previously the hint button silently did nothing if no cell was selected. It now
automatically finds and fills the first empty or incorrect cell in reading order,
and selects that cell so the player can see which one was filled.
