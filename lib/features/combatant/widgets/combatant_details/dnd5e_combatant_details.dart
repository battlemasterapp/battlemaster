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
        _SpecialAbilities(combatant: combatant),
        _Actions(combatant: combatant),
        _Reactions(combatant: combatant),
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

class _SpecialAbilities extends StatelessWidget {
  const _SpecialAbilities({
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final specialAbilities = combatant.specialAbilities;
    if (specialAbilities.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final ability in specialAbilities)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: BasicAbility(
              boldText: "${ability.name} ",
              text: ability.desc,
            ),
          ),
        const Divider(),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final actions = combatant.actions;
    final localization = AppLocalizations.of(context)!;
    if (actions.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.dnd5e_actions,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.black),
        ),
        for (final action in actions)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: BasicAbility(
              boldText: "${action.name} ",
              text: action.desc,
            ),
          ),
        const Divider(),
      ],
    );
  }
}

class _Reactions extends StatelessWidget {
  const _Reactions({
    required this.combatant,
  });

  final Dnd5eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final reactions = combatant.reactions;
    final localization = AppLocalizations.of(context)!;
    if (reactions.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.dnd5e_reactions,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.black),
        ),
        for (final reaction in reactions)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: BasicAbility(
              boldText: "${reaction.name} ",
              text: reaction.desc,
            ),
          ),
        const Divider(),
      ],
    );
  }
}
