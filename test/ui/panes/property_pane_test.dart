import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
    expect(find.text('枠タイプ情報'), findsNothing);
    expect(find.text('演者情報'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'OK'), findsNothing);
    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox.value, isTrue);
    expect(checkbox.onChanged, isNull);
  });

  testWidgets('changing the slot category dropdown applies immediately',
      (tester) async {
    final container = await pumpApp(tester, initialDocument: sampleDocument());
    container.read(selectionProvider.notifier).select(
          const Selection.slot(timelineId: 'day1', slotId: 's1'),
        );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('転換').last);
    await tester.pumpAndSettle();

    expect(
      find.text('出演枠属性のない枠タイプに変更しますか？割り当て済みの演者は未割り当てになります。'),
      findsOneWidget,
    );
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final slot = container
        .read(documentProvider)
        .timelineById('day1')!
        .slots
        .firstWhere((candidate) => candidate.id == 's1');
    expect(slot.categoryId, 'gap');
    expect(slot.participantId, isNull);
  });

  testWidgets('shows a disabled performance checkbox for a slot category',
      (tester) async {
    final container = await pumpApp(tester, initialDocument: sampleDocument());
    container.read(selectionProvider.notifier).select(
          const Selection.slotCategory(slotCategoryId: 'gap'),
        );

    await tester.pumpAndSettle();

    expect(find.byType(Checkbox), findsOneWidget);
    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox.value, isFalse);
    expect(checkbox.onChanged, isNull);
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

  Future<void> _commitSlotDuration(WidgetTester tester, String next) async {
    await tester.enterText(find.widgetWithText(TextField, '時間長（分）'), next);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }

  testWidgets('changing duration of a shared slot type asks this vs all',
      (tester) async {
    final container = await pumpApp(tester, initialDocument: sampleDocument());
    container.read(selectionProvider.notifier).select(
          const Selection.slot(timelineId: 'day1', slotId: 's1'),
        );
    await tester.pumpAndSettle();

    await _commitSlotDuration(tester, '45');

    expect(find.text('この枠のみを変更'), findsOneWidget);
    expect(find.text('すべての同じタイプの枠を変更'), findsOneWidget);
    expect(
      container.read(documentProvider).slotCategoryById('perf')!.durationMinutes,
      30,
    );
  });

  testWidgets('changing duration of a singly used slot type updates it directly',
      (tester) async {
    final container = await pumpApp(tester, initialDocument: sampleDocument());
    container.read(selectionProvider.notifier).select(
          const Selection.slot(timelineId: 'day1', slotId: 's2'),
        );
    await tester.pumpAndSettle();

    await _commitSlotDuration(tester, '15');

    expect(find.text('この枠のみを変更'), findsNothing);
    expect(find.text('すべての同じタイプの枠を変更'), findsNothing);
    expect(
      container.read(documentProvider).slotCategoryById('gap')!.durationMinutes,
      15,
    );
  });
}
