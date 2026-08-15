// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CagePos _$CagePosFromJson(Map<String, dynamic> json) {
  return _CagePos.fromJson(json);
}

/// @nodoc
mixin _$CagePos {
  int get row => throw _privateConstructorUsedError;
  int get col => throw _privateConstructorUsedError;

  /// Serializes this CagePos to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CagePos
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CagePosCopyWith<CagePos> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CagePosCopyWith<$Res> {
  factory $CagePosCopyWith(CagePos value, $Res Function(CagePos) then) =
      _$CagePosCopyWithImpl<$Res, CagePos>;
  @useResult
  $Res call({int row, int col});
}

/// @nodoc
class _$CagePosCopyWithImpl<$Res, $Val extends CagePos>
    implements $CagePosCopyWith<$Res> {
  _$CagePosCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CagePos
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? row = null,
    Object? col = null,
  }) {
    return _then(_value.copyWith(
      row: null == row
          ? _value.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
      col: null == col
          ? _value.col
          : col // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CagePosImplCopyWith<$Res> implements $CagePosCopyWith<$Res> {
  factory _$$CagePosImplCopyWith(
          _$CagePosImpl value, $Res Function(_$CagePosImpl) then) =
      __$$CagePosImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int row, int col});
}

/// @nodoc
class __$$CagePosImplCopyWithImpl<$Res>
    extends _$CagePosCopyWithImpl<$Res, _$CagePosImpl>
    implements _$$CagePosImplCopyWith<$Res> {
  __$$CagePosImplCopyWithImpl(
      _$CagePosImpl _value, $Res Function(_$CagePosImpl) _then)
      : super(_value, _then);

  /// Create a copy of CagePos
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? row = null,
    Object? col = null,
  }) {
    return _then(_$CagePosImpl(
      row: null == row
          ? _value.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
      col: null == col
          ? _value.col
          : col // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CagePosImpl implements _CagePos {
  const _$CagePosImpl({required this.row, required this.col});

  factory _$CagePosImpl.fromJson(Map<String, dynamic> json) =>
      _$$CagePosImplFromJson(json);

  @override
  final int row;
  @override
  final int col;

  @override
  String toString() {
    return 'CagePos(row: $row, col: $col)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CagePosImpl &&
            (identical(other.row, row) || other.row == row) &&
            (identical(other.col, col) || other.col == col));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, row, col);

  /// Create a copy of CagePos
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CagePosImplCopyWith<_$CagePosImpl> get copyWith =>
      __$$CagePosImplCopyWithImpl<_$CagePosImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CagePosImplToJson(
      this,
    );
  }
}

abstract class _CagePos implements CagePos {
  const factory _CagePos({required final int row, required final int col}) =
      _$CagePosImpl;

  factory _CagePos.fromJson(Map<String, dynamic> json) = _$CagePosImpl.fromJson;

  @override
  int get row;
  @override
  int get col;

  /// Create a copy of CagePos
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CagePosImplCopyWith<_$CagePosImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Cage _$CageFromJson(Map<String, dynamic> json) {
  return _Cage.fromJson(json);
}

/// @nodoc
mixin _$Cage {
  int get id => throw _privateConstructorUsedError;
  List<CagePos> get cells => throw _privateConstructorUsedError;
  Operation get operation => throw _privateConstructorUsedError;
  int get target => throw _privateConstructorUsedError;

  /// Serializes this Cage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CageCopyWith<Cage> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CageCopyWith<$Res> {
  factory $CageCopyWith(Cage value, $Res Function(Cage) then) =
      _$CageCopyWithImpl<$Res, Cage>;
  @useResult
  $Res call({int id, List<CagePos> cells, Operation operation, int target});
}

/// @nodoc
class _$CageCopyWithImpl<$Res, $Val extends Cage>
    implements $CageCopyWith<$Res> {
  _$CageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cells = null,
    Object? operation = null,
    Object? target = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      cells: null == cells
          ? _value.cells
          : cells // ignore: cast_nullable_to_non_nullable
              as List<CagePos>,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as Operation,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CageImplCopyWith<$Res> implements $CageCopyWith<$Res> {
  factory _$$CageImplCopyWith(
          _$CageImpl value, $Res Function(_$CageImpl) then) =
      __$$CageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, List<CagePos> cells, Operation operation, int target});
}

/// @nodoc
class __$$CageImplCopyWithImpl<$Res>
    extends _$CageCopyWithImpl<$Res, _$CageImpl>
    implements _$$CageImplCopyWith<$Res> {
  __$$CageImplCopyWithImpl(_$CageImpl _value, $Res Function(_$CageImpl) _then)
      : super(_value, _then);

  /// Create a copy of Cage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? cells = null,
    Object? operation = null,
    Object? target = null,
  }) {
    return _then(_$CageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      cells: null == cells
          ? _value._cells
          : cells // ignore: cast_nullable_to_non_nullable
              as List<CagePos>,
      operation: null == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as Operation,
      target: null == target
          ? _value.target
          : target // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CageImpl implements _Cage {
  const _$CageImpl(
      {required this.id,
      required final List<CagePos> cells,
      required this.operation,
      required this.target})
      : _cells = cells;

  factory _$CageImpl.fromJson(Map<String, dynamic> json) =>
      _$$CageImplFromJson(json);

  @override
  final int id;
  final List<CagePos> _cells;
  @override
  List<CagePos> get cells {
    if (_cells is EqualUnmodifiableListView) return _cells;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cells);
  }

  @override
  final Operation operation;
  @override
  final int target;

  @override
  String toString() {
    return 'Cage(id: $id, cells: $cells, operation: $operation, target: $target)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CageImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._cells, _cells) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.target, target) || other.target == target));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id,
      const DeepCollectionEquality().hash(_cells), operation, target);

  /// Create a copy of Cage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CageImplCopyWith<_$CageImpl> get copyWith =>
      __$$CageImplCopyWithImpl<_$CageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CageImplToJson(
      this,
    );
  }
}

abstract class _Cage implements Cage {
  const factory _Cage(
      {required final int id,
      required final List<CagePos> cells,
      required final Operation operation,
      required final int target}) = _$CageImpl;

  factory _Cage.fromJson(Map<String, dynamic> json) = _$CageImpl.fromJson;

  @override
  int get id;
  @override
  List<CagePos> get cells;
  @override
  Operation get operation;
  @override
  int get target;

  /// Create a copy of Cage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CageImplCopyWith<_$CageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
