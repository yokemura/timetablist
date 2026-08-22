import 'package:freezed_annotation/freezed_annotation.dart';

part 'participant.freezed.dart';
part 'participant.g.dart';

/// Performer that can be assigned to performance slots. Names must be unique
/// within a document. Assigning a participant to a slot does not remove it
/// from the participant list, so one participant can occupy multiple slots.
@freezed
abstract class Participant with _$Participant {
  const factory Participant({
    required String id,
    required String name,
  }) = _Participant;

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);
}
