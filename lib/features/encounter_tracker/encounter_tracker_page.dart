import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:flutter/material.dart';

class EncounterTrackerParams {
  final Encounter encounter;

  const EncounterTrackerParams({
    required this.encounter,
  });
}

class EncounterTrackerPage extends StatelessWidget {
  const EncounterTrackerPage({
    super.key,
    required this.params,
  });

  final EncounterTrackerParams params;

  @override
  Widget build(BuildContext context) {
    final encounter = params.encounter;
    return Scaffold(
      appBar: AppBar(
        title: Text(encounter.name),
      ),
      body: SafeArea(
        child: Column(
          children: [
            for (final combatant in encounter.combatants)
              ListTile(
                leading: Text(combatant.initiative.toString()),
                title: Text(combatant.name),
                trailing: Text("AC: ${combatant.armorClass}"),
                subtitle: Text("${combatant.currentHp}/${combatant.maxHp}"),
              ),
          ],
        ),
      ),
    );
  }
}
