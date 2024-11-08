import 'package:battlemaster/features/combatant/models/combatant.dart';
import 'package:battlemaster/features/engines/models/game_engine_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        _CombatantGameEngine(engineType: combatant.engineType),
        if (combatant.combatantData != null &&
            combatant.combatantData is Dnd5eCombatantData)
          Dnd5eCombatantDetails(
            combatant: combatant.combatantData as Dnd5eCombatantData,
          ),
      ],
    );
  }
}

class _CombatantGameEngine extends StatelessWidget {
  const _CombatantGameEngine({required this.engineType});

  final GameEngineType engineType;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final engineNameMap = {
      GameEngineType.dnd5e: localization.dnd5e_engine_name,
      GameEngineType.pf2e: localization.pf2e_engine_name,
      GameEngineType.custom: localization.custom_engine_name,
    };

    return Text(engineNameMap[engineType] ?? "");
  }
}
