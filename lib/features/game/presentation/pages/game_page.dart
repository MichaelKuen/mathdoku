// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
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
      body: Stack(
        children: [
          gameState.status == GameStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _StatsBar(gameState: gameState),
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 340,
                            maxHeight: 340,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: const MathdokuGrid(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const NumberPad(),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const ActionRow(),
                    ),
                    const SizedBox(height: 28),
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
