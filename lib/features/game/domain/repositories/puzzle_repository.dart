// Copyright © App Verse Games. All rights reserved.
import '../models/board.dart';
import '../models/game_state.dart';

abstract interface class PuzzleRepository {
  Board generatePuzzle(Difficulty difficulty);
}
