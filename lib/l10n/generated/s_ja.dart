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

  @override
  String get errorInvalidInteger => '整数を入力してください';

  @override
  String errorIntegerMin(int min) {
    return '$min以上を入力してください';
  }

  @override
  String errorIntegerMax(int max) {
    return '$max以下を入力してください';
  }

  @override
  String get errorInvalidTime => '時刻を「時:分」形式で入力してください（例: 25:05）';

  @override
  String get errorTimeOutOfRange => '0:00〜30:00の範囲で入力してください';

  @override
  String get requirementMismatchLabel => '要求不一致';
}
