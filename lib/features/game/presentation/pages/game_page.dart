import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../widgets/sudoku_grid.dart';
import '../../domain/models/game_state.dart';

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

    ref.listen(gameNotifierProvider.select((s) => s.status), (previous, next) {
      if (next == GameStatus.won) _showWinDialog(context, ref, gameState);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('${gameState.difficulty.name.toUpperCase()} SUDOKU'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _showRefreshConfirmation(context, ref, gameState),
          ),
        ],
      ),
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: gameState.status == GameStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 800;

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 600),
                                child: const SudokuGrid(),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: const Border(left: BorderSide(color: Colors.black12)),
                          ),
                          child: Column(
                            children: [
                              _GameHeader(gameState: gameState),
                              const Divider(height: 40),
                              const Text('CONTROLS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                              const SizedBox(height: 20),
                              const _NumberPad(isVertical: true),
                              const Spacer(),
                              _ActionButtons(hintsRemaining: gameState.hintsRemaining, isVertical: true),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _GameHeader(gameState: gameState),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 500),
                                child: const SudokuGrid(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _ActionButtons(hintsRemaining: gameState.hintsRemaining, isVertical: false),
                          const SizedBox(height: 15),
                          const _NumberPad(isVertical: false),
                        ],
                      ),
                    ),
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

class _ActionButtons extends ConsumerWidget {
  final int hintsRemaining;
  final bool isVertical;
  const _ActionButtons({required this.hintsRemaining, required this.isVertical});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Widget> children = [
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () => ref.read(gameNotifierProvider.notifier).eraseCell(),
          icon: const Icon(Icons.delete_outline),
          label: const Text('Erase'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ),
      if (!isVertical) const SizedBox(width: 16),
      if (isVertical) const SizedBox(height: 16),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: hintsRemaining > 0 ? () => ref.read(gameNotifierProvider.notifier).useHint() : null,
          icon: const Icon(Icons.lightbulb_outline),
          label: Text('Hint ($hintsRemaining)'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.amber[800],
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ),
    ];

    if (isVertical) {
      return Column(
        children: children.map((w) {
          if (w is Expanded) return SizedBox(width: double.infinity, child: w.child);
          return w;
        }).toList(),
      );
    }
    
    return Row(children: children);
  }
}

class _GameHeader extends StatelessWidget {
  final GameState gameState;
  const _GameHeader({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final minutes = (gameState.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (gameState.elapsedSeconds % 60).toString().padLeft(2, '0');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MISTAKES', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text('${gameState.mistakes}/${gameState.maxMistakes}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('TIME', style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text('$minutes:$seconds', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

class _NumberPad extends ConsumerWidget {
  final bool isVertical;
  const _NumberPad({required this.isVertical});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isVertical ? 3 : 9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
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
              child: Text('$number', style: TextStyle(fontSize: isVertical ? 24 : 18, color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }
}
