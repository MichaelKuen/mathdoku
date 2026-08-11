// Copyright © FullStackShack. All rights reserved.
// Unauthorised use, reproduction, or distribution is strictly prohibited.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cell.freezed.dart';
part 'cell.g.dart';

enum CellStatus { normal, correct, incorrect }

@freezed
class Cell with _$Cell {
  const factory Cell({
    required int value,
    required int row,
    required int col,
    @Default(false) bool isFixed,
    @Default(false) bool isSelected,
    @Default(false) bool isHighlighted,
    @Default(false) bool isSameNumber,
    @Default(false) bool isError,
    @Default(CellStatus.normal) CellStatus blockStatus,
    @Default(CellStatus.normal) CellStatus rowStatus,
    @Default(CellStatus.normal) CellStatus colStatus,
    @Default({}) Set<int> notes,
  }) = _Cell;

  factory Cell.fromJson(Map<String, dynamic> json) => _$CellFromJson(json);
}
