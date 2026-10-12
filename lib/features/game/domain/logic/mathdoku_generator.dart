// Copyright © App Verse Games. All rights reserved.
import 'dart:math';
import '../models/board.dart';
import '../models/cage.dart';
import '../models/cell.dart';
import '../models/game_state.dart';
import 'mathdoku_solver.dart';

class MathdokuGenerator {
  final Random _random;

  MathdokuGenerator({Random? random}) : _random = random ?? Random();

  // Grid size: 4 for Easy/Medium, 6 for Hard/Insane.
  int _sizeFor(Difficulty d) =>
      (d == Difficulty.hard || d == Difficulty.insane) ? 6 : 4;

  Board generate(Difficulty difficulty) {
    final size = _sizeFor(difficulty);

    final grid = List.generate(size, (_) => List.filled(size, 0));
    _solveLatinSquare(grid, 0, 0, size);

    final solution = List.generate(size, (r) => List<int>.from(grid[r]));
    final cages =
        _makeUnique(solution, _generateCages(difficulty, size), difficulty);

    final cageIdGrid = List.generate(size, (_) => List.filled(size, -1));
    for (final cage in cages) {
      for (final p in cage.cells) {
        cageIdGrid[p.row][p.col] = cage.id;
      }
    }

    final cells = List.generate(size, (r) {
      return List.generate(size, (c) {
        final cage = cages[cageIdGrid[r][c]];
        final isTopLeft =
            cage.cells.first.row == r && cage.cells.first.col == c;
        final isGiven = cage.cells.length == 1 &&
            (difficulty == Difficulty.easy || difficulty == Difficulty.hard);
        return Cell(
          value: isGiven ? solution[r][c] : 0,
          row: r,
          col: c,
          cageId: cage.id,
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

  List<List<(int, int)>> _generateCages(Difficulty difficulty, int size) {
    final taken = List.generate(size, (_) => List.filled(size, false));
    final positions = [
      for (int r = 0; r < size; r++)
        for (int c = 0; c < size; c++) (r, c),
    ]..shuffle(_random);

    final groups = <List<(int, int)>>[];

    for (final (sr, sc) in positions) {
      if (taken[sr][sc]) continue;

      // Bigger starting cages only get split again to make the puzzle unique,
      // and make that search much slower.
      final int maxSize = switch (difficulty) {
        Difficulty.easy => _random.nextDouble() < 0.5 ? 1 : 2,
        Difficulty.medium => 4,
        Difficulty.hard => 4,
        Difficulty.insane => 5,
      };

      final cageCells = <(int, int)>[(sr, sc)];
      taken[sr][sc] = true;

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
                !taken[nr][nc] &&
                !frontier.contains((nr, nc))) {
              frontier.add((nr, nc));
            }
          }
        }
        if (frontier.isEmpty) break;
        final next = frontier[_random.nextInt(frontier.length)];
        cageCells.add(next);
        taken[next.$1][next.$2] = true;
      }

      groups.add(cageCells);
    }

    return groups;
  }

  // ── Uniqueness ──────────────────────────────────────────────────────────────

  /// Assigns operations, then tightens the puzzle until [solution] is its only
  /// solution. Where another solution differs, the cage there first gets a
  /// different operation; if no operation rules the other solution out, the
  /// differing cell becomes a cage of its own.
  List<Cage> _makeUnique(List<List<int>> solution,
      List<List<(int, int)>> groups, Difficulty difficulty) {
    final size = solution.length;
    var cages = <Cage>[
      for (final group in groups)
        _cage(0, group, _pick(_operationChoices(solution, group, difficulty))),
    ];
    cages = _renumber(cages);
    final combinations = <Cage, List<List<int>>>{};

    while (true) {
      final other = MathdokuSolver(size, cages, combinationCache: combinations)
          .findOtherSolution(solution);
      if (other == null) return cages;

      final differing = [
        for (int r = 0; r < size; r++)
          for (int c = 0; c < size; c++)
            if (other[r][c] != solution[r][c]) (r, c),
      ];
      final (dr, dc) = differing[_random.nextInt(differing.length)];
      final index = cages
          .indexWhere((g) => g.cells.any((p) => p.row == dr && p.col == dc));
      final cage = cages[index];
      final group = [for (final p in cage.cells) (p.row, p.col)];

      final otherValues = [for (final (r, c) in group) other[r][c]];
      final better =
          _operationChoices(solution, group, difficulty, relaxed: true)
              .where((choice) =>
                  choice.$1 != cage.operation &&
                  !_satisfies(choice.$1, choice.$2, otherValues))
              .toList();
      if (better.isNotEmpty) {
        final (op, target) = _pick(better);
        cages[index] = cage.copyWith(operation: op, target: target);
        continue;
      }

      // Split: the differing cell stands alone; the rest of the cage breaks
      // into its connected pieces.
      final pieces = [
        [(dr, dc)],
        ..._connectedPieces(group.where((p) => p != (dr, dc)).toList()),
      ];
      cages.removeAt(index);
      for (final piece in pieces) {
        cages.add(_cage(
            0, piece, _pick(_operationChoices(solution, piece, difficulty))));
      }
      cages = _renumber(cages);
    }
  }

  List<Cage> _renumber(List<Cage> cages) =>
      [for (var i = 0; i < cages.length; i++) cages[i].copyWith(id: i)];

  Cage _cage(int id, List<(int, int)> group, (Operation, int) clue) {
    final sorted = [...group]..sort(
        (a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2));
    return Cage(
      id: id,
      cells: sorted.map((p) => CagePos(row: p.$1, col: p.$2)).toList(),
      operation: clue.$1,
      target: clue.$2,
    );
  }

  List<List<(int, int)>> _connectedPieces(List<(int, int)> cells) {
    final remaining = cells.toSet();
    final pieces = <List<(int, int)>>[];
    while (remaining.isNotEmpty) {
      final start = remaining.first;
      remaining.remove(start);
      final piece = [start];
      for (var i = 0; i < piece.length; i++) {
        final (r, c) = piece[i];
        for (final n in [(r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)]) {
          if (remaining.remove(n)) piece.add(n);
        }
      }
      pieces.add(piece);
    }
    return pieces;
  }

  bool _satisfies(Operation op, int target, List<int> values) {
    final sorted = [...values]..sort();
    return switch (op) {
      Operation.given => values.single == target,
      Operation.add => values.fold(0, (a, b) => a + b) == target,
      Operation.multiply => values.fold(1, (a, b) => a * b) == target,
      Operation.subtract => sorted.last - sorted.first == target,
      Operation.divide => sorted.last % sorted.first == 0 &&
          sorted.last ~/ sorted.first == target,
    };
  }

  // ── Operation assignment ────────────────────────────────────────────────────

  (Operation, int) _pick(List<(Operation, int)> choices) =>
      choices[_random.nextInt(choices.length)];

  /// The operations a cage may use at this level. [relaxed] adds choices the
  /// level normally avoids; it is only used to make a puzzle unique.
  List<(Operation, int)> _operationChoices(
      List<List<int>> grid, List<(int, int)> cells, Difficulty difficulty,
      {bool relaxed = false}) {
    final values = cells.map((p) => grid[p.$1][p.$2]).toList();

    if (cells.length == 1) return [(Operation.given, values[0])];

    final sum = values.fold(0, (a, b) => a + b);
    final product = values.fold(1, (a, b) => a * b);
    final add = (Operation.add, sum);
    final multiply = (Operation.multiply, product);

    if (difficulty == Difficulty.easy) {
      return product > 12 && !relaxed ? [add] : [add, multiply];
    }

    // Insane: only + or × — no subtract/divide (less constraint = harder to solve)
    // 3+ cells use × unless × alone can't make the puzzle unique
    if (difficulty == Difficulty.insane) {
      if (cells.length == 2 || relaxed) return [add, multiply];
      return [multiply];
    }

    // Medium and Hard: 2-cell cages can use any operation
    if (cells.length == 2) {
      final sorted = [...values]..sort();
      final lo = sorted.first;
      final hi = sorted.last;
      return [
        add,
        (Operation.subtract, hi - lo),
        multiply,
        if (hi % lo == 0) (Operation.divide, hi ~/ lo),
      ];
    }

    // 3+ cells: + or × with a product threshold scaled by difficulty
    final productThreshold = difficulty == Difficulty.hard ? 120 : 24;
    return product <= productThreshold || relaxed ? [add, multiply] : [add];
  }

  String _clueText(Cage cage) => switch (cage.operation) {
        Operation.given => '${cage.target}',
        Operation.add => '${cage.target}+',
        Operation.subtract => '${cage.target}−',
        Operation.multiply => '${cage.target}×',
        Operation.divide => '${cage.target}÷',
      };
}
