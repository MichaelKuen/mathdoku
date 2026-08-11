// Copyright © FullStackShack. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudoku/features/game/domain/models/game_state.dart';
import 'package:sudoku/features/game/presentation/providers/game_provider.dart';
import 'package:sudoku/features/game/presentation/pages/game_page.dart';
import 'package:sudoku/core/providers/theme_provider.dart';
import 'package:sudoku/shared/widgets/games_hub_sheet.dart';
import 'package:sudoku/shared/pages/privacy_policy_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Difficulty _selectedDifficulty = Difficulty.easy;

  void _onStart() {
    ref.read(gameNotifierProvider.notifier).startGame(_selectedDifficulty);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GamePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appBarBg = isDark ? const Color(0xFF252540) : const Color(0xFFEEEEEE);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        backgroundColor: appBarBg,
        actions: [
          IconButton(
            icon: const Icon(Icons.sports_esports),
            tooltip: 'Games Hub',
            onPressed: () => showGamesHub(context),
          ),
          IconButton(
            icon: const Icon(Icons.privacy_tip_outlined),
            tooltip: 'Privacy Policy',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
            ),
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 600) {
            return _buildWideLayout(context, theme, isDark);
          }
          return _buildNarrowLayout(context, theme);
        },
      ),
    );
  }

  Widget _buildNarrowLayout(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(
              'SUDOKU',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SegmentedButton<Difficulty>(
              segments: const [
                ButtonSegment(
                  value: Difficulty.easy,
                  label: Text('Easy'),
                  icon: Icon(Icons.sentiment_satisfied_alt, size: 16),
                ),
                ButtonSegment(
                  value: Difficulty.medium,
                  label: Text('Medium'),
                  icon: Icon(Icons.sentiment_neutral, size: 16),
                ),
                ButtonSegment(
                  value: Difficulty.hard,
                  label: Text('Hard'),
                  icon: Icon(Icons.sentiment_very_dissatisfied, size: 16),
                ),
              ],
              selected: {_selectedDifficulty},
              onSelectionChanged: (Set<Difficulty> selection) {
                setState(() => _selectedDifficulty = selection.first);
              },
            ),
            const SizedBox(height: 24),
            const _IconLegend(),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _onStart,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Start Game',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context, ThemeData theme, bool isDark) {
    final sidebarBg = isDark ? const Color(0xFF252540) : const Color(0xFFEEEEEE);
    final sidebarBorder = isDark ? const Color(0xFF5A5A7A) : const Color(0xFFCCCCCC);

    return Row(
      children: [
        const SizedBox(width: 180),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'SUDOKU',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: const _IconLegend(),
                  ),
                ],
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
                'DIFFICULTY',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              _SidebarButton(
                label: 'Easy',
                isSelected: _selectedDifficulty == Difficulty.easy,
                onPressed: () => setState(() => _selectedDifficulty = Difficulty.easy),
              ),
              const SizedBox(height: 8),
              _SidebarButton(
                label: 'Medium',
                isSelected: _selectedDifficulty == Difficulty.medium,
                onPressed: () => setState(() => _selectedDifficulty = Difficulty.medium),
              ),
              const SizedBox(height: 8),
              _SidebarButton(
                label: 'Hard',
                isSelected: _selectedDifficulty == Difficulty.hard,
                onPressed: () => setState(() => _selectedDifficulty = Difficulty.hard),
              ),
              const Divider(height: 32),
              FilledButton(
                onPressed: _onStart,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Start'),
              ),
              const Spacer(),
              const Divider(),
              OutlinedButton.icon(
                icon: const Icon(Icons.sports_esports, size: 16),
                label: const Text('More Games', style: TextStyle(fontSize: 12)),
                onPressed: () => showGamesHub(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _SidebarButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isSelected) {
      return FilledButton(
        onPressed: null,
        style: FilledButton.styleFrom(
          disabledBackgroundColor: theme.colorScheme.primary,
          disabledForegroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: theme.colorScheme.outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label),
    );
  }
}

class _IconLegend extends StatelessWidget {
  const _IconLegend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252540) : Colors.white,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ICON LEGEND',
            style: theme.textTheme.labelMedium?.copyWith(
              letterSpacing: 1.2,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 12),
          _LegendItem(icon: Icons.edit_outlined, label: 'Pencil mode (N)'),
          _LegendItem(icon: Icons.lightbulb_outline, label: 'Hint (H)'),
          _LegendItem(icon: Icons.delete_outline, label: 'Erase cell'),
          _LegendItem(icon: Icons.refresh, label: 'New game'),
          _LegendItem(icon: Icons.error_outline, label: 'Mistake counter'),
          _LegendItem(icon: Icons.timer_outlined, label: 'Elapsed time'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LegendItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
