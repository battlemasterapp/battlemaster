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
    );

Map<String, dynamic> _$AddCombatantLogToJson(AddCombatantLog instance) =>
    <String, dynamic>{
      'round': instance.round,
      'turn': instance.turn,
      'combatant': instance.combatant,
    };

RemoveCombatantLog _$RemoveCombatantLogFromJson(Map<String, dynamic> json) =>
    RemoveCombatantLog(
      round: (json['round'] as num).toInt(),
      turn: (json['turn'] as num).toInt(),
      combatant: Combatant.fromJson(json['combatant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RemoveCombatantLogToJson(RemoveCombatantLog instance) =>
    <String, dynamic>{
      'round': instance.round,
      'turn': instance.turn,
      'combatant': instance.combatant,
    };

DamageCombatantLog _$DamageCombatantLogFromJson(Map<String, dynamic> json) =>
    DamageCombatantLog(
      round: (json['round'] as num).toInt(),
      turn: (json['turn'] as num).toInt(),
      combatant: Combatant.fromJson(json['combatant'] as Map<String, dynamic>),
      damage: (json['damage'] as num).toInt(),
    );

Map<String, dynamic> _$DamageCombatantLogToJson(DamageCombatantLog instance) =>
    <String, dynamic>{
      'round': instance.round,
      'turn': instance.turn,
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
    );

Map<String, dynamic> _$CombatantInitiativeLogToJson(
        CombatantInitiativeLog instance) =>
    <String, dynamic>{
      'round': instance.round,
      'turn': instance.turn,
      'combatant': instance.combatant,
      'initiative': instance.initiative,
    };
