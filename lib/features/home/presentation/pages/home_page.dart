// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../game/domain/models/game_state.dart';
import '../../../game/presentation/providers/game_provider.dart';
import '../../../game/presentation/pages/game_page.dart';
import '../../../../core/theme/app_theme.dart';
import 'privacy_policy_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mathdoku'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Center(
                child: const Text('🔢', style: TextStyle(fontSize: 90))
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.elasticOut),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Mathdoku',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: kPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Math puzzles made fun!',
                  style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 48),
              const Center(
                child: Text(
                  'Choose your level:',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              _DifficultyButton(
                emoji: '⭐',
                label: 'Easy',
                subtitle: 'Addition & multiplication only',
                colour: const Color(0xFFB5EAD7),
                onTap: () {
                  ref
                      .read(gameNotifierProvider.notifier)
                      .startGame(Difficulty.easy);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GamePage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _DifficultyButton(
                emoji: '⭐⭐',
                label: 'Medium',
                subtitle: 'All four operations',
                colour: const Color(0xFFFFDAC1),
                onTap: () {
                  ref
                      .read(gameNotifierProvider.notifier)
                      .startGame(Difficulty.medium);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GamePage()),
                  );
                },
              ),
              const SizedBox(height: 48),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyPage()),
                  ),
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String emoji;
  final String label;
  final String subtitle;
  final Color colour;
  final VoidCallback onTap;

  const _DifficultyButton({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.colour,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.black45, size: 18),
          ],
        ),
      ),
    );
  }
}
