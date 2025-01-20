import 'package:battlemaster/features/encounter_tracker/widgets/details_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../encounter_tracker/providers/encounter_tracker_notifier.dart';
import '../encounter_tracker/widgets/combatant_tracker_list.dart';
import '../encounter_tracker/widgets/encounter_tracker_bar.dart';
import '../encounters/models/encounter.dart';
import '../settings/providers/system_settings_provider.dart';

class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({
    super.key,
    required this.groupId,
  });

  final int groupId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EncounterTrackerNotifier(
        database: context.read<AppDatabase>(),
        settings: context.read<SystemSettingsProvider>(),
        encounterId: groupId,
      ),
      child: Builder(builder: (context) {
        return StreamBuilder<Encounter>(
            stream: context.read<EncounterTrackerNotifier>().watchEncounter(),
            builder: (context, snapshot) {
              final encounter = snapshot.data;

              if (encounter == null) {
                return Scaffold(
                  appBar: AppBar(),
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

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
                              .read<EncounterTrackerNotifier>()
                              .addCombatants(value);
                        },
                        onTitleChanged: (value) async {
                          await context
                              .read<EncounterTrackerNotifier>()
                              .editName(value);
                        },
                      ),
                      Expanded(
                        child: _GroupDetailsContent(encounter: encounter),
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

class _GroupDetailsContent extends StatefulWidget {
  const _GroupDetailsContent({required this.encounter});

  final Encounter encounter;

  @override
  State<_GroupDetailsContent> createState() => _GroupDetailsContentState();
}

class _GroupDetailsContentState extends State<_GroupDetailsContent> {
  int? combatantIndex;
  bool detailsOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        CombatantTrackerList(
          encounter: widget.encounter,
          onCombatantTap: (combatant, index) {
            setState(() {
              combatantIndex = index;
              detailsOpen = true;
            });
          },
          onCombatantsAdded: (combatants) async {
            await context
                .read<EncounterTrackerNotifier>()
                .addCombatants(combatants);
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: EncounterDetailsPanel(
            combatant: combatantIndex != null
                ? widget.encounter.combatants[combatantIndex!]
                : null,
            open: detailsOpen,
            onClose: () => setState(() {
              detailsOpen = false;
              combatantIndex = null;
            }),
            onConditionsAdded: (conditions) async {
              final combatant = widget.encounter.combatants[combatantIndex!];
              await context
                  .read<EncounterTrackerNotifier>()
                  .updateCombatantsConditions(
                    combatant,
                    conditions,
                  );
            },
          ),
        ),
      ],
    );
  }
}
