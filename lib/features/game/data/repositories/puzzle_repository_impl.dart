import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../domain/models/board.dart';
import '../../domain/models/cell.dart';
import '../../domain/models/game_state.dart';
import '../../domain/repositories/puzzle_repository.dart';

class PuzzleRepositoryImpl implements PuzzleRepository {
  @override
  Future<Board> getPuzzle(Difficulty difficulty) async {
    final String path = 'assets/puzzles/${difficulty.name}.json';
    final String response = await rootBundle.loadString(path);
    final List<dynamic> data = json.decode(response);
    
    final random = Random();
    final puzzleData = data[random.nextInt(data.length)];
    final List<List<dynamic>> grid = List<List<dynamic>>.from(puzzleData['grid']);
    final List<List<dynamic>> solutionData = List<List<dynamic>>.from(puzzleData['solution']);

    List<List<int>> solution = solutionData.map((row) => row.cast<int>()).toList();

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
}
