import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'initiative_roll_type.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings {
  final InitiativeRollType rollType;
  final ThemeMode themeMode;
  final bool analyticsEnabled;
  final PF2eSettings pf2eSettings;
  final Dnd5eSettings dnd5eSettings;

  const Settings({
    this.rollType = InitiativeRollType.monstersOnly,
    this.themeMode = ThemeMode.light,
    this.analyticsEnabled = true,
    this.pf2eSettings = const PF2eSettings(),
    this.dnd5eSettings = const Dnd5eSettings(),
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  Settings copyWith({
    InitiativeRollType? rollType,
    ThemeMode? themeMode,
    PF2eSettings? pf2eSettings,
    Dnd5eSettings? dnd5eSettings,
    bool? analyticsEnabled,
  }) {
    return Settings(
      rollType: rollType ?? this.rollType,
      themeMode: themeMode ?? this.themeMode,
      pf2eSettings: pf2eSettings ?? this.pf2eSettings,
      dnd5eSettings: dnd5eSettings ?? this.dnd5eSettings,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
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
