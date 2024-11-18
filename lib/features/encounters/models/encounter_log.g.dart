// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encounter_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCombatantLog _$AddCombatantLogFromJson(Map<String, dynamic> json) =>
    AddCombatantLog(
      round: (json['round'] as num).toInt(),
      turn: (json['turn'] as num).toInt(),
      combatant: Combatant.fromJson(json['combatant'] as Map<String, dynamic>),
      type: $enumDecodeNullable(_$EncounterLogTypeEnumMap, json['type']) ??
          EncounterLogType.addCombatant,
    );

Map<String, dynamic> _$AddCombatantLogToJson(AddCombatantLog instance) =>
    <String, dynamic>{
      'round': instance.round,
      'turn': instance.turn,
      'type': _$EncounterLogTypeEnumMap[instance.type]!,
      'combatant': instance.combatant,
    };

const _$EncounterLogTypeEnumMap = {
  EncounterLogType.addCombatant: 'addCombatant',
  EncounterLogType.removeCombatant: 'removeCombatant',
  EncounterLogType.damageCombatant: 'damageCombatant',
  EncounterLogType.combatantInitiative: 'combatantInitiative',
  EncounterLogType.addConditions: 'addConditions',
};

RemoveCombatantLog _$RemoveCombatantLogFromJson(Map<String, dynamic> json) =>
    RemoveCombatantLog(
      round: (json['round'] as num).toInt(),
      turn: (json['turn'] as num).toInt(),
      combatant: Combatant.fromJson(json['combatant'] as Map<String, dynamic>),
      type: $enumDecodeNullable(_$EncounterLogTypeEnumMap, json['type']) ??
          EncounterLogType.removeCombatant,
    );

Map<String, dynamic> _$RemoveCombatantLogToJson(RemoveCombatantLog instance) =>
    <String, dynamic>{
      'round': instance.round,
      'turn': instance.turn,
      'type': _$EncounterLogTypeEnumMap[instance.type]!,
      'combatant': instance.combatant,
    };

DamageCombatantLog _$DamageCombatantLogFromJson(Map<String, dynamic> json) =>
    DamageCombatantLog(
      round: (json['round'] as num).toInt(),
      turn: (json['turn'] as num).toInt(),
      combatant: Combatant.fromJson(json['combatant'] as Map<String, dynamic>),
      damage: (json['damage'] as num).toInt(),
      type: $enumDecodeNullable(_$EncounterLogTypeEnumMap, json['type']) ??
          EncounterLogType.damageCombatant,
    );

Map<String, dynamic> _$DamageCombatantLogToJson(DamageCombatantLog instance) =>
    <String, dynamic>{
      'round': instance.round,
      'turn': instance.turn,
      'type': _$EncounterLogTypeEnumMap[instance.type]!,
      'combatant': instance.combatant,
      'damage': instance.damage,
    };

CombatantInitiativeLog _$CombatantInitiativeLogFromJson(
        Map<String, dynamic> json) =>
    CombatantInitiativeLog(
      round: (json['round'] as num).toInt(),
      turn: (json['turn'] as num).toInt(),
      combatant: Combatant.fromJson(json['combatant'] as Map<String, dynamic>),
      initiative: (json['initiative'] as num).toDouble(),
      type: $enumDecodeNullable(_$EncounterLogTypeEnumMap, json['type']) ??
          EncounterLogType.combatantInitiative,
    );

Map<String, dynamic> _$CombatantInitiativeLogToJson(
        CombatantInitiativeLog instance) =>
    <String, dynamic>{
      'round': instance.round,
      'turn': instance.turn,
      'type': _$EncounterLogTypeEnumMap[instance.type]!,
      'combatant': instance.combatant,
      'initiative': instance.initiative,
    };

AddConditionsLog _$AddConditionsLogFromJson(Map<String, dynamic> json) =>
    AddConditionsLog(
      round: (json['round'] as num).toInt(),
      turn: (json['turn'] as num).toInt(),
      combatant: Combatant.fromJson(json['combatant'] as Map<String, dynamic>),
      conditions: (json['conditions'] as List<dynamic>)
          .map((e) => Condition.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: $enumDecodeNullable(_$EncounterLogTypeEnumMap, json['type']) ??
          EncounterLogType.addConditions,
    );

Map<String, dynamic> _$AddConditionsLogToJson(AddConditionsLog instance) =>
    <String, dynamic>{
      'round': instance.round,
      'turn': instance.turn,
      'type': _$EncounterLogTypeEnumMap[instance.type]!,
      'combatant': instance.combatant,
      'conditions': instance.conditions,
    };
