import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../combatant/models/combatant.dart';
import '../providers/encounter_tracker_notifier.dart';

class TrackerBar extends StatelessWidget {
  const TrackerBar({
    super.key,
    this.onCombatantsAdded,
  });

  final ValueChanged<List<Combatant>>? onCombatantsAdded;

  @override
  Widget build(BuildContext context) {
    final trackerState = context.watch<EncounterTrackerNotifier>();
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton.outlined(
            onPressed: () {
              trackerState.playStop();
            },
            icon: Icon(
              trackerState.isPlaying ? Icons.stop : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            color: Colors.white,
            onPressed: () async {
              final combatantsMap =
                  await Navigator.of(context).pushNamed("/combatant/add");
              debugPrint(combatantsMap.toString());

              if (combatantsMap == null) {
                return;
              }

              onCombatantsAdded?.call(
                (combatantsMap as Map<Combatant, int>)
                    .entries
                    .fold<List<Combatant>>(
                  [],
                  (combatants, mapEntry) {
                    return [
                      ...combatants,
                      ...List.generate(mapEntry.value, (index) => mapEntry.key),
                    ];
                  },
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
