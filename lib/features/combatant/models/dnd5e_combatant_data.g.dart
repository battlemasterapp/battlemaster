// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dnd5e_combatant_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dnd5eCombatantData _$Dnd5eCombatantDataFromJson(Map<String, dynamic> json) =>
    Dnd5eCombatantData(
      engine: $enumDecodeNullable(_$GameEngineTypeEnumMap, json['engine']) ??
          GameEngineType.dnd5e,
      rawData: json['rawData'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$Dnd5eCombatantDataToJson(Dnd5eCombatantData instance) =>
    <String, dynamic>{
      'rawData': instance.rawData,
      'engine': _$GameEngineTypeEnumMap[instance.engine]!,
    };

const _$GameEngineTypeEnumMap = {
  GameEngineType.pf2e: 'pf2e',
  GameEngineType.dnd5e: 'dnd5e',
  GameEngineType.custom: 'custom',
};
