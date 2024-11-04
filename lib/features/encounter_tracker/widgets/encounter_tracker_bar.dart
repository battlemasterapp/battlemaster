import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/encounter_tracker_notifier.dart';

class TrackerMasterBar extends StatelessWidget {
  const TrackerMasterBar({super.key});

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
        ],
      ),
    );
  }
}
