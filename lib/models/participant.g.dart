// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParticipantRequirements _$ParticipantRequirementsFromJson(
  Map<String, dynamic> json,
) => _ParticipantRequirements(
  minDurationMinutes: (json['minDurationMinutes'] as num?)?.toInt(),
  maxDurationMinutes: (json['maxDurationMinutes'] as num?)?.toInt(),
  finishBy: _$JsonConverterFromJson<String, TimelineTime>(
    json['finishBy'],
    const TimelineTimeConverter().fromJson,
  ),
  startAfter: _$JsonConverterFromJson<String, TimelineTime>(
    json['startAfter'],
    const TimelineTimeConverter().fromJson,
  ),
  preferredOrderFrom: (json['preferredOrderFrom'] as num?)?.toInt(),
  preferredOrderBefore: (json['preferredOrderBefore'] as num?)?.toInt(),
);

Map<String, dynamic> _$ParticipantRequirementsToJson(
  _ParticipantRequirements instance,
) => <String, dynamic>{
  'minDurationMinutes': instance.minDurationMinutes,
  'maxDurationMinutes': instance.maxDurationMinutes,
  'finishBy': _$JsonConverterToJson<String, TimelineTime>(
    instance.finishBy,
    const TimelineTimeConverter().toJson,
  ),
  'startAfter': _$JsonConverterToJson<String, TimelineTime>(
    instance.startAfter,
    const TimelineTimeConverter().toJson,
  ),
  'preferredOrderFrom': instance.preferredOrderFrom,
  'preferredOrderBefore': instance.preferredOrderBefore,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_Participant _$ParticipantFromJson(Map<String, dynamic> json) => _Participant(
  id: json['id'] as String,
  name: json['name'] as String,
  requirements: json['requirements'] == null
      ? const ParticipantRequirements()
      : ParticipantRequirements.fromJson(
          json['requirements'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ParticipantToJson(_Participant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'requirements': instance.requirements.toJson(),
    };
