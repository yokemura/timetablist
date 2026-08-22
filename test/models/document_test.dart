import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/models/models.dart';

void main() {
  group('TimelineTime', () {
    test('displays hour without zero-padding', () {
      expect(
        TimelineTime.fromHoursAndMinutes(hour: 8, minute: 5).toDisplayString(),
        '8:05',
      );
      expect(
        TimelineTime.fromHoursAndMinutes(hour: 25, minute: 0).toDisplayString(),
        '25:00',
      );
    });

    test('parses display strings', () {
      expect(TimelineTime.parse('8:05').minutesFromMidnight, 8 * 60 + 5);
      expect(TimelineTime.parse('30:00'), TimelineTime.max);
    });

    test('tryParse returns null for invalid input', () {
      expect(TimelineTime.tryParse('8:05'), const TimelineTime(8 * 60 + 5));
      expect(TimelineTime.tryParse('805'), isNull);
      expect(TimelineTime.tryParse('8:60'), isNull);
      expect(TimelineTime.tryParse('-1:00'), isNull);
      expect(TimelineTime.tryParse('a:bc'), isNull);
    });

    test('allows times past 24:00 up to the max', () {
      expect(TimelineTime.max.hour, TimelineLimits.maxHour);
      expect(TimelineTime.max.isWithinMax, isTrue);
      expect(TimelineTime.max.addMinutes(1).isWithinMax, isFalse);
    });
  });

  group('Document', () {
    test('empty uses the given localized name and empty lists', () {
      final document = Document.empty(name: 'タイムテーブル');
      expect(document.name, 'タイムテーブル');
      expect(document.timelines, isEmpty);
      expect(document.slotCategories, isEmpty);
      expect(document.participants, isEmpty);
    });

    test('rejects duplicate category and participant names', () {
      const category = SlotCategory(
        id: 'c1',
        name: '出演枠',
        durationMinutes: 30,
        isPerformanceSlot: true,
      );
      const participant = Participant(id: 'p1', name: 'Alice');
      final document = Document(
        name: 'タイムテーブル',
        slotCategories: [category],
        participants: [participant],
      );

      expect(document.isSlotCategoryNameTaken('出演枠'), isTrue);
      expect(document.isSlotCategoryNameTaken('出演枠', exceptId: 'c1'), isFalse);
      expect(document.isParticipantNameTaken('Alice'), isTrue);
      expect(document.isParticipantNameTaken('Bob'), isFalse);
    });

    test('stacks slot times from the timeline start', () {
      const performance = SlotCategory(
        id: 'perf',
        name: '出演枠',
        durationMinutes: 30,
        isPerformanceSlot: true,
      );
      const changeover = SlotCategory(
        id: 'gap',
        name: '転換',
        durationMinutes: 10,
        isPerformanceSlot: false,
      );
      const alice = Participant(id: 'alice', name: 'Alice');
      const bob = Participant(id: 'bob', name: 'Bob');

      final timeline = Timeline(
        id: 'day1',
        name: '１日目',
        startTime: TimelineTime.fromHoursAndMinutes(hour: 10, minute: 0),
        slots: const [
          Slot(id: 's1', categoryId: 'perf', participantId: 'alice'),
          Slot(id: 's2', categoryId: 'gap'),
          Slot(id: 's3', categoryId: 'perf', participantId: 'bob'),
        ],
      );

      final document = Document(
        name: 'タイムテーブル',
        timelines: [timeline],
        slotCategories: [performance, changeover],
        participants: [alice, bob],
      );

      final placed = document.placedSlotsOf(timeline);
      expect(placed, hasLength(3));
      expect(placed[0].startTime.toDisplayString(), '10:00');
      expect(placed[0].endTime.toDisplayString(), '10:30');
      expect(placed[0].performanceOrder, 1);
      expect(placed[0].participant?.name, 'Alice');
      expect(placed[1].startTime.toDisplayString(), '10:30');
      expect(placed[1].endTime.toDisplayString(), '10:40');
      expect(placed[1].performanceOrder, isNull);
      expect(placed[2].startTime.toDisplayString(), '10:40');
      expect(placed[2].endTime.toDisplayString(), '11:10');
      expect(placed[2].performanceOrder, 2);
      expect(document.endTimeOf(timeline).toDisplayString(), '11:10');
      expect(timeline.performanceSlotCount(categories: document.slotCategories), 2);
    });

    test('round-trips through JSON', () {
      final original = Document(
        name: 'タイムテーブル',
        slotCategories: const [
          SlotCategory(
            id: 'perf',
            name: '出演枠',
            durationMinutes: 45,
            isPerformanceSlot: true,
          ),
        ],
        participants: const [
          Participant(id: 'alice', name: 'Alice'),
        ],
        timelines: [
          Timeline(
            id: 'day1',
            name: '会場A',
            startTime: TimelineTime.fromHoursAndMinutes(hour: 12, minute: 0),
            slots: const [
              Slot(id: 's1', categoryId: 'perf', participantId: 'alice'),
            ],
          ),
        ],
      );

      final restored = Document.fromJson(original.toJson());
      expect(restored, original);
    });
  });

  group('Document.nextAvailableSlotCategoryName', () {
    test('uses the common (2), (3) suffix rule', () {
      const document = Document(
        name: 'タイムテーブル',
        slotCategories: [
          SlotCategory(
            id: 'a',
            name: '空き',
            durationMinutes: 10,
            isPerformanceSlot: false,
          ),
          SlotCategory(
            id: 'b',
            name: '空き(2)',
            durationMinutes: 10,
            isPerformanceSlot: false,
          ),
        ],
      );
      expect(document.nextAvailableSlotCategoryName('空き'), '空き(3)');
      expect(document.nextAvailableSlotCategoryName('会場準備'), '会場準備');
    });
  });

  group('Document.nextAvailableTimelineName', () {
    test('uses the common (2), (3) suffix rule', () {
      final document = Document(
        name: 'タイムテーブル',
        slotCategories: const [
          SlotCategory(
            id: 'perf',
            name: '出演',
            durationMinutes: 30,
            isPerformanceSlot: true,
          ),
        ],
        timelines: [
          Timeline(
            id: 't1',
            name: 'タイムライン',
            startTime: TimelineTime.midnight,
            slots: const [Slot(id: 's1', categoryId: 'perf')],
          ),
        ],
      );
      expect(document.nextAvailableTimelineName('タイムライン'), 'タイムライン(2)');
      expect(document.nextAvailableTimelineName('会場A'), '会場A');
    });
  });

  group('generateEntityId', () {
    test('returns unique UUID-shaped ids', () {
      final ids = {generateEntityId(), generateEntityId(), generateEntityId()};
      expect(ids, hasLength(3));
      expect(
        ids.every(
          (id) => RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          ).hasMatch(id),
        ),
        isTrue,
      );
    });
  });
}
