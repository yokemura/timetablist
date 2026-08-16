import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 's_en.dart';
import 's_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/s.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// The application title.
  ///
  /// In en, this message translates to:
  /// **'Timetablist'**
  String get appTitle;

  /// Default name assigned when a new document is created. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Timetable'**
  String get defaultDocumentName;

  /// Tooltip of the menu icon in the title bar.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTooltip;

  /// Menu item: export the document to a JSON file.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get menuExport;

  /// Menu item: import a document from a JSON file, overwriting the current one.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get menuImport;

  /// Menu item: reset the document to the initial empty state.
  ///
  /// In en, this message translates to:
  /// **'Clear (New)'**
  String get menuClear;

  /// Menu item: undo the last data change.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get menuUndo;

  /// Menu item: redo the last undone data change.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get menuRedo;

  /// Validation error for numeric fields when the input is not an integer.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number'**
  String get errorInvalidInteger;

  /// Validation error when a number is below the minimum.
  ///
  /// In en, this message translates to:
  /// **'Enter {min} or more'**
  String errorIntegerMin(int min);

  /// Validation error when a number is above the maximum.
  ///
  /// In en, this message translates to:
  /// **'Enter {max} or less'**
  String errorIntegerMax(int max);

  /// Validation error for time fields when the input cannot be parsed.
  ///
  /// In en, this message translates to:
  /// **'Enter a time as hours:minutes (e.g. 25:05)'**
  String get errorInvalidTime;

  /// Validation error for time fields when the time is past the timeline maximum.
  ///
  /// In en, this message translates to:
  /// **'Enter a time between 0:00 and 30:00'**
  String get errorTimeOutOfRange;

  /// Fixed short warning shown on a placed participant whose requirements are not met. Details appear in the property pane.
  ///
  /// In en, this message translates to:
  /// **'Requirement mismatch'**
  String get requirementMismatchLabel;

  /// Button in the slot category pane that opens the creation sheet.
  ///
  /// In en, this message translates to:
  /// **'New slot type'**
  String get createSlotCategoryButton;

  /// Button in the participant pane that opens the creation sheet.
  ///
  /// In en, this message translates to:
  /// **'New participant'**
  String get createParticipantButton;

  /// Title of the slot category creation bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'New slot type'**
  String get slotCategoryCreateTitle;

  /// Title of the participant creation bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'New participant'**
  String get participantCreateTitle;

  /// Label of name input fields.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// Label of slot duration input fields, in minutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (min)'**
  String get fieldDurationMinutes;

  /// Label of the performance-slot attribute checkbox.
  ///
  /// In en, this message translates to:
  /// **'Performance slot'**
  String get fieldPerformanceAttribute;

  /// Confirm button of creation sheets.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get actionCreate;

  /// Cancel button of sheets and dialogs.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Warning shown when the entered slot category name is already taken.
  ///
  /// In en, this message translates to:
  /// **'A slot type with this name already exists'**
  String get errorDuplicateCategoryName;

  /// Warning shown when the entered participant name is already taken.
  ///
  /// In en, this message translates to:
  /// **'A participant with this name already exists'**
  String get errorDuplicateParticipantName;

  /// Warning shown when the checked requirement items contradict each other.
  ///
  /// In en, this message translates to:
  /// **'Requirements contradict each other'**
  String get errorRequirementsContradiction;

  /// Short badge label indicating a slot category has the performance attribute.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performanceAttributeLabel;

  /// Short display of a duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutesLabel(int minutes);

  /// Requirement editor row: minimum slot duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'Min duration (min)'**
  String get reqMinDurationLabel;

  /// Requirement editor row: maximum slot duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'Max duration (min)'**
  String get reqMaxDurationLabel;

  /// Requirement editor row: wants to finish by the given time.
  ///
  /// In en, this message translates to:
  /// **'Finish by'**
  String get reqFinishByLabel;

  /// Requirement editor row: wants to start at or after the given time.
  ///
  /// In en, this message translates to:
  /// **'Start at or after'**
  String get reqStartAfterLabel;

  /// Requirement editor row: preferred performance order, inclusive lower bound.
  ///
  /// In en, this message translates to:
  /// **'Prefer position or later'**
  String get reqOrderFromLabel;

  /// Requirement editor row: preferred performance order, exclusive upper bound.
  ///
  /// In en, this message translates to:
  /// **'Prefer position earlier than'**
  String get reqOrderBeforeLabel;

  /// List item summary: minimum duration requirement.
  ///
  /// In en, this message translates to:
  /// **'Min {minutes} min'**
  String reqSummaryMinDuration(int minutes);

  /// List item summary: maximum duration requirement.
  ///
  /// In en, this message translates to:
  /// **'Max {minutes} min'**
  String reqSummaryMaxDuration(int minutes);

  /// List item summary: finish-by requirement.
  ///
  /// In en, this message translates to:
  /// **'Finish by {time}'**
  String reqSummaryFinishBy(String time);

  /// List item summary: start-after requirement.
  ///
  /// In en, this message translates to:
  /// **'Start after {time}'**
  String reqSummaryStartAfter(String time);

  /// List item summary: preferred order lower bound (inclusive).
  ///
  /// In en, this message translates to:
  /// **'Position {position}+'**
  String reqSummaryOrderFrom(int position);

  /// List item summary: preferred order upper bound (exclusive).
  ///
  /// In en, this message translates to:
  /// **'Position < {position}'**
  String reqSummaryOrderBefore(int position);

  /// Separator used when joining requirement summaries into one line.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get reqSummarySeparator;

  /// Button in the timeline pane that opens the creation sheet.
  ///
  /// In en, this message translates to:
  /// **'New timeline'**
  String get createTimelineButton;

  /// Title of the timeline creation bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'New timeline'**
  String get timelineCreateTitle;

  /// Start time of the timeline sequence in the create sheet.
  ///
  /// In en, this message translates to:
  /// **'Sequence start'**
  String get fieldSequenceStart;

  /// Checkbox: prepend a preparation slot to the timeline.
  ///
  /// In en, this message translates to:
  /// **'Include preparation'**
  String get fieldHasPrep;

  /// Checkbox: insert interval slots between performance slots.
  ///
  /// In en, this message translates to:
  /// **'Include intervals'**
  String get fieldHasInterval;

  /// Checkbox: append a teardown slot to the timeline.
  ///
  /// In en, this message translates to:
  /// **'Include teardown'**
  String get fieldHasTeardown;

  /// How many performance slots to create.
  ///
  /// In en, this message translates to:
  /// **'Number of slots'**
  String get fieldPerformanceCount;

  /// Read-only start time of the first performance slot, derived from the sequence.
  ///
  /// In en, this message translates to:
  /// **'Performance start'**
  String get fieldPerformanceStart;

  /// Read-only start time of the teardown slot, derived from the sequence.
  ///
  /// In en, this message translates to:
  /// **'Teardown start'**
  String get fieldTeardownStart;

  /// Read-only end time of the timeline, derived from the sequence.
  ///
  /// In en, this message translates to:
  /// **'End time'**
  String get fieldEndTime;

  /// Warning when the drafted timeline would end after 30:00.
  ///
  /// In en, this message translates to:
  /// **'The end time exceeds the timeline maximum'**
  String get errorTimelineExceedsMax;

  /// Dropdown item that switches the slot category picker to the new-category fields.
  ///
  /// In en, this message translates to:
  /// **'Create new'**
  String get slotCategoryPickerCreateNew;

  /// Default name for a newly created preparation slot category. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get defaultCategoryPrep;

  /// Default name for a newly created performance slot category. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get defaultCategoryPerformance;

  /// Default name for a newly created interval slot category. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Changeover'**
  String get defaultCategoryInterval;

  /// Default name for a newly created teardown slot category. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Teardown'**
  String get defaultCategoryTeardown;

  /// Default name assigned when a new timeline is created. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Timeline {n}'**
  String defaultTimelineName(int n);

  /// Label of the document name field in the property pane.
  ///
  /// In en, this message translates to:
  /// **'Document name'**
  String get fieldDocumentName;

  /// Label of the timeline name field in the property pane.
  ///
  /// In en, this message translates to:
  /// **'Timeline name'**
  String get fieldTimelineName;

  /// Label of a timeline or slot start time field.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get fieldStartTime;

  /// Read-only count of performance slots on a timeline.
  ///
  /// In en, this message translates to:
  /// **'Performance slots'**
  String get fieldPerformanceSlotCount;

  /// Label of the slot type selector on a placed slot.
  ///
  /// In en, this message translates to:
  /// **'Slot type'**
  String get fieldSlotCategory;

  /// Label of the participant selector on a performance slot.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get fieldParticipant;

  /// Dropdown item when no participant is assigned to a slot.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get fieldParticipantNone;

  /// Section heading for read-only slot type fields on a placed slot.
  ///
  /// In en, this message translates to:
  /// **'Slot type details'**
  String get sectionSlotCategoryDetails;

  /// Section heading for participant fields shown on a placed slot.
  ///
  /// In en, this message translates to:
  /// **'Participant details'**
  String get sectionParticipantDetails;

  /// Section heading for participant requirement fields.
  ///
  /// In en, this message translates to:
  /// **'Requirements'**
  String get sectionRequirements;

  /// Section heading listing requirement violations for a placed slot.
  ///
  /// In en, this message translates to:
  /// **'Requirement mismatches'**
  String get sectionRequirementViolations;

  /// Destructive action button in the property pane.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// Action button that duplicates the selected timeline.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get actionDuplicate;

  /// Dismiss button on error dialogs.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// Name assigned when duplicating a timeline. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'(Copy) {name}'**
  String timelineCopyName(String name);

  /// Derived slot type name when forking a type with a new duration. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'{name} ({minutes} min)'**
  String categoryNameWithDuration(String name, int minutes);

  /// Confirmation dialog before deleting a timeline.
  ///
  /// In en, this message translates to:
  /// **'Delete this timeline?'**
  String get confirmDeleteTimeline;

  /// Confirmation dialog before deleting a slot category.
  ///
  /// In en, this message translates to:
  /// **'Delete this slot type? Slots using it will be removed.'**
  String get confirmDeleteSlotCategory;

  /// Confirmation dialog before deleting a placed slot.
  ///
  /// In en, this message translates to:
  /// **'Delete this slot?'**
  String get confirmDeleteSlot;

  /// Confirmation dialog before deleting a participant.
  ///
  /// In en, this message translates to:
  /// **'Delete this participant?'**
  String get confirmDeleteParticipant;

  /// Confirmation dialog before changing a slot to a non-performance type.
  ///
  /// In en, this message translates to:
  /// **'Change to a non-performance slot type? The assigned participant will be unassigned.'**
  String get confirmRemovePerformanceAttribute;

  /// Title of the dialog shown when the timeline start time is edited.
  ///
  /// In en, this message translates to:
  /// **'Change start time'**
  String get dialogTimelineStartChangeTitle;

  /// Title of the dialog shown when the timeline end time is edited.
  ///
  /// In en, this message translates to:
  /// **'Change end time'**
  String get dialogTimelineEndChangeTitle;

  /// Title of the dialog shown when a placed slot's duration is edited.
  ///
  /// In en, this message translates to:
  /// **'Change slot duration'**
  String get dialogSlotDurationChangeTitle;

  /// Timeline start-time dialog option.
  ///
  /// In en, this message translates to:
  /// **'Adjust the first slot only'**
  String get choiceAdjustFirstSlotOnly;

  /// Timeline end-time dialog option.
  ///
  /// In en, this message translates to:
  /// **'Adjust the last slot only'**
  String get choiceAdjustLastSlotOnly;

  /// Timeline time dialog option that shifts the whole sequence.
  ///
  /// In en, this message translates to:
  /// **'Move all slots'**
  String get choiceMoveAllSlots;

  /// Slot duration dialog option that forks the slot type.
  ///
  /// In en, this message translates to:
  /// **'Change this slot only'**
  String get choiceAdjustThisSlotOnly;

  /// Slot duration dialog option that updates the shared slot type.
  ///
  /// In en, this message translates to:
  /// **'Change all slots of this type'**
  String get choiceAdjustAllSameType;

  /// Error when moving slots would start before midnight.
  ///
  /// In en, this message translates to:
  /// **'Start time cannot be before 0:00'**
  String get errorTimelineStartBeforeMidnight;

  /// Requirement violation shown in the property pane.
  ///
  /// In en, this message translates to:
  /// **'Slot duration is below the minimum'**
  String get violationBelowMinDuration;

  /// Requirement violation shown in the property pane.
  ///
  /// In en, this message translates to:
  /// **'Slot duration exceeds the maximum'**
  String get violationAboveMaxDuration;

  /// Requirement violation shown in the property pane.
  ///
  /// In en, this message translates to:
  /// **'Slot ends after the requested finish time'**
  String get violationFinishesTooLate;

  /// Requirement violation shown in the property pane.
  ///
  /// In en, this message translates to:
  /// **'Slot starts before the requested start time'**
  String get violationStartsTooEarly;

  /// Requirement violation shown in the property pane.
  ///
  /// In en, this message translates to:
  /// **'Performance order is earlier than requested'**
  String get violationOrderTooEarly;

  /// Requirement violation shown in the property pane.
  ///
  /// In en, this message translates to:
  /// **'Performance order is later than requested'**
  String get violationOrderTooLate;

  /// Base name of the changeover slot category auto-created when a drop leaves a gap. Numbered (1), (2)... when taken. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Changeover slot'**
  String get autoGapCategoryName;

  /// Confirmation dialog when a slot is dropped beyond the timeline start or end, leaving a gap.
  ///
  /// In en, this message translates to:
  /// **'Create a changeover slot to fill the gap?'**
  String get confirmCreateGapSlot;

  /// Empty-area drop dialog option: create a timeline containing only the dragged slot.
  ///
  /// In en, this message translates to:
  /// **'Create with this slot only'**
  String get choiceCreateTimelineWithSlot;

  /// Empty-area drop dialog option: open the regular timeline creation sheet instead.
  ///
  /// In en, this message translates to:
  /// **'Create from template'**
  String get choiceCreateTimelineFromTemplate;

  /// Confirmation dialog when a participant is dropped on a slot that already has one.
  ///
  /// In en, this message translates to:
  /// **'This slot already has a participant. Replace them?'**
  String get confirmSwapParticipant;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'ja':
      return SJa();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
