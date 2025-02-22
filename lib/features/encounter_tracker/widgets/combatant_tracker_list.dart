import 'dart:async';

import 'package:battlemaster/features/combatant/add_combatant_page.dart';
import 'package:battlemaster/features/encounter_tracker/providers/encounter_tracker_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../combatant/models/combatant.dart';
import '../../encounters/models/encounter.dart';
import 'tracker_tile.dart';

typedef OnCombatantTap = void Function(Combatant combatant, int index);

class CombatantTrackerList extends StatefulWidget {
  const CombatantTrackerList({
    super.key,
    required this.encounter,
    this.selectedCombatantIndex,
    this.onCombatantsAdded,
    this.onCombatantTap,
  });

  final Encounter encounter;
  final int? selectedCombatantIndex;
  final ValueChanged<Map<Combatant, int>>? onCombatantsAdded;
  final OnCombatantTap? onCombatantTap;

  @override
  State<CombatantTrackerList> createState() => _CombatantTrackerListState();
}

class _CombatantTrackerListState extends State<CombatantTrackerList> {
  final _listController = ScrollController();
  late ListObserverController _observerController;
  StreamSubscription<int>? _sub;

  @override
  void initState() {
    super.initState();
    _observerController = ListObserverController(controller: _listController);
    _sub ??= context
        .read<EncounterTrackerNotifier>()
        .activeIndexStream
        .listen((index) {
      _observerController.animateTo(
        index: index,
        duration: 500.ms,
        curve: Curves.easeInOutQuad,
        padding: EdgeInsets.only(bottom: 100),
      );
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final combatants = widget.encounter.combatants;
    if (combatants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.empty_combatants_list),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final combatants = await context.pushNamed(
                  "add-combatant",
                  pathParameters: {
                    'encounterId': widget.encounter.id.toString()
                  },
                  extra: AddCombatantParams(
                    encounterType: widget.encounter.type,
                  ),
                );
                if (combatants == null) {
                  return;
                }
                widget.onCombatantsAdded
                    ?.call(combatants as Map<Combatant, int>);
              },
              icon: Icon(MingCute.add_fill),
              label: Text(AppLocalizations.of(context)!.add_combatants_button),
            ),
          ],
        ),
      );
    }
    return ListViewObserver(
      controller: _observerController,
      child: ReorderableListView.builder(
        scrollController: _listController,
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        itemBuilder: (context, index) {
          final combatant = combatants[index];
          return Padding(
            key: Key('$index'),
            padding: const EdgeInsets.all(8),
            child: TrackerTile(
              combatant: combatant,
              selected: index == widget.selectedCombatantIndex,
              index: index,
              onTap: widget.onCombatantTap != null
                  ? () => widget.onCombatantTap?.call(combatant, index)
                  : null,
              onRemove: () async {
                await context
                    .read<EncounterTrackerNotifier>()
                    .removeCombatant(combatant);
              },
              onHealthChanged: (health) async {
                await context
                    .read<EncounterTrackerNotifier>()
                    .updateCombatantHealth(
                      combatant,
                      health,
                    );
              },
              onInitiativeChanged: (initiative) async {
                await context
                    .read<EncounterTrackerNotifier>()
                    .updateCombatantInitiative(
                      combatant,
                      initiative,
                    );
              },
            ),
          );
        },
        itemCount: combatants.length,
        onReorder: (oldIndex, newIndex) async {
          await context.read<EncounterTrackerNotifier>().reorderCombatants(
                oldIndex,
                newIndex,
              );
        },
      ),
    );
  }
}
