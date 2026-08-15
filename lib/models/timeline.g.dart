// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Timeline _$TimelineFromJson(Map<String, dynamic> json) => _Timeline(
  id: json['id'] as String,
  name: json['name'] as String,
  startTime: const TimelineTimeConverter().fromJson(
    json['startTime'] as String,
  ),
  slots: (json['slots'] as List<dynamic>)
      .map((e) => Slot.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TimelineToJson(_Timeline instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'startTime': const TimelineTimeConverter().toJson(instance.startTime),
  'slots': instance.slots.map((e) => e.toJson()).toList(),
};
