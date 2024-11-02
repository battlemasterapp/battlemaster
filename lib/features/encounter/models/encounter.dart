import '../../combatant/models/combatant.dart';
import '../../engines/models/game_engine_type.dart';

class Encounter {
  final String name;
  final int round;
  final List<Combatant> combatants;
  final GameEngineType engine;

  Encounter({
    required this.name,
    required this.combatants,
    required this.engine,
    this.round = 0,
  });
}
