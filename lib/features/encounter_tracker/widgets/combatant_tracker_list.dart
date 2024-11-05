import 'package:battlemaster/features/encounter_tracker/providers/encounter_tracker_notifier.dart';
import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../combatant/models/combatant.dart';
import '../../encounters/models/encounter.dart';
import 'tracker_tile.dart';

class CombatantTrackerList extends StatelessWidget {
  const CombatantTrackerList({
    super.key,
    this.selectedCombatantIndex,
    this.onCombatantsAdded,
    required this.encounter,
  });

  final Encounter encounter;
  final int? selectedCombatantIndex;
  final ValueChanged<Map<Combatant, int>>? onCombatantsAdded;

  @override
  Widget build(BuildContext context) {
    final combatants = encounter.combatants;
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
    return ReorderableListView.builder(
      itemBuilder: (context, index) {
        final combatant = combatants[index];
        return Padding(
          key: Key('$index'),
          padding: const EdgeInsets.all(8.0),
          child: TrackerTile(
            combatant: combatant,
            selected: index == selectedCombatantIndex,
            index: index,
            onRemove: () async {
              await context
                  .read<EncountersProvider>()
                  .removeCombatant(encounter, combatant);
            },
            onHealthChanged: (health) async {
              await context.read<EncountersProvider>().editCombatant(
                    encounter,
                    combatant.copyWith(currentHp: health),
                    index,
                  );
            },
            onInitiativeChanged: (initiative) async {
              debugPrint(initiative.toString());
              await context.read<EncountersProvider>().editCombatant(
                    encounter,
                    combatant.copyWith(initiative: initiative),
                    index,
                  );
            },
          ),
        );
      },
      itemCount: combatants.length,
      onReorder: (oldIndex, newIndex) async {
        await context.read<EncounterTrackerNotifier>().reorderCombatants(
              oldIndex,
              newIndex,
            );
      },
    );
  }
}
