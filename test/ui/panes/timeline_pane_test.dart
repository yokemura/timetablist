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
    participants: [
      Participant(
        id: 'alice',
        name: 'Alice',
        requirements: const ParticipantRequirements(minDurationMinutes: 60),
      ),
    ],
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

void main() {
  testWidgets('empty pane shows only the create button', (tester) async {
    await pumpApp(tester);

    expect(find.text('タイムライン作成'), findsOneWidget);
    expect(find.byType(TimeRuler), findsNothing);
    expect(find.byType(TimelineLane), findsNothing);
  });

  testWidgets('creates a timeline from the sheet and shows a lane',
      (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.text('タイムライン作成'));
    await tester.pumpAndSettle();

    expect(find.text('出演枠の開始時刻: 10:00'), findsOneWidget);
    expect(find.text('終了時刻: —'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '時間長（分）'), '30');
    await tester.pump();
    expect(find.text('終了時刻: 10:30'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, '枠数'), '2');
    await tester.pump();
    expect(find.text('終了時刻: 11:00'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, '作成'));
    await tester.pumpAndSettle();

    final document = container.read(documentProvider);
    expect(document.timelines, hasLength(1));
    expect(document.timelines.single.name, 'タイムライン1');
    expect(document.timelines.single.slots, hasLength(2));
    expect(document.slotCategories.single.name, '出演枠');
    expect(find.byType(TimelineLane), findsOneWidget);
    expect(find.byType(TimeRuler), findsOneWidget);
    expect(find.text('タイムライン1'), findsOneWidget);
  });

  testWidgets('live times include prep and block past 30:00', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('タイムライン作成'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('準備あり'));
    await tester.pump();
    await tester.enterText(find.widgetWithText(TextField, '時間長（分）').first, '15');
    await tester.enterText(find.widgetWithText(TextField, '時間長（分）').last, '30');
    await tester.pump();
    expect(find.text('出演枠の開始時刻: 10:15'), findsOneWidget);
    expect(find.text('終了時刻: 10:45'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'シーケンス開始時間'),
      '29:00',
    );
    await tester.enterText(find.widgetWithText(TextField, '時間長（分）').last, '120');
    await tester.pump();
    expect(find.text('終了時刻: 31:15'), findsOneWidget);
    expect(find.text('終了時刻がタイムラインの最大時刻を超えています'), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, '作成'))
          .onPressed,
      isNull,
    );
  });

  testWidgets('clicking a slot or timeline name updates the selection',
      (tester) async {
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
    expect(find.text('要求不一致'), findsOneWidget);
  });
}
