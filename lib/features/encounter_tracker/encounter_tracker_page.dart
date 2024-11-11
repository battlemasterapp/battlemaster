import 'package:battlemaster/features/encounter_tracker/widgets/combatant_tracker_list.dart';
import 'package:battlemaster/features/encounter_tracker/widgets/encounter_tracker_controls.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../combatant/models/combatant.dart';
import '../settings/providers/system_settings_provider.dart';
import 'providers/encounter_tracker_notifier.dart';
import 'widgets/details_panel.dart';
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
                        encounter: encounter,
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
                        child: _TrackerPageContent(
                            encounter: encounter, trackerState: trackerState),
                      ),
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

class _TrackerPageContent extends StatefulWidget {
  const _TrackerPageContent({
    required this.encounter,
    required this.trackerState,
  });

  final Encounter encounter;
  final EncounterTrackerNotifier trackerState;

  @override
  State<_TrackerPageContent> createState() => _TrackerPageContentState();
}

class _TrackerPageContentState extends State<_TrackerPageContent> {
  Combatant? combatant;
  bool detailsOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        CombatantTrackerList(
          encounter: widget.encounter,
          onCombatantTap: (combatant) {
            setState(() {
              this.combatant = combatant;
              detailsOpen = true;
            });
          },
          selectedCombatantIndex: widget.trackerState.isPlaying
              ? widget.trackerState.activeCombatantIndex
              : null,
          onCombatantsAdded: (combatants) async {
            await context
                .read<EncountersProvider>()
                .addCombatants(widget.encounter, combatants);
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: EncounterDetailsPanel(
            combatant: combatant,
            open: detailsOpen,
            onClose: () => setState(() {
              detailsOpen = false;
            }),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: const EncounterTrackerControls(),
        ),
      ],
    );
  }
}
