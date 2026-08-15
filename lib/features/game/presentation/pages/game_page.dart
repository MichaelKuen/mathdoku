// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../providers/game_provider.dart';
import '../widgets/mathdoku_grid.dart';
import '../widgets/number_pad.dart';
import '../../domain/models/game_state.dart';
import '../../../../core/theme/app_theme.dart';
import 'break_page.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  late ConfettiController _confettiController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameNotifierProvider);

    ref.listen(gameNotifierProvider.select((s) => s.status), (_, next) {
      if (next == GameStatus.won) {
        _confettiController.play();
        _showWinDialog(context, gameState);
      }
      if (next == GameStatus.breakTime) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BreakPage()),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mathdoku 🔢'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: Stack(
        children: [
          gameState.status == GameStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    return Column(
                      children: [
                        _StatsBar(gameState: gameState),
                        Expanded(
                          child: isWide
                              ? _wideLayout()
                              : _narrowLayout(),
                        ),
                      ],
                    );
                  },
                ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 25,
              minBlastForce: 10,
              emissionFrequency: 0.05,
              numberOfParticles: 40,
              gravity: 0.12,
              colors: const [
                Colors.red,
                Colors.green,
                Colors.blue,
                Colors.yellow,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.teal,
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Act on key-down and key-repeat (repeat for held arrow keys only).
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final gameState = ref.read(gameNotifierProvider);
    if (gameState.status != GameStatus.playing) {
      return KeyEventResult.ignored;
    }

    final notifier = ref.read(gameNotifierProvider.notifier);
    final key = event.logicalKey;
    final curRow = gameState.selectedRow ?? 0;
    final curCol = gameState.selectedCol ?? 0;

    // Arrow keys — navigate the grid (also fires on key-repeat)
    if (key == LogicalKeyboardKey.arrowUp) {
      notifier.selectCell((curRow - 1).clamp(0, 3), curCol);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      notifier.selectCell((curRow + 1).clamp(0, 3), curCol);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      notifier.selectCell(curRow, (curCol - 1).clamp(0, 3));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      notifier.selectCell(curRow, (curCol + 1).clamp(0, 3));
      return KeyEventResult.handled;
    }

    // Everything below only fires once per key-press, not on repeat.
    if (event is KeyRepeatEvent) return KeyEventResult.ignored;

    // Number keys 1–4 (main keyboard and numpad)
    if (key == LogicalKeyboardKey.digit1 ||
        key == LogicalKeyboardKey.numpad1) {
      notifier.inputNumber(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.digit2 ||
        key == LogicalKeyboardKey.numpad2) {
      notifier.inputNumber(2);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.digit3 ||
        key == LogicalKeyboardKey.numpad3) {
      notifier.inputNumber(3);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.digit4 ||
        key == LogicalKeyboardKey.numpad4) {
      notifier.inputNumber(4);
      return KeyEventResult.handled;
    }

    // Delete / Backspace — erase selected cell
    if (key == LogicalKeyboardKey.delete ||
        key == LogicalKeyboardKey.backspace) {
      notifier.eraseCell();
      return KeyEventResult.handled;
    }

    // H — hint
    if (key == LogicalKeyboardKey.keyH) {
      notifier.useHint();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Widget _wideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (ctx, c) {
              final size = (c.maxHeight - 32).clamp(0.0, c.maxWidth - 32);
              return Center(
                child: SizedBox.square(
                  dimension: size,
                  child: const MathdokuGrid(),
                ),
              );
            },
          ),
        ),
        Container(
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              NumberPad(),
              SizedBox(height: 20),
              ActionRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _narrowLayout() {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (ctx, c) {
              final size = (c.maxWidth - 32).clamp(0.0, c.maxHeight - 32);
              return Center(
                child: SizedBox.square(
                  dimension: size,
                  child: const MathdokuGrid(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: NumberPad(),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ActionRow(),
        ),
        const SizedBox(height: 28),
      ],
    );
  }

  void _showWinDialog(BuildContext context, GameState state) {
    final minutes =
        (state.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds =
        (state.elapsedSeconds % 60).toString().padLeft(2, '0');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 80))
                .animate()
                .scale(duration: 700.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            const Text(
              'Amazing Work! 🎉',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 8),
            const Text(
              'You solved the puzzle!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 8),
            Text(
              'Time: $minutes:$seconds',
              style: const TextStyle(fontSize: 15),
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Play Again! ▶',
                style: TextStyle(fontSize: 18),
              ),
            ).animate().fadeIn(delay: 800.ms).moveY(begin: 20, end: 0),
          ),
        ],
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  final GameState gameState;
  const _StatsBar({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final minutes =
        (gameState.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds =
        (gameState.elapsedSeconds % 60).toString().padLeft(2, '0');

    return Container(
      color: kPrimary.withValues(alpha: 0.08),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Icon(Icons.timer_outlined, size: 20),
            const SizedBox(width: 6),
            Text(
              '$minutes:$seconds',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ]),
          Row(children: [
            const Text('Oops: ', style: TextStyle(fontSize: 18)),
            Text(
              '${gameState.mistakes}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kPrimary,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
