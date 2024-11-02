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
  final int round;
  final EncounterType type;
  final List<Combatant> combatants;
  final GameEngineType engine;

  const Encounter({
    required this.name,
    required this.combatants,
    required this.engine,
    this.type = EncounterType.encounter,
    this.id = -1,
    this.round = 0,
  });

  Encounter copyWith({
    int? id,
    String? name,
    int? round,
    EncounterType? type,
    List<Combatant>? combatants,
    GameEngineType? engine,
  }) {
    return Encounter(
      id: id ?? this.id,
      name: name ?? this.name,
      round: round ?? this.round,
      type: type ?? this.type,
      combatants: combatants ?? this.combatants,
      engine: engine ?? this.engine,
    );
  }

  factory Encounter.fromJson(Map<String, dynamic> json) =>
      _$EncounterFromJson(json);

  Map<String, dynamic> toJson() => _$EncounterToJson(this);

  @override
  List<Object> get props => [
        id,
        name,
        round,
        combatants,
        engine,
      ];
}
