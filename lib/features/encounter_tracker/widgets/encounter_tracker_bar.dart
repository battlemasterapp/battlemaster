import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/combatant/add_combatant_page.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/settings/models/initiative_roll_type.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../../flavors/pf2e/pf2e_theme.dart';
import '../../combatant/models/combatant.dart';
import '../providers/encounter_tracker_notifier.dart';

class TrackerBar extends StatelessWidget {
  const TrackerBar({
    super.key,
    required this.encounter,
    this.onCombatantsAdded,
    this.onTitleChanged,
    this.displayControls = true,
  });

  final ValueChanged<Map<Combatant, int>>? onCombatantsAdded;
  final ValueChanged<String>? onTitleChanged;
  final bool displayControls;
  final Encounter encounter;

  @override
  Widget build(BuildContext context) {
    final trackerState = context.watch<EncounterTrackerNotifier>();
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          if (displayControls)
            Row(
              children: [
                IconButton.filled(
                  color: Theme.of(context).primaryColor,
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () async {
                    trackerState.playStop();
                    await context.read<AnalyticsService>().logEvent(
                      'play_stop',
                      props: {'is_playing': trackerState.isPlaying.toString()},
                    );
                  },
                  icon: Icon(
                    trackerState.isPlaying
                        ? MingCute.stop_fill
                        : MingCute.play_fill,
                  ),
                ),
                const SizedBox(width: 16),
                const _RollInitiativeButton(),
              ],
            ),
          const Spacer(),
          _TrackerTitle(
            title: encounter.name,
            onTitleChanged: onTitleChanged,
          ),
          const Spacer(),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            color: Colors.white,
            onPressed: () async {
              final combatantsMap = await Navigator.of(context).pushNamed(
                "/combatant/add",
                arguments: AddCombatantParams(
                  encounterType: encounter.type,
                ),
              );

              if (combatantsMap == null) {
                return;
              }

              onCombatantsAdded?.call(
                combatantsMap as Map<Combatant, int>,
              );
            },
            icon: Icon(MingCute.add_fill),
          ),
        ],
      ),
    );
  }
}

class _TrackerTitle extends StatefulWidget {
  const _TrackerTitle({
    required this.title,
    this.onTitleChanged,
  });

  final String title;
  final ValueChanged<String>? onTitleChanged;

  @override
  State<_TrackerTitle> createState() => _TrackerTitleState();
}

class _TrackerTitleState extends State<_TrackerTitle> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Theme(
        data: pf2eDarkTheme,
        child: Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                  controller: _controller,
                  onSubmitted: (value) {
                    widget.onTitleChanged?.call(value);
                    setState(() {
                      _isEditing = false;
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.onTitleChanged?.call(_controller.text);
                  setState(() {
                    _isEditing = false;
                  });
                },
                icon: Icon(MingCute.check_fill),
              )
            ],
          ),
        ),
      );
    }

    return Theme(
      data: ThemeData.dark(),
      child: Row(
        children: [
          Text(
            widget.title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
            icon: Icon(
              MingCute.pencil_fill,
              color: Colors.white.withOpacity(.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _RollInitiativeButton extends StatelessWidget {
  const _RollInitiativeButton();

  @override
  Widget build(BuildContext context) {
    final rollType = context.select<SystemSettingsProvider, InitiativeRollType>(
        (state) => state.rollType);
    if (rollType == InitiativeRollType.manual) {
      return const SizedBox();
    }

    onPressed() async {
      await context.read<EncounterTrackerNotifier>().rollInitiative();
      // ignore: use_build_context_synchronously
      await context.read<AnalyticsService>().logEvent('roll_initiative');
    }

    return IconButton.outlined(
      onPressed: onPressed,
      color: Colors.white,
      icon: Icon(FontAwesome.dice_d20_solid),
    );
  }
}
