import 'package:battlemaster/features/settings/models/initiative_roll_type.dart';
import 'package:battlemaster/features/settings/models/skip_dead_behavior.dart';
import 'package:json_annotation/json_annotation.dart';

part 'encounter_settings.g.dart';

@JsonSerializable()
class EncounterSettings {
  final InitiativeRollType rollType;
  final SkipDeadBehavior skipDeadBehavior;

  const EncounterSettings({
    this.rollType = InitiativeRollType.monstersOnly,
    this.skipDeadBehavior = SkipDeadBehavior.allButPlayers,
  });

  factory EncounterSettings.fromJson(Map<String, dynamic> json) =>
      _$EncounterSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$EncounterSettingsToJson(this);

  EncounterSettings copyWith({
    InitiativeRollType? rollType,
    SkipDeadBehavior? skipDeadBehavior,
  }) {
    return EncounterSettings(
      rollType: rollType ?? this.rollType,
      skipDeadBehavior: skipDeadBehavior ?? this.skipDeadBehavior,
    );
  }
}
