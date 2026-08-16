import 'package:freezed_annotation/freezed_annotation.dart';

import 'participant.dart';
import 'slot.dart';
import 'slot_category.dart';
import 'timeline_time.dart';

part 'placed_slot.freezed.dart';

/// A requirement of the assigned participant that this placement violates.
/// Violations only produce warnings; they never block placement.
enum RequirementViolation {
  belowMinDuration,
  aboveMaxDuration,
  finishesTooLate,
  startsTooEarly,
  orderTooEarly,
  orderTooLate,
}

/// A [Slot] with category, participant, and stacked times resolved.
@freezed
abstract class PlacedSlot with _$PlacedSlot {
  const PlacedSlot._();

  const factory PlacedSlot({
    required Slot slot,
    required SlotCategory category,
    required Participant? participant,
    required TimelineTime startTime,
    required TimelineTime endTime,
    required int index,
    /// 1-based order among performance slots only; null when not a performance slot.
    int? performanceOrder,
  }) = _PlacedSlot;

  int get durationMinutes => endTime.difference(startTime).inMinutes;

  /// Which requirements of the assigned participant this placement violates.
  /// Empty when no participant is assigned or everything is satisfied.
  List<RequirementViolation> requirementViolations() {
    final participant = this.participant;
    if (participant == null) return const [];
    final requirements = participant.requirements;
    final min = requirements.minDurationMinutes;
    final max = requirements.maxDurationMinutes;
    final finishBy = requirements.finishBy;
    final startAfter = requirements.startAfter;
    final orderFrom = requirements.preferredOrderFrom;
    final orderBefore = requirements.preferredOrderBefore;
    final order = performanceOrder;
    return [
      if (min != null && durationMinutes < min)
        RequirementViolation.belowMinDuration,
      if (max != null && durationMinutes > max)
        RequirementViolation.aboveMaxDuration,
      if (finishBy != null && endTime > finishBy)
        RequirementViolation.finishesTooLate,
      if (startAfter != null && startTime < startAfter)
        RequirementViolation.startsTooEarly,
      if (orderFrom != null && order != null && order < orderFrom)
        RequirementViolation.orderTooEarly,
      if (orderBefore != null && order != null && order >= orderBefore)
        RequirementViolation.orderTooLate,
    ];
  }
}
