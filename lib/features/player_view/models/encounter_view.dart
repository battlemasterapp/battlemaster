import 'package:battlemaster/features/combatant/models/combatant.dart';

class EncounterView {
  final int round;
  final int turn;
  final List<Combatant> combatants;
  final String code;
  final bool showMonsterHealth;
  final bool hideFutureCombatants;

  EncounterView({
    required this.round,
    required this.turn,
    required this.combatants,
    required this.code,
    this.showMonsterHealth = true,
    this.hideFutureCombatants = true,
  });

  factory EncounterView.fromRecord(Map<String, dynamic> record) {
    return EncounterView(
      round: record['round'],
      turn: record['turn'],
      code: record['joinCode'],
      combatants: (record['combatants'] as List)
          .map((e) => Combatant.fromJson(e))
          .toList(),
      showMonsterHealth: record['flags']?['show_monster_health'] ?? true,
      hideFutureCombatants: record['flags']?['hide_future_combatants'] ?? true,
    );
  }
}
