import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:timetablist/l10n/generated/s.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/ui/app_theme.dart';
import 'package:timetablist/ui/widgets/drag_ghosts.dart';

// Golden tests use English strings: the test environment does not bundle a
// CJK font, so Japanese text would render as tofu.
void main() {
  goldenTest(
    'drag ghosts',
    fileName: 'drag_ghosts',
    pumpWidget: (tester, widget) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          locale: const Locale('en'),
          theme: appTheme,
          home: Scaffold(body: Center(child: widget)),
        ),
      );
    },
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(
          name: 'slot category ghost (height follows duration)',
          child: const SlotCategoryDragGhost(
            category: SlotCategory(
              id: 'perf',
              name: 'Performance',
              durationMinutes: 60,
              isPerformanceSlot: true,
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'short slot category ghost (minimum height)',
          child: const SlotCategoryDragGhost(
            category: SlotCategory(
              id: 'gap',
              name: 'Changeover',
              durationMinutes: 10,
              isPerformanceSlot: false,
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'participant ghost',
          child: const ParticipantDragGhost(
            participant: Participant(id: 'alice', name: 'Alice'),
          ),
        ),
      ],
    ),
  );
}
