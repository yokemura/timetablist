import '../../models/models.dart';

/// In-progress choice of a slot category: an existing one, or a new one
/// being typed in the create sheet.
class CategoryDraft {
  const CategoryDraft({
    this.existing,
    this.newName = '',
    this.newDurationText = '',
    required this.isPerformanceSlot,
  });

  factory CategoryDraft.initial({
    required List<SlotCategory> candidates,
    required String defaultName,
    required bool isPerformanceSlot,
  }) {
    return CategoryDraft(
      existing: candidates.isEmpty ? null : candidates.first,
      newName: defaultName,
      newDurationText: '',
      isPerformanceSlot: isPerformanceSlot,
    );
  }

  final SlotCategory? existing;
  final String newName;
  final String newDurationText;
  final bool isPerformanceSlot;

  bool get isNew => existing == null;

  String get name => existing?.name ?? newName.trim();

  int? get durationMinutes {
    if (existing != null) return existing!.durationMinutes;
    final value = int.tryParse(newDurationText.trim());
    if (value == null ||
        value < 1 ||
        value > TimelineLimits.maxSlotDurationMinutes) {
      return null;
    }
    return value;
  }

  CategoryDraft copyWith({
    SlotCategory? existing,
    bool clearExisting = false,
    String? newName,
    String? newDurationText,
  }) {
    return CategoryDraft(
      existing: clearExisting ? null : (existing ?? this.existing),
      newName: newName ?? this.newName,
      newDurationText: newDurationText ?? this.newDurationText,
      isPerformanceSlot: isPerformanceSlot,
    );
  }
}

/// Computed times for a timeline-create form. Any null time means a required
/// input is still missing or invalid.
class TimelineDraftTimes {
  const TimelineDraftTimes({
    required this.performanceStart,
    required this.teardownStart,
    required this.endTime,
  });

  final TimelineTime? performanceStart;
  final TimelineTime? teardownStart;
  final TimelineTime? endTime;

  bool get exceedsMax => endTime != null && !endTime!.isWithinMax;
}

/// Live calculation of the create-timeline template
/// (prep + N×performance [+ interval] + teardown).
class TimelineDraft {
  const TimelineDraft({
    required this.startTimeText,
    required this.hasPrep,
    required this.prep,
    required this.performanceCountText,
    required this.performance,
    required this.hasInterval,
    required this.interval,
    required this.hasTeardown,
    required this.teardown,
  });

  final String startTimeText;
  final bool hasPrep;
  final CategoryDraft prep;
  final String performanceCountText;
  final CategoryDraft performance;
  final bool hasInterval;
  final CategoryDraft interval;
  final bool hasTeardown;
  final CategoryDraft teardown;

  TimelineDraft copyWith({
    String? startTimeText,
    bool? hasPrep,
    CategoryDraft? prep,
    String? performanceCountText,
    CategoryDraft? performance,
    bool? hasInterval,
    CategoryDraft? interval,
    bool? hasTeardown,
    CategoryDraft? teardown,
  }) {
    return TimelineDraft(
      startTimeText: startTimeText ?? this.startTimeText,
      hasPrep: hasPrep ?? this.hasPrep,
      prep: prep ?? this.prep,
      performanceCountText: performanceCountText ?? this.performanceCountText,
      performance: performance ?? this.performance,
      hasInterval: hasInterval ?? this.hasInterval,
      interval: interval ?? this.interval,
      hasTeardown: hasTeardown ?? this.hasTeardown,
      teardown: teardown ?? this.teardown,
    );
  }

  TimelineTime? get startTime => TimelineTime.tryParse(startTimeText.trim());

  int? get performanceCount {
    final value = int.tryParse(performanceCountText.trim());
    if (value == null || value < 1) return null;
    return value;
  }

  TimelineDraftTimes get times {
    final start = startTime;
    if (start == null) {
      return const TimelineDraftTimes(
        performanceStart: null,
        teardownStart: null,
        endTime: null,
      );
    }

    var current = start;
    if (hasPrep) {
      final duration = prep.durationMinutes;
      if (duration == null) {
        return const TimelineDraftTimes(
          performanceStart: null,
          teardownStart: null,
          endTime: null,
        );
      }
      current = current.addMinutes(duration);
    }

    final performanceStart = current;
    final count = performanceCount;
    final performanceDuration = performance.durationMinutes;
    if (count == null || performanceDuration == null) {
      return TimelineDraftTimes(
        performanceStart: performanceStart,
        teardownStart: null,
        endTime: null,
      );
    }
    if (hasInterval && interval.durationMinutes == null) {
      return TimelineDraftTimes(
        performanceStart: performanceStart,
        teardownStart: null,
        endTime: null,
      );
    }

    for (var i = 0; i < count; i++) {
      current = current.addMinutes(performanceDuration);
      if (hasInterval && i < count - 1) {
        current = current.addMinutes(interval.durationMinutes!);
      }
    }

    final teardownStart = current;
    if (hasTeardown) {
      final duration = teardown.durationMinutes;
      if (duration == null) {
        return TimelineDraftTimes(
          performanceStart: performanceStart,
          teardownStart: teardownStart,
          endTime: null,
        );
      }
      current = current.addMinutes(duration);
    }

    return TimelineDraftTimes(
      performanceStart: performanceStart,
      teardownStart: hasTeardown ? teardownStart : null,
      endTime: current,
    );
  }

  /// Ordered slot specs to materialize. Null when the form is incomplete.
  List<({CategoryDraft category, bool isPerformance})>? get slotSequence {
    final count = performanceCount;
    if (startTime == null || count == null) return null;
    if (performance.durationMinutes == null) return null;
    if (hasPrep && prep.durationMinutes == null) return null;
    if (hasInterval && interval.durationMinutes == null) return null;
    if (hasTeardown && teardown.durationMinutes == null) return null;

    return [
      if (hasPrep) (category: prep, isPerformance: false),
      for (var i = 0; i < count; i++) ...[
        (category: performance, isPerformance: true),
        if (hasInterval && i < count - 1)
          (category: interval, isPerformance: false),
      ],
      if (hasTeardown) (category: teardown, isPerformance: false),
    ];
  }
}
