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
}
