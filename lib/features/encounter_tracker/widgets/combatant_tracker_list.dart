import 'dart:async';

import 'package:battlemaster/features/encounter_tracker/providers/encounter_tracker_notifier.dart';
import 'package:battlemaster/features/encounters/providers/encounters_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../combatant/models/combatant.dart';
import '../../encounters/models/encounter.dart';
import 'tracker_tile.dart';

class CombatantTrackerList extends StatefulWidget {
  const CombatantTrackerList({
    super.key,
    this.selectedCombatantIndex,
    this.onCombatantsAdded,
    required this.encounter,
  });

  final Encounter encounter;
  final int? selectedCombatantIndex;
  final ValueChanged<Map<Combatant, int>>? onCombatantsAdded;

  @override
  State<CombatantTrackerList> createState() => _CombatantTrackerListState();
}

class _CombatantTrackerListState extends State<CombatantTrackerList> {
  final _listController = ScrollController();
  late ListObserverController _observerController;
  late StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();
    _observerController = ListObserverController(controller: _listController);
    _sub = context
        .read<EncounterTrackerNotifier>()
        .activeIndexStream
        .listen((index) {
      debugPrint('Animating to index: $index');
      _observerController.animateTo(
        index: index,
        duration: 500.ms,
        curve: Curves.easeInOutQuad,
      );
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    _sub.cancel();
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
                final combatants =
                    await Navigator.of(context).pushNamed("/combatant/add");
                if (combatants == null) {
                  return;
                }
                widget.onCombatantsAdded
                    ?.call(combatants as Map<Combatant, int>);
              },
              icon: Icon(Icons.add),
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
        itemBuilder: (context, index) {
          final combatant = combatants[index];
          return Padding(
            key: Key('$index'),
            padding: const EdgeInsets.all(8.0),
            child: TrackerTile(
              combatant: combatant,
              selected: index == widget.selectedCombatantIndex,
              index: index,
              onRemove: () async {
                await context
                    .read<EncountersProvider>()
                    .removeCombatant(widget.encounter, combatant);
              },
              onHealthChanged: (health) async {
                await context.read<EncountersProvider>().editCombatant(
                      widget.encounter,
                      combatant.copyWith(currentHp: health),
                      index,
                    );
              },
              onInitiativeChanged: (initiative) async {
                debugPrint(initiative.toString());
                await context.read<EncountersProvider>().editCombatant(
                      widget.encounter,
                      combatant.copyWith(initiative: initiative),
                      index,
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
