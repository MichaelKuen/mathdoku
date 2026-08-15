// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Cell _$CellFromJson(Map<String, dynamic> json) {
  return _Cell.fromJson(json);
}

/// @nodoc
mixin _$Cell {
  int get value => throw _privateConstructorUsedError;
  int get row => throw _privateConstructorUsedError;
  int get col => throw _privateConstructorUsedError;
  int get cageId => throw _privateConstructorUsedError;
  bool get isFixed => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;
  bool get isHighlighted => throw _privateConstructorUsedError;
  bool get isSameNumber => throw _privateConstructorUsedError;
  bool get isError => throw _privateConstructorUsedError;
  bool get showClue => throw _privateConstructorUsedError;
  String get clueText => throw _privateConstructorUsedError;
  CellStatus get cageStatus => throw _privateConstructorUsedError;
  CellStatus get rowStatus => throw _privateConstructorUsedError;
  CellStatus get colStatus => throw _privateConstructorUsedError;

  /// Serializes this Cell to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CellCopyWith<Cell> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CellCopyWith<$Res> {
  factory $CellCopyWith(Cell value, $Res Function(Cell) then) =
      _$CellCopyWithImpl<$Res, Cell>;
  @useResult
  $Res call(
      {int value,
      int row,
      int col,
      int cageId,
      bool isFixed,
      bool isSelected,
      bool isHighlighted,
      bool isSameNumber,
      bool isError,
      bool showClue,
      String clueText,
      CellStatus cageStatus,
      CellStatus rowStatus,
      CellStatus colStatus});
}

/// @nodoc
class _$CellCopyWithImpl<$Res, $Val extends Cell>
    implements $CellCopyWith<$Res> {
  _$CellCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? row = null,
    Object? col = null,
    Object? cageId = null,
    Object? isFixed = null,
    Object? isSelected = null,
    Object? isHighlighted = null,
    Object? isSameNumber = null,
    Object? isError = null,
    Object? showClue = null,
    Object? clueText = null,
    Object? cageStatus = null,
    Object? rowStatus = null,
    Object? colStatus = null,
  }) {
    return _then(_value.copyWith(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      row: null == row
          ? _value.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
      col: null == col
          ? _value.col
          : col // ignore: cast_nullable_to_non_nullable
              as int,
      cageId: null == cageId
          ? _value.cageId
          : cageId // ignore: cast_nullable_to_non_nullable
              as int,
      isFixed: null == isFixed
          ? _value.isFixed
          : isFixed // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isHighlighted: null == isHighlighted
          ? _value.isHighlighted
          : isHighlighted // ignore: cast_nullable_to_non_nullable
              as bool,
      isSameNumber: null == isSameNumber
          ? _value.isSameNumber
          : isSameNumber // ignore: cast_nullable_to_non_nullable
              as bool,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      showClue: null == showClue
          ? _value.showClue
          : showClue // ignore: cast_nullable_to_non_nullable
              as bool,
      clueText: null == clueText
          ? _value.clueText
          : clueText // ignore: cast_nullable_to_non_nullable
              as String,
      cageStatus: null == cageStatus
          ? _value.cageStatus
          : cageStatus // ignore: cast_nullable_to_non_nullable
              as CellStatus,
      rowStatus: null == rowStatus
          ? _value.rowStatus
          : rowStatus // ignore: cast_nullable_to_non_nullable
              as CellStatus,
      colStatus: null == colStatus
          ? _value.colStatus
          : colStatus // ignore: cast_nullable_to_non_nullable
              as CellStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CellImplCopyWith<$Res> implements $CellCopyWith<$Res> {
  factory _$$CellImplCopyWith(
          _$CellImpl value, $Res Function(_$CellImpl) then) =
      __$$CellImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int value,
      int row,
      int col,
      int cageId,
      bool isFixed,
      bool isSelected,
      bool isHighlighted,
      bool isSameNumber,
      bool isError,
      bool showClue,
      String clueText,
      CellStatus cageStatus,
      CellStatus rowStatus,
      CellStatus colStatus});
}

/// @nodoc
class __$$CellImplCopyWithImpl<$Res>
    extends _$CellCopyWithImpl<$Res, _$CellImpl>
    implements _$$CellImplCopyWith<$Res> {
  __$$CellImplCopyWithImpl(_$CellImpl _value, $Res Function(_$CellImpl) _then)
      : super(_value, _then);

  /// Create a copy of Cell
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? row = null,
    Object? col = null,
    Object? cageId = null,
    Object? isFixed = null,
    Object? isSelected = null,
    Object? isHighlighted = null,
    Object? isSameNumber = null,
    Object? isError = null,
    Object? showClue = null,
    Object? clueText = null,
    Object? cageStatus = null,
    Object? rowStatus = null,
    Object? colStatus = null,
  }) {
    return _then(_$CellImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      row: null == row
          ? _value.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
      col: null == col
          ? _value.col
          : col // ignore: cast_nullable_to_non_nullable
              as int,
      cageId: null == cageId
          ? _value.cageId
          : cageId // ignore: cast_nullable_to_non_nullable
              as int,
      isFixed: null == isFixed
          ? _value.isFixed
          : isFixed // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
      isHighlighted: null == isHighlighted
          ? _value.isHighlighted
          : isHighlighted // ignore: cast_nullable_to_non_nullable
              as bool,
      isSameNumber: null == isSameNumber
          ? _value.isSameNumber
          : isSameNumber // ignore: cast_nullable_to_non_nullable
              as bool,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      showClue: null == showClue
          ? _value.showClue
          : showClue // ignore: cast_nullable_to_non_nullable
              as bool,
      clueText: null == clueText
          ? _value.clueText
          : clueText // ignore: cast_nullable_to_non_nullable
              as String,
      cageStatus: null == cageStatus
          ? _value.cageStatus
          : cageStatus // ignore: cast_nullable_to_non_nullable
              as CellStatus,
      rowStatus: null == rowStatus
          ? _value.rowStatus
          : rowStatus // ignore: cast_nullable_to_non_nullable
              as CellStatus,
      colStatus: null == colStatus
          ? _value.colStatus
          : colStatus // ignore: cast_nullable_to_non_nullable
              as CellStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CellImpl implements _Cell {
  const _$CellImpl(
      {required this.value,
      required this.row,
      required this.col,
      required this.cageId,
      this.isFixed = false,
      this.isSelected = false,
      this.isHighlighted = false,
      this.isSameNumber = false,
      this.isError = false,
      this.showClue = false,
      this.clueText = '',
      this.cageStatus = CellStatus.normal,
      this.rowStatus = CellStatus.normal,
      this.colStatus = CellStatus.normal});

  factory _$CellImpl.fromJson(Map<String, dynamic> json) =>
      _$$CellImplFromJson(json);

  @override
  final int value;
  @override
  final int row;
  @override
  final int col;
  @override
  final int cageId;
  @override
  @JsonKey()
  final bool isFixed;
  @override
  @JsonKey()
  final bool isSelected;
  @override
  @JsonKey()
  final bool isHighlighted;
  @override
  @JsonKey()
  final bool isSameNumber;
  @override
  @JsonKey()
  final bool isError;
  @override
  @JsonKey()
  final bool showClue;
  @override
  @JsonKey()
  final String clueText;
  @override
  @JsonKey()
  final CellStatus cageStatus;
  @override
  @JsonKey()
  final CellStatus rowStatus;
  @override
  @JsonKey()
  final CellStatus colStatus;

  @override
  String toString() {
    return 'Cell(value: $value, row: $row, col: $col, cageId: $cageId, isFixed: $isFixed, isSelected: $isSelected, isHighlighted: $isHighlighted, isSameNumber: $isSameNumber, isError: $isError, showClue: $showClue, clueText: $clueText, cageStatus: $cageStatus, rowStatus: $rowStatus, colStatus: $colStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CellImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.row, row) || other.row == row) &&
            (identical(other.col, col) || other.col == col) &&
            (identical(other.cageId, cageId) || other.cageId == cageId) &&
            (identical(other.isFixed, isFixed) || other.isFixed == isFixed) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected) &&
            (identical(other.isHighlighted, isHighlighted) ||
                other.isHighlighted == isHighlighted) &&
            (identical(other.isSameNumber, isSameNumber) ||
                other.isSameNumber == isSameNumber) &&
            (identical(other.isError, isError) || other.isError == isError) &&
            (identical(other.showClue, showClue) ||
                other.showClue == showClue) &&
            (identical(other.clueText, clueText) ||
                other.clueText == clueText) &&
            (identical(other.cageStatus, cageStatus) ||
                other.cageStatus == cageStatus) &&
            (identical(other.rowStatus, rowStatus) ||
                other.rowStatus == rowStatus) &&
            (identical(other.colStatus, colStatus) ||
                other.colStatus == colStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      value,
      row,
      col,
      cageId,
      isFixed,
      isSelected,
      isHighlighted,
      isSameNumber,
      isError,
      showClue,
      clueText,
      cageStatus,
      rowStatus,
      colStatus);

  /// Create a copy of Cell
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CellImplCopyWith<_$CellImpl> get copyWith =>
      __$$CellImplCopyWithImpl<_$CellImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CellImplToJson(
      this,
    );
  }
}

abstract class _Cell implements Cell {
  const factory _Cell(
      {required final int value,
      required final int row,
      required final int col,
      required final int cageId,
      final bool isFixed,
      final bool isSelected,
      final bool isHighlighted,
      final bool isSameNumber,
      final bool isError,
      final bool showClue,
      final String clueText,
      final CellStatus cageStatus,
      final CellStatus rowStatus,
      final CellStatus colStatus}) = _$CellImpl;

  factory _Cell.fromJson(Map<String, dynamic> json) = _$CellImpl.fromJson;

  @override
  int get value;
  @override
  int get row;
  @override
  int get col;
  @override
  int get cageId;
  @override
  bool get isFixed;
  @override
  bool get isSelected;
  @override
  bool get isHighlighted;
  @override
  bool get isSameNumber;
  @override
  bool get isError;
  @override
  bool get showClue;
  @override
  String get clueText;
  @override
  CellStatus get cageStatus;
  @override
  CellStatus get rowStatus;
  @override
  CellStatus get colStatus;

  /// Create a copy of Cell
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CellImplCopyWith<_$CellImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
