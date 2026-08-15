// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Board {
  List<List<Cell>> get cells => throw _privateConstructorUsedError;
  List<List<int>> get solution => throw _privateConstructorUsedError;
  List<Cage> get cages => throw _privateConstructorUsedError;

  /// Create a copy of Board
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoardCopyWith<Board> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardCopyWith<$Res> {
  factory $BoardCopyWith(Board value, $Res Function(Board) then) =
      _$BoardCopyWithImpl<$Res, Board>;
  @useResult
  $Res call(
      {List<List<Cell>> cells, List<List<int>> solution, List<Cage> cages});
}

/// @nodoc
class _$BoardCopyWithImpl<$Res, $Val extends Board>
    implements $BoardCopyWith<$Res> {
  _$BoardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Board
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cells = null,
    Object? solution = null,
    Object? cages = null,
  }) {
    return _then(_value.copyWith(
      cells: null == cells
          ? _value.cells
          : cells // ignore: cast_nullable_to_non_nullable
              as List<List<Cell>>,
      solution: null == solution
          ? _value.solution
          : solution // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      cages: null == cages
          ? _value.cages
          : cages // ignore: cast_nullable_to_non_nullable
              as List<Cage>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoardImplCopyWith<$Res> implements $BoardCopyWith<$Res> {
  factory _$$BoardImplCopyWith(
          _$BoardImpl value, $Res Function(_$BoardImpl) then) =
      __$$BoardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<List<Cell>> cells, List<List<int>> solution, List<Cage> cages});
}

/// @nodoc
class __$$BoardImplCopyWithImpl<$Res>
    extends _$BoardCopyWithImpl<$Res, _$BoardImpl>
    implements _$$BoardImplCopyWith<$Res> {
  __$$BoardImplCopyWithImpl(
      _$BoardImpl _value, $Res Function(_$BoardImpl) _then)
      : super(_value, _then);

  /// Create a copy of Board
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cells = null,
    Object? solution = null,
    Object? cages = null,
  }) {
    return _then(_$BoardImpl(
      cells: null == cells
          ? _value._cells
          : cells // ignore: cast_nullable_to_non_nullable
              as List<List<Cell>>,
      solution: null == solution
          ? _value._solution
          : solution // ignore: cast_nullable_to_non_nullable
              as List<List<int>>,
      cages: null == cages
          ? _value._cages
          : cages // ignore: cast_nullable_to_non_nullable
              as List<Cage>,
    ));
  }
}

/// @nodoc

class _$BoardImpl extends _Board {
  const _$BoardImpl(
      {required final List<List<Cell>> cells,
      required final List<List<int>> solution,
      required final List<Cage> cages})
      : _cells = cells,
        _solution = solution,
        _cages = cages,
        super._();

  final List<List<Cell>> _cells;
  @override
  List<List<Cell>> get cells {
    if (_cells is EqualUnmodifiableListView) return _cells;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cells);
  }

  final List<List<int>> _solution;
  @override
  List<List<int>> get solution {
    if (_solution is EqualUnmodifiableListView) return _solution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_solution);
  }

  final List<Cage> _cages;
  @override
  List<Cage> get cages {
    if (_cages is EqualUnmodifiableListView) return _cages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cages);
  }

  @override
  String toString() {
    return 'Board(cells: $cells, solution: $solution, cages: $cages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardImpl &&
            const DeepCollectionEquality().equals(other._cells, _cells) &&
            const DeepCollectionEquality().equals(other._solution, _solution) &&
            const DeepCollectionEquality().equals(other._cages, _cages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_cells),
      const DeepCollectionEquality().hash(_solution),
      const DeepCollectionEquality().hash(_cages));

  /// Create a copy of Board
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardImplCopyWith<_$BoardImpl> get copyWith =>
      __$$BoardImplCopyWithImpl<_$BoardImpl>(this, _$identity);
}

abstract class _Board extends Board {
  const factory _Board(
      {required final List<List<Cell>> cells,
      required final List<List<int>> solution,
      required final List<Cage> cages}) = _$BoardImpl;
  const _Board._() : super._();

  @override
  List<List<Cell>> get cells;
  @override
  List<List<int>> get solution;
  @override
  List<Cage> get cages;

  /// Create a copy of Board
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoardImplCopyWith<_$BoardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
