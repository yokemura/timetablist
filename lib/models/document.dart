import 'package:freezed_annotation/freezed_annotation.dart';

import 'participant.dart';
import 'placed_slot.dart';
import 'slot_category.dart';
import 'timeline.dart';
import 'timeline_time.dart';

part 'document.freezed.dart';
part 'document.g.dart';

/// A complete timetable. Import and export operate on this unit.
@freezed
abstract class Document with _$Document {
  const Document._();

  const factory Document({
    required String name,
    @Default([]) List<Timeline> timelines,
    @Default([]) List<SlotCategory> slotCategories,
    @Default([]) List<Participant> participants,
  }) = _Document;

  /// Empty document. [name] should be the already-localized default
  /// (`タイムテーブル` / `Timetable`); stored names are not retranslated later.
  factory Document.empty({required String name}) => Document(name: name);

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  SlotCategory? slotCategoryById(String id) {
    for (final category in slotCategories) {
      if (category.id == id) return category;
    }
    return null;
  }

  Participant? participantById(String id) {
    for (final participant in participants) {
      if (participant.id == id) return participant;
    }
    return null;
  }

  Timeline? timelineById(String id) {
    for (final timeline in timelines) {
      if (timeline.id == id) return timeline;
    }
    return null;
  }

  bool isSlotCategoryNameTaken(String name, {String? exceptId}) {
    return slotCategories.any(
      (category) => category.name == name && category.id != exceptId,
    );
  }

  bool isParticipantNameTaken(String name, {String? exceptId}) {
    return participants.any(
      (participant) => participant.name == name && participant.id != exceptId,
    );
  }

  /// Common auto-naming rule for copies: [base] if free, otherwise
  /// `base(2)`, `base(3)`, ... (first free number).
  String nextAvailableSlotCategoryName(String base) {
    return _nextAvailableName(base, isSlotCategoryNameTaken);
  }

  /// Common auto-naming rule applied to timeline names (used when
  /// duplicating a timeline).
  String nextAvailableTimelineName(String base) {
    return _nextAvailableName(
      base,
      (name) => timelines.any((timeline) => timeline.name == name),
    );
  }

  static String _nextAvailableName(String base, bool Function(String) taken) {
    if (!taken(base)) return base;
    var n = 2;
    while (taken('$base($n)')) {
      n += 1;
    }
    return '$base($n)';
  }

  List<PlacedSlot> placedSlotsOf(Timeline timeline) {
    return timeline.placedSlots(
      categories: slotCategories,
      participants: participants,
    );
  }

  TimelineTime endTimeOf(Timeline timeline) {
    return timeline.endTime(categories: slotCategories);
  }
}
