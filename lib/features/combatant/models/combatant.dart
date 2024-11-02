import 'package:battlemaster/features/combatant/models/combatant_data.dart';

import '../../engines/models/game_engine_type.dart';
import 'combatant_type.dart';

class Combatant {
  final String name;
  final int currentHp;
  final int maxHp;
  final int initiative;
  final int armorClass;
  final int initiativeModifier;
  final CombatantType type;
  final GameEngineType engineType;
  final CombatantData? combatantData;

  Combatant({
    required this.name,
    required this.currentHp,
    required this.maxHp,
    required this.armorClass,
    required this.initiativeModifier,
    required this.type,
    required this.engineType,
    this.initiative = 0,
    this.combatantData,
  });
}
