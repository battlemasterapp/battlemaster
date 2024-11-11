import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../encounter_tracker/providers/encounter_tracker_notifier.dart';
import '../encounter_tracker/widgets/combatant_tracker_list.dart';
import '../encounter_tracker/widgets/encounter_tracker_bar.dart';
import '../encounters/models/encounter.dart';
import '../settings/providers/system_settings_provider.dart';

class GroupDetailPageParams {
  final Encounter encounter;

  const GroupDetailPageParams({
    required this.encounter,
  });
}

class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({
    super.key,
    required this.params,
  });

  final GroupDetailPageParams params;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EncounterTrackerNotifier(
        database: context.read<AppDatabase>(),
        settings: context.read<SystemSettingsProvider>(),
        encounterId: params.encounter.id,
      ),
      child: Builder(builder: (context) {
        return StreamBuilder<Encounter>(
            stream: context.read<EncounterTrackerNotifier>().watchEncounter(),
            builder: (context, snapshot) {
              final encounter = snapshot.data ?? params.encounter;
              return Scaffold(
                appBar: AppBar(),
                body: SafeArea(
                  child: Column(
                    children: [
                      TrackerBar(
                        displayControls: false,
                        encounter: encounter,
                        onCombatantsAdded: (value) async {
                          await context
                              .read<EncountersProvider>()
                              .addCombatants(encounter, value);
                        },
                        onTitleChanged: (value) async {
                          await context
                              .read<EncountersProvider>()
                              .editEncounterName(encounter, value);
                        },
                      ),
                      Expanded(
                        child: CombatantTrackerList(
                          encounter: encounter,
                          onCombatantsAdded: (combatants) async {
                            await context
                                .read<EncountersProvider>()
                                .addCombatants(encounter, combatants);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}
