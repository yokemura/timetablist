import 'package:flutter_test/flutter_test.dart';
import 'package:timetablist/models/models.dart';
import 'package:timetablist/ui/timeline/time_layout.dart';

void main() {
  group('TimeLayout', () {
    test('empty scale spans 0:00–30:00 at the default density', () {
      final layout = TimeLayout.empty();
      expect(layout.yOf(TimelineTime.midnight), 0);
      expect(
        layout.yOf(TimelineTime.max),
        TimelineLimits.maxMinutesFromMidnight *
            TimeLayout.defaultPixelsPerMinute,
      );
      expect(
        layout.yOf(TimeLayout.afterMidnight),
        24 * 60 * TimeLayout.defaultPixelsPerMinute,
      );
    });

    test('a short slot stretches only its own interval', () {
      final start = TimelineTime.parse('10:00');
      final end = TimelineTime.parse('10:10');
      final layout = TimeLayout.fromDemands([
        TimeSpanDemand(start: start, end: end, minHeight: 40),
      ]);

      expect(layout.heightOf(start, end), 40);
      // Time outside the slot keeps the default density.
      expect(
        layout.heightOf(TimelineTime.midnight, TimelineTime.parse('10:00')),
        10 * 60 * TimeLayout.defaultPixelsPerMinute,
      );
    });

    test('the denser of two overlapping lanes wins; same time → same Y', () {
      // Lane A: 10 minutes that need 40px (4 px/min).
      // Lane B: 60 minutes that need 60px (1 px/min).
      final ten = TimelineTime.parse('10:00');
      final tenTen = TimelineTime.parse('10:10');
      final eleven = TimelineTime.parse('11:00');
      final layout = TimeLayout.fromDemands([
        TimeSpanDemand(start: ten, end: tenTen, minHeight: 40),
        TimeSpanDemand(start: ten, end: eleven, minHeight: 60),
      ]);

      expect(layout.yOf(ten), layout.yOf(TimelineTime.parse('10:00')));
      expect(layout.heightOf(ten, tenTen), 40);
      // The remaining 50 minutes of B stay at 1 px/min, so B is 40+50.
      expect(layout.heightOf(ten, eleven), 90);
    });

    test('timeOf is the inverse of yOf at hour marks', () {
      final layout = TimeLayout.fromDemands([
        TimeSpanDemand(
          start: TimelineTime.parse('8:00'),
          end: TimelineTime.parse('8:30'),
          minHeight: 80,
        ),
      ]);
      for (final hour in [0, 8, 9, 24, 30]) {
        final time = TimelineTime.fromHoursAndMinutes(hour: hour, minute: 0);
        expect(layout.timeOf(layout.yOf(time)), time);
      }
    });
  });
}
