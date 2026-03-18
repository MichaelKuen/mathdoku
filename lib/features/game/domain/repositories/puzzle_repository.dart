import '../models/board.dart';
import '../models/game_state.dart';

abstract class PuzzleRepository {
  Future<Board> getPuzzle(Difficulty difficulty);
}
