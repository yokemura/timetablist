import 'dart:math' as math;

import '../../models/models.dart';

/// A slot (or other span) that needs at least [minHeight] between two times.
class TimeSpanDemand {
  const TimeSpanDemand({
    required this.start,
    required this.end,
    required this.minHeight,
  });

  final TimelineTime start;
  final TimelineTime end;
  final double minHeight;
}

/// Shared conversion between [TimelineTime] and vertical pixels.
///
/// The mapping is piecewise-linear: empty time uses
/// [defaultPixelsPerMinute], while placed slots raise the local density so
/// they reach their minimum height. Multiple lanes share one layout, so the
/// same clock time is always at the same Y.
class TimeLayout {
  TimeLayout._(this._minutes, this._ys)
    : assert(_minutes.length == _ys.length),
      assert(_minutes.length >= 2);

  /// Pixels used for one minute when nothing is stretching the scale.
  static const defaultPixelsPerMinute = 1.0;

  /// Floor height of a slot, even when its duration is very short.
  static const minSlotHeight = 40.0;

  static const slotTitleHeight = 22.0;
  static const participantPadding = 6.0;
  static const participantNameHeight = 28.0;
  static const warningHeight = 16.0;

  /// First clock time that uses the "past midnight" (darker) treatment.
  static const afterMidnight = TimelineTime(24 * 60);

  final List<int> _minutes;
  final List<double> _ys;

  /// Full 0:00–30:00 scale at the default density, with no slot stretch.
  factory TimeLayout.empty() => TimeLayout.fromDemands(const []);

  factory TimeLayout.fromDemands(Iterable<TimeSpanDemand> demands) {
    final points = <int>{
      0,
      TimelineLimits.maxMinutesFromMidnight,
    };
    for (final demand in demands) {
      points.add(demand.start.minutesFromMidnight);
      points.add(demand.end.minutesFromMidnight);
    }
    final times = points.toList()..sort();

    final heights = <double>[];
    for (var i = 0; i < times.length - 1; i++) {
      final intervalStart = times[i];
      final intervalEnd = times[i + 1];
      final minutes = intervalEnd - intervalStart;
      var pxPerMin = defaultPixelsPerMinute;
      for (final demand in demands) {
        final start = demand.start.minutesFromMidnight;
        final end = demand.end.minutesFromMidnight;
        if (end <= start) continue;
        if (start <= intervalStart && end >= intervalEnd) {
          pxPerMin = math.max(pxPerMin, demand.minHeight / (end - start));
        }
      }
      heights.add(pxPerMin * minutes);
    }

    final ys = <double>[0];
    for (final height in heights) {
      ys.add(ys.last + height);
    }
    return TimeLayout._(times, ys);
  }

  /// Builds a layout from every placed slot in [document].
  ///
  /// [measureSlot] returns the minimum height a slot needs; it defaults to
  /// the [slotMinHeight] heuristic. Pass a text-measuring implementation
  /// (see `SlotHeightMeasurer`) so wrapped participant names fit.
  factory TimeLayout.fromDocument(
    Document document, {
    double Function(PlacedSlot placed)? measureSlot,
  }) {
    final measure = measureSlot ??
        (placed) => slotMinHeight(
              durationMinutes: placed.durationMinutes,
              hasParticipant: placed.participant != null,
              hasWarning: false,
            );
    return TimeLayout.fromDemands([
      for (final timeline in document.timelines)
        for (final placed in document.placedSlotsOf(timeline))
          TimeSpanDemand(
            start: placed.startTime,
            end: placed.endTime,
            minHeight: measure(placed),
          ),
    ]);
  }

  /// Height a slot needs: the larger of the floor, the duration at the
  /// default density, and the space required for its contents.
  static double slotMinHeight({
    required int durationMinutes,
    required bool hasParticipant,
    required bool hasWarning,
  }) {
    var content = slotTitleHeight;
    if (hasParticipant) {
      content += participantPadding * 2 + participantNameHeight;
      if (hasWarning) content += warningHeight;
    }
    return math.max(
      minSlotHeight,
      math.max(durationMinutes * defaultPixelsPerMinute, content),
    );
  }

  double get totalHeight => _ys.last;

  double yOf(TimelineTime time) {
    final minutes = time.minutesFromMidnight;
    if (minutes <= _minutes.first) return _ys.first;
    if (minutes >= _minutes.last) return _ys.last;
    final index = _indexAtOrBefore(minutes);
    return _lerp(
      _minutes[index],
      _minutes[index + 1],
      _ys[index],
      _ys[index + 1],
      minutes,
    );
  }

  /// Inverse of [yOf]. Values outside the scale clamp to 0:00 / 30:00.
  TimelineTime timeOf(double y) {
    if (y <= _ys.first) return TimelineTime(_minutes.first);
    if (y >= _ys.last) return TimelineTime(_minutes.last);
    var index = 0;
    while (index < _ys.length - 2 && _ys[index + 1] < y) {
      index += 1;
    }
    final minutes = _lerp(
      _ys[index],
      _ys[index + 1],
      _minutes[index].toDouble(),
      _minutes[index + 1].toDouble(),
      y,
    );
    return TimelineTime(minutes.round());
  }

  double heightOf(TimelineTime start, TimelineTime end) =>
      yOf(end) - yOf(start);

  int _indexAtOrBefore(int minutes) {
    var low = 0;
    var high = _minutes.length - 2;
    while (low < high) {
      final mid = (low + high + 1) >> 1;
      if (_minutes[mid] <= minutes) {
        low = mid;
      } else {
        high = mid - 1;
      }
    }
    return low;
  }

  static double _lerp(
    num x0,
    num x1,
    double y0,
    double y1,
    num x,
  ) {
    if (x1 == x0) return y0;
    final t = (x - x0) / (x1 - x0);
    return y0 + (y1 - y0) * t;
  }
}
