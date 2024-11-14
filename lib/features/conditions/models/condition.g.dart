// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Condition _$ConditionFromJson(Map<String, dynamic> json) => Condition(
      name: json['name'] as String,
      description: json['description'] as String,
      engine: $enumDecodeNullable(_$GameEngineTypeEnumMap, json['engine']) ??
          GameEngineType.custom,
      durationRounds: (json['durationRounds'] as num?)?.toInt(),
      value: (json['value'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConditionToJson(Condition instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'engine': _$GameEngineTypeEnumMap[instance.engine]!,
      'durationRounds': instance.durationRounds,
      'value': instance.value,
    };

const _$GameEngineTypeEnumMap = {
  GameEngineType.pf2e: 'pf2e',
  GameEngineType.dnd5e: 'dnd5e',
  GameEngineType.custom: 'custom',
};
