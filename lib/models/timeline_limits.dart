/// Domain limits for timelines and slots.
abstract final class TimelineLimits {
  /// Latest representable clock time on a timeline (`30:00`).
  static const int maxHour = 30;

  /// [maxHour] expressed as minutes from midnight.
  static const int maxMinutesFromMidnight = maxHour * 60;

  /// Maximum slot duration in minutes (same as [maxMinutesFromMidnight]).
  static const int maxSlotDurationMinutes = maxMinutesFromMidnight;
}
