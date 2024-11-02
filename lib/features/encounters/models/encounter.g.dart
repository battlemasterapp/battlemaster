// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encounter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Encounter _$EncounterFromJson(Map<String, dynamic> json) => Encounter(
      name: json['name'] as String,
      combatants: (json['combatants'] as List<dynamic>)
          .map((e) => Combatant.fromJson(e as Map<String, dynamic>))
          .toList(),
      engine: $enumDecode(_$GameEngineTypeEnumMap, json['engine']),
      type: $enumDecodeNullable(_$EncounterTypeEnumMap, json['type']) ??
          EncounterType.encounter,
      id: (json['id'] as num?)?.toInt() ?? -1,
      round: (json['round'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$EncounterToJson(Encounter instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'round': instance.round,
      'type': _$EncounterTypeEnumMap[instance.type]!,
      'combatants': instance.combatants.map((e) => e.toJson()).toList(),
      'engine': _$GameEngineTypeEnumMap[instance.engine]!,
    };

const _$GameEngineTypeEnumMap = {
  GameEngineType.pf2e: 'pf2e',
  GameEngineType.dnd5e: 'dnd5e',
};

const _$EncounterTypeEnumMap = {
  EncounterType.encounter: 'encounter',
  EncounterType.group: 'group',
};
