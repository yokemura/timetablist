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

  /// Menu item: save the document as a JSON file.
  ///
  /// In en, this message translates to:
  /// **'Save file'**
  String get menuExport;

  /// Menu item: export the timetable as a CSV for spreadsheet finishing.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get menuExportCsv;

  /// Menu item: load a document from a JSON file, overwriting the current one.
  ///
  /// In en, this message translates to:
  /// **'Load file'**
  String get menuImport;

  /// Menu item: clear the document and start over with the initial timeline dialog.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get menuNew;

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

  /// Button in the slot category pane that opens the creation dialog.
  ///
  /// In en, this message translates to:
  /// **'New slot type'**
  String get createSlotCategoryButton;

  /// Button in the participant pane that opens the creation dialog.
  ///
  /// In en, this message translates to:
  /// **'New participant'**
  String get createParticipantButton;

  /// Title of the slot category creation dialog.
  ///
  /// In en, this message translates to:
  /// **'New slot type'**
  String get slotCategoryCreateTitle;

  /// Title of the participant creation dialog.
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

  /// Confirm button of creation dialogs.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get actionCreate;

  /// Cancel button of dialogs.
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

  /// Button in the timeline pane that opens the creation dialog.
  ///
  /// In en, this message translates to:
  /// **'New timeline'**
  String get createTimelineButton;

  /// Title of the timeline creation dialog opened from the pane button.
  ///
  /// In en, this message translates to:
  /// **'New timeline'**
  String get timelineCreateTitle;

  /// Non-cancellable dialog shown at startup when the document has no timelines. Offers create-new or load-file.
  ///
  /// In en, this message translates to:
  /// **'There are no timelines. Create a new one, or load from a file?'**
  String get startupEmptyPrompt;

  /// Title of the initial timeline creation dialog shown after choosing New at startup and after the New menu action. Cannot be cancelled.
  ///
  /// In en, this message translates to:
  /// **'Create the first timeline'**
  String get initialTimelineCreateTitle;

  /// Label of the timeline name field.
  ///
  /// In en, this message translates to:
  /// **'Timeline name'**
  String get fieldTimelineName;

  /// How many performance slots to create. The same count is used for rehearsal slots.
  ///
  /// In en, this message translates to:
  /// **'Number of performance slots'**
  String get fieldPerformanceCount;

  /// Start time of the timeline sequence in the initial creation dialog.
  ///
  /// In en, this message translates to:
  /// **'Sequence start'**
  String get fieldSequenceStart;

  /// Checkbox: prepend a venue setup slot to the timeline.
  ///
  /// In en, this message translates to:
  /// **'Include venue setup'**
  String get fieldHasVenuePrep;

  /// Checkbox: add rehearsal slots before the performances.
  ///
  /// In en, this message translates to:
  /// **'Include rehearsal'**
  String get fieldHasRehearsal;

  /// Start time of the rehearsal block. Hidden when there is no venue setup (it then equals the sequence start).
  ///
  /// In en, this message translates to:
  /// **'Rehearsal start'**
  String get fieldRehearsalStart;

  /// Duration of each rehearsal slot in minutes.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal duration (min)'**
  String get fieldRehearsalDuration;

  /// Checkbox: insert changeover slots between rehearsal slots.
  ///
  /// In en, this message translates to:
  /// **'Include rehearsal changeovers'**
  String get fieldHasRehearsalChangeover;

  /// Duration of each rehearsal changeover slot in minutes.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal changeover (min)'**
  String get fieldRehearsalChangeoverDuration;

  /// Read-only end time of the rehearsal block, derived from the sequence.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal end'**
  String get fieldRehearsalEnd;

  /// Checkbox: insert a doors (audience entry) slot between the rehearsal end and the performance start. Hidden when there is no rehearsal.
  ///
  /// In en, this message translates to:
  /// **'Include doors'**
  String get fieldHasDoors;

  /// Label of read-only durations derived from the surrounding times (venue setup, doors, teardown).
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get fieldDerivedDuration;

  /// Section heading of the performance slot fields in the initial creation dialog.
  ///
  /// In en, this message translates to:
  /// **'Performance slots'**
  String get sectionPerformanceSlots;

  /// Start time of the first performance slot.
  ///
  /// In en, this message translates to:
  /// **'Performance start'**
  String get fieldPerformanceStart;

  /// Duration of each performance slot in minutes.
  ///
  /// In en, this message translates to:
  /// **'Performance duration (min)'**
  String get fieldPerformanceDuration;

  /// Checkbox: insert changeover slots between performance slots.
  ///
  /// In en, this message translates to:
  /// **'Include changeovers'**
  String get fieldHasChangeover;

  /// Duration of each changeover slot in minutes.
  ///
  /// In en, this message translates to:
  /// **'Changeover (min)'**
  String get fieldChangeoverDuration;

  /// Read-only end time of the last performance slot, derived from the sequence.
  ///
  /// In en, this message translates to:
  /// **'Show end time'**
  String get fieldShowEndTime;

  /// Checkbox: append a teardown slot to the timeline.
  ///
  /// In en, this message translates to:
  /// **'Include teardown'**
  String get fieldHasTeardown;

  /// Time the teardown slot ends; its duration is derived from the show end time.
  ///
  /// In en, this message translates to:
  /// **'Teardown complete'**
  String get fieldTeardownEnd;

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

  /// Warning in the initial timeline dialog when the entered times contradict each other (e.g. a derived duration would be zero or negative).
  ///
  /// In en, this message translates to:
  /// **'The entered times are inconsistent'**
  String get errorTimesContradiction;

  /// Error dialog shown when the timeline creation button is pressed while no slot categories exist.
  ///
  /// In en, this message translates to:
  /// **'Create a slot type first, then create a timeline.'**
  String get errorNoSlotCategoriesForTimeline;

  /// Dropdown in the pane's timeline creation dialog choosing the slot type of the single initial slot.
  ///
  /// In en, this message translates to:
  /// **'Initial slot type'**
  String get fieldInitialSlotCategory;

  /// Dropdown item that switches the slot category picker to the new-category fields.
  ///
  /// In en, this message translates to:
  /// **'Create new'**
  String get slotCategoryPickerCreateNew;

  /// Name of the venue setup slot category created by the initial timeline dialog. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Venue setup'**
  String get defaultCategoryVenuePrep;

  /// Name of the rehearsal slot category created by the initial timeline dialog. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal'**
  String get defaultCategoryRehearsal;

  /// Name of the rehearsal changeover slot category created by the initial timeline dialog. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Rehearsal changeover'**
  String get defaultCategoryRehearsalChangeover;

  /// Name of the doors (audience entry) slot category created by the initial timeline dialog. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Doors'**
  String get defaultCategoryDoors;

  /// Name of the performance slot category created by the initial timeline dialog. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get defaultCategoryPerformance;

  /// Name of the changeover slot category created by the initial timeline dialog. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Changeover'**
  String get defaultCategoryChangeover;

  /// Name of the teardown slot category created by the initial timeline dialog. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Cleanup'**
  String get defaultCategoryTeardown;

  /// Initial value of the timeline name field in the creation dialogs. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get defaultTimelineBaseName;

  /// Label of the document name field in the property pane.
  ///
  /// In en, this message translates to:
  /// **'Document name'**
  String get fieldDocumentName;

  /// Label of a timeline or slot start time field.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get fieldStartTime;

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

  /// Section heading for slot type fields on a placed slot.
  ///
  /// In en, this message translates to:
  /// **'Slot type details'**
  String get sectionSlotCategoryDetails;

  /// Section heading for participant fields shown on a placed slot.
  ///
  /// In en, this message translates to:
  /// **'Participant details'**
  String get sectionParticipantDetails;

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

  /// Display of a slot type name with its duration, used on placed slots.
  ///
  /// In en, this message translates to:
  /// **'{name} ({minutes} min)'**
  String categoryNameWithDuration(String name, int minutes);

  /// Placed slot caption: start–end, type name, and duration.
  ///
  /// In en, this message translates to:
  /// **'{start}-{end} {name} ({minutes} min)'**
  String placedSlotLabel(String start, String end, String name, int minutes);

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

  /// Base name of the gap slot category auto-created when a drop leaves open time. Follows the common auto-naming rule ((2), (3)...) when taken. Stored as-is and not retranslated later.
  ///
  /// In en, this message translates to:
  /// **'Gap'**
  String get autoGapCategoryName;

  /// Confirmation dialog when a slot is dropped beyond the timeline start or end, leaving open time.
  ///
  /// In en, this message translates to:
  /// **'Create a gap slot to fill the open time?'**
  String get confirmCreateGapSlot;

  /// Confirmation dialog when a participant is dropped on a slot that already has one.
  ///
  /// In en, this message translates to:
  /// **'This slot already has a participant. Replace them?'**
  String get confirmSwapParticipant;

  /// Confirmation dialog for the menu's New action.
  ///
  /// In en, this message translates to:
  /// **'Clear everything and start a new timetable?'**
  String get confirmClearDocument;

  /// Confirmation dialog shown before an import overwrites the current document.
  ///
  /// In en, this message translates to:
  /// **'Replace the current contents with the imported file? (Undo history will be cleared.)'**
  String get confirmImportReplace;

  /// Error dialog shown when the picked file cannot be parsed.
  ///
  /// In en, this message translates to:
  /// **'Could not read the file. Make sure it is a JSON file saved from this app.'**
  String get errorImportFailed;

  /// Error dialog shown when saving a JSON or CSV file fails.
  ///
  /// In en, this message translates to:
  /// **'Could not write the file.'**
  String get errorExportFailed;

  /// CSV header for the timeline name column (included only when there are two or more timelines).
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get csvHeaderTimeline;

  /// CSV header for slot start time.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get csvHeaderStart;

  /// CSV header for slot end time.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get csvHeaderEnd;

  /// CSV header for slot duration in minutes.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get csvHeaderDuration;

  /// CSV header for slot type name.
  ///
  /// In en, this message translates to:
  /// **'Slot type'**
  String get csvHeaderSlotType;

  /// CSV header for performer name on performance slots.
  ///
  /// In en, this message translates to:
  /// **'Performer'**
  String get csvHeaderPerformer;
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
