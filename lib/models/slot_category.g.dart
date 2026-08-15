// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SlotCategory _$SlotCategoryFromJson(Map<String, dynamic> json) =>
    _SlotCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      isPerformanceSlot: json['isPerformanceSlot'] as bool,
    );

Map<String, dynamic> _$SlotCategoryToJson(_SlotCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'durationMinutes': instance.durationMinutes,
      'isPerformanceSlot': instance.isPerformanceSlot,
    };
