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
}
