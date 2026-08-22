import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:timetablist/l10n/generated/s.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';
import 'package:timetablist/ui/timeline/time_layout.dart';
import 'package:timetablist/ui/widgets/placed_participant_view.dart';
import 'package:timetablist/ui/widgets/placed_slot_view.dart';
import 'package:timetablist/ui/widgets/time_ruler.dart';
import 'package:timetablist/ui/widgets/timeline_lane.dart';

// Golden tests use English strings: the test environment does not bundle a
// CJK font, so Japanese text would render as tofu.

const _performance = SlotCategory(
  id: 'perf',
  name: 'Performance',
  durationMinutes: 30,
  isPerformanceSlot: true,
);

const _gap = SlotCategory(
  id: 'gap',
  name: 'Changeover',
  durationMinutes: 10,
  isPerformanceSlot: false,
);

const _alice = Participant(id: 'alice', name: 'Alice');

PlacedSlot _placed({
  required Slot slot,
  required SlotCategory category,
  Participant? participant,
  required TimelineTime start,
  int index = 0,
  int? performanceOrder,
}) {
  return PlacedSlot(
    slot: slot,
    category: category,
    participant: participant,
    startTime: start,
    endTime: start.addMinutes(category.durationMinutes),
    index: index,
    performanceOrder: performanceOrder,
  );
}

void main() {
  goldenTest(
    'placed slot and participant',
    fileName: 'placed_slot_and_participant',
    pumpWidget: (tester, widget) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          locale: const Locale('en'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          ),
          home: Scaffold(body: Center(child: widget)),
        ),
      );
    },
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'empty performance slot',
          child: SizedBox(
            width: 168,
            height: 80,
            child: PlacedSlotView(
              placed: _placed(
                slot: const Slot(id: 's1', categoryId: 'perf'),
                category: _performance,
                start: TimelineTime.parse('10:00'),
                performanceOrder: 1,
              ),
              selected: false,
              onTap: () {},
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'slot with participant',
          child: SizedBox(
            width: 168,
            height: 80,
            child: PlacedSlotView(
              placed: _placed(
                slot: const Slot(
                  id: 's1',
                  categoryId: 'perf',
                  participantId: 'alice',
                ),
                category: _performance,
                participant: _alice,
                start: TimelineTime.parse('10:00'),
                performanceOrder: 1,
              ),
              selected: false,
              onTap: () {},
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'participant only',
          child: const SizedBox(
            width: 160,
            child: PlacedParticipantView(participant: _alice),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'aligned lanes (clipped to the start of the day)',
    fileName: 'timeline_lanes',
    pumpWidget: (tester, widget) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          locale: const Locale('en'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          ),
          home: Scaffold(body: widget),
        ),
      );
    },
    builder: () {
      final short = _placed(
        slot: const Slot(id: 'a1', categoryId: 'gap'),
        category: _gap,
        start: TimelineTime.midnight,
      );
      final long = _placed(
        slot: const Slot(id: 'b1', categoryId: 'perf', participantId: 'alice'),
        category: _performance,
        participant: _alice,
        start: TimelineTime.midnight,
        performanceOrder: 1,
      );
      final layout = TimeLayout.fromDemands([
        TimeSpanDemand(
          start: short.startTime,
          end: short.endTime,
          minHeight: TimeLayout.slotMinHeight(
            durationMinutes: short.durationMinutes,
            hasParticipant: false,
            hasWarning: false,
          ),
        ),
        TimeSpanDemand(
          start: long.startTime,
          end: long.endTime,
          minHeight: TimeLayout.slotMinHeight(
            durationMinutes: long.durationMinutes,
            hasParticipant: true,
            hasWarning: false,
          ),
        ),
      ]);
      final day1 = Timeline(
        id: 'day1',
        name: 'Hall A',
        startTime: TimelineTime.midnight,
        slots: [short.slot],
      );
      final day2 = Timeline(
        id: 'day2',
        name: 'Hall B',
        startTime: TimelineTime.midnight,
        slots: [long.slot],
      );

      return GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'two lanes share a time scale',
            child: SizedBox(
              width: TimeRuler.width + TimelineLane.width * 2,
              height: TimelineLane.headerHeight + 120,
              child: ClipRect(
                child: OverflowBox(
                  maxHeight: double.infinity,
                  alignment: Alignment.topLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: TimelineLane.headerHeight),
                          TimeRuler(layout: layout),
                        ],
                      ),
                      TimelineLane(
                        timeline: day1,
                        placedSlots: [short],
                        layout: layout,
                        selection: const Selection.document(),
                        onSelect: (_) {},
                      ),
                      TimelineLane(
                        timeline: day2,
                        placedSlots: [long],
                        layout: layout,
                        selection: const Selection.slot(
                          timelineId: 'day2',
                          slotId: 'b1',
                        ),
                        onSelect: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  goldenTest(
    'timeline slot end time alignment (0:00–1:00)',
    fileName: 'timeline_end_alignment',
    pumpWidget: (tester, widget) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          locale: const Locale('en'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          ),
          home: Scaffold(body: widget),
        ),
      );
    },
    builder: () {
      const changeoverHour = SlotCategory(
        id: 'gap60',
        name: 'Changeover',
        durationMinutes: 60,
        isPerformanceSlot: false,
      );
      const performance20 = SlotCategory(
        id: 'perf20',
        name: 'Performance',
        durationMinutes: 20,
        isPerformanceSlot: true,
      );
      const participants = [
        Participant(
          id: 'p1',
          name: 'The Magnificent Riverside Jazz Orchestra',
        ),
        Participant(
          id: 'p2',
          name: 'Downtown Experimental Music Collective',
        ),
        Participant(
          id: 'p3',
          name: 'Northern Lights Chamber Players Guild',
        ),
      ];

      // Long names wrap to multiple lines; CI fonts need more height than
      // [TimeLayout.slotMinHeight] assumes for a single participant line.
      const denseSlotMinHeight = 140.0;

      final sparseLane = _placed(
        slot: const Slot(id: 'c1', categoryId: 'gap60'),
        category: changeoverHour,
        start: TimelineTime.midnight,
      );

      final denseSlots = <PlacedSlot>[];
      var cursor = TimelineTime.midnight;
      for (var i = 0; i < 3; i++) {
        denseSlots.add(
          _placed(
            slot: Slot(
              id: 'd$i',
              categoryId: 'perf20',
              participantId: participants[i].id,
            ),
            category: performance20,
            participant: participants[i],
            start: cursor,
            index: i,
            performanceOrder: i + 1,
          ),
        );
        cursor = cursor.addMinutes(20);
      }

      final layout = TimeLayout.fromDemands([
        TimeSpanDemand(
          start: sparseLane.startTime,
          end: sparseLane.endTime,
          minHeight: TimeLayout.slotMinHeight(
            durationMinutes: sparseLane.durationMinutes,
            hasParticipant: false,
            hasWarning: false,
          ),
        ),
        for (final placed in denseSlots)
          TimeSpanDemand(
            start: placed.startTime,
            end: placed.endTime,
            minHeight: denseSlotMinHeight,
          ),
      ]);

      final oneOClock = TimelineTime.fromHoursAndMinutes(hour: 1, minute: 0);
      final viewportHeight = TimelineLane.headerHeight + layout.yOf(oneOClock);

      final sparseTimeline = Timeline(
        id: 'sparse',
        name: 'Hall A',
        startTime: TimelineTime.midnight,
        slots: [sparseLane.slot],
      );
      final denseTimeline = Timeline(
        id: 'dense',
        name: 'Hall B',
        startTime: TimelineTime.midnight,
        slots: [for (final placed in denseSlots) placed.slot],
      );

      return GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name:
                'sparse changeover vs dense performances share 0:00–1:00 scale',
            child: SizedBox(
              width: TimeRuler.width + TimelineLane.width * 2,
              height: viewportHeight,
              child: ClipRect(
                child: OverflowBox(
                  maxHeight: double.infinity,
                  alignment: Alignment.topLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: TimelineLane.headerHeight),
                          TimeRuler(layout: layout),
                        ],
                      ),
                      TimelineLane(
                        timeline: sparseTimeline,
                        placedSlots: [sparseLane],
                        layout: layout,
                        selection: const Selection.document(),
                        onSelect: (_) {},
                      ),
                      TimelineLane(
                        timeline: denseTimeline,
                        placedSlots: denseSlots,
                        layout: layout,
                        selection: const Selection.slot(
                          timelineId: 'dense',
                          slotId: 'd1',
                        ),
                        onSelect: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
