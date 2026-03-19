import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import '../providers/game_provider.dart';
import '../../domain/models/cell.dart';

class SudokuGrid extends ConsumerWidget {
  const SudokuGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameNotifierProvider);
    final board = gameState.board;

    if (board == null) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 9,
          ),
          itemCount: 81,
          itemBuilder: (context, index) {
            final row = index ~/ 9;
            final col = index % 9;
            final cell = board.getCell(row, col);
            return _SudokuCell(cell: cell);
          },
        ),
      ),
    );
  }
}

class _SudokuCell extends ConsumerWidget {
  final Cell cell;

  const _SudokuCell({required this.cell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color? backgroundColor;
    
    final isCorrect = cell.blockStatus == CellStatus.correct || 
                     cell.rowStatus == CellStatus.correct || 
                     cell.colStatus == CellStatus.correct;
                     
    final isIncorrect = cell.blockStatus == CellStatus.incorrect || 
                       cell.rowStatus == CellStatus.incorrect || 
                       cell.colStatus == CellStatus.incorrect;

    // Priority for background color
    if (isCorrect) {
      backgroundColor = Colors.green.withValues(alpha: 0.2);
    } else if (isIncorrect) {
      backgroundColor = Colors.orange.withValues(alpha: 0.2);
    } else if (cell.isSelected) {
      backgroundColor = Colors.blue.withValues(alpha: 0.5);
    } else if (cell.isSameNumber) {
      // Number Scoping: Distinct secondary highlight
      backgroundColor = Colors.blue.withValues(alpha: 0.3);
    } else if (cell.isHighlighted) {
      backgroundColor = Colors.blue.withValues(alpha: 0.1);
    }

    BorderSide thin = const BorderSide(color: Colors.grey, width: 0.5);
    BorderSide thick = const BorderSide(color: Colors.black, width: 2.0);

    Widget cellContent;
    
    if (cell.value != 0) {
      cellContent = Center(
        child: Text(
          '${cell.value}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: cell.isFixed ? FontWeight.bold : FontWeight.normal,
            color: cell.isError ? Colors.red : (cell.isFixed ? Colors.black : Colors.blue),
          ),
        ),
      );
    } else {
      // Pencil/Notes Mode: 3x3 mini-grid for candidates
      cellContent = Padding(
        padding: const EdgeInsets.all(2.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            final noteValue = index + 1;
            final hasNote = cell.notes.contains(noteValue);
            return Center(
              child: Text(
                hasNote ? '$noteValue' : '',
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.grey,
                  height: 1,
                ),
              ),
            );
          },
        ),
      );
    }

    // Apply animations
    if (cell.isSelected) {
      cellContent = cellContent.animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      ).scale(
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.05, 1.05),
        duration: 800.ms,
        curve: Curves.easeInOut,
      );
    }

    if (cell.isError) {
      cellContent = cellContent.animate()
        .shake(hz: 8, curve: Curves.easeInOut, duration: 300.ms)
        .tint(color: Colors.red.withValues(alpha: 0.3), duration: 300.ms);
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ref.read(gameNotifierProvider.notifier).selectCell(cell.row, cell.col);
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            top: cell.row % 3 == 0 ? thick : thin,
            left: cell.col % 3 == 0 ? thick : thin,
            bottom: cell.row == 8 ? thick : BorderSide.none,
            right: cell.col == 8 ? thick : BorderSide.none,
          ),
        ),
        child: Stack(
          children: [
            cellContent,
            if (isCorrect)
              Positioned.fill(
                child: Container()
                    .animate()
                    .shimmer(
                      duration: 600.ms,
                      color: Colors.green.withValues(alpha: 0.4),
                    ),
              ),
          ],
        ),
      ),
    );
  }
}
