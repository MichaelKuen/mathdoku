import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mathdoku/core/providers/web_mode_provider.dart';
import 'package:mathdoku/features/game/domain/models/game_state.dart';
import 'package:mathdoku/features/game/presentation/pages/break_page.dart';
import 'package:mathdoku/features/game/presentation/pages/game_page.dart';
import 'package:mathdoku/features/game/presentation/providers/game_provider.dart';
import 'package:mathdoku/features/home/presentation/pages/home_page.dart';
import 'package:mathdoku/main.dart';

// Web screen flow, checked on the VM by switching web mode on.
void main() {
  Future<ProviderContainer> openWebApp(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(ProviderScope(
      overrides: [webModeProvider.overrideWithValue(true)],
      child: const MathdokuApp(),
    ));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    return ProviderScope.containerOf(tester.element(find.byType(GamePage)));
  }

  // Characters outside the bundled Nunito subset make Flutter web download a
  // fallback font (emoji, symbols) from Google.
  void expectOnlyBundledCharacters(WidgetTester tester) {
    const extra = '×÷−—–‘’“”…';
    for (final text in tester.widgetList<RichText>(find.byType(RichText))) {
      if (text.text.style?.fontFamily == 'MaterialIcons') continue; // icons
      final s = text.text.toPlainText();
      for (final rune in s.runes) {
        final ok = rune < 0x7F || (rune >= 0xA0 && rune <= 0xFF) ||
            extra.runes.contains(rune);
        expect(ok, isTrue,
            reason: 'U+${rune.toRadixString(16)} in "$s" is not bundled');
      }
    }
  }

  Future<void> disposeApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('web opens straight into an Easy game with no app bar',
      (tester) async {
    final container = await openWebApp(tester);
    expect(find.byType(HomePage), findsNothing);
    expect(find.byType(AppBar), findsNothing);
    final state = container.read(gameNotifierProvider);
    expect(state.status, GameStatus.playing);
    expect(state.difficulty, Difficulty.easy);
    expectOnlyBundledCharacters(tester);

    // Notes mode shows a check mark; a finished digit shows one on its key.
    container.read(gameNotifierProvider.notifier).togglePencilMode();
    await tester.pump();
    expectOnlyBundledCharacters(tester);
    await disposeApp(tester);
  });

  testWidgets('New game dialog offers all levels', (tester) async {
    final container = await openWebApp(tester);
    await tester.tap(find.byTooltip('New game'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    Finder inDialog(String text) => find.descendant(
        of: find.byType(SimpleDialog), matching: find.text(text));
    for (final level in ['Easy', 'Medium', 'Hard', 'Insane']) {
      expect(inDialog(level), findsOneWidget);
    }
    expectOnlyBundledCharacters(tester);
    await tester.tap(inDialog('Hard'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final state = container.read(gameNotifierProvider);
    expect(state.difficulty, Difficulty.hard);
    expect(state.board!.size, 6);
    expect(find.text('New game'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('winning on web starts a new game instead of leaving the page',
      (tester) async {
    final container = await openWebApp(tester);
    final notifier = container.read(gameNotifierProvider.notifier);
    final board = container.read(gameNotifierProvider).board!;
    for (var r = 0; r < board.size; r++) {
      for (var c = 0; c < board.size; c++) {
        notifier.selectCell(r, c);
        notifier.inputNumber(board.getSolutionValue(r, c));
      }
    }
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expectOnlyBundledCharacters(tester);
    await tester.tap(find.text('Play Again!'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(GamePage), findsOneWidget);
    final state = container.read(gameNotifierProvider);
    expect(state.status, GameStatus.playing);
    expect(state.board, isNot(board));
    await disposeApp(tester);
  });

  testWidgets('break screen on web uses only bundled characters',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(ProviderScope(
      overrides: [webModeProvider.overrideWithValue(true)],
      child: const MaterialApp(home: BreakPage()),
    ));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Break Time!'), findsOneWidget);
    expectOnlyBundledCharacters(tester);
    await disposeApp(tester);
  });
}
