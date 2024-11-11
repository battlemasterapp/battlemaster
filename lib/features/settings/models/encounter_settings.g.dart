// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encounter_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EncounterSettings _$EncounterSettingsFromJson(Map<String, dynamic> json) =>
    EncounterSettings(
      rollType:
          $enumDecodeNullable(_$InitiativeRollTypeEnumMap, json['rollType']) ??
              InitiativeRollType.monstersOnly,
      skipDeadBehavior: $enumDecodeNullable(
              _$SkipDeadBehaviorEnumMap, json['skipDeadBehavior']) ??
          SkipDeadBehavior.allButPlayers,
    );

Map<String, dynamic> _$EncounterSettingsToJson(EncounterSettings instance) =>
    <String, dynamic>{
      'rollType': _$InitiativeRollTypeEnumMap[instance.rollType]!,
      'skipDeadBehavior': _$SkipDeadBehaviorEnumMap[instance.skipDeadBehavior]!,
    };

const _$InitiativeRollTypeEnumMap = {
  InitiativeRollType.manual: 'manual',
  InitiativeRollType.monstersOnly: 'monstersOnly',
  InitiativeRollType.all: 'all',
};

const _$SkipDeadBehaviorEnumMap = {
  SkipDeadBehavior.all: 'all',
  SkipDeadBehavior.allButPlayers: 'allButPlayers',
  SkipDeadBehavior.none: 'none',
};
