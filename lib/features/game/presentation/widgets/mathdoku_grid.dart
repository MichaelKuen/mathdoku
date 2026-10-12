// Copyright © App Verse Games. All rights reserved.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/board.dart';
import '../../domain/models/cell.dart';
import '../providers/game_provider.dart';
import '../../../../core/theme/app_theme.dart';

// Material 100-shade colours — clearly distinct but not overwhelming.
const List<Color> kCageColors = [
  Color(0xFFFFCDD2), // red
  Color(0xFFBBDEFB), // blue
  Color(0xFFC8E6C9), // green
  Color(0xFFFFF9C4), // yellow
  Color(0xFFE1BEE7), // purple
  Color(0xFFB2EBF2), // cyan
  Color(0xFFFFCCBC), // deep-orange
  Color(0xFFDCEDC8), // lime
  Color(0xFFC5CAE9), // indigo
  Color(0xFFB3E5FC), // sky
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
          border: Border.all(color: GameColors.of(context).frame, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CustomPaint(
            foregroundPainter: _CageBorderPainter(board),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: board.size,
              ),
              itemCount: board.size * board.size,
              itemBuilder: (context, index) {
                final row = index ~/ board.size;
                final col = index % board.size;
                return LayoutBuilder(
                  builder: (context, c) => _MathdokuCell(
                    cell: board.getCell(row, col),
                    board: board,
                    cellSize: c.maxWidth,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Draws faint inner grid lines, then overwrites cage boundaries with thick
// dark lines so each cage reads as one solid block.
class _CageBorderPainter extends CustomPainter {
  final Board board;
  const _CageBorderPainter(this.board);

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / board.size;

    final innerPaint = Paint()
      ..color = const Color(0x22000000)
      ..strokeWidth = 0.5;

    final cagePaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.square;

    // Step 1 — faint lines across the full grid
    for (int i = 1; i < board.size; i++) {
      final pos = i * cellSize;
      canvas.drawLine(Offset(0, pos), Offset(size.width, pos), innerPaint);
      canvas.drawLine(Offset(pos, 0), Offset(pos, size.height), innerPaint);
    }

    // Step 2 — thick dark line wherever two adjacent cells are in different cages
    // Horizontal boundaries
    for (int r = 0; r < board.size - 1; r++) {
      for (int c = 0; c < board.size; c++) {
        if (board.getCell(r, c).cageId != board.getCell(r + 1, c).cageId) {
          final y = (r + 1) * cellSize;
          canvas.drawLine(
            Offset(c * cellSize, y),
            Offset((c + 1) * cellSize, y),
            cagePaint,
          );
        }
      }
    }

    // Vertical boundaries
    for (int r = 0; r < board.size; r++) {
      for (int c = 0; c < board.size - 1; c++) {
        if (board.getCell(r, c).cageId != board.getCell(r, c + 1).cageId) {
          final x = (c + 1) * cellSize;
          canvas.drawLine(
            Offset(x, r * cellSize),
            Offset(x, (r + 1) * cellSize),
            cagePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_CageBorderPainter old) => old.board != board;
}

class _MathdokuCell extends ConsumerWidget {
  final Cell cell;
  final Board board;
  final double cellSize;

  const _MathdokuCell({
    required this.cell,
    required this.board,
    required this.cellSize,
  });

  Color _bgColor(GameColors colors) {
    final base = kCageColors[cell.cageId % kCageColors.length];

    if (cell.isSelected) return colors.selection.withValues(alpha: 0.50);
    if (cell.isSameNumber) {
      return Color.alphaBlend(colors.sameNumber.withValues(alpha: 0.35), base);
    }
    if (cell.isHighlighted) {
      return Color.alphaBlend(Colors.black.withValues(alpha: 0.10), base);
    }

    if (cell.cageStatus == CellStatus.correct) {
      return Color.alphaBlend(Colors.green.withValues(alpha: 0.22), base);
    }
    if (cell.cageStatus == CellStatus.incorrect) {
      return Color.alphaBlend(Colors.orange.withValues(alpha: 0.22), base);
    }
    return base;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Text scales with the cell. The 6×6 grid's clue font is a bit larger for
    // its cell size so long clues (e.g. "720×") stay readable.
    final clueFontSize = cellSize * (board.size > 4 ? 0.19 : 0.16);
    final noteFontSize = cellSize * (board.size > 4 ? 0.16 : 0.14);
    final digitFontSize = cellSize * 0.42;

    Widget content = Stack(
      children: [
        // Clue label — top-left corner with white backing so it's always readable
        if (cell.showClue)
          Positioned(
            top: 2,
            left: 2,
            right: 2,
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.60),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  cell.clueText,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: clueFontSize,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
        // Pencil notes — 2×2 for 4×4 grid, 2×3 for 6×6 grid
        if (cell.value == 0 && cell.notes.isNotEmpty)
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  2, cell.showClue ? clueFontSize + 5 : 4, 2, 4),
              child: Builder(builder: (context) {
                final noteCols = board.size == 4 ? 2 : 3;
                return Column(
                  children: List.generate(2, (rowIdx) {
                    return Expanded(
                      child: Row(
                        children: List.generate(noteCols, (colIdx) {
                          return _NoteDigit(
                            digit: rowIdx * noteCols + colIdx + 1,
                            notes: cell.notes,
                            fontSize: noteFontSize,
                          );
                        }),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        // Player digit — centred
        if (cell.value != 0)
          Center(
            child: Text(
              '${cell.value}',
              style: TextStyle(
                fontSize: digitFontSize,
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

    if (cell.isSelected) {
      content = content.animate(onPlay: (c) => c.repeat(reverse: true)).scale(
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
        // No border on individual cells — cage outlines are painted by
        // _CageBorderPainter so they never double-draw or mis-align.
        color: _bgColor(GameColors.of(context)),
        child: content,
      ),
    );
  }
}

class _NoteDigit extends StatelessWidget {
  final int digit;
  final List<int> notes;
  final double fontSize;

  const _NoteDigit({
    required this.digit,
    required this.notes,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    final visible = notes.contains(digit);
    return Expanded(
      child: Center(
        child: Text(
          visible ? '$digit' : '',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey.shade700,
          ),
        ),
      ),
    );
  }
}
