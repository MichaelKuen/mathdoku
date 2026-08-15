// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameState {
  Board? get board => throw _privateConstructorUsedError;
  GameStatus get status => throw _privateConstructorUsedError;
  Difficulty get difficulty => throw _privateConstructorUsedError;
  int get elapsedSeconds => throw _privateConstructorUsedError;
  int get playSecondsThisSegment => throw _privateConstructorUsedError;
  int get mistakes => throw _privateConstructorUsedError;
  int? get selectedRow => throw _privateConstructorUsedError;
  int? get selectedCol => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call(
      {Board? board,
      GameStatus status,
      Difficulty difficulty,
      int elapsedSeconds,
      int playSecondsThisSegment,
      int mistakes,
      int? selectedRow,
      int? selectedCol});

  $BoardCopyWith<$Res>? get board;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = freezed,
    Object? status = null,
    Object? difficulty = null,
    Object? elapsedSeconds = null,
    Object? playSecondsThisSegment = null,
    Object? mistakes = null,
    Object? selectedRow = freezed,
    Object? selectedCol = freezed,
  }) {
    return _then(_value.copyWith(
      board: freezed == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as Board?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GameStatus,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as Difficulty,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      playSecondsThisSegment: null == playSecondsThisSegment
          ? _value.playSecondsThisSegment
          : playSecondsThisSegment // ignore: cast_nullable_to_non_nullable
              as int,
      mistakes: null == mistakes
          ? _value.mistakes
          : mistakes // ignore: cast_nullable_to_non_nullable
              as int,
      selectedRow: freezed == selectedRow
          ? _value.selectedRow
          : selectedRow // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedCol: freezed == selectedCol
          ? _value.selectedCol
          : selectedCol // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoardCopyWith<$Res>? get board {
    if (_value.board == null) {
      return null;
    }

    return $BoardCopyWith<$Res>(_value.board!, (value) {
      return _then(_value.copyWith(board: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
          _$GameStateImpl value, $Res Function(_$GameStateImpl) then) =
      __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Board? board,
      GameStatus status,
      Difficulty difficulty,
      int elapsedSeconds,
      int playSecondsThisSegment,
      int mistakes,
      int? selectedRow,
      int? selectedCol});

  @override
  $BoardCopyWith<$Res>? get board;
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
      _$GameStateImpl _value, $Res Function(_$GameStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = freezed,
    Object? status = null,
    Object? difficulty = null,
    Object? elapsedSeconds = null,
    Object? playSecondsThisSegment = null,
    Object? mistakes = null,
    Object? selectedRow = freezed,
    Object? selectedCol = freezed,
  }) {
    return _then(_$GameStateImpl(
      board: freezed == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as Board?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as GameStatus,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as Difficulty,
      elapsedSeconds: null == elapsedSeconds
          ? _value.elapsedSeconds
          : elapsedSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      playSecondsThisSegment: null == playSecondsThisSegment
          ? _value.playSecondsThisSegment
          : playSecondsThisSegment // ignore: cast_nullable_to_non_nullable
              as int,
      mistakes: null == mistakes
          ? _value.mistakes
          : mistakes // ignore: cast_nullable_to_non_nullable
              as int,
      selectedRow: freezed == selectedRow
          ? _value.selectedRow
          : selectedRow // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedCol: freezed == selectedCol
          ? _value.selectedCol
          : selectedCol // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$GameStateImpl implements _GameState {
  const _$GameStateImpl(
      {this.board,
      this.status = GameStatus.initial,
      this.difficulty = Difficulty.easy,
      this.elapsedSeconds = 0,
      this.playSecondsThisSegment = 0,
      this.mistakes = 0,
      this.selectedRow,
      this.selectedCol});

  @override
  final Board? board;
  @override
  @JsonKey()
  final GameStatus status;
  @override
  @JsonKey()
  final Difficulty difficulty;
  @override
  @JsonKey()
  final int elapsedSeconds;
  @override
  @JsonKey()
  final int playSecondsThisSegment;
  @override
  @JsonKey()
  final int mistakes;
  @override
  final int? selectedRow;
  @override
  final int? selectedCol;

  @override
  String toString() {
    return 'GameState(board: $board, status: $status, difficulty: $difficulty, elapsedSeconds: $elapsedSeconds, playSecondsThisSegment: $playSecondsThisSegment, mistakes: $mistakes, selectedRow: $selectedRow, selectedCol: $selectedCol)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.elapsedSeconds, elapsedSeconds) ||
                other.elapsedSeconds == elapsedSeconds) &&
            (identical(other.playSecondsThisSegment, playSecondsThisSegment) ||
                other.playSecondsThisSegment == playSecondsThisSegment) &&
            (identical(other.mistakes, mistakes) ||
                other.mistakes == mistakes) &&
            (identical(other.selectedRow, selectedRow) ||
                other.selectedRow == selectedRow) &&
            (identical(other.selectedCol, selectedCol) ||
                other.selectedCol == selectedCol));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      board,
      status,
      difficulty,
      elapsedSeconds,
      playSecondsThisSegment,
      mistakes,
      selectedRow,
      selectedCol);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState implements GameState {
  const factory _GameState(
      {final Board? board,
      final GameStatus status,
      final Difficulty difficulty,
      final int elapsedSeconds,
      final int playSecondsThisSegment,
      final int mistakes,
      final int? selectedRow,
      final int? selectedCol}) = _$GameStateImpl;

  @override
  Board? get board;
  @override
  GameStatus get status;
  @override
  Difficulty get difficulty;
  @override
  int get elapsedSeconds;
  @override
  int get playSecondsThisSegment;
  @override
  int get mistakes;
  @override
  int? get selectedRow;
  @override
  int? get selectedCol;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
