import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathdoku/features/game/domain/models/board.dart';
import 'package:mathdoku/features/game/domain/models/cage.dart';
import 'package:mathdoku/features/game/domain/models/game_state.dart';
import 'package:mathdoku/features/game/presentation/providers/game_provider.dart';

void main() {
  late ProviderContainer container;
  GameNotifier notifier() => container.read(gameNotifierProvider.notifier);
  GameState state() => container.read(gameNotifierProvider);
  Board board() => state().board!;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  (int, int) firstEmpty() {
    for (var r = 0; r < board().size; r++) {
      for (var c = 0; c < board().size; c++) {
        if (!board().getCell(r, c).isFixed &&
            board().getCell(r, c).value == 0) {
          return (r, c);
        }
      }
    }
    throw StateError('no empty cell');
  }

  int wrongDigit(int r, int c) =>
      board().getSolutionValue(r, c) % board().size + 1;

  test('grid size and givens per level', () async {
    for (final (d, size) in [
      (Difficulty.easy, 4),
      (Difficulty.medium, 4),
      (Difficulty.hard, 6),
      (Difficulty.insane, 6),
    ]) {
      await notifier().startGame(d);
      expect(state().status, GameStatus.playing);
      expect(board().size, size);
      expect(state().mistakes, 0);
      expect(state().elapsedSeconds, 0);
      final givensAllowed = d == Difficulty.easy || d == Difficulty.hard;
      for (final cage in board().cages) {
        final cell =
            board().getCell(cage.cells.first.row, cage.cells.first.col);
        final isSingle = cage.cells.length == 1;
        expect(cell.isFixed, isSingle && givensAllowed);
        if (isSingle) expect(cage.operation, Operation.given);
      }
    }
  });

  test('cage clues match the solution', () async {
    for (final d in Difficulty.values) {
      await notifier().startGame(d);
      for (final cage in board().cages) {
        final v = [
          for (final p in cage.cells) board().getSolutionValue(p.row, p.col)
        ]..sort();
        final expected = switch (cage.operation) {
          Operation.given => v.single,
          Operation.add => v.fold(0, (a, b) => a + b),
          Operation.multiply => v.fold(1, (a, b) => a * b),
          Operation.subtract => v.last - v.first,
          Operation.divide => v.last ~/ v.first,
        };
        expect(cage.target, expected);
      }
    }
  });

  test('wrong digit counts a mistake and is marked, correct digit is not',
      () async {
    await notifier().startGame(Difficulty.medium);
    final (r, c) = firstEmpty();
    notifier().selectCell(r, c);
    notifier().inputNumber(wrongDigit(r, c));
    expect(state().mistakes, 1);
    expect(board().getCell(r, c).isError, isTrue);

    notifier().inputNumber(board().getSolutionValue(r, c));
    expect(state().mistakes, 1);
    expect(board().getCell(r, c).isError, isFalse);
    expect(board().getCell(r, c).value, board().getSolutionValue(r, c));
  });

  test('no input without a selected cell; fixed cells cannot change', () async {
    await notifier().startGame(Difficulty.easy);
    final before = board();
    notifier().inputNumber(1);
    expect(board(), before);

    final given = board().cells.expand((r) => r).where((c) => c.isFixed);
    if (given.isNotEmpty) {
      final g = given.first;
      notifier().selectCell(g.row, g.col);
      notifier().inputNumber(g.value % 4 + 1);
      notifier().eraseCell();
      expect(board().getCell(g.row, g.col).value, g.value);
      expect(state().mistakes, 0);
    }
  });

  test('notes toggle on empty cells and clear when the digit is placed nearby',
      () async {
    await notifier().startGame(Difficulty.medium);
    final (r, c) = firstEmpty();
    final digit = board().getSolutionValue(r, c);

    // A note for the same digit in another empty cell of the same row.
    int? other;
    for (var cc = 0; cc < board().size; cc++) {
      if (cc != c && board().getCell(r, cc).value == 0) other = cc;
    }

    notifier().togglePencilMode();
    expect(state().isPencilMode, isTrue);
    notifier().selectCell(r, c);
    notifier().inputNumber(1);
    notifier().inputNumber(2);
    expect(board().getCell(r, c).notes, [1, 2]);
    notifier().inputNumber(1);
    expect(board().getCell(r, c).notes, [2]);
    expect(board().getCell(r, c).value, 0);
    if (other != null) {
      notifier().selectCell(r, other);
      notifier().inputNumber(digit);
    }

    notifier().togglePencilMode();
    notifier().selectCell(r, c);
    notifier().inputNumber(digit);
    expect(board().getCell(r, c).notes, isEmpty);
    if (other != null) {
      expect(board().getCell(r, other).notes, isNot(contains(digit)));
    }
  });

  test('erase clears the digit first, then the notes', () async {
    await notifier().startGame(Difficulty.medium);
    final (r, c) = firstEmpty();
    notifier().selectCell(r, c);
    notifier().togglePencilMode();
    notifier().inputNumber(3);
    notifier().togglePencilMode();
    notifier().inputNumber(wrongDigit(r, c));
    notifier().eraseCell();
    expect(board().getCell(r, c).value, 0);
    expect(board().getCell(r, c).isError, isFalse);
    notifier().eraseCell();
    expect(board().getCell(r, c).notes, isEmpty);
  });

  test('hint fills and locks the selected cell, or the first empty one',
      () async {
    await notifier().startGame(Difficulty.medium);
    final (r, c) = firstEmpty();
    notifier().useHint();
    expect(state().selectedRow, r);
    expect(state().selectedCol, c);
    expect(board().getCell(r, c).value, board().getSolutionValue(r, c));
    expect(board().getCell(r, c).isFixed, isTrue);
    expect(state().mistakes, 0);
  });

  test('filling every cell correctly wins; there is no mistake limit',
      () async {
    await notifier().startGame(Difficulty.easy);
    final (r0, c0) = firstEmpty();
    notifier().selectCell(r0, c0);
    for (var i = 0; i < 5; i++) {
      notifier().inputNumber(wrongDigit(r0, c0));
    }
    expect(state().mistakes, 5);
    expect(state().status, GameStatus.playing);

    for (var r = 0; r < board().size; r++) {
      for (var c = 0; c < board().size; c++) {
        if (board().getCell(r, c).isFixed) continue;
        notifier().selectCell(r, c);
        notifier().inputNumber(board().getSolutionValue(r, c));
      }
    }
    expect(state().status, GameStatus.won);
  });
}
