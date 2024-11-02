import 'package:equatable/equatable.dart';

import '../../combatant/models/combatant.dart';
import '../../engines/models/game_engine_type.dart';
import 'encounter_type.dart';

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

  @override
  List<Object> get props => [
        id,
        name,
        round,
        combatants,
        engine,
      ];
}
