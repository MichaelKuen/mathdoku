// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/glyph.dart';
import '../../domain/models/board.dart';
import '../providers/game_provider.dart';

const _digitColors = [
  Color(0xFFFFADAD), // 1 – pastel coral
  Color(0xFFB5EAD7), // 2 – pastel mint
  Color(0xFFFFDAC1), // 3 – pastel peach
  Color(0xFFC7CEEA), // 4 – pastel lavender
  Color(0xFFFFEBEE), // 5 – pastel rose
  Color(0xFFE8F5E9), // 6 – pastel sage
];

class NumberPad extends ConsumerWidget {
  const NumberPad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(gameNotifierProvider).board;

    final size = board?.size ?? 4;
    return Row(
      children: List.generate(size, (i) {
        final digit = i + 1;
        final isComplete = board != null && _isDigitComplete(board, digit);

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : 6),
            child: _DigitButton(
              digit: digit,
              color: _digitColors[i],
              isComplete: isComplete,
              onTap: isComplete
                  ? null
                  : () => ref
                      .read(gameNotifierProvider.notifier)
                      .inputNumber(digit),
            ),
          ),
        );
      }),
    );
  }

  bool _isDigitComplete(Board board, int digit) {
    int count = 0;
    for (int r = 0; r < board.size; r++) {
      for (int c = 0; c < board.size; c++) {
        final cell = board.getCell(r, c);
        if (cell.value == digit && !cell.isError) count++;
      }
    }
    return count >= board.size;
  }
}

class _DigitButton extends StatelessWidget {
  final int digit;
  final Color color;
  final bool isComplete;
  final VoidCallback? onTap;

  const _DigitButton({
    required this.digit,
    required this.color,
    required this.isComplete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isComplete ? 0.35 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  '$digit',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (isComplete)
                const Positioned(
                  top: 4,
                  right: 6,
                  child: Glyph('✓', Icons.check, size: 12, color: Colors.green),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionRow extends ConsumerWidget {
  const ActionRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPencilMode = ref.watch(
      gameNotifierProvider.select((s) => s.isPencilMode),
    );
    final notifier = ref.read(gameNotifierProvider.notifier);

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () => notifier.useHint(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: _ActionLabel('💡', Icons.lightbulb_outline, 'Hint'),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () => notifier.togglePencilMode(),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPencilMode
                    ? Colors.blueGrey.shade600
                    : Colors.blueGrey.shade100,
                foregroundColor: isPencilMode
                    ? Colors.white
                    : Colors.blueGrey.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: _ActionLabel('✏️', Icons.edit_outlined, 'Notes',
                    checked: isPencilMode, fontSize: 15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: () => notifier.eraseCell(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade400),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const FittedBox(
                fit: BoxFit.scaleDown,
                child: _ActionLabel('🧹', Icons.cleaning_services_outlined, 'Erase'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionLabel extends StatelessWidget {
  final String emoji;
  final IconData icon;
  final String text;
  final bool checked;
  final double fontSize;

  const _ActionLabel(this.emoji, this.icon, this.text,
      {this.checked = false, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Glyph(emoji, icon, size: fontSize + 2),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: fontSize)),
        if (checked) ...[
          const SizedBox(width: 4),
          Glyph('✓', Icons.check, size: fontSize),
        ],
      ],
    );
  }
}
