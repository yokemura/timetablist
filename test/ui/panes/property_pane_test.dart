import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';
import 'package:timetablist/ui/panes/property_pane.dart';
import 'package:timetablist/ui/widgets/commit_text_field.dart';

import '../../state/document_editor_test.dart';
import '../../support/pump_app.dart';

void main() {
  testWidgets('shows document name by default', (tester) async {
    await pumpApp(tester, initialDocument: sampleDocument());

    expect(find.byType(PropertyPane), findsOneWidget);
    expect(find.widgetWithText(CommitTextField, 'タイムテーブル'), findsOneWidget);
    expect(find.text('ドキュメント名'), findsOneWidget);
  });

  testWidgets('shows participant fields when a participant is selected',
      (tester) async {
    final container = await pumpApp(tester, initialDocument: sampleDocument());
    container
        .read(selectionProvider.notifier)
        .select(const Selection.participant(participantId: 'bob'));

    await tester.pumpAndSettle();

    expect(find.widgetWithText(CommitTextField, 'Bob'), findsOneWidget);
    expect(find.text('要求項目'), findsOneWidget);
    expect(find.text('削除'), findsOneWidget);
  });

  testWidgets('shows timeline fields when a timeline is selected',
      (tester) async {
    final container = await pumpApp(tester, initialDocument: sampleDocument());
    container
        .read(selectionProvider.notifier)
        .select(const Selection.timeline(timelineId: 'day1'));

    await tester.pumpAndSettle();

    expect(find.widgetWithText(CommitTextField, '１日目'), findsOneWidget);
    expect(find.text('開始時刻'), findsOneWidget);
    expect(find.text('終了時刻'), findsOneWidget);
    expect(find.text('出演枠数'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('複製'), findsOneWidget);
  });

  testWidgets('shows slot fields when a slot is selected', (tester) async {
    final container = await pumpApp(tester, initialDocument: sampleDocument());
    container.read(selectionProvider.notifier).select(
          const Selection.slot(timelineId: 'day1', slotId: 's1'),
        );

    await tester.pumpAndSettle();

    expect(find.text('枠タイプ'), findsWidgets);
    expect(find.text('出演枠'), findsWidgets);
    expect(find.text('演者'), findsWidgets);
    expect(find.text('Alice'), findsWidgets);
    expect(find.text('要求不一致'), findsNothing);
  });

  testWidgets('renaming the document commits through the editor',
      (tester) async {
    final container = await pumpApp(tester, initialDocument: sampleDocument());

    await tester.enterText(
      find.widgetWithText(TextField, 'タイムテーブル'),
      'Live A',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(container.read(documentProvider).name, 'Live A');
  });

  testWidgets('falls back to document selection when participant is deleted',
      (tester) async {
    final container = await pumpApp(tester, initialDocument: sampleDocument());
    container
        .read(selectionProvider.notifier)
        .select(const Selection.participant(participantId: 'bob'));

    await tester.pumpAndSettle();

    container.read(documentEditorProvider.notifier).deleteParticipant('bob');
    await tester.pumpAndSettle();

    expect(container.read(documentProvider).participants, hasLength(1));
    expect(
      container.read(effectiveSelectionProvider),
      const Selection.document(),
    );
  });
}
