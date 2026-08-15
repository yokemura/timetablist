import 'package:freezed_annotation/freezed_annotation.dart';

import 'participant.dart';
import 'slot.dart';
import 'slot_category.dart';
import 'timeline_time.dart';

part 'placed_slot.freezed.dart';

/// A [Slot] with category, participant, and stacked times resolved.
@freezed
abstract class PlacedSlot with _$PlacedSlot {
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
}
