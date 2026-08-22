import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/l10n/generated/s.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';
import 'package:timetablist/ui/app_shell.dart';
import 'package:timetablist/ui/app_theme.dart';
import 'package:timetablist/ui/dialogs/participant_create_dialog.dart';
import 'package:timetablist/ui/dialogs/slot_category_create_dialog.dart';
import 'package:timetablist/ui/dialogs/timeline_create_dialog.dart';

import '../support/recording_document_store.dart';

// Golden tests use English strings: the test environment does not bundle a
// CJK font, so Japanese text would render as tofu.

Document _sampleDocument() {
  return Document(
    name: 'Timetable',
    slotCategories: const [
      SlotCategory(
        id: 'perf',
        name: 'Performance',
        durationMinutes: 30,
        isPerformanceSlot: true,
      ),
      SlotCategory(
        id: 'gap',
        name: 'Changeover',
        durationMinutes: 10,
        isPerformanceSlot: false,
      ),
    ],
    participants: const [
      Participant(id: 'bob', name: 'Bob'),
      Participant(id: 'carol', name: 'Carol'),
    ],
  );
}

/// Pumps [widget] inside a provider scope and an English-locale app.
Future<void> _pumpApp(
  WidgetTester tester,
  Widget widget, {
  Document? document,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        initialDocumentProvider.overrideWithValue(
          document ?? Document.empty(name: 'Timetable'),
        ),
        documentStoreProvider.overrideWithValue(RecordingDocumentStore()),
      ],
      child: MaterialApp(
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        locale: const Locale('en'),
        theme: appTheme,
        home: Scaffold(body: Center(child: widget)),
      ),
    ),
  );
}

void main() {
  goldenTest(
    'creation dialogs',
    fileName: 'creation_dialogs',
    pumpWidget: (tester, widget) =>
        _pumpApp(tester, widget, document: _sampleDocument()),
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'slot category create dialog',
          child: const SizedBox(
            width: 400,
            child: ExcludeFocus(child: SlotCategoryCreateDialog()),
          ),
        ),
        GoldenTestScenario(
          name: 'participant create dialog',
          child: const SizedBox(
            width: 400,
            child: ExcludeFocus(child: ParticipantCreateDialog()),
          ),
        ),
        GoldenTestScenario(
          name: 'timeline create dialog',
          child: const SizedBox(
            width: 400,
            child: ExcludeFocus(child: TimelineCreateDialog()),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'app shell',
    fileName: 'app_shell',
    pumpWidget: (tester, widget) =>
        _pumpApp(tester, widget, document: _sampleDocument()),
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'with categories and participants',
          child: const SizedBox(
            width: 1000,
            height: 640,
            child: AppShell(promptInitialTimeline: false),
          ),
        ),
      ],
    ),
  );
}
