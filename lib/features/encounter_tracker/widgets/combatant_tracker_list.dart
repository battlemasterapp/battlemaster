import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../combatant/models/combatant.dart';

class CombatantTrackerList extends StatelessWidget {
  const CombatantTrackerList({
    super.key,
    this.combatants = const [],
    this.selectedCombatantIndex,
    this.onCombatantsAdded,
  });

  final List<Combatant> combatants;
  final int? selectedCombatantIndex;
  final ValueChanged<Map<Combatant, int>>? onCombatantsAdded;

  @override
  Widget build(BuildContext context) {
    if (combatants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.empty_combatants_list),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final combatants =
                    await Navigator.of(context).pushNamed("/combatant/add");
                if (combatants == null) {
                  return;
                }
                onCombatantsAdded?.call(combatants as Map<Combatant, int>);
              },
              icon: Icon(Icons.add),
              label: Text(AppLocalizations.of(context)!.add_combatants_button),
            ),
          ],
        ),
      );
    }
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
