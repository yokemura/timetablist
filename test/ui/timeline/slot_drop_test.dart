import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/ui/timeline/slot_drop.dart';
import 'package:timetablist/ui/timeline/time_layout.dart';

/// Slots 10:00–10:30 and 10:30–10:40 on a default-density scale
/// (1 px per minute, so y == minutes from midnight).
List<PlacedSlot> _placedSlots() {
  const perf = SlotCategory(
    id: 'perf',
    name: 'Performance',
    durationMinutes: 30,
    isPerformanceSlot: true,
  );
  const gap = SlotCategory(
    id: 'gap',
    name: 'Changeover',
    durationMinutes: 10,
    isPerformanceSlot: false,
  );
  return [
    PlacedSlot(
      slot: const Slot(id: 's1', categoryId: 'perf'),
      category: perf,
      participant: null,
      startTime: TimelineTime.parse('10:00'),
      endTime: TimelineTime.parse('10:30'),
      index: 0,
      performanceOrder: 1,
    ),
    PlacedSlot(
      slot: const Slot(id: 's2', categoryId: 'gap'),
      category: gap,
      participant: null,
      startTime: TimelineTime.parse('10:30'),
      endTime: TimelineTime.parse('10:40'),
      index: 1,
    ),
  ];
}

void main() {
  final layout = TimeLayout.empty();
  final placed = _placedSlots();

  SlotDrop drop(double y, {int durationMinutes = 30}) => computeSlotDrop(
    layout: layout,
    placedSlots: placed,
    durationMinutes: durationMinutes,
    y: y,
  );

  group('computeSlotDrop', () {
    test('over the slots snaps to the nearest boundary', () {
      final atStart = drop(605);
      expect(atStart, isA<SlotDropInsert>());
      expect((atStart as SlotDropInsert).index, 0);
      expect(atStart.boundaryTime, TimelineTime.parse('10:00'));

      final between = drop(620);
      expect((between as SlotDropInsert).index, 1);
      expect(between.boundaryTime, TimelineTime.parse('10:30'));

      final atEnd = drop(638);
      expect((atEnd as SlotDropInsert).index, 2);
      expect(atEnd.boundaryTime, TimelineTime.parse('10:40'));
    });

    test('slightly before the start snaps to the start', () {
      final result = drop(590); // 9:50, 10 min out, dragged 30 min.
      expect((result as SlotDropInsert).index, 0);
    });

    test('far before the start places at a 10-minute resolution', () {
      final result = drop(483); // 8:03 → rounds to 8:00.
      expect(result, isA<SlotDropLeadingGap>());
      expect(
        (result as SlotDropLeadingGap).newStartTime,
        TimelineTime.parse('8:00'),
      );

      final up = drop(487); // 8:07 → rounds to 8:10.
      expect((up as SlotDropLeadingGap).newStartTime, TimelineTime.parse('8:10'));
    });

    test('leading placement with no room for a gap snaps to the start', () {
      // 9:25 is 35 min out (beyond the 30-min duration) but rounds to 9:30,
      // leaving a zero-length gap.
      final result = drop(565);
      expect((result as SlotDropInsert).index, 0);
    });

    test('slightly after the end snaps to the end', () {
      final result = drop(660); // 11:00, 20 min out, dragged 30 min.
      expect((result as SlotDropInsert).index, 2);
    });

    test('far after the end places at a 10-minute resolution', () {
      final result = drop(723); // 12:03 → rounds to 12:00.
      expect(result, isA<SlotDropTrailingGap>());
      expect(
        (result as SlotDropTrailingGap).slotStartTime,
        TimelineTime.parse('12:00'),
      );
    });
  });

  test('roundToDropResolution clamps to the 0:00–30:00 scale', () {
    expect(roundToDropResolution(TimelineTime.midnight), TimelineTime.midnight);
    expect(
      roundToDropResolution(TimelineTime.parse('29:58')),
      TimelineTime.max,
    );
  });
}
