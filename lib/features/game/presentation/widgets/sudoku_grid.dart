import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    
    // Priority for background color
    if (cell.blockStatus == CellStatus.correct || 
        cell.rowStatus == CellStatus.correct || 
        cell.colStatus == CellStatus.correct) {
      backgroundColor = Colors.green.withValues(alpha: 0.2);
    } else if (cell.blockStatus == CellStatus.incorrect || 
               cell.rowStatus == CellStatus.incorrect || 
               cell.colStatus == CellStatus.incorrect) {
      backgroundColor = Colors.orange.withValues(alpha: 0.2);
    } else if (cell.isSelected) {
      backgroundColor = Colors.blue.withValues(alpha: 0.5);
    } else if (cell.isHighlighted) {
      backgroundColor = Colors.blue.withValues(alpha: 0.1);
    }

    BorderSide thin = const BorderSide(color: Colors.grey, width: 0.5);
    BorderSide thick = const BorderSide(color: Colors.black, width: 2.0);

    return GestureDetector(
      onTap: () => ref.read(gameNotifierProvider.notifier).selectCell(cell.row, cell.col),
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
        child: Center(
          child: Text(
            cell.value == 0 ? '' : '${cell.value}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: cell.isFixed ? FontWeight.bold : FontWeight.normal,
              color: cell.isError ? Colors.red : (cell.isFixed ? Colors.black : Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
