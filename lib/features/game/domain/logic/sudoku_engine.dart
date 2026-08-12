// Copyright © App Verse Games. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import '../models/board.dart';
import '../models/cell.dart';

enum GroupStatus { incomplete, correct, incorrect }

class SudokuEngine {
  /// Validates if the entire board is valid according to Sudoku rules.
  bool isValid(Board board) {
    // Check rows
    for (int r = 0; r < 9; r++) {
      if (checkGroupStatus(board.cells[r]) == GroupStatus.incorrect) return false;
    }

    // Check columns
    for (int c = 0; c < 9; c++) {
      List<Cell> column = [];
      for (int r = 0; r < 9; r++) {
        column.add(board.cells[r][c]);
      }
      if (checkGroupStatus(column) == GroupStatus.incorrect) return false;
    }

    // Check 3x3 squares
    for (int rowBlock = 0; rowBlock < 3; rowBlock++) {
      for (int colBlock = 0; colBlock < 3; colBlock++) {
        List<Cell> block = getBlock(board, rowBlock, colBlock);
        if (checkGroupStatus(block) == GroupStatus.incorrect) return false;
      }
    }

    return true;
  }

  List<Cell> getBlock(Board board, int rowBlock, int colBlock) {
    List<Cell> block = [];
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        block.add(board.cells[rowBlock * 3 + r][colBlock * 3 + c]);
      }
    }
    return block;
  }

  GroupStatus checkGroupStatus(List<Cell> group) {
    bool isFull = true;
    Set<int> values = {};
    bool hasDuplicate = false;

    for (var cell in group) {
      if (cell.value == 0) {
        isFull = false;
      } else {
        if (values.contains(cell.value)) {
          hasDuplicate = true;
        }
        values.add(cell.value);
      }
    }

    if (hasDuplicate) return GroupStatus.incorrect;
    if (!isFull) return GroupStatus.incomplete;
    return GroupStatus.correct;
  }

  /// Checks if a specific value can be placed at [row], [col] without violating rules.
  bool canPlace(Board board, int row, int col, int value) {
    if (value == 0) return true;

    // Check row
    for (int c = 0; c < 9; c++) {
      if (c != col && board.cells[row][c].value == value) return false;
    }

    // Check column
    for (int r = 0; r < 9; r++) {
      if (r != row && board.cells[r][col].value == value) return false;
    }

    // Check 3x3 square
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int r = startRow; r < startRow + 3; r++) {
      for (int c = startCol; c < startCol + 3; c++) {
        if ((r != row || c != col) && board.cells[r][c].value == value) return false;
      }
    }

    return true;
  }
}
