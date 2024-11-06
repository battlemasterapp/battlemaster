import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'initiative_roll_type.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings {
  final InitiativeRollType rollType;
  final ThemeMode themeMode;
  final PF2eSettings pf2eSettings;

  const Settings({
    this.rollType = InitiativeRollType.manual,
    this.themeMode = ThemeMode.light,
    this.pf2eSettings = const PF2eSettings(),
  });

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  Settings copyWith({
    InitiativeRollType? rollType,
    ThemeMode? themeMode,
    PF2eSettings? pf2eSettings,
  }) {
    return Settings(
      rollType: rollType ?? this.rollType,
      themeMode: themeMode ?? this.themeMode,
      pf2eSettings: pf2eSettings ?? this.pf2eSettings,
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
