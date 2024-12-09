import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/widgets/add_combatant.dart';
import 'package:battlemaster/features/combatant/widgets/selected_combatants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCombatantPageLandscape extends StatelessWidget {
  const AddCombatantPageLandscape({
    super.key,
    required this.onCombatantsAdded,
    this.showGroupReminder = false,
    this.combatants = const {},
  });

  final bool showGroupReminder;
  final ValueChanged<Map<Combatant, int>> onCombatantsAdded;
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
                  onCombatantsChanged: onCombatantsAdded,
                ),
              ),
              Row(
                children: [
                  Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(localization.cancel_button),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(combatants);
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
