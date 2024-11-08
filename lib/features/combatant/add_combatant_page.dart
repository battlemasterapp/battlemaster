import 'package:battlemaster/api/services/dnd5e_bestiary_service.dart';
import 'package:battlemaster/api/services/pf2e_bestiary_service.dart';
import 'package:battlemaster/features/analytics/analytics_service.dart';
import 'package:battlemaster/features/combatant/widgets/add_custom_combatant.dart';
import 'package:battlemaster/features/combatant/widgets/add_from_bestiary_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../settings/providers/system_settings_provider.dart';
import 'models/combatant.dart';
import 'widgets/add_group_combatants.dart';
import 'widgets/selected_combatants.dart';

class AddCombatantPage extends StatefulWidget {
  const AddCombatantPage({super.key});

  @override
  State<AddCombatantPage> createState() => _AddCombatantPageState();
}

class _AddCombatantPageState extends State<AddCombatantPage> {
  Map<Combatant, int> _combatants = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.add_combatant_title),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: _AddCombatant(
                onCombatantsAdded: (combatants) {
                  setState(() {
                    combatants.forEach((combatant, count) {
                      _combatants.update(
                        combatant,
                        (value) => value + count,
                        ifAbsent: () => count,
                      );
                    });
                  });
                },
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SelectedCombatants(
                      combatants: _combatants,
                      onCombatantsChanged: (combatants) {
                        setState(() {
                          _combatants = combatants;
                        });
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child:
                            Text(AppLocalizations.of(context)!.cancel_button),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(_combatants);
                        },
                        child: Text(AppLocalizations.of(context)!.save_button),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _AddCombatantSource {
  dnd5e,
  pf2e,
  group,
  custom,
}

class _AddCombatant extends StatefulWidget {
  const _AddCombatant({
    required this.onCombatantsAdded,
  });

  final ValueChanged<Map<Combatant, int>> onCombatantsAdded;

  @override
  State<_AddCombatant> createState() => _AddCombatantState();
}

class _AddCombatantState extends State<_AddCombatant> {
  Set<_AddCombatantSource> _selected = {};

  @override
  void initState() {
    super.initState();
    final systemSettings = context.read<SystemSettingsProvider>();
    if (systemSettings.pf2eSettings.enabled) {
      _selected.add(_AddCombatantSource.pf2e);
    }
    if (systemSettings.dnd5eSettings.enabled) {
      _selected.clear();
      _selected.add(_AddCombatantSource.dnd5e);
    }
    if (_selected.isEmpty) {
      _selected.add(_AddCombatantSource.group);
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
          SegmentedButton<_AddCombatantSource>(
            segments: [
              if (systemSettings.dnd5eSettings.enabled)
                ButtonSegment(
                  value: _AddCombatantSource.dnd5e,
                  label: Text(localization.dnd5e_toggle_button),
                  icon: Icon(LineAwesome.dragon_solid),
                ),
              if (systemSettings.pf2eSettings.enabled)
                ButtonSegment(
                  value: _AddCombatantSource.pf2e,
                  label: Text(localization.pf2e_toggle_button),
                  icon: Icon(LineAwesome.dragon_solid),
                ),
              ButtonSegment(
                value: _AddCombatantSource.group,
                label: Text(localization.groups_toggle_button),
                icon: Icon(LineAwesome.users_solid),
              ),
              ButtonSegment(
                value: _AddCombatantSource.custom,
                label: Text(localization.custom_combatant_toggle_button),
                icon: Icon(LineAwesome.edit_solid),
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
    if (_selected.contains(_AddCombatantSource.dnd5e)) {
      return AddFromBestiaryList(
        combatants: context.read<Dnd5eBestiaryService>().bestiaryData,
        onCombatantSelected: (combatant) async {
          widget.onCombatantsAdded({combatant: 1});
          await context.read<AnalyticsService>().logEvent('add_5e_combatant');
        },
      );
    }
    if (_selected.contains(_AddCombatantSource.pf2e)) {
      return AddFromBestiaryList(
        combatants: context.read<Pf2eBestiaryService>().bestiaryData,
        onCombatantSelected: (combatant) async {
          widget.onCombatantsAdded({combatant: 1});
          await context.read<AnalyticsService>().logEvent('add_pf2e_combatant');
        },
      );
    }
    if (_selected.contains(_AddCombatantSource.group)) {
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
      onCombatantAdded: (combatant) async {
        widget.onCombatantsAdded({combatant: 1});
        await context.read<AnalyticsService>().logEvent('add_custom_combatant');
      },
    );
  }
}
