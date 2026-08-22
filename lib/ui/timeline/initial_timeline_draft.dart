import '../../models/models.dart';

/// Kinds of slots the initial timeline template can produce, in sequence
/// order. Each kind maps to exactly one auto-created slot category.
enum InitialSlotKind {
  venuePrep,
  rehearsal,
  rehearsalChangeover,
  doors,
  performance,
  changeover,
  teardown,
}

/// Computed times of the initial-timeline form. Null values mean a required
/// input is still missing or invalid; [hasContradiction] means all inputs are
/// present but contradict each other (e.g. a derived duration would be zero
/// or negative, or the sequence is not continuous).
class InitialTimelineTimes {
  const InitialTimelineTimes({
    this.venuePrepMinutes,
    this.rehearsalStart,
    this.rehearsalEnd,
    this.doorsMinutes,
    this.showEnd,
    this.teardownMinutes,
    this.endTime,
    this.hasContradiction = false,
  });

  final int? venuePrepMinutes;
  final TimelineTime? rehearsalStart;
  final TimelineTime? rehearsalEnd;
  final int? doorsMinutes;

  /// End of the last performance slot (演目終了時刻).
  final TimelineTime? showEnd;
  final int? teardownMinutes;
  final TimelineTime? endTime;
  final bool hasContradiction;

  bool get exceedsMax => endTime != null && !endTime!.isWithinMax;
}

/// Live calculation of the initial-timeline template
/// (venue setup + rehearsal block + doors + N×performance + teardown).
///
/// The sequence must be continuous: gaps between the entered times are only
/// allowed where a block (venue setup / doors) absorbs them, and every
/// derived duration must be positive.
class InitialTimelineDraft {
  const InitialTimelineDraft({
    this.nameText = '',
    this.countText = '1',
    this.sequenceStartText = '10:00',
    this.hasVenuePrep = false,
    this.hasRehearsal = false,
    this.rehearsalStartText = '',
    this.rehearsalDurationText = '',
    this.hasRehearsalChangeover = false,
    this.rehearsalChangeoverText = '',
    this.hasDoors = false,
    this.performanceStartText = '10:00',
    this.performanceDurationText = '',
    this.hasChangeover = false,
    this.changeoverText = '',
    this.hasTeardown = false,
    this.teardownEndText = '',
  });

  final String nameText;
  final String countText;
  final String sequenceStartText;
  final bool hasVenuePrep;
  final bool hasRehearsal;

  /// Only meaningful when [hasVenuePrep] and [hasRehearsal]; without venue
  /// setup the rehearsal starts at the sequence start.
  final String rehearsalStartText;
  final String rehearsalDurationText;
  final bool hasRehearsalChangeover;
  final String rehearsalChangeoverText;

  /// Only meaningful when [hasRehearsal].
  final bool hasDoors;
  final String performanceStartText;
  final String performanceDurationText;
  final bool hasChangeover;
  final String changeoverText;
  final bool hasTeardown;
  final String teardownEndText;

  InitialTimelineDraft copyWith({
    String? nameText,
    String? countText,
    String? sequenceStartText,
    bool? hasVenuePrep,
    bool? hasRehearsal,
    String? rehearsalStartText,
    String? rehearsalDurationText,
    bool? hasRehearsalChangeover,
    String? rehearsalChangeoverText,
    bool? hasDoors,
    String? performanceStartText,
    String? performanceDurationText,
    bool? hasChangeover,
    String? changeoverText,
    bool? hasTeardown,
    String? teardownEndText,
  }) {
    return InitialTimelineDraft(
      nameText: nameText ?? this.nameText,
      countText: countText ?? this.countText,
      sequenceStartText: sequenceStartText ?? this.sequenceStartText,
      hasVenuePrep: hasVenuePrep ?? this.hasVenuePrep,
      hasRehearsal: hasRehearsal ?? this.hasRehearsal,
      rehearsalStartText: rehearsalStartText ?? this.rehearsalStartText,
      rehearsalDurationText:
          rehearsalDurationText ?? this.rehearsalDurationText,
      hasRehearsalChangeover:
          hasRehearsalChangeover ?? this.hasRehearsalChangeover,
      rehearsalChangeoverText:
          rehearsalChangeoverText ?? this.rehearsalChangeoverText,
      hasDoors: hasDoors ?? this.hasDoors,
      performanceStartText: performanceStartText ?? this.performanceStartText,
      performanceDurationText:
          performanceDurationText ?? this.performanceDurationText,
      hasChangeover: hasChangeover ?? this.hasChangeover,
      changeoverText: changeoverText ?? this.changeoverText,
      hasTeardown: hasTeardown ?? this.hasTeardown,
      teardownEndText: teardownEndText ?? this.teardownEndText,
    );
  }

  String get name => nameText.trim();

  int? get performanceCount {
    final value = int.tryParse(countText.trim());
    if (value == null || value < 1) return null;
    return value;
  }

  TimelineTime? get sequenceStart =>
      TimelineTime.tryParse(sequenceStartText.trim());

  TimelineTime? get performanceStart =>
      TimelineTime.tryParse(performanceStartText.trim());

  TimelineTime? get teardownEnd => TimelineTime.tryParse(teardownEndText.trim());

  int? get rehearsalDuration => _positiveMinutes(rehearsalDurationText);

  int? get rehearsalChangeoverDuration =>
      _positiveMinutes(rehearsalChangeoverText);

  int? get performanceDuration => _positiveMinutes(performanceDurationText);

  int? get changeoverDuration => _positiveMinutes(changeoverText);

  /// Whether the doors block is effectively enabled (hidden and ignored when
  /// there is no rehearsal).
  bool get effectiveHasDoors => hasRehearsal && hasDoors;

  InitialTimelineTimes get times {
    final count = performanceCount;
    final seqStart = sequenceStart;
    final perfStart = performanceStart;
    final perfDuration = performanceDuration;
    if (count == null || seqStart == null || perfStart == null) {
      return const InitialTimelineTimes();
    }

    var contradiction = false;

    // Rehearsal block.
    TimelineTime? rehearsalStart;
    TimelineTime? rehearsalEnd;
    if (hasRehearsal) {
      rehearsalStart = hasVenuePrep
          ? TimelineTime.tryParse(rehearsalStartText.trim())
          : seqStart;
      final rehDuration = rehearsalDuration;
      if (rehearsalStart == null || rehDuration == null) {
        return const InitialTimelineTimes();
      }
      var minutes = count * rehDuration;
      if (hasRehearsalChangeover) {
        final changeover = rehearsalChangeoverDuration;
        if (changeover == null) {
          return InitialTimelineTimes(rehearsalStart: rehearsalStart);
        }
        minutes += (count - 1) * changeover;
      }
      rehearsalEnd = rehearsalStart.addMinutes(minutes);
    }

    // Venue setup absorbs the gap between the sequence start and the block
    // that follows it; without it the following block must start exactly at
    // the sequence start.
    final afterPrepStart = hasRehearsal ? rehearsalStart! : perfStart;
    int? venuePrepMinutes;
    if (hasVenuePrep) {
      venuePrepMinutes = afterPrepStart.difference(seqStart).inMinutes;
      if (venuePrepMinutes <= 0) contradiction = true;
    } else if (afterPrepStart != seqStart) {
      contradiction = true;
    }

    // Doors absorbs the gap between the rehearsal end and the performance
    // start; without it the performances must start right after rehearsal.
    int? doorsMinutes;
    if (hasRehearsal) {
      if (effectiveHasDoors) {
        doorsMinutes = perfStart.difference(rehearsalEnd!).inMinutes;
        if (doorsMinutes <= 0) contradiction = true;
      } else if (perfStart != rehearsalEnd) {
        contradiction = true;
      }
    }

    // Performance block.
    if (perfDuration == null) {
      return InitialTimelineTimes(
        venuePrepMinutes: venuePrepMinutes,
        rehearsalStart: rehearsalStart,
        rehearsalEnd: rehearsalEnd,
        doorsMinutes: doorsMinutes,
        hasContradiction: contradiction,
      );
    }
    var performanceMinutes = count * perfDuration;
    if (hasChangeover) {
      final changeover = changeoverDuration;
      if (changeover == null) {
        return InitialTimelineTimes(
          venuePrepMinutes: venuePrepMinutes,
          rehearsalStart: rehearsalStart,
          rehearsalEnd: rehearsalEnd,
          doorsMinutes: doorsMinutes,
          hasContradiction: contradiction,
        );
      }
      performanceMinutes += (count - 1) * changeover;
    }
    final showEnd = perfStart.addMinutes(performanceMinutes);

    // Teardown duration is derived from its entered end time.
    int? teardownMinutes;
    TimelineTime endTime = showEnd;
    if (hasTeardown) {
      final teardownEndTime = teardownEnd;
      if (teardownEndTime == null) {
        return InitialTimelineTimes(
          venuePrepMinutes: venuePrepMinutes,
          rehearsalStart: rehearsalStart,
          rehearsalEnd: rehearsalEnd,
          doorsMinutes: doorsMinutes,
          showEnd: showEnd,
          hasContradiction: contradiction,
        );
      }
      teardownMinutes = teardownEndTime.difference(showEnd).inMinutes;
      if (teardownMinutes <= 0) contradiction = true;
      endTime = teardownEndTime;
    }

    return InitialTimelineTimes(
      venuePrepMinutes: venuePrepMinutes,
      rehearsalStart: rehearsalStart,
      rehearsalEnd: rehearsalEnd,
      doorsMinutes: doorsMinutes,
      showEnd: showEnd,
      teardownMinutes: teardownMinutes,
      endTime: contradiction ? null : endTime,
      hasContradiction: contradiction,
    );
  }

  /// Duration in minutes of the category for [kind], or null when the kind is
  /// unused or the form is incomplete/contradictory.
  int? categoryDurationOf(InitialSlotKind kind) {
    final times = this.times;
    if (times.hasContradiction) return null;
    return switch (kind) {
      InitialSlotKind.venuePrep => hasVenuePrep ? times.venuePrepMinutes : null,
      InitialSlotKind.rehearsal => hasRehearsal ? rehearsalDuration : null,
      InitialSlotKind.rehearsalChangeover =>
        hasRehearsal && hasRehearsalChangeover
            ? rehearsalChangeoverDuration
            : null,
      InitialSlotKind.doors => effectiveHasDoors ? times.doorsMinutes : null,
      InitialSlotKind.performance => performanceDuration,
      InitialSlotKind.changeover => hasChangeover ? changeoverDuration : null,
      InitialSlotKind.teardown => hasTeardown ? times.teardownMinutes : null,
    };
  }

  /// Ordered slot kinds to materialize. Null when the form is incomplete or
  /// contradictory.
  List<InitialSlotKind>? get slotSequence {
    final count = performanceCount;
    if (count == null || name.isEmpty) return null;
    final times = this.times;
    if (times.hasContradiction || times.endTime == null || times.exceedsMax) {
      return null;
    }
    return [
      if (hasVenuePrep) InitialSlotKind.venuePrep,
      if (hasRehearsal)
        for (var i = 0; i < count; i++) ...[
          InitialSlotKind.rehearsal,
          if (hasRehearsalChangeover && i < count - 1)
            InitialSlotKind.rehearsalChangeover,
        ],
      if (effectiveHasDoors) InitialSlotKind.doors,
      for (var i = 0; i < count; i++) ...[
        InitialSlotKind.performance,
        if (hasChangeover && i < count - 1) InitialSlotKind.changeover,
      ],
      if (hasTeardown) InitialSlotKind.teardown,
    ];
  }

  static int? _positiveMinutes(String text) {
    final value = int.tryParse(text.trim());
    if (value == null ||
        value < 1 ||
        value > TimelineLimits.maxSlotDurationMinutes) {
      return null;
    }
    return value;
  }
}
