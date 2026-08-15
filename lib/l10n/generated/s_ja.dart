// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 's.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class SJa extends S {
  SJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Timetablist';

  @override
  String get defaultDocumentName => 'タイムテーブル';

  @override
  String get menuTooltip => 'メニュー';

  @override
  String get menuExport => 'エクスポート';

  @override
  String get menuImport => 'インポート';

  @override
  String get menuClear => 'クリア（新規作成）';

  @override
  String get menuUndo => '取り消す';

  @override
  String get menuRedo => 'やり直す';
}
