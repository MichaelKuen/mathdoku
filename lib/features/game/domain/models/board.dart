// Copyright © App Verse Games. All rights reserved.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'cage.dart';
import 'cell.dart';

part 'board.freezed.dart';

@freezed
class Board with _$Board {
  const factory Board({
    required List<List<Cell>> cells,
    required List<List<int>> solution,
    required List<Cage> cages,
  }) = _Board;

  const Board._();

  int get size => cells.length;

  Cell getCell(int row, int col) => cells[row][col];
  int getSolutionValue(int row, int col) => solution[row][col];

  bool get isComplete {
    for (final row in cells) {
      for (final cell in row) {
        if (cell.value == 0 || cell.isError) return false;
      }
    }
    return true;
  }
}
