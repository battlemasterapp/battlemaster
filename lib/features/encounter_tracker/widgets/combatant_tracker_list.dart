import 'package:flutter/material.dart';

import '../../combatant/models/combatant.dart';

class CombatantTrackerList extends StatelessWidget {
  const CombatantTrackerList({
    super.key,
    this.combatants = const [],
    this.selectedCombatantIndex,
  });

  final List<Combatant> combatants;
  final int? selectedCombatantIndex;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: combatants.length,
      itemBuilder: (context, index) {
        final combatant = combatants[index];
        return ListTile(
          leading: Text(combatant.initiative.toString()),
          title: Text(combatant.name),
          trailing: Text("AC: ${combatant.armorClass}"),
          subtitle: Text("${combatant.currentHp}/${combatant.maxHp}"),
          selected: index == selectedCombatantIndex,
        );
      },
    );
  }
}
