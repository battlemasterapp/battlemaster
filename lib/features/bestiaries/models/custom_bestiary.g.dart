// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_bestiary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomBestiary _$CustomBestiaryFromJson(Map<String, dynamic> json) =>
    CustomBestiary(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      combatants: (json['combatants'] as List<dynamic>)
          .map((e) => Combatant.fromJson(e as Map<String, dynamic>))
          .toList(),
      engine: $enumDecode(_$GameEngineTypeEnumMap, json['engine']),
    );

Map<String, dynamic> _$CustomBestiaryToJson(CustomBestiary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'combatants': instance.combatants,
      'engine': _$GameEngineTypeEnumMap[instance.engine]!,
    };

const _$GameEngineTypeEnumMap = {
  GameEngineType.pf2e: 'pf2e',
  GameEngineType.dnd5e: 'dnd5e',
  GameEngineType.custom: 'custom',
};
