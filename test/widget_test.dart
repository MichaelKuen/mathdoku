import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mathdoku/features/game/presentation/pages/game_page.dart';
import 'package:mathdoku/features/game/presentation/providers/game_provider.dart';
import 'package:mathdoku/features/home/presentation/pages/home_page.dart';
import 'package:mathdoku/main.dart';

// Mobile screen flow (VM tests run with kIsWeb == false).
void main() {
  Future<void> disposeApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('mobile opens on the home page with four levels', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const ProviderScope(child: MathdokuApp()));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(HomePage), findsOneWidget);
    for (final level in ['Easy', 'Medium', 'Hard', 'Insane']) {
      expect(find.text(level), findsOneWidget);
    }
    await disposeApp(tester);
  });

  testWidgets('choosing a level opens the game; winning returns home',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const ProviderScope(child: MathdokuApp()));
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Medium'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(GamePage), findsOneWidget);

    final container =
        ProviderScope.containerOf(tester.element(find.byType(GamePage)));
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
    expect(find.text('You solved the puzzle!'), findsOneWidget);

    await tester.tap(find.text('Play Again!'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(GamePage), findsNothing);
    await disposeApp(tester);
  });
}
