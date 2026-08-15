import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot.freezed.dart';
part 'slot.g.dart';

/// A slot placed on a timeline.
///
/// Start/end times are not stored; they are always stacked from the timeline
/// start. The category and optional participant are referenced by ID so that
/// edits to the shared objects apply to every placement.
@freezed
abstract class Slot with _$Slot {
  const factory Slot({
    required String id,
    required String categoryId,
    String? participantId,
  }) = _Slot;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);
}
