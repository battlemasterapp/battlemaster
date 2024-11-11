import 'package:battlemaster/features/settings/models/encounter_settings.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings {
  final ThemeMode themeMode;
  final bool analyticsEnabled;
  final PF2eSettings pf2eSettings;
  final Dnd5eSettings dnd5eSettings;
  final EncounterSettings encounterSettings;

  const Settings({
    this.themeMode = ThemeMode.light,
    this.analyticsEnabled = true,
    this.encounterSettings = const EncounterSettings(),
    this.pf2eSettings = const PF2eSettings(),
    this.dnd5eSettings = const Dnd5eSettings(),
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  Settings copyWith({
    ThemeMode? themeMode,
    PF2eSettings? pf2eSettings,
    Dnd5eSettings? dnd5eSettings,
    EncounterSettings? encounterSettings,
    bool? analyticsEnabled,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      pf2eSettings: pf2eSettings ?? this.pf2eSettings,
      dnd5eSettings: dnd5eSettings ?? this.dnd5eSettings,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      encounterSettings: encounterSettings ?? this.encounterSettings,
    );
  }
}

@JsonSerializable()
class PF2eSettings {
  final bool enabled;

  const PF2eSettings({
    this.enabled = true,
  });

  factory PF2eSettings.fromJson(Map<String, dynamic> json) =>
      _$PF2eSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PF2eSettingsToJson(this);

  PF2eSettings copyWith({
    bool? enabled,
  }) {
    return PF2eSettings(
      enabled: enabled ?? this.enabled,
    );
  }
}

@JsonSerializable()
class Dnd5eSettings {
  final bool enabled;

  const Dnd5eSettings({
    this.enabled = true,
  });

  factory Dnd5eSettings.fromJson(Map<String, dynamic> json) =>
      _$Dnd5eSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$Dnd5eSettingsToJson(this);

  Dnd5eSettings copyWith({
    bool? enabled,
  }) {
    return Dnd5eSettings(
      enabled: enabled ?? this.enabled,
    );
  }
}
