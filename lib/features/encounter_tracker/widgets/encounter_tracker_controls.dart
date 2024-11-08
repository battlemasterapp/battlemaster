import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/encounter_tracker_notifier.dart';

class EncounterTrackerControls extends StatelessWidget {
  const EncounterTrackerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final isPlaying = context
        .select<EncounterTrackerNotifier, bool>((state) => state.isPlaying);
    return AnimatedSwitcher(
      duration: 300.ms,
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          child: child,
        ),
      ),
      child: isPlaying ? _EncounterControls() : const SizedBox(),
    );
  }
}

class _EncounterControls extends StatelessWidget {
  const _EncounterControls();

  @override
  Widget build(BuildContext context) {
    final trackerState = context.watch<EncounterTrackerNotifier>();
    return Material(
      elevation: 8,
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          children: [
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              color: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.skip_previous,
              ),
              onPressed: trackerState.previousRound,
            ),
            const SizedBox(width: 16),
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              color: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.arrow_left,
              ),
              onPressed: trackerState.previousTurn,
            ),
            const Spacer(),
            Text(
              AppLocalizations.of(context)!.round_counter(trackerState.round),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const Spacer(),
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              color: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.arrow_right,
              ),
              onPressed: trackerState.nextTurn,
            ),
            const SizedBox(width: 16),
            IconButton.filled(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              color: Theme.of(context).primaryColor,
              icon: Icon(
                Icons.skip_next,
              ),
              onPressed: trackerState.nextRound,
            ),
          ],
        ),
      ),
    );
  }
}
