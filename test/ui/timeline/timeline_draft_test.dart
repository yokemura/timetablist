import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/ui/timeline/initial_timeline_draft.dart';

void main() {
  group('InitialTimelineDraft', () {
    test('performances start at the sequence start with no extras', () {
      const draft = InitialTimelineDraft(
        nameText: 'タイムライン',
        countText: '2',
        sequenceStartText: '10:00',
        performanceStartText: '10:00',
        performanceDurationText: '30',
      );

      expect(draft.times.showEnd?.toDisplayString(), '11:00');
      expect(draft.times.endTime?.toDisplayString(), '11:00');
      expect(draft.slotSequence, [
        InitialSlotKind.performance,
        InitialSlotKind.performance,
      ]);
    });

    test('rehearsal, doors, changeovers, and teardown stack in order', () {
      const draft = InitialTimelineDraft(
        nameText: 'タイムライン',
        countText: '2',
        sequenceStartText: '10:00',
        hasVenuePrep: true,
        hasRehearsal: true,
        rehearsalStartText: '10:30',
        rehearsalDurationText: '20',
        hasRehearsalChangeover: true,
        rehearsalChangeoverText: '10',
        hasDoors: true,
        performanceStartText: '11:30',
        performanceDurationText: '30',
        hasChangeover: true,
        changeoverText: '10',
        hasTeardown: true,
        teardownEndText: '13:00',
      );

      // Venue prep 10:00–10:30 (30). Rehearsal 10:30–10:50 + 10 + 11:00–11:20.
      // Doors 11:20–11:30 (10). Shows 11:30–12:00 + 10 + 12:10–12:40. Teardown
      // 12:40–13:00 (20).
      expect(draft.times.venuePrepMinutes, 30);
      expect(draft.times.rehearsalStart?.toDisplayString(), '10:30');
      expect(draft.times.rehearsalEnd?.toDisplayString(), '11:20');
      expect(draft.times.doorsMinutes, 10);
      expect(draft.times.showEnd?.toDisplayString(), '12:40');
      expect(draft.times.teardownMinutes, 20);
      expect(draft.times.endTime?.toDisplayString(), '13:00');
      expect(draft.times.hasContradiction, isFalse);
      expect(draft.slotSequence, [
        InitialSlotKind.venuePrep,
        InitialSlotKind.rehearsal,
        InitialSlotKind.rehearsalChangeover,
        InitialSlotKind.rehearsal,
        InitialSlotKind.doors,
        InitialSlotKind.performance,
        InitialSlotKind.changeover,
        InitialSlotKind.performance,
        InitialSlotKind.teardown,
      ]);
    });

    test('contradicts when a derived duration would not be positive', () {
      const draft = InitialTimelineDraft(
        nameText: 'タイムライン',
        countText: '1',
        sequenceStartText: '10:00',
        hasVenuePrep: true,
        performanceStartText: '10:00',
        performanceDurationText: '30',
      );

      expect(draft.times.hasContradiction, isTrue);
      expect(draft.slotSequence, isNull);
    });

    test('exceedsMax when the sequence runs past 30:00', () {
      const draft = InitialTimelineDraft(
        nameText: 'タイムライン',
        countText: '1',
        sequenceStartText: '29:00',
        performanceStartText: '29:00',
        performanceDurationText: '120',
      );

      expect(draft.times.endTime?.toDisplayString(), '31:00');
      expect(draft.times.exceedsMax, isTrue);
      expect(draft.slotSequence, isNull);
    });
  });
}
