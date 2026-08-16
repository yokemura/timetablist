import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/l10n/generated/s.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';
import 'package:timetablist/ui/app_shell.dart';

import 'recording_document_store.dart';

/// Pumps the full app shell (Japanese locale) with a fresh container.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  Document? initialDocument,
}) async {
  final container = ProviderContainer(
    overrides: [
      initialDocumentProvider.overrideWithValue(
        initialDocument ?? Document.empty(name: 'タイムテーブル'),
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
