import 'package:battlemaster/features/combatant/models/combatant.dart';

class EncounterView {
  final int round;
  final int turn;
  final List<Combatant> combatants;

  EncounterView({
    required this.round,
    required this.turn,
    required this.combatants,
  });

  factory EncounterView.fromRecord(Map<String, dynamic> record) {
    return EncounterView(
      round: record['round'],
      turn: record['turn'],
      combatants: (record['combatants'] as List)
          .map((e) => Combatant.fromJson(e))
          .toList(),
    );
  }
}
