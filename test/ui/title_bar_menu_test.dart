import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/files/document_file_port.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';

import '../support/pump_app.dart';

class _FakeDocumentFilePort implements DocumentFilePort {
  String? exportedFileName;
  String? exportedJson;
  String? importText;

  @override
  Future<void> exportJson({
    required String fileName,
    required String json,
  }) async {
    exportedFileName = fileName;
    exportedJson = json;
  }

  @override
  Future<String?> importJson() async => importText;
}

Document _document() => Document(
      name: 'マイタイムテーブル',
      slotCategories: const [
        SlotCategory(
          id: 'perf',
          name: '出演枠',
          durationMinutes: 30,
          isPerformanceSlot: true,
        ),
      ],
    );

Future<void> _selectMenuAction(WidgetTester tester, String label) async {
  await tester.tap(find.byIcon(Icons.menu));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('export hands the document JSON to the file port',
      (tester) async {
    final port = _FakeDocumentFilePort();
    await pumpApp(tester, initialDocument: _document(), filePort: port);

    await _selectMenuAction(tester, 'エクスポート');

    expect(port.exportedFileName, 'マイタイムテーブル.json');
    final decoded =
        Document.fromJson(jsonDecode(port.exportedJson!) as Map<String, dynamic>);
    expect(decoded, _document());
  });

  testWidgets('import replaces the document after confirmation',
      (tester) async {
    final port = _FakeDocumentFilePort()
      ..importText = jsonEncode(Document.empty(name: '読み込んだ表').toJson());
    final container = await pumpApp(
      tester,
      initialDocument: _document(),
      filePort: port,
    );

    await _selectMenuAction(tester, 'インポート');

    expect(
      find.textContaining('現在の内容を読み込んだファイルの内容で置き換えますか'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();

    final state = container.read(documentEditorProvider);
    expect(state.document.name, '読み込んだ表');
    // Import clears the undo history.
    expect(state.canUndo, isFalse);
  });

  testWidgets('import shows an error for an unreadable file', (tester) async {
    final port = _FakeDocumentFilePort()..importText = 'これはJSONではない';
    final container = await pumpApp(
      tester,
      initialDocument: _document(),
      filePort: port,
    );

    await _selectMenuAction(tester, 'インポート');

    expect(find.textContaining('ファイルを読み込めませんでした'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();
    expect(container.read(documentProvider).name, 'マイタイムテーブル');
  });

  testWidgets('new resets to an empty document then opens the initial dialog',
      (tester) async {
    final container = await pumpApp(tester, initialDocument: _document());

    await _selectMenuAction(tester, '新規作成');

    expect(find.textContaining('内容をすべてクリア'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();

    final state = container.read(documentEditorProvider);
    expect(state.document.slotCategories, isEmpty);
    expect(state.document.name, 'タイムテーブル');
    expect(state.canUndo, isTrue);
    expect(find.text('初期タイムライン作成'), findsOneWidget);
  });

  testWidgets('Ctrl+Z / Ctrl+Shift+Z drive undo and redo', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    try {
      final container = await pumpApp(tester, initialDocument: _document());
      await tester.pump(); // Let the shortcut scope's autofocus take effect.

      container
          .read(documentEditorProvider.notifier)
          .renameDocument('変更後の名前');
      await tester.pump();

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyZ);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      expect(container.read(documentProvider).name, 'マイタイムテーブル');

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyZ);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pump();
      expect(container.read(documentProvider).name, '変更後の名前');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
