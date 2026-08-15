// Copyright © App Verse Games. All rights reserved.
import 'package:freezed_annotation/freezed_annotation.dart';
import 'board.dart';

part 'game_state.freezed.dart';

enum GameStatus { initial, loading, playing, won, breakTime }
enum Difficulty { easy, medium }

@freezed
class GameState with _$GameState {
  const factory GameState({
    Board? board,
    @Default(GameStatus.initial) GameStatus status,
    @Default(Difficulty.easy) Difficulty difficulty,
    @Default(0) int elapsedSeconds,
    @Default(0) int playSecondsThisSegment,
    @Default(0) int mistakes,
    int? selectedRow,
    int? selectedCol,
    @Default(false) bool isPencilMode,
  }) = _GameState;
}
