// Copyright © App Verse Games. All rights reserved.
import '../models/cage.dart';

/// Solver used by the generator to make sure a puzzle has exactly one
/// solution.
///
/// Each cage's possible digit combinations are listed once up front. During
/// the search a cell may only take digits that still appear in a combination
/// of its cage that fits the rows and columns, and the cell with the fewest
/// choices is filled next.
class MathdokuSolver {
  final int size;
  final List<Cage> cages;

  /// Combinations per cage, in the order of `cage.cells`. Shared between
  /// solvers so unchanged cages are not listed again.
  final Map<Cage, List<List<int>>> _combinationCache;

  MathdokuSolver(this.size, this.cages,
      {Map<Cage, List<List<int>>>? combinationCache})
      : _combinationCache = combinationCache ?? {};

  /// Returns a solution that differs from [known], or null if [known] is the
  /// only one.
  List<List<int>>? findOtherSolution(List<List<int>> known) {
    final combos = [
      for (final cage in cages)
        _combinationCache.putIfAbsent(cage, () => _combinations(cage)),
    ];
    final grid = List.generate(size, (_) => List.filled(size, 0));
    final rowUsed = List.filled(size, 0);
    final colUsed = List.filled(size, 0);
    List<List<int>>? found;

    bool differs() {
      for (var r = 0; r < size; r++) {
        for (var c = 0; c < size; c++) {
          if (grid[r][c] != known[r][c]) return true;
        }
      }
      return false;
    }

    bool search(int filled) {
      if (filled == size * size) {
        if (!differs()) return false;
        found = [for (final row in grid) List<int>.from(row)];
        return true;
      }

      // Digits each empty cell can still take, as bit masks.
      var bestR = -1, bestC = -1, bestMask = 0, bestCount = size + 1;
      for (var k = 0; k < cages.length; k++) {
        final cells = cages[k].cells;
        if (cells.every((p) => grid[p.row][p.col] != 0)) continue;
        final masks = List.filled(cells.length, 0);
        for (final combo in combos[k]) {
          var fits = true;
          for (var i = 0; i < cells.length && fits; i++) {
            final p = cells[i];
            final v = combo[i];
            final g = grid[p.row][p.col];
            fits = g != 0
                ? g == v
                : (rowUsed[p.row] | colUsed[p.col]) & (1 << v) == 0;
          }
          if (!fits) continue;
          for (var i = 0; i < cells.length; i++) {
            masks[i] |= 1 << combo[i];
          }
        }
        for (var i = 0; i < cells.length; i++) {
          final p = cells[i];
          if (grid[p.row][p.col] != 0) continue;
          final count = _bitCount(masks[i]);
          if (count == 0) return false;
          if (count < bestCount) {
            bestCount = count;
            bestMask = masks[i];
            bestR = p.row;
            bestC = p.col;
          }
        }
      }

      for (var d = 1; d <= size; d++) {
        if (bestMask & (1 << d) == 0) continue;
        grid[bestR][bestC] = d;
        rowUsed[bestR] |= 1 << d;
        colUsed[bestC] |= 1 << d;
        final done = search(filled + 1);
        rowUsed[bestR] &= ~(1 << d);
        colUsed[bestC] &= ~(1 << d);
        if (done) return true;
      }
      grid[bestR][bestC] = 0;
      return false;
    }

    search(0);
    return found;
  }

  /// Every way to fill [cage] that meets its clue, with no digit repeated in
  /// a row or column inside the cage.
  List<List<int>> _combinations(Cage cage) {
    final cells = cage.cells;
    final n = cells.length;
    final values = List.filled(n, 0);
    final result = <List<int>>[];

    void fill(int i, int sum, int product) {
      if (i == n) {
        final sorted = [...values]..sort();
        final ok = switch (cage.operation) {
          Operation.given => values.single == cage.target,
          Operation.add => sum == cage.target,
          Operation.multiply => product == cage.target,
          Operation.subtract => sorted.last - sorted.first == cage.target,
          Operation.divide => sorted.last % sorted.first == 0 &&
              sorted.last ~/ sorted.first == cage.target,
        };
        if (ok) result.add(List<int>.from(values));
        return;
      }
      final left = n - i - 1;
      for (var d = 1; d <= size; d++) {
        if (cage.operation == Operation.add &&
            (sum + d + left > cage.target ||
                sum + d + left * size < cage.target)) {
          continue;
        }
        if (cage.operation == Operation.multiply &&
            cage.target % (product * d) != 0) {
          continue;
        }
        var clash = false;
        for (var j = 0; j < i && !clash; j++) {
          clash = values[j] == d &&
              (cells[j].row == cells[i].row || cells[j].col == cells[i].col);
        }
        if (clash) continue;
        values[i] = d;
        fill(i + 1, sum + d, product * d);
      }
      values[i] = 0;
    }

    fill(0, 0, 1);
    return result;
  }

  static int _bitCount(int mask) {
    var count = 0;
    for (var m = mask; m != 0; m &= m - 1) {
      count++;
    }
    return count;
  }
}
