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

  @override
  String get createSlotCategoryButton => '枠タイプ作成';

  @override
  String get createParticipantButton => '演者作成';

  @override
  String get slotCategoryCreateTitle => '枠タイプ作成';

  @override
  String get participantCreateTitle => '演者作成';

  @override
  String get fieldName => '名前';

  @override
  String get fieldDurationMinutes => '時間長（分）';

  @override
  String get fieldPerformanceAttribute => '出演枠属性';

  @override
  String get actionCreate => '作成';

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get errorDuplicateCategoryName => '同じ名前の枠タイプがあります';

  @override
  String get errorDuplicateParticipantName => '同じ名前の演者がいます';

  @override
  String get errorRequirementsContradiction => '要求項目に矛盾があります';

  @override
  String get performanceAttributeLabel => '出演枠';

  @override
  String durationMinutesLabel(int minutes) {
    return '$minutes分';
  }

  @override
  String get reqMinDurationLabel => '最低時間（分）';

  @override
  String get reqMaxDurationLabel => '最長時間（分）';

  @override
  String get reqFinishByLabel => '〜までに終了したい';

  @override
  String get reqStartAfterLabel => '〜以降に開始したい';

  @override
  String get reqOrderFromLabel => '〜番目以降を希望';

  @override
  String get reqOrderBeforeLabel => '〜番目より前を希望';

  @override
  String reqSummaryMinDuration(int minutes) {
    return '最低$minutes分';
  }

  @override
  String reqSummaryMaxDuration(int minutes) {
    return '最長$minutes分';
  }

  @override
  String reqSummaryFinishBy(String time) {
    return '$timeまでに終了';
  }

  @override
  String reqSummaryStartAfter(String time) {
    return '$time以降に開始';
  }

  @override
  String reqSummaryOrderFrom(int position) {
    return '$position番目以降';
  }

  @override
  String reqSummaryOrderBefore(int position) {
    return '$position番目より前';
  }

  @override
  String get reqSummarySeparator => '・';

  @override
  String get createTimelineButton => 'タイムライン作成';

  @override
  String get timelineCreateTitle => 'タイムライン作成';

  @override
  String get fieldSequenceStart => 'シーケンス開始時間';

  @override
  String get fieldHasPrep => '準備あり';

  @override
  String get fieldHasInterval => 'インターバルあり';

  @override
  String get fieldHasTeardown => '撤収あり';

  @override
  String get fieldPerformanceCount => '枠数';

  @override
  String get fieldPerformanceStart => '出演枠の開始時刻';

  @override
  String get fieldTeardownStart => '撤収の開始時刻';

  @override
  String get fieldEndTime => '終了時刻';

  @override
  String get errorTimelineExceedsMax => '終了時刻がタイムラインの最大時刻を超えています';

  @override
  String get slotCategoryPickerCreateNew => '新規作成';

  @override
  String get defaultCategoryPrep => '準備';

  @override
  String get defaultCategoryPerformance => '出演枠';

  @override
  String get defaultCategoryInterval => '転換';

  @override
  String get defaultCategoryTeardown => '撤収';

  @override
  String defaultTimelineName(int n) {
    return 'タイムライン$n';
  }
}
