// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';
import '../../../../core/providers/web_mode_provider.dart';
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
  /// Starts a game at this level when the page opens (used on web, which has
  /// no home page).
  final Difficulty? autoStart;

  const GamePage({super.key, this.autoStart});

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
    final start = widget.autoStart;
    if (start != null) {
      Future.microtask(
          () => ref.read(gameNotifierProvider.notifier).startGame(start));
    }
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
    final isWeb = ref.watch(webModeProvider);

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
      appBar: isWeb
          ? null
          : AppBar(
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
            gameState.status == GameStatus.loading || gameState.board == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _StatsBar(
                        gameState: gameState,
                        onNewGame:
                            isWeb ? () => _showNewGameDialog(context) : null,
                      ),
                      Expanded(
                        child: LayoutBuilder(builder: _playArea),
                      ),
                    ],
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
    final gridMax = (gameState.board?.size ?? 4) - 1;

    // Arrow keys — navigate the grid (also fires on key-repeat)
    if (key == LogicalKeyboardKey.arrowUp) {
      notifier.selectCell((curRow - 1).clamp(0, gridMax), curCol);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      notifier.selectCell((curRow + 1).clamp(0, gridMax), curCol);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      notifier.selectCell(curRow, (curCol - 1).clamp(0, gridMax));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      notifier.selectCell(curRow, (curCol + 1).clamp(0, gridMax));
      return KeyEventResult.handled;
    }

    // Everything below only fires once per key-press, not on repeat.
    if (event is KeyRepeatEvent) return KeyEventResult.ignored;

    // Number keys 1–6 (main keyboard and numpad), gated to current grid size
    final numKeys = {
      LogicalKeyboardKey.digit1: 1,
      LogicalKeyboardKey.numpad1: 1,
      LogicalKeyboardKey.digit2: 2,
      LogicalKeyboardKey.numpad2: 2,
      LogicalKeyboardKey.digit3: 3,
      LogicalKeyboardKey.numpad3: 3,
      LogicalKeyboardKey.digit4: 4,
      LogicalKeyboardKey.numpad4: 4,
      LogicalKeyboardKey.digit5: 5,
      LogicalKeyboardKey.numpad5: 5,
      LogicalKeyboardKey.digit6: 6,
      LogicalKeyboardKey.numpad6: 6,
    };
    final digit = numKeys[key];
    if (digit != null && digit <= (gameState.board?.size ?? 4)) {
      notifier.inputNumber(digit);
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

    // P — toggle pencil/notes mode
    if (key == LogicalKeyboardKey.keyP) {
      notifier.togglePencilMode();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  // Sizes come from the space the page actually gets (inside the iframe on
  // web), never from the device screen.
  static const _gap = 12.0;
  static const _maxBoard = 640.0;

  Widget _playArea(BuildContext context, BoxConstraints c) {
    final w = c.maxWidth;
    final h = c.maxHeight;

    // Controls beside the board only when there is room for both.
    if (w >= 720 && w > h) {
      final panelWidth = (w * 0.32).clamp(240.0, 340.0);
      final board = [w - panelWidth - 3 * _gap, h - 2 * _gap, _maxBoard]
          .reduce((a, b) => a < b ? a : b);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox.square(dimension: board, child: const MathdokuGrid()),
          const SizedBox(width: _gap),
          SizedBox(
            width: panelWidth,
            height: board,
            child: _controls(panelWidth),
          ),
        ],
      );
    }

    // Stacked: board on top, controls in a band underneath that shrinks on
    // short screens instead of overflowing.
    final controlsHeight = (h * 0.28).clamp(96.0, 150.0);
    final board = [w - 2 * _gap, h - controlsHeight - 3 * _gap, _maxBoard]
        .reduce((a, b) => a < b ? a : b);
    final controlsWidth = (w - 2 * _gap).clamp(0.0, 520.0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox.square(dimension: board, child: const MathdokuGrid()),
        const SizedBox(height: _gap),
        SizedBox(
          width: controlsWidth,
          height: controlsHeight,
          child: _controls(controlsWidth),
        ),
      ],
    );
  }

  /// Number pad and action buttons at their natural size, scaled down to fit.
  Widget _controls(double width) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: width,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NumberPad(),
            SizedBox(height: 10),
            ActionRow(),
          ],
        ),
      ),
    );
  }

  void _showWinDialog(BuildContext context, GameState state) {
    final minutes = (state.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (state.elapsedSeconds % 60).toString().padLeft(2, '0');

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
                if (ref.read(webModeProvider)) {
                  // Web has no home page: start the next puzzle right here.
                  ref
                      .read(gameNotifierProvider.notifier)
                      .startGame(state.difficulty);
                } else {
                  Navigator.of(context).pop();
                }
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

  void _showNewGameDialog(BuildContext context) {
    final current = ref.read(gameNotifierProvider).difficulty;
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('New game'),
        children: [
          for (final (level, label, subtitle) in kLevels)
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(ctx).pop();
                ref.read(gameNotifierProvider.notifier).startGame(level);
              },
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(subtitle,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade700)),
                      ],
                    ),
                  ),
                  if (level == current) const Icon(Icons.check),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The levels with the labels shown on the home page and the New game dialog.
const kLevels = [
  (Difficulty.easy, 'Easy', 'Addition & multiplication only'),
  (Difficulty.medium, 'Medium', 'All four operations'),
  (Difficulty.hard, 'Hard', '6×6 grid — all operations'),
  (Difficulty.insane, 'Insane', '6×6 grid — giant cages, no mercy'),
];

class _StatsBar extends StatelessWidget {
  final GameState gameState;
  final VoidCallback? onNewGame;

  const _StatsBar({required this.gameState, this.onNewGame});

  @override
  Widget build(BuildContext context) {
    final minutes = (gameState.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (gameState.elapsedSeconds % 60).toString().padLeft(2, '0');

    return Container(
      color: kPrimary.withValues(alpha: 0.08),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        children: [
          if (onNewGame != null) ...[
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Tooltip(
                  message: 'New game',
                  child: TextButton.icon(
                    onPressed: onNewGame,
                    icon: const Icon(Icons.add_circle_outline, size: 22),
                    label: Text(
                      kLevels
                          .firstWhere((l) => l.$1 == gameState.difficulty)
                          .$2,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    '$minutes:$seconds',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  const Text('Oops: ', style: TextStyle(fontSize: 18)),
                  Text(
                    '${gameState.mistakes}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
