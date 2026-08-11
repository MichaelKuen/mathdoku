// Copyright © FullStackShack. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/cell.dart';
import '../../domain/repositories/puzzle_repository.dart';
import '../../data/repositories/puzzle_repository_impl.dart';
import '../../domain/logic/sudoku_engine.dart';
import '../../domain/logic/sudoku_generator.dart';

part 'game_provider.g.dart';

@riverpod
PuzzleRepository puzzleRepository(PuzzleRepositoryRef ref) {
  return PuzzleRepositoryImpl();
}

@Riverpod(keepAlive: true)
class GameNotifier extends _$GameNotifier {
  final _engine = SudokuEngine();
  final _generator = SudokuGenerator();
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
      mistakes: 0,
      hintsRemaining: 3,
      isPencilMode: false,
      selectedRow: null,
      selectedCol: null,
    );
    
    _startTimer();
    _updateGroupStatuses();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.status == GameStatus.playing) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      }
    });
  }

  void togglePencilMode() {
    state = state.copyWith(isPencilMode: !state.isPencilMode);
  }

  void selectCell(int row, int col) {
    if (state.status != GameStatus.playing) return;
    state = state.copyWith(selectedRow: row, selectedCol: col);
    _highlightCells(row, col);
  }

  void _highlightCells(int row, int col) {
    if (state.board == null) return;
    
    final selectedCell = state.board!.getCell(row, col);
    final selectedValue = selectedCell.value;
    
    final newCells = state.board!.cells.map<List<Cell>>((r) {
      return r.map<Cell>((cell) {
        final isSelected = cell.row == row && cell.col == col;
        final isHighlighted = cell.row == row || 
                             cell.col == col || 
                             (cell.row ~/ 3 == row ~/ 3 && cell.col ~/ 3 == col ~/ 3);
        
        // Number Scoping: Highlight other cells with same number
        final isSameNumber = selectedValue != 0 && cell.value == selectedValue;
        
        return cell.copyWith(
          isSelected: isSelected, 
          isHighlighted: isHighlighted,
          isSameNumber: isSameNumber,
        );
      }).toList();
    }).toList();
    
    state = state.copyWith(board: state.board!.copyWith(cells: newCells));
  }

  void inputNumber(int number) {
    if (state.status != GameStatus.playing || 
        state.selectedRow == null || 
        state.selectedCol == null) {
      return;
    }

    final row = state.selectedRow!;
    final col = state.selectedCol!;
    final cell = state.board!.getCell(row, col);

    if (cell.isFixed) return;

    if (state.isPencilMode) {
      if (cell.value != 0) return; // Can't add notes to a filled cell
      
      final newNotes = Set<int>.from(cell.notes);
      if (newNotes.contains(number)) {
        newNotes.remove(number);
      } else {
        newNotes.add(number);
      }

      final newCells = state.board!.cells.map<List<Cell>>((r) {
        return r.map<Cell>((c) {
          if (c.row == row && c.col == col) {
            return c.copyWith(notes: newNotes);
          }
          return c;
        }).toList();
      }).toList();

      state = state.copyWith(board: state.board!.copyWith(cells: newCells));
    } else {
      if (cell.value == number) return;

      final correctValue = state.board!.getSolutionValue(row, col);
      final isCorrect = number == correctValue;
      
      if (!isCorrect) {
        state = state.copyWith(mistakes: state.mistakes + 1);
      }

      final newCells = state.board!.cells.map<List<Cell>>((r) {
        return r.map<Cell>((c) {
          if (c.row == row && c.col == col) {
            return c.copyWith(value: number, isError: !isCorrect, notes: {});
          }
          return c;
        }).toList();
      }).toList();

      state = state.copyWith(board: state.board!.copyWith(cells: newCells));
      _updateGroupStatuses();
      _highlightCells(row, col); // Refresh highlighting for number scoping

      if (state.board!.isComplete) {
        state = state.copyWith(status: GameStatus.won);
        _timer?.cancel();
      }
    }
  }

  void eraseCell() {
    if (state.status != GameStatus.playing || 
        state.selectedRow == null || 
        state.selectedCol == null) {
      return;
    }

    final row = state.selectedRow!;
    final col = state.selectedCol!;
    final cell = state.board!.getCell(row, col);

    if (cell.isFixed) return;

    final newCells = state.board!.cells.map<List<Cell>>((r) {
      return r.map<Cell>((c) {
        if (c.row == row && c.col == col) {
          return c.copyWith(value: 0, isError: false, notes: {});
        }
        return c;
      }).toList();
    }).toList();

    state = state.copyWith(board: state.board!.copyWith(cells: newCells));
    _updateGroupStatuses();
    _highlightCells(row, col);
  }

  void useHint() {
    if (state.status != GameStatus.playing || 
        state.selectedRow == null || 
        state.selectedCol == null ||
        state.hintsRemaining <= 0) {
      return;
    }

    final row = state.selectedRow!;
    final col = state.selectedCol!;
    final cell = state.board!.getCell(row, col);

    if (cell.isFixed) return;

    final correctValue = state.board!.getSolutionValue(row, col);

    final newCells = state.board!.cells.map<List<Cell>>((r) {
      return r.map<Cell>((c) {
        if (c.row == row && c.col == col) {
          return c.copyWith(
            value: correctValue, 
            isError: false,
            isFixed: true, 
            notes: {},
          );
        }
        return c;
      }).toList();
    }).toList();

    state = state.copyWith(
      board: state.board!.copyWith(cells: newCells),
      hintsRemaining: state.hintsRemaining - 1,
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
    List<List<Cell>> newCells = board.cells.map((r) => r.toList()).toList();

    final isEasy = state.difficulty == Difficulty.easy;

    for (int rowBlock = 0; rowBlock < 3; rowBlock++) {
      for (int colBlock = 0; colBlock < 3; colBlock++) {
        final block = _engine.getBlock(board, rowBlock, colBlock);
        final status = _engine.checkGroupStatus(block);
        final cellStatus = _toCellStatus(status);

        for (int r = 0; r < 3; r++) {
          for (int c = 0; c < 3; c++) {
            int tr = rowBlock * 3 + r;
            int tc = colBlock * 3 + c;
            newCells[tr][tc] = newCells[tr][tc].copyWith(blockStatus: cellStatus);
          }
        }
      }
    }

    if (isEasy) {
      for (int r = 0; r < 9; r++) {
        final row = board.cells[r];
        final status = _engine.checkGroupStatus(row);
        final cellStatus = _toCellStatus(status);
        for (int c = 0; c < 9; c++) {
          newCells[r][c] = newCells[r][c].copyWith(rowStatus: cellStatus);
        }
      }

      for (int c = 0; c < 9; c++) {
        List<Cell> column = [];
        for (int r = 0; r < 9; r++) {
          column.add(board.cells[r][c]);
        }
        final status = _engine.checkGroupStatus(column);
        final cellStatus = _toCellStatus(status);
        for (int r = 0; r < 9; r++) {
          newCells[r][c] = newCells[r][c].copyWith(colStatus: cellStatus);
        }
      }
    }

    state = state.copyWith(board: board.copyWith(cells: newCells));
  }

  CellStatus _toCellStatus(GroupStatus status) {
    if (status == GroupStatus.correct) {
      return CellStatus.correct;
    }
    if (status == GroupStatus.incorrect) {
      return CellStatus.incorrect;
    }
    return CellStatus.normal;
  }
}
