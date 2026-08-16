import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/ui/timeline/timeline_draft.dart';

CategoryDraft _new({
  required String name,
  required String duration,
  bool performance = false,
}) {
  return CategoryDraft(
    newName: name,
    newDurationText: duration,
    isPerformanceSlot: performance,
  );
}

void main() {
  group('TimelineDraft', () {
    test('performance start equals sequence start when there is no prep', () {
      final draft = TimelineDraft(
        startTimeText: '10:00',
        hasPrep: false,
        prep: _new(name: 'Prep', duration: '15'),
        performanceCountText: '2',
        performance: _new(name: 'Set', duration: '30', performance: true),
        hasInterval: false,
        interval: _new(name: 'Gap', duration: '10'),
        hasTeardown: false,
        teardown: _new(name: 'Out', duration: '20'),
      );

      expect(draft.times.performanceStart?.toDisplayString(), '10:00');
      expect(draft.times.endTime?.toDisplayString(), '11:00');
      expect(draft.times.teardownStart, isNull);
      expect(draft.slotSequence, hasLength(2));
    });

    test('prep, intervals (N-1), and teardown stack in order', () {
      final draft = TimelineDraft(
        startTimeText: '10:00',
        hasPrep: true,
        prep: _new(name: 'Prep', duration: '15'),
        performanceCountText: '3',
        performance: _new(name: 'Set', duration: '30', performance: true),
        hasInterval: true,
        interval: _new(name: 'Gap', duration: '10'),
        hasTeardown: true,
        teardown: _new(name: 'Out', duration: '20'),
      );

      // 15 + 30+10 + 30+10 + 30 + 20 = 145 minutes → 12:25
      expect(draft.times.performanceStart?.toDisplayString(), '10:15');
      expect(draft.times.teardownStart?.toDisplayString(), '12:05');
      expect(draft.times.endTime?.toDisplayString(), '12:25');
      expect(draft.times.exceedsMax, isFalse);
      expect(
        draft.slotSequence?.map((step) => step.category.name),
        ['Prep', 'Set', 'Gap', 'Set', 'Gap', 'Set', 'Out'],
      );
    });

    test('exceedsMax when the sequence runs past 30:00', () {
      final draft = TimelineDraft(
        startTimeText: '29:00',
        hasPrep: false,
        prep: _new(name: 'Prep', duration: '15'),
        performanceCountText: '1',
        performance: _new(name: 'Set', duration: '120', performance: true),
        hasInterval: false,
        interval: _new(name: 'Gap', duration: '10'),
        hasTeardown: false,
        teardown: _new(name: 'Out', duration: '20'),
      );

      expect(draft.times.endTime?.toDisplayString(), '31:00');
      expect(draft.times.exceedsMax, isTrue);
    });
  });
}
