// Copyright © App Verse Games. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../providers/game_provider.dart';
import '../widgets/sudoku_grid.dart';
import '../../domain/models/game_state.dart';
import 'package:sudoku/core/providers/theme_provider.dart';
import 'package:sudoku/shared/widgets/games_hub_sheet.dart';
import 'package:sudoku/shared/pages/privacy_policy_page.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  final FocusNode _focusNode = FocusNode();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      final String logicalKey = event.logicalKey.keyLabel;
      if (RegExp(r'^[1-9]$').hasMatch(logicalKey)) {
        ref.read(gameNotifierProvider.notifier).inputNumber(int.parse(logicalKey));
      } else if (event.logicalKey == LogicalKeyboardKey.backspace ||
          event.logicalKey == LogicalKeyboardKey.delete) {
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
      } else if (event.logicalKey == LogicalKeyboardKey.keyN) {
        ref.read(gameNotifierProvider.notifier).togglePencilMode();
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
        content: const Text('Abandon this game and start a new one?'),
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
            child: Text(
              'NEW GAME',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appBarBg = isDark ? const Color(0xFF252540) : const Color(0xFFEEEEEE);

    ref.listen(gameNotifierProvider.select((s) => s.status), (previous, next) {
      if (next == GameStatus.won) {
        _confettiController.play();
        _showWinDialog(context, ref, gameState);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        backgroundColor: appBarBg,
        leading: IconButton(
          icon: const Text('⬅️', style: TextStyle(fontSize: 20)),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Text('🎮', style: TextStyle(fontSize: 20)),
            tooltip: 'Games Hub',
            onPressed: () => showGamesHub(context),
          ),
          IconButton(
            icon: const Text('🔒', style: TextStyle(fontSize: 20)),
            tooltip: 'Privacy Policy',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
            ),
          ),
          IconButton(
            icon: Text(isDark ? '☀️' : '🌙', style: const TextStyle(fontSize: 20)),
            tooltip: 'Toggle Theme',
            onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: Stack(
        children: [
          KeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: _handleKeyEvent,
            child: gameState.status == GameStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 600) {
                        return _buildWideLayout(context, ref, gameState, theme, isDark);
                      }
                      return _buildNarrowLayout(context, ref, gameState, isDark);
                    },
                  ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 20,
              minBlastForce: 8,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.amber,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout(
    BuildContext context,
    WidgetRef ref,
    GameState gameState,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final outlineStyle = OutlinedButton.styleFrom(
      side: BorderSide(color: theme.colorScheme.outline),
      padding: const EdgeInsets.symmetric(vertical: 6),
    );
    return Column(
      children: [
        _StatsBar(gameState: gameState, isDark: isDark),
        Expanded(
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
                    child: const SudokuGrid(),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: gameState.isPencilMode
                            ? FilledButton.icon(
                                onPressed: () => ref.read(gameNotifierProvider.notifier).togglePencilMode(),
                                icon: const Text('✏️', style: TextStyle(fontSize: 13)),
                                label: const Text('Pencil', style: TextStyle(fontSize: 11)),
                                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 6)),
                              )
                            : OutlinedButton.icon(
                                onPressed: () => ref.read(gameNotifierProvider.notifier).togglePencilMode(),
                                icon: const Text('✏️', style: TextStyle(fontSize: 13)),
                                label: const Text('Pencil', style: TextStyle(fontSize: 11)),
                                style: outlineStyle,
                              ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: gameState.hintsRemaining > 0
                              ? () => ref.read(gameNotifierProvider.notifier).useHint()
                              : null,
                          icon: Text('💡', style: TextStyle(fontSize: 13, color: gameState.hintsRemaining > 0 ? Colors.amber : null)),
                          label: Text('Hint (${gameState.hintsRemaining})', style: const TextStyle(fontSize: 11)),
                          style: outlineStyle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => ref.read(gameNotifierProvider.notifier).eraseCell(),
                          icon: const Text('🗑️', style: TextStyle(fontSize: 13)),
                          label: const Text('Erase', style: TextStyle(fontSize: 11)),
                          style: outlineStyle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showRefreshConfirmation(context, ref, gameState),
                          icon: const Text('🔄', style: TextStyle(fontSize: 13)),
                          label: const Text('New', style: TextStyle(fontSize: 11)),
                          style: outlineStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _NumberPad(isVertical: false),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWideLayout(
    BuildContext context,
    WidgetRef ref,
    GameState gameState,
    ThemeData theme,
    bool isDark,
  ) {
    final sidebarBg = isDark ? const Color(0xFF252540) : const Color(0xFFEEEEEE);
    final sidebarBorder = isDark ? const Color(0xFF5A5A7A) : const Color(0xFFCCCCCC);
    final minutes = (gameState.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (gameState.elapsedSeconds % 60).toString().padLeft(2, '0');

    return Row(
      children: [
        const SizedBox(width: 180),
        Expanded(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400, maxHeight: 400),
                  child: const SudokuGrid(),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 180,
          decoration: BoxDecoration(
            color: sidebarBg,
            border: Border(left: BorderSide(color: sidebarBorder)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'MODE',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              _SidebarButton(
                label: gameState.isPencilMode ? 'Pencil ON' : 'Pencil',
                emoji: '✏️',
                isSelected: gameState.isPencilMode,
                onPressed: () => ref.read(gameNotifierProvider.notifier).togglePencilMode(),
              ),
              const Divider(height: 24),
              Text(
                'ACTIONS',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: Text(
                  '💡',
                  style: TextStyle(
                    fontSize: 14,
                    color: gameState.hintsRemaining > 0 ? Colors.amber : null,
                  ),
                ),
                label: Text('Hint (${gameState.hintsRemaining})'),
                onPressed: gameState.hintsRemaining > 0
                    ? () => ref.read(gameNotifierProvider.notifier).useHint()
                    : null,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.colorScheme.outline),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Text('🗑️', style: TextStyle(fontSize: 14)),
                label: const Text('Erase'),
                onPressed: () => ref.read(gameNotifierProvider.notifier).eraseCell(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.colorScheme.outline),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Text('🔄', style: TextStyle(fontSize: 14)),
                label: const Text('New Game'),
                onPressed: () => _showRefreshConfirmation(context, ref, gameState),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.colorScheme.outline),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const Divider(height: 24),
              Text(
                'NUMBER PAD',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              _NumberPad(isVertical: true, isCompact: true),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E38) : const Color(0xFFF0F0F0),
                  border: Border.all(
                    color: isDark ? const Color(0xFF3A3A5A) : const Color(0xFFD0D0D0),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⏱️', style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 4),
                        Text(
                          '$minutes:$seconds',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⚠️', style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 4),
                        Text(
                          '${gameState.mistakes}/${gameState.maxMistakes}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Text('🎮', style: TextStyle(fontSize: 14)),
                label: const Text('More Games', style: TextStyle(fontSize: 12)),
                onPressed: () => showGamesHub(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showWinDialog(BuildContext context, WidgetRef ref, GameState state) {
    final minutes = (state.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (state.elapsedSeconds % 60).toString().padLeft(2, '0');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Center(
          child: const Text(
            'CONGRATULATIONS!',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ).animate().fadeIn(duration: 400.ms).scale(delay: 200.ms),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 80))
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut)
                .rotate(begin: -0.1, end: 0, duration: 600.ms),
            const SizedBox(height: 16),
            Text('Time: $minutes:$seconds')
                .animate()
                .fadeIn(delay: 400.ms)
                .slideX(begin: -0.2, end: 0),
            Text('Mistakes: ${state.mistakes}/${state.maxMistakes}')
                .animate()
                .fadeIn(delay: 600.ms)
                .slideX(begin: -0.2, end: 0),
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
            ).animate().fadeIn(delay: 800.ms).moveY(begin: 20, end: 0),
          ),
        ],
      ),
    );
  }
}

class _SidebarButton extends StatelessWidget {
  final String label;
  final String? emoji;
  final bool isSelected;
  final VoidCallback onPressed;

  const _SidebarButton({
    required this.label,
    this.emoji,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isSelected) {
      return FilledButton.icon(
        onPressed: null,
        icon: emoji != null ? Text(emoji!, style: const TextStyle(fontSize: 14)) : const SizedBox.shrink(),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        style: FilledButton.styleFrom(
          disabledBackgroundColor: theme.colorScheme.primary,
          disabledForegroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: emoji != null ? Text(emoji!, style: const TextStyle(fontSize: 14)) : const SizedBox.shrink(),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: theme.colorScheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  final GameState gameState;
  final bool isDark;

  const _StatsBar({required this.gameState, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final minutes = (gameState.elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (gameState.elapsedSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      color: isDark ? const Color(0xFF1E1E38) : const Color(0xFFF0F0F0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('⏱️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                '$minutes:$seconds',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                'Mistakes: ${gameState.mistakes}/${gameState.maxMistakes}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
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
    final gameState = ref.watch(gameNotifierProvider);
    final theme = Theme.of(context);
    final board = gameState.board;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isVertical ? 3 : 9,
        crossAxisSpacing: isCompact ? 4 : 8,
        mainAxisSpacing: isCompact ? 4 : 8,
        childAspectRatio: isVertical ? 1.2 : 1.0,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final number = index + 1;
        bool isComplete = false;
        if (board != null) {
          int count = 0;
          for (int r = 0; r < 9; r++) {
            for (int c = 0; c < 9; c++) {
              final cell = board.getCell(r, c);
              if (cell.value == number && !cell.isError) count++;
            }
          }
          isComplete = count >= 9;
        }

        return InkWell(
          onTap: isComplete
              ? null
              : () => ref.read(gameNotifierProvider.notifier).inputNumber(number),
          borderRadius: BorderRadius.circular(8),
          child: Opacity(
            opacity: isComplete ? 0.3 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.08),
                border: Border.all(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.25),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontSize: isCompact ? 16 : 22,
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isComplete)
                    const Positioned(
                      top: 2,
                      right: 2,
                      child: Text('✓', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
