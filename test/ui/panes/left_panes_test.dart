import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';
import 'package:timetablist/ui/panes/participant_pane.dart';
import 'package:timetablist/ui/widgets/participant_list_item.dart';
import 'package:timetablist/ui/widgets/slot_category_list_item.dart';

import '../../support/pump_app.dart';

Document documentWithData() {
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
    participants: const [
      Participant(id: 'alice', name: 'Alice'),
      Participant(id: 'bob', name: 'Bob'),
    ],
    timelines: [
      Timeline(
        id: 'day1',
        name: '１日目',
        startTime: TimelineTime.fromHoursAndMinutes(hour: 10, minute: 0),
        slots: const [
          Slot(id: 's1', categoryId: 'perf', participantId: 'alice'),
        ],
      ),
    ],
  );
}

void main() {
  testWidgets('empty document shows only the create buttons', (tester) async {
    await pumpApp(tester);

    expect(find.text('枠タイプ作成'), findsOneWidget);
    expect(find.text('演者作成'), findsOneWidget);
    expect(find.byType(SlotCategoryListItem), findsNothing);
    expect(find.byType(ParticipantListItem), findsNothing);
  });

  testWidgets('creates a slot category from the dialog', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.text('枠タイプ作成'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, '名前'),
      '演奏',
    );
    await tester.enterText(
      find.widgetWithText(TextField, '時間長（分）'),
      '45',
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, '作成'));
    await tester.pumpAndSettle();

    final document = container.read(documentProvider);
    expect(document.slotCategories, hasLength(1));
    final created = document.slotCategories.single;
    expect(created.name, '演奏');
    expect(created.durationMinutes, 45);
    expect(created.isPerformanceSlot, isTrue); // Default is on.

    expect(find.byType(SlotCategoryListItem), findsOneWidget);
    expect(find.text('演奏'), findsOneWidget);
    expect(find.text('45分'), findsOneWidget);
  });

  testWidgets('duplicate slot category name blocks creation', (tester) async {
    await pumpApp(tester, initialDocument: documentWithData());

    await tester.tap(find.text('枠タイプ作成'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, '名前'), '出演枠');
    await tester.enterText(find.widgetWithText(TextField, '時間長（分）'), '30');
    await tester.pump();

    expect(find.text('同じ名前の枠タイプがあります'), findsOneWidget);
    final createButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, '作成'),
    );
    expect(createButton.onPressed, isNull);
  });

  testWidgets('creates a participant from the dialog', (tester) async {
    final container = await pumpApp(tester);

    await tester.tap(find.text('演者作成'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, '名前'), 'Alice');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, '作成'));
    await tester.pumpAndSettle();

    final document = container.read(documentProvider);
    final created = document.participants.single;
    expect(created.name, 'Alice');

    expect(find.text('Alice'), findsOneWidget);
  });

  testWidgets('assigned participants remain in the pane', (tester) async {
    await pumpApp(tester, initialDocument: documentWithData());

    expect(find.byType(ParticipantListItem), findsNWidgets(2));
    expect(
      find.descendant(
        of: find.byType(ParticipantPane),
        matching: find.text('Bob'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(ParticipantPane),
        matching: find.text('Alice'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('clicking items selects them; empty space selects the document',
      (tester) async {
    final container = await pumpApp(
      tester,
      initialDocument: documentWithData(),
    );

    await tester.tap(find.byType(SlotCategoryListItem));
    await tester.pump();
    expect(
      container.read(effectiveSelectionProvider),
      const Selection.slotCategory(slotCategoryId: 'perf'),
    );

    await tester.tap(find.text('Bob'));
    await tester.pump();
    expect(
      container.read(effectiveSelectionProvider),
      const Selection.participant(participantId: 'bob'),
    );
  });
}
