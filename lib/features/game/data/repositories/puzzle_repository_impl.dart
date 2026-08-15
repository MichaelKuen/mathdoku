// Copyright © App Verse Games. All rights reserved.
import '../../domain/models/board.dart';
import '../../domain/models/game_state.dart';
import '../../domain/repositories/puzzle_repository.dart';
import '../../domain/logic/mathdoku_generator.dart';

class PuzzleRepositoryImpl implements PuzzleRepository {
  final _generator = MathdokuGenerator();

  @override
  Board generatePuzzle(Difficulty difficulty) => _generator.generate(difficulty);
}
