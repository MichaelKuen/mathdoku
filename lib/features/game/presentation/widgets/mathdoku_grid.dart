// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/board.dart';
import '../../domain/models/cell.dart';
import '../providers/game_provider.dart';
import '../../../../core/theme/app_theme.dart';

const List<Color> kCageColors = [
  Color(0xFFFFEBEE), // pastel red
  Color(0xFFE3F2FD), // pastel blue
  Color(0xFFE8F5E9), // pastel green
  Color(0xFFFFF8E1), // pastel yellow
  Color(0xFFF3E5F5), // pastel purple
  Color(0xFFE0F7FA), // pastel cyan
  Color(0xFFFBE9E7), // pastel orange
  Color(0xFFF1F8E9), // pastel lime
  Color(0xFFE8EAF6), // pastel indigo
  Color(0xFFE1F5FE), // pastel light-blue
];

// Saturated border colours — one per cage, matched to kCageColors hues.
const List<Color> kCageBorderColors = [
  Color(0xFFE57373), // red
  Color(0xFF64B5F6), // blue
  Color(0xFF81C784), // green
  Color(0xFFFFD54F), // yellow
  Color(0xFFBA68C8), // purple
  Color(0xFF4DD0E1), // cyan
  Color(0xFFFF8A65), // orange
  Color(0xFFAED581), // lime
  Color(0xFF7986CB), // indigo
  Color(0xFF4FC3F7), // light-blue
];

class MathdokuGrid extends ConsumerWidget {
  const MathdokuGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(gameNotifierProvider).board;
    if (board == null) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kPrimary, width: 4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              final row = index ~/ 4;
              final col = index % 4;
              return _MathdokuCell(
                cell: board.getCell(row, col),
                board: board,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MathdokuCell extends ConsumerWidget {
  final Cell cell;
  final Board board;

  const _MathdokuCell({required this.cell, required this.board});

  Color _bgColor() {
    if (cell.isSelected) return kPrimary.withValues(alpha: 0.50);
    if (cell.isSameNumber) return kSecondary.withValues(alpha: 0.35);
    if (cell.isHighlighted) return Colors.grey.withValues(alpha: 0.20);

    final base = kCageColors[cell.cageId % kCageColors.length];
    if (cell.cageStatus == CellStatus.correct) {
      return Color.alphaBlend(Colors.green.withValues(alpha: 0.22), base);
    }
    if (cell.cageStatus == CellStatus.incorrect) {
      return Color.alphaBlend(Colors.orange.withValues(alpha: 0.22), base);
    }
    return base;
  }

  // Only draw top and left borders to avoid doubling between adjacent cells.
  // Bottom is drawn for the last row, right for the last column.
  BorderSide _side(int dr, int dc) {
    final nr = cell.row + dr;
    final nc = cell.col + dc;
    if (nr < 0 || nr > 3 || nc < 0 || nc > 3) {
      return const BorderSide(width: 4.0, color: Colors.black87);
    }
    final neighbor = board.getCell(nr, nc);
    if (neighbor.cageId == cell.cageId) {
      return BorderSide(width: 1.5, color: Colors.grey.shade500);
    }
    return BorderSide(
      width: 3.5,
      color: kCageBorderColors[cell.cageId % kCageBorderColors.length],
    );
  }

  Border _border() => Border(
        top: cell.row == 0 ? BorderSide.none : _side(-1, 0),
        left: cell.col == 0 ? BorderSide.none : _side(0, -1),
        bottom: cell.row == 3 ? _side(1, 0) : BorderSide.none,
        right: cell.col == 3 ? _side(0, 1) : BorderSide.none,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content = Stack(
      children: [
        // Clue label in top-left corner
        if (cell.showClue)
          Positioned(
            top: 2,
            left: 3,
            child: Text(
              cell.clueText,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                height: 1.0,
              ),
            ),
          ),
        // Player digit centred
        if (cell.value != 0)
          Center(
            child: Text(
              '${cell.value}',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: cell.isError
                    ? Colors.red.shade600
                    : cell.isFixed
                        ? Colors.black87
                        : Colors.green.shade700,
              ),
            ),
          ),
      ],
    );

    // Animations
    if (cell.isSelected) {
      content = content
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.06, 1.06),
            duration: 700.ms,
            curve: Curves.easeInOut,
          );
    }
    if (cell.isError) {
      content = content
          .animate()
          .shake(hz: 6, duration: 350.ms)
          .tint(color: Colors.red.withValues(alpha: 0.30), duration: 300.ms);
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(gameNotifierProvider.notifier).selectCell(cell.row, cell.col);
      },
      child: Container(
        decoration: BoxDecoration(
          color: _bgColor(),
          border: _border(),
        ),
        child: content,
      ),
    );
  }
}
