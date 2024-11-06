import 'package:battlemaster/features/encounter_tracker/widgets/combatant_tracker_list.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/encounter_tracker_controls.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../settings/providers/system_settings_provider.dart';
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
        settings: context.read<SystemSettingsProvider>(),
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
                  title: Text(AppLocalizations.of(context)!
                      .encounter_tracker_page_title),
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      TrackerBar(
                        title: encounter.name,
                        onTitleChanged: (title) async {
                          await context
                              .read<EncountersProvider>()
                              .editEncounterName(encounter, title);
                        },
                        onCombatantsAdded: (combatantsMap) async {
                          await context
                              .read<EncountersProvider>()
                              .addCombatants(encounter, combatantsMap);
                        },
                      ),
                      Expanded(
                        child: CombatantTrackerList(
                          encounter: encounter,
                          selectedCombatantIndex: trackerState.isPlaying
                              ? trackerState.activeCombatantIndex
                              : null,
                          onCombatantsAdded: (combatants) async {
                            await context
                                .read<EncountersProvider>()
                                .addCombatants(encounter, combatants);
                          },
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
