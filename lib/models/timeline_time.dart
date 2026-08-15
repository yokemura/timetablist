import 'package:freezed_annotation/freezed_annotation.dart';

import 'timeline_limits.dart';

/// Clock time on a timeline, measured from midnight.
///
/// Hours may exceed 24 so a timeline can run past midnight without changing
/// dates (up to [TimelineLimits.maxHour]). Display uses 24-hour style without
/// zero-padding the hour, e.g. `8:05` or `25:00`.
@immutable
class TimelineTime implements Comparable<TimelineTime> {
  const TimelineTime(this.minutesFromMidnight)
    : assert(minutesFromMidnight >= 0, 'Time cannot be negative');

  factory TimelineTime.fromHoursAndMinutes({
    required int hour,
    required int minute,
  }) {
    if (minute < 0 || minute > 59) {
      throw ArgumentError.value(minute, 'minute', 'Must be in 0–59');
    }
    if (hour < 0) {
      throw ArgumentError.value(hour, 'hour', 'Must be >= 0');
    }
    return TimelineTime(hour * 60 + minute);
  }

  /// Parses `H:mm` or `HH:mm` (hour may be greater than 23).
  factory TimelineTime.parse(String value) {
    final parts = value.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid time "$value"');
    }
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimelineTime.fromHoursAndMinutes(hour: hour, minute: minute);
  }

  static const midnight = TimelineTime(0);
  static const max = TimelineTime(TimelineLimits.maxMinutesFromMidnight);

  final int minutesFromMidnight;

  int get hour => minutesFromMidnight ~/ 60;
  int get minute => minutesFromMidnight % 60;

  /// Whether this time is at or before the timeline maximum (`30:00`).
  bool get isWithinMax =>
      minutesFromMidnight <= TimelineLimits.maxMinutesFromMidnight;

  String toDisplayString() => '$hour:${minute.toString().padLeft(2, '0')}';

  TimelineTime addMinutes(int minutes) =>
      TimelineTime(minutesFromMidnight + minutes);

  TimelineTime operator +(Duration duration) => addMinutes(duration.inMinutes);

  Duration difference(TimelineTime other) =>
      Duration(minutes: minutesFromMidnight - other.minutesFromMidnight);

  bool operator <(TimelineTime other) => compareTo(other) < 0;
  bool operator <=(TimelineTime other) => compareTo(other) <= 0;
  bool operator >(TimelineTime other) => compareTo(other) > 0;
  bool operator >=(TimelineTime other) => compareTo(other) >= 0;

  @override
  int compareTo(TimelineTime other) =>
      minutesFromMidnight.compareTo(other.minutesFromMidnight);

  @override
  bool operator ==(Object other) =>
      other is TimelineTime && other.minutesFromMidnight == minutesFromMidnight;

  @override
  int get hashCode => minutesFromMidnight.hashCode;

  @override
  String toString() => toDisplayString();
}

/// Serializes [TimelineTime] as a display string such as `8:05`.
class TimelineTimeConverter implements JsonConverter<TimelineTime, String> {
  const TimelineTimeConverter();

  @override
  TimelineTime fromJson(String json) => TimelineTime.parse(json);

  @override
  String toJson(TimelineTime object) => object.toDisplayString();
}
