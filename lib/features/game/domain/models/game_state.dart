// Copyright © App Verse Games. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'board.dart';

part 'game_state.freezed.dart';

enum GameStatus { initial, loading, playing, won, paused }
enum Difficulty { easy, medium, hard }

@freezed
class GameState with _$GameState {
  const factory GameState({
    Board? board,
    @Default(GameStatus.initial) GameStatus status,
    @Default(Difficulty.easy) Difficulty difficulty,
    @Default(0) int elapsedSeconds,
    @Default(0) int mistakes,
    @Default(3) int maxMistakes,
    @Default(3) int hintsRemaining,
    @Default(false) bool isPencilMode,
    int? selectedRow,
    int? selectedCol,
  }) = _GameState;
}
