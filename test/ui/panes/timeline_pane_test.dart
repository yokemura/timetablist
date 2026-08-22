import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';
import 'package:timetablist/ui/widgets/placed_slot_view.dart';
import 'package:timetablist/ui/widgets/time_ruler.dart';
import 'package:timetablist/ui/widgets/timeline_lane.dart';

import '../../support/pump_app.dart';

Document timelineDocument() {
  return Document(
    name: 'タイムテーブル',
    slotCategories: const [
      SlotCategory(
        id: 'perf',
        name: '出演枠',
        durationMinutes: 30,
        isPerformanceSlot: true,
      ),
    ],
    participants: const [Participant(id: 'alice', name: 'Alice')],
    timelines: [
      Timeline(
        id: 'day1',
        name: '１日目',
        startTime: TimelineTime.midnight,
        slots: const [
          Slot(id: 's1', categoryId: 'perf', participantId: 'alice'),
        ],
      ),
    ],
  );
}

Document documentWithCategoryOnly() {
  return Document(
    name: 'タイムテーブル',
    slotCategories: const [
      SlotCategory(
        id: 'perf',
        name: '出演枠',
        durationMinutes: 30,
        isPerformanceSlot: true,
      ),
    ],
  );
}

void main() {
  testWidgets('empty pane shows only the create button', (tester) async {
    await pumpApp(tester);

    expect(find.text('タイムライン作成'), findsOneWidget);
    expect(find.byType(TimeRuler), findsNothing);
    expect(find.byType(TimelineLane), findsNothing);
  });

  testWidgets('creating a timeline with no slot types shows an error', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('タイムライン作成'));
    await tester.pumpAndSettle();

    expect(find.text('タイムラインを作成するには、まず枠タイプを作成してください。'), findsOneWidget);
    expect(find.byType(TimelineLane), findsNothing);
  });

  testWidgets('creates a timeline with the selected initial slot type', (
    tester,
  ) async {
    final container = await pumpApp(
      tester,
      initialDocument: documentWithCategoryOnly(),
    );

    await tester.tap(find.text('タイムライン作成'));
    await tester.pumpAndSettle();

    expect(find.text('タイムライン作成'), findsWidgets);
    await tester.tap(find.widgetWithText(FilledButton, '作成'));
    await tester.pumpAndSettle();

    final document = container.read(documentProvider);
    expect(document.timelines, hasLength(1));
    expect(document.timelines.single.name, 'タイムライン');
    expect(document.timelines.single.slots, hasLength(1));
    expect(document.timelines.single.slots.single.categoryId, 'perf');
    expect(find.byType(TimelineLane), findsOneWidget);
    expect(find.byType(TimeRuler), findsOneWidget);
    expect(find.text('タイムライン'), findsWidgets);
  });

  testWidgets('slots grow to fit participant names that wrap', (tester) async {
    final document = Document(
      name: 'タイムテーブル',
      slotCategories: const [
        SlotCategory(
          id: 'perf',
          name: '出演枠',
          durationMinutes: 30,
          isPerformanceSlot: true,
        ),
      ],
      participants: const [
        Participant(id: 'long', name: 'とてもとても長い名前の演者グループ・アンサンブル・オーケストラ合唱団'),
      ],
      timelines: [
        Timeline(
          id: 'day1',
          name: '１日目',
          startTime: TimelineTime.midnight,
          slots: const [
            Slot(id: 's1', categoryId: 'perf', participantId: 'long'),
          ],
        ),
      ],
    );

    await pumpApp(tester, initialDocument: document);

    // Regression: fixed-height estimates used to overflow (RenderFlex error)
    // when the name wrapped to multiple lines.
    expect(tester.takeException(), isNull);
  });

  testWidgets('clicking a slot or timeline name updates the selection', (
    tester,
  ) async {
    final container = await pumpApp(
      tester,
      initialDocument: timelineDocument(),
    );

    await tester.tap(find.text('１日目'));
    await tester.pump();
    expect(
      container.read(effectiveSelectionProvider),
      const Selection.timeline(timelineId: 'day1'),
    );

    await tester.tap(find.byType(PlacedSlotView));
    await tester.pump();
    expect(
      container.read(effectiveSelectionProvider),
      const Selection.slot(timelineId: 'day1', slotId: 's1'),
    );
    expect(find.text('0:00〜0:30 出演枠(30分)'), findsOneWidget);
  });
}
