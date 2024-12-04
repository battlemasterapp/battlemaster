import 'package:battlemaster/common/fonts/action_font.dart';
import 'package:battlemaster/extensions/int_extensions.dart';
import 'package:battlemaster/extensions/string_extension.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_attack.dart';
import 'package:battlemaster/features/combatant/models/pf2e_combatant_data/pf2e_combatant_data.dart';
import 'package:battlemaster/features/combatant/widgets/combatant_details/basic_ability.dart';
import 'package:battlemaster/features/combatant/widgets/traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Pf2eCombatantDetails extends StatelessWidget {
  const Pf2eCombatantDetails({
    super.key,
    required this.combatant,
  });

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    // FIXME: spacing
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Traits(traits: combatant.traits),
        Text('Creature ${combatant.level}'),
        _Perception(combatant),
        if (combatant.languages.isNotEmpty)
          BasicAbility(
            boldText: "Languages: ",
            text: combatant.languages.join(', '),
          ),
        if (combatant.skills.isNotEmpty)
          BasicAbility(
            boldText: "Skills ",
            text: combatant.skills.join(', '),
          ),
        _Abilities(combatant),
        if (combatant.items.isNotEmpty)
          BasicAbility(
            boldText: 'Items: ',
            text: combatant.items.join(', '),
          ),
        const Divider(),
        _Defenses(combatant),
        _Health(combatant),
        const Divider(),
        BasicAbility(
          boldText: 'Speed ',
          text: "${combatant.baseSpeed} feet",
        ),
        _Attacks(combatant),
        const Divider(),
        _RecallKnowledge(combatant),
      ],
    );
  }
}

class _Perception extends StatelessWidget {
  const _Perception(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    final otherSenses = combatant.otherSenses;
    if (otherSenses.isNotEmpty) {
      return BasicAbility(
        boldText: 'Perception: ',
        text: '${combatant.perception.signString}, ${otherSenses.join(', ')}',
      );
    }
    return BasicAbility(
      boldText: 'Perception',
      text: combatant.perception.signString,
    );
  }
}

class _Abilities extends StatelessWidget {
  const _Abilities(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final attributes = {
      localization.str_short: combatant.strength,
      localization.dex_short: combatant.dexterity,
      localization.con_short: combatant.constitution,
      localization.int_short: combatant.intelligence,
      localization.wis_short: combatant.wisdom,
      localization.cha_short: combatant.charisma,
    };
    return Wrap(
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 4,
      direction: Axis.horizontal,
      children: [
        for (final entry in attributes.entries) ...[
          Text(
            entry.key.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(entry.value.modifier.signString),
        ],
      ],
    );
  }
}

class _Defenses extends StatelessWidget {
  const _Defenses(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    return Row(
      children: [
        BasicAbility(
          boldText: 'AC ',
          text: combatant.ac.toString(),
        ),
        const SizedBox(width: 8),
        BasicAbility(
          boldText: 'Fort ',
          text: combatant.fortitude.signString,
        ),
        const SizedBox(width: 8),
        BasicAbility(
          boldText: 'Ref ',
          text: combatant.reflex.signString,
        ),
        const SizedBox(width: 8),
        BasicAbility(
          boldText: 'Will ',
          text: combatant.will.signString,
        ),
      ],
    );
  }
}

class _Health extends StatelessWidget {
  const _Health(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    final hpDetails =
        combatant.hpDetails.isNotEmpty ? " (${combatant.hpDetails})" : "";
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: 'HP ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '${combatant.hp}$hpDetails;'),
          if (combatant.immunities.isNotEmpty) ...[
            TextSpan(
              text: ' Immunities ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "${(combatant.immunities..sort()).join(', ')};",
            ),
          ],
          if (combatant.resistances.isNotEmpty) ...[
            TextSpan(
              text: ' Resistances ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: "${combatant.resistances.join(', ')};",
            ),
          ],
        ],
      ),
    );
  }
}

class _Attacks extends StatelessWidget {
  const _Attacks(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    if (combatant.attacks.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        for (final attack in combatant.attacks) _Attack(attack),
      ],
    );
  }
}

class _Attack extends StatelessWidget {
  const _Attack(this.attack);

  final Pf2eAttack attack;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: "${attack.range.capitalize()} ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          getAction(),
          TextSpan(text: "${attack.name} "),
          TextSpan(text: "${attack.modifier.signString} "),
          TextSpan(text: "[${attack.map.map((i) => i.signString).join("/")}] "),
          if (attack.traits.isNotEmpty)
            TextSpan(
                text:
                    "(${attack.traits.join(", ").capitalizeAll().replaceAll("-", " ")}) "),
          if (attack.damage != null) ...[
            const TextSpan(
              text: "Damage ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: "${attack.damage} "),
          ],
          if (attack.effects.isNotEmpty) ...[
            const TextSpan(
              text: "Effects ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
                text: attack.effects
                    .join(", ")
                    .replaceAll("-", " ")
                    .capitalizeAll()),
          ],
          // TextSpan(text: attack.entry.toString()),
        ],
      ),
    );
  }

  TextSpan getAction() {
    return TextSpan(
      text: "${actionToString(ActionsEnum.one)} ",
      style: const TextStyle(fontFamily: "ActionIcons"),
    );
  }
}

class _RecallKnowledge extends StatelessWidget {
  const _RecallKnowledge(this.combatant);

  final Pf2eCombatantData combatant;

  @override
  Widget build(BuildContext context) {
    // FIXME: textos
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text:
                "Recall Knowledge (${combatant.recallKnowledge.skills.join(', ')}): ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: "DC ${combatant.recallKnowledge.dc}",
          ),
        ],
      ),
    );
  }
}
