import 'package:battlemaster/database/database.dart';
import 'package:battlemaster/features/encounter_tracker/encounter_tracker_page.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../combatant/models/combatant.dart';
import '../../combatant/models/combatant_type.dart';
import '../models/encounter.dart';
import 'encounter_tile.dart';

class EncountersGrid extends StatelessWidget {
  const EncountersGrid({
    super.key,
    this.encounters = const [],
    this.isLoading = false,
  });

  final List<Encounter> encounters;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return GridView.builder(
      itemCount: encounters.length + 1,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          return ElevatedButton.icon(
            onPressed: () async {
              // FIXME: for now this is hardcoded, but we will change it later
              final encounter = Encounter(
                name: "New Encounter",
                round: 0,
                combatants: [
                  Combatant(
                    name: "Goblin",
                    initiative: 15,
                    currentHp: 6,
                    maxHp: 6,
                    armorClass: 15,
                    initiativeModifier: 0,
                    type: CombatantType.monster,
                    engineType: GameEngineType.pf2e,
                  ),
                  Combatant(
                    name: "Player",
                    initiative: 10,
                    currentHp: 10,
                    maxHp: 10,
                    armorClass: 10,
                    initiativeModifier: 0,
                    type: CombatantType.player,
                    engineType: GameEngineType.pf2e,
                  ),
                ],
                engine: GameEngineType.pf2e,
              );
              final database = context.read<AppDatabase>();
              final created = await database.insertEncounter(encounter);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamed("/encounter",
                  arguments: EncounterTrackerParams(encounter: created));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add),
            label: Text(
              AppLocalizations.of(context)!.add_new_encounter,
              textAlign: TextAlign.center,
            ),
          );
        }

        if (index > encounters.length) {
          return null;
        }

        final encounter = encounters[index - 1];

        return EncounterGridTile(encounter: encounter);
      },
    );
  }
}
