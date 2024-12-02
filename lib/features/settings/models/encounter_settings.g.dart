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
      liveEncounterSettings: json['liveEncounterSettings'] == null
          ? const LiveEncounterSettings()
          : LiveEncounterSettings.fromJson(
              json['liveEncounterSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EncounterSettingsToJson(EncounterSettings instance) =>
    <String, dynamic>{
      'rollType': _$InitiativeRollTypeEnumMap[instance.rollType]!,
      'skipDeadBehavior': _$SkipDeadBehaviorEnumMap[instance.skipDeadBehavior]!,
      'liveEncounterSettings': instance.liveEncounterSettings,
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

LiveEncounterSettings _$LiveEncounterSettingsFromJson(
        Map<String, dynamic> json) =>
    LiveEncounterSettings(
      featureEnabled: json['featureEnabled'] as bool? ?? false,
      userEnabled: json['userEnabled'] as bool? ?? true,
      showMonsterHealth: json['showMonsterHealth'] as bool? ?? true,
      hideFutureCombatants: json['hideFutureCombatants'] as bool? ?? true,
      showPlayersHealth: json['showPlayersHealth'] as bool? ?? true,
    );

Map<String, dynamic> _$LiveEncounterSettingsToJson(
        LiveEncounterSettings instance) =>
    <String, dynamic>{
      'featureEnabled': instance.featureEnabled,
      'userEnabled': instance.userEnabled,
      'showMonsterHealth': instance.showMonsterHealth,
      'hideFutureCombatants': instance.hideFutureCombatants,
      'showPlayersHealth': instance.showPlayersHealth,
    };
