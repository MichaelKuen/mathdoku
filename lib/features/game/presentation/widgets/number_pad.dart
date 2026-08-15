// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/board.dart';
import '../providers/game_provider.dart';

const _digitColors = [
  Color(0xFFFFADAD), // 1 – pastel coral
  Color(0xFFB5EAD7), // 2 – pastel mint
  Color(0xFFFFDAC1), // 3 – pastel peach
  Color(0xFFC7CEEA), // 4 – pastel lavender
];

class NumberPad extends ConsumerWidget {
  const NumberPad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(gameNotifierProvider).board;

    return Row(
      children: List.generate(4, (i) {
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
    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        final cell = board.getCell(r, c);
        if (cell.value == digit && !cell.isError) count++;
      }
    }
    return count >= 4;
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
                  child: Text(
                    '✓',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('💡 Hint', style: TextStyle(fontSize: 16)),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                '✏️ ${isPencilMode ? "Notes ON" : "Notes"}',
                style: const TextStyle(fontSize: 15),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('🧹 Erase', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }
}
