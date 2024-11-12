import 'package:battlemaster/features/combatant/models/combatant_type.dart';
import 'package:battlemaster/features/combatant/widgets/combatant_details/basic_ability.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/combatant.dart';

class CustomCombatantDetails extends StatelessWidget {
  const CustomCombatantDetails({
    super.key,
    required this.combatant,
  });

  final Combatant combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CombatantType(combatant: combatant),
        BasicAbility(
          boldText: '${localization.hit_points} ',
          text: combatant.maxHp.toString(),
        ),
        BasicAbility(
          boldText: '${localization.armor_class} ',
          text: combatant.armorClass.toString(),
        ),
      ],
    );
  }
}

class _CombatantType extends StatelessWidget {
  const _CombatantType({required this.combatant});

  final Combatant combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final typeNames = {
      CombatantType.monster: localization.combatant_type_monster,
      CombatantType.player: localization.combatant_type_player,
      CombatantType.hazard: localization.combatant_type_hazard,
      CombatantType.lair: localization.combatant_type_lair,
    };
    return Text(typeNames[combatant.type]!);
  }
}
