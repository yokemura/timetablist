import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/files/document_file_port.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';

import '../support/pump_app.dart';

class _FakeDocumentFilePort implements DocumentFilePort {
  String? importText;
  var importCallCount = 0;

  @override
  Future<void> saveFile({
    required String fileName,
    required String contents,
    required String mimeType,
  }) async {}

  @override
  Future<String?> importJson() async {
    importCallCount += 1;
    return importText;
  }
}

Document _loadedDocument() => Document(
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

void main() {
  testWidgets('startup with no timelines asks create or load', (tester) async {
    await pumpApp(tester, promptInitialTimeline: true);
    await tester.pumpAndSettle();

    expect(find.textContaining('タイムラインがありません'), findsOneWidget);
    expect(find.text('初期タイムライン作成'), findsNothing);
  });

  testWidgets('startup create new opens the initial timeline dialog', (
    tester,
  ) async {
    await pumpApp(tester, promptInitialTimeline: true);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, '新規作成'));
    await tester.pumpAndSettle();

    expect(find.textContaining('タイムラインがありません'), findsNothing);
    expect(find.text('初期タイムライン作成'), findsOneWidget);
  });

  testWidgets('startup load skips overwrite confirmation', (tester) async {
    final port = _FakeDocumentFilePort()
      ..importText = jsonEncode(_loadedDocument().toJson());
    final container = await pumpApp(
      tester,
      promptInitialTimeline: true,
      filePort: port,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'ファイルを読み込む'));
    await tester.pumpAndSettle();

    expect(find.textContaining('現在の内容を読み込んだファイルの内容で置き換えますか'), findsNothing);
    expect(port.importCallCount, 1);
    expect(container.read(documentProvider).name, '読み込んだ表');
    expect(find.textContaining('タイムラインがありません'), findsNothing);
  });

  testWidgets('startup load cancel shows the choice dialog again', (
    tester,
  ) async {
    final port = _FakeDocumentFilePort();
    await pumpApp(tester, promptInitialTimeline: true, filePort: port);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'ファイルを読み込む'));
    await tester.pumpAndSettle();

    expect(port.importCallCount, 1);
    expect(find.textContaining('タイムラインがありません'), findsOneWidget);
  });

  testWidgets('startup load failure shows an error then the choice again', (
    tester,
  ) async {
    final port = _FakeDocumentFilePort()..importText = 'これはJSONではない';
    await pumpApp(tester, promptInitialTimeline: true, filePort: port);
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'ファイルを読み込む'));
    await tester.pumpAndSettle();

    expect(find.textContaining('ファイルを読み込めませんでした'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();

    expect(find.textContaining('タイムラインがありません'), findsOneWidget);
  });

  testWidgets('startup with existing timelines does not prompt', (
    tester,
  ) async {
    await pumpApp(
      tester,
      promptInitialTimeline: true,
      initialDocument: _loadedDocument(),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('タイムラインがありません'), findsNothing);
    expect(find.text('初期タイムライン作成'), findsNothing);
  });
}
