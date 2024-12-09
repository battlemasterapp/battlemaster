// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      rollType: $enumDecode(_$InitiativeRollTypeEnumMap, json['rollType']),
      themeMode: $enumDecode(_$ThemeModeEnumMap, json['themeMode']),
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'rollType': _$InitiativeRollTypeEnumMap[instance.rollType]!,
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
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
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$PF2eSettingsToJson(PF2eSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
    };
