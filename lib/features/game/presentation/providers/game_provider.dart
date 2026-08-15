// Copyright © App Verse Games. All rights reserved.
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/cell.dart';
import '../../domain/models/game_state.dart';
import '../../domain/repositories/puzzle_repository.dart';
import '../../data/repositories/puzzle_repository_impl.dart';
import '../../domain/logic/mathdoku_engine.dart';
import '../../domain/logic/mathdoku_generator.dart';

part 'game_provider.g.dart';

@riverpod
PuzzleRepository puzzleRepository(PuzzleRepositoryRef ref) =>
    PuzzleRepositoryImpl();

@Riverpod(keepAlive: true)
class GameNotifier extends _$GameNotifier {
  static const int _breakInterval = 600; // 10 minutes

  final _engine = MathdokuEngine();
  final _generator = MathdokuGenerator();
  Timer? _timer;

  @override
  GameState build() {
    ref.onDispose(() => _timer?.cancel());
    return const GameState();
  }

  Future<void> startGame(Difficulty difficulty) async {
    state = state.copyWith(status: GameStatus.loading, difficulty: difficulty);

    final board = _generator.generate(difficulty);

    state = state.copyWith(
      board: board,
      status: GameStatus.playing,
      elapsedSeconds: 0,
      playSecondsThisSegment: 0,
      mistakes: 0,
      selectedRow: null,
      selectedCol: null,
    );

    _startTimer();
    _updateGroupStatuses();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      if (state.status == GameStatus.playing) {
        final next = state.playSecondsThisSegment + 1;
        if (next >= _breakInterval) {
          state = state.copyWith(
            playSecondsThisSegment: next,
            status: GameStatus.breakTime,
          );
        } else {
          state = state.copyWith(playSecondsThisSegment: next);
        }
      }
    });
  }

  void acknowledgeBreak() {
    state = state.copyWith(
      playSecondsThisSegment: 0,
      status: GameStatus.playing,
    );
  }

  void selectCell(int row, int col) {
    if (state.status != GameStatus.playing) return;
    state = state.copyWith(selectedRow: row, selectedCol: col);
    _highlightCells(row, col);
  }

  void _highlightCells(int row, int col) {
    if (state.board == null) return;
    final selectedValue = state.board!.getCell(row, col).value;

    final newCells = state.board!.cells.map<List<Cell>>((r) {
      return r.map<Cell>((cell) {
        return cell.copyWith(
          isSelected: cell.row == row && cell.col == col,
          // Mathdoku: highlight row and column only — no box
          isHighlighted: cell.row == row || cell.col == col,
          isSameNumber: selectedValue != 0 && cell.value == selectedValue,
        );
      }).toList();
    }).toList();

    state = state.copyWith(board: state.board!.copyWith(cells: newCells));
  }

  void inputNumber(int number) {
    if (state.status != GameStatus.playing ||
        state.selectedRow == null ||
        state.selectedCol == null) { return; }

    final row = state.selectedRow!;
    final col = state.selectedCol!;
    final cell = state.board!.getCell(row, col);
    if (cell.isFixed) { return; }

    final correct = state.board!.getSolutionValue(row, col);
    final isCorrect = number == correct;

    if (!isCorrect) { state = state.copyWith(mistakes: state.mistakes + 1); }

    final newCells = state.board!.cells.map<List<Cell>>((r) {
      return r.map<Cell>((c) {
        if (c.row == row && c.col == col) {
          return c.copyWith(value: number, isError: !isCorrect);
        }
        return c;
      }).toList();
    }).toList();

    state = state.copyWith(board: state.board!.copyWith(cells: newCells));
    _updateGroupStatuses();
    _highlightCells(row, col);

    if (state.board!.isComplete) {
      state = state.copyWith(status: GameStatus.won);
      _timer?.cancel();
    }
  }

  void eraseCell() {
    if (state.status != GameStatus.playing ||
        state.selectedRow == null ||
        state.selectedCol == null) { return; }

    final row = state.selectedRow!;
    final col = state.selectedCol!;
    final cell = state.board!.getCell(row, col);
    if (cell.isFixed) { return; }

    final newCells = state.board!.cells.map<List<Cell>>((r) {
      return r.map<Cell>((c) {
        if (c.row == row && c.col == col) {
          return c.copyWith(value: 0, isError: false);
        }
        return c;
      }).toList();
    }).toList();

    state = state.copyWith(board: state.board!.copyWith(cells: newCells));
    _updateGroupStatuses();
    _highlightCells(row, col);
  }

  void useHint() {
    if (state.status != GameStatus.playing) { return; }

    int? row = state.selectedRow;
    int? col = state.selectedCol;

    // If no cell selected, or selected cell is already fixed, find first empty cell.
    if (row == null || col == null || state.board!.getCell(row, col).isFixed) {
      outer:
      for (int r = 0; r < 4; r++) {
        for (int c = 0; c < 4; c++) {
          final candidate = state.board!.getCell(r, c);
          if (!candidate.isFixed && (candidate.value == 0 || candidate.isError)) {
            row = r;
            col = c;
            break outer;
          }
        }
      }
    }

    if (row == null || col == null) { return; }

    final cell = state.board!.getCell(row, col);
    if (cell.isFixed) { return; }

    final correctValue = state.board!.getSolutionValue(row, col);

    final newCells = state.board!.cells.map<List<Cell>>((r) {
      return r.map<Cell>((c) {
        if (c.row == row && c.col == col) {
          return c.copyWith(value: correctValue, isError: false, isFixed: true);
        }
        return c;
      }).toList();
    }).toList();

    state = state.copyWith(
      board: state.board!.copyWith(cells: newCells),
      selectedRow: row,
      selectedCol: col,
    );
    _updateGroupStatuses();
    _highlightCells(row, col);

    if (state.board!.isComplete) {
      state = state.copyWith(status: GameStatus.won);
      _timer?.cancel();
    }
  }

  void _updateGroupStatuses() {
    if (state.board == null) return;

    final board = state.board!;
    final newCells = board.cells.map((r) => r.toList()).toList();

    // Row statuses
    for (int r = 0; r < 4; r++) {
      final status = _toCellStatus(_engine.checkGroupStatus(board.cells[r]));
      for (int c = 0; c < 4; c++) {
        newCells[r][c] = newCells[r][c].copyWith(rowStatus: status);
      }
    }

    // Column statuses
    for (int c = 0; c < 4; c++) {
      final col = [for (int r = 0; r < 4; r++) board.cells[r][c]];
      final status = _toCellStatus(_engine.checkGroupStatus(col));
      for (int r = 0; r < 4; r++) {
        newCells[r][c] = newCells[r][c].copyWith(colStatus: status);
      }
    }

    // Cage statuses (using original board values, before status updates)
    for (final cage in board.cages) {
      final cageStatus = _engine.cageStatusForCell(cage, board);
      for (final pos in cage.cells) {
        newCells[pos.row][pos.col] =
            newCells[pos.row][pos.col].copyWith(cageStatus: cageStatus);
      }
    }

    state = state.copyWith(board: board.copyWith(cells: newCells));
  }

  CellStatus _toCellStatus(GroupStatus s) => switch (s) {
        GroupStatus.correct => CellStatus.correct,
        GroupStatus.incorrect => CellStatus.incorrect,
        GroupStatus.incomplete => CellStatus.normal,
      };
}
