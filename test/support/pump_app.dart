import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/files/document_file_port.dart';
import 'package:timetablist/l10n/generated/s.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';
import 'package:timetablist/ui/app_shell.dart';
import 'package:timetablist/ui/app_theme.dart';

import 'recording_document_store.dart';

/// Pumps the full app shell (Japanese locale) with a fresh container.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  Document? initialDocument,
  DocumentFilePort? filePort,
  bool promptInitialTimeline = false,
}) async {
  final container = ProviderContainer(
    overrides: [
      initialDocumentProvider.overrideWithValue(
        initialDocument ?? Document.empty(name: 'タイムテーブル'),
      ),
      documentStoreProvider.overrideWithValue(RecordingDocumentStore()),
      if (filePort != null)
        documentFilePortProvider.overrideWithValue(filePort),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        locale: const Locale('ja'),
        theme: appTheme,
        home: AppShell(promptInitialTimeline: promptInitialTimeline),
      ),
    ),
  );
  return container;
}
