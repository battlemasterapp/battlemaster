import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/combatant_type.dart';

enum SkipDeadBehavior {
  all,
  allButPlayers,
  none,
}

extension SkipCombatants on SkipDeadBehavior {
  bool shouldSkip(Combatant combatant) {
    switch (this) {
      case SkipDeadBehavior.all:
        return !combatant.isAlive;
      case SkipDeadBehavior.allButPlayers:
        return combatant.type != CombatantType.player && !combatant.isAlive;
      case SkipDeadBehavior.none:
        return false;
    }
  }
}
