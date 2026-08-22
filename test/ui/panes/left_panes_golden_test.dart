import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:timetablist/l10n/generated/s.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/ui/widgets/participant_list_item.dart';
import 'package:timetablist/ui/widgets/slot_category_list_item.dart';

// Golden tests use English strings: the test environment does not bundle a
// CJK font, so Japanese text would render as tofu.
void main() {
  goldenTest(
    'left pane list items',
    fileName: 'left_pane_list_items',
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
          name: 'slot category (performance)',
          child: SizedBox(
            width: 240,
            child: SlotCategoryListItem(
              category: const SlotCategory(
                id: 'c1',
                name: 'Performance',
                durationMinutes: 30,
                isPerformanceSlot: true,
              ),
              selected: false,
              onTap: () {},
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'slot category (selected, non-performance)',
          child: SizedBox(
            width: 240,
            child: SlotCategoryListItem(
              category: const SlotCategory(
                id: 'c2',
                name: 'Changeover',
                durationMinutes: 10,
                isPerformanceSlot: false,
              ),
              selected: true,
              onTap: () {},
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'participant',
          child: SizedBox(
            width: 240,
            child: ParticipantListItem(
              participant: const Participant(id: 'p1', name: 'Alice'),
              selected: false,
              onTap: () {},
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'participant (selected)',
          child: SizedBox(
            width: 240,
            child: ParticipantListItem(
              participant: const Participant(id: 'p2', name: 'Bob'),
              selected: true,
              onTap: () {},
            ),
          ),
        ),
      ],
    ),
  );
}
