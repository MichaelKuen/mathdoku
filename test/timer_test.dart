import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathdoku/features/game/domain/models/game_state.dart';
import 'package:mathdoku/features/game/presentation/providers/game_provider.dart';

void main() {
  testWidgets('break after 10 minutes; the clock stops during the break',
      (tester) async {
    final container = ProviderContainer();
    final notifier = container.read(gameNotifierProvider.notifier);
    GameState state() => container.read(gameNotifierProvider);

    await notifier.startGame(Difficulty.easy);
    await tester.pump(const Duration(seconds: 599));
    expect(state().status, GameStatus.playing);
    await tester.pump(const Duration(seconds: 1));
    expect(state().status, GameStatus.breakTime);
    expect(state().elapsedSeconds, 600);

    await tester.pump(const Duration(seconds: 30));
    expect(state().elapsedSeconds, 600);

    notifier.acknowledgeBreak();
    await tester.pump(const Duration(seconds: 1));
    expect(state().status, GameStatus.playing);
    expect(state().elapsedSeconds, 601);

    container.dispose();
  });
}
