// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Document _$DocumentFromJson(Map<String, dynamic> json) => _Document(
  name: json['name'] as String,
  timelines:
      (json['timelines'] as List<dynamic>?)
          ?.map((e) => Timeline.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  slotCategories:
      (json['slotCategories'] as List<dynamic>?)
          ?.map((e) => SlotCategory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DocumentToJson(_Document instance) => <String, dynamic>{
  'name': instance.name,
  'timelines': instance.timelines.map((e) => e.toJson()).toList(),
  'slotCategories': instance.slotCategories.map((e) => e.toJson()).toList(),
  'participants': instance.participants.map((e) => e.toJson()).toList(),
};
