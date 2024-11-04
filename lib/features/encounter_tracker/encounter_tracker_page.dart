import 'package:battlemaster/features/encounter_tracker/widgets/combatant_tracker_list.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/encounter_tracker_controls.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import 'providers/encounter_tracker_notifier.dart';
import 'widgets/encounter_tracker_bar.dart';

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
    return ChangeNotifierProvider(
      create: (context) => EncounterTrackerNotifier(
        database: context.read<AppDatabase>(),
        encounterId: params.encounter.id,
      ),
      child: Builder(
        builder: (context) {
          final trackerState = context.watch<EncounterTrackerNotifier>();
          return StreamBuilder<Encounter>(
            stream: trackerState.watchEncounter(),
            builder: (context, snapshot) {
              final encounter = snapshot.data ?? params.encounter;
              return Scaffold(
                appBar: AppBar(
                  title: Text(encounter.name),
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      const TrackerMasterBar(),
                      Expanded(
                        child: CombatantTrackerList(
                          combatants: encounter.combatants,
                          selectedCombatantIndex: trackerState.isPlaying
                              ? trackerState.activeCombatantIndex
                              : null,
                        ),
                      ),
                      const EncounterTrackerControls(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
