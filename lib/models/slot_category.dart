import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot_category.freezed.dart';
part 'slot_category.g.dart';

/// Kind of slot (枠タイプ). Names must be unique within a document.
@freezed
abstract class SlotCategory with _$SlotCategory {
  const factory SlotCategory({
    required String id,
    required String name,
    required int durationMinutes,
    required bool isPerformanceSlot,
  }) = _SlotCategory;

  factory SlotCategory.fromJson(Map<String, dynamic> json) =>
      _$SlotCategoryFromJson(json);
}
