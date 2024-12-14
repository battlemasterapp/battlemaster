import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_combatant_data.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_template.dart';
import 'package:battlemaster/features/combatant/widgets/combatant_details/pf2e_combatant_details.dart';
import 'package:battlemaster/features/conditions/models/condition.dart';
import 'package:battlemaster/features/conditions/widgets/add_condition_button.dart';
import 'package:battlemaster/features/encounter_tracker/providers/encounter_tracker_notifier.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../models/dnd5e_combatant_data.dart';
import 'custom_combatant_details.dart';
import 'dnd5e_combatant_details.dart';

class CombatantDetails extends StatelessWidget {
  const CombatantDetails({
    super.key,
    required this.combatant,
    this.onConditionsAdded,
  });

  final Combatant combatant;
  final ValueChanged<List<Condition>>? onConditionsAdded;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.black),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getName(context),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                ),
          ),
          const SizedBox(height: 4),
          AddConditionButton(
            conditions: combatant.conditions,
            onConditionsAdded: (conditions) =>
                onConditionsAdded?.call(conditions),
            engine: combatant.engineType,
          ),
          const SizedBox(height: 8),
          if (combatant.engineType == GameEngineType.custom)
            CustomCombatantDetails(combatant: combatant),
          if (combatant.combatantData != null &&
              combatant.combatantData is Dnd5eCombatantData)
            Dnd5eCombatantDetails(
              combatant: combatant.combatantData as Dnd5eCombatantData,
            ),
          if (combatant.combatantData != null &&
              combatant.combatantData is Pf2eCombatantData)
            Pf2eCombatantDetails(
              combatant: combatant.combatantData as Pf2eCombatantData,
              onDataChanged: (combatantData) async {
                final encounterState = context.read<EncounterTrackerNotifier>();
                await encounterState.updateCombatantData(
                    combatant, combatantData);
              },
            )
        ],
      ),
    );
  }

  String getName(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    if (combatant.combatantData == null) {
      return combatant.name;
    }

    if (combatant.engineType == GameEngineType.pf2e) {
      return '${(combatant.combatantData as Pf2eCombatantData).template.translate(localization)} ${combatant.name}'
          .trim();
    }

    return combatant.name;
  }
}
