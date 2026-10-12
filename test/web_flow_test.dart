import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mathdoku/core/providers/web_mode_provider.dart';
import 'package:mathdoku/features/game/domain/models/game_state.dart';
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
    await disposeApp(tester);
  });

  testWidgets('New game dialog offers all levels', (tester) async {
    final container = await openWebApp(tester);
    await tester.tap(find.byTooltip('New game'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    for (final level in ['Easy', 'Medium', 'Hard', 'Insane']) {
      expect(find.text(level), findsOneWidget);
    }
    await tester.tap(find.text('Hard'));
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
    await tester.tap(find.text('Play Again! ▶'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(GamePage), findsOneWidget);
    final state = container.read(gameNotifierProvider);
    expect(state.status, GameStatus.playing);
    expect(state.board, isNot(board));
    await disposeApp(tester);
  });
}
