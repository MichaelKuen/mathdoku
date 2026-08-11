// Copyright © FullStackShack. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import 'dart:math';
import '../models/board.dart';
import '../models/cell.dart';
import '../models/game_state.dart';

class SudokuGenerator {
  final _random = Random();

  Board generate(Difficulty difficulty) {
    // 1. Start with an empty 9x9 grid
    List<List<int>> solution = List.generate(9, (_) => List.generate(9, (_) => 0));
    
    // 2. Fill the diagonal 3x3 blocks (they are independent)
    _fillDiagonal(solution);
    
    // 3. Fill the rest of the board using backtracking
    _solve(solution);
    
    // 4. Create a copy for the playable grid
    List<List<int>> grid = solution.map((row) => List<int>.from(row)).toList();
    
    // 5. Remove numbers based on difficulty
    int attempts = _getAttempts(difficulty);
    _removeDigits(grid, attempts);

    // 6. Convert to Board model
    List<List<Cell>> cells = List.generate(9, (r) {
      return List.generate(9, (c) {
        int value = grid[r][c];
        return Cell(
          value: value,
          row: r,
          col: c,
          isFixed: value != 0,
        );
      });
    });

    return Board(cells: cells, solution: solution);
  }

  void _fillDiagonal(List<List<int>> board) {
    for (int i = 0; i < 9; i += 3) {
      _fillBox(board, i, i);
    }
  }

  void _fillBox(List<List<int>> board, int row, int col) {
    List<int> nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle(_random);
    int idx = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        board[row + i][col + j] = nums[idx++];
      }
    }
  }

  bool _solve(List<List<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          List<int> nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle(_random);
          for (int num in nums) {
            if (_isSafe(board, row, col, num)) {
              board[row][col] = num;
              if (_solve(board)) return true;
              board[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  bool _isSafe(List<List<int>> board, int row, int col, int num) {
    for (int x = 0; x < 9; x++) {
      if (board[row][x] == num || board[x][col] == num) return false;
    }
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i + startRow][j + startCol] == num) return false;
      }
    }
    return true;
  }

  void _removeDigits(List<List<int>> board, int count) {
    int removed = 0;
    while (removed < count) {
      int cellId = _random.nextInt(81);
      int r = cellId ~/ 9;
      int c = cellId % 9;
      if (board[r][c] != 0) {
        board[r][c] = 0;
        removed++;
      }
    }
  }

  int _getAttempts(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy: return 30;
      case Difficulty.medium: return 45;
      case Difficulty.hard: return 55;
    }
  }
}
