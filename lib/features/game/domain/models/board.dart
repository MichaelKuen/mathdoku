// Copyright © FullStackShack. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'cell.dart';

part 'board.freezed.dart';

@freezed
class Board with _$Board {
  const factory Board({
    required List<List<Cell>> cells,
    required List<List<int>> solution,
  }) = _Board;

  const Board._();

  Cell getCell(int row, int col) => cells[row][col];
  int getSolutionValue(int row, int col) => solution[row][col];
  
  bool get isComplete {
    for (var row in cells) {
      for (var cell in row) {
        if (cell.value == 0 || cell.isError) return false;
      }
    }
    return true;
  }
}
