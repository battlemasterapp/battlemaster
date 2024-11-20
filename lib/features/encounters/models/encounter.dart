import 'package:battlemaster/features/encounters/models/encounter_log.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../combatant/models/combatant.dart';
import '../../engines/models/game_engine_type.dart';
import 'encounter_type.dart';

part 'encounter.g.dart';

@JsonSerializable(explicitToJson: true)
class Encounter extends Equatable {
  final int id;
  final String name;
  final EncounterType type;
  final int round;
  final int turn;
  final List<Combatant> combatants;
  final GameEngineType engine;
  final List<EncounterLog> logs;

  const Encounter({
    required this.name,
    required this.combatants,
    required this.engine,
    this.type = EncounterType.encounter,
    this.id = -1,
    this.logs = const [],
    this.round = 1,
    this.turn = 0,
  })  : assert(round > 0),
        assert(turn >= 0);

  bool get isEncounter => type == EncounterType.encounter;

  bool get isGroup => type == EncounterType.group;

  Encounter copyWith({
    int? id,
    String? name,
    int? round,
    int? turn,
    EncounterType? type,
    List<Combatant>? combatants,
    GameEngineType? engine,
    List<EncounterLog>? logs,
  }) {
    return Encounter(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      combatants: combatants ?? this.combatants,
      engine: engine ?? this.engine,
      logs: logs ?? this.logs,
      round: round ?? this.round,
      turn: turn ?? this.turn,
    );
  }

  factory Encounter.fromJson(Map<String, dynamic> json) =>
      _$EncounterFromJson(json);

  Map<String, dynamic> toJson() => _$EncounterToJson(this);

  @override
  List<Object> get props => [
        id,
        name,
        combatants,
        engine,
        round,
        turn,
      ];
}
