import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/l10n/generated/s.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';
import 'package:timetablist/ui/app_shell.dart';
import 'package:timetablist/ui/sheets/participant_create_sheet.dart';
import 'package:timetablist/ui/sheets/slot_category_create_sheet.dart';
import 'package:timetablist/ui/sheets/timeline_create_sheet.dart';
import 'package:timetablist/ui/widgets/requirements_editor.dart';

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
    participants: [
      const Participant(id: 'bob', name: 'Bob'),
      Participant(
        id: 'carol',
        name: 'Carol',
        requirements: ParticipantRequirements(
          minDurationMinutes: 30,
          finishBy: TimelineTime.parse('21:00'),
        ),
      ),
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: Scaffold(body: Center(child: widget)),
      ),
    ),
  );
}

void main() {
  goldenTest(
    'requirements editor',
    fileName: 'requirements_editor',
    pumpWidget: (tester, widget) => _pumpApp(tester, widget),
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'all unchecked',
          child: SizedBox(
            width: 320,
            child: RequirementsEditor(
              initialValue: const ParticipantRequirements(),
              onChanged: (_) {},
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'partially filled',
          child: SizedBox(
            width: 320,
            child: RequirementsEditor(
              initialValue: ParticipantRequirements(
                minDurationMinutes: 30,
                finishBy: TimelineTime.parse('21:00'),
                preferredOrderFrom: 2,
              ),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    ),
  );

  goldenTest(
    'creation sheets',
    fileName: 'creation_sheets',
    pumpWidget: (tester, widget) =>
        _pumpApp(tester, widget, document: _sampleDocument()),
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'slot category create sheet',
          child: const SizedBox(
            width: 400,
            // ExcludeFocus keeps the autofocused field's cursor out of the
            // golden so the image stays deterministic. The Material stands in
            // for the one a real bottom sheet provides.
            child: ExcludeFocus(
              child: Material(child: SlotCategoryCreateSheet()),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'participant create sheet',
          child: const SizedBox(
            width: 400,
            child: ExcludeFocus(
              child: Material(child: ParticipantCreateSheet()),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'timeline create sheet',
          child: const SizedBox(
            width: 400,
            height: 560,
            child: ExcludeFocus(
              child: Material(child: TimelineCreateSheet()),
            ),
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
            child: AppShell(),
          ),
        ),
      ],
    ),
  );
}
