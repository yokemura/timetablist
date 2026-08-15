import 'package:freezed_annotation/freezed_annotation.dart';

import 'timeline_time.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

/// Optional constraints used only for warnings, not placement rules.
@freezed
abstract class ParticipantRequirements with _$ParticipantRequirements {
  const factory ParticipantRequirements({
    int? minDurationMinutes,
    int? maxDurationMinutes,
    @TimelineTimeConverter() TimelineTime? finishBy,
    @TimelineTimeConverter() TimelineTime? startAfter,
    /// Inclusive 1-based performance-slot index (〜番目以降).
    int? preferredOrderFrom,
    /// Exclusive 1-based performance-slot index (〜番目より前).
    int? preferredOrderBefore,
  }) = _ParticipantRequirements;

  factory ParticipantRequirements.fromJson(Map<String, dynamic> json) =>
      _$ParticipantRequirementsFromJson(json);
}

/// Performer that can be assigned to a performance slot. Names must be unique
/// within a document.
@freezed
abstract class Participant with _$Participant {
  const factory Participant({
    required String id,
    required String name,
    @Default(ParticipantRequirements()) ParticipantRequirements requirements,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);
}
