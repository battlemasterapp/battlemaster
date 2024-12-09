import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/widgets/add_combatant.dart';
import 'package:battlemaster/features/combatant/widgets/selected_combatants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class AddCombatantPageLandscape extends StatelessWidget {
  const AddCombatantPageLandscape({
    super.key,
    required this.onCombatantsAdded,
    required this.onCombatantsChanged,
    this.showGroupReminder = false,
    this.combatants = const {},
  });

  final bool showGroupReminder;
  final ValueChanged<Map<Combatant, int>> onCombatantsAdded;
  final ValueChanged<Map<Combatant, int>> onCombatantsChanged;
  final Map<Combatant, int> combatants;

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: AddCombatant(
            showGroupReminder: showGroupReminder,
            onCombatantsAdded: onCombatantsAdded,
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: SelectedCombatants(
                  combatants: combatants,
                  onCombatantsChanged: onCombatantsChanged,
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(localization.cancel_button),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.pop(combatants);
                    },
                    child: Text(localization.save_button),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}
