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
  String get menuNew => 'New';

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
  String get performanceAttributeLabel => 'Performance';

  @override
  String durationMinutesLabel(int minutes) {
    return '$minutes min';
  }

  @override
  String get createTimelineButton => 'New timeline';

  @override
  String get timelineCreateTitle => 'New timeline';

  @override
  String get initialTimelineCreateTitle => 'Create the first timeline';

  @override
  String get fieldTimelineName => 'Timeline name';

  @override
  String get fieldPerformanceCount => 'Number of performance slots';

  @override
  String get fieldSequenceStart => 'Sequence start';

  @override
  String get fieldHasVenuePrep => 'Include venue setup';

  @override
  String get fieldHasRehearsal => 'Include rehearsal';

  @override
  String get fieldRehearsalStart => 'Rehearsal start';

  @override
  String get fieldRehearsalDuration => 'Rehearsal duration (min)';

  @override
  String get fieldHasRehearsalChangeover => 'Include rehearsal changeovers';

  @override
  String get fieldRehearsalChangeoverDuration => 'Rehearsal changeover (min)';

  @override
  String get fieldRehearsalEnd => 'Rehearsal end';

  @override
  String get fieldHasDoors => 'Include doors';

  @override
  String get fieldDerivedDuration => 'Duration';

  @override
  String get sectionPerformanceSlots => 'Performance slots';

  @override
  String get fieldPerformanceStart => 'Performance start';

  @override
  String get fieldPerformanceDuration => 'Performance duration (min)';

  @override
  String get fieldHasChangeover => 'Include changeovers';

  @override
  String get fieldChangeoverDuration => 'Changeover (min)';

  @override
  String get fieldShowEndTime => 'Show end time';

  @override
  String get fieldHasTeardown => 'Include teardown';

  @override
  String get fieldTeardownEnd => 'Teardown complete';

  @override
  String get fieldEndTime => 'End time';

  @override
  String get errorTimelineExceedsMax =>
      'The end time exceeds the timeline maximum';

  @override
  String get errorTimesContradiction => 'The entered times are inconsistent';

  @override
  String get errorNoSlotCategoriesForTimeline =>
      'Create a slot type first, then create a timeline.';

  @override
  String get fieldInitialSlotCategory => 'Initial slot type';

  @override
  String get slotCategoryPickerCreateNew => 'Create new';

  @override
  String get defaultCategoryVenuePrep => 'Venue setup';

  @override
  String get defaultCategoryRehearsal => 'Rehearsal';

  @override
  String get defaultCategoryRehearsalChangeover => 'Rehearsal changeover';

  @override
  String get defaultCategoryDoors => 'Doors';

  @override
  String get defaultCategoryPerformance => 'Performance';

  @override
  String get defaultCategoryChangeover => 'Changeover';

  @override
  String get defaultCategoryTeardown => 'Cleanup';

  @override
  String get defaultTimelineBaseName => 'Timeline';

  @override
  String get fieldDocumentName => 'Document name';

  @override
  String get fieldStartTime => 'Start time';

  @override
  String get fieldSlotCategory => 'Slot type';

  @override
  String get fieldParticipant => 'Participant';

  @override
  String get fieldParticipantNone => 'Unassigned';

  @override
  String get sectionSlotCategoryDetails => 'Slot type details';

  @override
  String get sectionParticipantDetails => 'Participant details';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionDuplicate => 'Duplicate';

  @override
  String get actionOk => 'OK';

  @override
  String categoryNameWithDuration(String name, int minutes) {
    return '$name ($minutes min)';
  }

  @override
  String placedSlotLabel(String start, String end, String name, int minutes) {
    return '$start-$end $name ($minutes min)';
  }

  @override
  String get confirmDeleteTimeline => 'Delete this timeline?';

  @override
  String get confirmDeleteSlotCategory =>
      'Delete this slot type? Slots using it will be removed.';

  @override
  String get confirmDeleteSlot => 'Delete this slot?';

  @override
  String get confirmDeleteParticipant => 'Delete this participant?';

  @override
  String get confirmRemovePerformanceAttribute =>
      'Change to a non-performance slot type? The assigned participant will be unassigned.';

  @override
  String get dialogTimelineStartChangeTitle => 'Change start time';

  @override
  String get dialogTimelineEndChangeTitle => 'Change end time';

  @override
  String get dialogSlotDurationChangeTitle => 'Change slot duration';

  @override
  String get choiceAdjustFirstSlotOnly => 'Adjust the first slot only';

  @override
  String get choiceAdjustLastSlotOnly => 'Adjust the last slot only';

  @override
  String get choiceMoveAllSlots => 'Move all slots';

  @override
  String get choiceAdjustThisSlotOnly => 'Change this slot only';

  @override
  String get choiceAdjustAllSameType => 'Change all slots of this type';

  @override
  String get errorTimelineStartBeforeMidnight =>
      'Start time cannot be before 0:00';

  @override
  String get autoGapCategoryName => 'Gap';

  @override
  String get confirmCreateGapSlot => 'Create a gap slot to fill the open time?';

  @override
  String get confirmSwapParticipant =>
      'This slot already has a participant. Replace them?';

  @override
  String get confirmClearDocument =>
      'Clear everything and start a new timetable?';

  @override
  String get confirmImportReplace =>
      'Replace the current contents with the imported file? (Undo history will be cleared.)';

  @override
  String get errorImportFailed =>
      'Could not read the file. Make sure it is a JSON file exported from this app.';
}
