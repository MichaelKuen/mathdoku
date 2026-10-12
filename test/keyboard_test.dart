import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mathdoku/core/providers/web_mode_provider.dart';
import 'package:mathdoku/features/game/domain/models/game_state.dart';
import 'package:mathdoku/features/game/presentation/pages/game_page.dart';
import 'package:mathdoku/features/game/presentation/providers/game_provider.dart';
import 'package:mathdoku/main.dart';

void main() {
  testWidgets('keyboard play on desktop', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1024, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(ProviderScope(
      overrides: [webModeProvider.overrideWithValue(true)],
      child: const MathdokuApp(),
    ));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final container =
        ProviderScope.containerOf(tester.element(find.byType(GamePage)));
    GameState state() => container.read(gameNotifierProvider);

    // First arrow selects the first empty cell.
    final firstEmpty = state()
        .board!
        .cells
        .expand((r) => r)
        .firstWhere((c) => c.value == 0 && !c.isFixed);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect((state().selectedRow, state().selectedCol),
        (firstEmpty.row, firstEmpty.col));

    // Digit keys enter the number.
    final r = firstEmpty.row, c = firstEmpty.col;
    final answer = state().board!.getSolutionValue(r, c);
    final wrong = answer % 4 + 1;
    await tester.sendKeyEvent(
        LogicalKeyboardKey(LogicalKeyboardKey.digit1.keyId + wrong - 1));
    await tester.pump();
    expect(state().board!.getCell(r, c).value, wrong);
    expect(state().mistakes, 1);

    // Backspace erases, even after clicking a button.
    await tester.tap(find.text('Notes'));
    await tester.tap(find.text('Notes'));
    await tester.pump();
    expect(state().isPencilMode, isFalse);
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();
    expect(state().board!.getCell(r, c).value, 0);

    // Numpad digits work too.
    await tester.sendKeyEvent(
        LogicalKeyboardKey(LogicalKeyboardKey.numpad1.keyId + answer - 1));
    await tester.pump();
    expect(state().board!.getCell(r, c).value, answer);

    // Keys are ignored while a dialog is open.
    await tester.tap(find.byTooltip('New game'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final before = state();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();
    expect(state(), before);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
