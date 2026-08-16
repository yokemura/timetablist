// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 's.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Timetablist';

  @override
  String get defaultDocumentName => 'Timetable';

  @override
  String get menuTooltip => 'Menu';

  @override
  String get menuExport => 'Export';

  @override
  String get menuImport => 'Import';

  @override
  String get menuClear => 'Clear (New)';

  @override
  String get menuUndo => 'Undo';

  @override
  String get menuRedo => 'Redo';

  @override
  String get errorInvalidInteger => 'Enter a whole number';

  @override
  String errorIntegerMin(int min) {
    return 'Enter $min or more';
  }

  @override
  String errorIntegerMax(int max) {
    return 'Enter $max or less';
  }

  @override
  String get errorInvalidTime => 'Enter a time as hours:minutes (e.g. 25:05)';

  @override
  String get errorTimeOutOfRange => 'Enter a time between 0:00 and 30:00';

  @override
  String get requirementMismatchLabel => 'Requirement mismatch';

  @override
  String get createSlotCategoryButton => 'New slot type';

  @override
  String get createParticipantButton => 'New participant';

  @override
  String get slotCategoryCreateTitle => 'New slot type';

  @override
  String get participantCreateTitle => 'New participant';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldDurationMinutes => 'Duration (min)';

  @override
  String get fieldPerformanceAttribute => 'Performance slot';

  @override
  String get actionCreate => 'Create';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get errorDuplicateCategoryName =>
      'A slot type with this name already exists';

  @override
  String get errorDuplicateParticipantName =>
      'A participant with this name already exists';

  @override
  String get errorRequirementsContradiction =>
      'Requirements contradict each other';

  @override
  String get performanceAttributeLabel => 'Performance';

  @override
  String durationMinutesLabel(int minutes) {
    return '$minutes min';
  }

  @override
  String get reqMinDurationLabel => 'Min duration (min)';

  @override
  String get reqMaxDurationLabel => 'Max duration (min)';

  @override
  String get reqFinishByLabel => 'Finish by';

  @override
  String get reqStartAfterLabel => 'Start at or after';

  @override
  String get reqOrderFromLabel => 'Prefer position or later';

  @override
  String get reqOrderBeforeLabel => 'Prefer position earlier than';

  @override
  String reqSummaryMinDuration(int minutes) {
    return 'Min $minutes min';
  }

  @override
  String reqSummaryMaxDuration(int minutes) {
    return 'Max $minutes min';
  }

  @override
  String reqSummaryFinishBy(String time) {
    return 'Finish by $time';
  }

  @override
  String reqSummaryStartAfter(String time) {
    return 'Start after $time';
  }

  @override
  String reqSummaryOrderFrom(int position) {
    return 'Position $position+';
  }

  @override
  String reqSummaryOrderBefore(int position) {
    return 'Position < $position';
  }

  @override
  String get reqSummarySeparator => ', ';

  @override
  String get createTimelineButton => 'New timeline';

  @override
  String get timelineCreateTitle => 'New timeline';

  @override
  String get fieldSequenceStart => 'Sequence start';

  @override
  String get fieldHasPrep => 'Include preparation';

  @override
  String get fieldHasInterval => 'Include intervals';

  @override
  String get fieldHasTeardown => 'Include teardown';

  @override
  String get fieldPerformanceCount => 'Number of slots';

  @override
  String get fieldPerformanceStart => 'Performance start';

  @override
  String get fieldTeardownStart => 'Teardown start';

  @override
  String get fieldEndTime => 'End time';

  @override
  String get errorTimelineExceedsMax =>
      'The end time exceeds the timeline maximum';

  @override
  String get slotCategoryPickerCreateNew => 'Create new';

  @override
  String get defaultCategoryPrep => 'Preparation';

  @override
  String get defaultCategoryPerformance => 'Performance';

  @override
  String get defaultCategoryInterval => 'Changeover';

  @override
  String get defaultCategoryTeardown => 'Teardown';

  @override
  String defaultTimelineName(int n) {
    return 'Timeline $n';
  }
}
