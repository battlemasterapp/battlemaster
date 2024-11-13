import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/widgets/add_combatant.dart';
import 'package:battlemaster/features/combatant/widgets/selected_combatants_sheet.dart';
import 'package:flutter/material.dart';

class AddCombatantsPortraitPage extends StatelessWidget {
  const AddCombatantsPortraitPage({
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
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: AddCombatant(
            showGroupReminder: showGroupReminder,
            onCombatantsAdded: onCombatantsAdded,
          ),
        ),
        SelectedCombatantsBottomSheet(
          combatants: combatants,
          onCombatantsChanged: onCombatantsChanged,
        ),
      ],
    );
  }
}
