import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mathdoku/features/game/domain/logic/mathdoku_generator.dart';
import 'package:mathdoku/features/game/domain/logic/mathdoku_solver.dart';
import 'package:mathdoku/features/game/domain/models/cage.dart';
import 'package:mathdoku/features/game/domain/models/game_state.dart';

void main() {
  for (final d in Difficulty.values) {
    test('${d.name} puzzles have exactly one solution', () {
      final generator = MathdokuGenerator(random: Random(d.index));
      for (var i = 0; i < 100; i++) {
        final board = generator.generate(d);
        final solver = MathdokuSolver(board.size, board.cages);
        expect(solver.findOtherSolution(board.solution), isNull);

        // Every cell is in exactly one cage, and cage ids match their index.
        final seen = <(int, int)>{};
        for (var k = 0; k < board.cages.length; k++) {
          expect(board.cages[k].id, k);
          for (final p in board.cages[k].cells) {
            expect(seen.add((p.row, p.col)), isTrue);
            expect(board.getCell(p.row, p.col).cageId, k);
          }
        }
        expect(seen.length, board.size * board.size);

        if (d == Difficulty.medium || d == Difficulty.insane) {
          expect(board.cells.expand((r) => r).where((c) => c.isFixed), isEmpty);
        }
        if (d == Difficulty.insane) {
          for (final cage in board.cages) {
            expect(cage.operation,
                isNot(anyOf(Operation.subtract, Operation.divide)));
          }
        }
      }
    });
  }

  test('the solver finds a second solution when there is one', () {
    // Two 2-cell "3+" cages in a 2x2 corner of a 4x4 are ambiguous on their
    // own; one cage per cell fixes everything else.
    final solution = [
      [1, 2, 3, 4],
      [2, 1, 4, 3],
      [3, 4, 1, 2],
      [4, 3, 2, 1],
    ];
    final cages = <Cage>[
      Cage(
          id: 0,
          cells: const [CagePos(row: 0, col: 0), CagePos(row: 0, col: 1)],
          operation: Operation.add,
          target: 3),
      Cage(
          id: 1,
          cells: const [CagePos(row: 1, col: 0), CagePos(row: 1, col: 1)],
          operation: Operation.add,
          target: 3),
      for (var r = 0; r < 4; r++)
        for (var c = 0; c < 4; c++)
          if (r > 1 || c > 1)
            Cage(
                id: 0,
                cells: [CagePos(row: r, col: c)],
                operation: Operation.given,
                target: solution[r][c]),
    ];
    expect(MathdokuSolver(4, cages).findOtherSolution(solution), isNotNull);
  });
}
