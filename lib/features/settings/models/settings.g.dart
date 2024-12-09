// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.light,
      analyticsEnabled: json['analyticsEnabled'] as bool? ?? true,
      encounterSettings: json['encounterSettings'] == null
          ? const EncounterSettings()
          : EncounterSettings.fromJson(
              json['encounterSettings'] as Map<String, dynamic>),
      pf2eSettings: json['pf2eSettings'] == null
          ? const PF2eSettings()
          : PF2eSettings.fromJson(json['pf2eSettings'] as Map<String, dynamic>),
      dnd5eSettings: json['dnd5eSettings'] == null
          ? const Dnd5eSettings()
          : Dnd5eSettings.fromJson(
              json['dnd5eSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'analyticsEnabled': instance.analyticsEnabled,
      'pf2eSettings': instance.pf2eSettings,
      'dnd5eSettings': instance.dnd5eSettings,
      'encounterSettings': instance.encounterSettings,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

PF2eSettings _$PF2eSettingsFromJson(Map<String, dynamic> json) => PF2eSettings(
      enabled: json['enabled'] as bool? ?? false,
      bestiaries: (json['bestiaries'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {"pathfinder-monster-core"},
    );

Map<String, dynamic> _$PF2eSettingsToJson(PF2eSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'bestiaries': instance.bestiaries.toList(),
    };

Dnd5eSettings _$Dnd5eSettingsFromJson(Map<String, dynamic> json) =>
    Dnd5eSettings(
      enabled: json['enabled'] as bool? ?? true,
      sources: (json['sources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {"wotc-srd"},
    );

Map<String, dynamic> _$Dnd5eSettingsToJson(Dnd5eSettings instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'sources': instance.sources.toList(),
    };
