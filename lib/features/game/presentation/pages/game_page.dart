import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../widgets/sudoku_grid.dart';
import '../../domain/models/game_state.dart';
import 'package:sudoku/core/providers/theme_provider.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final String logicalKey = event.logicalKey.keyLabel;
      if (RegExp(r'^[1-9]$').hasMatch(logicalKey)) {
        ref.read(gameNotifierProvider.notifier).inputNumber(int.parse(logicalKey));
      } else if (event.logicalKey == LogicalKeyboardKey.backspace || event.logicalKey == LogicalKeyboardKey.delete) {
        ref.read(gameNotifierProvider.notifier).eraseCell();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _moveSelection(-1, 0);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _moveSelection(1, 0);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _moveSelection(0, -1);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _moveSelection(0, 1);
      } else if (event.logicalKey == LogicalKeyboardKey.keyH) {
        ref.read(gameNotifierProvider.notifier).useHint();
      }
    }
  }

  void _moveSelection(int dRow, int dCol) {
    final state = ref.read(gameNotifierProvider);
    int newRow = ((state.selectedRow ?? 0) + dRow).clamp(0, 8);
    int newCol = ((state.selectedCol ?? 0) + dCol).clamp(0, 8);
    ref.read(gameNotifierProvider.notifier).selectCell(newRow, newCol);
  }

  void _showRefreshConfirmation(BuildContext context, WidgetRef ref, GameState state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Game?'),
        content: const Text('Are you sure you want to abandon this game and start a new one?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(gameNotifierProvider.notifier).startGame(state.difficulty);
            },
            child: const Text('NEW GAME', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameNotifierProvider);
    final themeMode = ref.watch(themeNotifierProvider);

    ref.listen(gameNotifierProvider.select((s) => s.status), (previous, next) {
      if (next == GameStatus.won) _showWinDialog(context, ref, gameState);
    });

    final minutes = (gameState.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (gameState.elapsedSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Text(gameState.difficulty.name.toUpperCase()),
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode, size: 22),
            onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 22),
            onPressed: gameState.hintsRemaining > 0 
                ? () => ref.read(gameNotifierProvider.notifier).useHint() 
                : null,
            tooltip: 'Hint (${gameState.hintsRemaining})',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 22),
            onPressed: () => ref.read(gameNotifierProvider.notifier).eraseCell(),
            tooltip: 'Erase',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 22),
            onPressed: () => _showRefreshConfirmation(context, ref, gameState),
            tooltip: 'New Game',
          ),
        ],
      ),
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: gameState.status == GameStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : OrientationBuilder(
                builder: (context, orientation) {
                  bool isLandscape = orientation == Orientation.landscape;

                  if (isLandscape) {
                    return SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 500),
                                  child: const SudokuGrid(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _CompactStatsRow(gameState: gameState),
                                  const SizedBox(height: 8),
                                  const _NumberPad(isVertical: true, isCompact: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      _StatsBar(gameState: gameState),
                      Expanded(
                        child: SafeArea(
                          child: Column(
                            children: [
                              const Spacer(),
                              Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 500),
                                  child: const SudokuGrid(),
                                ),
                              ),
                              const Spacer(),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: _NumberPad(isVertical: false),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  void _showWinDialog(BuildContext context, WidgetRef ref, GameState state) {
    final minutes = (state.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (state.elapsedSeconds % 60).toString().padLeft(2, '0');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Center(child: Text('CONGRATULATIONS!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            Text('Time: $minutes:$seconds'),
            Text('Mistakes: ${state.mistakes}/${state.maxMistakes}'),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('PICK NEXT GAME'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactStatsRow extends StatelessWidget {
  final GameState gameState;
  const _CompactStatsRow({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final minutes = (gameState.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (gameState.elapsedSeconds % 60).toString().padLeft(2, '0');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            const Icon(Icons.timer_outlined, size: 14, color: Colors.blue),
            const SizedBox(width: 4),
            Text('$minutes:$seconds', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.error_outline, size: 14, color: Colors.redAccent),
            const SizedBox(width: 4),
            Text('${gameState.mistakes}/${gameState.maxMistakes}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          ],
        ),
      ],
    );
  }
}

class _StatsBar extends StatelessWidget {
  final GameState gameState;
  const _StatsBar({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final minutes = (gameState.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (gameState.elapsedSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 18, color: Colors.blue),
              const SizedBox(width: 6),
              Text(
                '$minutes:$seconds',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 18, color: Colors.redAccent),
              const SizedBox(width: 6),
              Text(
                'Mistakes: ${gameState.mistakes}/${gameState.maxMistakes}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumberPad extends ConsumerWidget {
  final bool isVertical;
  final bool isCompact;
  const _NumberPad({required this.isVertical, this.isCompact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isVertical ? 3 : 9,
        crossAxisSpacing: isCompact ? 6 : 8,
        mainAxisSpacing: isCompact ? 6 : 8,
        childAspectRatio: isVertical ? 1.4 : 1.0,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final number = index + 1;
        return InkWell(
          onTap: () => ref.read(gameNotifierProvider.notifier).inputNumber(number),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: isCompact ? 18 : 22,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
