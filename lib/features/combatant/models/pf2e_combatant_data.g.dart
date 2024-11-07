// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pf2e_combatant_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pf2eCombatantData _$Pf2eCombatantDataFromJson(Map<String, dynamic> json) =>
    Pf2eCombatantData(
      engine: $enumDecodeNullable(_$GameEngineTypeEnumMap, json['engine']) ??
          GameEngineType.pf2e,
      rawData: json['rawData'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$Pf2eCombatantDataToJson(Pf2eCombatantData instance) =>
    <String, dynamic>{
      'rawData': instance.rawData,
      'engine': _$GameEngineTypeEnumMap[instance.engine]!,
    };

const _$GameEngineTypeEnumMap = {
  GameEngineType.pf2e: 'pf2e',
  GameEngineType.dnd5e: 'dnd5e',
  GameEngineType.custom: 'custom',
};
