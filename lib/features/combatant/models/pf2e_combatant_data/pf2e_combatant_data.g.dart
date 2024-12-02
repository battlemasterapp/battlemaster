// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pf2e_combatant_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pf2eCombatantData _$Pf2eCombatantDataFromJson(Map<String, dynamic> json) =>
    Pf2eCombatantData(
      rawData: json['rawData'] as Map<String, dynamic>? ?? const {},
      engine: $enumDecodeNullable(_$GameEngineTypeEnumMap, json['engine']) ??
          GameEngineType.pf2e,
      template: $enumDecodeNullable(_$Pf2eTemplateEnumMap, json['template']) ??
          Pf2eTemplate.normal,
    );

Map<String, dynamic> _$Pf2eCombatantDataToJson(Pf2eCombatantData instance) =>
    <String, dynamic>{
      'rawData': instance.rawData,
      'engine': _$GameEngineTypeEnumMap[instance.engine]!,
      'template': _$Pf2eTemplateEnumMap[instance.template]!,
    };

const _$GameEngineTypeEnumMap = {
  GameEngineType.pf2e: 'pf2e',
  GameEngineType.dnd5e: 'dnd5e',
  GameEngineType.custom: 'custom',
};

const _$Pf2eTemplateEnumMap = {
  Pf2eTemplate.weak: 'weak',
  Pf2eTemplate.normal: 'normal',
  Pf2eTemplate.elite: 'elite',
};
