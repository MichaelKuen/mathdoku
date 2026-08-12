// Copyright © App Verse Games. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/privacy_policy_page.dart';

void showGamesHub(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const _GamesHubSheet(),
  );
}

class _GamesHubSheet extends StatelessWidget {
  const _GamesHubSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF5F5F5);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                child: Row(
                  children: [
                    const Text('🎮', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Text(
                      'App Verse Games',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Text('✕', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  children: const [
                    _GameCard(
                      emoji: '🔢',
                      iconColor: Color(0xFFFF5252),
                      name: 'Sudoku',
                      tagline: 'Fill the grid with logic',
                      isPlaying: true,
                    ),
                    SizedBox(height: 12),
                    _GameCard(
                      emoji: '❌',
                      iconColor: Color(0xFF40C4FF),
                      name: 'Tic Tac Toe',
                      tagline: 'Classic X vs O showdown',
                      isPlaying: false,
                      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.appversegames.tictactoe',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Text('↗️', style: TextStyle(fontSize: 14)),
                        label: const Text('View all on Google Play'),
                        onPressed: () async {
                          final uri = Uri.parse(
                            'https://play.google.com/store/apps/developer?id=AppVerseGames',
                          );
                          if (await canLaunchUrl(uri)) launchUrl(uri);
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Games shown here are App Verse Games originals.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                        );
                      },
                      child: Text(
                        'Privacy Policy',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GameCard extends StatelessWidget {
  final String emoji;
  final Color iconColor;
  final String name;
  final String tagline;
  final bool isPlaying;
  final String? playStoreUrl;

  const _GameCard({
    required this.emoji,
    required this.iconColor,
    required this.name,
    required this.tagline,
    required this.isPlaying,
    this.playStoreUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF252540) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(
          color: isPlaying ? theme.colorScheme.primary : theme.colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  tagline,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isPlaying)
            _Badge(label: 'Playing', color: theme.colorScheme.primary)
          else if (playStoreUrl != null && playStoreUrl!.isNotEmpty)
            OutlinedButton(
              onPressed: () async {
                final uri = Uri.parse(playStoreUrl!);
                if (await canLaunchUrl(uri)) launchUrl(uri);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Play', style: TextStyle(fontSize: 12)),
            )
          else
            _Badge(label: 'Soon', color: theme.colorScheme.outline),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
