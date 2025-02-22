// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combatant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Combatant _$CombatantFromJson(Map<String, dynamic> json) => Combatant(
      id: json['id'] as String? ?? "",
      name: json['name'] as String,
      currentHp: (json['currentHp'] as num).toInt(),
      maxHp: (json['maxHp'] as num).toInt(),
      armorClass: (json['armorClass'] as num).toInt(),
      initiativeModifier: (json['initiativeModifier'] as num).toInt(),
      type: $enumDecode(_$CombatantTypeEnumMap, json['type']),
      engineType: $enumDecode(_$GameEngineTypeEnumMap, json['engineType']),
      conditions: (json['conditions'] as List<dynamic>?)
              ?.map((e) => Condition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      initiative: (json['initiative'] as num?)?.toDouble() ?? 0,
      combatantData:
          combatantDataFromJson(json['combatantData'] as Map<String, dynamic>),
      level: (json['level'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CombatantToJson(Combatant instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'currentHp': instance.currentHp,
      'maxHp': instance.maxHp,
      'initiative': instance.initiative,
      'armorClass': instance.armorClass,
      'initiativeModifier': instance.initiativeModifier,
      'level': instance.level,
      'type': _$CombatantTypeEnumMap[instance.type]!,
      'engineType': _$GameEngineTypeEnumMap[instance.engineType]!,
      'conditions': instance.conditions,
      'combatantData': combatantDataToJson(instance.combatantData),
    };

const _$CombatantTypeEnumMap = {
  CombatantType.player: 'player',
  CombatantType.monster: 'monster',
  CombatantType.hazard: 'hazard',
  CombatantType.lair: 'lair',
};

const _$GameEngineTypeEnumMap = {
  GameEngineType.pf2e: 'pf2e',
  GameEngineType.dnd5e: 'dnd5e',
  GameEngineType.custom: 'custom',
};
