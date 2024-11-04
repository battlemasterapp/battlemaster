import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../combatant/models/combatant.dart';
import '../providers/encounter_tracker_notifier.dart';

class CombatantTrackerList extends StatelessWidget {
  const CombatantTrackerList({
    super.key,
    this.combatants = const [],
  });

  final List<Combatant> combatants;

  @override
  Widget build(BuildContext context) {
    final trackerState = context.watch<EncounterTrackerNotifier>();
    return ListView.builder(
      itemCount: combatants.length,
      itemBuilder: (context, index) {
        final combatant = combatants[index];
        final selected = trackerState.activeCombatantIndex == index && trackerState.isPlaying;
        return ListTile(
          leading: Text(combatant.initiative.toString()),
          title: Text(combatant.name),
          trailing: Text("AC: ${combatant.armorClass}"),
          subtitle: Text("${combatant.currentHp}/${combatant.maxHp}"),
          selected: selected,
        );
      },
    );
  }
}
