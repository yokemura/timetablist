import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/l10n/generated/s.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';
import 'package:timetablist/ui/ad_area.dart';
import 'package:timetablist/ui/app_shell.dart';
import 'package:timetablist/ui/four_pane_layout.dart';
import 'package:timetablist/ui/panes/participant_pane.dart';
import 'package:timetablist/ui/panes/property_pane.dart';
import 'package:timetablist/ui/panes/slot_category_pane.dart';
import 'package:timetablist/ui/panes/timeline_pane.dart';

import '../support/recording_document_store.dart';

Future<ProviderContainer> pumpShell(WidgetTester tester) async {
  final container = ProviderContainer(
    overrides: [
      initialDocumentProvider.overrideWithValue(
        Document.empty(name: 'タイムテーブル'),
      ),
      documentStoreProvider.overrideWithValue(RecordingDocumentStore()),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        locale: Locale('ja'),
        home: AppShell(),
      ),
    ),
  );
  return container;
}

void main() {
  testWidgets('shows title bar, four panes, and the ad area', (tester) async {
    await pumpShell(tester);

    expect(find.text('Timetablist by YMCK'), findsOneWidget);
    expect(find.byType(SlotCategoryPane), findsOneWidget);
    expect(find.byType(ParticipantPane), findsOneWidget);
    expect(find.byType(TimelinePane), findsOneWidget);
    expect(find.byType(PropertyPane), findsOneWidget);
    expect(find.byType(AdArea), findsOneWidget);
    expect(tester.getSize(find.byType(AdArea)).height, AdArea.height);
  });

  testWidgets('menu lists all actions; undo/redo start disabled',
      (tester) async {
    await pumpShell(tester);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.text('エクスポート'), findsOneWidget);
    expect(find.text('インポート'), findsOneWidget);
    expect(find.text('クリア（新規作成）'), findsOneWidget);
    expect(find.text('取り消す'), findsOneWidget);
    expect(find.text('やり直す'), findsOneWidget);

    PopupMenuItem<dynamic> itemOf(String label) => tester.widget(
      find.ancestor(
        of: find.text(label),
        matching: find.byWidgetPredicate((w) => w is PopupMenuItem),
      ),
    ) as PopupMenuItem<dynamic>;
    expect(itemOf('取り消す').enabled, isFalse);
    expect(itemOf('やり直す').enabled, isFalse);
  });

  testWidgets('undo menu item becomes enabled and undoes a change',
      (tester) async {
    final container = await pumpShell(tester);
    container.read(documentEditorProvider.notifier).renameDocument('ライブA');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取り消す'));
    await tester.pumpAndSettle();

    expect(container.read(documentProvider).name, 'タイムテーブル');
  });

  testWidgets('pane boundaries can be dragged to resize', (tester) async {
    await pumpShell(tester);

    final before = tester.getSize(find.byType(SlotCategoryPane)).width;
    await tester.drag(
      find.byKey(FourPaneLayout.leftHandleKey),
      const Offset(60, 0),
    );
    await tester.pump();
    final after = tester.getSize(find.byType(SlotCategoryPane)).width;
    expect(after, before + 60);

    final topBefore = tester.getSize(find.byType(SlotCategoryPane)).height;
    await tester.drag(
      find.byKey(FourPaneLayout.leftSplitHandleKey),
      const Offset(0, -40),
    );
    await tester.pump();
    final topAfter = tester.getSize(find.byType(SlotCategoryPane)).height;
    expect(topAfter, lessThan(topBefore));
  });
}
