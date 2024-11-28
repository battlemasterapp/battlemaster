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
  static const featureKey = 'live_view';
  final bool featureEnabled;
  final bool userEnabled;

  final bool showMonsterHealth;
  final bool hideFutureCombatants;
  final bool showPlayersHealth;

  const LiveEncounterSettings({
    this.featureEnabled = false,
    this.userEnabled = true,
    this.showMonsterHealth = true,
    this.hideFutureCombatants = true,
    this.showPlayersHealth = true,
  });

  factory LiveEncounterSettings.fromJson(Map<String, dynamic> json) =>
      _$LiveEncounterSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$LiveEncounterSettingsToJson(this);

  bool get enabled => featureEnabled && userEnabled;

  Map<String, bool> get flags => {
        'show_monster_health': showMonsterHealth,
        'hide_future_combatants': hideFutureCombatants,
        'show_players_health': showPlayersHealth,
      };

  LiveEncounterSettings copyWith({
    bool? featureEnabled,
    bool? userEnabled,
    bool? autoStartStop,
    bool? showMonsterHealth,
    bool? hideFutureCombatants,
    bool? showPlayersHealth,
  }) {
    return LiveEncounterSettings(
      featureEnabled: featureEnabled ?? this.featureEnabled,
      userEnabled: userEnabled ?? this.userEnabled,
      showMonsterHealth: showMonsterHealth ?? this.showMonsterHealth,
      hideFutureCombatants: hideFutureCombatants ?? this.hideFutureCombatants,
      showPlayersHealth: showPlayersHealth ?? this.showPlayersHealth,
    );
  }
}
