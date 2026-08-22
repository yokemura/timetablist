import '../../models/models.dart';
import 'time_layout.dart';

/// Where a dragged slot category would land on a lane, per the spec:
/// - over the placed slots: snap to the nearest slot boundary;
/// - before the start (or after the end) by no more than the dragged
///   duration: snap to the start (end);
/// - further out: free placement at a 10-minute resolution, which creates an
///   auto gap slot to fill the open time.
sealed class SlotDrop {
  const SlotDrop();

  /// Time the insertion bar is drawn at.
  TimelineTime get barTime;
}

/// Insert at [index] (0..slots.length); the bar sits on that slot boundary.
class SlotDropInsert extends SlotDrop {
  const SlotDropInsert({required this.index, required this.boundaryTime});

  final int index;
  final TimelineTime boundaryTime;

  @override
  TimelineTime get barTime => boundaryTime;
}

/// Place before the timeline start; the timeline start moves to
/// [newStartTime] and a gap slot fills the open time.
class SlotDropLeadingGap extends SlotDrop {
  const SlotDropLeadingGap({required this.newStartTime});

  final TimelineTime newStartTime;

  @override
  TimelineTime get barTime => newStartTime;
}

/// Place after the timeline end; a gap slot fills the open time and the new
/// slot starts at [slotStartTime].
class SlotDropTrailingGap extends SlotDrop {
  const SlotDropTrailingGap({required this.slotStartTime});

  final TimelineTime slotStartTime;

  @override
  TimelineTime get barTime => slotStartTime;
}

/// Rounds to the nearest 10 minutes, clamped to the 0:00–30:00 scale.
TimelineTime roundToDropResolution(TimelineTime time) {
  final rounded = ((time.minutesFromMidnight + 5) ~/ 10) * 10;
  return TimelineTime(
    rounded.clamp(0, TimelineLimits.maxMinutesFromMidnight),
  );
}

/// Resolves the drop position for a dragged category on a lane whose slots
/// are [placedSlots] (never empty). [y] is in [layout] coordinates.
SlotDrop computeSlotDrop({
  required TimeLayout layout,
  required List<PlacedSlot> placedSlots,
  required int durationMinutes,
  required double y,
}) {
  final time = layout.timeOf(y);
  final start = placedSlots.first.startTime;
  final end = placedSlots.last.endTime;

  if (time < start) {
    if (start.difference(time).inMinutes <= durationMinutes) {
      return SlotDropInsert(index: 0, boundaryTime: start);
    }
    final newStart = roundToDropResolution(time);
    // Rounding may leave no room for a positive-length gap; snap instead.
    final gapMinutes =
        start.difference(newStart).inMinutes - durationMinutes;
    if (gapMinutes <= 0) {
      return SlotDropInsert(index: 0, boundaryTime: start);
    }
    return SlotDropLeadingGap(newStartTime: newStart);
  }

  if (time > end) {
    if (time.difference(end).inMinutes <= durationMinutes) {
      return SlotDropInsert(
        index: placedSlots.length,
        boundaryTime: end,
      );
    }
    final slotStart = roundToDropResolution(time);
    if (slotStart.difference(end).inMinutes <= 0) {
      return SlotDropInsert(
        index: placedSlots.length,
        boundaryTime: end,
      );
    }
    return SlotDropTrailingGap(slotStartTime: slotStart);
  }

  // Over the placed slots: nearest boundary among every slot start plus the
  // final end.
  var bestIndex = 0;
  var bestBoundary = start;
  var bestDistance = (time.minutesFromMidnight - start.minutesFromMidnight)
      .abs();
  for (var i = 0; i < placedSlots.length; i++) {
    final boundary = placedSlots[i].endTime;
    final distance =
        (time.minutesFromMidnight - boundary.minutesFromMidnight).abs();
    if (distance < bestDistance) {
      bestDistance = distance;
      bestIndex = i + 1;
      bestBoundary = boundary;
    }
  }
  return SlotDropInsert(index: bestIndex, boundaryTime: bestBoundary);
}
