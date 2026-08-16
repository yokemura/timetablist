import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetablist/l10n/generated/s.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/state/state.dart';
import 'package:timetablist/ui/panes/property/document_property_view.dart';
import 'package:timetablist/ui/panes/property/participant_property_view.dart';
import 'package:timetablist/ui/panes/property/slot_category_property_view.dart';
import 'package:timetablist/ui/panes/property/slot_property_view.dart';
import 'package:timetablist/ui/panes/property/timeline_property_view.dart';

import '../../support/recording_document_store.dart';

// Golden tests use English strings: the test environment does not bundle a
// CJK font, so Japanese text would render as tofu.

/// One timeline (performance / changeover / performance); Alice is assigned
/// to the first performance slot and violates her min-duration requirement so
/// the slot view shows the violation list.
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
      Participant(
        id: 'alice',
        name: 'Alice',
        requirements: ParticipantRequirements(
          minDurationMinutes: 60,
          finishBy: TimelineTime.parse('21:00'),
        ),
      ),
      const Participant(id: 'bob', name: 'Bob'),
    ],
    timelines: [
      Timeline(
        id: 'day1',
        name: 'Hall A',
        startTime: TimelineTime.parse('10:00'),
        slots: const [
          Slot(id: 's1', categoryId: 'perf', participantId: 'alice'),
          Slot(id: 's2', categoryId: 'gap'),
          Slot(id: 's3', categoryId: 'perf'),
        ],
      ),
    ],
  );
}

Widget _scoped(Widget view, {required double height}) {
  return ProviderScope(
    overrides: [
      initialDocumentProvider.overrideWithValue(_sampleDocument()),
      documentStoreProvider.overrideWithValue(RecordingDocumentStore()),
    ],
    child: SizedBox(width: 300, height: height, child: view),
  );
}

void main() {
  goldenTest(
    'property pane views',
    fileName: 'property_pane_views',
    pumpWidget: (tester, widget) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          locale: const Locale('en'),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          ),
          home: Scaffold(body: Center(child: widget)),
        ),
      );
    },
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'document',
          child: _scoped(const DocumentPropertyView(), height: 100),
        ),
        GoldenTestScenario(
          name: 'timeline',
          child: _scoped(
            const TimelinePropertyView(timelineId: 'day1'),
            height: 420,
          ),
        ),
        GoldenTestScenario(
          name: 'slot category',
          child: _scoped(
            const SlotCategoryPropertyView(categoryId: 'perf'),
            height: 320,
          ),
        ),
        GoldenTestScenario(
          name: 'slot with participant and violation',
          child: _scoped(
            const SlotPropertyView(timelineId: 'day1', slotId: 's1'),
            height: 1100,
          ),
        ),
        GoldenTestScenario(
          name: 'participant',
          child: _scoped(
            const ParticipantPropertyView(participantId: 'bob'),
            height: 640,
          ),
        ),
      ],
    ),
  );
}
