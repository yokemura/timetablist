import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:timetablist/l10n/generated/s.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/ui/app_theme.dart';
import 'package:timetablist/ui/widgets/commit_int_field.dart';
import 'package:timetablist/ui/widgets/commit_text_field.dart';
import 'package:timetablist/ui/widgets/commit_time_field.dart';
import 'package:timetablist/ui/widgets/warning_text.dart';

// Golden tests use English strings: the test environment does not bundle a
// CJK font, so Japanese text would render as tofu.
void main() {
  goldenTest(
    'common input widgets',
    fileName: 'common_widgets',
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
          name: 'commit text field',
          child: SizedBox(
            width: 240,
            child: CommitTextField(
              value: 'Performance',
              label: 'Name',
              onCommit: (_) {},
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'commit int field',
          child: SizedBox(
            width: 240,
            child: CommitIntField(
              value: 30,
              label: 'Duration (min)',
              onCommit: (_) {},
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'commit time field',
          child: SizedBox(
            width: 240,
            child: CommitTimeField(
              value: TimelineTime.fromHoursAndMinutes(hour: 25, minute: 5),
              label: 'Start time',
              onCommit: (_) {},
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'warning text',
          child: const WarningText('Requirement mismatch'),
        ),
      ],
    ),
  );
}
