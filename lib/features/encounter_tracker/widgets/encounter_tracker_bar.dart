import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/combatant/add_combatant_page.dart';
import 'package:battlemaster/features/encounters/models/encounter.dart';
import 'package:battlemaster/features/settings/models/initiative_roll_type.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../../flavors/pf2e/pf2e_theme.dart';
import '../../combatant/models/combatant.dart';
import '../providers/encounter_tracker_notifier.dart';

class TrackerBar extends StatefulWidget {
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
  State<TrackerBar> createState() => _TrackerBarState();
}

class _TrackerBarState extends State<TrackerBar> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return Container(
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TitleEdit(
              title: widget.encounter.name,
              onTitleChanged: (value) {
                widget.onTitleChanged?.call(value);
                setState(() {
                  _editing = false;
                });
              },
            ),
          ],
        ),
      );
    }

    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.displayControls) const _BarControls(),
          if (!widget.displayControls) const SizedBox.shrink(),
          Expanded(
            child: _TrackerTitle(
              title: widget.encounter.name,
              onEdit: () => setState(() => _editing = true),
            ),
          ),
          _AddCombatantButton(
            encounter: widget.encounter,
            onCombatantsAdded: widget.onCombatantsAdded,
          ),
        ],
      ),
    );
  }
}

class _TitleEdit extends StatefulWidget {
  const _TitleEdit({
    required this.title,
    this.onTitleChanged,
  });

  final String title;
  final ValueChanged<String>? onTitleChanged;

  @override
  State<_TitleEdit> createState() => _TitleEditState();
}

class _TitleEditState extends State<_TitleEdit> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Theme(
      data: pf2eDarkTheme,
      child: Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: min(400, width * .5)),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                ),
                controller: _controller,
                onSubmitted: (value) {
                  widget.onTitleChanged?.call(value);
                },
              ),
            ),
            IconButton(
              onPressed: () {
                widget.onTitleChanged?.call(_controller.text);
              },
              icon: Icon(MingCute.check_fill),
            )
          ],
        ),
      ),
    );
  }
}

class _BarControls extends StatelessWidget {
  const _BarControls();

  @override
  Widget build(BuildContext context) {
    final trackerState = context.watch<EncounterTrackerNotifier>();
    return Row(
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
            trackerState.isPlaying ? MingCute.stop_fill : MingCute.play_fill,
          ),
        ),
        const SizedBox(width: 16),
        const _RollInitiativeButton(),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _AddCombatantButton extends StatelessWidget {
  const _AddCombatantButton({
    required this.encounter,
    required this.onCombatantsAdded,
  });

  final Encounter encounter;
  final ValueChanged<Map<Combatant, int>>? onCombatantsAdded;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      color: Colors.white,
      onPressed: () async {
        final combatantsMap = await context.pushNamed(
          "add-combatant",
          pathParameters: {'encounterId': encounter.id.toString()},
          extra: AddCombatantParams(
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
    );
  }
}

class _TrackerTitle extends StatelessWidget {
  const _TrackerTitle({
    required this.title,
    this.onEdit,
  });

  final String title;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          AutoSizeText(
            title,
            minFontSize: 18,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white),
          ),
          IconButton(
            onPressed: onEdit,
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
