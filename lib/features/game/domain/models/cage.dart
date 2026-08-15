// Copyright © App Verse Games. All rights reserved.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cage.freezed.dart';
part 'cage.g.dart';

enum Operation { add, subtract, multiply, divide, given }

@freezed
class CagePos with _$CagePos {
  const factory CagePos({required int row, required int col}) = _CagePos;
  factory CagePos.fromJson(Map<String, dynamic> json) => _$CagePosFromJson(json);
}

@freezed
class Cage with _$Cage {
  const factory Cage({
    required int id,
    required List<CagePos> cells,
    required Operation operation,
    required int target,
  }) = _Cage;
  factory Cage.fromJson(Map<String, dynamic> json) => _$CageFromJson(json);
}
