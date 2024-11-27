import 'package:battlemaster/features/settings/models/initiative_roll_type.dart';
import 'package:battlemaster/features/settings/models/skip_dead_behavior.dart';
import 'package:json_annotation/json_annotation.dart';

part 'encounter_settings.g.dart';

@JsonSerializable()
class EncounterSettings {
  final InitiativeRollType rollType;
  final SkipDeadBehavior skipDeadBehavior;
  final LiveEncounterSettings liveEncounterSettings;

  const EncounterSettings({
    this.rollType = InitiativeRollType.monstersOnly,
    this.skipDeadBehavior = SkipDeadBehavior.allButPlayers,
    this.liveEncounterSettings = const LiveEncounterSettings(),
  });

  factory EncounterSettings.fromJson(Map<String, dynamic> json) =>
      _$EncounterSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$EncounterSettingsToJson(this);

  EncounterSettings copyWith({
    InitiativeRollType? rollType,
    SkipDeadBehavior? skipDeadBehavior,
    LiveEncounterSettings? liveEncounterSettings,
  }) {
    return EncounterSettings(
      rollType: rollType ?? this.rollType,
      skipDeadBehavior: skipDeadBehavior ?? this.skipDeadBehavior,
      liveEncounterSettings:
          liveEncounterSettings ?? this.liveEncounterSettings,
    );
  }
}

@JsonSerializable()
class LiveEncounterSettings {
  final bool enabled;
  final bool autoStartStop;

  // FIXME: this values should be sent with the live encounter
  final bool showMonsterHealth;
  final bool hideFutureCombatants;

  const LiveEncounterSettings({
    this.enabled = false,
    this.autoStartStop = false,
    this.showMonsterHealth = true,
    this.hideFutureCombatants = true,
  });

  factory LiveEncounterSettings.fromJson(Map<String, dynamic> json) =>
      _$LiveEncounterSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$LiveEncounterSettingsToJson(this);

  LiveEncounterSettings copyWith({
    bool? enabled,
    bool? autoStartStop,
    bool? showMonsterHealth,
    bool? hideFutureCombatants,
  }) {
    return LiveEncounterSettings(
      enabled: enabled ?? this.enabled,
      autoStartStop: autoStartStop ?? this.autoStartStop,
      showMonsterHealth: showMonsterHealth ?? this.showMonsterHealth,
      hideFutureCombatants: hideFutureCombatants ?? this.hideFutureCombatants,
    );
  }
}
