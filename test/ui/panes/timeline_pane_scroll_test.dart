import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/files/document_file_port.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';
import 'package:timetablist/ui/panes/timeline_pane.dart';
import 'package:timetablist/ui/widgets/placed_slot_view.dart';

import '../../support/pump_app.dart';

class _FakeDocumentFilePort implements DocumentFilePort {
  _FakeDocumentFilePort(this.importText);

  final String? importText;

  @override
  Future<void> saveFile({
    required String fileName,
    required String contents,
    required String mimeType,
  }) async {}

  @override
  Future<String?> importJson() async => importText;
}

Document _tenAmDocument() => Document(
  name: '読み込んだ表',
  slotCategories: const [
    SlotCategory(
      id: 'perf',
      name: '出演枠',
      durationMinutes: 30,
      isPerformanceSlot: true,
    ),
  ],
  timelines: [
    Timeline(
      id: 'tl1',
      name: '本編',
      startTime: TimelineTime.fromHoursAndMinutes(hour: 10, minute: 0),
      slots: const [Slot(id: 's1', categoryId: 'perf')],
    ),
  ],
);

Document _emptyNamed(String name) => Document.empty(name: name);

Future<void> _selectMenuAction(WidgetTester tester, String label) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void _expectFirstSlotNearPaneTop(WidgetTester tester) {
  final paneTop = tester.getTopLeft(find.byType(TimelinePane)).dy;
  final slotTop = tester.getTopLeft(find.byType(PlacedSlotView)).dy;
  expect(slotTop, closeTo(paneTop, 2));
}

void main() {
  testWidgets('scroll cue jumps the earliest start to the top of the pane', (
    tester,
  ) async {
    final container = await pumpApp(tester, initialDocument: _tenAmDocument());
    await tester.pumpAndSettle();

    final paneTop = tester.getTopLeft(find.byType(TimelinePane)).dy;
    expect(
      tester.getTopLeft(find.byType(PlacedSlotView)).dy,
      greaterThan(paneTop + 100),
    );

    container.read(timelinePaneScrollCueProvider.notifier).request();
    await tester.pumpAndSettle();

    _expectFirstSlotNearPaneTop(tester);
  });

  testWidgets('import scrolls so the earliest start is at the top', (
    tester,
  ) async {
    final port = _FakeDocumentFilePort(jsonEncode(_tenAmDocument().toJson()));
    await pumpApp(
      tester,
      initialDocument: _emptyNamed('マイタイムテーブル'),
      filePort: port,
    );

    await _selectMenuAction(tester, 'ファイルを読み込む');
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();

    _expectFirstSlotNearPaneTop(tester);
  });

  testWidgets('initial timeline create scrolls the start to the top', (
    tester,
  ) async {
    await pumpApp(tester, initialDocument: _emptyNamed('タイムテーブル'));

    await _selectMenuAction(tester, '新規作成');
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, '出演時間長（分）'), '30');
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, '作成'));
    await tester.pumpAndSettle();

    _expectFirstSlotNearPaneTop(tester);
  });
}
