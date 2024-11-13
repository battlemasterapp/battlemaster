import 'package:battlemaster/api/providers/dnd5e_engine_provider.dart';
import 'package:battlemaster/api/services/pf2e_bestiary_service.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/combatant/widgets/add_custom_combatant.dart';
import 'package:battlemaster/features/combatant/widgets/add_from_bestiary_list.dart';
import 'package:battlemaster/features/combatant/widgets/add_group_combatants.dart';
import 'package:battlemaster/features/settings/providers/system_settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

enum AddCombatantSource {
  dnd5e,
  pf2e,
  group,
  custom,
}

class AddCombatant extends StatefulWidget {
  const AddCombatant({
    super.key,
    required this.onCombatantsAdded,
    this.showGroupReminder = false,
  });

  final ValueChanged<Map<Combatant, int>> onCombatantsAdded;
  final bool showGroupReminder;

  @override
  State<AddCombatant> createState() => _AddCombatantState();
}

class _AddCombatantState extends State<AddCombatant> {
  Set<AddCombatantSource> _selected = {};

  @override
  void initState() {
    super.initState();
    final systemSettings = context.read<SystemSettingsProvider>();
    if (systemSettings.pf2eSettings.enabled) {
      _selected.add(AddCombatantSource.pf2e);
    }
    if (systemSettings.dnd5eSettings.enabled) {
      _selected.clear();
      _selected.add(AddCombatantSource.dnd5e);
    }
    if (_selected.isEmpty) {
      _selected.add(AddCombatantSource.group);
    }
  }

  @override
  Widget build(BuildContext context) {
    final systemSettings = context.watch<SystemSettingsProvider>();
    var localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SegmentedButton<AddCombatantSource>(
            segments: [
              if (systemSettings.dnd5eSettings.enabled)
                ButtonSegment(
                  value: AddCombatantSource.dnd5e,
                  label: Text(localization.dnd5e_toggle_button),
                  icon: Icon(FontAwesome.dragon_solid),
                ),
              if (systemSettings.pf2eSettings.enabled)
                ButtonSegment(
                  value: AddCombatantSource.pf2e,
                  label: Text(localization.pf2e_toggle_button),
                  icon: Icon(FontAwesome.dragon_solid),
                ),
              ButtonSegment(
                value: AddCombatantSource.group,
                label: Text(localization.groups_toggle_button),
                icon: Icon(MingCute.group_fill),
              ),
              ButtonSegment(
                value: AddCombatantSource.custom,
                label: Text(localization.custom_combatant_toggle_button),
                icon: Icon(MingCute.edit_fill),
              ),
            ],
            selected: _selected,
            multiSelectionEnabled: false,
            onSelectionChanged: (selected) {
              setState(() {
                _selected = selected;
              });
            },
          ),
          Divider(),
          Expanded(child: _getSelectedWidget()),
        ],
      ),
    );
  }

  Widget _getSelectedWidget() {
    if (_selected.contains(AddCombatantSource.dnd5e)) {
      return AddFromBestiaryList(
        combatants: context.read<Dnd5eEngineProvider>().bestiary,
        onCombatantSelected: (combatant) async {
          widget.onCombatantsAdded({combatant: 1});
          await context.read<AnalyticsService>().logEvent('add_5e_combatant');
        },
      );
    }
    if (_selected.contains(AddCombatantSource.pf2e)) {
      return AddFromBestiaryList(
        combatants: context.read<Pf2eBestiaryService>().bestiaryData,
        onCombatantSelected: (combatant) async {
          widget.onCombatantsAdded({combatant: 1});
          await context.read<AnalyticsService>().logEvent('add_pf2e_combatant');
        },
      );
    }
    if (_selected.contains(AddCombatantSource.group)) {
      return AddGroupCombatants(
        onGroupSelected: (combatants) async {
          widget.onCombatantsAdded(
            combatants.fold<Map<Combatant, int>>(
              {},
              (map, combatant) {
                map[combatant] = 1;
                return map;
              },
            ),
          );
          await context
              .read<AnalyticsService>()
              .logEvent('add_group_combatants');
        },
      );
    }
    return AddCustomCombatant(
      showGroupReminder: widget.showGroupReminder,
      onCombatantAdded: (combatant) async {
        widget.onCombatantsAdded({combatant: 1});
        await context.read<AnalyticsService>().logEvent('add_custom_combatant');
      },
    );
  }
}
