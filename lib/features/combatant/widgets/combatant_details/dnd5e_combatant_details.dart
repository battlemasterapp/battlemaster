import 'package:battlemaster/features/combatant/models/dnd5e_combatant_data.dart';
import 'package:battlemaster/features/combatant/widgets/combatant_details/basic_ability.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Dnd5eCombatantDetails extends StatelessWidget {
  const Dnd5eCombatantDetails({
    super.key,
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CombatantType(combatant: combatant),
        const Divider(),
        BasicAbility(
          boldText: "${localization.armor_class} ",
          text: combatant.ac.toString(),
        ),
        BasicAbility(
          boldText: '${localization.hit_points} ',
          text: combatant.hp.toString(),
        ),
        _CombatantSpeed(combatant: combatant),
        const Divider(),
      ],
    );
  }
}

class _CombatantType extends StatelessWidget {
  const _CombatantType({
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final texts = [
      combatant.size,
      combatant.type,
      if (combatant.subtype.isNotEmpty) "(${combatant.subtype})",
    ].nonNulls.toList().join(" ");
    return Text("$texts, ${combatant.alignment}");
  }
}

class _CombatantSpeed extends StatelessWidget {
  const _CombatantSpeed({
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final baseSpeed = combatant.speed.walk;
    final speeds = [
      localization.speed_ft(baseSpeed),
      if (combatant.speed.fly > 0)
        localization.fly_speed_ft(combatant.speed.fly),
      if (combatant.speed.swim > 0)
        localization.swim_speed_ft(combatant.speed.swim),
      if (combatant.speed.burrow > 0)
        localization.burrow_speed_ft(combatant.speed.burrow),
      if (combatant.speed.climb > 0)
        localization.climb_speed_ft(combatant.speed.climb),
    ].join(", ");
    return BasicAbility(boldText: '${localization.speed_label} ', text: speeds);
  }
}
