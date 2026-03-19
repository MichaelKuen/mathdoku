import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/features/game/domain/models/game_state.dart';
import 'package:sudoku/features/game/presentation/providers/game_provider.dart';
import 'package:sudoku/features/game/presentation/pages/game_page.dart';
import 'package:sudoku/core/providers/theme_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return _buildLandscape(context, ref);
          } else {
            return _buildPortrait(context, ref);
          }
        },
      ),
    );
  }

  Widget _buildPortrait(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'SUDOKU',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 40),
              const _IconLegend(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandscape(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'SUDOKU',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: _IconLegend(compact: true),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _DifficultyButton(
                          label: 'EASY',
                          color: Colors.green,
                          onPressed: () => _onStart(context, ref, Difficulty.easy),
                        ),
                        const SizedBox(height: 12),
                        _DifficultyButton(
                          label: 'MEDIUM',
                          color: Colors.orange,
                          onPressed: () => _onStart(context, ref, Difficulty.medium),
                        ),
                        const SizedBox(height: 12),
                        _DifficultyButton(
                          label: 'HARD',
                          color: Colors.red,
                          onPressed: () => _onStart(context, ref, Difficulty.hard),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

class _IconLegend extends StatelessWidget {
  final bool compact;
  const _IconLegend({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 24),
      margin: EdgeInsets.symmetric(horizontal: compact ? 0 : 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ICON LEGEND',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          SizedBox(height: compact ? 8 : 16),
          _LegendItem(icon: Icons.dark_mode, label: 'Dark Mode', compact: compact),
          _LegendItem(icon: Icons.light_mode, label: 'Light Mode', compact: compact),
          _LegendItem(icon: Icons.delete_outline, label: 'Erase Cell', compact: compact),
          _LegendItem(icon: Icons.refresh, label: 'New Game', compact: compact),
          _LegendItem(icon: Icons.lightbulb_outline, label: 'Hint (Reveal)', compact: compact),
          _LegendItem(icon: Icons.error_outline, label: 'Mistakes', compact: compact),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool compact;

  const _LegendItem({
    required this.icon,
    required this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: compact ? 2.0 : 6.0),
      child: Row(
        children: [
          Icon(icon, size: compact ? 16 : 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: compact ? 11 : 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
