import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:flutter/material.dart';

import '../../models/dnd5e_combatant_data.dart';
import 'dnd5e_combatant_details.dart';

class CombatantDetails extends StatelessWidget {
  const CombatantDetails({
    super.key,
    required this.combatant,
  });

  final Combatant combatant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          combatant.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.black,
              ),
        ),
        if (combatant.combatantData != null &&
            combatant.combatantData is Dnd5eCombatantData)
          Dnd5eCombatantDetails(
            combatant: combatant.combatantData as Dnd5eCombatantData,
          ),
      ],
    );
  }
}
