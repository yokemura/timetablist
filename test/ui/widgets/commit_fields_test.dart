import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/l10n/generated/s.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/ui/widgets/commit_int_field.dart';
import 'package:timetablist/ui/widgets/commit_text_field.dart';
import 'package:timetablist/ui/widgets/commit_time_field.dart';

Future<void> pumpField(WidgetTester tester, Widget field) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      locale: const Locale('ja'),
      home: Scaffold(body: Center(child: SizedBox(width: 240, child: field))),
    ),
  );
}

Future<void> unfocus(WidgetTester tester) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pump();
}

void main() {
  group('CommitTextField', () {
    testWidgets('commits on Enter, not per keystroke', (tester) async {
      final commits = <String>[];
      await pumpField(
        tester,
        CommitTextField(value: '出演枠', onCommit: commits.add),
      );

      await tester.enterText(find.byType(TextField), '演奏');
      expect(commits, isEmpty);

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(commits, ['演奏']);
    });

    testWidgets('commits on focus loss', (tester) async {
      final commits = <String>[];
      await pumpField(
        tester,
        CommitTextField(value: '出演枠', onCommit: commits.add),
      );

      await tester.enterText(find.byType(TextField), '転換');
      await unfocus(tester);
      expect(commits, ['転換']);
    });

    testWidgets('does not commit an unchanged value', (tester) async {
      final commits = <String>[];
      await pumpField(
        tester,
        CommitTextField(value: '出演枠', onCommit: commits.add),
      );

      await tester.enterText(find.byType(TextField), '出演枠');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(commits, isEmpty);
    });

    testWidgets('invalid input is not committed and reverts on unfocus',
        (tester) async {
      final commits = <String>[];
      await pumpField(
        tester,
        CommitTextField(
          value: '出演枠',
          validator: (text) => text.isEmpty ? '必須です' : null,
          onCommit: commits.add,
        ),
      );

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      // The error is shown live while typing, but nothing is committed.
      expect(find.text('必須です'), findsOneWidget);
      expect(commits, isEmpty);

      // Enter also drops focus, which reverts to the last committed value.
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await unfocus(tester);
      expect(commits, isEmpty);
      expect(find.text('出演枠'), findsOneWidget);
      expect(find.text('必須です'), findsNothing);
    });
  });

  group('CommitIntField', () {
    testWidgets('commits a valid integer', (tester) async {
      final commits = <int>[];
      await pumpField(
        tester,
        CommitIntField(value: 30, max: 1800, onCommit: commits.add),
      );

      await tester.enterText(find.byType(TextField), '45');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(commits, [45]);
    });

    testWidgets('rejects non-integers and out-of-range values',
        (tester) async {
      final commits = <int>[];
      await pumpField(
        tester,
        CommitIntField(value: 30, min: 1, max: 1800, onCommit: commits.add),
      );

      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pump();
      expect(find.text('整数を入力してください'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '0');
      await tester.pump();
      expect(find.text('1以上を入力してください'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '1801');
      await tester.pump();
      expect(find.text('1800以下を入力してください'), findsOneWidget);

      // Confirming invalid input commits nothing and reverts the text.
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await unfocus(tester);
      expect(commits, isEmpty);
      expect(find.text('30'), findsOneWidget);
    });
  });

  group('CommitTimeField', () {
    testWidgets('commits times past 24:00', (tester) async {
      final commits = <TimelineTime>[];
      await pumpField(
        tester,
        CommitTimeField(value: TimelineTime.midnight, onCommit: commits.add),
      );

      await tester.enterText(find.byType(TextField), '25:05');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(commits, [
        TimelineTime.fromHoursAndMinutes(hour: 25, minute: 5),
      ]);
    });

    testWidgets('rejects malformed and out-of-range times', (tester) async {
      final commits = <TimelineTime>[];
      await pumpField(
        tester,
        CommitTimeField(value: TimelineTime.midnight, onCommit: commits.add),
      );

      await tester.enterText(find.byType(TextField), '2505');
      await tester.pump();
      expect(
        find.text('時刻を「時:分」形式で入力してください（例: 25:05）'),
        findsOneWidget,
      );

      await tester.enterText(find.byType(TextField), '30:01');
      await tester.pump();
      expect(find.text('0:00〜30:00の範囲で入力してください'), findsOneWidget);

      // Confirming invalid input commits nothing and reverts the text.
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await unfocus(tester);
      expect(commits, isEmpty);
      expect(find.text('0:00'), findsOneWidget);
    });
  });
}
