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
