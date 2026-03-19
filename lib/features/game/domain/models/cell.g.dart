// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CellImpl _$$CellImplFromJson(Map<String, dynamic> json) => _$CellImpl(
  value: (json['value'] as num).toInt(),
  row: (json['row'] as num).toInt(),
  col: (json['col'] as num).toInt(),
  isFixed: json['isFixed'] as bool? ?? false,
  isSelected: json['isSelected'] as bool? ?? false,
  isHighlighted: json['isHighlighted'] as bool? ?? false,
  isSameNumber: json['isSameNumber'] as bool? ?? false,
  isError: json['isError'] as bool? ?? false,
  blockStatus:
      $enumDecodeNullable(_$CellStatusEnumMap, json['blockStatus']) ??
      CellStatus.normal,
  rowStatus:
      $enumDecodeNullable(_$CellStatusEnumMap, json['rowStatus']) ??
      CellStatus.normal,
  colStatus:
      $enumDecodeNullable(_$CellStatusEnumMap, json['colStatus']) ??
      CellStatus.normal,
  notes:
      (json['notes'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toSet() ??
      const {},
);

Map<String, dynamic> _$$CellImplToJson(_$CellImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'row': instance.row,
      'col': instance.col,
      'isFixed': instance.isFixed,
      'isSelected': instance.isSelected,
      'isHighlighted': instance.isHighlighted,
      'isSameNumber': instance.isSameNumber,
      'isError': instance.isError,
      'blockStatus': _$CellStatusEnumMap[instance.blockStatus]!,
      'rowStatus': _$CellStatusEnumMap[instance.rowStatus]!,
      'colStatus': _$CellStatusEnumMap[instance.colStatus]!,
      'notes': instance.notes.toList(),
    };

const _$CellStatusEnumMap = {
  CellStatus.normal: 'normal',
  CellStatus.correct: 'correct',
  CellStatus.incorrect: 'incorrect',
};
