// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      rollType:
          $enumDecodeNullable(_$InitiativeRollTypeEnumMap, json['rollType']) ??
              InitiativeRollType.manual,
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.light,
      pf2eSettings: json['pf2eSettings'] == null
          ? const PF2eSettings()
          : PF2eSettings.fromJson(json['pf2eSettings'] as Map<String, dynamic>),
      dnd5eSettings: json['dnd5eSettings'] == null
          ? const Dnd5eSettings()
          : Dnd5eSettings.fromJson(
              json['dnd5eSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'rollType': _$InitiativeRollTypeEnumMap[instance.rollType]!,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'pf2eSettings': instance.pf2eSettings,
      'dnd5eSettings': instance.dnd5eSettings,
    };

const _$InitiativeRollTypeEnumMap = {
  InitiativeRollType.manual: 'manual',
  InitiativeRollType.monstersOnly: 'monstersOnly',
  InitiativeRollType.all: 'all',
};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

PF2eSettings _$PF2eSettingsFromJson(Map<String, dynamic> json) => PF2eSettings(
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$PF2eSettingsToJson(PF2eSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
    };

Dnd5eSettings _$Dnd5eSettingsFromJson(Map<String, dynamic> json) =>
    Dnd5eSettings(
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$Dnd5eSettingsToJson(Dnd5eSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
    };
