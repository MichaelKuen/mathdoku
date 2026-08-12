// Copyright © App Verse Games. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import '../models/board.dart';
import '../models/game_state.dart';

abstract class PuzzleRepository {
  Future<Board> getPuzzle(Difficulty difficulty);
}
