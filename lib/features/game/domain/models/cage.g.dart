// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CagePosImpl _$$CagePosImplFromJson(Map<String, dynamic> json) =>
    _$CagePosImpl(
      row: (json['row'] as num).toInt(),
      col: (json['col'] as num).toInt(),
    );

Map<String, dynamic> _$$CagePosImplToJson(_$CagePosImpl instance) =>
    <String, dynamic>{
      'row': instance.row,
      'col': instance.col,
    };

_$CageImpl _$$CageImplFromJson(Map<String, dynamic> json) => _$CageImpl(
      id: (json['id'] as num).toInt(),
      cells: (json['cells'] as List<dynamic>)
          .map((e) => CagePos.fromJson(e as Map<String, dynamic>))
          .toList(),
      operation: $enumDecode(_$OperationEnumMap, json['operation']),
      target: (json['target'] as num).toInt(),
    );

Map<String, dynamic> _$$CageImplToJson(_$CageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cells': instance.cells,
      'operation': _$OperationEnumMap[instance.operation]!,
      'target': instance.target,
    };

const _$OperationEnumMap = {
  Operation.add: 'add',
  Operation.subtract: 'subtract',
  Operation.multiply: 'multiply',
  Operation.divide: 'divide',
  Operation.given: 'given',
};
