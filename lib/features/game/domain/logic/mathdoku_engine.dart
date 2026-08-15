// Copyright © App Verse Games. All rights reserved.
import '../models/board.dart';
import '../models/cage.dart';
import '../models/cell.dart';

enum GroupStatus { incomplete, correct, incorrect }

class MathdokuEngine {
  GroupStatus checkGroupStatus(List<Cell> group) {
    bool isFull = true;
    final seen = <int>{};
    bool hasDuplicate = false;

    for (final cell in group) {
      if (cell.value == 0) {
        isFull = false;
      } else {
        if (seen.contains(cell.value)) hasDuplicate = true;
        seen.add(cell.value);
      }
    }

    if (hasDuplicate) return GroupStatus.incorrect;
    if (!isFull) return GroupStatus.incomplete;
    return GroupStatus.correct;
  }

  bool isCageSatisfied(Cage cage, Board board) {
    final values =
        cage.cells.map((p) => board.getCell(p.row, p.col).value).toList();
    if (values.any((v) => v == 0)) return false;

    switch (cage.operation) {
      case Operation.given:
        return values.single == cage.target;
      case Operation.add:
        return values.fold(0, (a, b) => a + b) == cage.target;
      case Operation.subtract:
        final sorted = [...values]..sort();
        return sorted.last - sorted.first == cage.target;
      case Operation.multiply:
        return values.fold(1, (a, b) => a * b) == cage.target;
      case Operation.divide:
        final sorted = [...values]..sort();
        final lo = sorted.first;
        final hi = sorted.last;
        return lo != 0 && hi % lo == 0 && hi ~/ lo == cage.target;
    }
  }

  CellStatus cageStatusForCell(Cage cage, Board board) {
    final values =
        cage.cells.map((p) => board.getCell(p.row, p.col).value).toList();
    if (values.any((v) => v == 0)) return CellStatus.normal;
    return isCageSatisfied(cage, board) ? CellStatus.correct : CellStatus.incorrect;
  }

  bool isValid(Board board) {
    for (int r = 0; r < board.size; r++) {
      if (checkGroupStatus(board.cells[r]) == GroupStatus.incorrect) return false;
    }
    for (int c = 0; c < board.size; c++) {
      final col = [for (int r = 0; r < board.size; r++) board.cells[r][c]];
      if (checkGroupStatus(col) == GroupStatus.incorrect) return false;
    }
    return true;
  }
}
