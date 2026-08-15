import 'package:freezed_annotation/freezed_annotation.dart';

import 'participant.dart';
import 'placed_slot.dart';
import 'slot.dart';
import 'slot_category.dart';
import 'timeline_time.dart';

part 'timeline.freezed.dart';
part 'timeline.g.dart';

/// Ordered, non-overlapping sequence of slots (e.g. a venue or a day).
///
/// End time is not stored; it is derived from the last slot. Crossing calendar
/// dates is not supported — use hours past 24 or another timeline instead.
/// A timeline must always contain at least one slot.
@freezed
abstract class Timeline with _$Timeline {
  const Timeline._();

  const factory Timeline({
    required String id,
    required String name,
    @TimelineTimeConverter() required TimelineTime startTime,
    required List<Slot> slots,
  }) = _Timeline;

  factory Timeline.fromJson(Map<String, dynamic> json) =>
      _$TimelineFromJson(json);

  /// Resolves each slot's category, participant, and stacked start/end times.
  List<PlacedSlot> placedSlots({
    required List<SlotCategory> categories,
    List<Participant> participants = const [],
  }) {
    final categoriesById = {for (final category in categories) category.id: category};
    final participantsById = {
      for (final participant in participants) participant.id: participant,
    };

    var current = startTime;
    var performanceCount = 0;
    final placed = <PlacedSlot>[];

    for (var index = 0; index < slots.length; index++) {
      final slot = slots[index];
      final category = categoriesById[slot.categoryId];
      if (category == null) {
        throw StateError('Unknown slot category: ${slot.categoryId}');
      }

      final endTime = current.addMinutes(category.durationMinutes);
      int? performanceOrder;
      if (category.isPerformanceSlot) {
        performanceCount += 1;
        performanceOrder = performanceCount;
      }

      placed.add(
        PlacedSlot(
          slot: slot,
          category: category,
          participant: slot.participantId == null
              ? null
              : participantsById[slot.participantId!],
          startTime: current,
          endTime: endTime,
          index: index,
          performanceOrder: performanceOrder,
        ),
      );
      current = endTime;
    }

    return placed;
  }

  /// End time of the last slot. Throws if [slots] is empty.
  TimelineTime endTime({required List<SlotCategory> categories}) {
    if (slots.isEmpty) {
      throw StateError('Timeline must contain at least one slot');
    }
    return placedSlots(categories: categories).last.endTime;
  }

  int performanceSlotCount({required List<SlotCategory> categories}) {
    final categoriesById = {for (final category in categories) category.id: category};
    return slots.where((slot) {
      final category = categoriesById[slot.categoryId];
      if (category == null) {
        throw StateError('Unknown slot category: ${slot.categoryId}');
      }
      return category.isPerformanceSlot;
    }).length;
  }
}
