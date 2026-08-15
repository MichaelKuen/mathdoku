// Copyright © App Verse Games. All rights reserved.
import 'dart:math';
import '../models/board.dart';
import '../models/cage.dart';
import '../models/cell.dart';
import '../models/game_state.dart';

class MathdokuGenerator {
  final _random = Random();

  // Grid size: 4 for Easy/Medium, 6 for Hard.
  int _sizeFor(Difficulty d) => d == Difficulty.hard ? 6 : 4;

  Board generate(Difficulty difficulty) {
    final size = _sizeFor(difficulty);

    final grid = List.generate(size, (_) => List.filled(size, 0));
    _solveLatinSquare(grid, 0, 0, size);

    final solution = List.generate(size, (r) => List<int>.from(grid[r]));
    final (cages, cageIdGrid) = _generateCages(grid, difficulty, size);

    final cells = List.generate(size, (r) {
      return List.generate(size, (c) {
        final cageId = cageIdGrid[r][c];
        final cage = cages.firstWhere((g) => g.id == cageId);
        final isTopLeft =
            cage.cells.first.row == r && cage.cells.first.col == c;
        final isGiven =
            cage.cells.length == 1 && difficulty == Difficulty.easy;
        return Cell(
          value: isGiven ? solution[r][c] : 0,
          row: r,
          col: c,
          cageId: cageId,
          isFixed: isGiven,
          showClue: isTopLeft,
          clueText: isTopLeft ? _clueText(cage) : '',
        );
      });
    });

    return Board(cells: cells, solution: solution, cages: cages);
  }

  // ── Latin square ────────────────────────────────────────────────────────────

  bool _solveLatinSquare(List<List<int>> grid, int row, int col, int size) {
    if (row == size) return true;
    final nextRow = col == size - 1 ? row + 1 : row;
    final nextCol = col == size - 1 ? 0 : col + 1;

    if (grid[row][col] != 0) {
      return _solveLatinSquare(grid, nextRow, nextCol, size);
    }

    final nums = List.generate(size, (i) => i + 1)..shuffle(_random);
    for (final num in nums) {
      if (_isSafe(grid, row, col, num, size)) {
        grid[row][col] = num;
        if (_solveLatinSquare(grid, nextRow, nextCol, size)) return true;
        grid[row][col] = 0;
      }
    }
    return false;
  }

  bool _isSafe(List<List<int>> grid, int row, int col, int num, int size) {
    for (int i = 0; i < size; i++) {
      if (grid[row][i] == num) return false;
      if (grid[i][col] == num) return false;
    }
    return true;
  }

  // ── Cage generation ─────────────────────────────────────────────────────────

  (List<Cage>, List<List<int>>) _generateCages(
      List<List<int>> grid, Difficulty difficulty, int size) {
    final cageIdGrid = List.generate(size, (_) => List.filled(size, -1));
    final positions = [
      for (int r = 0; r < size; r++)
        for (int c = 0; c < size; c++) (r, c),
    ]..shuffle(_random);

    final cages = <Cage>[];
    int nextId = 0;

    for (final (sr, sc) in positions) {
      if (cageIdGrid[sr][sc] != -1) continue;

      final int maxSize = switch (difficulty) {
        Difficulty.easy => _random.nextDouble() < 0.5 ? 1 : 2,
        Difficulty.medium => 4,
        Difficulty.hard => 6,
      };

      final cageCells = <(int, int)>[(sr, sc)];
      cageIdGrid[sr][sc] = nextId;

      while (cageCells.length < maxSize) {
        final frontier = <(int, int)>[];
        for (final (r, c) in cageCells) {
          for (final (dr, dc) in [(-1, 0), (1, 0), (0, -1), (0, 1)]) {
            final nr = r + dr;
            final nc = c + dc;
            if (nr >= 0 &&
                nr < size &&
                nc >= 0 &&
                nc < size &&
                cageIdGrid[nr][nc] == -1 &&
                !frontier.contains((nr, nc))) {
              frontier.add((nr, nc));
            }
          }
        }
        if (frontier.isEmpty) break;
        final next = frontier[_random.nextInt(frontier.length)];
        cageCells.add(next);
        cageIdGrid[next.$1][next.$2] = nextId;
      }

      cageCells.sort(
          (a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2));

      final (op, target) = _assignOperation(grid, cageCells, difficulty);

      cages.add(Cage(
        id: nextId,
        cells: cageCells.map((p) => CagePos(row: p.$1, col: p.$2)).toList(),
        operation: op,
        target: target,
      ));
      nextId++;
    }

    return (cages, cageIdGrid);
  }

  // ── Operation assignment ────────────────────────────────────────────────────

  (Operation, int) _assignOperation(
      List<List<int>> grid, List<(int, int)> cells, Difficulty difficulty) {
    final values = cells.map((p) => grid[p.$1][p.$2]).toList();

    if (cells.length == 1) return (Operation.given, values[0]);

    final sum = values.fold(0, (a, b) => a + b);
    final product = values.fold(1, (a, b) => a * b);

    if (difficulty == Difficulty.easy) {
      if (product > 12) return (Operation.add, sum);
      return _random.nextBool()
          ? (Operation.add, sum)
          : (Operation.multiply, product);
    }

    // Medium and Hard: 2-cell cages can use any operation
    if (cells.length == 2) {
      final sorted = [...values]..sort();
      final lo = sorted.first;
      final hi = sorted.last;
      final choices = <(Operation, int)>[
        (Operation.add, sum),
        (Operation.subtract, hi - lo),
        (Operation.multiply, product),
      ];
      if (lo != 0 && hi % lo == 0) choices.add((Operation.divide, hi ~/ lo));
      return choices[_random.nextInt(choices.length)];
    }

    // 3+ cells: + or × with a product threshold scaled by difficulty
    final productThreshold = difficulty == Difficulty.hard ? 120 : 24;
    if (product <= productThreshold) {
      return _random.nextBool()
          ? (Operation.add, sum)
          : (Operation.multiply, product);
    }
    return (Operation.add, sum);
  }

  String _clueText(Cage cage) => switch (cage.operation) {
        Operation.given => '${cage.target}',
        Operation.add => '${cage.target}+',
        Operation.subtract => '${cage.target}−',
        Operation.multiply => '${cage.target}×',
        Operation.divide => '${cage.target}÷',
      };
}
