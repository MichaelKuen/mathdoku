import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/features/game/domain/models/game_state.dart';
import 'package:sudoku/features/game/presentation/providers/game_provider.dart';
import 'package:sudoku/features/game/presentation/pages/game_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SUDOKU',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 60),
            _DifficultyButton(
              label: 'EASY',
              color: Colors.green,
              onPressed: () => _onStart(context, ref, Difficulty.easy),
            ),
            const SizedBox(height: 16),
            _DifficultyButton(
              label: 'MEDIUM',
              color: Colors.orange,
              onPressed: () => _onStart(context, ref, Difficulty.medium),
            ),
            const SizedBox(height: 16),
            _DifficultyButton(
              label: 'HARD',
              color: Colors.red,
              onPressed: () => _onStart(context, ref, Difficulty.hard),
            ),
          ],
        ),
      ),
    );
  }

  void _onStart(BuildContext context, WidgetRef ref, Difficulty difficulty) {
    ref.read(gameNotifierProvider.notifier).startGame(difficulty);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GamePage()),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _DifficultyButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
