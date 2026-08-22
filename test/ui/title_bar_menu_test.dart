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
  String? savedFileName;
  String? savedContents;
  String? savedMimeType;
  String? importText;
  Object? saveError;
  var importCallCount = 0;

  @override
  Future<void> saveFile({
    required String fileName,
    required String contents,
    required String mimeType,
  }) async {
    if (saveError != null) throw saveError!;
    savedFileName = fileName;
    savedContents = contents;
    savedMimeType = mimeType;
  }

  @override
  Future<String?> importJson() async {
    importCallCount += 1;
    return importText;
  }
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
  testWidgets('save file hands the document JSON to the file port', (
    tester,
  ) async {
    final port = _FakeDocumentFilePort();
    await pumpApp(tester, initialDocument: _document(), filePort: port);

    await _selectMenuAction(tester, 'ファイルに保存');

    expect(port.savedFileName, 'マイタイムテーブル.json');
    expect(port.savedMimeType, 'application/json');
    final decoded = Document.fromJson(
      jsonDecode(port.savedContents!) as Map<String, dynamic>,
    );
    expect(decoded, _document());
  });

  testWidgets('export CSV hands a spreadsheet CSV to the file port', (
    tester,
  ) async {
    final port = _FakeDocumentFilePort();
    await pumpApp(tester, initialDocument: _document(), filePort: port);

    await _selectMenuAction(tester, 'CSVエクスポート');

    expect(port.savedFileName, 'マイタイムテーブル.csv');
    expect(port.savedMimeType, 'text/csv');
    expect(port.savedContents, startsWith('\uFEFF'));
    expect(port.savedContents, contains('開始時刻,終了時刻,時間長,枠タイプ名,演者名'));
  });

  testWidgets('save file shows an error when writing fails', (tester) async {
    final port = _FakeDocumentFilePort()..saveError = Exception('disk');
    await pumpApp(tester, initialDocument: _document(), filePort: port);

    await _selectMenuAction(tester, 'ファイルに保存');

    expect(find.textContaining('ファイルを書き出せませんでした'), findsOneWidget);
  });

  testWidgets('import replaces the document after confirmation', (
    tester,
  ) async {
    final port = _FakeDocumentFilePort()
      ..importText = jsonEncode(Document.empty(name: '読み込んだ表').toJson());
    final container = await pumpApp(
      tester,
      initialDocument: _document(),
      filePort: port,
    );

    await _selectMenuAction(tester, 'ファイルを読み込む');

    expect(find.textContaining('現在の内容を読み込んだファイルの内容で置き換えますか'), findsOneWidget);
    expect(port.importCallCount, 0);
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();

    expect(port.importCallCount, 1);

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

    await _selectMenuAction(tester, 'ファイルを読み込む');

    expect(find.textContaining('現在の内容を読み込んだファイルの内容で置き換えますか'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();

    expect(find.textContaining('ファイルを読み込めませんでした'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'OK'));
    await tester.pumpAndSettle();
    expect(container.read(documentProvider).name, 'マイタイムテーブル');
  });

  testWidgets('import cancel on overwrite confirmation does not pick a file', (
    tester,
  ) async {
    final port = _FakeDocumentFilePort()
      ..importText = jsonEncode(Document.empty(name: '読み込んだ表').toJson());
    final container = await pumpApp(
      tester,
      initialDocument: _document(),
      filePort: port,
    );

    await _selectMenuAction(tester, 'ファイルを読み込む');
    await tester.tap(find.widgetWithText(TextButton, 'キャンセル'));
    await tester.pumpAndSettle();

    expect(port.importCallCount, 0);
    expect(container.read(documentProvider).name, 'マイタイムテーブル');
  });

  testWidgets('new resets to an empty document then opens the initial dialog', (
    tester,
  ) async {
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

      container.read(documentEditorProvider.notifier).renameDocument('変更後の名前');
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
