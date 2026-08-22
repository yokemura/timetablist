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
  String get menuNew => '新規作成';

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
  String get performanceAttributeLabel => '出演枠';

  @override
  String durationMinutesLabel(int minutes) {
    return '$minutes分';
  }

  @override
  String get createTimelineButton => 'タイムライン作成';

  @override
  String get timelineCreateTitle => 'タイムライン作成';

  @override
  String get initialTimelineCreateTitle => '初期タイムライン作成';

  @override
  String get fieldTimelineName => 'タイムライン名';

  @override
  String get fieldPerformanceCount => '出演枠数';

  @override
  String get fieldSequenceStart => 'シーケンス開始時間';

  @override
  String get fieldHasVenuePrep => '会場準備あり';

  @override
  String get fieldHasRehearsal => 'リハーサルあり';

  @override
  String get fieldRehearsalStart => 'リハーサル開始時間';

  @override
  String get fieldRehearsalDuration => 'リハーサル所要時間（分）';

  @override
  String get fieldHasRehearsalChangeover => 'リハーサル転換時間あり';

  @override
  String get fieldRehearsalChangeoverDuration => 'リハーサル転換時間長（分）';

  @override
  String get fieldRehearsalEnd => 'リハーサル終了時間';

  @override
  String get fieldHasDoors => '客入れあり';

  @override
  String get fieldDerivedDuration => '所要時間';

  @override
  String get sectionPerformanceSlots => '出演枠';

  @override
  String get fieldPerformanceStart => '出演枠の開始時刻';

  @override
  String get fieldPerformanceDuration => '出演時間長（分）';

  @override
  String get fieldHasChangeover => '転換あり';

  @override
  String get fieldChangeoverDuration => '転換時間（分）';

  @override
  String get fieldShowEndTime => '演目終了時刻';

  @override
  String get fieldHasTeardown => '撤収あり';

  @override
  String get fieldTeardownEnd => '撤収完了時刻';

  @override
  String get fieldEndTime => '終了時刻';

  @override
  String get errorTimelineExceedsMax => '終了時刻がタイムラインの最大時刻を超えています';

  @override
  String get errorTimesContradiction => '入力された時刻に矛盾があります';

  @override
  String get errorNoSlotCategoriesForTimeline =>
      'タイムラインを作成するには、まず枠タイプを作成してください。';

  @override
  String get fieldInitialSlotCategory => '初期配置枠タイプ';

  @override
  String get slotCategoryPickerCreateNew => '新規作成';

  @override
  String get defaultCategoryVenuePrep => '会場準備';

  @override
  String get defaultCategoryRehearsal => 'リハーサル';

  @override
  String get defaultCategoryRehearsalChangeover => 'リハーサル転換';

  @override
  String get defaultCategoryDoors => '客入れ';

  @override
  String get defaultCategoryPerformance => '出演';

  @override
  String get defaultCategoryChangeover => '転換';

  @override
  String get defaultCategoryTeardown => '片付け';

  @override
  String get defaultTimelineBaseName => 'タイムライン';

  @override
  String get fieldDocumentName => 'ドキュメント名';

  @override
  String get fieldStartTime => '開始時刻';

  @override
  String get fieldSlotCategory => '枠タイプ';

  @override
  String get fieldParticipant => '演者';

  @override
  String get fieldParticipantNone => '未割り当て';

  @override
  String get sectionSlotCategoryDetails => '枠タイプ情報';

  @override
  String get sectionParticipantDetails => '演者情報';

  @override
  String get actionDelete => '削除';

  @override
  String get actionDuplicate => '複製';

  @override
  String get actionOk => 'OK';

  @override
  String categoryNameWithDuration(String name, int minutes) {
    return '$name($minutes分)';
  }

  @override
  String get confirmDeleteTimeline => 'このタイムラインを削除しますか？';

  @override
  String get confirmDeleteSlotCategory => 'この枠タイプを削除しますか？使用中の枠も削除されます。';

  @override
  String get confirmDeleteSlot => 'この枠を削除しますか？';

  @override
  String get confirmDeleteParticipant => 'この演者を削除しますか？';

  @override
  String get confirmRemovePerformanceAttribute =>
      '出演枠属性のない枠タイプに変更しますか？割り当て済みの演者は未割り当てになります。';

  @override
  String get dialogTimelineStartChangeTitle => '開始時刻の変更';

  @override
  String get dialogTimelineEndChangeTitle => '終了時刻の変更';

  @override
  String get dialogSlotDurationChangeTitle => '時間長の変更';

  @override
  String get choiceAdjustFirstSlotOnly => '最初の枠のみを拡大・縮小する';

  @override
  String get choiceAdjustLastSlotOnly => '最後の枠のみを拡大・縮小する';

  @override
  String get choiceMoveAllSlots => 'すべての枠を移動する';

  @override
  String get choiceAdjustThisSlotOnly => 'この枠のみを変更';

  @override
  String get choiceAdjustAllSameType => 'すべての同じタイプの枠を変更';

  @override
  String get errorTimelineStartBeforeMidnight => '開始時刻を0:00より前にできません';

  @override
  String get autoGapCategoryName => '空き';

  @override
  String get confirmCreateGapSlot => '空いた時間に空き枠を自動作成して配置しますか？';

  @override
  String get confirmSwapParticipant => 'この枠にはすでに演者が割り当てられています。入れ替えますか？';

  @override
  String get confirmClearDocument => '内容をすべてクリアして新規作成しますか？';

  @override
  String get confirmImportReplace =>
      '現在の内容を読み込んだファイルの内容で置き換えますか？（取り消しの履歴は消去されます）';

  @override
  String get errorImportFailed => 'ファイルを読み込めませんでした。エクスポートしたJSONファイルかご確認ください。';
}
