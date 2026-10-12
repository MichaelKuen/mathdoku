import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mathdoku/core/providers/web_mode_provider.dart';
import 'package:mathdoku/core/theme/app_theme.dart';
import 'package:mathdoku/features/game/domain/models/game_state.dart';
import 'package:mathdoku/features/game/presentation/pages/game_page.dart';
import 'package:mathdoku/features/game/presentation/providers/game_provider.dart';
import 'package:mathdoku/features/game/presentation/widgets/mathdoku_grid.dart';
import 'package:mathdoku/features/game/presentation/widgets/number_pad.dart';
import 'package:mathdoku/main.dart';

// The iframe is 320–1280px wide and about 700px tall; also short desktop
// windows and phone landscape.
const webSizes = [
  Size(320, 568),
  Size(360, 640),
  Size(390, 844),
  Size(600, 700),
  Size(700, 700),
  Size(768, 700),
  Size(900, 700),
  Size(1024, 700),
  Size(1100, 700),
  Size(1280, 700),
  Size(1024, 500),
  Size(844, 390),
];

const mobileSizes = [Size(360, 640), Size(390, 844), Size(844, 390)];

void main() {
  Future<void> checkLayout(WidgetTester tester, Size size,
      {required bool web, required Difficulty level}) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = ProviderContainer(
        overrides: [webModeProvider.overrideWithValue(web)]);
    await container.read(gameNotifierProvider.notifier).startGame(level);
    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: web
          ? const MathdokuApp()
          : MaterialApp(
              theme: kidsTheme,
              home: const GamePage(),
            ),
    ));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final label = '${web ? 'web' : 'mobile'} ${level.name} '
        '${size.width.toInt()}x${size.height.toInt()}';
    expect(tester.takeException(), isNull, reason: '$label: exception');

    final screen = Offset.zero & size;
    bool fullyVisible(Rect r) =>
        r.left >= -0.5 &&
        r.top >= -0.5 &&
        r.right <= screen.right + 0.5 &&
        r.bottom <= screen.bottom + 0.5;

    final board = tester.getRect(find.byType(MathdokuGrid));
    expect(fullyVisible(board), isTrue, reason: '$label: board $board');
    for (final controls in [NumberPad, ActionRow]) {
      final r = tester.getRect(find.byType(controls));
      expect(fullyVisible(r), isTrue, reason: '$label: $controls $r');
      expect(r.overlaps(board), isFalse, reason: '$label: $controls on board');
    }

    for (final s in tester.stateList<ScrollableState>(find.byType(Scrollable))) {
      expect(s.position.maxScrollExtent, lessThanOrEqualTo(0.5),
          reason: '$label: something scrolls');
    }

    if (web) {
      final shortest = size.shortestSide;
      final minBoard = shortest >= 600 ? 400.0 : 280.0;
      expect(board.width, greaterThanOrEqualTo(minBoard),
          reason: '$label: board ${board.width}');
    }

    await tester.pumpWidget(const SizedBox());
    container.dispose();
    await tester.pump(const Duration(seconds: 1));
  }

  for (final level in [Difficulty.easy, Difficulty.hard]) {
    for (final size in webSizes) {
      testWidgets(
          'web ${level.name} ${size.width.toInt()}x${size.height.toInt()}',
          (tester) => checkLayout(tester, size, web: true, level: level));
    }
    for (final size in mobileSizes) {
      testWidgets(
          'mobile ${level.name} ${size.width.toInt()}x${size.height.toInt()}',
          (tester) => checkLayout(tester, size, web: false, level: level));
    }
  }
}
