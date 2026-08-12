// Copyright © App Verse Games. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appBarBg = isDark ? const Color(0xFF252540) : const Color(0xFFEEEEEE);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Privacy Policy'),
          backgroundColor: appBarBg,
          bottom: TabBar(
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            tabs: const [
              Tab(text: 'Summary'),
              Tab(text: 'Full Policy'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _SummaryTab(),
            _FullPolicyTab(),
          ],
        ),
      ),
    );
  }
}

class _SummaryTab extends StatelessWidget {
  const _SummaryTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E38) : const Color(0xFFE8EAF6),
            border: Border.all(
              color: isDark ? const Color(0xFF3A3A5A) : const Color(0xFFC5CAE9),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Text('ℹ️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Effective date: January 1, 2025',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF7986CB),
                  ),
                ),
              ),
            ],
          ),
        ),
        _SummaryItem(
          emoji: '🚫',
          iconColor: theme.colorScheme.primary,
          title: 'No Data Collected',
          description: 'We do not collect, store, or transmit any personal information.',
        ),
        _SummaryItem(
          emoji: '📵',
          iconColor: theme.colorScheme.secondary,
          title: 'Fully Offline',
          description: 'Sudoku works entirely offline. No internet connection required.',
        ),
        _SummaryItem(
          emoji: '👤',
          iconColor: const Color(0xFF69F0AE),
          title: 'No Account Required',
          description: 'Play instantly — no sign-up, no login, no tracking.',
        ),
        _SummaryItem(
          emoji: '💾',
          iconColor: const Color(0xFFFFD740),
          title: 'Local Storage Only',
          description: 'Game progress is saved locally on your device only.',
        ),
        _SummaryItem(
          emoji: '📢',
          iconColor: const Color(0xFF7986CB),
          title: 'No Ads or Analytics',
          description:
              'No advertising SDKs, no analytics libraries, no third-party tracking.',
        ),
        const SizedBox(height: 24),
        Text(
          'Contact',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Text('📧', style: TextStyle(fontSize: 18)),
          label: const Text('Contact Us'),
          onPressed: () async {
            final uri = Uri.parse(
              'mailto:play@appversegames.com?subject=Sudoku%20Privacy',
            );
            if (await canLaunchUrl(uri)) launchUrl(uri);
          },
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String emoji;
  final Color iconColor;
  final String title;
  final String description;

  const _SummaryItem({
    required this.emoji,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252540) : Colors.white,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FullPolicyTab extends StatelessWidget {
  const _FullPolicyTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _PolicySection(
          number: '1',
          title: 'Introduction',
          body:
              'App Verse Games ("we", "our", or "us") operates the Sudoku mobile application. '
              'This Privacy Policy explains our practices regarding the collection, use, and '
              'disclosure of information when you use our app.',
        ),
        _PolicySection(
          number: '2',
          title: 'Information We Collect',
          body:
              'We do not collect any personal information. The Sudoku app does not require '
              'registration, does not connect to our servers, and does not transmit any data '
              'from your device.',
        ),
        _PolicySection(
          number: '3',
          title: 'Local Data Storage',
          body:
              'Game progress and settings (such as theme preference) may be stored locally '
              'on your device using standard platform storage mechanisms. This data never '
              'leaves your device.',
        ),
        _PolicySection(
          number: '4',
          title: 'Third-Party Services',
          body:
              'The Sudoku app does not integrate any third-party analytics, advertising, or '
              'tracking SDKs. We do not share any information with third parties because we '
              'do not collect any.',
        ),
        _PolicySection(
          number: '5',
          title: "Children's Privacy",
          body:
              'Our app is safe for all ages. We do not knowingly collect personal information '
              'from anyone, including children under the age of 13.',
        ),
        _PolicySection(
          number: '6',
          title: 'Changes to This Policy',
          body:
              'We may update this Privacy Policy from time to time. Changes will be reflected '
              'in an updated effective date. Continued use of the app after changes constitutes '
              'acceptance of the updated policy.',
        ),
        _PolicySection(
          number: '7',
          title: 'Contact Us',
          body:
              'If you have any questions about this Privacy Policy, please contact us at '
              'play@appversegames.com.',
        ),
      ],
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String number;
  final String title;
  final String body;

  const _PolicySection({
    required this.number,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. $title',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.65,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
