# Mathdoku — Flutter Build Prompt

> **How to use this file**
> You are in a brand-new Flutter project created via Android Studio.
> Paste each **Part** into the terminal Claude (claude.ai/code or the IDE assistant)
> one at a time. Wait for Claude to finish and confirm success before pasting the next part.
> Do **not** skip parts — each one builds on the last.

---

## What we are building

A **children's Mathdoku app** in Flutter/Dart. Mathdoku (also known as KenKen or CalcuDoku)
is a math puzzle played on a 4×4 grid:

- **Grid rule:** Every row and every column must contain the digits 1–4 exactly once.
  (Unlike Sudoku there are **no** 2×2 box constraints.)
- **Cages:** The grid is divided into irregularly shaped groups of cells called *cages*.
  Each cage displays a **clue** in its top-left corner — a target number and an arithmetic
  operation (e.g. `6+`, `12×`, `2−`, `2÷`). Single-cell cages just show the required
  digit with no operation symbol.
- **Cage rule:** The digits in a cage must produce the target value when the cage's
  operation is applied:
  - `+` — digits sum to target
  - `−` — |a − b| equals target (2-cell cages only)
  - `×` — digits multiply to target
  - `÷` — larger ÷ smaller equals target with no remainder (2-cell cages only)
  - single-cell — digit equals target
- **Win condition:** Every cell is filled, every row and column is valid, every cage
  satisfies its clue.

Non-negotiable requirements:
- **Zero advertisements** — no AdMob, no ad SDK, no revenue packages of any kind.
- **Mandatory screen breaks** — after every 10 minutes of play the game pauses and shows
  a friendly full-screen break reminder the child must actively dismiss.
- **Child-safe visuals** — bright pastel colours, large tap targets, rounded shapes,
  encouraging language only, no dark themes.
- **Unlimited hints** — children should never feel stuck.
- **No mistake limit** — wrong answers show gentle feedback but never end the game.
- **Pencil / notes mode** — tap ✏️ Notes (or press `P`) to toggle; writes candidate digits into empty cells as a 2×2 mini-grid. Entering a correct digit auto-clears that note from the same row/column.
- **State management:** flutter_riverpod + riverpod_annotation (code generation).
- **Immutable models:** freezed + freezed_annotation.
- **Animations:** flutter_animate for in-game feedback; confetti package for win celebration.
- **Font:** Google Fonts — Nunito (rounded, friendly, highly legible for children).

---

## PART 1 — Project Setup

**Goal: initialise the Flutter project and install all dependencies.**

```
We are building a children's 4×4 Mathdoku app from scratch.
The app name is mathdoku.

Step 1: This Flutter project was just created by Android Studio.
Replace the entire contents of pubspec.yaml with the following:

name: mathdoku
description: "A fun, child-friendly 4x4 Mathdoku math puzzle game."
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.5.0

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.3.5
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  google_fonts: ^6.2.1
  flutter_animate: ^4.5.2
  confetti: ^0.7.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.15
  freezed: ^2.5.7
  json_serializable: ^6.9.0
  riverpod_generator: ^2.6.4

flutter:
  uses-material-design: true

Step 2: Run:  flutter pub get

Step 3: Create this exact folder structure inside lib/ (create empty placeholder
.dart files so the folders exist — we will fill them in later parts):

lib/
  core/
    theme/
      app_theme.dart
  features/
    game/
      data/
        repositories/
          puzzle_repository_impl.dart
      domain/
        logic/
          mathdoku_engine.dart
          mathdoku_generator.dart
        models/
          board.dart
          cage.dart
          cell.dart
          game_state.dart
        repositories/
          puzzle_repository.dart
      presentation/
        pages/
          break_page.dart
          game_page.dart
        providers/
          game_provider.dart
        widgets/
          mathdoku_grid.dart
          number_pad.dart
    home/
      presentation/
        pages/
          home_page.dart
          privacy_policy_page.dart
  main.dart

Confirm the folder structure exists and that flutter pub get succeeded.
Do not write any real Dart code yet.
```

---

## PART 2 — Domain Models

**Goal: create all immutable data models using freezed.**

```
Now implement the domain models for a 4×4 Mathdoku app.
Use freezed for immutability. Run build_runner after all files are written.

=== lib/features/game/domain/models/cell.dart ===

Create an enum CellStatus { normal, correct, incorrect }

Create a @freezed class Cell with these fields:
  required int value          — 0 means empty
  required int row
  required int col
  required int cageId         — which cage this cell belongs to (set by the generator)
  @Default(false) bool isFixed       — true only for easy-mode single-cell given cages
  @Default(false) bool isSelected
  @Default(false) bool isHighlighted — same row or column as selected cell
  @Default(false) bool isSameNumber  — same digit value as the selected cell
  @Default(false) bool isError       — player placed a wrong digit (compared against solution)
  @Default(false) bool showClue      — true for the top-left cell of each cage (displays the clue)
  @Default('') String clueText       — the clue string, e.g. "6+", "12×", "2−", "2÷", or "3"
  @Default(CellStatus.normal) CellStatus cageStatus  — whether this cell's cage is satisfied
  @Default(CellStatus.normal) CellStatus rowStatus
  @Default(CellStatus.normal) CellStatus colStatus
  @Default(<int>[]) List<int> notes  — candidate digits written in pencil mode (empty = no notes)

Include the freezed part directive and json_serializable fromJson factory.

=== lib/features/game/domain/models/cage.dart ===

Create an enum Operation { add, subtract, multiply, divide, given }

Create a @freezed class CagePos with:
  required int row
  required int col
Include the freezed part directive and json_serializable fromJson factory.

Create a @freezed class Cage with:
  required int id
  required List<CagePos> cells   — positions of every cell in this cage
  required Operation operation
  required int target            — the clue number
Include the freezed part directive and json_serializable fromJson factory.

=== lib/features/game/domain/models/board.dart ===

Create a @freezed class Board with:
  required List<List<Cell>> cells    — 4 rows × 4 cols
  required List<List<int>> solution  — 4×4 correct Latin square
  required List<Cage> cages          — all cages for this puzzle

Add a const Board._() constructor so we can add methods.

Add these methods:
  Cell getCell(int row, int col) => cells[row][col];
  int getSolutionValue(int row, int col) => solution[row][col];
  bool get isComplete:
    Returns true only when every cell has a non-zero value AND no cell has isError == true.

=== lib/features/game/domain/models/game_state.dart ===

Create enums:
  enum GameStatus { initial, loading, playing, won, breakTime }
  enum Difficulty { easy, medium }

Create a @freezed class GameState with:
  Board? board
  @Default(GameStatus.initial) GameStatus status
  @Default(Difficulty.easy) Difficulty difficulty
  @Default(0) int elapsedSeconds             — total seconds played (never resets)
  @Default(0) int playSecondsThisSegment     — seconds since last break; resets when break is taken
  @Default(0) int mistakes
  int? selectedRow
  int? selectedCol
  @Default(false) bool isPencilMode  — true when pencil/notes mode is active

After writing all four files, run:
  dart run build_runner build --delete-conflicting-outputs

Fix any errors before moving on. Confirm build_runner succeeded.
```

---

## PART 3 — Game Logic

**Goal: implement the Latin-square generator and Mathdoku rules engine for a 4×4 grid.**

```
Implement the Mathdoku logic layer. This is a 4×4 puzzle:
  - 4 rows, 4 columns
  - Each row and each column must contain the digits 1–4 exactly once.
  - There are NO 2×2 box constraints (unlike Sudoku).
  - Cells are grouped into irregularly shaped cages.
  - Each cage has a target number and an arithmetic operation.

=== lib/features/game/domain/logic/mathdoku_generator.dart ===

import dart:math

class MathdokuGenerator {
  final _random = Random();

  Board generate(Difficulty difficulty):
    1. Create a 4×4 int grid filled with zeroes.
    2. Call _solveLatinSquare(grid, 0, 0) to fill it — must return true.
       (Details of _solveLatinSquare below.)
    3. Store the filled grid as `solution` (deep copy: List.generate(4, (r) => List<int>.from(grid[r]))).
    4. Generate cages by calling _generateCages(grid, difficulty).
       This returns a tuple of (List<Cage> cages, List<List<int>> cageIdGrid)
       where cageIdGrid[r][c] is the cage id for cell (r,c).
    5. Build and return a Board:
         cells: build a 4×4 List<List<Cell>>:
           For each (r, c):
             cage = find the Cage in cages where cage.id == cageIdGrid[r][c]
             isTopLeft = cage.cells.first.row == r && cage.cells.first.col == c
               (cells.first is the reading-order minimum, ensured during cage construction)
             isGiven = cage.cells.length == 1 && difficulty == Difficulty.easy
             Cell(
               value: isGiven ? solution[r][c] : 0,
               row: r, col: c,
               cageId: cage.id,
               isFixed: isGiven,
               showClue: isTopLeft,
               clueText: isTopLeft ? _clueText(cage) : '',
             )
         solution: solution
         cages: cages

  bool _solveLatinSquare(List<List<int>> grid, int row, int col):
    If row == 4: return true (all cells filled).
    int nextRow = col == 3 ? row + 1 : row;
    int nextCol = col == 3 ? 0 : col + 1;
    If grid[row][col] != 0: return _solveLatinSquare(grid, nextRow, nextCol). (skip fixed)
    Create a shuffled copy of [1, 2, 3, 4].
    For each num in that list:
      If _isSafeLatinSquare(grid, row, col, num):
        grid[row][col] = num
        If _solveLatinSquare(grid, nextRow, nextCol): return true
        grid[row][col] = 0   (backtrack)
    return false

  bool _isSafeLatinSquare(List<List<int>> grid, int row, int col, int num):
    num is not already in row `row` (check cols 0-3).
    num is not already in col `col` (check rows 0-3).
    Return true if both checks pass.

  (List<Cage>, List<List<int>>) _generateCages(List<List<int>> grid, Difficulty difficulty):
    1. Create cageIdGrid = List.generate(4, (_) => List.filled(4, -1)).
    2. Create a list of all 16 positions as (row, col) pairs, shuffle it:
         positions = [(r, c) for r in 0..3 for c in 0..3]..shuffle(_random)
    3. cages = <Cage>[], nextCageId = 0.
    4. For each (startRow, startCol) in positions:
         If cageIdGrid[startRow][startCol] != -1: continue (already assigned).
         Decide maxCageSize:
           easy:   50% chance → maxSize = 1 (single-cell given), else maxSize = 2
           medium: maxSize = 4
         Grow the cage:
           cageCells = [(startRow, startCol)]
           cageIdGrid[startRow][startCol] = nextCageId
           While cageCells.length < maxSize:
             frontier = all cells adjacent (up/down/left/right) to any cell in cageCells
                        that have cageIdGrid == -1
             If frontier.isEmpty: break
             next = frontier[_random.nextInt(frontier.length)]
             cageCells.add(next)
             cageIdGrid[next.row][next.col] = nextCageId
         Sort cageCells by reading order: by row then by col.
           (This ensures cageCells.first is always the top-left cell of the cage.)
         Assign operation and target: call _assignOperation(grid, cageCells, difficulty).
         cages.add(Cage(
           id: nextCageId,
           cells: cageCells.map((p) => CagePos(row: p.row, col: p.col)).toList(),
           operation: op,
           target: target,
         ))
         nextCageId++
    5. Return (cages, cageIdGrid).

  (Operation, int) _assignOperation(List<List<int>> grid, List<(int,int)> cells, Difficulty d):
    values = [grid[r][c] for (r, c) in cells]
    If cells.length == 1:
      return (Operation.given, values[0])
    int sum = values.fold(0, (a, b) => a + b)
    int product = values.fold(1, (a, b) => a * b)
    If d == Difficulty.easy:
      Use addition if product > 12, else randomly pick add or multiply:
        if product > 12: return (Operation.add, sum)
        return _random.nextBool() ? (Operation.add, sum) : (Operation.multiply, product)
    Else (medium):
      If cells.length == 2:
        int a = values.reduce(max), b = values.reduce(min)
        List<(Operation, int)> choices = [
          (Operation.add, sum),
          (Operation.subtract, a - b),
          (Operation.multiply, product),
        ]
        if (a % b == 0) choices.add((Operation.divide, a ~/ b))
        return choices[_random.nextInt(choices.length)]
      Else (3+ cells, medium):
        if product <= 24: return _random.nextBool() ? (Operation.add, sum) : (Operation.multiply, product)
        return (Operation.add, sum)

  String _clueText(Cage cage):
    switch cage.operation:
      Operation.given:    return '${cage.target}'
      Operation.add:      return '${cage.target}+'
      Operation.subtract: return '${cage.target}−'
      Operation.multiply: return '${cage.target}×'
      Operation.divide:   return '${cage.target}÷'

=== lib/features/game/domain/logic/mathdoku_engine.dart ===

enum GroupStatus { incomplete, correct, incorrect }

class MathdokuEngine {

  GroupStatus checkGroupStatus(List<Cell> group):
    Track seen values in a Set<int>.
    If any non-zero value appears more than once → incorrect.
    If the group is full (no zeroes) and no duplicates → correct.
    Otherwise → incomplete.

  bool isCageSatisfied(Cage cage, Board board):
    values = [board.getCell(pos.row, pos.col).value for pos in cage.cells]
    If any value == 0: return false (not complete, not satisfied)
    switch cage.operation:
      given:    return values.single == cage.target
      add:      return values.fold(0, (a,b) => a+b) == cage.target
      subtract: return (values[0] - values[1]).abs() == cage.target  (2-cell only)
      multiply: return values.fold(1, (a,b) => a*b) == cage.target
      divide:
        int a = values.reduce(max), b = values.reduce(min)
        return b != 0 && a % b == 0 && a ~/ b == cage.target  (2-cell only)

  CellStatus cageStatusForCell(Cage cage, Board board):
    values = [board.getCell(pos.row, pos.col).value for pos in cage.cells]
    If any value == 0: return CellStatus.normal  (incomplete)
    return isCageSatisfied(cage, board) ? CellStatus.correct : CellStatus.incorrect

  bool isValid(Board board):
    Check all 4 rows: if any row has GroupStatus.incorrect → return false.
    Check all 4 cols: if any col has GroupStatus.incorrect → return false.
    NO box checks — Mathdoku has no box constraint.
    Return true.
}

No build_runner needed for these files (no annotations). Confirm no analysis errors.
```

---

## PART 4 — Repository & State Provider

**Goal: repository layer and full Riverpod game state with break timer.**

```
Implement the repository and the Riverpod state management.

=== lib/features/game/domain/repositories/puzzle_repository.dart ===

abstract interface class PuzzleRepository {
  Board generatePuzzle(Difficulty difficulty);
}

=== lib/features/game/data/repositories/puzzle_repository_impl.dart ===

class PuzzleRepositoryImpl implements PuzzleRepository {
  final _generator = MathdokuGenerator();

  @override
  Board generatePuzzle(Difficulty difficulty) => _generator.generate(difficulty);
}

=== lib/features/game/presentation/providers/game_provider.dart ===

Use riverpod_annotation. Create:

@riverpod
PuzzleRepository puzzleRepository(Ref ref) => PuzzleRepositoryImpl();

@Riverpod(keepAlive: true)
class GameNotifier extends _$GameNotifier {
  static const int breakIntervalSeconds = 600; // 10 minutes

  final _engine = MathdokuEngine();
  final _generator = MathdokuGenerator();
  Timer? _timer;

  @override
  GameState build() {
    ref.onDispose(() => _timer?.cancel());
    return const GameState();
  }

  Future<void> startGame(Difficulty difficulty):
    1. Set status = GameStatus.loading.
    2. Generate board: _generator.generate(difficulty).
    3. Reset: elapsedSeconds=0, playSecondsThisSegment=0, mistakes=0,
              selectedRow=null, selectedCol=null.
    4. Set status = GameStatus.playing.
    5. Cancel any existing timer, start a new periodic Timer (1 second):
         - Increment elapsedSeconds always.
         - Only increment playSecondsThisSegment when status == playing.
         - If playSecondsThisSegment >= breakIntervalSeconds:
             set status = GameStatus.breakTime
             (timer keeps running for elapsedSeconds tracking).

  void acknowledgeBreak():
    Reset playSecondsThisSegment = 0.
    Set status = GameStatus.playing.

  void selectCell(int row, int col):
    Guard: status must be playing.
    Update selectedRow, selectedCol.
    Call _highlightCells(row, col).

  void _highlightCells(int row, int col):
    Get the value of the selected cell.
    For every cell, compute:
      isSelected    = (cell.row == row && cell.col == col)
      isHighlighted = same row OR same col
                      (NO box highlight — Mathdoku has no box constraint)
      isSameNumber  = selectedValue != 0 && cell.value == selectedValue
    Rebuild board with updated cells.

  void togglePencilMode():
    state = state.copyWith(isPencilMode: !state.isPencilMode)

  void inputNumber(int number):
    Guard: status == playing, selectedRow/Col not null.
    Guard: cell.isFixed == false.

    If state.isPencilMode:
      Guard: cell.value == 0 (notes only go on empty cells).
      Toggle the digit in cell.notes:
        If notes contains number → remove it.
        Else → add it.
      Rebuild board with updated notes. Return early (no solution check).

    Pen mode (normal):
    Lookup correct answer from board.getSolutionValue(row, col).
    If number != correct: increment mistakes, set cell isError=true.
    If number == correct:
      Set cell: value=number, isError=false, notes=[].
      Auto-remove the placed digit from notes in all cells in the same row and column.
    Call _updateGroupStatuses() then _highlightCells(row, col).
    Check board.isComplete → status = won, cancel timer.

  void eraseCell():
    Guard: status == playing, selectedRow/Col not null, cell not fixed.
    If cell.value != 0:
      Clear value only (set value=0, isError=false). Notes are preserved and become visible.
    Else (already empty):
      Clear notes (set notes=[]).
    Call _updateGroupStatuses() then _highlightCells(row, col).

  void useHint():
    Guard: status == playing.
    If no cell is selected OR the selected cell is already fixed:
      find the first empty/error non-fixed cell in reading order (row 0→3, col 0→3).
      Use that as the target cell.
    If still no target found: return early.
    Get correctValue from solution.
    Set cell: value=correctValue, isFixed=true, isError=false, notes=[].
    Update selectedRow/selectedCol to point at the hinted cell (so it visually highlights).
    Call _updateGroupStatuses() then _highlightCells(row, col).
    Check board.isComplete → status = won, cancel timer.

  void _updateGroupStatuses():
    For each of the 4 rows → checkGroupStatus → apply rowStatus to each cell in row.
    For each of the 4 cols → checkGroupStatus → apply colStatus to each cell in col.
    For each Cage in board.cages → cageStatusForCell(cage, board) → apply cageStatus
      to EVERY cell in that cage (so the whole cage lights up green/orange together).
    Update state.board.
    (NO block/box status updates — Mathdoku has no box constraint.)

  CellStatus _toCellStatus(GroupStatus s):
    correct   → CellStatus.correct
    incorrect → CellStatus.incorrect
    else      → CellStatus.normal
}

Run: dart run build_runner build --delete-conflicting-outputs
Confirm success with no errors.
```

---

## PART 5 — Theme & Main Entry Point

**Goal: child-friendly theme and app wiring.**

```
Implement the visual theme and main.dart.

=== lib/core/theme/app_theme.dart ===

Import google_fonts and material.

Define these colour constants:
  kPrimary    = Color(0xFFFF6B6B)   // coral — warm, fun
  kSecondary  = Color(0xFF4ECDC4)   // teal — friendly
  kBackground = Color(0xFFFFF9F0)   // warm cream — easy on young eyes
  kSurface    = Color(0xFFFFFFFF)

Create ThemeData kidsTheme:
  useMaterial3: true
  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimary,
    secondary: kSecondary,
    surface: kSurface,
    brightness: Brightness.light,
  ).copyWith(surface: kBackground)
  scaffoldBackgroundColor: kBackground
  textTheme: GoogleFonts.nunitoTextTheme()
  appBarTheme: AppBarTheme(
    backgroundColor: kPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
  )
  elevatedButtonTheme: rounded corners radius 16, padding vertical 14 horizontal 24
  outlinedButtonTheme: rounded corners radius 16

Export only kidsTheme and the colour constants.

=== lib/main.dart ===

void main() {
  runApp(const ProviderScope(child: MathdokuApp()));
}

class MathdokuApp extends StatelessWidget:
  MaterialApp(
    title: 'Mathdoku',
    theme: kidsTheme,
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  )

Run flutter analyze — fix all errors and warnings before continuing.
```

---

## PART 6 — Mathdoku Grid Widget

**Goal: the visual 4×4 game grid with cage boundaries and clue labels.**

```
Implement lib/features/game/presentation/widgets/mathdoku_grid.dart

This widget is more complex than a standard Sudoku grid because:
  - Cell borders must be THICK between cells in different cages,
    and THIN between cells in the same cage.
  - Each cage's top-left cell displays a small clue label (e.g. "6+", "12×").
  - Each cage is tinted with a subtle pastel background colour so the player
    can instantly see which cells belong together.

=== MathdokuGrid (ConsumerWidget) ===

Reads gameNotifierProvider. If board is null returns SizedBox.shrink().

Renders an AspectRatio(1.0) container with:
  - Outer border: BoxDecoration(border: Border.all(color: kPrimary, width: 4),
                               borderRadius: BorderRadius.circular(8))
  - GridView.builder: crossAxisCount 4, itemCount 16, NeverScrollableScrollPhysics,
                      padding: EdgeInsets.zero
  - Each item: _MathdokuCell(cell: board.getCell(row, col), board: board)
    where row = index ~/ 4, col = index % 4

=== Cage colours ===

Define a top-level constant list (not inside any class):

const List<Color> kCageColors = [
  Color(0xFFFFEBEE), // pastel red
  Color(0xFFE3F2FD), // pastel blue
  Color(0xFFE8F5E9), // pastel green
  Color(0xFFFFF8E1), // pastel yellow
  Color(0xFFF3E5F5), // pastel purple
  Color(0xFFE0F7FA), // pastel cyan
  Color(0xFFFBE9E7), // pastel orange
  Color(0xFFF1F8E9), // pastel lime
  Color(0xFFE8EAF6), // pastel indigo
  Color(0xFFE1F5FE), // pastel light-blue
];

// Saturated border colours — one per cage, matched to kCageColors hues.
// Use kCageBorderColors[cell.cageId % kCageBorderColors.length] for inter-cage borders.
const List<Color> kCageBorderColors = [
  Color(0xFFE57373), // red
  Color(0xFF64B5F6), // blue
  Color(0xFF81C784), // green
  Color(0xFFFFD54F), // yellow
  Color(0xFFBA68C8), // purple
  Color(0xFF4DD0E1), // cyan
  Color(0xFFFF8A65), // orange
  Color(0xFFAED581), // lime
  Color(0xFF7986CB), // indigo
  Color(0xFF4FC3F7), // light-blue
];

=== _MathdokuCell (ConsumerWidget) ===

Parameters:
  final Cell cell
  final Board board

Background colour (check in this priority order):
  1. cell.isSelected    → kPrimary.withOpacity(0.50)
  2. cell.isSameNumber  → kSecondary.withOpacity(0.35)
  3. cell.isHighlighted → Colors.grey.withOpacity(0.20)
  4. Cage tint:          kCageColors[cell.cageId % kCageColors.length]

Border logic — for each of the 4 sides compute a BorderSide using _borderSide():

  BorderSide _borderSide(Board board, Cell cell, int dr, int dc):
    nr = cell.row + dr
    nc = cell.col + dc
    If nr < 0 || nr > 3 || nc < 0 || nc > 3:
      return BorderSide(width: 4.0, color: Colors.black87)   // grid edge
    neighbor = board.getCell(nr, nc)
    if neighbor.cageId == cell.cageId:
      return BorderSide(width: 1.5, color: Colors.grey.shade500)  // same cage
    else:
      return BorderSide(   // cage boundary — each cage uses its own colour
        width: 3.5,
        color: kCageBorderColors[cell.cageId % kCageBorderColors.length],
      )

  Apply:
    Border(
      top:    _borderSide(board, cell,  -1, 0),
      right:  _borderSide(board, cell,  0,  1),
      bottom: _borderSide(board, cell,  1,  0),
      left:   _borderSide(board, cell,  0, -1),
    )

Cell content — use a Stack:

  Layer 1 (clue text, top-left corner):
    If cell.showClue:
      Positioned(top: 2, left: 3):
        Text(
          cell.clueText,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: Colors.black87,
            height: 1.0,
          ),
        )

  Layer 2 (pencil notes, shown when cell.value == 0 && cell.notes.isNotEmpty):
    Positioned.fill → Padding(left:2, top: 18 if showClue else 4, right:2, bottom:4):
      Column of two Expanded Rows:
        Row 1: _NoteDigit(digit:1, notes:cell.notes)  _NoteDigit(digit:2, notes:cell.notes)
        Row 2: _NoteDigit(digit:3, notes:cell.notes)  _NoteDigit(digit:4, notes:cell.notes)

      _NoteDigit: Expanded → Center → Text(digit if in notes else '',
        style: TextStyle(fontSize:11, fontWeight: bold, color: Colors.blueGrey.shade700))

  Layer 3 (player digit, centred):
    If cell.value != 0:
      Center:
        Text(
          '${cell.value}',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color:
              cell.isError  → Colors.red.shade600
              cell.isFixed  → Colors.black87
              else          → Colors.green.shade700,   // user-entered correct digit
          ),
        )

Cage status border overlay (applies on top of the cage tint):
  If cell.cageStatus == CellStatus.correct:
    add a subtle green overlay: Colors.green.withOpacity(0.15) blended into background
  If cell.cageStatus == CellStatus.incorrect:
    add a subtle orange overlay: Colors.orange.withOpacity(0.15)
  Simplest implementation: use a ColoredBox or Container with color overlay in the Stack
  behind the clue and digit layers.

Animations (flutter_animate):
  cell.isSelected → pulse: scale 1.0→1.06, 700ms, easeInOut, looping with reverse
  cell.isError    → .shake(hz: 6, duration: 350.ms) followed by .tint(color: Colors.red, duration: 300.ms)

On tap:
  HapticFeedback.lightImpact()
  ref.read(gameNotifierProvider.notifier).selectCell(cell.row, cell.col)
```

---

## PART 7 — Number Pad & Action Buttons

**Goal: large child-friendly number pad and game action buttons.**

```
Implement lib/features/game/presentation/widgets/number_pad.dart

=== NumberPad (ConsumerWidget) ===

A Row of 4 large buttons, one per digit (1, 2, 3, 4).

Each digit has a unique pastel fill colour:
  1 → Color(0xFFFFADAD)  — pastel coral
  2 → Color(0xFFB5EAD7)  — pastel mint
  3 → Color(0xFFFFDAC1)  — pastel peach
  4 → Color(0xFFC7CEEA)  — pastel lavender

Each button:
  - Flexible(flex:1) inside the Row, with 6px horizontal margin between buttons
  - Height: 72
  - Shape: RoundedRectangleBorder(radius: 16)
  - Child: Text('$digit', fontSize: 34, fontWeight: bold, color: Colors.black87)
  - If digit is "complete" (all 4 instances of that digit are on the board correctly,
    i.e. value == digit AND isError == false):
      Opacity 0.35, disabled, show a small ✓ checkmark in the top-right corner
  - On tap: ref.read(gameNotifierProvider.notifier).inputNumber(digit)

To check if a digit is complete:
  Iterate all 16 cells. Count cells where value == digit && isError == false.
  If count >= 4, the digit is complete.

=== ActionRow (ConsumerWidget) ===

Watch isPencilMode from gameNotifierProvider.

A Row with THREE equal-width Expanded buttons, separated by SizedBox(width: 8):

"💡 Hint" — ElevatedButton:
  backgroundColor: Color(0xFFFFD700) — gold
  foregroundColor: Colors.black87
  fontSize: 16, height: 56, rounded corners 14
  Always enabled (unlimited hints for children)
  On tap: ref.read(gameNotifierProvider.notifier).useHint()

"✏️ Notes" / "✏️ Notes ON" — ElevatedButton (toggle):
  backgroundColor: isPencilMode ? Colors.blueGrey.shade600 : Colors.blueGrey.shade100
  foregroundColor: isPencilMode ? Colors.white : Colors.blueGrey.shade700
  label: isPencilMode ? '✏️ Notes ON' : '✏️ Notes'
  fontSize: 15, height: 56, rounded corners 14
  On tap: ref.read(gameNotifierProvider.notifier).togglePencilMode()

"🧹 Erase" — OutlinedButton:
  borderColor: Colors.grey.shade400
  fontSize: 16, height: 56, rounded corners 14
  On tap: ref.read(gameNotifierProvider.notifier).eraseCell()
  Note: first press clears the placed digit (notes reappear); second press clears notes.
```

---

## PART 8 — Home Page & Privacy Policy

**Goal: welcoming home screen with difficulty selection.**

```
Implement lib/features/home/presentation/pages/home_page.dart
and lib/features/home/presentation/pages/privacy_policy_page.dart

=== HomePage (ConsumerWidget) ===

Scaffold:
  appBar: AppBar(title: Text('Mathdoku'), centerTitle: true)
  body: SafeArea → SingleChildScrollView → Padding(horizontal: 32) → Column:

    SizedBox(height: 32)

    Center → Text('🔢', style: TextStyle(fontSize: 90))
      .animate().scale(duration: 600.ms, curve: Curves.elasticOut)

    SizedBox(height: 16)

    Center → Text('Mathdoku',
      style: TextStyle(fontSize: 36, fontWeight: bold, color: kPrimary))

    SizedBox(height: 8)

    Center → Text('Math puzzles made fun!',
      style: TextStyle(fontSize: 17, color: Colors.grey.shade600))

    SizedBox(height: 48)

    Center → Text('Choose your level:',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))

    SizedBox(height: 20)

    _DifficultyButton(
      emoji: '⭐',
      label: 'Easy',
      subtitle: 'Addition & multiplication only',
      colour: Color(0xFFB5EAD7),
      onTap: () {
        ref.read(gameNotifierProvider.notifier).startGame(Difficulty.easy);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GamePage()));
      },
    )

    SizedBox(height: 16)

    _DifficultyButton(
      emoji: '⭐⭐',
      label: 'Medium',
      subtitle: 'All four operations',
      colour: Color(0xFFFFDAC1),
      onTap: () {
        ref.read(gameNotifierProvider.notifier).startGame(Difficulty.medium);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GamePage()));
      },
    )

    SizedBox(height: 48)

    Center → TextButton(
      onPressed: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => const PrivacyPolicyPage())),
      child: Text('Privacy Policy', style: TextStyle(color: Colors.grey)),
    )

    SizedBox(height: 16)

_DifficultyButton (StatelessWidget):
  A GestureDetector wrapping a Container:
    width: double.infinity, height: 80
    decoration: BoxDecoration(
      color: colour,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,3))]
    )
  Inside: Row(padding 20):
    Text(emoji, fontSize: 28)
    SizedBox(width: 16)
    Column(crossAxisAlignment: start):
      Text(label, fontSize: 22, fontWeight: bold)
      Text(subtitle, fontSize: 13, color: grey)
    Spacer()
    Icon(Icons.arrow_forward_ios, color: Colors.black45, size: 18)

=== PrivacyPolicyPage (StatelessWidget) ===

Scaffold:
  AppBar(title: Text('Privacy Policy'))
  Body: SingleChildScrollView → Padding(32) → Column:
    Text('Privacy Policy', fontSize: 24, bold)
    SizedBox(height: 16)
    Text(
      'Mathdoku does not collect, store, or share any personal data.\n\n'
      'This app works entirely offline. No internet connection is required to play.\n\n'
      'This app contains no advertisements of any kind.\n\n'
      'No in-app purchases are available.\n\n'
      'If you have any questions, please contact the developer.',
      fontSize: 16, height: 1.7
    )
```

---

## PART 9 — Game Page

**Goal: the main gameplay screen with stats, grid, number pad, and win dialog.**

```
Implement lib/features/game/presentation/pages/game_page.dart

=== GamePage (ConsumerStatefulWidget) ===

initState: _confettiController = ConfettiController(duration: Duration(seconds: 3))
dispose: _confettiController.dispose()

ref.listen on gameState.status:
  If won:       _confettiController.play(); _showWinDialog()
  If breakTime: Navigator.push(context, MaterialPageRoute(builder: (_) => const BreakPage()))

=== Scaffold ===

AppBar:
  title: Text('Mathdoku 🔢')
  centerTitle: true
  leading: IconButton(icon: Icon(Icons.home), onPressed: () => Navigator.pop(context))

Body: Stack [

  Layer 1 — game content:
    LayoutBuilder to detect screen width:
      isWide = constraints.maxWidth > 600

    Column:
      _StatsBar(state: gameState)
      Expanded:
        if isWide → Row [
          Expanded:
            LayoutBuilder → Center → SizedBox.square(
              dimension: min(availableHeight - 32, availableWidth - 32),
              child: MathdokuGrid()
            )
          Container(width: 300, padding: all 24):
            Column(mainAxisAlignment: center):
              NumberPad()
              SizedBox(height: 20)
              ActionRow()
        ]
        if narrow → Column [
          Expanded:
            LayoutBuilder → Center → SizedBox.square(
              dimension: min(availableWidth - 32, availableHeight - 32),
              child: MathdokuGrid()
            )
          SizedBox(12)
          Padding(horizontal: 20) → NumberPad()
          SizedBox(12)
          Padding(horizontal: 20) → ActionRow()
          SizedBox(28)
        ]

  Layer 2 — confetti:
    Align(topCenter) → ConfettiWidget(
      confettiController: _confettiController,
      blastDirectionality: BlastDirectionality.explosive,
      maxBlastForce: 25,
      minBlastForce: 10,
      emissionFrequency: 0.05,
      numberOfParticles: 40,
      gravity: 0.12,
      colors: [red, green, blue, yellow, pink, orange, purple, teal]
    )
]

=== _StatsBar (StatelessWidget, receives GameState) ===

Container:
  color: kPrimary.withOpacity(0.08)
  padding: vertical 10, horizontal 24
  child: Row(mainAxisAlignment: spaceBetween):
    Row: [Icon(Icons.timer_outlined, size:20), SizedBox(6), Text(formattedTime, fontSize:18, bold)]
    Row: [Text('Oops: ', fontSize:18), Text('${state.mistakes}', fontSize:18, bold, color:kPrimary)]

formattedTime: '${(elapsedSeconds~/60).toString().padLeft(2,'0')}:${(elapsedSeconds%60).toString().padLeft(2,'0')}'

=== Keyboard support ===

Wrap the body Stack in:
  Focus(focusNode: _focusNode, autofocus: true, onKeyEvent: _handleKeyEvent, child: Stack(...))

Add FocusNode _focusNode to state; init in initState, dispose in dispose.

_handleKeyEvent(FocusNode node, KeyEvent event) → KeyEventResult:
  Only fire on KeyDownEvent or KeyRepeatEvent.
  Guard: status must be playing.

  Arrow keys (also fire on KeyRepeatEvent):
    ArrowUp    → selectCell((curRow - 1).clamp(0,3), curCol)
    ArrowDown  → selectCell((curRow + 1).clamp(0,3), curCol)
    ArrowLeft  → selectCell(curRow, (curCol - 1).clamp(0,3))
    ArrowRight → selectCell(curRow, (curCol + 1).clamp(0,3))
  (If no cell selected, curRow/curCol default to 0.)

  The following only fire on KeyDownEvent (not repeat):
    1 / numpad1 → inputNumber(1)
    2 / numpad2 → inputNumber(2)
    3 / numpad3 → inputNumber(3)
    4 / numpad4 → inputNumber(4)
    Delete / Backspace → eraseCell()
    H → useHint()
    P → togglePencilMode()

  Note: inputNumber() already respects isPencilMode, so the keyboard
  automatically writes notes when pencil mode is active.

=== _showWinDialog ===

showDialog, barrierDismissible: false.
AlertDialog:
  content: Column(mainAxisSize: min):
    Text('🏆', fontSize: 80)
      .animate().scale(duration:700.ms, curve: Curves.elasticOut)
    SizedBox(16)
    Text('Amazing Work! 🎉', fontSize:26, bold, color:Colors.green)
      .animate().fadeIn(delay:300.ms)
    SizedBox(8)
    Text('You solved the puzzle!', fontSize:16, color:grey)
      .animate().fadeIn(delay:500.ms)
    SizedBox(8)
    Text('Time: $formattedTime', fontSize:15)
      .animate().fadeIn(delay:600.ms)
  actions: [Center → ElevatedButton(
    onPressed: () { Navigator.pop(context); Navigator.pop(context); },
    child: Text('Play Again! ▶', fontSize:18),
    style: min width 200, height 52, rounded 14
  ).animate().fadeIn(delay:800.ms)]
```

---

## PART 10 — Break Page

**Goal: mandatory full-screen break reminder that cannot be skipped.**

```
Implement lib/features/game/presentation/pages/break_page.dart

=== BreakPage (ConsumerWidget) ===

This is a FULL-SCREEN takeover. The child must tap the button — they cannot
use the back button or swipe to dismiss this screen.

Use PopScope(canPop: false, ...) to block back navigation.

Scaffold:
  backgroundColor: Color(0xFFFFF3CD)  — warm yellow
  No AppBar

Body: SafeArea → Center → Padding(horizontal: 32) → Column(mainAxisAlignment: center):

  Text('😊', style: TextStyle(fontSize: 100))
    .animate(onPlay: (c) => c.repeat(reverse: true))
    .scale(begin: Offset(1,1), end: Offset(1.08,1.08), duration: 1200.ms, curve: Curves.easeInOut)

  SizedBox(height: 32)

  Text('Break Time!',
    textAlign: center,
    style: TextStyle(fontSize: 42, fontWeight: bold, color: Color(0xFFE67E22)))
    .animate().fadeIn(duration: 400.ms)

  SizedBox(height: 20)

  Text(
    "You've been playing for 10 minutes.\n\n"
    "Time to rest your eyes! 👀\n\n"
    "Stretch, get some water,\nand come back when you're ready! 😄",
    textAlign: center,
    style: TextStyle(fontSize: 18, color: Color(0xFF555555), height: 1.7),
  ).animate().fadeIn(delay: 200.ms)

  SizedBox(height: 56)

  ElevatedButton(
    onPressed: () {
      ref.read(gameNotifierProvider.notifier).acknowledgeBreak();
      Navigator.pop(context);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF4ECDC4),
      foregroundColor: Colors.white,
      minimumSize: Size(240, 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    ),
    child: Text("I'm Ready! ▶"),
  ).animate().fadeIn(delay: 600.ms).moveY(begin: 20, end: 0)
```

---

## PART 11 — Final Check & Smoke Test

**Goal: confirm everything works end to end.**

```
Perform the following final checks and fix any issues found.

1. Run: dart run build_runner build --delete-conflicting-outputs
   Confirm: exits with no errors.

2. Run: flutter analyze
   Confirm: zero errors, zero warnings.
   Fix anything reported before continuing.

3. Security check — confirm zero ad packages:
   Run: grep -ri "admob\|google_mobile_ads\|ad_sdk\|advert" pubspec.lock
   It must return nothing.

4. Run: flutter run (on a connected device or emulator)
   Perform this manual smoke test in order:

   a. App launches → Home Page shows "Mathdoku", 🔢 emoji, two difficulty buttons
      ("Easy" and "Medium"), "Privacy Policy" link at the bottom.

   b. Tap "Easy" → navigates to Game Page. A 4×4 grid appears with:
      - Cells grouped into cages, each cage tinted in a distinct pastel colour.
      - Thick borders between different cages, thin borders within the same cage.
      - Clue labels (e.g. "6+", "3×", "2") visible in the top-left corner of each cage.
      - Some single-cell cages are pre-filled (isFixed) with their digit.

   c. Tap an empty cell → it highlights with a coral/primary tint.
      Cells in the same row and column also highlight (no box highlight in Mathdoku).

   d. Tap a digit on the number pad → it appears in the selected cell.
      If correct: shown in primary colour.
      If wrong: cell shakes, digit shown in red, "Oops" counter increments.

   e. Tap "✏️ Notes" → button turns dark and shows "Notes ON".
      Tap an empty cell, then tap digit buttons → small candidate numbers appear in a
      2×2 mini-grid inside the cell. Tapping the same digit removes it.
      Tap "✏️ Notes ON" again → returns to pen mode.
      In pen mode, entering the correct digit clears the cell's notes and removes
      that digit from notes in the same row and column.
      Press P on the keyboard to toggle pencil mode without using the button.
      First "🧹 Erase" press on a filled cell → clears the value (notes reappear).
      Second press (cell now empty) → clears the notes.

   f. Tap "💡 Hint" with an empty cell selected → correct value fills in for free.
      Hint also clears any notes on the hinted cell.

   f. When all cells in a cage are correctly filled, the cage tints green.
      When a cage has an error, the cage tints orange.

   g. Complete the entire puzzle correctly → confetti explodes, win dialog shows
      "Amazing Work! 🎉" with the elapsed time.
      Tap "Play Again!" → returns to Home Page.

   h. Break timer test: temporarily change breakIntervalSeconds = 10 in game_provider.dart,
      start a game, wait 10 seconds → BreakPage appears full screen.
      Attempt to use the back button/gesture → it is blocked (cannot dismiss).
      Tap "I'm Ready! ▶" → game resumes.
      Change breakIntervalSeconds back to 600 after testing.

   i. Tap "Medium" from Home Page → generates a new puzzle with larger cages and all
      four arithmetic operations visible in clue labels (−, ÷ may appear).

   j. Tap the home icon in the AppBar → returns to Home Page.

5. Report the outcome of each step a–j.
   If any step fails, identify the root cause and fix it before reporting complete.
```

---

## Quick reference — key design decisions

| Decision | Reason |
|---|---|
| 4×4 grid only | Age-appropriate; solvable in minutes; builds confidence and arithmetic fluency |
| Cage colours (pastel tints per cage) | Instantly shows which cells belong together without the child needing to trace thick borders |
| Thick cage borders / thin intra-cage borders | Classic Mathdoku visual convention; essential for understanding the puzzle structure |
| Clue in top-left cell only | Keeps the grid uncluttered; top-left is the universal Mathdoku standard |
| Easy: + and × only, some pre-filled | Reduces cognitive load; supports children learning multiplication tables |
| Medium: all four operations, no pre-fills | Exercises division and subtraction; closer to classic Mathdoku |
| No box constraint | Mathdoku rule — only rows and columns must be unique, not 2×2 boxes |
| Highlight row + column only (no box) | Correctly reflects Mathdoku rules; avoids misleading the player |
| Solution-based error checking | Immediate gentle feedback helps children learn; avoids pure trial-and-error |
| Pencil / notes mode | Players jot candidate digits (1–4) in a 2×2 mini-grid per cell; auto-cleared when the correct digit is placed in the same row/column |
| Unlimited hints | Children learn by seeing answers; no frustration spiral |
| Mandatory 10-min breaks | Screen-time hygiene; back-button blocked so it cannot be skipped |
| Zero advertisements | Child safety; regulatory compliance (COPPA/GDPR-K) |
