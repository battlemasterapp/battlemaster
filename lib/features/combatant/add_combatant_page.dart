import 'package:battlemaster/features/combatant/widgets/add_custom_combatant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:icons_plus/icons_plus.dart';

import 'models/combatant.dart';
import 'widgets/add_group_combatants.dart';
import 'widgets/selected_combatants.dart';

class AddCombatantPage extends StatefulWidget {
  const AddCombatantPage({super.key});

  @override
  State<AddCombatantPage> createState() => _AddCombatantPageState();
}

class _AddCombatantPageState extends State<AddCombatantPage> {
  final Map<Combatant, int> _combatants = {};

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
                  Expanded(child: SelectedCombatants(combatants: _combatants)),
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
                        child: Text(AppLocalizations.of(context)!
                            .add_combatants_button),
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
  Set<_AddCombatantSource> _selected = {_AddCombatantSource.group};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SegmentedButton<_AddCombatantSource>(
            segments: [
              ButtonSegment(
                value: _AddCombatantSource.group,
                label: Text(AppLocalizations.of(context)!.groups_toggle_button),
                icon: Icon(LineAwesome.users_solid),
              ),
              ButtonSegment(
                value: _AddCombatantSource.custom,
                label: Text(AppLocalizations.of(context)!
                    .custom_combatant_toggle_button),
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
    if (_selected.contains(_AddCombatantSource.group)) {
      return AddGroupCombatants(
        onGroupSelected: (combatants) {
          widget.onCombatantsAdded(
            combatants.fold<Map<Combatant, int>>(
              {},
              (map, combatant) {
                map[combatant] = 1;
                return map;
              },
            ),
          );
        },
      );
    } else {
      return AddCustomCombatant();
    }
  }
}
